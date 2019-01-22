#include "defs.h"

struct Queue;
typedef struct Queue Queue;
typedef struct Queue *queue;

struct Queue{
    struct proc *proc[64];
    int front;
    int rear;
    int qsize;
};

int IsEmpty(queue Q){
    return (Q->qsize == Q);
}

int IsFull(queue Q){
    return (Q->qsize == Q->proc[64]);
}

struct proc *Dequeue(queue Q){
    int tmp = Q->front;
    Q->front = ((Q->front)+1) % (Q->proc[64]);
    Q->qsize--;
    return Q->proc[tmp];
}

void Enqueue(queue Q, struct proc * X){
    Q->qsize++;
    Q->rear = (Q->rear+1)%(Q->proc[64]);
    Q->proc[Q->rear] = X;
}





