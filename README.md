# ⚡ RISC-V Nano-SoC

![CI Status](https://github.com/YOUR_USER/YOUR_REPO/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Language](https://img.shields.io/badge/Language-VHDL%20%2F%20C-orange.svg)

A minimalist System-on-Chip (SoC) based on the **PicoRV32** processor (RISC-V RV32I). This project implements a complete architecture including RAM, a data bus, and control peripherals, all validated by an automated unit testing suite using **VUnit**.

---

## System Architecture

The SoC uses simple address decoding logic to map peripherals onto the CPU data bus:

| Peripheral | Address Range | Description |
| :--- | :--- | :--- |
| **RAM** | `0x00000000` - `0x00007FFF` | Code (ROM) and Data storage (32 KB) |
| **GPIO** | `0x10000000` | Output register for signal/LED control |

### Key Features:
* **CPU**: PicoRV32 (RV32I) configured in native mode.
* **Bus**: Single-cycle combinational address selection.
* **Reset**: Synchronous reset management across all modules (CPU, RAM, GPIO).

---

## Development Environment

The project integrates a modern Hardware DevOps verification stack:

* **Local Simulation**: ModelSim / QuestaSim.
* **CI Simulation**: GHDL (via GitHub Actions).
* **Test Framework**: [VUnit](https://vunit.github.io/) (Python-based automation).
* **Toolchain**: `riscv64-unknown-elf-gcc`.
* **Build System**: GNU Make.

---

## Quick Start

### 1. Install Dependencies
It is recommended to use a Python virtual environment for VUnit:

```bash
pip install vunit_hdl
```

### 2. Compile and Simulate (GUI)
To automatically compile the C firmware and launch ModelSim with pre-configured signals:

```bash
make gui
```

### 3. Run Tests (Console)
Ideal for quick non-regression checks (and used by the CI pipeline):

```bash
make test
```
## Verification Strategy

The project follows a Unit Testing approach. Scenarios defined in sim/tb_top.vhd include:

* **test_loop_increment**: Validates the full data path (Fetch -> Exec -> Write GPIO).

* **test_reset_recovery**: Verifies that the Program Counter and GPIO states correctly return to zero after a reset signal.

* **test_long_run**: Analyzes processor stability over an extended execution period.

## Repository Structure

* **rtl/**: VHDL/Verilog source files for the SoC (CPU, RAM, GPIO, Top).

* **sw/**: C firmware source, HEX generation script (makehex.py), and Linker Script.

* **sim/**: VHDL testbenches and VUnit configuration.

* **.github/workflows/**: Continuous Integration pipeline configuration.

* **run.py**: Main VUnit test management script.

* **Makefile**: Root orchestrator for the entire project.

## Roadmap

* Implement an UART controller for console output.

* Add a 32-bit Timer with Interrupt (IRQ) support.

* Migrate the interconnect to the AXI4-Lite standard.

Project developed to deepen knowledge in RISC-V architectures and automated hardware verification.# SoC-PicoRV32
