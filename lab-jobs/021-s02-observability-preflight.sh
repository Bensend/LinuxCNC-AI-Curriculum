#!/usr/bin/env bash
set -euo pipefail

# S02 non-authoritative preflight for the already-frozen P0-P5 model and Gates A-J.
# This script validates only harness behavior and retained evidence. It does NOT
# score the frozen gates and must not retune the model merely to obtain a pass.

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-s02-preflight"
REAL_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
RUN_DIR="${REAL_WORKSPACE}/lab-results/run-${GITHUB_RUN_ID:?}-${GITHUB_RUN_ATTEMPT:?}"
OUT="$RUN_DIR/s02-021-evidence"
mkdir -p "$OUT"

# Frozen numeric predeclarations made before first execution.
SERVO_NS=1000000          # 1 ms
PHASE_CYCLES=200          # 200 ms/phase
DISAGREE_THRESHOLD=0.050
P1_OFFSET=0.200
P2_STEP_PER_CYCLE=0.002
P2_STALE_THRESHOLD=0.050
P1_DETECT_BOUND_CYCLES=1
P2_DETECT_BOUND_CYCLES=30
TOTAL_CAPTURE=1400

cat > "$OUT/predeclared-model.txt" <<EOF
S02-021 NON-AUTHORITATIVE PREFLIGHT
Pinned LinuxCNC: $LINUXCNC_COMMIT
Servo period: $SERVO_NS ns
Phase length: $PHASE_CYCLES cycles
P1 disagreement threshold: $DISAGREE_THRESHOLD
P1 injected B offset: $P1_OFFSET
P1 detection bound: <= $P1_DETECT_BOUND_CYCLES servo cycle after P1 begins
P2 physical ramp: $P2_STEP_PER_CYCLE units/cycle
P2 stale threshold: $P2_STALE_THRESHOLD
P2 oracle-stale detection bound: <= $P2_DETECT_BOUND_CYCLES servo cycles after P2 begins
P3 required classification: UNKNOWN sensor freshness from value-only evidence
P4 restricted detector inputs: reported_A, reported_B, transport_healthy only
P4 required restricted result: no detection while synthetic physical oracle disagrees
P5 quadrature diagnostic: modeled limited diagnostic only, never universal validity
Frozen P0-P5 and Gates A-J remain unchanged and UNSCORED in this preflight.
EOF

printf '== S02 frozen observability model non-authoritative preflight ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
cat "$OUT/predeclared-model.txt"

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
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

cat > /tmp/s02_model.comp <<'EOF'
component s02_model "S02 deterministic synthetic feedback-observability fixture";
pin out float phase;
pin out float physical_a;
pin out float physical_b;
pin out float reported_a;
pin out float reported_b;
pin out bit transport_healthy;
pin out bit quadrature_diag;
pin out bit pair_disagreement;
pin out bit oracle_stale_b;
pin out bit freshness_unknown;
pin out bit restricted_detect;
pin out bit oracle_common_mode;
param rw u32 phase_cycles = 200;
param rw float disagree_threshold = 0.050;
param rw float p1_offset = 0.200;
param rw float p2_step = 0.002;
param rw float stale_threshold = 0.050;
function _;
license "GPL";
;;
#include <math.h>
static unsigned long cyc = 0;
FUNCTION(_) {
    unsigned long plen = phase_cycles ? phase_cycles : 1;
    unsigned long p = cyc / plen;
    unsigned long k = cyc % plen;
    if (p > 5) p = 5;

    phase = (double)p;
    transport_healthy = 1;
    quadrature_diag = 0;
    pair_disagreement = 0;
    oracle_stale_b = 0;
    freshness_unknown = 0;
    restricted_detect = 0;
    oracle_common_mode = 0;

    if (p == 0) {
        physical_a = physical_b = reported_a = reported_b = 0.0;
    } else if (p == 1) {
        double truth = 1.0 + 0.001 * (double)k;
        physical_a = physical_b = truth;
        reported_a = truth;
        reported_b = truth + p1_offset;
    } else if (p == 2) {
        double truth = 2.0 + p2_step * (double)k;
        physical_a = physical_b = truth;
        reported_a = truth;
        reported_b = 2.0;
    } else if (p == 3) {
        physical_a = physical_b = reported_a = reported_b = 3.0;
        freshness_unknown = 1;
    } else if (p == 4) {
        physical_a = physical_b = 4.0;
        reported_a = reported_b = 3.5;
        oracle_common_mode = 1;
    } else {
        physical_a = physical_b = reported_a = reported_b = 5.0;
        quadrature_diag = 1;
    }

    pair_disagreement = fabs(reported_a - reported_b) > disagree_threshold;
    oracle_stale_b = fabs(physical_b - reported_b) > stale_threshold;
    /* Restricted detector deliberately has no synthetic-oracle access. */
    restricted_detect = transport_healthy && pair_disagreement;
    cyc++;
}
EOF
cp /tmp/s02_model.comp "$OUT/s02_model.comp"

