PREFIX  = riscv64-unknown-elf-
CC      = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy

CFLAGS  = -march=rv32i -mabi=ilp32 -Os -ffreestanding -nostdlib
LDFLAGS = -T linker.ld -Wl,--build-id=none,-Bstatic,--strip-debug

all: firmware.hex

firmware.elf: main.c linker.ld
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

firmware.bin: firmware.elf
	$(OBJCOPY) -O binary $< $@

# Conversion en HEX (format Verilog 32-bit pour readmemh)
firmware.hex: firmware.bin
	python3 makehex.py $< 32768 > $@

clean:
	rm -f *.elf *.bin *.hex *.o