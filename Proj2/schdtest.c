#include "types.h"
#include "user.h"

#define P_LOOP_CNT 0x01000000
#define C_LOOP_CNT 0x03000000


void do_parent(void)
{
    volatile int cnt = 0;
    volatile int tmp = 0;

    while(cnt < P_LOOP_CNT)
    {
        tmp += cnt;
        cnt ++;
    }
}


void do_child(void)
{
    volatile int cnt = 0;
    volatile int tmp = 0;

    while(cnt < C_LOOP_CNT)
    {
        tmp += cnt;
        cnt ++;
    }

    exit();
}

void example_test_code()
{
    int pid = 0;

    pid = fork();
    // set_priority(getpid(), 3);
    if (pid < 0)
    {
        printf(1, "fork() failed!\n");
        exit();
    }
    else if (pid == 0) // child
    {
        //sleep(100);
        
        set_priority(getpid(), 2);
        printf(1, "fork() Child!\n");
        do_child();
    }
    else // parent
    {
        
        printf(1, "fork() Parent!\n");
        set_priority(getpid(), 3);
        do_parent();
        if (wait() < 0)
        {
            printf(1, "wait() failed!\n");
        }
    }
	int pid1 = 0;
    pid1 = fork();
    // set_priority(getpid(), 3);
    if (pid1 < 0)
    {
        printf(1, "fork() failed!\n");
        exit();
    }
    else if (pid1 == 0) // child
    {
        //sleep(100);
        
        set_priority(getpid(), 3);
        printf(1, "fork() Child!\n");
        do_child();
    }
    else // parent
    {
        
        printf(1, "fork() Parent!\n");
        // set_priority(getpid(), 3);
        do_parent();
        if (wait() < 0)
        {
            printf(1, "wait() failed!\n");
        }
    }
	printf(1, "\n");
}

int
main(int argc, char *argv[])
{
    enable_sched_trace(1);

    /* ---------------- start: add your test code ------------------- */
    set_sched(1);
    example_test_code();


    /* ---------------- end: add your test code ------------------- */

    enable_sched_trace(0);
    
    exit();
}
