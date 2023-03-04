#include "arm_cp15.h"

    .global Icache_enable
    .global Icache_disable
    .global Dcache_enable
    .global Dcache_disable
    .global Icache_invalidate_all
    .global Dcache_clean_all_by_set_way
    .global Dcache_clean_buffer
    .global Dcache_invalidate_buffer
    .global Dcache_clean_and_invalidate_buffer
    .global Icache_invalidate_buffer

    .section .text.cache, "ax", %progbits 
    .arm

/*****************************************************************************
* This API enable the instruction cache.
*****************************************************************************/
Icache_enable:
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #SCTLR_I
    mcr p15, 0, r0, c1, c0, 0
    bx lr

/*****************************************************************************
* This API disable the instruction cache.
*****************************************************************************/
Icache_disable:
    push {lr}
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #SCTLR_I
    mcr p15, 0, r0, c1, c0, 0
    bl Icache_invalidate_all
    pop {lr}
    bx lr

/*****************************************************************************
* This API enable the Data cache.
*****************************************************************************/
Dcache_enable:
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #SCTLR_C
    mcr p15, 0, r0, c1, c0, 0
    bx lr

/*****************************************************************************
* This API disable the Data cache.
******************************************************************************/
Dcache_disable:
    push {r4-r11, lr}
    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #SCTLR_C
    mcr p15, 0, r0, c1, c0, 0
    bl Dcache_clean_all_by_set_way
    pop {r4-r11, lr}
    bx lr

/*****************************************************************************
* This API invalidate all the instruction cache.
*****************************************************************************/
Icache_invalidate_all:
    mov r0, #0
    mcr p15, 0, r0, c7, c5, 0   @ ICIALLU 失效所有的指令cache
    dsb
    bx lr

/*****************************************************************************
* This API Invalidates the entire Data/Unified Cache
*****************************************************************************/
Dcache_invalidate_all_by_set_way:
    push {r4-r11}
    dmb
    mrc p15, 1, r0, c0, c0, 1   @read CLIDR 
    ands r3, r0, #0x7000000
    mov r3, r3, lsr #23         @Cache level value (naturally aligned)
    beq Dcache_invalidate_all_by_set_way_finished
    mov r10, #0

Dcache_invalidate_all_by_set_way_loop1:
    add r2, r10, r10, lsr #1    @Work out 3 x cachelevel
    mov r1, r0, lsr r2          @bottom 3 bits are the Cache type for this level
    and r1, r1, #7              @get those 3 bits alone
    cmp r1, #2

    blt Dcache_invalidate_all_by_set_way_skip

    mcr p15, 2, r10, c0, c0, 0  @write CSSELR from r10
    isb                         @isb to sync the change to the CCSIDR
    mrc p15, 1, r1, c0, c0, 0   @read current CCSIDR to r1
    and r2, r1, #7              @extract the line length field
    add r2, r2, #4              @add 4 for the line length offset (log2 16 bytes)
    ldr r4, =0x3FF
    ands r4, r4, r1, lsr #3     @r4 is the max number on the way size (right aligned)
    clz r5, r4                  @r5 is the bit position of the way size increment
    mov r9, r4                  @r9 working copy of the max way size (right aligned)

Dcache_invalidate_all_by_set_way_loop2: 
    ldr r7, =0x7FFF
    ands r7, r7, r1, lsr #13    @r7 is the max number of the index size (right aligned)

Dcache_invalidate_all_by_set_way_loop3:
    orr r11, r10, r9, lsl r5    @factor in the way number and cache number into r11
    orr r11, r11, r7, lsl r2    @factor in the index number
    mcr p15, 0, r11, c7, c6, 2  @DCISW, Invalidate by set/way
    subs r7, r7, #1             @decrement the index
    bge Dcache_invalidate_all_by_set_way_loop3
    subs r9, r9, #1             @decrement the way number
    bge Dcache_invalidate_all_by_set_way_loop2

Dcache_invalidate_all_by_set_way_skip:
    add r10, r10, #2            @increment the cache number
    cmp r3, r10
    bgt Dcache_invalidate_all_by_set_way_loop1
    dsb

