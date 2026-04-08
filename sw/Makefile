PREFIX  = riscv64-unknown-elf-
CC      = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy

# Ajout impératif de -march et -mabi ici pour que start.S soit vu en 32-bit
CFLAGS  = -march=rv32i -mabi=ilp32 -Os -ffreestanding -nostdlib -I.
LDFLAGS = -T linker.ld -Wl,--build-id=none,-Bstatic,--strip-debug

OBJS = start.o main.o irq.o

all: firmware.hex

# Règle pour le C
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Règle pour l'assembleur (.S majuscule pour gérer le #include)
# AJOUT DE $(CFLAGS) ICI POUR ÉVITER L'ERREUR ABI
%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

# Édition de liens
firmware.elf: $(OBJS) linker.ld
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $@

firmware.bin: firmware.elf
	$(OBJCOPY) -O binary $< $@

firmware.hex: firmware.bin
	python3 makehex.py $< 32768 > $@

clean:
	rm -f *.elf *.bin *.hex *.o