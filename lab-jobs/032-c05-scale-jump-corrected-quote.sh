#!/usr/bin/env bash
set -euo pipefail
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/031-c05-scale-jump-corrected.sh"
TMP="${RUNNER_TEMP:-/tmp}/032-c05-scale-jump-corrected.sh"
[[ -f "$BASE" ]] || { echo "HARNESS_INVALID: missing $BASE" >&2; exit 90; }
python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()
old="inject=r'''src=src[:phase_start]+phases+src[phase_end:]"
new='inject=r"""src=src[:phase_start]+phases+src[phase_end:]'
if s.count(old)!=1: raise SystemExit('HARNESS_INVALID: opening quote anchor mismatch')
s=s.replace(old,new,1)
old="# Retain the original evidence-copy envelope, then replace the analyzer tail.'''"
new='# Retain the original evidence-copy envelope, then replace the analyzer tail."""'
if s.count(old)!=1: raise SystemExit('HARNESS_INVALID: closing quote anchor mismatch')
s=s.replace(old,new,1)
Path(sys.argv[2]).write_text(s)
PY
chmod +x "$TMP"
printf '%s\n' 'C05-029 attempt-3 correction=Python generator quoting only; split-sampler transport and frozen Gates A-H unchanged.'
exec bash "$TMP"
