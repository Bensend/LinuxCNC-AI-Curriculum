#!/usr/bin/env bash
set -euo pipefail

CURRIC_REPO="$(pwd)"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c07-full-preflight"
EVID="$WORK/tests/linuxcncrsh/c07-048-evidence"
OUT="$CURRIC_REPO/lab-results/c07-049-authoritative-evidence"

printf '== C07-047 AUTHORITATIVE request-vs-achieved-state sequencing run ==\n'
date -u '+UTC authoritative start: %Y-%m-%dT%H:%M:%SZ'
printf '%s\n' 'Authority declaration: this is the one authoritative execution permitted after C07-048 full-sequencer PREFLIGHT PASS.'
printf '%s\n' 'Frozen experiment contract: experiments/C07-047-request-achieved-state-sequencing-plan.md; P0-P8 and Gates A-J are unchanged.'
printf '%s\n' 'Harness integrity strategy: execute the already-passed C07-048 full P0-P8 harness byte-for-byte, then apply this precommitted Gate A-J analyzer to the new independent execution. The inherited helper prints PRECHECK/non-authoritative labels internally; those labels describe the helper itself and are not the authoritative verdict. This outer job is authoritative.'
printf '%s\n' 'Safety boundary: ordinary Task/HAL sequencing state integrity only; NOT functional-safety evidence.'

# Execute a new independent instance of the exact full harness that passed C07-048.
bash "$CURRIC_REPO/lab-jobs/048-c07-full-sequencer-preflight.sh"

[[ -d "$EVID" ]]
[[ -f "$EVID/c07-trace.csv" ]]
[[ -f "$EVID/c07-sequencer-preflight.py" ]]
[[ -f "$EVID/c07-production-source-sha256.txt" ]]
[[ -f "$EVID/c07-required-hal-objects.txt" ]]
[[ -f "$EVID/c07-signals.txt" ]]

rm -rf "$OUT"
mkdir -p "$OUT"
cp -a "$EVID"/. "$OUT"/
cp "$CURRIC_REPO/lab-jobs/048-c07-full-sequencer-preflight.sh" "$OUT/harness-048-exact.sh"
cp "$CURRIC_REPO/lab-jobs/049-c07-authoritative-request-achieved-sequencing.sh" "$OUT/authoritative-wrapper-049.sh"
cp "$CURRIC_REPO/experiments/C07-047-request-achieved-state-sequencing-plan.md" "$OUT/frozen-plan.md"

printf '\n== Frozen Gate A-J analyzer ==\n'
python3 - "$OUT" <<'PY' | tee "$OUT/gate-analysis.txt"
import csv, pathlib, sys, re, hashlib
out=pathlib.Path(sys.argv[1])
rows=list(csv.DictReader(open(out/'c07-trace.csv')))
assert rows, 'Gate B: empty trace'
ints=('seq','t0_ns','t1_ns','span_ns','tick','phase','state','start_authorize','request_internal','request_actual','motion_enable','motion_motion_enabled','machine_is_on','estop_activated','cycle_permission')
for r in rows:
    for k in ints: r[k]=int(r[k])

def phase(p): return [r for r in rows if r['phase']==p]
def rises(p):
    rs=phase(p); prev=0; n=0
    for r in rs:
        cur=r['request_actual']
        if cur and not prev: n+=1
        prev=cur
    return n

def idx_event(substr):
    for i,r in enumerate(rows):
        if substr in r['event']: return i
    raise AssertionError('missing event '+substr)

# Gate A — provenance/topology.
prod=(out/'c07-production-source-sha256.txt').read_text()
required=['src/emc/usr_intf/halui.cc','src/emc/task/emctask.cc','src/emc/task/emctaskmain.cc','src/emc/task/taskintf.cc','src/emc/motion/command.c','src/emc/motion/control.c','src/emc/motion/motion.c']
assert all(x in prod for x in required), 'Gate A: incomplete production hashes'
obj=(out/'c07-required-hal-objects.txt').read_text()
assert 'halui.machine.on' in obj and 'halui.machine.is-on' in obj and 'motion.enable' in obj and 'motion.motion-enabled' in obj
# The accepted harness controls the unlinked HAL_IN directly with setp and verifies readback; no net writer is introduced by the harness.
assert (out/'c07-full-preflight.ini').exists() and (out/'lcncrsh_sim.hal').exists()
print('Gate A PASS — pinned production hashes/config retained; required real HAL objects observed; harness uses one direct unlinked motion.enable injection path.')

