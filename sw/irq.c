#include <stdint.h>

void irq(void)
{
    volatile uint32_t *mtimecmp = (uint32_t*)0x20000004;
    volatile uint32_t *mtime    = (uint32_t*)0x20000000;

    // prochain tick
    *mtimecmp = *mtime + 100;

    // appeler FreeRTOS
    //extern void xPortSysTickHandler(void);
    //xPortSysTickHandler();
}