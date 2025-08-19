// p1_syscalls_test.c — Prueba de syscalls: waitx, setgroup, getgroup
// Uso: p1_syscalls_test [nA] [nB] [mode]
//   nA: número de hijos en grupo 1 (default 1)
//   nB: número de hijos en grupo 2 (default 1)
//   mode: "cpu" (default) o "mixed" (grupo 2 hace I/O simulada)

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

struct msg {
  int pid;
  int gid;
};

static int streq(const char *a, const char *b) {
  while (*a && *b && *a == *b) { a++; b++; }
  return *a == 0 && *b == 0;
}

static void busy_loop(int iters) {
  volatile int x = 0;
  for (int i = 0; i < iters; i++) x += i;
  if (x == 42) printf(1, ""); // evita optimización tonta
}

static void child_work(int gid, int is_io, int wfd) {
  // 1) fijar grupo a sí mismo
  int me = getpid();
  if (setgroup(me, gid) < 0) {
    printf(1, "child %d: setgroup(%d) fallo\n", me, gid);
    exit();
  }

  // 2) avisar al padre mi pid/gid
  struct msg m; m.pid = me; m.gid = gid;
  if (write(wfd, &m, sizeof(m)) != sizeof(m)) {
    // si falla, igual continúo; el padre quizá no podrá mapear gid
  }

  // 3) trabajo: CPU o "I/O" (sleep)
  if (!is_io) {
    // CPU-bound: ~unos cuantos ms/ticks (ajusta si quieres)
    for (int k = 0; k < 200; k++) busy_loop(50000);
  } else {
    // I/O-bound: alternar pequeños bursts de CPU con sleeps
    for (int s = 0; s < 120; s++) {
      busy_loop(3000);
      sleep(1);
    }
  }

  exit();
}

int
main(int argc, char *argv[])
{
  int nA = 1, nB = 1;
  int is_mixed = 0; // si 1 => grupo 2 hace "I/O"

  if (argc >= 2) nA = atoi(argv[1]);
  if (argc >= 3) nB = atoi(argv[2]);
  if (argc >= 4 && (streq(argv[3], "mixed") || streq(argv[3], "io")))
    is_mixed = 1;

  int p[2];
  if (pipe(p) < 0) {
    printf(1, "pipe failed\n");
    exit();
  }
  int rfd = p[0], wfd = p[1];

  // Lanzar hijos de grupo 1 (CPU)
  for (int i = 0; i < nA; i++) {
    int pid = fork();
    if (pid < 0) {
      printf(1, "fork failed (A)\n");
      exit();
    }
    if (pid == 0) {
      close(rfd);
      child_work(/*gid=*/1, /*is_io=*/0, wfd);
      // no retorna
    }
  }

  // Lanzar hijos de grupo 2 (CPU o I/O según modo)
  for (int i = 0; i < nB; i++) {
    int pid = fork();
    if (pid < 0) {
      printf(1, "fork failed (B)\n");
      exit();
    }
    if (pid == 0) {
      close(rfd);
      child_work(/*gid=*/2, /*is_io=*/is_mixed, wfd);
      // no retorna
    }
  }

  // Padre: cerramos escritura, leemos los (pid,gid) anunciados por los hijos
  close(wfd);

  int total = nA + nB;
  struct msg *table = (struct msg*) malloc(sizeof(struct msg) * total);
  int recvd = 0;
  while (recvd < total) {
    int n = read(rfd, (char*)&table[recvd], sizeof(struct msg));
    if (n == sizeof(struct msg)) {
      recvd++;
    } else if (n == 0) {
      // no más datos; puede pasar si algún hijo murió antes de escribir
      break;
    }
  }
  close(rfd);

  // Helper para mapear pid->gid
  int lookup_gid(int pid) {
    for (int i = 0; i < recvd; i++) {
      if (table[i].pid == pid) return table[i].gid;
    }
    // Si no llegó por pipe, intentar getgroup antes de recolectar (no aplica aquí)
    return -1;
  }

  // (Opcional) Verificar getgroup() en caliente (antes de waitx)
  // Nota: tras waitx, el proceso ya no existe y getgroup(pid) devolverá -1.
  // Aquí hacemos una pasada best-effort: si ya no están, no es error fatal.
  for (int i = 0; i < recvd; i++) {
    int g = getgroup(table[i].pid);
    if (g >= 0 && g != table[i].gid) {
      printf(1, "WARN: getgroup(%d)=%d difiere de pipe=%d\n",
             table[i].pid, g, table[i].gid);
    }
  }

  // Recolectar con waitx y mostrar resultados
  printf(1, "pid\tgid\trtime\twtime\n");
  int w = 0, r = 0, pid;
  int collected = 0;
  while ((pid = waitx(&w, &r)) > 0) {
    int gid = lookup_gid(pid);
    printf(1, "%d\t%d\t%d\t%d\n", pid, gid, r, w);
    collected++;
    if (collected >= total) break;
  }

  free(table);

  // Termina
  exit();
}
