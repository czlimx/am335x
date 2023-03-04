#include "arch.h"
#include "interrupt.h"

void handler1(unsigned int num, void *arg)
{
    volatile unsigned int a = 0;

    a++;
}

void handler(unsigned int num, void *arg)
{
    //trigger_irq(1);
}

int main(void)
{
    Icache_enable();
    init_irq();
    arm_irq_enable();

    request_irq(0, handler, handler);
    request_irq(1, handler1, handler1);
    set_priority_irq(0, 10);
    set_priority_irq(1, 12);
    //enable_irq(0);
    //enable_irq(1);
    
    //trigger_irq(0);*/

    //mmu_enable();
    

    while(1);

    return 0;
}