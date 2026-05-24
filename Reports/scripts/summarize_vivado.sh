#!/usr/bin/env bash
set -u

SV_FILE="${1:-}"
RDIR="${2:-$HOME/vivado_run/reports}"
if [[ -z "$SV_FILE" ]]; then
  echo "Usage: $0 /path/to/design.sv [reports_dir]" >&2
  exit 1
fi

DESIGN="$(basename "$SV_FILE" .sv)"

UTIL="$RDIR/${DESIGN}_util_route.rpt"
PWRR="$RDIR/${DESIGN}_power_route_est.rpt"
TIM="$RDIR/${DESIGN}_timing_route.rpt"
CLK="$RDIR/${DESIGN}_clocks.rpt"

# Util pipe-table rows: | Slice LUTs | 64 | ...
get_pipe_used() {
  local label="$1" file="$2"
  [[ -f "$file" ]] || { echo "NA"; return; }
  awk -v lab="$label" 'BEGIN{FS="|"}
    {
      gsub(/^[ \t]+|[ \t]+$/, "", $2)
      if ($2 == lab) {
        gsub(/^[ \t]+|[ \t]+$/, "", $3)
        gsub(/,/, "", $3)
        print ($3 ~ /^[0-9]+$/ ? $3 : "NA")
        exit
      }
    }' "$file" 2>/dev/null | head -1
}

LUT="$(get_pipe_used "Slice LUTs" "$UTIL")"
FF="$(get_pipe_used "Slice Registers" "$UTIL")"
BRAM="$(get_pipe_used "Block RAM Tile" "$UTIL")"
DSP="$(get_pipe_used "DSPs" "$UTIL")"

# Power
PWR="NA"
if [[ -f "$PWRR" ]]; then
  PWR="$(awk '/Total On-Chip Power/ {for(i=1;i<=NF;i++) if($i~/^[0-9.]+$/){print $i; exit}}' "$PWRR" | head -1)"
  [[ -n "${PWR:-}" ]] || PWR="NA"
fi

# Period from report_clocks (ns) for clk
PERIOD="NA"
if [[ -f "$CLK" ]]; then
  PERIOD="$(awk '$1=="clk" && $2 ~ /^[0-9.]+$/ {print $2; exit}' "$CLK" 2>/dev/null | head -1)"
  [[ -n "${PERIOD:-}" ]] || PERIOD="NA"
fi

# WNS from report_timing_summary (ns):
# After the first header line containing "WNS(ns) TNS(ns) ..." take next data line and
# extract the first numeric field.
WNS="NA"
if [[ -f "$TIM" ]]; then
  WNS="$(awk '
    found && NF>0 {
      for (i=1;i<=NF;i++) if ($i ~ /^-?[0-9.]+$/) {print $i; exit}
    }
    /WNS\(ns\)[[:space:]]+TNS\(ns\)/ {found=1; next}
  ' "$TIM" 2>/dev/null | head -1)"
  [[ -n "${WNS:-}" ]] || WNS="NA"
fi

# Fmax = 1000 / (Period - WNS)
FMAX="NA"
if [[ "$PERIOD" != "NA" && "$WNS" != "NA" ]]; then
  FMAX="$(python3 - <<PY
try:
  p=float("$PERIOD"); w=float("$WNS")
  minp=p-w
  print("NA" if minp<=0 else f"{1000.0/minp:.3f}")
except Exception:
  print("NA")
PY
)"
fi

echo "Design LUT FF BRAM DSP Power(W) Fmax(MHz)"
echo "${DESIGN} ${LUT} ${FF} ${BRAM} ${DSP} ${PWR} ${FMAX}"
