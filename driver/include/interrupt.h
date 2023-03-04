#ifndef INTERRUPT_H_
#define INTERRUPT_H_

#define INTC_MAX_IRQ_NUM            128
#define INTC_MAX_HANDLE             5

typedef void (*interrupt_t)(unsigned int num, void *arg);

typedef struct{
    void *arg;
    interrupt_t handle;
}interrupt_handler_t;

int request_irq(unsigned int num, interrupt_t handle, void *arg);
int free_irq(unsigned int num, void *arg);
int clear_irq(unsigned int num);
int trigger_irq(unsigned int num);
int enable_irq(unsigned int num);
int disable_irq(unsigned int num);
int set_priority_irq(unsigned int num, unsigned int pri);
int init_irq(void);

#endif /* INTERRUPT_H_ */
