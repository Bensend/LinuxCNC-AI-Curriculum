#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c08-trace-preflight"
EVID="lab-results/c08-051-preflight-evidence"

printf '== C08-051 diagnostic discrimination / trace-validity preflight (NON-AUTHORITATIVE) ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Predeclared prediction: P1 and P3 expose the same coarse symptom=TRUE, but the realtime trace distinguishes same-cycle cause A from cause-B-before-symptom ordering. A separate depth-4 FIFO will overrun while successful retained tags may remain contiguous.'
printf '%s\n' 'Authority boundary: implementation/topology/order/collector validity only. Frozen C08-050 Gates A-J are NOT scored here.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
./debian/configure uspace
sudo apt-get build-dep -y .
cd src
./autogen.sh
./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation
make -j"$(nproc)"
cd ..
set +u
source scripts/rip-environment
set -u

mkdir -p "$GITHUB_WORKSPACE/$EVID"
EVID_ABS="$GITHUB_WORKSPACE/$EVID"

sha256sum src/hal/components/sampler.c src/hal/components/sampler_usr.c src/hal/hal_lib.c \
  | tee "$EVID_ABS/production-source-sha256.txt"

cat > /tmp/c08diag.comp <<'COMP'
component c08diag "C08 lab-only deterministic diagnostic-cause fixture";
pin in u32 phase_cmd = 0;
pin in bit inject_a = 0;
pin in bit inject_b = 0;
pin out u32 phase = 0;
pin out bit cause_a = 0;
pin out bit cause_b = 0;
pin out bit symptom = 0;
variable int b_seen = 0;
function _;
license "GPL";
;;
FUNCTION(_) {
    phase = phase_cmd;
    if (inject_a) {
        cause_a = 1;
        cause_b = 0;
        symptom = 1;
        b_seen = 0;
    } else if (inject_b) {
        cause_a = 0;
        cause_b = 1;
        if (b_seen) {
            symptom = 1;
        } else {
            symptom = 0;
            b_seen = 1;
        }
    } else {
        cause_a = 0;
        cause_b = 0;
        symptom = 0;
        b_seen = 0;
    }
}
COMP
cp /tmp/c08diag.comp "$EVID_ABS/c08diag.comp"
halcompile --install /tmp/c08diag.comp | tee "$EVID_ABS/halcompile.log"

cleanup() {
    trap - EXIT
    if [[ -n "${MAIN_PID:-}" ]]; then kill -TERM "$MAIN_PID" 2>/dev/null || true; wait "$MAIN_PID" 2>/dev/null || true; fi
    timeout --signal=TERM --kill-after=2s 5s halcmd stop >/dev/null 2>&1 || true
    timeout --signal=TERM --kill-after=2s 5s halcmd unload all >/dev/null 2>&1 || true
    timeout --signal=TERM --kill-after=2s 8s realtime stop >/dev/null 2>&1 || true
}
trap cleanup EXIT

realtime start
halcmd loadrt threads name1=c08-thread period1=1000000
halcmd loadrt c08diag count=1
halcmd loadrt sampler depth=4,5000 cfg=b,ubbb

# Signals from the fixture outputs into both sampler channels.
halcmd net c08-phase c08diag.0.phase sampler.1.pin.0
halcmd net c08-cause-a c08diag.0.cause-a sampler.1.pin.1
halcmd net c08-cause-b c08diag.0.cause-b sampler.1.pin.2
halcmd net c08-symptom c08diag.0.symptom sampler.1.pin.3 sampler.0.pin.0

# The frozen causal trace requires producer-before-sampler ordering.
halcmd addf c08diag.0 c08-thread
halcmd addf sampler.0 c08-thread
halcmd addf sampler.1 c08-thread
halcmd show thread | tee "$EVID_ABS/thread-order.txt"
PROD_LINE="$(grep -n 'c08diag\.0' "$EVID_ABS/thread-order.txt" | head -1 | cut -d: -f1)"
MAIN_LINE="$(grep -n 'sampler\.1' "$EVID_ABS/thread-order.txt" | head -1 | cut -d: -f1)"
[[ -n "$PROD_LINE" && -n "$MAIN_LINE" && "$PROD_LINE" -lt "$MAIN_LINE" ]]

