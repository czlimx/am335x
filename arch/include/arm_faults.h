/**
 * @file arm_faults.h
 * @author czlimx (czlimx@163.com)
 * @brief 
 * @version 0.1
 * @date 2023-03-03
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#ifndef ARMV7A_ARM_FAULTS_H
#define ARMV7A_ARM_FAULTS_H

#ifndef ASSEMBLY

/**
 * @brief arm general + faults register.
 * 
 */
typedef struct arch_frame {
    unsigned int dfar;
    unsigned int dfsr;
    unsigned int ifar;
    unsigned int ifsr;
    unsigned int spsr;
    unsigned int r0;
    unsigned int r1;
    unsigned int r2;
    unsigned int r3;
    unsigned int r4;
    unsigned int r5;
    unsigned int r6;
    unsigned int r7;
    unsigned int r8;
    unsigned int r9;
    unsigned int r10;
    unsigned int r11;
    unsigned int r12;
    unsigned int lr;
}arch_frame_t;

/**
 * @brief svc exception handle function
 * 
 * @param frame pointer for arm general + faults register
 */
void arm_svc_handler(struct arch_frame *frame);

/**
 * @brief undefined exception handle function
 * 
 * @param frame pointer for arm general + faults register
 */
void arm_undefined_handler(struct arch_frame *frame);

/**
 * @brief data abort exception handle function
 * 
 * @param frame pointer for arm general + faults register
 */
void arm_data_abort_handler(struct arch_frame *frame);

/**
 * @brief prefetch abort exception handle function
 * 
 * @param frame pointer for arm general + faults register
 */
void arm_prefetch_abort_handler(struct arch_frame *frame);

#endif  /* ASSEMBLY */

#endif /* ARMV7A_ARM_FAULTS_H */
