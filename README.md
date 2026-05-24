# From Algorithm to RTL: Artifact Repository

This repository contains artifacts accompanying the paper:

**From Algorithm to RTL**

If you are new to this repository, start by reading the paper PDF in:

- `Paper/From Algotithm to RTL.pdf`

The repo includes MLIR/CIRCT/Calyx lowering intermediates, generated SystemVerilog, and FPGA synthesis/implementation reports used in the paper experiments.

## Paper

- Title: **From Algorithm to RTL**
- PDF: `Paper/From Algotithm to RTL.pdf`
- Recommended: read the paper first, then use this repository to inspect and reproduce the reported artifacts and hardware results.

## Repository Contents

- `Paper/`
  - PDF of the paper (`From Algotithm to RTL.pdf`).
- `Relu/`, `GeLU/`, `FFNN/`
  - End-to-end lowering artifacts:
    - `Input/*.mlir` (+ some Python source files)
    - `0.*-linalg.mlir`, `1.*-scf.mlir`, `2.*-scf-flat.mlir`, `3.*-calyx.mlir`, `4.*.futil`
    - `Output/*.sv` (generated RTL)
  - `lower.sh`: run lowering flow.
  - `clean.sh`: clean generated intermediates/RTL in that folder.
- `Gemm/`, `Increment/`
  - Input and output artifacts (MLIR + generated RTL), without local lowering scripts.
- `Reports/`
  - Vivado outputs for multiple designs/variants (e.g., baseline, GPT-generated, Gemini-generated):
    - utilization, timing, power reports (`*.rpt`)
    - design checkpoints (`*.dcp`)
    - Vivado logs/journals (`*.log`, `*.jou`)
  - `scripts/` helpers for running/processing reports.

## Toolchain Prerequisites

The lowering scripts assume:

- LLVM MLIR tools (`mlir-opt`)
- CIRCT tools (`circt-opt`, `circt-translate`, `hlstool`)
- Calyx compiler (`calyx`)
- `bash`, `awk`, `python3`
- Xilinx Vivado (for reproducing FPGA reports)

## Installation

Install the required tools before using this repository:

- CIRCT (includes MLIR/CIRCT build flow):  
  https://circt.llvm.org/docs/GettingStarted/
- Xilinx Vivado (for synthesis/place-and-route reports):  
  https://www.xilinx.com/support/download.html

After installation, ensure the following tools are available:

- `mlir-opt`
- `circt-opt`
- `circt-translate`
- `hlstool`
- `calyx`
- `vivado`

Important: `lower.sh` scripts currently contain hardcoded tool paths:

- `LLVM_BIN_DIR=/home/mahfuz/circt/llvm/build/bin`
- `CIRCT_BIN_DIR=/home/mahfuz/circt/build/bin`

Update those paths to your environment before running.

## Reproducing RTL Generation

Examples below run the checked-in lowering flow for kernels that include scripts.

```bash
cd Relu
bash lower.sh
```

```bash
cd GeLU
bash lower.sh
```

```bash
cd FFNN
bash lower.sh
```

Outputs are written to each kernel’s `Output/` directory (e.g., `Relu/Output/relu.sv`).

## Reproducing/Parsing Vivado Results

Vivado TCL example is provided in:

- `Reports/scripts/run_gemm_main_zynq7020.tcl`

Report summarization helper:

```bash
bash Reports/scripts/summarize_vivado.sh /path/to/design.sv /path/to/reports_dir
```

This prints: LUT, FF, BRAM, DSP, power, and estimated Fmax (derived from clock period and WNS).
