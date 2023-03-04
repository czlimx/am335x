/**
 * @file interrupt.c
 * @author czlimx (czlimx@163.com)
 * @brief 
 * @version 0.1
 * @date 2023-03-02
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#include "compiler.h"
#include "intc.h"
#include "interrupt.h"
#include "memory_base.h"

interrupt_handler_t irq_handler_array[INTC_MAX_IRQ_NUM];

/**
 * @brief unmask irq 
 * 
 * @param irq_number 
 * @return __interrupt__ 
 */
__interrupt__ void arm_irq_handler(unsigned int irq_number)
{
    /* loop all handler */
    for (int i = 0; i < INTC_MAX_HANDLE; i++) {

        /* Find the handler that needs to be fired */
        if (irq_handler_array[irq_number].arg != NULL) {
            irq_handler_array[irq_number].handle(irq_number, 
                         irq_handler_array[irq_number].arg);
        }
    }

    clear_irq(irq_number);
}

__interrupt__ void arm_fiq_handler(unsigned int irq_number)
{

}

__interrupt__ int request_irq(unsigned int num, interrupt_t handle, void *arg)
{
    unsigned int i = 0;

    if (handle == NULL)
        return -1;

    if (arg == NULL)
        return -1;

    if (num > (INTC_MAX_IRQ_NUM - 1))
        return -1;

    for (i = 0; i < INTC_MAX_HANDLE; i++) {
        if (irq_handler_array[num].arg == NULL) {
            break;
        }
    }

    if (irq_handler_array[num].arg != NULL)
        return -1;
    
    irq_handler_array[num].handle = handle;
    irq_handler_array[num].arg = arg;

    return 0;
}

__interrupt__ int free_irq(unsigned int num, void *arg)
{
    unsigned int i = 0;

    if (arg == NULL)
        return -1;

    if (num > (INTC_MAX_IRQ_NUM - 1))
        return -1;

    for (i = 0; i < INTC_MAX_HANDLE; i++) {
        if (irq_handler_array[num].arg == arg) {
            break;
        }
    }

    if (irq_handler_array[num].arg != arg)
        return -1;
    
    irq_handler_array[num].handle = NULL;
    irq_handler_array[num].arg = NULL;

    return 0;
    
}

__interrupt__ int clear_irq(unsigned int num)
{
    unsigned int group = 0;
    unsigned int bit = 0;

    if (num > (INTC_MAX_IRQ_NUM - 1))
        return -1;

    group = num / 32;
    bit = num % 32;

    writel((1 << bit), INTCPS_BASE + INTC_ISR_CLEAR(group));

    return 0;
}

__interrupt__ int trigger_irq(unsigned int num)
{
    unsigned int group = 0;
    unsigned int bit = 0;

    if (num > (INTC_MAX_IRQ_NUM - 1))
        return -1;

    group = num / 32;
    bit = num % 32;

    writel((1 << bit), INTCPS_BASE + INTC_ISR_SET(group));

    return 0;
}

__interrupt__ int enable_irq(unsigned int num)
{
    unsigned int group = 0;
    unsigned int bit = 0;

    if (num > (INTC_MAX_IRQ_NUM - 1))
        return -1;

    group = num / 32;
    bit = num % 32;

    writel((1 << bit), INTCPS_BASE + INTC_MIR_CLEAR(group));

    return 0;
}

__interrupt__ int disable_irq(unsigned int num)
{
    unsigned int group = 0;
    unsigned int bit = 0;

    if (num > (INTC_MAX_IRQ_NUM - 1))
        return -1;

    group = num / 32;
    bit = num % 32;

    writel((1 << bit), INTCPS_BASE + INTC_MIR_SET(group));

    return 0;
}

__interrupt__ int set_priority_irq(unsigned int num, unsigned int pri)
{
    if (num > (INTC_MAX_IRQ_NUM - 1))
        return -1;

    writel(((pri & 0x3F) << 2), INTCPS_BASE + INTC_ILR(num));

    return 0;
}

__init__ int init_irq(void)
{
    unsigned int sysconfig = 0;
    unsigned int status = 0;
    unsigned int timeout = 1000;

    /* softreset intc*/
    sysconfig = readl(INTCPS_BASE + INTC_SYSCONFIG);
    sysconfig |= (1 << 1);
    writel(sysconfig, INTCPS_BASE + INTC_SYSCONFIG);

    /* wait for intc reset done*/
    while ((!status) && (timeout)) {
        status = readl(INTCPS_BASE + INTC_SYSSTATUS) & 0x1;
        timeout--;
    }

    if (timeout)
        return 0;
    else
        return -1;
}
