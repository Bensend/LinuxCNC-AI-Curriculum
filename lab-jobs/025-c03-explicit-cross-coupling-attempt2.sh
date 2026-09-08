#!/usr/bin/env bash
set -euo pipefail

# C03-025 attempt 2. Gates A-H and all control parameters/thresholds remain
# frozen. The only correction is to establish each userspace-written
# configuration value before publishing the new phase label to realtime
# sampling. See results/C03-025-attempt-1-reconciliation.md.

ROOT="${GITHUB_WORKSPACE:-$PWD}"
SRC="$ROOT/lab-jobs/025-c03-explicit-cross-coupling.sh"
TMP="${RUNNER_TEMP:-/tmp}/025-c03-explicit-cross-coupling-attempt2-inner.sh"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()
repls={
"halcmd sets c03-plant-b-gain 0.25\nhalcmd sets c03-phase 2":
"halcmd sets c03-plant-b-gain 0.25\n# Attempt-2 observation correction: let the realtime thread observe the new configuration before publishing phase 2.\nsleep 0.020\nhalcmd sets c03-phase 2",
"halcmd sets c03-kc 0.5\nhalcmd sets c03-phase 3":
"halcmd sets c03-kc 0.5\n# Attempt-2 observation correction: publish phase only after Kc is established.\nsleep 0.020\nhalcmd sets c03-phase 3",
"halcmd sets c03-kc 0\nhalcmd sets c03-phase 4":
"halcmd sets c03-kc 0\n# Attempt-2 observation correction: publish phase only after Kc removal is established.\nsleep 0.020\nhalcmd sets c03-phase 4",
}
for old,new in repls.items():
    count=s.count(old)
    if count != 1:
        raise SystemExit(f'HARNESS_INVALID: expected exactly one frozen phase sequence match, got {count}: {old!r}')
    s=s.replace(old,new)
p.write_text(s)
PY

printf '%s\n' '== C03-025 attempt-2 correction preflight =='
printf '%s\n' 'frozen-gates=A-H unchanged'
printf '%s\n' 'changed-only=20ms configuration settle before phase-2/3/4 publication'
grep -n -B2 -A4 -E 'sets c03-phase [234]' "$TMP"
printf 'attempt2-inner-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"

exec bash "$TMP"
