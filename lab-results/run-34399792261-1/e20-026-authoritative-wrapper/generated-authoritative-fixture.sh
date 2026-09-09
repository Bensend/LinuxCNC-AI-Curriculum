#!/usr/bin/env bash
set -euo pipefail

# E20-001 AUTHORITATIVE independent execution.
# Frozen source target, numeric contract, P0-P8 and Gates A-J are defined in
# experiments/E20-001-transport-watchdog-recovery-boundaries.md and MUST NOT be
# retuned based on this run. This script executes the frozen, already-preflighted fixture independently; Gates A-J are scored later from the retained artifact.

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_REF="v2.9.10"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-e20-authoritative"
REAL_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
RUN_DIR="${REAL_WORKSPACE}/lab-results/run-${GITHUB_RUN_ID:?}-${GITHUB_RUN_ATTEMPT:?}"
OUT="$RUN_DIR/e20-026-authoritative-evidence"
mkdir -p "$OUT"

SERVO_NS=1000000
ERROR_LIMIT=10
ERROR_INCREMENT=2
ERROR_DECREMENT=1
TOTAL_CAPTURE=1100

cat > "$OUT/predeclared-model.txt" <<EOF
E20-026 AUTHORITATIVE EXECUTION
Target source: LinuxCNC $LINUXCNC_REF
Servo period: $SERVO_NS ns
packet-error-limit: $ERROR_LIMIT
packet-error-increment: $ERROR_INCREMENT
packet-error-decrement: $ERROR_DECREMENT
Frozen phases: P0-P8 exactly as experiments/E20-001-transport-watchdog-recovery-boundaries.md
Frozen Gates A-J must be scored only after independent retained-artifact inspection.
Synthetic watchdog/physical-I/O/state-revalidation signals are laboratory-only witnesses.
EOF

printf '== E20 frozen transport/watchdog recovery-boundary authoritative execution ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
cat "$OUT/predeclared-model.txt"

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"
git clone --filter=blob:none --branch "$LINUXCNC_REF" --single-branch "$UPSTREAM" "$WORK"
cd "$WORK"
git rev-parse HEAD | tee "$OUT/linuxcnc-commit.txt"
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

cat > /tmp/e20_model.comp <<'EOF'
component e20_model "E20 deterministic hm2_eth/watchdog recovery-boundary fixture";
pin out float phase;
pin out bit transaction_error;
pin out bit io_error_clear_request;
pin out bit watchdog_bitten;
pin out bit state_revalidated;
pin out bit reauthorize_request;
pin out bit packet_error_current;
pin out float packet_error_total;
pin out float packet_error_level;
pin out bit packet_error_exceeded;
pin out bit io_error;
pin out bit needs_soft_reset;
pin out bit physical_io_authority;
pin out float internal_generator_counter;
pin out bit transport_current_good;
pin out bit machine_motion_authorized;
param rw s32 error_limit = 10;
param rw s32 error_increment = 2;
param rw s32 error_decrement = 1;
function _;
license "GPL";
;;
static unsigned long cyc = 0;
static long level = 0;
static unsigned long total = 0;
static int ioerr = 0;
static int needs = 0;
static int authorized = 1;
static unsigned long internal_count = 0;

FUNCTION(_) {
    unsigned long p;
    /* P0 300 cycles; P1 1; P2 100; P3 5; P4..P7 100 each; P8 thereafter. */
    if (cyc < 300) p = 0;
    else if (cyc < 301) p = 1;
    else if (cyc < 401) p = 2;
    else if (cyc < 406) p = 3;
    else if (cyc < 506) p = 4;
    else if (cyc < 606) p = 5;
    else if (cyc < 706) p = 6;
    else if (cyc < 806) p = 7;
    else p = 8;

    phase = (double)p;
    transaction_error = (p == 1 || p == 3 || p == 8);
    io_error_clear_request = (p == 4 && cyc == 406);
    watchdog_bitten = (p == 5);
    state_revalidated = (p == 7);
    reauthorize_request = (p == 7);

    /* Mirrors the current-lineage saturated-counter/io_error clear interaction. */
    if (ioerr && level >= error_limit && io_error_clear_request) {
        ioerr = 0;
        level = 0;
    }

    if (transaction_error) {
        packet_error_current = 1;
        total++;
        needs = 1;
        level += error_increment < 1 ? 1 : error_increment;
        if (level > error_limit) level = error_limit;
        if (level >= error_limit) ioerr = 1;
    } else {
        packet_error_current = 0;
        level -= error_decrement < 1 ? 1 : error_decrement;
        if (level < 0) level = 0;
    }

    /* P6 is the explicit modeled driver/board soft-reset completion. */
    if (p == 6) needs = 0;

    packet_error_total = (double)total;
    packet_error_level = (double)level;
    packet_error_exceeded = ioerr && level >= error_limit;
    io_error = ioerr;
    needs_soft_reset = needs;
    transport_current_good = !transaction_error;

    physical_io_authority = !watchdog_bitten;
    internal_count++;
    internal_generator_counter = (double)internal_count;

    if (transaction_error || ioerr || watchdog_bitten || !physical_io_authority) {
        authorized = 0;
    }
    if (p == 7 && transport_current_good && !ioerr && !needs && physical_io_authority && state_revalidated && reauthorize_request) {
        authorized = 1;
    }
    machine_motion_authorized = authorized;
    cyc++;
}
EOF
cp /tmp/e20_model.comp "$OUT/e20_model.comp"
halcompile --install /tmp/e20_model.comp >"$OUT/halcompile.stdout" 2>"$OUT/halcompile.stderr"

