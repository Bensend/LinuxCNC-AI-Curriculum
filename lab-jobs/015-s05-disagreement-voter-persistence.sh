#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-s05-disagreement"

printf '== LinuxCNC S05 disagreement/voter/persistence lab ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Predeclared prediction: signed A-B through wcomp faults at |d| >= 0.125; timedelay rejects short fault/recovery states; maj3 masks one dissent in its voted output; equal common-mode values still look numerically healthy.'
printf '%s\n' 'Evidence boundary: ordinary LinuxCNC HAL software semantics only; no physical independence, diagnostic coverage, PL/SIL/category or safety-function validation.'

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
sudo make setcap
cd ..
set +u
source scripts/rip-environment
set -u
export LINUXCNC_FORCE_REALTIME=1

cat >/tmp/s05-monitor.hal <<'EOF'
loadrt threads name1=servo period1=10000000 fp1=1
loadrt sum2 count=1
loadrt wcomp count=1
loadrt or2 count=1
loadrt timedelay count=1
loadrt maj3 count=1

addf sum2.0 servo
addf wcomp.0 servo
addf or2.0 servo
addf timedelay.0 servo
addf maj3.0 servo

setp sum2.0.gain0 1.0
setp sum2.0.gain1 -1.0
setp sum2.0.offset 0.0
setp wcomp.0.min -0.125
setp wcomp.0.max 0.125
setp timedelay.0.on-delay 0.050
setp timedelay.0.off-delay 0.030

net s05-difference sum2.0.out => wcomp.0.in
net s05-under wcomp.0.under => or2.0.in0
net s05-over wcomp.0.over => or2.0.in1
net s05-raw-fault or2.0.out => timedelay.0.in
start
EOF

rm -f /tmp/s05-hal.stdout /tmp/s05-hal.stderr /tmp/s05-hal.stdin
mkfifo /tmp/s05-hal.stdin
exec 9<>/tmp/s05-hal.stdin
halrun -I -f /tmp/s05-monitor.hal <&9 >/tmp/s05-hal.stdout 2>/tmp/s05-hal.stderr &
HALRUN_PID=$!
cleanup() {
    trap - EXIT
    exec 9>&- || true
    kill -TERM "$HALRUN_PID" 2>/dev/null || true
    for _ in $(seq 1 30); do
        if ! kill -0 "$HALRUN_PID" 2>/dev/null; then break; fi
        sleep 0.1
    done
    kill -KILL "$HALRUN_PID" 2>/dev/null || true
    wait "$HALRUN_PID" 2>/dev/null || true
    rm -f /tmp/s05-hal.stdin
}
trap cleanup EXIT

getp() { timeout 3s halcmd getp "$1" | tr -d '[:space:]'; }
setp() { timeout 3s halcmd setp "$1" "$2"; }
is_true() { [[ "$1" == "TRUE" || "$1" == "1" ]]; }
is_false() { [[ "$1" == "FALSE" || "$1" == "0" ]]; }
float_close() { python3 - "$1" "$2" "$3" <<'PY'
import sys
x=float(sys.argv[1]); y=float(sys.argv[2]); tol=float(sys.argv[3])
raise SystemExit(0 if abs(x-y) <= tol else 1)
PY
}

printf '\n== Wait for HAL topology ==\n'
READY=0
for i in $(seq 1 100); do
    if timeout 3s halcmd show funct >/tmp/s05-funct.txt 2>/tmp/s05-probe.err \
       && grep -q 'sum2.0' /tmp/s05-funct.txt \
       && grep -q 'timedelay.0' /tmp/s05-funct.txt \
       && grep -q 'maj3.0' /tmp/s05-funct.txt \
       && timeout 3s halcmd show thread >/tmp/s05-thread.txt 2>/tmp/s05-thread.err; then
        READY=1; printf 'HAL ready at probe %s\n' "$i"; break
    fi
    sleep 0.1
done
if [[ "$READY" != 1 ]]; then
    echo 'S05 HAL topology did not become ready.' >&2
    cat /tmp/s05-hal.stdout >&2 || true
    cat /tmp/s05-hal.stderr >&2 || true
    exit 2
fi
cat /tmp/s05-thread.txt
cat /tmp/s05-funct.txt

# Gate J is checked early so every behavioral result has known execution order.
printf '\n== Gate J: function order ==\n'
ORDER_TEXT="$(cat /tmp/s05-thread.txt /tmp/s05-funct.txt)"
python3 - "$ORDER_TEXT" <<'PY'
import sys
s=sys.argv[1]
names=['sum2.0','wcomp.0','or2.0','timedelay.0','maj3.0']
pos=[]
for n in names:
    p=s.find(n)
    if p < 0:
        raise SystemExit(f'missing function {n}')
    pos.append(p)
if pos != sorted(pos):
    raise SystemExit(f'wrong order: {list(zip(names,pos))}')
print('function-order=PASS', list(zip(names,pos)))
PY

printf '\n== Gate A: equal values ==\n'
setp sum2.0.in0 1.0; setp sum2.0.in1 1.0
sleep 0.04
D="$(getp sum2.0.out)"; W="$(getp wcomp.0.out)"; U="$(getp wcomp.0.under)"; O="$(getp wcomp.0.over)"; R="$(getp or2.0.out)"; P="$(getp timedelay.0.out)"
printf 'd=%s inside=%s under=%s over=%s raw=%s persisted=%s\n' "$D" "$W" "$U" "$O" "$R" "$P"
float_close "$D" 0 1e-12; is_true "$W"; is_false "$U"; is_false "$O"; is_false "$R"; is_false "$P"
printf 'gate-A-equal=PASS\n'

