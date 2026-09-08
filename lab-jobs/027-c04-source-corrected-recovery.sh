#!/usr/bin/env bash
set -euo pipefail

# C04-027 implementation from frozen source-corrected recovery plan.
# C04-026 remains preserved as a valid behavioral failure.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
SRC="$ROOT/lab-jobs/026-c04-asymmetric-authority.sh"
TMP="${RUNNER_TEMP:-/tmp}/027-c04-source-corrected-recovery-outer.sh"
EVID="$ROOT/lab-results/c04-027-evidence"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
rm -rf "$EVID"
mkdir -p "$RUN_EVID"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()

# Independent identifiers/evidence.
s=s.replace('c04-026','c04-027').replace('C04-026','C04-027')

# Established observation correction from C04-026 reconciliation.
old="ok=(r[18]==1 and abs(r[8]-1.0)<=1e-9) # outB index 8; positive move"
new="ok=(r[18]==1 and abs(r[9]-1.0)<=1e-9) # outB index 9; positive move"
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

# Source-corrected phase-4 recovery sentinel: finite/nonbinding so calc_pid()
# executes the branch that explicitly clears limit_state.
old='''halcmd sets c04-plant-b-gain 1.0
halcmd sets c04-b-maxoutput 0
sleep 0.020
halcmd sets c04-phase 4'''
new='''halcmd sets c04-plant-b-gain 1.0
halcmd sets c04-b-maxoutput 1000.0
sleep 0.020
halcmd sets c04-phase 4'''
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

old="expect={1:(1.0,0.0),2:(0.35,0.0),3:(0.35,1.0),4:(1.0,0.0)}"
new="expect={1:(1.0,0.0),2:(0.35,0.0),3:(0.35,1.0),4:(1.0,1000.0)}"
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

old="p4_unsat=sum(1 for r in w[4] if r[18]==0)/len(w[4])"
new="""p4_unsat=sum(1 for r in w[4] if r[18]==0)/len(w[4])
p4_count_zero=sum(1 for r in w[4] if r[19]==0)/len(w[4])
p4_nonbinding=sum(1 for r in by[4] if abs(r[9])<1000.0)/len(by[4])"""
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

old="print(f'phase-4-b-unsaturated-fraction-last500={p4_unsat:.12g}')"
new="""print(f'phase-4-b-unsaturated-fraction-last500={p4_unsat:.12g}')
print(f'phase-4-b-saturated-count-zero-fraction-last500={p4_count_zero:.12g}')
print(f'phase-4-b-nonbinding-output-fraction={p4_nonbinding:.12g}')"""
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

old="gate('G',S[3]>=0.10 and p4_unsat>=0.99 and S[4]<=0.60*S[3])"
new="gate('G',S[3]>=0.10 and p4_unsat>=0.99 and p4_count_zero>=0.99 and p4_nonbinding>=1.0 and S[4]<=0.60*S[3])"
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

old="print('source-reconciliation=maxoutput clamps local PID output and drives limit_state/saturated telemetry; same-direction integral update is held while limited; integ gain scales only the toy plant derivative')"
new="print('source-reconciliation=maxoutput nonzero executes limit_state update; maxoutput zero skips that update at the pinned revision; finite nonbinding phase-4 sentinel traverses the explicit limit_state-clear path; integ gain scales only the toy plant derivative')"
assert s.count(old)==1, s.count(old)
s=s.replace(old,new)

p.write_text(s)
PY

printf '%s\n' '== C04-027 frozen implementation preflight =='
printf '%s\n' 'source-plan=experiments/C04-027-source-corrected-recovery-plan.md'
printf '%s\n' 'phase-1-through-3=C04-026 values unchanged'
printf '%s\n' 'phase-4-b-maxoutput=1000.0 source-corrected finite nonbinding sentinel'
grep -n -E 'outB index 9|b-maxoutput 1000|4:\(1.0,1000.0\)|p4_count_zero|p4_nonbinding' "$TMP"
printf 'c04-027-outer-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"

set +e
bash "$TMP"
STATUS=$?
set -e

for f in c04-027-realtime.txt c04-linuxcnc.stdout c04-linuxcnc.stderr c04-027-halsampler.stderr; do
  if [[ ! -f "$EVID/$f" ]]; then
    printf 'HARNESS_INVALID: fresh post-run evidence missing: %s\n' "$f" >&2
    exit 32
  fi
  cp "$EVID/$f" "$RUN_EVID/$f"
  printf 'post-run-retained-evidence=%s sha256=%s bytes=%s\n' "$f" "$(sha256sum "$EVID/$f" | awk '{print $1}')" "$(wc -c < "$EVID/$f")"
done
printf 'post-run-retained-realtime-lines=%s\n' "$(wc -l < "$EVID/c04-027-realtime.txt")"
printf 'inner-status=%s\n' "$STATUS"
exit "$STATUS"
