/*#include "FreeRTOS.h"
#include "task.h"

#define GPIO (*(volatile int*)0x10000000)

void task1(void *p)
{
    while (1) {
        GPIO = 1;
    }
}

void task2(void *p)
{
    while (1) {
        GPIO = 2;
    }
}

int main()
{
    xTaskCreate(task1, "T1", 128, NULL, 1, NULL);
    xTaskCreate(task2, "T2", 128, NULL, 1, NULL);

    vTaskStartScheduler();

    while (1);
}*/

#include <stdint.h>

#define set_mask(mask) \
    asm volatile (".word 0x0161000b\n" : : "r"(mask))

int main() {

    set_mask(0x00000000);

    volatile uint32_t *mtimecmp = (uint32_t*)0x20000004;
    volatile uint32_t *mtime    = (uint32_t*)0x20000000;
    
    *mtimecmp = *mtime + 100;
    
    while(1) {}
}