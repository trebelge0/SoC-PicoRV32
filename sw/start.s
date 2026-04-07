.section .vectors
.global _start

_start:
    j reset_handler      # Adresse 0x00 : Saut au démarrage
    .align 4
    # Le hardware du PicoRV32 saute à 0x10 lors d'une IRQ
    . = 0x10             
    j irq_wrapper        # Adresse 0x10 : Saut vers le gestionnaire

.section .text
reset_handler:
    la sp, _stack_top
    call main
loop:
    j loop

irq_wrapper:
    # 1. Sauvegarder les registres (Optionnel pour un test simple)
    # 2. Appeler ta fonction C
    call irq
    # 3. Utiliser l'instruction spéciale du PicoRV32 pour quitter l'IRQ
    # Si ton assembleur ne connaît pas 'picorv32_retirq', utilise l'opcode :
    .word 0x0600000b     # picorv32_retirq