FIRMWARE_DIR = ./sw
SIM_DIR = ./sim

all: test

firmware:
	@echo "--- Compilation du Firmware C ---"
	$(MAKE) -C $(FIRMWARE_DIR) 

test: firmware
	@echo "--- Lancement des tests VUnit ---"
	python3 run_VUnit.py -v

clean:
	rm -rf vunit_out
	$(MAKE) -C $(FIRMWARE_DIR) clean