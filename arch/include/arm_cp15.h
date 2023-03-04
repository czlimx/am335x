/**
 * @file arm_cp15.h
 * @author czlimx (czlimx@163.com)
 * @brief 
 * @version 0.1
 * @date 2023-03-03
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#ifndef ARMV7A_CP15_H
#define ARMV7A_CP15_H

/* SCTLR */
#define SCTLR_M             (1 << 0)
#define SCTLR_A             (1 << 1)
#define SCTLR_C             (1 << 2)
#define SCTLR_Z             (1 << 11)
#define SCTLR_I             (1 << 12)
#define SCTLR_V             (1 << 13)
#define SCTLR_EE            (1 << 25)
#define SCTLR_NMFI          (1 << 27)
#define SCTLR_ARE           (1 << 28)
#define SCTLR_AFE           (1 << 29)
#define SCTLR_TE            (1 << 30)


#endif /* ARMV7A_CP15_H */
