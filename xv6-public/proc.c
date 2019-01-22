#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

/*using queue structure to implement MLFQ*/
typedef struct CircularQueue *Queue;
struct CircularQueue{
    struct proc *proc[64]; //Max size
    int front;
    int rear;
    int qsize;
};

struct {
    struct spinlock lock;
    struct proc proc[NPROC];
} ptable;


static struct proc *initproc;


int nextpid = 1;
int boostflag = 0;
int m = 0;
int s = 0;
int noflag;

extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);
struct CircularQueue priority[3];

int lev; //checing current level
int totalShare;

void
pinit(void)
{
    initlock(&ptable.lock, "ptable");
}

int IsEmpty(Queue Q){
    return (Q->qsize == 0);
}

int IsFull(Queue Q){
    return (Q->qsize == 64);
}

struct proc *Dequeue(Queue Q){
    int tmp = Q->front;
    Q->front = ((Q->front)+1) % 64;
    Q->qsize--;
    return Q->proc[tmp];
}

void Enqueue(Queue Q, struct proc * X){
    Q->qsize++;
    Q->rear = (Q->rear+1)%64;
    Q->proc[Q->rear] = X;
}

void priorityBoost(){
    struct proc *p;
   // cprintf("do boosting\n");
    while(!IsEmpty(&priority[1])){//boosting priority[1]
        p = Dequeue(&priority[1]);
        Enqueue(&priority[0],p);
        p->level = 0;
        p->cnt = 5;
    }
    while(!IsEmpty(&priority[2])){//boosting priority[2]
        p = Dequeue(&priority[2]);
        Enqueue(&priority[0],p);
        p->level = 0;
        p->cnt = 5;
    }
}

