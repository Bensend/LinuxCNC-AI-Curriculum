#!/usr/bin/env bash
set -euo pipefail

# Harness-only execution-mode correction to the materially redesigned 070 path.
# 070 completed its outer transformation but temp-file execute permission blocked
# before the generated validator or LinuxCNC ran. Invoke the exact 070 logic via
# bash instead; no frozen PB-PREP behavioral content changes.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/070-pb-prep-001-p2-p7-render-validated-packed.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-071-execfix.sh"
cp "$SRC" "$FIXED"

python3 - "$FIXED" <<'PATCH071'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
old='exec "$GEN"\n'
new='exec bash "$GEN"\n'
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: expected one generator exec, found {s.count(old)}')
s=s.replace(old,new,1)
p.write_text(s)
PATCH071

bash -n "$FIXED"
printf '%s\n' 'PB-PREP-001 071: temp generator will be invoked through bash; frozen behavioral contract unchanged.'
exec bash "$FIXED"