halcmd show pin c08diag.0.phase-cmd | tee "$EVID_ABS/required-objects.txt"
halcmd show pin c08diag.0.inject-a >> "$EVID_ABS/required-objects.txt"
halcmd show pin c08diag.0.inject-b >> "$EVID_ABS/required-objects.txt"
halcmd show pin c08diag.0.cause-a >> "$EVID_ABS/required-objects.txt"
halcmd show pin c08diag.0.cause-b >> "$EVID_ABS/required-objects.txt"
halcmd show pin c08diag.0.symptom >> "$EVID_ABS/required-objects.txt"
halcmd show pin sampler.0.overruns >> "$EVID_ABS/required-objects.txt"
halcmd show pin sampler.1.overruns >> "$EVID_ABS/required-objects.txt"

# Begin with both channels disabled. Stream creation has already occurred at loadrt.
halcmd setp sampler.0.enable 0
halcmd setp sampler.1.enable 0
halcmd setp c08diag.0.phase-cmd 0
halcmd setp c08diag.0.inject-a 0
halcmd setp c08diag.0.inject-b 0

# Actual attach-readiness proof for the main collector. It will block waiting for data.
rm -f /tmp/c08-main.trace /tmp/c08-main.stderr
halsampler -c 1 -t /tmp/c08-main.trace 2>/tmp/c08-main.stderr &
MAIN_PID=$!
sleep 0.10
kill -0 "$MAIN_PID"
printf 'main_collector_pid=%s attach_process_alive_before_sampling=1\n' "$MAIN_PID" | tee "$EVID_ABS/collector-readiness.txt"

halcmd setp sampler.1.enable 1
halcmd start
sleep 0.04

# P0 baseline.
halcmd setp c08diag.0.phase-cmd 0
sleep 0.025

# P1: phase publication before mutation, then same-cycle A cause/symptom.
halcmd setp c08diag.0.phase-cmd 1
sleep 0.010
halcmd setp c08diag.0.inject-a 1
sleep 0.030
A_COARSE="$(halcmd getp c08diag.0.symptom | tr -d '[:space:]')"
printf 'P1 coarse symptom=%s\n' "$A_COARSE" | tee "$EVID_ABS/coarse-halcmd.txt"
halcmd setp c08diag.0.inject-a 0
sleep 0.020

# P2 quiescent separator.
halcmd setp c08diag.0.phase-cmd 2
sleep 0.025

# P3: phase publication before mutation; B cause must precede B symptom by one producer invocation.
halcmd setp c08diag.0.phase-cmd 3
sleep 0.010
halcmd setp c08diag.0.inject-b 1
sleep 0.030
B_COARSE="$(halcmd getp c08diag.0.symptom | tr -d '[:space:]')"
printf 'P3 coarse symptom=%s\n' "$B_COARSE" | tee -a "$EVID_ABS/coarse-halcmd.txt"
halcmd setp c08diag.0.inject-b 0
sleep 0.020

# P4 final baseline.
halcmd setp c08diag.0.phase-cmd 4
sleep 0.025

# Stop main production first, then terminate collector cleanly and retain producer validity.
halcmd setp sampler.1.enable 0
sleep 0.020
MAIN_OVR="$(halcmd getp sampler.1.overruns | tr -d '[:space:]')"
MAIN_FULL="$(halcmd getp sampler.1.full | tr -d '[:space:]')"
MAIN_DEPTH="$(halcmd getp sampler.1.curr-depth | tr -d '[:space:]')"
printf 'main overruns=%s full=%s curr_depth=%s\n' "$MAIN_OVR" "$MAIN_FULL" "$MAIN_DEPTH" | tee "$EVID_ABS/main-producer-validity.txt"
kill -TERM "$MAIN_PID"
set +e
wait "$MAIN_PID"
MAIN_RC=$?
set -e
MAIN_PID=""
printf 'main_collector_exit=%s\n' "$MAIN_RC" | tee -a "$EVID_ABS/collector-readiness.txt"
cp /tmp/c08-main.trace "$EVID_ABS/main-trace.txt"
cp /tmp/c08-main.stderr "$EVID_ABS/main-collector.stderr"
[[ "$MAIN_RC" -eq 0 ]]
[[ -s "$EVID_ABS/main-trace.txt" ]]
[[ ! -s "$EVID_ABS/main-collector.stderr" ]]
[[ "$MAIN_OVR" -eq 0 ]]

