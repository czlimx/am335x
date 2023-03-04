/**
 * @file arm.h
 * @author czlimx (czlimx@163.com)
 * @brief 
 * @version 0.1
 * @date 2023-03-03
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#ifndef ARMV7A_ARM_H
#define ARMV7A_ARM_H

/* CPU MODE */
#define MODE_USR            0x10
#define MODE_FIQ            0x11
#define MODE_IRQ            0x12
#define MODE_SVC            0x13
#define MODE_ABT            0x17
#define MODE_UND            0x1B
#define MODE_SYS            0x1F

#define MODE_MASK           0x1F
#define I_F_BIT             0xC0

/* PSR */
#define PSR_MODE_SHIFT      (0)
#define PSR_MODE_MASK       (0x1f << PSR_MODE_SHIFT)
#define PSR_MODE_USR        (MODE_USR << PSR_MODE_SHIFT)
#define PSR_MODE_FIQ        (MODE_FIQ << PSR_MODE_SHIFT)
#define PSR_MODE_IRQ        (MODE_IRQ << PSR_MODE_SHIFT)
#define PSR_MODE_SVC        (MODE_SVC << PSR_MODE_SHIFT)
#define PSR_MODE_ABT        (MODE_ABT << PSR_MODE_SHIFT)
#define PSR_MODE_UND        (MODE_UND << PSR_MODE_SHIFT)
#define PSR_MODE_SYS        (MODE_SYS << PSR_MODE_SHIFT)
#define PSR_T_BIT           (1 << 5)
#define PSR_F_BIT           (1 << 6)
#define PSR_I_BIT           (1 << 7)
#define PSR_A_BIT           (1 << 8)
#define PSR_E_BIT           (1 << 9)
#define PSR_IT27_SHIFT      (10)
#define PSR_IT27_MASK       (0x3f << PSR_IT27_SHIFT)
#define PSR_GE_SHIFT        (16)
#define PSR_GE_MASK         (15 << PSR_GE_SHIFT)
#define PSR_J_BIT           (1 << 24)
#define PSR_IT01_SHIFT      (25)
#define PSR_IT01_MASK       (3 << PSR_IT01_SHIFT)
#define PSR_Q_BIT           (1 << 27)
#define PSR_V_BIT           (1 << 28)
#define PSR_C_BIT           (1 << 29)
#define PSR_Z_BIT           (1 << 30)
#define PSR_N_BIT           (1 << 31)

#endif
