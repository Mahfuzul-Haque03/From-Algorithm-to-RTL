#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 file1.sv [file2.sv ...]" >&2
  exit 1
fi

for f in "$@"; do
  if [[ ! -f "$f" ]]; then
    echo "Skip (not found): $f" >&2
    continue
  fi

  # Skip if already patched (search for literal `ifndef SYNTHESIS)
  if grep -qF '`ifndef SYNTHESIS' "$f"; then
    echo "Already patched: $f"
    continue
  fi

  cp -a "$f" "${f}.bak"

  # Wrap the sim-only block starting at "string DATA;" through the matching "final begin ... end"
  perl -0777 -i -pe '
    # Only patch if there is a string and initial begin (typical calyx sim IO block)
    if ($_ !~ /\bstring\b/ || $_ !~ /\binitial\s+begin\b/) { next; }

    # Insert guards around string DATA; ... final begin ... end
    s{
      (\n\s*string\s+DATA\s*;\s*\n.*?\n\s*final\s+begin\b.*?\n\s*end\s*)
    }{
      "\n`ifndef SYNTHESIS\n$1\n`endif\n"
    }sex;
  ' "$f"

  echo "Patched: $f (backup: ${f}.bak)"
done
