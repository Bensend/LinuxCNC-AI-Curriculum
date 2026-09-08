#!/usr/bin/env bash
set -euo pipefail

# C05-028 attempt 2 harness-only correction.
# The frozen behavioral plan remains experiments/C05-028-feedback-freeze-plan.md.
# Attempt 1 linked mux sel0 to signal c05-sensor-freeze for same-cycle sampling,
# then incorrectly tried to setp the linked pin. This wrapper changes runtime
# writes to sets on that already-existing signal and fixes scalar freeze parsing.

ROOT="${GITHUB_WORKSPACE:-$PWD}"
SRC="$ROOT/lab-jobs/028-c05-feedback-freeze.sh"
TMP="${RUNNER_TEMP:-/tmp}/029-c05-feedback-freeze-corrected-body.sh"

[[ -f "$SRC" ]] || { echo "HARNESS_INVALID: missing source harness $SRC" >&2; exit 90; }

python3 - "$SRC" "$TMP" <<'PY'
from pathlib import Path
import sys
src=Path(sys.argv[1]).read_text()
old=src
src=src.replace('halcmd setp c05-sensor-b.sel0 false', 'halcmd sets c05-sensor-freeze false')
src=src.replace('halcmd setp c05-sensor-b.sel0 true', 'halcmd sets c05-sensor-freeze true')
src=src.replace('FREEZE="$(halcmd gets c05-true-b | awk \'{print $2}\')"', 'FREEZE="$(halcmd gets c05-true-b | tr -d \'[:space:]\')"')
if src == old:
    raise SystemExit('HARNESS_INVALID: correction substitutions made no changes')
if 'halcmd setp c05-sensor-b.sel0 ' in src:
    raise SystemExit('HARNESS_INVALID: direct writes to linked sel0 remain')
if "awk '{print $2}'" in src and 'c05-true-b' in src:
    raise SystemExit('HARNESS_INVALID: stale freeze parser remains')
# Add an explicit scalar-float validation immediately before publishing freeze.
needle='halcmd sets c05-freeze-value "$FREEZE"'
replacement='''python3 - "$FREEZE" <<'PYVAL'\nimport math,sys\ntry:\n    v=float(sys.argv[1])\nexcept Exception:\n    raise SystemExit('HARNESS_INVALID: freeze capture is not a scalar float')\nif not math.isfinite(v):\n    raise SystemExit('HARNESS_INVALID: freeze capture is non-finite')\nprint(f'validated-freeze-capture={v:.12g}')\nPYVAL\nhalcmd sets c05-freeze-value "$FREEZE"'''
if needle not in src:
    raise SystemExit('HARNESS_INVALID: freeze publication anchor missing')
src=src.replace(needle,replacement,1)
Path(sys.argv[2]).write_text(src)
PY

chmod +x "$TMP"
printf '%s\n' 'C05-028 attempt-2 correction=selector writes use sampled HAL signal; freeze capture parsed/validated as scalar; frozen Gates A-H unchanged.'
printf 'source-harness-sha256=%s\n' "$(sha256sum "$SRC" | awk '{print $1}')"
printf 'corrected-body-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
