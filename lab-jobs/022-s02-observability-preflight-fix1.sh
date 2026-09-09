#!/usr/bin/env bash
set -euo pipefail

# S02 frozen observability preflight attempt 2.
# Attempt 1 failed before P0 because halcompile normalizes exported HAL
# identifiers from underscores to hyphens. This wrapper changes only exported
# HAL object references s02_model.0 -> s02-model.0. Frozen P0-P5, Gates A-J and
# every predeclared numeric threshold/latency remain unchanged and UNSCORED.

BASE="lab-jobs/021-s02-observability-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/s02-022-preflight.sh"

python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys
src,dst=map(Path,sys.argv[1:])
s=src.read_text()
count=s.count('s02_model.0')
assert count >= 10, count
s=s.replace('s02_model.0','s02-model.0')
# Preserve module/file/component source tokens; only runtime HAL object names change.
assert 'loadrt s02_model\n' in s
assert 'component s02_model ' in s
assert 's02_model.0' not in s

dst.write_text(s)
print(f'S02-022 applied exported-HAL-name correction to {count} references only.')
PY

chmod +x "$TMP"
printf '%s\n' 'S02-022: attempt 2; HAL exported-name correction only; frozen P0-P5/Gates A-J and numeric contract unchanged; Gates remain UNSCORED.'
exec bash "$TMP"
