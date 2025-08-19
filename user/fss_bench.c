// user/fss_bench.c  (xv6 x86)
// Fair Share Scheduling benchmark for two groups (gid=1, gid=2).
// Modes: cpu | io | mixed | move
//   cpu   : all children CPU-bound
//   io    : all children IO-bound
//   mixed : half cpu-bound, half io-bound within each group
//   move  : one child from A migrates A->B at mid duration
//
// Usage:
///  fss_bench <duration_ticks> <nA> <nB> [mode] [tol_share%] [tol_perproc%] [staggerB_ticks]
//
// Exit codes: 0 PASS, 1 FAIL, 2 invalid usage.
//
// Requires syscalls added:
//   int waitx(int *wtime, int *rtime);
//   int setgroup(int pid, int gid);

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define MAXKIDS 128

struct pid_gid { int pid; int gid; };
static struct pid_gid map_pg[MAXKIDS];
static int map_count = 0;

static int abs_i(int x) { return x < 0 ? -x : x; }

static int find_gid(int pid) {
  int i;
  for (i = 0; i < map_count; i++) if (map_pg[i].pid == pid) return map_pg[i].gid;
  return -1;
}

static int verbose = 1;

static int streq(const char *a, const char *b) {
  while (*a && *b && *a == *b) { a++; b++; }
  return *a == 0 && *b == 0;
}

//static int streq(const char *a, const char *b) { return strcmp(a, b) == 0; }

static void cpu_bound_worker(int duration) {
  int start = uptime();
  volatile unsigned x = 1u;
  while (uptime() - start < duration) {
    int i;
    for (i = 0; i < 100000; i++)
      x = x * 1664525u + 1013904223u;
  }
  if (x == 42u) write(1, "", 0); // keep compiler calm
  exit();
}

static void io_bound_worker(int duration) {
  int start = uptime();
  while (uptime() - start < duration) {
    sleep(10);
    if (verbose) write(1, ".", 1);
  }
  exit();
}

static void move_then_cpu_worker(int duration, int new_gid) {
  int start = uptime();
  int half = duration / 2;
  int migrated = 0;
  volatile unsigned x = 1u;

  for (;;) {
    int elapsed = uptime() - start;
    if (!migrated && elapsed >= half) {
      setgroup(getpid(), new_gid);
      migrated = 1;
    }
    if (elapsed >= duration) break;

    int i;
    for (i = 0; i < 100000; i++)
      x = x * 1664525u + 1013904223u;
  }
  if (x == 43u) write(1, "", 0);
  exit();
}

