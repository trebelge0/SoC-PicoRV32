#define configUSE_PREEMPTION            1
#define configCPU_CLOCK_HZ              10000000
#define configTICK_RATE_HZ              1000

#define configMAX_PRIORITIES            3
#define configMINIMAL_STACK_SIZE        128
#define configTOTAL_HEAP_SIZE           4096

#define configUSE_PORT_OPTIMISED_TASK_SELECTION 0

#define configMTIME_BASE_ADDRESS    0x20000000
#define configMTIMECMP_BASE_ADDRESS 0x20000004