#include "custom_ops.S"

.section .text
.global _start

_start:
reset_vec:
    picorv32_maskirq_insn(zero, zero) // Demask
    j start

.balign 16
irq_vec:
    /* 1. Sauvegarde x1 et x2 (ra, sp) */
    picorv32_setq_insn(q2, x1)
    picorv32_setq_insn(q3, x2)

    /* 2. Pointer sur la zone de sauvegarde */
    lui x1, %hi(irq_regs)
    addi x1, x1, %lo(irq_regs)

    /* 3. Sauver PC (q0) et les originaux de x1, x2 */
    picorv32_getq_insn(x2, q0)
    sw x2, 0*4(x1)
    picorv32_getq_insn(x2, q2)
    sw x2, 1*4(x1)
    picorv32_getq_insn(x2, q3)
    sw x2, 2*4(x1)

    /* 4. Sauver le reste (Caller-saved) */
    sw x5, 5*4(x1)
    sw x6, 6*4(x1)
    sw x7, 7*4(x1)
    sw x10, 10*4(x1)
    sw x11, 11*4(x1)
    sw x12, 12*4(x1)
    sw x13, 13*4(x1)
    sw x14, 14*4(x1)
    sw x15, 15*4(x1)
    sw x16, 16*4(x1)
    sw x17, 17*4(x1)
    sw x28, 28*4(x1)
    sw x29, 29*4(x1)
    sw x30, 30*4(x1)
    sw x31, 31*4(x1)

    /* 5. Pile IRQ et Appel C */
    la sp, irq_stack
    mv a0, x1                  // Arg 0: regs
    picorv32_getq_insn(a1, q1) // Arg 1: irqs status
    jal ra, irq_handler

    /* 6. Restauration */
    mv x1, a0                  // Utilise l'adresse retournée par le C
    
    lw x2, 0*4(x1)
    picorv32_setq_insn(q0, x2) // Restaure PC de retour

    lw x2, 1*4(x1)
    picorv32_setq_insn(q1, x2) // Cache x1 original dans q1

    lw x2, 2*4(x1)
    picorv32_setq_insn(q2, x2) // Cache x2 original dans q2

    lw x5, 5*4(x1)
	lw x6, 6*4(x1)
	lw x7, 7*4(x1)
	lw x10, 10*4(x1)
	lw x11, 11*4(x1)
	lw x12, 12*4(x1)
	lw x13, 13*4(x1)
	lw x14, 14*4(x1)
	lw x15, 15*4(x1)
	lw x16, 16*4(x1)
	lw x17, 17*4(x1)
	lw x28, 28*4(x1)
	lw x29, 29*4(x1)
	lw x30, 30*4(x1)
    lw x31, 31*4(x1)

    /* 7. Libération finale de x1 et x2 */
    picorv32_getq_insn(x1, q1)
    picorv32_getq_insn(x2, q2)

    picorv32_retirq_insn()

.balign 0x200
irq_regs:
    .fill 32,4
    .fill 128,4
irq_stack:

start:
    /* Initialisation de la pile via le linker */
    la sp, _stack_top
    jal ra, main