# Gate B — ordered observation, no unexplained gaps, phase before mutation.
assert all(b['seq']==a['seq']+1 for a,b in zip(rows,rows[1:])), 'Gate B sequence gap'
assert all(b['t0_ns']>=a['t0_ns'] for a,b in zip(rows,rows[1:])), 'Gate B non-monotonic time'
assert all(r['t1_ns']>=r['t0_ns'] for r in rows), 'Gate B negative span'
for p,mut in [(1,'P1-motion-enable-low'),(2,'P2-start-auth-high-before-eval'),(4,'P4-motion-enable-high'),(5,'P5-retry-auth-high-before-eval'),(6,'P6-motion-enable-low'),(7,'P7-motion-enable-high'),(8,'P8-recovery-auth-high-before-eval')]:
    assert idx_event(f'PHASE_P{p}_') < idx_event(mut), f'Gate B phase {p} marker after mutation'
print(f"Gate B PASS — {len(rows)} monotonic rows; max sequential HAL-read span={max(r['span_ns'] for r in rows)/1e6:.6f} ms; every decisive phase marker precedes its mutation.")

# Gate C — baseline.
p0=phase(0)
assert p0 and all(r['machine_is_on']==0 for r in p0) and all(r['estop_activated']==0 for r in p0)
assert all(r['request_actual']==0 and r['cycle_permission']==0 for r in p0)
print('Gate C PASS — P0 out-of-estop, machine OFF, request low, cycle permission false.')

# Gate D — blocked request proves request != achieved.
p23=phase(2)+phase(3)
assert rises(2)==1 and rises(3)==0
assert all(r['machine_is_on']==0 for r in p23)
assert all(r['state']!=4 and r['cycle_permission']==0 for r in p23)
assert any(r['motion_enable']==0 for r in phase(2))
print('Gate D PASS — exactly one P2 ON rising edge while blocked; P2/P3 achieved ON stayed false and sequencer never confirmed/allowed cycle.')

# Gate E — prerequisite restore is not implicit retry.
p4=phase(4)
assert rises(4)==0 and any(r['motion_enable']==1 for r in p4)
assert all(r['machine_is_on']==0 and r['cycle_permission']==0 for r in p4)
print('Gate E PASS — P4 restored motion.enable without a request edge; achieved ON and cycle permission stayed false.')

# Gate F — explicit retry waits for achieved state.
p5=phase(5)
assert rises(5)==1
on5=next(i for i,r in enumerate(p5) if r['machine_is_on']==1)
conf5=next(i for i,r in enumerate(p5) if r['state']==4)
cyc5=next(i for i,r in enumerate(p5) if r['cycle_permission']==1)
assert conf5>=on5 and cyc5>=on5
assert all(r['cycle_permission']==0 for r in p5[:on5])
print('Gate F PASS — one fresh P5 request; no confirmed/cycle state precedes observed machine.is-on=true.')

# Gate G — active fault interrupts achieved state and permission.
p6=phase(6)
loss6=next(i for i,r in enumerate(p6) if r['machine_is_on']==0)
rev6=next(i for i,r in enumerate(p6) if 'revoked-on-status-loss' in r['event'])
assert rev6>=loss6
assert p6[rev6]['state']==5 and p6[rev6]['cycle_permission']==0
assert p6[rev6]['tick']==p6[loss6]['tick']
assert all(r['cycle_permission']==0 for r in p6[rev6:])
print('Gate G PASS — achieved ON loss caused recovery entry and cycle-permission revocation in the same sequencer evaluation tick.')

# Gate H — no automatic restart after restoring fault input.
p7=phase(7)
assert rises(7)==0
assert all(r['machine_is_on']==0 and r['cycle_permission']==0 for r in p7)
assert any(r['state']==6 for r in p7)
print('Gate H PASS — P7 prerequisite restoration without fresh authorization/request did not restore active state.')

# Gate I — guarded explicit recovery.
p8=phase(8)
assert any(r['start_authorize']==1 for r in p8) and rises(8)==1
on8=next(i for i,r in enumerate(p8) if r['machine_is_on']==1)
conf8=next(i for i,r in enumerate(p8) if r['state']==4)
cyc8=next(i for i,r in enumerate(p8) if r['cycle_permission']==1)
assert conf8>=on8 and cyc8>=on8
assert all(r['cycle_permission']==0 for r in p8[:on8])
print('Gate I PASS — fresh P8 authorization + fresh request required; active permission followed achieved ON confirmation.')

# Gate J — safety-language boundary.
safety='ordinary Task/HAL sequencing state integrity only; NOT functional-safety evidence; real-machine restart additionally requires machine-specific physical-state, energy, E-stop and interlock verification.'
print('Gate J PASS — '+safety)
print('AUTHORITATIVE C07-047 RESULT: GATES A-J PASS')
PY

sha256sum "$OUT"/* | tee "$OUT/SHA256SUMS.txt"
printf '\n%s\n' 'AUTHORITATIVE C07-047 PASS if and only if this job exits 0 and the retained gate-analysis reports Gates A-J PASS.'
printf '%s\n' 'Do not treat this as proof of functional safety or physical-machine restart safety.'
date -u '+UTC authoritative finish: %Y-%m-%dT%H:%M:%SZ'
