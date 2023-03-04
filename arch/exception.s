#include "memory_base.h"
#include "intc.h"

    .global do_undefined_instruction
    .global do_software_interrupt
    .global do_prefetch_abort
    .global do_data_abort
    .global do_not_used
    .global do_irq
    .global do_fiq

    .extern arm_svc_handler
    .extern arm_undefined_handler
    .extern arm_data_abort_handler
    .extern arm_prefetch_abort_handler

    .section .text.exception, "ax", %progbits
    .arm

.macro save_general_register
    /* save general register */
    stmfd sp!, {r0-r12, lr}
.endm
   
.macro save_special_register
    /* save spsr register */
    mrs r8, spsr

    /* The IFSR holds status information about the last instruction fault */
    mrc p15, 0, r7, c5, c0, 1

    /* The IFAR of faulting address of synchronous Prefetch Abort exception */
    mrc p15, 0, r6, c6, c0, 2

    /* The DFSR holds status information about the last data fault. */
    mrc p15, 0, r5, c5, c0, 0

    /* The DFAR of faulting address of synchronous Data Abort exception */
    mrc p15, 0, r4, c6, c0, 0

    /* save special register */
    stmfd sp!, {r4-r8}

    /* used r0 for frame pointer */
    mov r0, sp
.endm

.macro restore_special_register
    /* restore special register */
    ldmfd sp!, {r4-r8}
.endm
    
.macro restore_general_register
    /* restore general register */
    ldmfd sp!, {r0-r12, pc}^
.endm

do_undefined_instruction:
    save_general_register
    save_special_register
    bl arm_undefined_handler
    restore_special_register
    restore_general_register
        
do_software_interrupt:
    save_general_register
    bl arm_svc_handler
    restore_general_register

do_prefetch_abort:
    sub lr, lr, #4
    save_general_register
    save_special_register
    bl arm_prefetch_abort_handler
    restore_special_register
    restore_general_register

do_data_abort:
    sub lr, lr, #8
    save_general_register
    save_special_register
    bl arm_data_abort_handler
    restore_special_register
    restore_general_register

do_not_used:
    b .

do_irq:
    sub lr, lr, #4
    save_general_register
    
    /* save spsr to r11, atpcs is 0~3*/
    mrs r11, spsr
    
    /* read current interrupt threshold */
    ldr r0, =INTCPS_BASE + INTC_THRESHOLD
    ldr r12, [r0]

    /* update current priority to threshold */
    ldr r1, =INTCPS_BASE + INTC_IRQ_PRIORITY
    ldr r2, [r1]
    and r2, r2, #0x3F
    str r2, [r0]
    
    /* get current IRQ number */
    ldr r1, =INTCPS_BASE + INTC_SIR_IRQ
    ldr r0, [r1]
    and r0, r0, #0x7F

    /* allow new IRQ */
    ldr r1, =INTCPS_BASE + INTC_CONTROL
    ldr r2, [r1]
    orr r2, r2, #0x1
    str r2, [r1]

    /* Data Synchronization Barrier */
    mov r1, #0
    mcr p15, 0, r1, c7, c10, 4

    /* Read-modify-write the CPSR to enable IRQs */
    mrs r1, cpsr
    bic r1, r1, #0x80
    msr cpsr_c, r1

    /* current register value
     * R0 :IRQ number
     * R11:SPSR
     * R12:IRQ threshold
     */
    bl arm_irq_handler

    /* Read-modify-write the CPSR to disable IRQs */
    mrs r1, cpsr
    orr r1, r1, #0x80
    msr cpsr_c, r1

    /* Restore the INTC_THRESHOLD register from R12 */
    ldr r0, =INTCPS_BASE + INTC_THRESHOLD
    str r12, [r0]

    /* Restore spsr */
    msr spsr_cxsf, r11
    restore_general_register

do_fiq:
    sub lr, lr, #4
    save_general_register
    
    /* save spsr to r11, atpcs is 0~3*/
    mrs r11, spsr
    
    /* read current interrupt threshold */
    ldr r0, =INTCPS_BASE + INTC_THRESHOLD
    ldr r12, [r0]

    /* update current priority to threshold */
    ldr r1, =INTCPS_BASE + INTC_FIQ_PRIORITY
    ldr r2, [r1]
    and r2, r2, #0x3F
    str r2, [r0]
    
    /* git current FIQ number */
    ldr r1, =INTCPS_BASE + INTC_SIR_FIQ
    ldr r0, [r1]
    and r0, r0, #0x7F

    /* allow new FIQ */
    ldr r1, =INTCPS_BASE + INTC_CONTROL
    ldr r2, [r1]
    orr r2, r2, #0x2
    str r2, [r1]

    /* Data Synchronization Barrier */
    mov r1, #0
    mcr p15, 0, r1, c7, c10, 4

    /* Read-modify-write the CPSR to enable IRQs */
    mrs r1, cpsr
    bic r1, r1, #0x40
    msr cpsr_c, r1

    /* current register value
     * R0 :IRQ number
     * R11:SPSR
     * R12:IRQ threshold
     */
    bl arm_fiq_handler

    /* Read-modify-write the CPSR to disable IRQs */
    mrs r1, cpsr
    orr r1, r1, #0x40
    msr cpsr_c, r1

    /* Restore the INTC_THRESHOLD register from R12 */
    ldr r0, =INTCPS_BASE + INTC_THRESHOLD
    str r12, [r0]

    /* Restore spsr */
    msr spsr_cxsf, r11
    restore_general_register

    .end