cat > /tmp/e20.hal <<EOF
loadrt threads name1=servo-thread period1=$SERVO_NS
loadrt e20_model
loadrt sampler depth=5000 cfg=fbbbbbbffbbbbfbb
addf e20-model.0 servo-thread
addf sampler.0 servo-thread
setp e20-model.0.error-limit $ERROR_LIMIT
setp e20-model.0.error-increment $ERROR_INCREMENT
setp e20-model.0.error-decrement $ERROR_DECREMENT
setp sampler.0.enable 0
net e20-phase e20-model.0.phase => sampler.0.pin.0
net e20-tx-error e20-model.0.transaction-error => sampler.0.pin.1
net e20-clear e20-model.0.io-error-clear-request => sampler.0.pin.2
net e20-watchdog e20-model.0.watchdog-bitten => sampler.0.pin.3
net e20-revalidated e20-model.0.state-revalidated => sampler.0.pin.4
net e20-reauth-req e20-model.0.reauthorize-request => sampler.0.pin.5
net e20-packet-current e20-model.0.packet-error-current => sampler.0.pin.6
net e20-total e20-model.0.packet-error-total => sampler.0.pin.7
net e20-level e20-model.0.packet-error-level => sampler.0.pin.8
net e20-exceeded e20-model.0.packet-error-exceeded => sampler.0.pin.9
net e20-io-error e20-model.0.io-error => sampler.0.pin.10
net e20-needs-reset e20-model.0.needs-soft-reset => sampler.0.pin.11
net e20-physical-authority e20-model.0.physical-io-authority => sampler.0.pin.12
net e20-internal-counter e20-model.0.internal-generator-counter => sampler.0.pin.13
net e20-transport-good e20-model.0.transport-current-good => sampler.0.pin.14
net e20-authorized e20-model.0.machine-motion-authorized => sampler.0.pin.15
start
EOF
cp /tmp/e20.hal "$OUT/e20.hal"

rm -f /tmp/e20.samples /tmp/e20-halsampler.stdout /tmp/e20-halsampler.stderr
cleanup(){
  trap - EXIT
  timeout --signal=TERM --kill-after=2s 5s halcmd stop >/dev/null 2>&1 || true
  timeout --signal=TERM --kill-after=2s 5s halcmd unload all >/dev/null 2>&1 || true
  timeout --signal=TERM --kill-after=2s 8s realtime stop >/dev/null 2>&1 || true
}
trap cleanup EXIT
realtime start >"$OUT/realtime-start.stdout" 2>"$OUT/realtime-start.stderr"
halcmd -f /tmp/e20.hal >"$OUT/hal-setup.stdout" 2>"$OUT/hal-setup.stderr"

READY=0
for i in $(seq 1 80); do
  if timeout 2s halcmd show pin e20-model.0.phase >/tmp/e20-ready.txt 2>/tmp/e20-ready.err && grep -q e20-model.0.phase /tmp/e20-ready.txt && timeout 2s halcmd show pin sampler.0.enable >/tmp/e20-sampler-ready.txt 2>>/tmp/e20-ready.err && grep -q sampler.0.enable /tmp/e20-sampler-ready.txt; then
    READY=1; break
  fi
  sleep .05
done
[[ "$READY" == 1 ]] || { cat "$OUT/hal-setup.stderr" >&2 || true; cat /tmp/e20-ready.err >&2 || true; exit 2; }

halcmd show pin e20-model.0 | tee "$OUT/topology.txt"
halcmd show thread | tee "$OUT/thread.txt"

halsampler -t -n "$TOTAL_CAPTURE" /tmp/e20.samples >/tmp/e20-halsampler.stdout 2>/tmp/e20-halsampler.stderr &
HSPID=$!
halcmd setp sampler.0.enable 1
if ! timeout 8s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep .02; done' _ "$HSPID"; then
  kill -TERM "$HSPID" 2>/dev/null || true
  wait "$HSPID" 2>/dev/null || true
  echo 'E20 halsampler capture did not complete' >&2
  exit 3
fi
wait "$HSPID"
halcmd setp sampler.0.enable 0 || true
cp /tmp/e20.samples "$OUT/atomic.samples"
cp /tmp/e20-halsampler.stdout "$OUT/halsampler.stdout"
cp /tmp/e20-halsampler.stderr "$OUT/halsampler.stderr"
OV="$(timeout 2s halcmd getp sampler.0.overruns | tr -d '[:space:]')"
printf 'sampler-overruns=%s\n' "$OV" | tee "$OUT/recorder-health.txt"
[[ "$OV" == 0 ]]
[[ ! -s "$OUT/halsampler.stderr" ]]

