#ifndef INTC_H_
#define INTC_H_

#define INTC_REVISION               0x00 
#define INTC_SYSCONFIG              0x10
#define INTC_SYSSTATUS              0x14
#define INTC_SIR_IRQ                0x40
#define INTC_SIR_FIQ                0x44
#define INTC_CONTROL                0x48
#define INTC_PROTECTION             0x4C
#define INTC_IDLE                   0x50
#define INTC_IRQ_PRIORITY           0x60    
#define INTC_FIQ_PRIORITY           0x64    
#define INTC_THRESHOLD              0x68
#define INTC_ITR0                   0x80
#define INTC_MIR0                   0x84
#define INTC_MIR_CLEAR0             0x88
#define INTC_MIR_SET0               0x8C
#define INTC_ISR_SET0               0x90
#define INTC_ISR_CLEAR0             0x94
#define INTC_PENDING_IRQ0           0x98    
#define INTC_PENDING_FIQ0           0x9C    
#define INTC_ILR0                   0x100

#define INTC_ITR(n)                 (INTC_ITR0 + (n * 0x20))
#define INTC_MIR(n)                 (INTC_MIR0 + (n * 0x20))
#define INTC_MIR_CLEAR(n)           (INTC_MIR_CLEAR0 + (n * 0x20))
#define INTC_MIR_SET(n)             (INTC_MIR_SET0 + (n * 0x20))
#define INTC_ISR_SET(n)             (INTC_ISR_SET0 + (n * 0x20))
#define INTC_ISR_CLEAR(n)           (INTC_ISR_CLEAR0 + (n * 0x20))
#define INTC_PENDING_IRQ(n)         (INTC_PENDING_IRQ0 + (n * 0x20))
#define INTC_PENDING_FIQ(n)         (INTC_PENDING_FIQ0 + (n * 0x20))
#define INTC_ILR(n)                 (INTC_ILR0 + (n * 0x4))

#endif /* INTC_H_ */
