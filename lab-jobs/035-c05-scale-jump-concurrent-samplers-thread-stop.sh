#!/usr/bin/env bash
set -euo pipefail

# C05-029 redesigned observation transport, attempt 6.
# Harness-only correction after attempt 5 showed one terminal sample present
# only in FIFO A. Preserve the two concurrent readers and exact join, but stop
# the realtime thread once instead of disabling sampler.0 and sampler.1 with
# separate userspace writes.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/033-c05-scale-jump-concurrent-samplers.sh"
TMP="${RUNNER_TEMP:-/tmp}/035-c05-scale-jump-concurrent-samplers-thread-stop.sh"

[[ -f "$BASE" ]] || { echo "HARNESS_INVALID: missing $BASE" >&2; exit 90; }
[[ -f "$ROOT/lab-jobs/028-c05-feedback-freeze.sh" ]] || { echo "HARNESS_INVALID: missing inherited 028 source" >&2; exit 90; }

python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys

s=Path(sys.argv[1]).read_text()

def replace_one(old,new,label):
    global s
    n=s.count(old)
    if n != 1:
        raise SystemExit(f'HARNESS_INVALID: 035 patch {label} count={n}')
    s=s.replace(old,new,1)

# Retain the staging repair from 034: the isolated generator root used by 033
# must contain the inherited 028 source that 030 ultimately reads.
replace_one(
    'mkdir -p "$TMPROOT/root/lab-jobs"\n\n# 032 expects 031 at ROOT/lab-jobs.',
    'mkdir -p "$TMPROOT/root/lab-jobs"\ncp "$ROOT/lab-jobs/028-c05-feedback-freeze.sh" "$TMPROOT/root/lab-jobs/028-c05-feedback-freeze.sh"\n\n# 032 expects 031 at ROOT/lab-jobs.',
    'stage-028')

# 033 already patches the generated 031 transport to use two concurrent
# halsampler readers. Extend that same generator patch with one additional
# observation-only transformation: replace the two sequential per-sampler
# disable writes with one HAL realtime-thread stop. The exact join remains
# unchanged and therefore still rejects any unequal sample-number sets.
anchor="one(start,repl,'remove-deferred-drain')"
insert=anchor + r'''
one(
    'halcmd setp sampler.0.enable false\\nhalcmd setp sampler.1.enable false\\nOVERRUNS=',
    'halcmd stop\\nOVERRUNS=',
    'single-realtime-thread-stop')'''
replace_one(anchor,insert,'thread-stop-injection')

Path(sys.argv[2]).write_text(s)
PY

chmod +x "$TMP"
printf '%s\n' 'C05-029 attempt 6 correction=post-acquisition realtime-thread stop only; concurrent readers, exact join, frozen Gates A-H and behavioral values unchanged.'
printf 'base-033-sha256=%s\n' "$(sha256sum "$BASE" | awk '{print $1}')"
printf 'patched-035-sha256=%s\n' "$(sha256sum "$TMP" | awk '{print $1}')"
exec bash "$TMP"
