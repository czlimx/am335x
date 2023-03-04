/**
 * @file arch.h
 * @author czlimx (czlimx@163.com)
 * @brief 
 * @version 0.1
 * @date 2023-03-03
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#ifndef ARCH_V7A_H_
#define ARCH_V7A_H_

void alignment_check_enable(void);
void alignment_check_disable(void);
void flow_prediction_enable(void);
void flow_prediction_disable(void);
void set_low_exception_vector(void);
void set_high_exception_vector(void);
void set_arm_exception_generation(void);
void set_thumb_exception_generation(void);

void arm_irq_enable(void);
void arm_irq_disable(void);
void arm_read_cpsr(void);
void arm_write_cpsr(void);

void Icache_enable(void);
void Icache_disable(void);
void Dcache_enable(void);
void Dcache_disable(void);
void Icache_invalidate_all(void);
void Dcache_invalidate_all_by_set_way(void);
void Dcache_clean_all_by_set_way(void);
void Dcache_clean_and_invalidate_all_by_set_way(void);
void Dcache_clean_buffer(unsigned int address, unsigned int size);
void Dcache_invalidate_buffer(unsigned int address, unsigned int size);
void Dcache_clean_and_invalidate_buffer(unsigned int address, unsigned int size);
void Icache_invalidate_buffer(unsigned int address, unsigned int size);

void mmu_enable();
void mmu_disable();

#endif // !ARCH_H_
