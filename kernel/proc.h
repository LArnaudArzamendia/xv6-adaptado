// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];
  int gid;                     // Process group ID
  int rtime;                   // CPU running time (ticks in RUNNING)
  int wtime;                   // waiting/ready time (ticks in RUNNABLE)
  int stime;               // Process name (debugging)
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap

// --- Fair Share Scheduling (FSS) ---

#define NGROUPS 16
#define FSS_BIG 100000  // for stride scheduling, big enough to avoid overflow

struct group {
  int   gid;         // logical group ID
  int   active;      // 0 if used, 1 otherwise
  uint  pass;        // cummulative pass value (stride)
  uint  stride;      // FSS_BIG / share (if share=1 => all processes in group have same priority)
  int   rr_cursor;   // cursor for internal round-robin scheduling (last seen pid)
};

extern struct group gtable[NGROUPS];  // declared in proc.c

static void fss_init_groups(void);
static struct group* fss_group_lookup(int gid);
static struct group* fss_group_ensure(int gid);
static int fss_group_has_runnable(struct group *g);
static struct group* fss_pick_group(void);
static struct proc* fss_pick_proc_in_group(struct group *g);
