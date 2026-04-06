// Adresses définies dans ton Top et ton VHDL
#define LED_REG    (*(volatile unsigned int*)0x40000000)
#define SENSOR_REG (*(volatile unsigned int*)0x40000004)

int main() {
    unsigned int sensor_val;
    int counter = 0;

    while (1) {
        // 1. Lire la valeur du capteur VHDL
        sensor_val = SENSOR_REG;

        // 2. Si le capteur renvoie bien 42 (0x2A), on fait un chenillard
        if (sensor_val == 0x2A) {
            LED_REG = (1 << (counter % 8));
        } else {
            // Sinon on allume tout pour indiquer une erreur
            LED_REG = 0xFF;
        }

        counter++;

        // Petite boucle d'attente pour la simulation
        for (volatile int i = 0; i < 50; i++);
    }
    
    return 0;
}