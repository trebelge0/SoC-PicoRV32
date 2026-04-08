# RISC-V Nano-SoC

A minimalist System-on-Chip (SoC) based on the [**PicoRV32**](https://github.com/YosysHQ/picorv32/tree/main) softcore (RISC-V). 

My work consisted in:
* Developing **peripherals** in both **VHDL** and **Verilog** (RAM, Timer, GPIO).
* Implementing **interrupt** processing based on a hardware timer, a **bootloader** in **RISC-V** assembly, and a **C** program for handling.
* Setting up an automated **DevOps** environment (**Makefile**, [**VUnit**](https://vunit.github.io/), **GCC**).
* Simulation on **Modelsim**.

Project developed to deepen knowledge in Soc architecture: FPGA, RISC-V architectures, bare metal C and DevOps.

---

## System Architecture

The SoC uses simple address decoding logic to map peripherals onto the CPU data bus:

| Peripheral | Address Range | Description |
| :--- | :--- | :--- |
| **Memory** | `0x00000000` - `0x0001FFFF` | Vectors, code and data storage (128 KB) |
| **GPIO** | `0x10000000` | Output register |
| **Timer** | `0x20000000` | For periodic interrupt |

### Key Features:
* **CPU**: PicoRV32 (RV32I).
* **Firmware**: Firmware architecture, compilation and bootloading of bare metal C programs.
* **Interrupts**: Interrupt handling based on the Timer.
* **Bus**: Peripheral selection logic.
* **Reset**: Synchronous reset across all modules (CPU, RAM, GPIO).

---

## Development Environment

The project integrates a DevOps hardware simulation stack:

* **Local Simulation**: ModelSim.
* **Test Framework**: [VUnit](https://vunit.github.io/) (Python-based automation).
* **Toolchain**: `riscv64-unknown-elf-gcc`.
* **Build System**: GNU Make.

* **Note**: Git CI is difficult to configure for a multi-language SoC.

---

## Repository Structure

* **rtl/**: VHDL/Verilog source files for the SoC (CPU, RAM, GPIO, Timer, Top).

* **sw/**: C firmware source, HEX generation script (makehex.py), Bootloader (start.S), Linker Script, and the Makefile to generate *sw/firmware.hex*.

* **sim/**: VHDL testbenches using VUnit and Modelsim configuration.

* **run.py**: Main VUnit test script.

* **Makefile**: Root orchestrator for the entire project.

---

## Demo

### 1. Long run
An interrupt is handled every 100 $\mu s$, and increment GPIO.

<img src="img/irqs.png" alt="IRQS" width="600">

### 2. Zoom on a single interrupt: process

1) The current state of the program (registers, PC, SP) is stored in a dedicated IRQ stack.
2) The C function *IRQ_handle.c* is called.
3) The state of the original program is restored, and execution continue from where it was interrupted.

<img src="img/irq_process.png" alt="process Logo" width="600">

### 3. Zoom on interrupt trigger: handling

1) The timer expires (*mtime* reach *mtimecmp*), then triggers the CPU's *IRQ* input signal and sets *mtimecmp* to 0xFFFFFFFF to disable *IRQ*, waiting for *mtimecmp* to be set back by *irq_handle.c*.
2) The CPU handles interruption and sends *mem_addr* to 0x00000010, where the interrupt vector is stored (via the bootloader).
3) Execute the interrupt process described in 2.

<img src="img/irq_handle_start.png" alt="start Logo" width="600">

### 4. Zoom on the return to main program
1) The program address returns to 0x528, where the interrupt occured.
2) The registers have been returned to the main program and have been restored.
3) The program continues.

<img src="img/irq_handle_end.png" alt="end Logo" width="600">

---

## How to run

### 1. Install Dependencies
Install [Modelsim](https://www.altera.com/downloads/simulation-tools/modelsim-fpgas-standard-edition-software-version-20-1-1).

To install VUnit (within a Python virtual environment) and the toolchain:

```bash
pip install vunit_hdl
sudo apt install gcc-riscv64-unknown-elf
```

### 2. Compile and Simulate (GUI)
This section refers to the Makefile a the root of the repo.

To automatically compile the C firmware (It runs sw/Makefile to get hex firmware) and launch VUnit tests:

```bash
make
```

To compile and launch ModelSim GUI with pre-configured signals:
```bash
make gui
```

To only launch tests:
```bash
make test
```

---

## Testing

The project integrates **Unit Testing** using **VUnit**. Scenarios defined in *sim/tb_top.vhd* include:

* **test_loop_increment**: Validates the full data path (Fetch -> Exec -> Write GPIO).

* **test_reset_recovery**: Verifies that the PC, RAM, Timer, and GPIO correctly return to zero after a reset signal.

* **test_long_run**: Analyzes processor stability over an extended execution period.

To launch the test, run the Python program *run_VUnit.py*.