python3 - "$OUT" <<'PY'
from pathlib import Path
import sys
out=Path(sys.argv[1]); rows=[]
def bit(s): return s.lower() in ('1','true')
for line in (out/'atomic.samples').read_text().splitlines():
    f=line.split()
    if len(f)<17: continue
    rows.append(dict(i=int(f[0]),phase=int(round(float(f[1]))),tx=bit(f[2]),clear=bit(f[3]),wd=bit(f[4]),rv=bit(f[5]),req=bit(f[6]),cur=bit(f[7]),total=float(f[8]),level=float(f[9]),ex=bit(f[10]),io=bit(f[11]),needs=bit(f[12]),phys=bit(f[13]),internal=float(f[14]),good=bit(f[15]),auth=bit(f[16])))
assert len(rows) >= 900, len(rows)
assert all(rows[i]['i'] < rows[i+1]['i'] for i in range(len(rows)-1))
ph={p:[r for r in rows if r['phase']==p] for p in range(9)}
assert all(ph[p] for p in range(9)), {p:len(v) for p,v in ph.items()}
# P0
assert all((not r['cur']) and r['level']==0 and (not r['io']) and (not r['wd']) and r['phys'] and r['auth'] for r in ph[0])
# P1 exactly the declared isolated soft error.
p1=ph[1]; assert len(p1)==1, len(p1); r=p1[0]
assert r['cur'] and r['level']==2 and not r['io'] and r['needs'] and not r['auth']
# P2 first clean cycle retains history at level 1, then drains to zero without reauth.
p2=ph[2]; r=p2[0]
assert (not r['cur']) and r['level']==1 and not r['io'] and not r['auth']
assert any(x['level']==0 for x in p2) and not any(x['auth'] for x in p2)
# P3 five consecutive errors reach saturation on fifth.
p3=ph[3]; assert len(p3)==5, len(p3)
assert [x['level'] for x in p3]==[2,4,6,8,10], [x['level'] for x in p3]
assert not p3[3]['io'] and p3[4]['io'] and p3[4]['ex'] and not p3[4]['auth']
# P4 explicit clear recovers driver-level state but never authorization.
p4=ph[4]; assert p4[0]['clear'] and p4[0]['level']==0 and not p4[0]['io'] and not p4[0]['ex']
assert not any(x['auth'] for x in p4)
# P5 clean current transport + internal evolution can coexist with no physical authority.
p5=ph[5]; assert all(x['good'] and not x['cur'] and x['wd'] and not x['phys'] and not x['auth'] for x in p5)
assert p5[-1]['internal'] > p5[0]['internal']
# P6 restores board/driver conditions but not machine authorization/revalidation.
p6=ph[6]; assert all(x['good'] and not x['io'] and not x['needs'] and x['phys'] and not x['rv'] and not x['auth'] for x in p6)
# P7 explicit revalidation+request is the only recovery authorization transition.
p7=ph[7]; assert all(x['good'] and x['phys'] and x['rv'] and x['req'] and x['auth'] for x in p7)
# P8 immediately revokes authorization on fresh fault.
p8=ph[8]; assert p8[0]['tx'] and p8[0]['cur'] and not p8[0]['auth']
summary=f'''E20-026 AUTHORITATIVE RUNTIME PREDICATES PASS\nsamples={len(rows)}\nphase_counts={ {p:len(ph[p]) for p in ph} }\nP1 isolated error: level=2, io_error=false, authorization revoked\nP2 first clean cycle: packet_error=false, level=1, authorization remains false\nP3 levels={[x['level'] for x in p3]} with io_error on fifth error\nP4 driver error clears but authorization remains false\nP5 internal generator advances while physical I/O authority=false and current transport is clean\nP6 transport/driver/board authority restored without state revalidation; authorization=false\nP7 explicit revalidation+request authorizes\nP8 fresh fault revokes authorization immediately\nNOTE: watchdog/physical-I/O/state-revalidation signals are synthetic laboratory witnesses.\nNOTE: this run does not prove Ethernet physics, exact Mesa-output timing, or functional safety. Frozen Gates A-J require independent artifact scoring.\n'''
(out/'analysis.txt').write_text(summary)
print(summary,end='')
PY

find "$OUT" -maxdepth 1 -type f -printf '%f %s bytes\n' | sort | tee "$OUT/inventory.txt"
[[ -s "$OUT/atomic.samples" ]]
[[ -s "$OUT/e20_model.comp" ]]
[[ -s "$OUT/predeclared-model.txt" ]]
[[ -s "$OUT/analysis.txt" ]]
printf '%s\n' 'E20-026 AUTHORITATIVE EVIDENCE PACKAGE PRODUCED; score frozen Gates A-J only from retained artifact.'
