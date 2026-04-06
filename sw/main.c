#define GPIO (*(volatile int*)0x10000000)

int main() {
    int i = 0;

    while (1) {
        GPIO = i;
        i++;
    }
}