Dcache_invalidate_all_by_set_way_finished:
    dsb
    isb
    pop {r4-r11}
    bx lr


/*****************************************************************************
* This API cleans the entire D Cache to PoC
*****************************************************************************/
Dcache_clean_all_by_set_way:
    push {r4-r11}
    dmb
    mrc p15, 1, r0, c0, c0, 1   @read CLIDR 
    ands r3, r0, #0x7000000
    mov r3, r3, lsr #23         @Cache level value (naturally aligned)
    beq Dcache_clean_all_by_set_way_finished
    mov r10, #0

Dcache_clean_all_by_set_way_loop1:
    add r2, r10, r10, lsr #1    @Work out 3 x cachelevel
    mov r1, r0, lsr r2          @bottom 3 bits are the Cache type for this level
    and r1, r1, #7              @get those 3 bits alone
    cmp r1, #2

    blt Dcache_clean_all_by_set_way_skip

    mcr p15, 2, r10, c0, c0, 0  @write CSSELR from r10
    isb                         @isb to sync the change to the CCSIDR
    mrc p15, 1, r1, c0, c0, 0   @read current CCSIDR to r1
    and r2, r1, #7              @extract the line length field
    add r2, r2, #4              @add 4 for the line length offset (log2 16 bytes)
    ldr r4, =0x3FF
    ands r4, r4, r1, lsr #3     @r4 is the max number on the way size (right aligned)
    clz r5, r4                  @r5 is the bit position of the way size increment
    mov r9, r4                  @r9 working copy of the max way size (right aligned)

Dcache_clean_all_by_set_way_loop2: 
    ldr r7, =0x7FFF
    ands r7, r7, r1, lsr #13    @r7 is the max number of the index size (right aligned)

Dcache_clean_all_by_set_way_loop3:
    orr r11, r10, r9, lsl r5    @factor in the way number and cache number into r11
    orr r11, r11, r7, lsl r2    @factor in the index number
    mcr p15, 0, r11, c7, c10, 2 @DCCSW, clean by set/way
    subs r7, r7, #1             @decrement the index
    bge Dcache_clean_all_by_set_way_loop3
    subs r9, r9, #1             @decrement the way number
    bge Dcache_clean_all_by_set_way_loop2

Dcache_clean_all_by_set_way_skip:
    add r10, r10, #2            @increment the cache number
    cmp r3, r10
    bgt Dcache_clean_all_by_set_way_loop1
    dsb

Dcache_clean_all_by_set_way_finished:
    dsb
    isb
    pop {r4-r11}
    bx lr

/*****************************************************************************
* This API cleans and invalidates the entire D Cache to PoC
*****************************************************************************/
Dcache_clean_and_invalidate_all_by_set_way:
    push {r4-r11}
    dmb
    mrc p15, 1, r0, c0, c0, 1   @read CLIDR 
    ands r3, r0, #0x7000000     @get[24:26]LoC:表明clean invalidate等级，0x3意味level1-3被操作，level4不受影响
    mov r3, r3, lsr #23         @Cache level value (naturally aligned)
    beq Dcache_clean_and_invalidate_all_by_set_way_finished
    mov r10, #0

Dcache_clean_and_invalidate_all_by_set_way_loop1:
    add r2, r10, r10, lsr #1    @Work out 3 x cachelevel, r2现在是level等级
    mov r1, r0, lsr r2          @bottom 3 bits are the Cache type for this level
    and r1, r1, #7              @get those 3 bits alone, 取出Ctype: 2-->Data cache only, 3-->Separate instruction and data caches
    cmp r1, #2

    blt Dcache_clean_and_invalidate_all_by_set_way_skip

    /* 设置当前选定的level等级 */
    mcr p15, 2, r10, c0, c0, 0  @write CSSELR from r10
    isb                         @isb to sync the change to the CCSIDR

    /* 读取设定等级的cache信息 */
    mrc p15, 1, r1, c0, c0, 0   @read current CCSIDR to r1

    /* 获取当前cacheline尺寸 LineSize = 0x02 */
    and r2, r1, #7              @extract the line length field
    add r2, r2, #4              @add 4 for the line length offset (log2 16 bytes)

    /* 获取当前level的way数量 Associativity = 0x03 */
    ldr r4, =0x3FF
    ands r4, r4, r1, lsr #3     @r4 is the max number on the way size (right aligned)
    clz r5, r4                  @r5 is the bit position of the way size increment
    mov r9, r4                  @r9 working copy of the max way size (right aligned)

    /* 获取当前level的set数量 NumSets = 0x7F*/
