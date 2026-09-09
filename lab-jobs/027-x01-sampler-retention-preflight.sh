#!/usr/bin/env bash
set -euo pipefail

# X01-001 NON-AUTHORITATIVE preflight.
# Frozen P0-P5 and Gates A-J are defined in
# experiments/X01-001-sampler-retention-perturbation.md.
# This script may expose harness defects; it must not retune the frozen model.

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_REF="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-x01-preflight"
REAL_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
RUN_DIR="${REAL_WORKSPACE}/lab-results/run-${GITHUB_RUN_ID:?}-${GITHUB_RUN_ATTEMPT:?}"
OUT="$RUN_DIR/x01-027-preflight-evidence"
mkdir -p "$OUT"

SERVO_NS=1000000
BASELINE_SAMPLES=2000
SMALL_DEPTH=64

cat > "$OUT/predeclared-model.txt" <<EOF
X01-027 NON-AUTHORITATIVE PREFLIGHT
Pinned LinuxCNC commit: $LINUXCNC_REF
Servo period: $SERVO_NS ns
Baseline retained samples: $BASELINE_SAMPLES
Forced-starvation FIFO depth: $SMALL_DEPTH
Frozen phases/gates: experiments/X01-001-sampler-retention-perturbation.md P0-P5 / Gates A-J
This preflight validates harness behavior and recorder evidence only; gates remain UNSCORED.
EOF

printf '== X01 sampler retention / perturbation preflight ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
cat "$OUT/predeclared-model.txt"

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_REF"
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

cat > /tmp/x01_source.comp <<'EOF'
component x01_source "X01 deterministic recorder-integrity source";
pin out float value[15];
pin out bit marker;
function _;
license "GPL";
;;
static unsigned long cyc = 0;
FUNCTION(_) {
    cyc++;
    value(0) = (double)cyc;
    value(1) = (double)(cyc % 1000);
    value(2) = (double)(cyc % 100) / 100.0;
    value(3) = (double)((cyc / 100) % 10);
    for (int i = 4; i < 15; i++) {
        value(i) = (double)cyc + ((double)i / 1000.0);
    }
    marker = ((cyc / 25) & 1) ? 1 : 0;
}
EOF
cp /tmp/x01_source.comp "$OUT/x01_source.comp"
halcompile --install /tmp/x01_source.comp >"$OUT/halcompile.stdout" 2>"$OUT/halcompile.stderr"

cleanup_case() {
    timeout --signal=TERM --kill-after=2s 5s halcmd stop >/dev/null 2>&1 || true
    timeout --signal=TERM --kill-after=2s 5s halcmd unload all >/dev/null 2>&1 || true
    timeout --signal=TERM --kill-after=2s 8s realtime stop >/dev/null 2>&1 || true
}
trap cleanup_case EXIT

wait_ready() {
    local tries=0
    until timeout 2s halcmd show pin sampler.0.enable >/tmp/x01-ready.txt 2>/tmp/x01-ready.err && grep -q sampler.0.enable /tmp/x01-ready.txt; do
        tries=$((tries+1))
        if (( tries > 80 )); then
            cat /tmp/x01-ready.err >&2 || true
            return 1
        fi
        sleep .05
    done
}

