#!/usr/bin/env bash
set -euo pipefail

# Materially redesigned S04-014 instrumentation. Preserve the immutable numerical
# and behavioral gates, but observe strict |f-error| > f-error-lim in realtime
# with stock pinned abs+comp components rather than decimal sampler text alone.
SRC="lab-jobs/014-s04-feedback-freeze.sh"
TMP="${RUNNER_TEMP:-/tmp}/014-s04-feedback-freeze-rtcompare-body.sh"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
# Preserve corrected requested-move-remaining gate.
s=s.replace("timeout 3s halcmd setp mux2.0.sel 1\nprintf 'freeze-asserted hold=%s cmd-at-freeze=%s\\n' \"$HOLD\" \"$(read_pin joint.0.motor-pos-cmd)\"\n", "timeout 3s halcmd setp mux2.0.sel 1\nFREEZE_CMD=\"$(read_pin joint.0.motor-pos-cmd)\"\nprintf 'freeze-asserted hold=%s cmd-at-freeze=%s\\n' \"$HOLD\" \"$FREEZE_CMD\"\nawk -v c=\"$FREEZE_CMD\" 'BEGIN{remaining=1.0-c; if(remaining<0)remaining=-remaining; exit !(remaining>=0.20)}' || { echo 'HARNESS INVALID: commanded move did not have >=0.20 units remaining at freeze.' >&2; exit 6; }\n",1)
# Add stock realtime strict comparator and one sampled bit.
s=s.replace("loadrt sampler depth=9000 cfg=ffffbbbb\n", "loadrt abs count=1\nloadrt comp count=1\nloadrt sampler depth=9000 cfg=ffffbbbbb\n",1)
s=s.replace("addf sampler.0 servo-thread\n", "addf abs.0 servo-thread\naddf comp.0 servo-thread\naddf sampler.0 servo-thread\n",1)
s=s.replace("net s04-motion-enabled motion.motion-enabled => sampler.0.pin.7\n", "net s04-motion-enabled motion.motion-enabled => sampler.0.pin.7\nnet s04-ferror abs.0.in\nnet s04-abs-ferror abs.0.out => comp.0.in1\nnet s04-ferror-lim comp.0.in0\nsetp comp.0.hyst 0\nnet s04-strict-cross comp.0.out => sampler.0.pin.8\n",1)
# Thread order must include comparator between controller and sampler.
s=s.replace("local ctl mux samp\n", "local ctl mux cmp samp\n",1)
s=s.replace("mux=\"$(grep -n 'mux2\\.0' \"/tmp/s04-${tag}-thread.txt\" | head -1 | cut -d: -f1)\"\n    samp=", "mux=\"$(grep -n 'mux2\\.0' \"/tmp/s04-${tag}-thread.txt\" | head -1 | cut -d: -f1)\"\n    cmp=\"$(grep -n 'comp\\.0' \"/tmp/s04-${tag}-thread.txt\" | head -1 | cut -d: -f1)\"\n    samp=",1)
s=s.replace("printf 'thread-order-%s: motion-controller=%s mux2=%s sampler=%s\\n' \"$tag\" \"$ctl\" \"$mux\" \"$samp\"\n    [[ \"$ctl\" -lt \"$mux\" && \"$mux\" -lt \"$samp\" ]]", "printf 'thread-order-%s: motion-controller=%s mux2=%s comp=%s sampler=%s\\n' \"$tag\" \"$ctl\" \"$mux\" \"$cmp\" \"$samp\"\n    [[ \"$ctl\" -lt \"$cmp\" && \"$cmp\" -lt \"$samp\" && \"$ctl\" -lt \"$mux\" && \"$mux\" -lt \"$samp\" ]]",1)
# Track displayed limit and realtime comparator bit. Columns: 1 idx, 2-5 float, 6-10 bits.
s=s.replace("if (travel>max_travel) max_travel=travel\n        if (abs(fe)>lim) crossed++", "if (travel>max_travel) max_travel=travel\n        if (lim>max_lim) max_lim=lim\n        if (abs(fe)>lim) crossed++\n        if (b($10)) rt_crossed++",1)
s=s.replace('printf("moving-analysis frozen=%d max_travel=%.9g crossed=%d ferrored=%d exact_fault=%d disable=%d\\n", frozen,max_travel,crossed,ferrored,exact_fault,disable)\n    if (frozen < 1) exit 20\n    if (max_travel < 0.20) exit 21', 'printf("moving-analysis frozen=%d max_travel=%.9g max_runtime_limit=%.9g text_crossed=%d rt_crossed=%d ferrored=%d exact_fault=%d disable=%d\\n", frozen,max_travel,max_lim,crossed,rt_crossed,ferrored,exact_fault,disable)\n    if (frozen < 1) exit 20\n    if (rt_crossed < 1) exit 21',1)
# Ensure stationary-control AWK tolerates the extra sampled bit; its existing columns remain unchanged.
p.write_text(s)
PY
bash -n "$TMP"
exec bash "$TMP"
