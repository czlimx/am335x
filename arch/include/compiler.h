/**
 * @file compiler.h
 * @author czlimx (czlimx@163.com)
 * @brief 
 * @version 0.1
 * @date 2023-03-03
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#ifndef ARMV7A_ARM_COMPILER_H
#define ARMV7A_ARM_COMPILER_H

#define NULL            ((void *)0)
#define REG32(addr)     ((volatile unsigned int *)(addr))
#define writel(v, a)    (*REG32(a) = (v))
#define readl(a)        (*REG32(a))
#define RMWREG32(addr, startbit, width, val) *REG32(addr) = (*REG32(addr) & ~((((unsigned int)1u<<(width)) - 1u) << (startbit))) | ((unsigned int)(val) << (startbit))

#define __init__ __attribute__((unused, section(".text.init")))
#define __boot__ __attribute__((unused, section(".text.boot")))
#define __exception__ __attribute__((unused, section(".text.exception")))
#define __interrupt__ __attribute__((unused, section(".text.interrupt")))

#endif // !ARMV7A_ARM_COMPILER_H
