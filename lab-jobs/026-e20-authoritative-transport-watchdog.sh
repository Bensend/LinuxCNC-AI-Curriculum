#!/usr/bin/env bash
set -euo pipefail

# E20-001 independent AUTHORITATIVE execution.
# The frozen source target, numeric contract, P0-P8 and Gates A-J are defined in
# experiments/E20-001-transport-watchdog-recovery-boundaries.md.
# This job deliberately reuses the already-preflighted fixture without retuning it.
# Frozen gates are scored only after independent inspection of this run's retained artifact.

SRC="lab-jobs/025-e20-transport-watchdog-preflight.sh"
[[ -f "$SRC" ]] || { echo "Missing frozen/preflighted fixture: $SRC" >&2; exit 2; }
TMP="${RUNNER_TEMP:-/tmp}/e20-026-authoritative.sh"

python3 - "$SRC" "$TMP" <<'PY'
from pathlib import Path
import sys
src=Path(sys.argv[1]).read_text()
repl={
    '# E20-001 NON-AUTHORITATIVE preflight.':'# E20-001 AUTHORITATIVE independent execution.',
    'This script validates runtime/harness/evidence only.':'This script executes the frozen, already-preflighted fixture independently; Gates A-J are scored later from the retained artifact.',
    'linuxcnc-e20-preflight':'linuxcnc-e20-authoritative',
    'e20-025-preflight-evidence':'e20-026-authoritative-evidence',
    'E20-025 NON-AUTHORITATIVE PREFLIGHT':'E20-026 AUTHORITATIVE EXECUTION',
    'Frozen Gates A-J remain UNSCORED in this preflight.':'Frozen Gates A-J must be scored only after independent retained-artifact inspection.',
    '== E20 frozen transport/watchdog recovery-boundary preflight ==':'== E20 frozen transport/watchdog recovery-boundary authoritative execution ==',
    'E20-025 PREFLIGHT RUNTIME PREDICATES PASS':'E20-026 AUTHORITATIVE RUNTIME PREDICATES PASS',
    'NOTE: this preflight does not prove Ethernet physics, Mesa stopping behavior, or functional safety. Frozen Gates A-J remain UNSCORED.':'NOTE: this run does not prove Ethernet physics, exact Mesa-output timing, or functional safety. Frozen Gates A-J require independent artifact scoring.',
    'E20-025 EVIDENCE-RETENTION PREFLIGHT PASS; frozen Gates A-J remain UNSCORED.':'E20-026 AUTHORITATIVE EVIDENCE PACKAGE PRODUCED; score frozen Gates A-J only from retained artifact.'
}
for a,b in repl.items():
    if a not in src:
        raise SystemExit(f'expected frozen-fixture marker missing: {a!r}')
    src=src.replace(a,b)
Path(sys.argv[2]).write_text(src)
PY
chmod +x "$TMP"

# Preserve the exact generator used for this authoritative invocation so the
# fixture identity and textual transformation are independently auditable.
REAL_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
RUN_DIR="${REAL_WORKSPACE}/lab-results/run-${GITHUB_RUN_ID:?}-${GITHUB_RUN_ATTEMPT:?}"
mkdir -p "$RUN_DIR/e20-026-authoritative-wrapper"
cp "$SRC" "$RUN_DIR/e20-026-authoritative-wrapper/preflighted-fixture-source.sh"
cp "$TMP" "$RUN_DIR/e20-026-authoritative-wrapper/generated-authoritative-fixture.sh"
printf '%s\n' \
  'E20-026 authoritative wrapper' \
  'Transformation only changes classification/output labels and work-directory names.' \
  'Numeric contract, component logic, HAL topology, P0-P8 and runtime assertions are inherited unchanged from 025.' \
  > "$RUN_DIR/e20-026-authoritative-wrapper/lineage.txt"

exec bash "$TMP"
