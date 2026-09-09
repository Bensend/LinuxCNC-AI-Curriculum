#!/usr/bin/env bash
set -euo pipefail

# C06-030 authoritative behavioral run after accepted clean-fixture preflight.
# Frozen P0-P6 / Gates A-H are from experiments/C06-030-transport-watchdog-fault-plan.md.
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
PINNED="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c06-037"
ROOT="${GITHUB_WORKSPACE:-$PWD}"
PATCH="$ROOT/lab-results/run-34306117465-1/c06-clean-hm2test.patch"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_EVID"

echo '== C06 phase-publication redesign preflight (NON-AUTHORITATIVE) =='
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
echo "Pinned upstream commit: $PINNED"
echo 'Frozen gates: experiments/C06-030-transport-watchdog-fault-plan.md'
echo 'Fixture lineage: exact patch accepted by C06-036 non-authoritative preflight'

[[ -s "$PATCH" ]] || { echo 'HARNESS_INVALID: retained preflight patch missing' >&2; exit 20; }
sha256sum "$PATCH" | tee "$RUN_EVID/fixture-patch.sha256"
cp "$PATCH" "$RUN_EVID/c06-fixture.patch"

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps python3
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$PINNED"
[[ "$(git rev-parse HEAD)" == "$PINNED" ]] || { echo 'HARNESS_INVALID: pinned checkout mismatch' >&2; exit 21; }

HM2=src/hal/drivers/mesa-hostmot2/hm2_test.c
CORE=src/hal/drivers/mesa-hostmot2/hostmot2.c
TRAM=src/hal/drivers/mesa-hostmot2/tram.c
WD=src/hal/drivers/mesa-hostmot2/watchdog.c
LLIO=src/hal/drivers/mesa-hostmot2/hostmot2-lowlevel.h
sha256sum "$CORE" "$TRAM" "$WD" "$LLIO" | tee "$RUN_EVID/production-source-before.sha256"
git apply --check "$PATCH"
git apply "$PATCH"
git diff --check
sha256sum "$HM2" | tee "$RUN_EVID/hm2-test-patched.sha256"
sha256sum "$CORE" "$TRAM" "$WD" "$LLIO" | tee "$RUN_EVID/production-source-after.sha256"
cmp "$RUN_EVID/production-source-before.sha256" "$RUN_EVID/production-source-after.sha256" || { echo 'HARNESS_INVALID: production HostMot2 source changed' >&2; exit 22; }
grep -q 'c06_hal = hal_malloc(sizeof(\*c06_hal))' "$HM2" || { echo 'HARNESS_INVALID: accepted shared-memory fixture missing' >&2; exit 23; }

./debian/configure uspace
sudo apt-get build-dep -y .
cd src
./autogen.sh
./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation
make -j"$(nproc)" 2>&1 | tee "$RUN_EVID/build.log"
cd ..
set +u
source scripts/rip-environment
set -u

cat >/tmp/c06-037.hal <<'EOF'
loadrt hostmot2
loadrt hm2_test test_pattern=15
loadrt threads name1=c06-thread period1=1000000
loadrt sampler depth=30000 cfg=uubbbuuuub

addf hm2_test.0.read c06-thread
addf hm2_test.0.write c06-thread
addf sampler.0 c06-thread

newsig c06-phase u32
newsig c06-fail-remaining u32
newsig c06-watchdog-command bit
newsig c06-io-error-mirror bit
newsig c06-has-bit bit
newsig c06-read-success u32
newsig c06-read-fail u32
newsig c06-write-success u32
newsig c06-consecutive u32
newsig c06-watchdog-status-mirror bit

net c06-fail-remaining hm2_test.0.c06.fail-reads-remaining
net c06-watchdog-command hm2_test.0.c06.watchdog-status-command
net c06-io-error-mirror hm2_test.0.c06.io-error-mirror
net c06-has-bit hm2_test.0.watchdog.has_bit
net c06-read-success hm2_test.0.c06.read-success-count
net c06-read-fail hm2_test.0.c06.read-fail-count
net c06-write-success hm2_test.0.c06.write-success-count
net c06-consecutive hm2_test.0.c06.consecutive-failures
net c06-watchdog-status-mirror hm2_test.0.c06.watchdog-status-mirror

net c06-phase sampler.0.pin.0
net c06-fail-remaining sampler.0.pin.1
net c06-watchdog-command sampler.0.pin.2
net c06-io-error-mirror sampler.0.pin.3
net c06-has-bit sampler.0.pin.4
net c06-read-success sampler.0.pin.5
net c06-read-fail sampler.0.pin.6
net c06-write-success sampler.0.pin.7
net c06-consecutive sampler.0.pin.8
net c06-watchdog-status-mirror sampler.0.pin.9

setp hm2_test.0.watchdog.timeout_ns 5000000
sets c06-phase 0
sets c06-fail-remaining 0
sets c06-watchdog-command false
start
EOF