Dcache_clean_and_invalidate_all_by_set_way_loop2: 
    ldr r7, =0x7FFF
    ands r7, r7, r1, lsr #13    @r7 is the max number of the index size (right aligned)

    /* :::[31:30] = 0x3, [10:4] = 0x7F,  */
Dcache_clean_and_invalidate_all_by_set_way_loop3:
    orr r11, r10, r9, lsl r5    @factor in the way number and cache number into r11
    orr r11, r11, r7, lsl r2    @factor in the index number

    /* DCCSW数据格式：
     * [31:4]SetWay
        [31:32 - A] Way, A = Log2(ASSOCIATIVITY) 
        [B- 1:L] Set, L = Log2(LINELEN), B = (L + S), S = Log2(NSETS).
    ASSOCIATIVITY, LINELEN (line length, in bytes), and NSETS (number of sets).
     * [3 :1] level
        0 = level 1, 1 = level 2
     */
    mcr p15, 0, r11, c7, c14, 2 @DCCISW, Clean and invalidate by set/way
    subs r7, r7, #1             @decrement the index
    bge Dcache_clean_and_invalidate_all_by_set_way_loop3
    subs r9, r9, #1             @decrement the way number
    bge Dcache_clean_and_invalidate_all_by_set_way_loop2

Dcache_clean_and_invalidate_all_by_set_way_skip:
    add r10, r10, #2            @increment the cache number, bit[0] 0-->Data or unified cache, 1-->Instruction cache
    cmp r3, r10
    bgt Dcache_clean_and_invalidate_all_by_set_way_loop1
    dsb

Dcache_clean_and_invalidate_all_by_set_way_finished:
    dsb
    isb
    pop {r4-r11}
    bx lr

/******************************************************************************
* This API clean the D-cache/Unified  lines corresponding to 
* the buffer pointer upto the specified length to PoC.
* r0 - Start Address 
* r1 - Number of bytes to be flushed
******************************************************************************/
Dcache_clean_buffer:
    add r2, r0, r1               @Calculate the end address
    dmb
    mrc p15, 0, r3, c0, c0, 1    @Read Cache Type Register
    lsr r3, r3, #16
    orr r3, r3, #0xF             @Extract the DMinLine

    /* DMinLine = 0x4 --> 16-words --> 64-bytes */  
    mov r4, #2
    add r4, r4, r3
    mov r5, #1
    lsl r5, r5, r3               @Calculate the line size
   
    /* cacheline Align */
    sub r4, r5, #1               @Calculate the mask
    bic r0, r0, r4               @Align to cache line boundary 64-bytes for start address
    bic r2, r2, r4               @Align to cache line boundary 64-bytes for end address

Dcache_clean_loop:
    cmp r0, r2
    beq Dcache_clean_finshed
    mcr p15, 0, r0, c7, c10, 1   @Clean data cache line by MVA to PoC : 通过地址清理数据cache
    add r0, r0, r5               @Go to next line
    b Dcache_clean_loop
 
Dcache_clean_finshed:
    dsb
    bx lr

/******************************************************************************
* This API invalidates the D-cache/Unified  lines corresponding to 
* the buffer pointer upto the specified length to PoC.
* r0 - Start Address 
* r1 - Number of bytes to be flushed
******************************************************************************/
Dcache_invalidate_buffer:
    add r2, r0, r1               @Calculate the end address
    dmb
    mrc p15, 0, r3, c0, c0, 1    @Read Cache Type Register
    lsr r3, r3, #16
    orr r3, r3, #0xF             @Extract the DMinLine

    /* DMinLine = 0x4 --> 16-words --> 64-bytes */  
    mov r4, #2
    add r4, r4, r3
    mov r5, #1
    lsl r5, r5, r3               @Calculate the line size
   
    /* cacheline Align */
    sub r4, r5, #1               @Calculate the mask
    bic r0, r0, r4               @Align to cache line boundary 64-bytes for start address
    bic r2, r2, r4               @Align to cache line boundary 64-bytes for end address

