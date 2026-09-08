#!/usr/bin/env bash
set -euo pipefail

# C03-025 attempt 3. Gates A-H, control parameters, thresholds and decisive
# phase durations remain frozen. Only phase-instrumentation publication is
# corrected. See results/C03-025-attempt-2-reconciliation.md.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
SRC="$ROOT/lab-jobs/025-c03-explicit-cross-coupling.sh"
TMP="${RUNNER_TEMP:-/tmp}/025-c03-explicit-cross-coupling-attempt3-inner.sh"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()
repls={
"halcmd sets c03-plant-b-gain 0.25\nhalcmd sets c03-phase 2":
"# Withdraw the old phase before mutating configuration. Phase 0 is unscored transition instrumentation.\nhalcmd sets c03-phase 0\nsleep 0.020\nhalcmd sets c03-plant-b-gain 0.25\nsleep 0.020\nhalcmd sets c03-phase 2",
"halcmd sets c03-kc 0.5\nhalcmd sets c03-phase 3":
"halcmd sets c03-phase 0\nsleep 0.020\nhalcmd sets c03-kc 0.5\nsleep 0.020\nhalcmd sets c03-phase 3",
"halcmd sets c03-kc 0\nhalcmd sets c03-phase 4":
"halcmd sets c03-phase 0\nsleep 0.020\nhalcmd sets c03-kc 0\nsleep 0.020\nhalcmd sets c03-phase 4",
}
for old,new in repls.items():
    count=s.count(old)
    if count != 1:
        raise SystemExit(f'HARNESS_INVALID: expected exactly one frozen phase sequence match, got {count}: {old!r}')
    s=s.replace(old,new)
p.write_text(s)
PY

printf '%s\n' '== C03-025 attempt-3 correction preflight =='
printf '%s\n' 'frozen-gates=A-H unchanged'
printf '%s\n' 'changed-only=phase0 transition isolation plus 20ms pre/post configuration settle'
grep -n -B5 -A4 -E 'sets c03-phase [234]' "$TMP"
printf 'attempt3-inner-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
