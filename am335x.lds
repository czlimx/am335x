MEMORY
{
    IRAM_MEM :   o = 0x402F0400,  l = 0x1FBFF      /* 127k internal Memory */
}
OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)
SECTIONS
{
    .text : {
        . = ALIGN(4);
        *(.text.vectors)
        *(.text.exception)
        *(.text.boot)
        *(.text.init)
        *(.text.interrupt)
        *(.text.cache)
        *(.text.mmu)
        *(.text.cp15)
        *(.text*)
        *(.glue*)
        *(.vfp*)
        *(.v4*)
        *(*.iplt*)
    } >IRAM_MEM
    
	.rodata : {
        . = ALIGN(4);
		*(.rodata*)
	} >IRAM_MEM

	.data : {
        . = ALIGN(4);
		*(.data*)
        *(.igot*)
	} >IRAM_MEM

	.bss :{
		. = ALIGN(4);
		_bss_start = .;
		*(.bss*)
        *(COMMON)
        . = ALIGN(4);
		_bss_end = .;
	} >IRAM_MEM

    .stack :
    {
        . = ALIGN(256);
        __StackLimit = .;
        *(.stack*)
        . = . + 0x1000;
        __StackTop = .;
    } >IRAM_MEM
    _stack = __StackTop;
}
