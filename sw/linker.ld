MEMORY {
    ram : ORIGIN = 0x00000000, LENGTH = 128K
}

SECTIONS {
    /* Code and vectors */
    .text : {
        . = 0x000000;  /* reset_vec -> 0x000000 */
        start.o(.text) 
        *(.text .text.*)
    } > ram

    /* Constnates */
    .rodata : {
        . = ALIGN(4);
        *(.rodata .rodata.*)
    } > ram

    /* Variables globales */
    .data : {
        . = ALIGN(4);
        *(.data .data.*)
    } > ram

    /* Non-initialized data */
    .bss : {
        . = ALIGN(4);
        *(.bss .bss.*)
        *(COMMON)
    } > ram

    /* Stack top -> ram top */
    _stack_top = ORIGIN(ram) + LENGTH(ram);

    _end = .;
}