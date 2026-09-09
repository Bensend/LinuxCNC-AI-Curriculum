#!/usr/bin/env bash
set -euo pipefail

# C06 NON-AUTHORITATIVE combined fixture + sampler readiness preflight.
# Corrects the false readiness predicate used by C06-038/039/041/042:
# `halcmd show ...` may return success with no matching object. Here readiness
# requires the actual requested names to appear in HAL output before attach.
# Frozen C06-030 Gates A-H remain unscored and unchanged.
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
PINNED="8bf4605ae81042248add031e94c77300406e0413"
ROOT="${GITHUB_WORKSPACE:-$PWD}"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c06-043"
PATCH="$ROOT/lab-results/run-34306117465-1/c06-clean-hm2test.patch"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_EVID"

echo '== C06 real-readiness combined preflight (NON-AUTHORITATIVE) =='
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
echo "Pinned upstream commit: $PINNED"
echo 'Prediction: once readiness requires actual HAL object names, exact fixture + full static P0 topology + exact sampler should attach and retain rows; if not, the prior race diagnosis is falsified.'

[[ -s "$PATCH" ]] || { echo 'PREFLIGHT_INVALID: fixture patch missing' >&2; exit 20; }
sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps python3
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$PINNED"
[[ "$(git rev-parse HEAD)" == "$PINNED" ]] || exit 21
git apply --check "$PATCH" && git apply "$PATCH"
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

FIFO=/tmp/c06-043-hal.fifo
rm -f "$FIFO"; mkfifo "$FIFO"
halrun -I <"$FIFO" >"$RUN_EVID/halrun.log" 2>&1 &
HALPID=$!
exec 9>"$FIFO"
cleanup() {
  set +e
  echo stop >&9
  echo exit >&9
  exec 9>&-
  wait "$HALPID"
  rm -f "$FIFO"
}
trap cleanup EXIT

cat >&9 <<'EOF'
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

# Prove actual objects, not just successful `show` command execution.
ready=0
for _ in $(seq 1 400); do
  PINS="$(halcmd show pin 2>/dev/null || true)"
  PARAMS="$(halcmd show param 2>/dev/null || true)"
  FUNCTS="$(halcmd show funct 2>/dev/null || true)"
  if grep -Fq 'sampler.0.pin.9' <<<"$PINS" \
     && grep -Fq 'sampler.0.enable' <<<"$PINS" \
     && grep -Fq 'hm2_test.0.watchdog.has_bit' <<<"$PINS" \
     && grep -Fq 'hm2_test.0.c06.fail-reads-remaining' <<<"$PINS" \
     && grep -Fq 'hm2_test.0.io_error' <<<"$PARAMS" \
     && grep -Fq 'sampler.0' <<<"$FUNCTS" \
     && kill -0 "$HALPID" 2>/dev/null; then
       ready=1; break
  fi
  sleep .025
done

{
  echo "ready=$ready"
  echo "halrun_pid=$HALPID alive=$(kill -0 "$HALPID" 2>/dev/null && echo yes || echo no)"
  echo '-- comps --'; halcmd show comp || true
  echo '-- sampler pins --'; halcmd show pin 'sampler.*' || true
  echo '-- hm2 pins --'; halcmd show pin 'hm2_test.0.*' || true
  echo '-- hm2 params --'; halcmd show param 'hm2_test.0.*' || true
  echo '-- threads/functions --'; halcmd show thread || true
  echo '-- shmem --'; ipcs -m || true
} >"$RUN_EVID/ready-proof.txt" 2>&1

if [[ "$ready" != 1 ]]; then
  echo 'PREFLIGHT FAIL: actual-object readiness was not reached.' | tee "$RUN_EVID/summary.txt"
  exit 90
fi

set +e
timeout 12s halsampler -c 0 -n 20 -t >"$RUN_EVID/halsampler.stdout" 2>"$RUN_EVID/halsampler.stderr"
RC=$?
set -e
ROWS=$(grep -Ec '^[[:space:]]*[0-9]+[[:space:]]' "$RUN_EVID/halsampler.stdout" || true)
OVERRUNS=$(halcmd getp sampler.0.overruns 2>/dev/null || echo UNKNOWN)
printf 'ready=%s halsampler_rc=%s parseable_rows=%s overruns=%s\n' "$ready" "$RC" "$ROWS" "$OVERRUNS" | tee "$RUN_EVID/summary.txt"
if [[ -s "$RUN_EVID/halsampler.stderr" ]]; then cat "$RUN_EVID/halsampler.stderr" | tee -a "$RUN_EVID/summary.txt"; fi

if [[ "$RC" == 0 && "$ROWS" -ge 20 && "$OVERRUNS" == 0 ]]; then
  echo 'PREFLIGHT PASS: real object readiness + accepted fixture + full static P0 topology + exact sampler attached and retained data.' | tee -a "$RUN_EVID/summary.txt"
  exit 0
fi

echo 'PREFLIGHT FAIL: real readiness was proven but attachment/data retention still failed; startup-race diagnosis falsified.' | tee -a "$RUN_EVID/summary.txt"
exit 91
