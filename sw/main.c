#include <stdint.h>

extern void irq_handler(void);

int main() {
    volatile uint32_t *mtime    = (uint32_t*)0x20000000;
    volatile uint32_t *mtimecmp = (uint32_t*)0x20000004;

    // Configurer la première alerte (très proche pour le test)
    *mtimecmp = 50;

    // Boucle infinie
    volatile int counter = 0;
    while(1) {
        counter++;
    }
    return 0;
}