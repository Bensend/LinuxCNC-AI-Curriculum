#!/usr/bin/env bash
set -euo pipefail

# C06 NON-AUTHORITATIVE observation-harness localization diagnostic.
# C06-039 proved the exact depth/cfg attaches in isolation. This test adds the
# accepted C06-036 hm2_test fixture in stages. It MUST NOT score frozen C06-030 Gates A-H.
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
PINNED="8bf4605ae81042248add031e94c77300406e0413"
ROOT="${GITHUB_WORKSPACE:-$PWD}"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c06-041"
PATCH="$ROOT/lab-results/run-34306117465-1/c06-clean-hm2test.patch"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_EVID"

echo '== C06 fixture/sampler interaction diagnostic (NON-AUTHORITATIVE) =='
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
echo "Pinned upstream commit: $PINNED"
echo 'Prior evidence: C06-039 exact depth=30000 cfg=uubbbuuuub attaches in isolation.'
echo 'Prediction A: if adding hostmot2+pattern15 alone causes -EINVAL, fixture/HAL shared-memory interaction is implicated.'
echo 'Prediction B: if fixture-only attaches but full P0 wiring fails, net/pin topology or startup state is implicated.'
echo 'Prediction C: if both attach, the C06-037/038 failure depends on a detail outside static P0 topology and needs exact harness differential.'

[[ -s "$PATCH" ]] || { echo 'DIAGNOSTIC_INVALID: accepted C06-036 patch missing' >&2; exit 20; }
sha256sum "$PATCH" | tee "$RUN_EVID/fixture-patch.sha256"

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps python3
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$PINNED"
[[ "$(git rev-parse HEAD)" == "$PINNED" ]] || { echo 'DIAGNOSTIC_INVALID: pinned checkout mismatch' >&2; exit 21; }

git apply --check "$PATCH"
git apply "$PATCH"
git diff --check
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

snapshot() {
  local tag="$1"
  {
    echo "== $tag =="; date -u '+UTC %Y-%m-%dT%H:%M:%SZ'
    echo '-- comps --'; halcmd show comp || true
    echo '-- sampler --'; halcmd show pin 'sampler.*' || true
    echo '-- hm2/watchdog --'; halcmd show pin 'hm2_test.0.*' || true; halcmd show param 'hm2_test.0.*' || true
    echo '-- ipcs --'; ipcs -m || true
    echo '-- /dev/shm --'; ls -la /dev/shm || true
  } >"$RUN_EVID/${tag}.txt" 2>&1
}

run_case() {
  local label="$1" wiring="$2"
  local fifo="/tmp/c06-041-${label}.fifo"
  local halout="$RUN_EVID/${label}-halrun.log"
  local hsout="$RUN_EVID/${label}-halsampler.stdout"
  local hserr="$RUN_EVID/${label}-halsampler.stderr"
  rm -f "$fifo" "$halout" "$hsout" "$hserr"
  mkfifo "$fifo"
  halrun -I <"$fifo" >"$halout" 2>&1 &
  local halpid=$!
  exec 9>"$fifo"
  cat >&9 <<'EOF'
loadrt hostmot2
loadrt hm2_test test_pattern=15
loadrt threads name1=diag-thread period1=1000000
loadrt sampler depth=30000 cfg=uubbbuuuub
addf hm2_test.0.read diag-thread
addf hm2_test.0.write diag-thread
addf sampler.0 diag-thread
EOF
  if [[ "$wiring" == full ]]; then
    cat >&9 <<'EOF'
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
EOF
  fi
  echo start >&9

  local ready=0
  for _ in $(seq 1 250); do
    if halcmd show pin sampler.0.enable >/dev/null 2>&1 \
       && halcmd show pin hm2_test.0.watchdog.has_bit >/dev/null 2>&1 \
       && halcmd show param hm2_test.0.io_error >/dev/null 2>&1; then ready=1; break; fi
    sleep .02
  done
  if [[ "$ready" != 1 ]]; then
    echo "CASE $label: INVALID — fixture/sampler not ready" | tee -a "$RUN_EVID/summary.txt"
    snapshot "${label}-not-ready"
    echo exit >&9 || true; exec 9>&-; wait "$halpid" || true
    return 90
  fi
  snapshot "${label}-before-attach"
  set +e
  timeout 10s halsampler -c 0 -n 10 -t >"$hsout" 2>"$hserr"
  local rc=$?
  set -e
  snapshot "${label}-after-attach"
  echo stop >&9 || true; echo exit >&9 || true; exec 9>&-; wait "$halpid" || true
  local rows=0
  [[ -f "$hsout" ]] && rows=$(grep -Ec '^[[:space:]]*[0-9]+[[:space:]]' "$hsout" || true)
  printf 'CASE %s wiring=%s: halsampler_rc=%s parseable_rows=%s\n' "$label" "$wiring" "$rc" "$rows" | tee -a "$RUN_EVID/summary.txt"
  if [[ -s "$hserr" ]]; then sed 's/^/  stderr: /' "$hserr" | tee -a "$RUN_EVID/summary.txt"; fi
  [[ "$rc" == 0 && "$rows" -ge 10 ]]
}

rm -f "$RUN_EVID/summary.txt"
set +e
run_case fixture fixture
A=$?
set -e
if [[ "$A" != 0 ]]; then
  echo 'DIAGNOSTIC VERDICT: adding the accepted HostMot2/pattern-15 fixture is sufficient to reproduce the attach failure. Localize fixture/HAL shared-memory interaction before any behavioral retry.' | tee -a "$RUN_EVID/summary.txt"
else
  set +e
  run_case full-p0 full
  B=$?
  set -e
  if [[ "$B" != 0 ]]; then
    echo 'DIAGNOSTIC VERDICT: fixture-only attaches, but full static P0 topology reproduces failure. Localize the signal/net/startup difference before any behavioral retry.' | tee -a "$RUN_EVID/summary.txt"
  else
    echo 'DIAGNOSTIC VERDICT: both fixture-only and full static P0 topology attach successfully. The prior C06-037/038 failure depends on another exact harness/runtime differential; diff retained harnesses before further authoritative execution.' | tee -a "$RUN_EVID/summary.txt"
  fi
fi
cat "$RUN_EVID/summary.txt"
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
exit 0
