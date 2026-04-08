FIRMWARE_DIR = ./sw
SIM_DIR = ./sim

all: test

firmware:
	@echo "--- Compilation du Firmware C ---"
	$(MAKE) -C $(FIRMWARE_DIR) 

test: firmware
	@echo "--- Lancement des tests VUnit ---"
	python3 run_VUnit.py -v

gui: firmware
	@echo "--- Lancement des tests VUnit avec interface graphique ---"
	python3 run_VUnit.py --gui

clean:
	rm -rf vunit_out
	rm -rf work
	$(MAKE) -C $(FIRMWARE_DIR) clean