int
main(int argc, char **argv)
{
  if (argc < 4) {
    printf(1, "usage: fss_bench <duration_ticks> <nA> <nB> [mode] [tol_share%%] [tol_perproc%%]\n");
    printf(1, "defaults: mode=cpu, tol_share=10, tol_perproc=20\n");
    exit();
  }

  int duration = atoi(argv[1]);
  int nA = atoi(argv[2]);
  int nB = atoi(argv[3]);
  char *mode = (argc >= 5) ? argv[4] : "cpu";
  int tol_share = (argc >= 6) ? atoi(argv[5]) : 10;
  int tol_perproc = (argc >= 7) ? atoi(argv[6]) : 20;
  int staggerB = (argc >= 8) ? atoi(argv[7]) : 0;

  if (argc >= 9 && (streq(argv[8], "-q") || streq(argv[8], "quiet") || streq(argv[8], "0"))) {
    verbose = 0;
  }

  if (duration <= 0 || nA < 0 || nB < 0 || (nA + nB) <= 0 || (nA + nB) > MAXKIDS) {
    printf(1, "fss_bench: invalid args (duration>0, 0<=nA+nB<=%d)\n", MAXKIDS);
    exit();
  }

  int fd[2];
  if (pipe(fd) < 0) {
    printf(1, "fss_bench: pipe failed\n");
    exit();
  }

  // Launch group A (gid=1)
  int i;
  for (i = 0; i < nA; i++) {
    int pid = fork();
    if (pid < 0) { printf(1, "fss_bench: fork A failed\n"); exit(); }
    if (pid == 0) {
      close(fd[0]);
      setgroup(getpid(), 1);
      struct pid_gid msg; msg.pid = getpid(); msg.gid = 1;
      write(fd[1], &msg, sizeof(msg));
      if (streq(mode, "io")) io_bound_worker(duration);
      else if (streq(mode, "mixed")) ((i % 2) == 0) ? cpu_bound_worker(duration) : io_bound_worker(duration);
      else if (streq(mode, "move") && i == 0) move_then_cpu_worker(duration, 2);
      else cpu_bound_worker(duration);
    }
  }

  // Launch group B (gid=2)
  for (i = 0; i < nB; i++) {
    int pid = fork();
    if (pid < 0) { printf(1, "fss_bench: fork B failed\n"); exit(); }
    if (pid == 0) {
      close(fd[0]);

      if (staggerB > 0) {
        sleep(i * staggerB);
      }

      setgroup(getpid(), 2);
      struct pid_gid msg; msg.pid = getpid(); msg.gid = 2;
      write(fd[1], &msg, sizeof(msg));

      if (streq(mode, "io")) {
        io_bound_worker(duration);
      } else if (streq(mode, "mixed")) {
        ((i % 2) == 0) ? cpu_bound_worker(duration) : io_bound_worker(duration);
      } else {
        cpu_bound_worker(duration);
      }
    }
  }

  // Parent: build pid->gid map
  close(fd[1]);
  for (i = 0; i < (nA + nB); i++) {
    struct pid_gid msg;
    int r = read(fd[0], &msg, sizeof(msg));
    if (r != sizeof(msg)) { printf(1, "fss_bench: pipe read failed (%d)\n", r); exit(); }
    map_pg[map_count++] = msg;
  }
  close(fd[0]);

  // Collect results with waitx
  int ga_r = 0, gb_r = 0, ga_w = 0, gb_w = 0;

  printf(1, "pid\tgid\trtime\twtime\n");
  for (i = 0; i < (nA + nB); i++) {
    int wtime = 0, rtime = 0;
    int pid = waitx(&wtime, &rtime);
    int gid = find_gid(pid);
    printf(1, "%d\t%d\t%d\t%d\n", pid, gid, rtime, wtime);
    if (gid == 1) { ga_r += rtime; ga_w += wtime; }
    else if (gid == 2) { gb_r += rtime; gb_w += wtime; }
  }

  int total_r = ga_r + gb_r;
  printf(1, "\nGROUP A (gid=1) CPU total rtime: %d\n", ga_r);
  printf(1, "GROUP B (gid=2) CPU total rtime: %d\n", gb_r);
  if (total_r == 0) {
    printf(1, "No CPU time recorded; duration too short?\n");
    printf(1, "\nRESULT: FAIL\n");
    exit(); // return 0 in xv6; we'll treat as fail by message
  }
  int pa = (ga_r * 100) / total_r;
  int pb = 100 - pa;
  printf(1, "CPU share A/B: %d%% / %d%%  (tolerance_share=%d%%)\n", pa, pb, tol_share);

  int pass_share = (abs_i(pa - 50) <= tol_share) && (abs_i(pb - 50) <= tol_share);

  // Secondary per-proc check for Case 1: nA==1, cpu-mode, nB>=2 (not needed in move)
  int pass_perproc = 1;
  if (nA == 1 && nB >= 2 && streq(mode, "cpu")) {
    int a_proc = ga_r;                // only 1 process in A
    int b_avg  = (nB > 0) ? (gb_r / nB) : 0;
    if (a_proc > 0) {
      int num = b_avg * nB;           // ≈ a_proc
      int diff_pct = (abs_i(num - a_proc) * 100) / a_proc;
      pass_perproc = (diff_pct <= tol_perproc);
      printf(1, "Per-process check: B_avg ≈ A/ nB; diff=%d%% (tol=%d%%)\n", diff_pct, tol_perproc);
    }
  }

  int pass = pass_share && pass_perproc;
  printf(1, "\nRESULT: %s\n", pass ? "PASS" : "FAIL");
  exit(); // xv6 doesn't use exit(code); success/fail seen in text
  return 0;
}