Dcache_invalidate_loop:
    cmp r0, r2
    beq Dcache_invalidate_finshed
    mcr p15, 0, r0, c7, c6, 1    @Invalidate data cache line by MVA to PoC : 通过地址失效数据cache
    add r0, r0, r5               @Go to next line
    b Dcache_invalidate_loop
 
Dcache_invalidate_finshed:
    dsb
    bx lr

/******************************************************************************
* This API clean and invalidates the D-cache/Unified  lines corresponding to 
* the buffer pointer upto the specified length to PoC.
* r0 - Start Address 
* r1 - Number of bytes to be flushed
******************************************************************************/
/* Cache Type Register bit functions : mrc p15, 0, r2, c0, c0, 1 */
/* [27:24] Cache writeback granule: 4'b0010 = cache writeback granule size is 4 words */
/* [19:16] DMinLine: 4'b0100 = sixteen 32-bit word data line length */
/* [15:14] L1 Ipolicy: 2'b10 = virtual index, physical tag L1 Ipolicy */
/* [3 : 0] IMinLine: 4'b0100 = sixteen 32-bit word data line length */
Dcache_clean_and_invalidate_buffer:
    add r2, r0, r1               @Calculate the end address
    dmb
    mrc p15, 0, r3, c0, c0, 1    @Read Cache Type Register
    lsr r3, r3, #16
    orr r3, r3, #0xF             @Extract the DMinLine

    /* DMinLine = 0x4 --> 16-words --> 64-bytes */  
    mov r4, #2
    add r4, r4, r3
    mov r5, #1
    lsl r5, r5, r3               @Calculate the line size
   
    /* cacheline Align */
    sub r4, r5, #1               @Calculate the mask
    bic r0, r0, r4               @Align to cache line boundary 64-bytes for start address
    bic r2, r2, r4               @Align to cache line boundary 64-bytes for end address

Dcache_clean_and_invalidate_loop:
    cmp r0, r2
    beq Dcache_clean_and_invalidate_finshed
    mcr p15, 0, r0, c7, c14, 1   @Clean and Flush D/U line to PoC : 通过地址 清理 + 失效数据cache
    add r0, r0, r5               @Go to next line
    b Dcache_clean_and_invalidate_loop
 
Dcache_clean_and_invalidate_finshed:
    dsb
    bx lr

/*****************************************************************************
* This API invlidates I-cache lines from the star address till the length   
* specified to PoU.
* r0 - Start Address 
* r1 - Number of bytes to be cleaned
******************************************************************************/
Icache_invalidate_buffer:
    add r2, r0, r1               @Calculate the end address
    dmb
    mrc p15, 0, r3, c0, c0, 1    @Read Cache Type Register
    orr r3, r3, #0xF             @Extract the IMinLine

    /* IMinLine = 0x4 --> 16-words --> 64-bytes */  
    mov r4, #2
    add r4, r4, r3
    mov r5, #1
    lsl r5, r5, r3               @Calculate the line size
   
    /* cacheline Align */
    sub r4, r5, #1               @Calculate the mask
    bic r0, r0, r4               @Align to cache line boundary 64-bytes for start address
    bic r2, r2, r4               @Align to cache line boundary 64-bytes for end address

Icache_invalidate_loop:
    cmp r0, r2
    beq Icache_invalidate_finshed
    mcr p15, 0, r0, c7, c5, 1    @Invalidate by MVA to PoU : ICIMVAU 通过地址失效指令cache
    add r0, r0, r5               @Go to next line
    b Icache_invalidate_loop
 
 Icache_invalidate_finshed:
    dsb
    bx lr


    .end