from vunit import VUnit
from os.path import join, dirname

# 1. Initialisation de VUnit à partir des arguments de ligne de commande
ui = VUnit.from_argv()

# 2. Création d'une bibliothèque "lib" pour ton projet
lib = ui.add_library("lib")

# 3. Ajout de toutes les sources (VHDL et Verilog)
root = dirname(__file__)
lib.add_source_files(join(root, "rtl", "*.vhd"))
lib.add_source_files(join(root, "rtl", "*.v"))
lib.add_source_files(join(root, "sim", "*.vhd"))

## On dit à VUnit : "Si on est en GUI, lance wave.do"
ui.set_sim_option("modelsim.init_files.after_load", [join(root, "sim", "run.do")])

ui.main()