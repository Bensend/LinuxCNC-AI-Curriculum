#!/usr/bin/env bash
set -euo pipefail

# C06 NON-AUTHORITATIVE persistent-stream topology localizer.
# C06-039: exact stream attaches alone.
# C06-041: fixture-only attaches; full static P0 fails, but was a second halrun.
# This keeps ONE sampler stream alive and probes attachment after each topology
# mutation, eliminating cross-halrun/stale-key ambiguity. Frozen C06-030 Gates A-H
# remain unscored and unchanged.
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
PINNED="8bf4605ae81042248add031e94c77300406e0413"
ROOT="${GITHUB_WORKSPACE:-$PWD}"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c06-042"
PATCH="$ROOT/lab-results/run-34306117465-1/c06-clean-hm2test.patch"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_EVID"

echo '== C06 persistent-stream P0 topology localizer (NON-AUTHORITATIVE) =='
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
echo "Pinned upstream commit: $PINNED"
echo 'Prediction: if an attach that succeeds before a topology mutation fails immediately after it while the same realtime stream remains alive, that mutation (or realtime side effect it enables) is causal to stream invalidation.'

[[ -s "$PATCH" ]] || { echo 'DIAGNOSTIC_INVALID: fixture patch missing' >&2; exit 20; }
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

FIFO=/tmp/c06-042-hal.fifo
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
loadrt threads name1=diag-thread period1=1000000
loadrt sampler depth=30000 cfg=uubbbuuuub
addf hm2_test.0.read diag-thread
addf hm2_test.0.write diag-thread
addf sampler.0 diag-thread
start
EOF
for _ in $(seq 1 250); do
  halcmd show pin sampler.0.pin.9 >/dev/null 2>&1 && halcmd show pin hm2_test.0.watchdog.has_bit >/dev/null 2>&1 && break
  sleep .02
done
halcmd show pin sampler.0.pin.9 >/dev/null 2>&1 || { echo 'DIAGNOSTIC_INVALID: sampler not ready'; exit 90; }

probe=0
probe_attach() {
  local tag="$1"
  probe=$((probe+1))
  local out="$RUN_EVID/probe-${probe}-${tag}.stdout" err="$RUN_EVID/probe-${probe}-${tag}.stderr"
  set +e
  timeout 8s halsampler -c 0 -n 3 -t >"$out" 2>"$err"
  local rc=$?
  set -e
  local rows=0
  rows=$(grep -Ec '^[[:space:]]*[0-9]+[[:space:]]' "$out" 2>/dev/null || true)
  printf 'PROBE %02d %-28s rc=%s rows=%s' "$probe" "$tag" "$rc" "$rows" | tee -a "$RUN_EVID/summary.txt"
  if [[ -s "$err" ]]; then printf ' stderr=%q' "$(tr '\n' ' ' <"$err")" | tee -a "$RUN_EVID/summary.txt"; fi
  printf '\n' | tee -a "$RUN_EVID/summary.txt"
  if [[ "$rc" != 0 || "$rows" -lt 3 ]]; then
    {
      echo "== failure snapshot after $tag =="
      date -u '+UTC %Y-%m-%dT%H:%M:%SZ'
      halcmd show comp || true
      halcmd show pin 'sampler.*' || true
      halcmd show pin 'hm2_test.0.*' || true
      halcmd show param 'hm2_test.0.*' || true
      ipcs -m || true
    } >"$RUN_EVID/failure-${probe}-${tag}.txt" 2>&1
    return 1
  fi
  return 0
}

rm -f "$RUN_EVID/summary.txt"
probe_attach baseline-fixture || { echo 'VERDICT baseline failed unexpectedly' | tee -a "$RUN_EVID/summary.txt"; exit 0; }

# Creating unlinked signals should not alter sampler pin references.
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
EOF
probe_attach after-signal-create || { echo 'VERDICT signal creation invalidated stream' | tee -a "$RUN_EVID/summary.txt"; exit 0; }

# Link fixture/generic HostMot2 endpoints first, leaving sampler pins untouched.
cat >&9 <<'EOF'
net c06-fail-remaining hm2_test.0.c06.fail-reads-remaining
net c06-watchdog-command hm2_test.0.c06.watchdog-status-command
net c06-io-error-mirror hm2_test.0.c06.io-error-mirror
net c06-has-bit hm2_test.0.watchdog.has_bit
net c06-read-success hm2_test.0.c06.read-success-count
net c06-read-fail hm2_test.0.c06.read-fail-count
net c06-write-success hm2_test.0.c06.write-success-count
net c06-consecutive hm2_test.0.c06.consecutive-failures
net c06-watchdog-status-mirror hm2_test.0.c06.watchdog-status-mirror
EOF
probe_attach after-fixture-link || { echo 'VERDICT linking fixture/HostMot2 pins invalidated stream' | tee -a "$RUN_EVID/summary.txt"; exit 0; }

# Link sampler pins one at a time and probe after each exact mutation.
links=(
  'net c06-phase sampler.0.pin.0'
  'net c06-fail-remaining sampler.0.pin.1'
  'net c06-watchdog-command sampler.0.pin.2'
  'net c06-io-error-mirror sampler.0.pin.3'
  'net c06-has-bit sampler.0.pin.4'
  'net c06-read-success sampler.0.pin.5'
  'net c06-read-fail sampler.0.pin.6'
  'net c06-write-success sampler.0.pin.7'
  'net c06-consecutive sampler.0.pin.8'
  'net c06-watchdog-status-mirror sampler.0.pin.9'
)
for i in "${!links[@]}"; do
  echo "${links[$i]}" >&9
  if ! probe_attach "after-sampler-pin-$i"; then
    echo "VERDICT first failing mutation: ${links[$i]}" | tee -a "$RUN_EVID/summary.txt"
    exit 0
  fi
done

# Finally apply non-faulting P0 values and watchdog timeout.
cat >&9 <<'EOF'
setp hm2_test.0.watchdog.timeout_ns 5000000
sets c06-phase 0
sets c06-fail-remaining 0
sets c06-watchdog-command false
EOF
if ! probe_attach after-p0-values-timeout; then
  echo 'VERDICT P0 value/timeout mutation invalidated stream' | tee -a "$RUN_EVID/summary.txt"
  exit 0
fi

echo 'VERDICT all persistent-stream topology probes passed; prior full-P0 failure requires another differential (including possible cross-halrun cleanup in C06-041).' | tee -a "$RUN_EVID/summary.txt"
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
exit 0
