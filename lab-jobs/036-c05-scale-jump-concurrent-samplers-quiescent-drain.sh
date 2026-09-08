#!/usr/bin/env bash
set -euo pipefail

# C05-029 redesigned observation transport, attempt 7.
# Final bounded termination-transport correction under the three-similar-attempt
# rule: stop realtime production once, then allow both already-running userspace
# readers the same quiescent drain interval before either is terminated.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/035-c05-scale-jump-concurrent-samplers-thread-stop.sh"
TMP="${RUNNER_TEMP:-/tmp}/036-c05-scale-jump-concurrent-samplers-quiescent-drain.sh"

[[ -f "$BASE" ]] || { echo "HARNESS_INVALID: missing $BASE" >&2; exit 90; }

python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
old="'halcmd stop\\\\nOVERRUNS=',"
new="'halcmd stop\\\\nsleep 0.250\\\\nOVERRUNS=',"
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: 036 drain patch count={s.count(old)}')
s=s.replace(old,new,1)
p.write_text(s)
PY

chmod +x "$TMP"
printf '%s\n' 'C05-029 attempt 7 correction=single 250ms quiescent post-stop drain before either concurrent reader is terminated; frozen Gates A-H and exact join unchanged.'
printf 'base-035-sha256=%s\n' "$(sha256sum "$BASE" | awk '{print $1}')"
printf 'patched-036-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
