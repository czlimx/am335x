#include "arm_cp15.h"
#include "arm.h"

    .global arm_irq_enable
    .global arm_irq_disable
    .global arm_read_cpsr
    .global arm_write_cpsr

    .section .text.cp15, "ax", %progbits
    .arm

alignment_check_enable:
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #SCTLR_A
    mcr p15, 0, r0, c1, c0, 0
    bx lr

alignment_check_disable:
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #SCTLR_A
    mcr p15, 0, r0, c1, c0, 0
    bx lr

flow_prediction_enable:
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #SCTLR_Z
    mcr p15, 0, r0, c1, c0, 0
    bx lr

flow_prediction_disable:
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #SCTLR_Z
    mcr p15, 0, r0, c1, c0, 0
    bx lr

set_low_exception_vector:
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #SCTLR_V
    mcr p15, 0, r0, c1, c0, 0
    bx lr

set_high_exception_vector:
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #SCTLR_V
    mcr p15, 0, r0, c1, c0, 0
    bx lr

set_arm_exception_generation:
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #SCTLR_TE
    mcr p15, 0, r0, c1, c0, 0
    bx lr

set_thumb_exception_generation:
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #SCTLR_TE
    mcr p15, 0, r0, c1, c0, 0
    bx lr

arm_irq_enable:
    mrs r0, cpsr
    bic r0, r0, #PSR_I_BIT
    msr cpsr_c, r0
    bx lr

arm_irq_disable:
    mrs r0, cpsr
    orr r0, r0, #PSR_I_BIT
    msr cpsr_c, r0
    bx lr

arm_read_cpsr:
    mrs r0, cpsr

arm_write_cpsr:
    msr cpsr_cxsf, r0

    .end