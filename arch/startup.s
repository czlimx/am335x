#include "arm.h"
#include "arm_cp15.h"

    .set  UND_STACK_SIZE, 0x100
    .set  SVC_STACK_SIZE, 0x100
    .set  ABT_STACK_SIZE, 0x100
    .set  FIQ_STACK_SIZE, 0x100
    .set  IRQ_STACK_SIZE, 0x100

    .global _stack
    .global _startup
    .global main
    .section .text.boot, "ax", %progbits
    .arm

_startup:
    @switch to svc mode, disable FIQ IRQ, switch Arm mode
    msr cpsr_c, #(MODE_SVC | I_F_BIT)

setup_vbar:
    @select low exception vectors
    mrc p15, 0, r0, c1, c0, 0    @ read SCTLR into r0
    bic r0, r0, #SCTLR_V         @ SCTLR.V-->0:0x0 1:0xFFFF0000
    mcr p15, 0, r0, c1, c0, 0    @ write r0 to SCTLR

    @set non-secure mode exception base address
    mrc p15, 0, r0, c12, c0, 0
    ldr r0, =_start
    mcr p15, 0, r0, c12, c0, 0
    
setup_stack:
    @Set up the Stack for Undefined mode
    ldr r0, =_stack
    msr cpsr_c, #MODE_UND | I_F_BIT
    mov sp, r0
    sub r0, r0, #UND_STACK_SIZE

    @ Set up the Stack for abort mode
    msr cpsr_c, #MODE_ABT | I_F_BIT
    mov sp, r0
    sub r0, r0, #ABT_STACK_SIZE

    @ Set up the Stack for FIQ mode
    msr cpsr_c, #MODE_FIQ | I_F_BIT
    mov sp, r0
    sub r0, r0, #FIQ_STACK_SIZE

    @ Set up the Stack for IRQ mode
    msr cpsr_c, #MODE_IRQ | I_F_BIT
    mov sp, r0
    sub r0, r0, #IRQ_STACK_SIZE

    @ Set up the Stack for SVC mode
    msr cpsr_c, #MODE_SVC | I_F_BIT
    mov sp, r0
    sub r0, r0, #SVC_STACK_SIZE

    @ Set up the Stack for USer/System mode
    msr cpsr_c, #MODE_SYS | I_F_BIT
    mov sp, r0

clear_bss_section:
    ldr r0, =_bss_start                 @ Start address of BSS
    ldr r1, =(_bss_end - 0x04)          @ End address of BSS
    mov r2, #0  
bss_loop: 
    str r2, [r0], #4                    @ Clear one word in BSS
    cmp r0, r1
    ble bss_loop                        @ Clear till BSS end

    bl main 

    .end