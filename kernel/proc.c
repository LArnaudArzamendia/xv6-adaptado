#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

struct group gtable[NGROUPS]; // table of process groups

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
  fss_init_groups();
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  p->gid = 0;
  fss_group_ensure(p->gid);

  p->rtime = 0;
  p->wtime = 0;
  p->stime = 0;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // Asegurar grupo 0 y que el grupo existe.
  p->gid = 0;
  fss_group_ensure(0);

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  np->gid = curproc->gid; // inherit group ID
  fss_group_ensure(np->gid);
  
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

int
waitx(int *wtime, int *rtime)
{
  struct proc *p;
  int havekids, pid;

  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Keep times before releasing ptable.lock
        if(wtime) *wtime = p->wtime;
        if(rtime) *rtime = p->rtime;

        // === same as in wait(): free child's resources ===
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->rtime = p->wtime = p->stime = 0; // cleanup counters
        release(&ptable.lock);
        return pid;
      }
    }

    // No children left.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait until something changes.
    sleep(curproc, &ptable.lock);
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    acquire(&ptable.lock);
    // Elegir grupo con menor pass que tenga RUNNABLEs.
    struct group *g = fss_pick_group();
    if(g == 0){
      // No hay nada listo ahora.
      release(&ptable.lock);
      continue;
    }

    // RR dentro del grupo.
    struct proc *p = fss_pick_proc_in_group(g);
    if(p == 0){
      // Grupo sin procesos RUNNABLE.
      release(&ptable.lock);
      continue;
    }

    // Despacho.
    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;

    swtch(&c->scheduler, p->context);
    switchkvm();

    // Limpiar puntero CPU-proceso.
    c->proc = 0;

    // Incrementar pass del grupo que corrió.
    g->pass += g->stride;
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// Cuenta 1 tick a cada proceso según su estado.
// Llamar en el handler de timer (trap.c) para cada tick.
void
tick_accounting(void)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    switch(p->state){
    case RUNNING:
      p->rtime++;
      break;
    case RUNNABLE:
      p->wtime++;
      break;
    case SLEEPING:
      p->stime++;
      break;
    default:
      break;
    }
  }
  release(&ptable.lock);
}

int
getgroup_k(int pid)
{
  struct proc *p;
  int gid = -1;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid && p->state != UNUSED){
      gid = p->gid;
      break;
    }
  }
  release(&ptable.lock);
  return gid;
}

int
setgroup_k(int pid, int gid)
{
  if(gid < 0) return -1;

  acquire(&ptable.lock);
  struct group *g = fss_group_ensure(gid);
  if(g == 0){ release(&ptable.lock); return -1; }

  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid && p->state != UNUSED){
      p->gid = gid;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

static void
fss_init_groups(void) // Inicializar tabla de grupos.
{
  for(int i = 0; i < NGROUPS; i++){
    gtable[i].gid = 0;
    gtable[i].active = 0;
    gtable[i].pass = 0;
    gtable[i].stride = FSS_BIG; // share=1
    gtable[i].rr_cursor = 0;
  }

  // Initialize the default group (gid=0)
  gtable[0].gid = 0;
  gtable[0].active = 1;
  gtable[0].pass = 0;
  gtable[0].stride = FSS_BIG;
  gtable[0].rr_cursor = 0;
}

static struct group*
fss_group_lookup(int gid) // Buscar un grupo activo por su gid.
{
  for(int i = 0; i < NGROUPS; i++){
    if(gtable[i].active && gtable[i].gid == gid) return &gtable[i];
  }
  return 0;
}

// Ensure that a group with the given gid exists in gtable.
// If the group already exists, return a pointer to it.
// Otherwise, allocate a new slot in gtable for the group,
// initialize its fields (active=1, pass=0, stride=FSS_BIG, rr_cursor=0),
// and return a pointer to the new group.
// If no free slot is available, return 0.
// Called with ptable.lock held, so it can safely modify gtable.
static struct group*
fss_group_ensure(int gid) // Asegurar que un grupo con gid existe.
{
  struct group *g = fss_group_lookup(gid);
  if(g) return g;
  for(int i = 0; i < NGROUPS; i++){
    if(!gtable[i].active){
      gtable[i].active = 1;
      gtable[i].gid = gid;
      gtable[i].pass = 0;
      gtable[i].stride = FSS_BIG; // share = 1 (todas iguales)
      gtable[i].rr_cursor = 0;
      return &gtable[i];
    }
  }
  return 0; // no slots: unlikely in this implementation
}

// Does the group g have at least one RUNNABLE process?
// Called with ptable.lock held.
// Return 1 if at least one process in group g is RUNNABLE, else 0.
static int
fss_group_has_runnable(struct group *g) // Verificar si el grupo tiene procesos RUNNABLE.
{
  // TODO: iterate over ptable.proc[]
  for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    // TODO: check if p->state == RUNNABLE and p->gid == g->gid
    if(p->state == RUNNABLE && p->gid == g->gid) {
      // TODO: return 1 if such process is found
      return 1;
    }
  }
  // Otherwise, return 0
  return 0;
}

// Pick the group with the lowest pass value
// that has at least one RUNNABLE process.
// If no such group exists, return 0.
// This function is used by the scheduler to select a group.
// It is called with ptable.lock held, so it can safely
// access gtable[] and ptable.proc[].
static struct group*
fss_pick_group(void)
{
  // TODO: initialize a pointer to best group (e.g., NULL)
  struct group *best = 0;
  // TODO: iterate over all groups in gtable[]
  for(int i = 0; i < NGROUPS; i++) {
    if(!gtable[i].active) continue; // skip if group is not active.
    struct group *g = &gtable[i];
    if(!fss_group_has_runnable(g)) continue; // skip if no RUNNABLE processes.
    if(best == 0 || g->pass < best->pass || (g->pass == best->pass && g->gid < best->gid)) { // track the group with the smallest pass value
      best = g; // found a better group with lower pass value.
    }
  }
  // TODO: return pointer to best group found, or 0 if none
  return best;
}

// Pick a RUNNABLE process from group g using round-robin.
// Called with ptable.lock held.
// Returns a pointer to the selected process, or 0 if none is found.
// Updates g->rr_cursor to remember the last scheduling position.
static struct proc*
fss_pick_proc_in_group(struct group *g)
{
  if(!g) return 0;// Ver si no hay grupo de primeras.
  // TODO: use g->rr_cursor as a rotating index into ptable.proc[]
  int start = g->rr_cursor % NPROC; // % NPROC para el overflow.
  // TODO: perform one pass from rr_cursor to end of table

  // TODO: if no candidate found, wrap around and try from 0 to rr_cursor-1
  for(int j = 0; j < NPROC; j++) {
    int i = (start + j) % NPROC;
    struct proc *p = &ptable.proc[i];
    // TODO: check condition: p->state == RUNNABLE && p->gid == g->gid
    if(p->state == RUNNABLE && p->gid == g->gid) {
      // TODO: if found, update g->rr_cursor and return process pointer
      g->rr_cursor = (i + 1) % NPROC; // Siguiente punto de partida.
      return p;
    }
  }
  // TODO: return 0 if no RUNNABLE process in group
  return 0;
}
