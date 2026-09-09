#!/usr/bin/env bash
set -euo pipefail

# C06 non-authoritative observation-harness diagnostic.
# Purpose: isolate sampler realtime stream creation -> userspace halsampler attach.
# This is NOT C06-030 behavioral evidence and MUST NOT score frozen Gates A-H.
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
PINNED="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c06-039"
ROOT="${GITHUB_WORKSPACE:-$PWD}"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_EVID"

echo '== C06 sampler/stream attach diagnostic (NON-AUTHORITATIVE) =='
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
echo "Pinned upstream commit: $PINNED"
echo 'Prediction: if exact C06 depth/cfg alone reproduces -EINVAL, the defect is in stream configuration/environment rather than hm2_test or C06 phase logic.'
echo 'Control prediction: if exact C06 fails but depth=100 cfg=uffb attaches, investigate size/type-layout; if both fail, trace general stream/shared-memory attach.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps python3
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$PINNED"
[[ "$(git rev-parse HEAD)" == "$PINNED" ]] || { echo 'DIAGNOSTIC_INVALID: pinned checkout mismatch' >&2; exit 21; }

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

# Retain the exact pinned call sites and attach implementation for later diagnosis.
python3 - "$RUN_EVID" <<'PY'
from pathlib import Path
import sys
out=Path(sys.argv[1])
for src,name,needle in [
    (Path('src/hal/components/sampler_usr.c'),'sampler_usr-attach.txt','hal_stream_attach'),
    (Path('src/hal/components/sampler.c'),'sampler-create.txt','hal_stream_create'),
    (Path('src/hal/hal_lib.c'),'hal-stream-attach-impl.txt','int hal_stream_attach'),
]:
    text=src.read_text(errors='replace').splitlines()
    hits=[i for i,l in enumerate(text) if needle in l]
    parts=[]
    for i in hits:
        a=max(0,i-18); b=min(len(text),i+55)
        parts.append(f'--- {src}:{i+1} ---\n'+'\n'.join(f'{j+1}: {text[j]}' for j in range(a,b)))
    (out/name).write_text('\n\n'.join(parts)+'\n')
PY

snapshot() {
  local tag="$1"
  {
    echo "== $tag =="
    date -u '+UTC %Y-%m-%dT%H:%M:%SZ'
    echo '-- hal components --'; halcmd show comp || true
    echo '-- hal pins --'; halcmd show pin 'sampler.*' || true
    echo '-- hal params --'; halcmd show param 'sampler.*' || true
    echo '-- System V shared memory --'; ipcs -m || true
    echo '-- /dev/shm --'; ls -la /dev/shm || true
    echo '-- processes --'; ps -ef | grep -E 'halrun|rtapi|sampler|halsampler' | grep -v grep || true
  } >"$RUN_EVID/${tag}.txt" 2>&1
}

run_case() {
  local label="$1" depth="$2" cfg="$3"
  local fifo="/tmp/c06-039-${label}.fifo"
  local halout="$RUN_EVID/${label}-halrun.log"
  local hsout="$RUN_EVID/${label}-halsampler.stdout"
  local hserr="$RUN_EVID/${label}-halsampler.stderr"
  rm -f "$fifo" "$halout" "$hsout" "$hserr"
  mkfifo "$fifo"
  halrun -I <"$fifo" >"$halout" 2>&1 &
  local halpid=$!
  exec 9>"$fifo"
  cat >&9 <<EOF
loadrt threads name1=diag-thread period1=1000000
loadrt sampler depth=$depth cfg=$cfg
addf sampler.0 diag-thread
start
EOF
  local ready=0
  for _ in $(seq 1 200); do
    if halcmd show pin sampler.0.enable >/dev/null 2>&1 \
       && halcmd show param sampler.0.sample-num >/dev/null 2>&1 \
       && halcmd show param sampler.0.curr-depth >/dev/null 2>&1 \
       && halcmd show param sampler.0.overruns >/dev/null 2>&1; then ready=1; break; fi
    sleep .025
  done
  if [[ "$ready" != 1 ]]; then
    echo "CASE $label: INVALID — sampler objects absent" | tee -a "$RUN_EVID/summary.txt"
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
  echo stop >&9 || true
  echo exit >&9 || true
  exec 9>&-
  wait "$halpid" || true
  local rows=0
  [[ -f "$hsout" ]] && rows=$(grep -Ec '^[[:space:]]*[0-9]+[[:space:]]' "$hsout" || true)
  printf 'CASE %s depth=%s cfg=%s: halsampler_rc=%s parseable_rows=%s\n' "$label" "$depth" "$cfg" "$rc" "$rows" | tee -a "$RUN_EVID/summary.txt"
  if [[ -s "$hserr" ]]; then sed 's/^/  stderr: /' "$hserr" | tee -a "$RUN_EVID/summary.txt"; fi
  if [[ "$rc" == 0 && "$rows" -ge 10 ]]; then return 0; fi
  return 1
}

rm -f "$RUN_EVID/summary.txt"
set +e
run_case exact 30000 uubbbuuuub
EXACT=$?
set -e
if [[ "$EXACT" == 0 ]]; then
  echo 'DIAGNOSTIC VERDICT: exact C06 sampler stream attaches successfully in isolation. The C06-037/038 -EINVAL requires an interaction present in the behavioral harness, not depth/cfg alone.' | tee -a "$RUN_EVID/summary.txt"
  FINAL=0
else
  set +e
  run_case control 100 uffb
  CONTROL=$?
  set -e
  if [[ "$CONTROL" == 0 ]]; then
    echo 'DIAGNOSTIC VERDICT: exact C06 stream fails while small control attaches. Investigate depth/type-layout/resource validation before behavioral retry.' | tee -a "$RUN_EVID/summary.txt"
    FINAL=0
  else
    echo 'DIAGNOSTIC VERDICT: both exact and small control streams fail. General userspace attach/shared-memory path is implicated; do not retry C06-030.' | tee -a "$RUN_EVID/summary.txt"
    FINAL=0
  fi
fi

cat "$RUN_EVID/summary.txt"
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
exit "$FINAL"