void boostFlagOn() { //checking it is right time to boost
    boostflag = 1;
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

    //p->isThread = 0;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    //Enqueue jobs to priority[0], so level is 0 and cnt(ticks) is 5
    Enqueue(&priority[0], p);
    p->level = 0;
    p->cnt = 5;
    p->isStride = 0;
    noflag = 0;
    
    return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];
    
    int i;
    for(i=0;i<3;i++){//initialize queue
        priority[i].front = 0;
        priority[i].rear = -1;
        priority[i].qsize = 0;
    }
    totalShare = 0;

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
    sz = proc->sz;
    
    if(n > 0){
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if(n < 0){
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    proc->sz = sz;
    switchuvm(proc);
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
   // cprintf("fork enter\n");

    
    // Allocate process.
    if((np = allocproc()) == 0){
        return -1;
    }

    if(np->isThread == 1){
        //cprintf("isThread==1\n");
        if((np->pgdir = copyuvm(proc->parent->pgdir, proc->sz)) == 0){
            kfree(np->kstack);
            np->kstack = 0;
            np->state = UNUSED;
            return -1;
        }
        //cprintf("after copyuvm\n");
        np->isThread = 1;
       // np->isParent = 1;
        np->sz = proc->parent->sz;
        np->parent = proc->parent->parent;
        *np->tf = *proc->parent->tf;
        
        np->tf->eax = 0;

    
        for(i = 0; i < NOFILE; i++)
            if(proc->parent->ofile[i])
                np->ofile[i] = filedup(proc->parent->ofile[i]);
        np->cwd = idup(proc->parent->cwd);
        safestrcpy(np->name, proc->parent->name, sizeof(proc->parent->name));
        pid = np->pid;
        acquire(&ptable.lock);
        np->state = RUNNABLE;
        release(&ptable.lock);
    }

    else if (np->isThread == 0){
       //cprintf("isThread == 0\n");
       // Copy process state from p.
       if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
           kfree(np->kstack);
           np->kstack = 0;
           np->state = UNUSED;
           return -1;
       }
       //cprintf("after copyuvm in isThread == 0\n");
       np->isThread = 0;
       //np->isParent = 0;
       np->sz = proc->sz;
       np->parent = proc;
       *np->tf = *proc->tf;
      
        // Clear %eax so that fork returns 0 in the child.
        np->tf->eax = 0;

    
        for(i = 0; i < NOFILE; i++)
            if(proc->ofile[i])
                np->ofile[i] = filedup(proc->ofile[i]);
        np->cwd = idup(proc->cwd);
        safestrcpy(np->name, proc->name, sizeof(proc->name));
        pid = np->pid;
        acquire(&ptable.lock);
        np->state = RUNNABLE;
        release(&ptable.lock);

    
        
     }
     return pid;

    /*
    int i, pid;
    struct proc *np;
    
    // Allocate process.
    if((np = allocproc()) == 0){
        return -1;
    }
    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->isThread = 0;
    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;
    
    
    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
    
    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
    safestrcpy(np->name, proc->name, sizeof(proc->name));
    pid = np->pid;
    acquire(&ptable.lock);
    np->state = RUNNABLE;
    release(&ptable.lock);
    
    return pid;*/
    
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{   
    struct proc *p;
    int fd;
    if(proc->parent == initproc)
        panic("init exiting");

    //close all open files
    for(fd = 0; fd < NOFILE; fd++){
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    
    begin_op();
    iput(proc->cwd);
    end_op();
    proc->cwd = 0;
   
    //thread calls exit
    if(proc->tid > 0){
        acquire(&ptable.lock);
        wakeup1(proc->parent);
        for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){ //change threads' state
            if(p->parent == proc->parent && p->tid == -1){
                p->parent = initproc;
                if(p->state == ZOMBIE)
                    wakeup1(initproc);
            }
        }
        proc->parent->killed = 1;
    }
    else{
        
        acquire(&ptable.lock);
        wakeup1(proc->parent);
 
        for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
            if(p->parent == proc && p->tid >0){
                p->killed = 1;
                if(p->state == SLEEPING){
                    p->state = RUNNABLE;
                    continue;
                }
            }
            if(p->parent == proc && p->tid == -1){
                p->parent = initproc;
                if(p->state == ZOMBIE)
                    wakeup1(initproc);
            }
        }
    }
    proc->state = ZOMBIE;
   // cprintf("exit finish befor sched\n");
    sched();

    panic("zombie exit");
   
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{  // cprintf("wait enter\n");
    struct proc *p;
    int havekids, pid,i;
    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->parent != proc)
                continue;
            havekids = 1;
            if(p->state == ZOMBIE){
                if(p->tid > 0){
                    p->tid = 0;
                    deallocuvm(p->parent->pgdir, p->sz, p->sz-2*PGSIZE);
                    for(i=0;i<10;i++){
                        if(p->tarr[i] == 1){
                            p->tarr[i] = 0;
                            p->parent->tarr[i] = 0;
                            break;
                        }
                    }
                }
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
                //freevm(p->pgdir);
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
        if(!havekids || proc->killed){
            release(&ptable.lock);
            return -1;
        }
        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
       // cprintf("wait finish\n");
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

    struct proc *p;
    struct proc *minProc;

    totalShare = 0;
    noflag = 0;

    for(;;){

        sti();
        
        if(m >= 1000000) {
            m = 0; s = 0;
        }
        if((totalShare == 0 || m*totalShare <= s *(100-totalShare)) && noflag == 0){
          
     
            //cprintf("[[mlfq] m : [%d] s : [%d]]", m, s);
            // Enable interrupts on this processor.
            // Loop over process table looking for process to run.
            acquire(&ptable.lock);
            if(!IsEmpty(&priority[0])) {
                p = Dequeue(&priority[0]);
                if(p->state == RUNNABLE){// context switching
                    proc = p;
                    switchuvm(p);
                    p->state = RUNNING;
                    swtch(&cpu->scheduler, p->context);
                    switchkvm();
                    proc = 0;
                    if(p->isStride == 0) {
                    if(boostflag == 1) {
                        Enqueue(&priority[0], p);
                        priorityBoost();
                        boostflag = 0;
                        m+= 5;
                    } else if(p->state != SLEEPING) {
                        if(p->cnt <= 1){
                            Enqueue(&priority[1], p);
                            p->level = 1;
                            p->cnt = 10;
                            m+= 5;
                        } else {
                            //p->cnt--;
                            Enqueue(&priority[0], p);
                        }
                    }
                    }
                }
            }
            else if(!IsEmpty(&priority[1])) {
                p = Dequeue(&priority[1]);
                if(p->state == RUNNABLE){//context switching
                    proc = p;
                    switchuvm(p);
                    p->state = RUNNING;
                    swtch(&cpu->scheduler, p->context);
                    switchkvm();
                    proc = 0;
                    
                    if(p->isStride == 0) {
                    if(boostflag == 1) {
                        Enqueue(&priority[1], p);
                        priorityBoost();
                        boostflag = 0;
                        m+=10;
                    }
                    else if(p->state != SLEEPING) {
                        if(p->cnt == 1){
                            Enqueue(&priority[2],p);
                            p->level = 2;
                            p->cnt = 20;
                            m+=10;
                        }
                        else {
                            // p->cnt--;
                            Enqueue(&priority[1], p);
                        }
                    }
                    }
                }
            }
            else if(!IsEmpty(&priority[2])) {
                p = Dequeue(&priority[2]);
                if(p->state == RUNNABLE){//context switching
                    proc = p;
                    switchuvm(p);
                    p->state = RUNNING;
                    swtch(&cpu->scheduler, p->context);
                    switchkvm();
                    proc = 0;
                    
                    if(p->isStride == 0) {
                    if(boostflag == 1) {
                        Enqueue(&priority[2], p);
                        priorityBoost();
                        boostflag = 0;
                    }
                    else if(p->state != SLEEPING) {
                        if(p->cnt == 1){
                            Enqueue(&priority[2],p);
                            p->level = 2;
                            p->cnt = 20;
                            m+= 20;
                        }
                        else {
                            // p->cnt--;
                            if(p->cnt == 1) {
                                Enqueue(&priority[2], p);
                                p->level = 2;
                                p->cnt = 20;
                                m+=20;
                                //cprintf("3\n");
                            }
                            else {
                                Enqueue(&priority[2], p);
                            }
                        }
                    }
                    }
                }
            }
            else {
                noflag = 1;
            }        
            release(&ptable.lock);
        }
        else if(totalShare){
            acquire(&ptable.lock);
            minProc = 0;
            for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
                if(p && p->state == RUNNABLE && p->isStride == 1){
                    if(minProc == 0) minProc = p;
                    else if(minProc->pass > p->pass) minProc = p;
                }
            }
            minProc->pass += minProc->stride;
            minProc->state = RUNNING;

            proc = minProc;
            switchuvm(minProc);
            swtch(&cpu->scheduler, minProc->context);
            switchkvm();
            
            if(minProc && minProc->state != RUNNABLE) totalShare = totalShare - (1000/minProc->stride);

            proc = 0;
            s = s + 1;
            noflag = 0;
            release(&ptable.lock);
        }
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
    if(!holding(&ptable.lock))
        panic("sched ptable.lock");
    if(cpu->ncli != 1)
        panic("sched locks");
    if(proc->state == RUNNING)
        panic("sched running");
    if(readeflags()&FL_IF)
        panic("sched interruptible");
    intena = cpu->intena;
    swtch(&proc->context, cpu->scheduler);
    cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
    acquire(&ptable.lock);  //DOC: yieldlock
    proc->state = RUNNABLE;
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
    if(proc == 0)
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
    proc->chan = chan;
    proc->state = SLEEPING;
    sched();
    // Tidy up.
    proc->chan = 0;
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
        if(p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
            Enqueue(&priority[p->level], p);//after changing
            noflag = 0;
        }
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
kill(int pid){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid == pid){
            p->killed = 1;
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING) {
                p->state = RUNNABLE;
                Enqueue(&priority[p->level], p);
                noflag = 0;
            }
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

int checkLevel(){//checking level : transfter result to getlev
    return proc->level;
}

int
set_cpu_share(int tickets)
{
   // struct proc *p;
    int large = 1000;
    int stride = large/tickets;
  
    //cprintf("totalShare : %d\n", totalShare);
    if(totalShare + tickets > 80) return -1;
    
    //cprintf("set_cpu_share\n");
    totalShare = totalShare + tickets;
    proc->stride = stride;
    proc->pass = 0;
    proc->isStride = 1;
    m = 0;
    s = 0;

    return 0;
}

// Create a new thread (similar to process
// Sets up stack to return as if from system call.
// stack is independent elements (other areas are shared)
// Caller must set state of returned proc to RUNNABLE.

int thread_create(thread_t* thread, void *(*start_routine)(void *), void *arg){
    int i, base;
    struct proc* p;

    //allocate process
    p=allocproc();
    nextpid--;
    if(p == 0){
        cprintf("process allocation fail\n");
        return -1;
    }
    
    acquire(&ptable.lock);

    if(proc->isThread==0)
        p->parent = proc;
    else
        p->parent = proc->parent;

    for(i=0;i<64;i++){
        if(proc->tarr[i]==0){
            p->tid=i+1;
            proc->tarr[i] = 1;
            break;
        }
    }
    *thread = p->tid;
    p->isThread = 1;
    safestrcpy(p->name, proc->name, sizeof(proc->name));
    p->pid = proc->pid;
    *p->tf=*proc->tf; //copy trap frame
    p->sz=proc->sz;
    p->tf->eax = 0;
    p->pgdir = proc->pgdir; //sharing pointer
    
    //kernel stack copyvi p
    for(i = 0; i < NOFILE; i++){
        if(proc->ofile[i]){
            p->ofile[i] = filedup(proc->ofile[i]);
        }
        p->cwd = idup(proc->cwd);
    }
    p->tf->eip = (uint)start_routine;
    
    //allocate two memory for stack and guard page

    
    base = proc->sz + (uint)(PGSIZE*(p->tid));
    p->sz = allocuvm(p->pgdir, base, base+PGSIZE);
  

    
    //cprintf("[tid] %d\n", p->tid);
    p->tf->esp = proc->sz + (uint)(PGSIZE*(1 + p->tid)) - 4;
    *((uint*)(p->tf->esp)) = (uint)arg; //arg pointer
    p->tf->esp -= 4;
    *((uint*)(p->tf->esp)) = 0xffffffff; //fake return PC
    p->tf->ebp = p->tf->esp;
    //cprintf("[create]esp : %d\n", p->tf->esp);
    
   // p->top = base + PGSIZE;
   
    p->state = RUNNABLE;
    release(&ptable.lock);

    return 0;
}

// Wait for exit and return its pid.
// Return -1 if this process has no threads.
 // Scan through table looking for exited threads.
int thread_join(thread_t thread, void **retval){
    struct proc *p;
    int havethreads;
    //int havethreads;
    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited threads.
        havethreads = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->tid != thread)
                continue;
            havethreads = 1;
            if(p->state == ZOMBIE){
                // Found one.
                p->parent->tarr[p->tid - 1] = 0;
                kfree(p->kstack);
                p->kstack = 0;
                p->pid = 0;
                p->tid = 0;
                deallocuvm(p->pgdir, p->sz, p->sz-PGSIZE);
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                *retval = p->retval;
                p->retval = 0;
                release(&ptable.lock);
                return 0;
            }
        }

        // No point waiting if we don't have any threads.
        if(!havethreads || proc->killed){
            release(&ptable.lock);
            return -1;
        }
        // Wait for threas to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
thread_exit(void *retval)
{
    struct proc *p;
    int fd;
    if(proc == initproc)
        panic("init exiting");
    for(fd = 0; fd < NOFILE; fd++){
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    
    begin_op();
    iput(proc->cwd);
    end_op();
    proc->cwd = 0;
    acquire(&ptable.lock);

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent == proc){
            p->parent = initproc;
            if(p->state == ZOMBIE)
                wakeup1(initproc);
        }
    }
    //return value
    proc->retval = retval;
    proc->state = ZOMBIE;
    sched();
    panic("zombie exit");

}