# Keep halrun alive through all frozen phases. All decisive state is sampled on one realtime stream.
rm -f /tmp/c06-hal.in /tmp/c06-hal.out "$RUN_EVID/c06-trace.txt"
mkfifo /tmp/c06-hal.in
halrun -I </tmp/c06-hal.in >/tmp/c06-hal.out 2>&1 &
HALPID=$!
exec 9>/tmp/c06-hal.in
cat /tmp/c06-037.hal >&9

# C06-043 correction: readiness must prove the requested HAL objects EXIST,
# not merely that `halcmd show` returned exit status 0. Also prove halrun alive.
ready=0
for _ in $(seq 1 400); do
  PINS="$(halcmd show pin 2>/dev/null || true)"
  PARAMS="$(halcmd show param 2>/dev/null || true)"
  FUNCTS="$(halcmd show funct 2>/dev/null || true)"
  if grep -Fq 'hm2_test.0.watchdog.has_bit' <<<"$PINS" \
     && grep -Fq 'hm2_test.0.c06.fail-reads-remaining' <<<"$PINS" \
     && grep -Fq 'sampler.0.pin.9' <<<"$PINS" \
     && grep -Fq 'sampler.0.enable' <<<"$PINS" \
     && grep -Fq 'hm2_test.0.io_error' <<<"$PARAMS" \
     && grep -Fq 'sampler.0' <<<"$FUNCTS" \
     && kill -0 "$HALPID" 2>/dev/null; then ready=1; break; fi
  sleep .025
done
{
  echo "ready=$ready"
  echo "halrun_alive=$(kill -0 "$HALPID" 2>/dev/null && echo yes || echo no)"
  halcmd show comp || true
  halcmd show pin 'sampler.*' || true
  halcmd show pin 'hm2_test.0.*' || true
  halcmd show param 'hm2_test.0.*' || true
  ipcs -m || true
} >"$RUN_EVID/readiness-proof.txt" 2>&1
[[ "$ready" == 1 ]] || { cat /tmp/c06-hal.out; echo 'HARNESS_INVALID: actual fixture/sampler objects did not become ready' >&2; kill "$HALPID" 2>/dev/null || true; exit 24; }

halsampler -c 0 -t >"$RUN_EVID/c06-trace.txt" 2>"$RUN_EVID/halsampler.stderr" &
SAMPID=$!
# Authoritative observation barrier: reader remains alive and at least 50 baseline
# rows exist before any P1 mutation.
observing=0
for _ in $(seq 1 150); do
  if ! kill -0 "$SAMPID" 2>/dev/null; then
    cat "$RUN_EVID/halsampler.stderr" >&2 || true
    echo 'HARNESS_INVALID: halsampler exited before P0 observation' >&2
    kill "$HALPID" 2>/dev/null || true
    exit 27
  fi
  if [[ -s "$RUN_EVID/c06-trace.txt" ]] && [[ $(wc -l <"$RUN_EVID/c06-trace.txt") -ge 50 ]]; then observing=1; break; fi
  sleep .01
done
[[ "$observing" == 1 ]] || { cat "$RUN_EVID/halsampler.stderr" >&2 || true; echo 'HARNESS_INVALID: no initial atomic sampler rows' >&2; kill "$SAMPID" "$HALPID" 2>/dev/null || true; exit 28; }
sleep .30

# P1 publication barrier: publish phase, let realtime observe it, then inject one failed read.
echo 'sets c06-phase 1' >&9
sleep .05
echo 'sets c06-fail-remaining 1' >&9
sleep .35

# P2 publication barrier, then unchanged repeated-failure command.
echo 'sets c06-phase 2' >&9
sleep .05
echo 'sets c06-fail-remaining 5' >&9
sleep .35

# P3 publication barrier, then unchanged transport recovery actions.
echo 'sets c06-phase 3' >&9
sleep .05
echo 'sets c06-fail-remaining 0' >&9
echo 'setp hm2_test.0.io_error false' >&9
sleep .35

# P4 publication barrier, then unchanged fake watchdog-status injection.
echo 'sets c06-phase 4' >&9
sleep .05
echo 'sets c06-watchdog-command true' >&9
sleep .35

# P5: leave has_bit asserted and verify recovery remains held.
echo 'sets c06-phase 5' >&9
sleep .40

# P6 publication barrier, then unchanged watchdog recovery actions.
echo 'sets c06-phase 6' >&9
sleep .05
echo 'sets c06-watchdog-command false' >&9
echo 'sets c06-has-bit false' >&9
sleep .45

echo 'stop' >&9
sleep .05
kill "$SAMPID" 2>/dev/null || true
wait "$SAMPID" 2>/dev/null || true
echo 'exit' >&9
exec 9>&-
wait "$HALPID" || { cat /tmp/c06-hal.out; echo 'HARNESS_INVALID: halrun exited nonzero' >&2; exit 25; }
cp /tmp/c06-hal.out "$RUN_EVID/halrun.log"

# Retain sampler overrun state from stderr/log; any overrun invalidates Gate B.
cat "$RUN_EVID/halsampler.stderr" || true

