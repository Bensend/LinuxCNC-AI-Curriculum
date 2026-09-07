#!/usr/bin/env bash
set -euo pipefail

# S04-014 material redesign after three comparator-family teardown/restart failures.
# Reuse the accepted realtime-comparator instrumentation, but perform the
# stationary-frozen adversarial control FIRST in the same LinuxCNC runtime that
# later performs the moving-freeze fault test. This removes cross-runtime teardown
# from the evidence path without changing the immutable S04 numerical/behavioral gates.
WRAPPER_SRC="lab-jobs/014-s04-feedback-freeze-rtcompare.sh"
WRAPPER_TMP="${RUNNER_TEMP:-/tmp}/014-s04-single-runtime-wrapper.sh"
cp "$WRAPPER_SRC" "$WRAPPER_TMP"

python3 - "$WRAPPER_TMP" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()
needle = 'bash -n "$TMP"\nexec bash "$TMP"\n'
if needle not in s:
    raise SystemExit('HARNESS INVALID: rtcompare wrapper tail changed; refusing unreviewed transform')
replacement = r'''bash -n "$TMP"
python3 - "$TMP" <<'PY_SINGLE_RUNTIME'
from pathlib import Path
import re, sys
p = Path(sys.argv[1])
s = p.read_text()

# Remove the old post-fault fresh-runtime Gate D. It is precisely the lifecycle
# path that exhausted the three materially-similar attempts.
start_marker = "printf '\\n== Gate D: fresh stationary-frozen control ==\\n'"
end_marker = "printf '\\nS04 frozen-feedback experiment completed successfully.\\n'"
start = s.find(start_marker)
end = s.find(end_marker)
if start < 0 or end < 0 or end <= start:
    raise SystemExit('HARNESS INVALID: could not locate old Gate D block for material redesign')
s = s[:start] + s[end:]

# Insert an equivalent stationary-frozen control before Gate A/B/C, after all
# helper functions are defined. It uses the same runtime pins and sampler, freezes
# already-equal command/feedback, samples >=600 servo cycles, and requires no
# comparator crossing, following error, joint error, or disable.
gate_abc = "printf '\\n== Gate A/B/C: healthy motion, freeze feedback, threshold fault ==\\n'"
pos = s.find(gate_abc)
if pos < 0:
    raise SystemExit('HARNESS INVALID: could not locate Gate A/B/C insertion point')
stationary = r"""printf '\n== Gate D first: stationary-frozen control in shared runtime ==\n'
rm -f /tmp/s04-stationary.samples /tmp/s04-stationary-errors.txt
start_runtime combined
enable_machine combined

# Establish equal stationary state, then freeze exactly that feedback. No motion
# command is issued during this control interval.
sleep 0.2
SCMD="$(read_pin joint.0.motor-pos-cmd)"
SFB="$(read_pin joint.0.motor-pos-fb)"
awk -v c="$SCMD" -v f="$SFB" 'BEGIN{e=c-f;if(e<0)e=-e; exit !(e<0.010)}' || {
    echo 'Gate D initial command/feedback mismatch; HARNESS INVALID.' >&2
    exit 30
}
timeout 3s halcmd setp mux2.0.in1 "$SFB"
timeout 3s halcmd setp mux2.0.sel 1
printf 'stationary-freeze hold=%s cmd=%s\n' "$SFB" "$SCMD"

# 600 samples at the configured 1 ms servo period exceeds the immutable >=250-cycle gate.
halsampler -t -n 600 /tmp/s04-stationary.samples >/tmp/s04-stationary-halsampler.out 2>/tmp/s04-stationary-halsampler.err &
HS2_PID=$!
timeout 3s halcmd setp sampler.0.enable 1
if ! timeout 3s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep 0.02; done' _ "$HS2_PID"; then
    echo 'Stationary halsampler did not finish bounded capture.' >&2
    kill -TERM "$HS2_PID" 2>/dev/null || true
    wait "$HS2_PID" 2>/dev/null || true
    exit 31
fi
wait "$HS2_PID"
timeout 3s halcmd setp sampler.0.enable 0 || true
OV2="$(read_pin sampler.0.overruns)"
printf 'stationary-sampler-overruns=%s\n' "$OV2"
[[ "$OV2" == "0" ]]

# rtcompare sampler format: idx + 4 floats + 5 bits.
# Columns 2..9 retain the original S04 meanings; column 10 is realtime strict-cross.
awk -v cmd0="$SCMD" -v fb0="$SFB" '
function abs(x){return x<0?-x:x}
function b(v){return (v=="1" || v=="TRUE" || v=="true") ? 1 : 0}
{
    cmd=$2; fb=$3; fe=$4; lim=$5; fer=b($6); er=b($7); amp=b($8); mot=b($9); rtc=b($10)
    n++
    dc=abs(cmd-cmd0); df=abs(fb-fb0)
    if (dc>max_cmd_move) max_cmd_move=dc
    if (df>max_fb_move) max_fb_move=df
    if (abs(fe)>lim || rtc) overlim++
    if (fer) ferrored++
    if (er) errors++
    if (!mot) motion_off++
    if (!amp) amp_off++
}
END{
    printf("stationary-analysis cycles=%d max_cmd_move=%.9g max_fb_move=%.9g overlim=%d ferrored=%d errors=%d motion_off=%d amp_off=%d\n",n,max_cmd_move,max_fb_move,overlim,ferrored,errors,motion_off,amp_off)
    if (n < 250) exit 40
    if (max_cmd_move > 1e-6 || max_fb_move > 1e-6) exit 41
    if (overlim || ferrored || errors || motion_off || amp_off) exit 42
}
' /tmp/s04-stationary.samples | tee /tmp/s04-stationary-analysis.txt
printf 'gate-D-stationary-frozen-control=PASS\n'

# Return only the feedback fault injection to healthy live loopback. The same
# LinuxCNC process remains running; prove it is still enabled before moving test.
timeout 3s halcmd setp mux2.0.sel 0
sleep 0.05
M0="$(read_pin motion.motion-enabled)"
A0="$(read_pin joint.0.amp-enable-out)"
F0="$(read_pin joint.0.f-errored)"
E0="$(read_pin joint.0.error)"
printf 'post-control-live-loopback motion=%s amp=%s f-errored=%s error=%s\n' "$M0" "$A0" "$F0" "$E0"
is_true_value "$M0" && is_true_value "$A0" && is_false_value "$F0" && is_false_value "$E0" || {
    echo 'HARNESS INVALID: stationary control did not leave shared runtime healthy.' >&2
    exit 43
}

"""
s = s[:pos] + stationary + s[pos:]

# Gate A/B/C must reuse the already-proven shared runtime, not launch another one.
s, n = re.subn(r'(rm -f /tmp/s04-moving\.samples /tmp/s04-errors\.txt\n)start_runtime moving\n',
               r'\1printf \'shared-runtime-reuse-for-moving=PASS\\n\'\n', s, count=1)
if n != 1:
    raise SystemExit('HARNESS INVALID: could not convert moving phase to shared runtime')

# Re-running enable_machine is intentional: it verifies the same runtime remains
# commandable and healthy after stationary freeze/unfreeze; it does not restart HAL.
p.write_text(s)
PY_SINGLE_RUNTIME
bash -n "$TMP"
exec bash "$TMP"
'''
s = s.replace(needle, replacement, 1)
p.write_text(s)
PY

bash -n "$WRAPPER_TMP"
exec bash "$WRAPPER_TMP"
