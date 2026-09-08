#!/usr/bin/env bash
set -euo pipefail

# C05-029 attempt 11. Reuse reviewed attempt-10 script, changing only the
# generator's obs_shell from raw-string to normal-string semantics so repr()'s
# escaped newlines become actual generated shell line boundaries.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/039-c05-scale-jump-atomic-precision-sed.sh"
TMP="${RUNNER_TEMP:-/tmp}/040-c05-scale-jump-atomic-precision-final.sh"
[[ -f "$BASE" ]] || { echo "HARNESS_INVALID: missing $BASE" >&2; exit 90; }

python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()
old="obs_shell = r''' + repr("
new="obs_shell = ''' + repr("
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: 040 raw-string anchor count={s.count(old)}')
s=s.replace(old,new,1)
s=s.replace('C05-029 attempt 10:', 'C05-029 attempt 11:', 1)
Path(sys.argv[2]).write_text(s)
PY
chmod +x "$TMP"
printf '%s\n' 'C05-029 attempt 11: corrected generated observer newline semantics only; frozen behavior and one-FIFO architecture unchanged.'
printf 'base-039-sha256=%s\n' "$(sha256sum "$BASE" | awk '{print $1}')"
printf 'patched-040-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