python3 - "$RUN_EVID/c06-trace.txt" "$RUN_EVID/gate-analysis.txt" <<'PY'
import sys
from pathlib import Path
trace=Path(sys.argv[1]); out=Path(sys.argv[2])
rows=[]
for ln in trace.read_text().splitlines():
    p=ln.split()
    if len(p)!=11: continue
    try:
        n=int(p[0]); vals=[int(x,0) for x in p[1:]]
    except ValueError: continue
    rows.append((n,*vals))
# columns n,phase,failrem,wdcmd,iomirror,has,rs,rf,ws,consec,wdmirror
lines=[]
def verdict(name, ok, detail):
    lines.append(f'Gate {name}: {"PASS" if ok else "FAIL"} — {detail}')
    return ok
allok=True
# A is established outside trace by exact SHA, accepted patch, production-source identity, real registered watchdog.
verdict('A', True, 'pinned SHA + retained preflight-tested patch + production source integrity + real HostMot2 watchdog topology')
if len(rows)<1200:
    verdict('B',False,f'only {len(rows)} parseable atomic rows'); allok=False
else:
    mono=all(rows[i][0] < rows[i+1][0] for i in range(len(rows)-1))
    verdict('B',mono,f'{len(rows)} single-stream rows; sample numbers strictly increasing={mono}; sampler stderr retained')
    allok &= mono
ph={k:[r for r in rows if r[1]==k] for k in range(7)}
for k in range(7):
    if len(ph[k])<150:
        lines.append(f'PHASE {k} insufficient rows: {len(ph[k])}')
        allok=False

def advance(a,idx): return len(a)>=2 and a[-1][idx] > a[0][idx]
# C P0 baseline: no faults; low-level read/write service advances.
a=ph[0]
ok=len(a)>=150 and all(r[4]==0 and r[5]==0 for r in a[-150:]) and advance(a[-150:],6) and advance(a[-150:],8)
verdict('C',ok,f'P0 rows={len(a)} io/has clear and read/write counters advance={ok}'); allok &= ok
# D P1: at least one failed read, success resumes, no watchdog bite.
a=ph[1]
ok=len(a)>=150 and a[-1][7] > a[0][7] and a[-1][6] > a[0][6] and all(r[5]==0 for r in a)
verdict('D',ok,f'P1 transient fail observed, successful reads resume, watchdog stays clear={ok}'); allok &= ok
# E P2: io_error mirror asserts while watchdog command/status/has remain false; then service counts freeze.
a=ph[2]; hit=next((i for i,r in enumerate(a) if r[4]==1),None)
ok=hit is not None
if ok:
    tail=a[min(hit+5,len(a)-1):]
    ok=len(tail)>=20 and all(r[2] >= 0 and r[3]==0 and r[4]==1 and r[5]==0 and r[10]==0 for r in tail) and tail[-1][6]==tail[0][6] and tail[-1][8]==tail[0][8]
verdict('E',ok,f'P2 io_error asserts independently of watchdog and generic service freezes={ok}'); allok &= ok
# F P3: explicit io_error clear permits read/write recovery and no watchdog indication.
a=ph[3]; tail=a[-150:] if len(a)>=150 else a
ok=len(tail)>=150 and all(r[4]==0 and r[5]==0 for r in tail) and advance(tail,6) and advance(tail,8)
verdict('F',ok,f'P3 explicit io_error clear restores service={ok}'); allok &= ok
# G P4 proves valid watchdog bit under healthy transport; P5 proves has_bit hold while transport itself remains clear.
a=ph[4]
p4=any(r[3]==1 and r[4]==0 and r[5]==1 and r[10]==1 for r in a)
b=ph[5]; tail=b[-150:] if len(b)>=150 else b
p5=len(tail)>=150 and all(r[4]==0 and r[5]==1 for r in tail)
ok=p4 and p5
verdict('G',ok,f'P4 valid watchdog status raises real has_bit under healthy transport={p4}; P5 holds={p5}'); allok &= ok
# H P6 explicit watchdog status removal + has_bit clear permits recovery.
a=ph[6]; tail=a[-150:] if len(a)>=150 else a
ok=len(tail)>=150 and all(r[3]==0 and r[4]==0 and r[5]==0 and r[10]==0 for r in tail) and advance(tail,6) and advance(tail,8)
verdict('H',ok,f'P6 explicit watchdog clear permits service recovery={ok}; no physical-safe-state claim'); allok &= ok
lines.append('SAFETY BOUNDARY: clearing LinuxCNC/HostMot2 fault state is not evidence that an external machine is physically safe to resume.')
lines.append('C06-030 BEHAVIORAL VERDICT: '+('PASS' if allok else 'FAIL'))
out.write_text('\n'.join(lines)+'\n')
print(out.read_text(),end='')
if not allok: raise SystemExit(41)
PY

# Explicitly reject sampler overrun evidence if reported.
if grep -Eiq 'overrun[^0-9]*[1-9]|[1-9][0-9]*[^0-9]+overrun' "$RUN_EVID/halsampler.stderr"; then
  echo 'HARNESS_INVALID: sampler reported nonzero overruns' >&2
  exit 26
fi

echo 'NON-AUTHORITATIVE PREFLIGHT: internal analyzer reached PASS; frozen Gates remain unaccepted' | tee "$RUN_EVID/verdict.txt"
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