printf '\n== Gate B: sub-threshold disagreement ==\n'
setp sum2.0.in0 1.0; setp sum2.0.in1 1.0625
sleep 0.025
D="$(getp sum2.0.out)"; W="$(getp wcomp.0.out)"; R="$(getp or2.0.out)"; P="$(getp timedelay.0.out)"
printf 'd=%s inside=%s raw=%s persisted=%s\n' "$D" "$W" "$R" "$P"
float_close "$D" -0.0625 1e-12; is_true "$W"; is_false "$R"; is_false "$P"
printf 'gate-B-subthreshold=PASS\n'

printf '\n== Gates C/D: exact threshold and short persistence ==\n'
setp sum2.0.in0 1.0; setp sum2.0.in1 1.125
sleep 0.015
D="$(getp sum2.0.out)"; W="$(getp wcomp.0.out)"; U="$(getp wcomp.0.under)"; O="$(getp wcomp.0.over)"; R="$(getp or2.0.out)"; P="$(getp timedelay.0.out)"
printf 'after-short-boundary d=%s inside=%s under=%s over=%s raw=%s persisted=%s elapsed=%s\n' "$D" "$W" "$U" "$O" "$R" "$P" "$(getp timedelay.0.elapsed)"
float_close "$D" -0.125 1e-12; is_false "$W"; is_true "$U"; is_false "$O"; is_true "$R"; is_false "$P"
printf 'gate-C-exact-boundary=PASS\nprintf gate-D-short-fault-rejected=PASS\n'

printf '\n== Gate E: sustained excursion accepted ==\n'
sleep 0.070
R="$(getp or2.0.out)"; P="$(getp timedelay.0.out)"
printf 'raw=%s persisted=%s elapsed=%s\n' "$R" "$P" "$(getp timedelay.0.elapsed)"
is_true "$R"; is_true "$P"
printf 'gate-E-sustained-fault=PASS\n'

printf '\n== Gate F: short healthy recovery does not clear ==\n'
setp sum2.0.in0 1.0; setp sum2.0.in1 1.0
sleep 0.010
R="$(getp or2.0.out)"; P="$(getp timedelay.0.out)"
printf 'raw=%s persisted=%s elapsed=%s\n' "$R" "$P" "$(getp timedelay.0.elapsed)"
is_false "$R"; is_true "$P"
printf 'gate-F-short-recovery-held=PASS\n'

printf '\n== Gate G: sustained healthy recovery clears ==\n'
sleep 0.060
R="$(getp or2.0.out)"; P="$(getp timedelay.0.out)"
printf 'raw=%s persisted=%s elapsed=%s\n' "$R" "$P" "$(getp timedelay.0.elapsed)"
is_false "$R"; is_false "$P"
printf 'gate-G-sustained-recovery=PASS\n'

printf '\n== Gate H: 2-of-3 vote masks dissent ==\n'
setp maj3.0.in1 1; setp maj3.0.in2 1; setp maj3.0.in3 0
sleep 0.025
M1="$(getp maj3.0.in1)"; M2="$(getp maj3.0.in2)"; M3="$(getp maj3.0.in3)"; MO="$(getp maj3.0.out)"
printf 'case1 raw=(%s,%s,%s) vote=%s\n' "$M1" "$M2" "$M3" "$MO"
is_true "$M1"; is_true "$M2"; is_false "$M3"; is_true "$MO"
setp maj3.0.in1 0; setp maj3.0.in2 0; setp maj3.0.in3 1
sleep 0.025
M1="$(getp maj3.0.in1)"; M2="$(getp maj3.0.in2)"; M3="$(getp maj3.0.in3)"; MO="$(getp maj3.0.out)"
printf 'case2 raw=(%s,%s,%s) vote=%s\n' "$M1" "$M2" "$M3" "$MO"
is_false "$M1"; is_false "$M2"; is_true "$M3"; is_false "$MO"
printf 'gate-H-majority-masks-dissent=PASS\n'

printf '\n== Gate I: equal synthetic wrong value still agrees ==\n'
setp sum2.0.in0 42.0; setp sum2.0.in1 42.0
sleep 0.04
D="$(getp sum2.0.out)"; W="$(getp wcomp.0.out)"; R="$(getp or2.0.out)"; P="$(getp timedelay.0.out)"
printf 'designated-wrong synthetic values A=B=42: d=%s inside=%s raw=%s persisted=%s\n' "$D" "$W" "$R" "$P"
float_close "$D" 0 1e-12; is_true "$W"; is_false "$R"; is_false "$P"
printf 'gate-I-common-mode-agreement=PASS\n'

printf '\n== Timing-skew adversarial arithmetic ==\n'
python3 - <<'PY'
Ts=0.010; v=20.0; T=0.125
apparent=v*Ts
print(f'Ts={Ts:.3f}s v={v:.1f} units/s one-cycle apparent disagreement={apparent:.3f} threshold={T:.3f}')
assert apparent > T
print('timing-skew-analysis=PASS: correct-but-time-shifted samples can trip the numerical monitor')
PY

printf '\n== Final evidence ==\n'
timeout 3s halcmd show sig s05-difference
timeout 3s halcmd show sig s05-raw-fault
timeout 3s halcmd show pin wcomp.0
timeout 3s halcmd show pin timedelay.0
timeout 3s halcmd show pin maj3.0
printf 'S05 disagreement/voter/persistence lab completed successfully.\n'
printf '%s\n' 'TEST scope if PASS: stock HAL numeric threshold, persistence and majority-voter semantics at the pinned revision in a hosted userspace software lab.'
printf '%s\n' 'Explicit non-claim: agreement/voting in this fixture does not prove correctness, freshness, independence, diagnostic coverage or functional-safety integrity.'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
