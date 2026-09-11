#!/usr/bin/env bash
set -euo pipefail

# Execute EXACTLY the flattened behavioral script retained by successful 076.
# No source rewriting is permitted here. The digest binds execution to the
# preflight-audited artifact; any drift is HARNESS INVALID before LinuxCNC.

SCRIPT="${GITHUB_WORKSPACE:?}/lab-results/pb-prep-001-076-preflight/behavioral-rendered.sh"
EXPECTED="7c185fb0af4b056d7e9406de164a79ae6eb30d06510a6b3ce77ed12d46c4a0e6"
[[ -f "$SCRIPT" ]] || { echo 'HARNESS_INVALID: retained 076 rendered script missing' >&2; exit 41; }
ACTUAL="$(sha256sum "$SCRIPT" | awk '{print $1}')"
[[ "$ACTUAL" == "$EXPECTED" ]] || { echo "HARNESS_INVALID: retained script digest drift expected=$EXPECTED actual=$ACTUAL" >&2; exit 42; }
bash -n "$SCRIPT"
printf '%s\n' "PB-PREP-001 077 retained-render digest verified: $ACTUAL"
printf '%s\n' 'PB-PREP-001 077 executing exact 076-preflighted script; frozen behavioral contract unchanged.'
exec bash "$SCRIPT"