# Tiny-FIFO subtest: deliberately produce into depth=4 with no consumer.
halcmd setp sampler.0.overruns 0
halcmd setp sampler.0.enable 1
sleep 0.030
halcmd setp sampler.0.enable 0
sleep 0.005
TINY_OVR="$(halcmd getp sampler.0.overruns | tr -d '[:space:]')"
TINY_FULL="$(halcmd getp sampler.0.full | tr -d '[:space:]')"
TINY_DEPTH="$(halcmd getp sampler.0.curr-depth | tr -d '[:space:]')"
printf 'tiny depth_config=4 usable_expected=3 overruns=%s full=%s curr_depth=%s\n' "$TINY_OVR" "$TINY_FULL" "$TINY_DEPTH" | tee "$EVID_ABS/tiny-producer-validity.txt"
[[ "$TINY_OVR" -gt 0 ]]
[[ "$TINY_DEPTH" -ge 3 ]]

# Drain exactly the three successfully queued records after production is disabled.
rm -f /tmp/c08-tiny.trace /tmp/c08-tiny.stderr
set +e
halsampler -c 0 -n 3 -t /tmp/c08-tiny.trace 2>/tmp/c08-tiny.stderr
TINY_RC=$?
set -e
printf 'tiny_collector_exit=%s\n' "$TINY_RC" | tee "$EVID_ABS/tiny-collector-status.txt"
cp /tmp/c08-tiny.trace "$EVID_ABS/tiny-trace.txt"
cp /tmp/c08-tiny.stderr "$EVID_ABS/tiny-collector.stderr"
[[ "$TINY_RC" -eq 0 ]]
[[ ! -s "$EVID_ABS/tiny-collector.stderr" ]]
[[ "$(wc -l < "$EVID_ABS/tiny-trace.txt")" -eq 3 ]]

# Non-authoritative implementation analysis. Frozen Gates A-J are intentionally not named/scored here.
python3 - "$EVID_ABS/main-trace.txt" "$EVID_ABS/tiny-trace.txt" "$A_COARSE" "$B_COARSE" "$TINY_OVR" <<'PY' | tee "$EVID_ABS/preflight-analysis.txt"
import sys
main_path,tiny_path,a_coarse,b_coarse,tiny_ovr=sys.argv[1:]

def truth(s): return s.strip().upper() in ('TRUE','1')
assert truth(a_coarse) and truth(b_coarse), (a_coarse,b_coarse)
rows=[]
for line in open(main_path):
    p=line.split()
    if not p: continue
    # tag phase cause_a cause_b symptom
    assert len(p) >= 5, p
    rows.append(tuple(map(int,p[:5])))
assert rows
# tags from a single drained stream should be contiguous in this no-overrun main channel.
tags=[r[0] for r in rows]
assert all(b==a+1 for a,b in zip(tags,tags[1:])), 'main tag gap'
p1=[r for r in rows if r[1]==1]
p3=[r for r in rows if r[1]==3]
assert p1 and p3
# P1: no sampled cause-A lead without symptom; at least one asserted pair exists.
assert any(a==1 and b==0 and s==1 for _,_,a,b,s in p1)
assert not any(a==1 and s==0 for _,_,a,b,s in p1)
# P3: cause-B-only row strictly precedes first cause-B+symptom row.
lead=next(i for i,r in enumerate(p3) if r[3]==1 and r[2]==0 and r[4]==0)
full=next(i for i,r in enumerate(p3) if r[3]==1 and r[2]==0 and r[4]==1)
assert lead < full, (lead,full)
tiny=[]
for line in open(tiny_path):
    p=line.split()
    if p: tiny.append(int(p[0]))
assert len(tiny)==3
assert all(b==a+1 for a,b in zip(tiny,tiny[1:])), tiny
assert int(tiny_ovr)>0
print(f'preflight_shape=PASS main_rows={len(rows)} p1_rows={len(p1)} p3_rows={len(p3)}')
print(f'tiny_tags={tiny} tiny_tags_contiguous=1 producer_overruns={tiny_ovr}')
print('interpretation=consumer continuity coexists with proven rejected producer writes; continuity alone is not a no-loss oracle')
print('authority=NON-AUTHORITATIVE; frozen C08-050 Gates A-J remain UNSCORED')
PY

# Preserve exact harness/provenance after successful smoke-scale execution.
halcmd show thread > "$EVID_ABS/thread-order-final.txt"
halcmd show sig > "$EVID_ABS/signals.txt"
halcmd show pin > "$EVID_ABS/pins.txt"
sha256sum "$EVID_ABS"/* | sort > "$EVID_ABS/SHA256SUMS.txt"

printf '\nC08-051 non-authoritative preflight completed successfully.\n'
printf 'evidence_dir=%s\n' "$EVID"
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
