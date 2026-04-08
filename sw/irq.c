#include <stdint.h>

void irq_handler(uint32_t *regs, uint32_t irqs) {
    // Utilise des constantes directes pour ne pas dépendre du GP ou de la RAM basse
    *((volatile uint32_t*)0x10000000) += 1; // GPIO
    uint32_t now = *((volatile uint32_t*)0x20000000); // MTIME
    *((volatile uint32_t*)0x20000004) = now + 1000; // MTIMECMP CPU 100 MHz, interrupts 10 kHz -> 10000 cycles entre interrupts
}