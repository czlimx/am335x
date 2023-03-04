#include "arm_cp15.h"

    .global mmu_enable
    .global mmu_disable

    .section .text.mmu, "ax", %progbits 
    .arm

mmu_enable:
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #SCTLR_M
    mcr p15, 0, r0, c1, c0, 0
    bx lr

mmu_disable:
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #SCTLR_M
    mcr p15, 0, r0, c1, c0, 0
    bx lr

    .end