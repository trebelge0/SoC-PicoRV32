PREFIX  = riscv64-unknown-elf-
CC      = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy

CFLAGS  = -march=rv32i -mabi=ilp32 -Os -ffreestanding -nostdlib
LDFLAGS = -T linker.ld -Wl,--build-id=none,-Bstatic,--strip-debug

# On ajoute irq.o à la liste des objets
OBJS = start.o main.o irq.o

all: firmware.hex

# Règle générique pour compiler le C (.c -> .o)
%.o: %.c main.h
	$(CC) $(CFLAGS) -c $< -o $@

# Règle pour l'assembleur (.s -> .o)
%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

# Édition de liens : lie TOUS les objets ensemble
firmware.elf: $(OBJS) linker.ld
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $@

firmware.bin: firmware.elf
	$(OBJCOPY) -O binary $< $@

firmware.hex: firmware.bin
	python3 makehex.py $< 32768 > $@

clean:
	rm -f *.elf *.bin *.hex *.o