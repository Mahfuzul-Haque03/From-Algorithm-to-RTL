#!/bin/bash
set -euo pipefail
set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

LLVM_BIN_DIR=/home/mahfuz/circt/llvm/build/bin
CIRCT_BIN_DIR=/home/mahfuz/circt/build/bin

# Tools (override if needed)
MLIR_OPT="${LLVM_BIN_DIR}/mlir-opt"
CIRCT_OPT="${CIRCT_BIN_DIR}/circt-opt"
CIRCT_TRANSLATE="${CIRCT_BIN_DIR}/circt-translate"
FILE_NAME="gelu"

# Inputs / outputs
IN_MLIR="$SCRIPT_DIR/Input/${FILE_NAME}.mlir"
OUT_DIR="$SCRIPT_DIR"
TOP_FUNC="${TOP_FUNC:-forward}"   # <-- change to your entry function

# Step outputs
LINALG_TENSOR="$SCRIPT_DIR/0.${FILE_NAME}-linalg.mlir"
SCF_MLIR="$SCRIPT_DIR/${FILE_NAME}-scf.mlir"
CALYX_MLIR="$SCRIPT_DIR/${FILE_NAME}-calyx.mlir"
FUTIL="$SCRIPT_DIR/${FILE_NAME}-futil.futil"
VERILOG_OUT="$SCRIPT_DIR/Output/${FILE_NAME}.sv"

# If fud2 is not in PATH, set it explicitly:
FUD2_BIN="${FUD2_BIN:-fud2}"


# Basic checks
[[ -f "$IN_MLIR" ]] || { echo "Missing input MLIR: $IN_MLIR"; exit 1; }
[[ -x "$MLIR_OPT" ]] || { echo "Missing mlir-opt at: $MLIR_OPT"; exit 1; }
[[ -x "$CIRCT_OPT" ]] || { echo "Missing circt-opt at: $CIRCT_OPT"; exit 1; }
[[ -x "$CIRCT_TRANSLATE" ]] || { echo "Missing circt-translate at: $CIRCT_TRANSLATE"; exit 1; }
command -v "$FUD2_BIN" >/dev/null 2>&1 || { echo "fud2 not found (set FUD2_BIN=/path/to/fud2)"; exit 1; }

# -----------------------------
# 0) Your existing step
# -----------------------------
"$MLIR_OPT" \
  "$IN_MLIR" \
  -o "$LINALG_TENSOR"

 #1) Lower toward SCF
"$MLIR_OPT" \
  "$LINALG_TENSOR" \
  --buffer-results-to-out-params="modify-public-functions hoist-static-allocs " \
  --canonicalize \
  --cse \
  --arith-expand \
  --convert-linalg-to-loops \
  --lower-affine \
  -o $OUT_DIR/1.${FILE_NAME}-scf.mlir
  

# 2)Flatte memory
"$CIRCT_OPT" \
  $OUT_DIR/1.${FILE_NAME}-scf.mlir \
  -flatten-memref \
  -arc-inline \
  -symbol-dce \
  -o $OUT_DIR/2.${FILE_NAME}-scf-flat.mlir
  
# 3)Generate calyx IR
$CIRCT_BIN_DIR/hlstool --calyx-hw  --output-level=core --ir --allow-unregistered-dialects $OUT_DIR/2.${FILE_NAME}-scf-flat.mlir -o 3.${FILE_NAME}-calyx.mlir

# 4)Extracts the CalyxIR representation
$CIRCT_BIN_DIR/circt-translate --export-calyx 3.${FILE_NAME}-calyx.mlir -o 4.${FILE_NAME}.futil

# 5)Lower control logic and emit SystemVerilog
calyx -l ~/calyx -b verilog 4.${FILE_NAME}.futil > $VERILOG_OUT

echo "-------------------- Successfully generated SystemVerilog ---------------------"


