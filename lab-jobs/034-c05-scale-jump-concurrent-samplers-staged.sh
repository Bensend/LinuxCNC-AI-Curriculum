#!/usr/bin/env bash
set -euo pipefail
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/033-c05-scale-jump-concurrent-samplers.sh"
TMP="${RUNNER_TEMP:-/tmp}/034-c05-scale-jump-concurrent-samplers.sh"
[[ -f "$BASE" ]] || { echo "HARNESS_INVALID: missing $BASE" >&2; exit 90; }
python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()
old='mkdir -p "$TMPROOT/root/lab-jobs"\n\n# 032 expects 031 at ROOT/lab-jobs.'
new='mkdir -p "$TMPROOT/root/lab-jobs"\ncp "$ROOT/lab-jobs/028-c05-feedback-freeze.sh" "$TMPROOT/root/lab-jobs/028-c05-feedback-freeze.sh"\n\n# 032 expects 031 at ROOT/lab-jobs.'
if s.count(old)!=1: raise SystemExit('HARNESS_INVALID: 034 staging anchor mismatch')
s=s.replace(old,new,1)
Path(sys.argv[2]).write_text(s)
PY
chmod +x "$TMP"
printf '%s\n' 'C05-029 redesigned transport staging repair only; inherited 028 source copied into isolated generator root; frozen behavior unchanged.'
exec bash "$TMP"
