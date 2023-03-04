/**
 * @file arm_faults.c
 * @author czlimx (czlimx@163.com)
 * @brief 
 * @version 0.1
 * @date 2023-03-03
 * 
 * @copyright Copyright (c) 2023
 * 
 */
#include "arm_faults.h"
#include "compiler.h"
#include "debug.h"

static __exception__ void arm_printf_general_register(struct arch_frame *frame)
{
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r0);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r1);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r2);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r3);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r4);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r5);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r6);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r7);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r8);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r9);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r10);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r11);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->r12);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->lr);
    ssdk_printf(SSDK_EMERG, "R0:0x%x\r\n", frame->spsr);
}

void __exception__ arm_undefined_handler(struct arch_frame *frame)
{
    ssdk_printf(SSDK_EMERG, "cpu undefined fault\r\n");
    arm_printf_general_register(frame);
    ssdk_printf(SSDK_EMERG, "fault address:0x%x\r\n", frame->lr - 4);
    ssdk_printf(SSDK_EMERG, "fault opcode:0x%x\r\n", (*(unsigned int *)(frame->lr - 4)));
}

void __exception__ arm_prefetch_abort_handler(struct arch_frame *frame)
{
    unsigned int ifar = frame->ifar;
    unsigned int ifsr = frame->ifsr;

    /* Fault status bits[10, 3:0] */
    unsigned int fault_status = (((ifsr >> 10) & 0x1) << 0x4) | ((ifsr >> 0) & 0xF);

    ssdk_printf(SSDK_EMERG, "cpu prefetch abort fault\r\n");

        /* decode the fault status (from table B3-23) */
    switch (fault_status) {
        case 0x01: // alignment fault
            ssdk_printf(SSDK_EMERG, "alignment fault\r\n");
            break;
        case 0x05:
        case 0x07: // translation fault
            ssdk_printf(SSDK_EMERG, "translation fault\r\n");
            break;
        case 0x03:
        case 0x06: // access flag fault
            ssdk_printf(SSDK_EMERG, "access flag fault\r\n");
            break;
        case 0x09:
        case 0x0B: // domain fault
            ssdk_printf(SSDK_EMERG, "domain fault, domain %lu\r\n", (ifsr >> 4) & 0xF);
            break;
        case 0x0D:
        case 0x0F: // permission fault
            ssdk_printf(SSDK_EMERG, "permission fault\r\n");
            break;
        case 0x02: // debug event
            ssdk_printf(SSDK_EMERG, "debug event\r\n");
            break;
        case 0x08: // synchronous external abort
            ssdk_printf(SSDK_EMERG, "synchronous external abort\r\n");
            break;
        case 0x16: // asynchronous external abort
            ssdk_printf(SSDK_EMERG, "asynchronous external abort\r\n");
            break;
        case 0x10: // TLB conflict event
        case 0x19: // synchronous parity error on memory access
        case 0x04: // fault on instruction cache maintenance
        case 0x0C: // synchronous external abort on translation table walk
        case 0x0E: //    "
        case 0x1C: // synchronous parity error on translation table walk
        case 0x1E: //    "
        case 0x18: // asynchronous parity error on memory access
        default:
            ssdk_printf(SSDK_EMERG, "unhandled fault\r\n");
            break;
    }

    ssdk_printf(SSDK_EMERG, "IFAR:0x%x\r\n", frame->ifar);
    ssdk_printf(SSDK_EMERG, "IFSR:0x%x\r\n", frame->ifsr);
    
    /* used for avoid warnning */
    ifsr = ifar;
}

void __exception__ arm_data_abort_handler(struct arch_frame *frame)
{
    unsigned int dfar = frame->dfar;
    unsigned int dfsr = frame->dfsr;

    /* Write not Read bit[11] */
    /* 0 Abort caused by a read instruction. */
    /* 1 Abort caused by a write instruction. */
    unsigned int write = (dfsr >> 11) & 0x1;

    /* Fault status bits[10, 3:0] */
    unsigned int fault_status = (((dfsr >> 10) & 0x1) << 0x4) | ((dfsr >> 0) & 0xF);

    ssdk_printf(SSDK_EMERG, "cpu data abort fault\r\n");

    switch (fault_status) {
        case 0x01: // alignment fault
            ssdk_printf(SSDK_EMERG, "alignment fault on %s\r\n", write ? "write" : "read");
            break;
        case 0x05:
        case 0x07: // translation fault
            ssdk_printf(SSDK_EMERG, "translation fault on %s\r\n", write ? "write" : "read");
            break;
        case 0x03:
        case 0x06: // access flag fault
            ssdk_printf(SSDK_EMERG, "access flag fault on %s\r\n", write ? "write" : "read");
            break;
        case 0x09:
        case 0x0B: // domain fault
            ssdk_printf(SSDK_EMERG, "domain fault, domain %lu\r\n", (dfsr >> 4) & 0xF);
            break;
        case 0x0D:
        case 0x0F: // permission fault
            ssdk_printf(SSDK_EMERG, "permission fault on %s\r\n", write ? "write" : "read");
            break;
        case 0x02: // debug event
            ssdk_printf(SSDK_EMERG, "debug event\r\n");
            break;
        case 0x08: // synchronous external abort
            ssdk_printf(SSDK_EMERG, "synchronous external abort on %s\r\n", write ? "write" : "read");
            break;
        case 0x16: // asynchronous external abort
            ssdk_printf(SSDK_EMERG, "asynchronous external abort on %s\r\n", write ? "write" : "read");
            break;
        case 0x10: // TLB conflict event
        case 0x19: // synchronous parity error on memory access
        case 0x04: // fault on instruction cache maintenance
        case 0x0C: // synchronous external abort on translation table walk
        case 0x0E: //    "
        case 0x1C: // synchronous parity error on translation table walk
        case 0x1E: //    "
        case 0x18: // asynchronous parity error on memory access
        default:
            ssdk_printf(SSDK_EMERG, "unhandled fault\r\n");
            break;
    }

    ssdk_printf(SSDK_EMERG, "DFAR:0x%x\r\n", frame->dfar);
    ssdk_printf(SSDK_EMERG, "DFSR:0x%x\r\n", frame->dfsr);

    /* used for avoid warnning */
    dfar = (dfsr == dfar) ? dfar : write;
}

void __exception__ arm_svc_handler(struct arch_frame *frame)
{
    unsigned int svc_number = frame->r0;

    switch (svc_number) {
    case 0:     break;
    case 1:     break;
    case 2:     break;
    default:    break;
    }
}
