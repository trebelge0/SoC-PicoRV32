MEMORY
{
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 32K
}

SECTIONS {
    . = 0x00000000;

    /* On force les vecteurs à l'adresse 0 */
    .vectors : {
        KEEP(*(.vectors))
    } > RAM

    .text : { 
        *(.text*) 
    } > RAM

    .rodata : { *(.rodata*) } > RAM
    .data   : { *(.data*)   } > RAM
    .bss    : { *(.bss*)    } > RAM

    /* On définit le haut de la pile à la fin de la RAM */
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}