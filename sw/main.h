#include <stdint.h>
#include <stdbool.h>

// irq.c
extern void irq_handler(uint32_t *regs, uint32_t irqs);