# Install only this test fixture into the current RIP environment.
halcompile --install /tmp/s02_model.comp >"$OUT/halcompile.stdout" 2>"$OUT/halcompile.stderr"

cat > /tmp/s02.hal <<EOF
loadrt threads name1=servo-thread period1=$SERVO_NS
loadrt s02_model
loadrt sampler depth=5000 cfg=fffffbbbbbbb
addf s02_model.0 servo-thread
addf sampler.0 servo-thread
setp s02_model.0.phase-cycles $PHASE_CYCLES
setp s02_model.0.disagree-threshold $DISAGREE_THRESHOLD
setp s02_model.0.p1-offset $P1_OFFSET
setp s02_model.0.p2-step $P2_STEP_PER_CYCLE
setp s02_model.0.stale-threshold $P2_STALE_THRESHOLD
setp sampler.0.enable 0
net s02-phase s02_model.0.phase => sampler.0.pin.0
net s02-physical-a s02_model.0.physical-a => sampler.0.pin.1
net s02-physical-b s02_model.0.physical-b => sampler.0.pin.2
net s02-reported-a s02_model.0.reported-a => sampler.0.pin.3
net s02-reported-b s02_model.0.reported-b => sampler.0.pin.4
net s02-transport s02_model.0.transport-healthy => sampler.0.pin.5
net s02-quad-diag s02_model.0.quadrature-diag => sampler.0.pin.6
net s02-pair-disagreement s02_model.0.pair-disagreement => sampler.0.pin.7
net s02-oracle-stale-b s02_model.0.oracle-stale-b => sampler.0.pin.8
net s02-freshness-unknown s02_model.0.freshness-unknown => sampler.0.pin.9
net s02-restricted-detect s02_model.0.restricted-detect => sampler.0.pin.10
net s02-oracle-common-mode s02_model.0.oracle-common-mode => sampler.0.pin.11
start
EOF
cp /tmp/s02.hal "$OUT/s02.hal"

rm -f /tmp/s02.samples /tmp/s02-halsampler.stdout /tmp/s02-halsampler.stderr
halrun -f /tmp/s02.hal >"$OUT/halrun.stdout" 2>"$OUT/halrun.stderr" &
HALPID=$!
cleanup(){
  trap - EXIT
  kill -TERM "$HALPID" 2>/dev/null || true
  sleep .1
  kill -KILL "$HALPID" 2>/dev/null || true
  wait "$HALPID" 2>/dev/null || true
}
trap cleanup EXIT

READY=0
for i in $(seq 1 80); do
  if kill -0 "$HALPID" 2>/dev/null && timeout 2s halcmd show pin s02_model.0.phase >/tmp/s02-ready.txt 2>/tmp/s02-ready.err && grep -q s02_model.0.phase /tmp/s02-ready.txt; then
    READY=1; break
  fi
  sleep .05
done
[[ "$READY" == 1 ]] || { cat "$OUT/halrun.stderr" >&2; cat /tmp/s02-ready.err >&2 || true; exit 2; }

halcmd show pin s02_model.0 | tee "$OUT/topology.txt"
halcmd show thread | tee "$OUT/thread.txt"

halsampler -t -n "$TOTAL_CAPTURE" /tmp/s02.samples >/tmp/s02-halsampler.stdout 2>/tmp/s02-halsampler.stderr &
HSPID=$!
halcmd setp sampler.0.enable 1

if ! timeout 8s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep .02; done' _ "$HSPID"; then
  kill -TERM "$HSPID" 2>/dev/null || true
  wait "$HSPID" 2>/dev/null || true
  echo 'S02 halsampler capture did not complete' >&2
  exit 3
fi
wait "$HSPID"
halcmd setp sampler.0.enable 0 || true
cp /tmp/s02.samples "$OUT/atomic.samples"
cp /tmp/s02-halsampler.stdout "$OUT/halsampler.stdout"
cp /tmp/s02-halsampler.stderr "$OUT/halsampler.stderr"
OV="$(timeout 2s halcmd getp sampler.0.overruns | tr -d '[:space:]')"
printf 'sampler-overruns=%s\n' "$OV" | tee "$OUT/recorder-health.txt"
[[ "$OV" == 0 ]]
[[ ! -s "$OUT/halsampler.stderr" ]]