write_hal() {
    local cfg="$1" depth="$2" file="$3"
    {
        echo "loadrt threads name1=servo-thread period1=$SERVO_NS"
        echo "loadrt x01_source"
        echo "loadrt sampler depth=$depth cfg=$cfg"
        echo "addf x01-source.0 servo-thread"
        echo "addf sampler.0 servo-thread"
        echo "setp sampler.0.enable 0"
        # cfg is all floats followed by a bool. Number of float sampler inputs is len(cfg)-1.
        local floats=$(( ${#cfg} - 1 ))
        for ((i=0; i<floats; i++)); do
            echo "net x01-v$i x01-source.0.value-$i => sampler.0.pin.$i"
        done
        echo "net x01-marker x01-source.0.marker => sampler.0.pin.$floats"
        echo "start"
    } > "$file"
}

start_case() {
    local cfg="$1" depth="$2" name="$3"
    cleanup_case
    write_hal "$cfg" "$depth" "/tmp/x01-$name.hal"
    realtime start >"$OUT/$name-realtime-start.stdout" 2>"$OUT/$name-realtime-start.stderr"
    halcmd -f "/tmp/x01-$name.hal" >"$OUT/$name-hal-setup.stdout" 2>"$OUT/$name-hal-setup.stderr"
    wait_ready
    halcmd show thread >"$OUT/$name-thread.txt"
    halcmd show pin x01-source.0 >"$OUT/$name-source-pins.txt"
    halcmd show pin sampler.0 >"$OUT/$name-sampler-pins.txt"
    cp "/tmp/x01-$name.hal" "$OUT/$name.hal"
}

health() {
    local name="$1"
    {
        printf 'overruns='; timeout 2s halcmd getp sampler.0.overruns | tr -d '[:space:]'; echo
        printf 'curr-depth='; timeout 2s halcmd getp sampler.0.curr-depth | tr -d '[:space:]'; echo
        printf 'full='; timeout 2s halcmd getp sampler.0.full | tr -d '[:space:]'; echo
        printf 'source-counter='; timeout 2s halcmd getp x01-source.0.value-0 | tr -d '[:space:]'; echo
    } | tee "$OUT/$name-health.txt"
}

# P1: normally drained baseline. Narrow configuration = 4 float fields + marker.
NARROW_CFG="ffffb"
start_case "$NARROW_CFG" 5000 baseline
rm -f /tmp/x01-baseline.samples
halsampler -t -n "$BASELINE_SAMPLES" /tmp/x01-baseline.samples >"$OUT/baseline-halsampler.stdout" 2>"$OUT/baseline-halsampler.stderr" &
HSPID=$!
halcmd setp sampler.0.enable 1
if ! timeout 10s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep .02; done' _ "$HSPID"; then
    kill -TERM "$HSPID" 2>/dev/null || true
    wait "$HSPID" 2>/dev/null || true
    echo 'baseline halsampler did not complete' >&2
    exit 20
fi
wait "$HSPID"
halcmd setp sampler.0.enable 0
cp /tmp/x01-baseline.samples "$OUT/baseline.samples"
health baseline

# P2: stop producer sampling first, then boundedly drain exactly the remaining FIFO depth.
start_case "$NARROW_CFG" 1000 stop-drain
halcmd setp sampler.0.enable 1
sleep 0.35
halcmd setp sampler.0.enable 0
STOP_COUNTER="$(timeout 2s halcmd getp x01-source.0.value-0 | tr -d '[:space:]')"
DEPTH="$(timeout 2s halcmd getp sampler.0.curr-depth | tr -d '[:space:]')"
printf 'stopped-source-counter=%s\nremaining-depth=%s\n' "$STOP_COUNTER" "$DEPTH" | tee "$OUT/stop-drain-boundary.txt"
[[ "$DEPTH" =~ ^[0-9]+$ ]] && (( DEPTH > 0 && DEPTH <= 1000 ))
rm -f /tmp/x01-stop-drain.samples
halsampler -t -n "$DEPTH" /tmp/x01-stop-drain.samples >"$OUT/stop-drain-halsampler.stdout" 2>"$OUT/stop-drain-halsampler.stderr"
cp /tmp/x01-stop-drain.samples "$OUT/stop-drain.samples"
health stop-drain-after

# P3: intentionally starve the userspace reader until the tiny FIFO saturates,
# then start a bounded reader while production continues so post-loss records reveal tag discontinuity.
start_case "$NARROW_CFG" "$SMALL_DEPTH" forced-loss
halcmd setp sampler.0.enable 1
sleep 0.25
health forced-loss-before-drain
rm -f /tmp/x01-forced-loss.samples
halsampler -t -n 220 /tmp/x01-forced-loss.samples >"$OUT/forced-loss-halsampler.stdout" 2>"$OUT/forced-loss-halsampler.stderr" &
HSPID=$!
if ! timeout 10s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep .02; done' _ "$HSPID"; then
    kill -TERM "$HSPID" 2>/dev/null || true
    wait "$HSPID" 2>/dev/null || true
    echo 'forced-loss halsampler did not complete' >&2
    exit 21
fi
wait "$HSPID"
halcmd setp sampler.0.enable 0
cp /tmp/x01-forced-loss.samples "$OUT/forced-loss.samples"
health forced-loss-after

# P4: quantitative narrow vs wide recorder thread-cost comparison.
# Reset servo-thread.tmax when writable; otherwise retain before/after values and document reset failure.
measure_timing() {
    local name="$1" cfg="$2"
    start_case "$cfg" 5000 "$name"
    local reset_status=0
    halcmd setp servo-thread.tmax 0 >"$OUT/$name-tmax-reset.stdout" 2>"$OUT/$name-tmax-reset.stderr" || reset_status=$?
    printf '%s\n' "$reset_status" >"$OUT/$name-tmax-reset.status"
    rm -f "/tmp/x01-$name.samples"
    halsampler -t -n 2000 "/tmp/x01-$name.samples" >"$OUT/$name-halsampler.stdout" 2>"$OUT/$name-halsampler.stderr" &
    local pid=$!
    halcmd setp sampler.0.enable 1
    timeout 10s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep .02; done' _ "$pid"
    wait "$pid"
    halcmd setp sampler.0.enable 0
    cp "/tmp/x01-$name.samples" "$OUT/$name.samples"
    {
        printf 'servo-thread.time='; timeout 2s halcmd getp servo-thread.time | tr -d '[:space:]'; echo
        printf 'servo-thread.tmax='; timeout 2s halcmd getp servo-thread.tmax | tr -d '[:space:]'; echo
    } | tee "$OUT/$name-timing.txt"
    health "$name"
}

measure_timing narrow-timing "$NARROW_CFG"
WIDE_CFG="fffffffffffffffb"  # 15 floats + 1 bool, within HAL stream field limit.
measure_timing wide-timing "$WIDE_CFG"

cleanup_case
trap - EXIT

python3 - "$OUT" <<'PY'
from pathlib import Path
import re, sys
out=Path(sys.argv[1])

def parse_samples(path):
    rows=[]; overruns=0
    for line in path.read_text().splitlines():
        s=line.strip()
        if not s: continue
        if s == 'overrun':
            overruns += 1; continue
        f=s.split()
        try:
            tag=int(f[0]); vals=[float(x) for x in f[1:-1]]; marker=int(f[-1])
        except Exception as exc:
            raise AssertionError(f'bad sample row {s!r}: {exc}')
        rows.append((tag, vals, marker))
    return rows, overruns

def kv(path):
    d={}
    for line in path.read_text().splitlines():
        if '=' in line:
            k,v=line.split('=',1); d[k.strip()]=v.strip()
    return d

base, base_overrun_lines=parse_samples(out/'baseline.samples')
assert len(base)==2000, len(base)
assert base_overrun_lines==0, base_overrun_lines
assert all(base[i+1][0]==base[i][0]+1 for i in range(len(base)-1))
# Deterministic row integrity: v1 = counter mod 1000; v2 = (counter mod 100)/100; v3=(counter//100)%10.
for tag, vals, marker in base:
    c=round(vals[0])
    assert abs(vals[1]-(c%1000)) < 1e-9
    assert abs(vals[2]-((c%100)/100.0)) < 1e-9
    assert abs(vals[3]-((c//100)%10)) < 1e-9
    assert marker in (0,1)
bh=kv(out/'baseline-health.txt')
assert int(float(bh['overruns']))==0, bh

sd, sd_overrun_lines=parse_samples(out/'stop-drain.samples')
bound=kv(out/'stop-drain-boundary.txt')
assert len(sd)==int(bound['remaining-depth'])
assert sd_overrun_lines==0
assert sd and all(sd[i+1][0]==sd[i][0]+1 for i in range(len(sd)-1))
# Sampler is ordered after source; last retained source value should be at or immediately before userspace stop observation.
stop_counter=float(bound['stopped-source-counter'])
last_counter=sd[-1][1][0]
assert 0 <= stop_counter-last_counter <= 3, (stop_counter,last_counter)

forced, forced_overrun_lines=parse_samples(out/'forced-loss.samples')
pre=kv(out/'forced-loss-before-drain-health.txt'); post=kv(out/'forced-loss-after-health.txt')
assert int(float(pre['overruns']))>0, pre
assert int(float(post['overruns']))>=int(float(pre['overruns']))
# Consumer loss evidence can appear either as the explicit 'overrun' marker or a numerical tag gap.
tag_gaps=sum(1 for i in range(len(forced)-1) if forced[i+1][0] != forced[i][0]+1)
assert forced_overrun_lines>0 or tag_gaps>0, (forced_overrun_lines,tag_gaps)
assert float(post['source-counter']) > float(pre['source-counter']), (pre,post)

narrow,_=parse_samples(out/'narrow-timing.samples'); wide,_=parse_samples(out/'wide-timing.samples')
assert len(narrow)==2000 and len(wide)==2000
nh=kv(out/'narrow-timing-health.txt'); wh=kv(out/'wide-timing-health.txt')
assert int(float(nh['overruns']))==0 and int(float(wh['overruns']))==0
nt=kv(out/'narrow-timing-timing.txt'); wt=kv(out/'wide-timing-timing.txt')
for d in (nt,wt):
    assert float(d['servo-thread.tmax']) >= 0
summary=f'''X01-027 PREFLIGHT RUNTIME PREDICATES PASS
baseline_rows={len(base)} contiguous=yes producer_overruns={bh['overruns']}
stop_drain_rows={len(sd)} expected_depth={bound['remaining-depth']} stop_counter={stop_counter} last_retained_counter={last_counter}
forced_loss_rows={len(forced)} producer_overruns_before={pre['overruns']} producer_overruns_after={post['overruns']} consumer_overrun_markers={forced_overrun_lines} tag_gaps={tag_gaps}
narrow_servo_thread_time={nt['servo-thread.time']} narrow_tmax={nt['servo-thread.tmax']}
wide_servo_thread_time={wt['servo-thread.time']} wide_tmax={wt['servo-thread.tmax']}
NOTE: timing values are quantitative observed thread-cost evidence, not a claim of zero or causal deadline perturbation.
NOTE: forced recorder loss is not classified as a producer/control-loop cycle skip.
NOTE: frozen Gates A-J remain UNSCORED in this non-authoritative preflight.
'''
(out/'analysis.txt').write_text(summary)
print(summary,end='')
PY

find "$OUT" -maxdepth 1 -type f -printf '%f %s bytes\n' | sort | tee "$OUT/inventory.txt"
[[ -s "$OUT/baseline.samples" ]]
[[ -s "$OUT/stop-drain.samples" ]]
[[ -s "$OUT/forced-loss.samples" ]]
[[ -s "$OUT/narrow-timing.samples" ]]
[[ -s "$OUT/wide-timing.samples" ]]
[[ -s "$OUT/analysis.txt" ]]
printf '%s\n' 'X01-027 NON-AUTHORITATIVE PREFLIGHT PASS; frozen Gates A-J remain UNSCORED.'