python3 - "$OUT" "$PHASE_CYCLES" "$P1_DETECT_BOUND_CYCLES" "$P2_DETECT_BOUND_CYCLES" <<'PY'
from pathlib import Path
import sys
out=Path(sys.argv[1]); phase_cycles=int(sys.argv[2]); p1_bound=int(sys.argv[3]); p2_bound=int(sys.argv[4])
rows=[]
for line in (out/'atomic.samples').read_text().splitlines():
    f=line.split()
    if len(f)<13: continue
    bit=lambda s:s.lower() in ('1','true')
    # sample-index + 5 floats + 7 bits
    rows.append(dict(i=int(f[0]),phase=int(round(float(f[1]))),pa=float(f[2]),pb=float(f[3]),ra=float(f[4]),rb=float(f[5]),transport=bit(f[6]),quad=bit(f[7]),pair=bit(f[8]),stale=bit(f[9]),unknown=bit(f[10]),restricted=bit(f[11]),common=bit(f[12])))
assert len(rows) >= 1000, len(rows)
assert all(rows[i]['i'] < rows[i+1]['i'] for i in range(len(rows)-1))
ph={p:[r for r in rows if r['phase']==p] for p in range(6)}
assert all(len(ph[p]) >= 100 for p in range(6)), {p:len(ph[p]) for p in ph}
# P0: no false assertions.
assert not any(r['pair'] or r['stale'] or r['restricted'] or r['common'] or r['quad'] for r in ph[0])
# P1: differential disagreement with healthy transport, detected immediately/bounded.
p1=ph[1]; assert all(r['transport'] for r in p1)
first_pair=next(i for i,r in enumerate(p1) if r['pair'])
assert first_pair <= p1_bound, first_pair
assert any(abs(r['ra']-r['rb']) > .05 for r in p1)
# P2: healthy transport can carry a frozen B while physical B moves.
p2=ph[2]; assert all(r['transport'] for r in p2)
assert max(r['pb'] for r in p2)-min(r['pb'] for r in p2) > .10
assert max(r['rb'] for r in p2)-min(r['rb'] for r in p2) < 1e-9
first_stale=next(i for i,r in enumerate(p2) if r['stale'])
assert first_stale <= p2_bound, first_stale
# P3: stationary equality is explicitly UNKNOWN, not health proof.
p3=ph[3]; assert all(r['unknown'] for r in p3)
assert all(abs(r['pa']-r['ra'])<1e-9 and abs(r['pb']-r['rb'])<1e-9 for r in p3)
# P4: false agreement + healthy transport defeats restricted detector while lab oracle sees wrong physical truth.
p4=ph[4]; assert all(r['transport'] and r['common'] for r in p4)
assert all(abs(r['ra']-r['rb'])<1e-9 for r in p4)
assert all(abs(r['pa']-r['ra'])>.1 and abs(r['pb']-r['rb'])>.1 for r in p4)
assert not any(r['restricted'] or r['pair'] for r in p4)
# P5: limited diagnostic can assert independently with numerically truthful/equal channels.
p5=ph[5]; assert all(r['quad'] for r in p5)
assert not any(r['pair'] or r['restricted'] for r in p5)
summary=f'''S02-021 PREFLIGHT RUNTIME PREDICATES PASS\nsamples={len(rows)}\nphase_counts={ {p:len(ph[p]) for p in ph} }\nP1 first pair-disagreement sample-in-phase={first_pair} bound<={p1_bound}\nP2 first oracle-stale sample-in-phase={first_stale} bound<={p2_bound}\nP3 value-only freshness classification=UNKNOWN\nP4 restricted detector=false despite common-mode physical mismatch\nP5 quadrature diagnostic asserted without pair disagreement\nNOTE: synthetic physical_a/physical_b and oracle_* outputs are laboratory-only truth signals, not LinuxCNC production validity signals.\nNOTE: this is non-authoritative harness validation; frozen S02 Gates A-J remain UNSCORED.\n'''
(out/'analysis.txt').write_text(summary)
print(summary,end='')
PY

printf '\nS02-021 retained evidence inventory:\n'
find "$OUT" -maxdepth 1 -type f -printf '%f %s bytes\n' | sort | tee "$OUT/inventory.txt"
[[ -s "$OUT/atomic.samples" ]]
[[ -s "$OUT/s02_model.comp" ]]
[[ -s "$OUT/predeclared-model.txt" ]]
[[ -s "$OUT/analysis.txt" ]]

printf '%s\n' 'S02-021 EVIDENCE-RETENTION PREFLIGHT PASS; frozen Gates A-J remain UNSCORED.'
