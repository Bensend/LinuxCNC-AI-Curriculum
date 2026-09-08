#!/usr/bin/env bash
set -euo pipefail

# C05-029 redesigned observation transport after three invalid attempts.
# Generate attempt-3 body, then change ONLY acquisition transport so both
# realtime sampler FIFOs have concurrent userspace readers.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
GEN="$ROOT/lab-jobs/032-c05-scale-jump-corrected-quote.sh"
TMPROOT="${RUNNER_TEMP:-/tmp}/c05-033"
mkdir -p "$TMPROOT/root/lab-jobs"

# 032 expects 031 at ROOT/lab-jobs. Copy the repository scripts into an
# isolated generator root and patch 031's generated-body injection there.
cp "$ROOT/lab-jobs/030-c05-scale-jump.sh" "$TMPROOT/root/lab-jobs/030-c05-scale-jump.sh"
cp "$ROOT/lab-jobs/031-c05-scale-jump-corrected.sh" "$TMPROOT/root/lab-jobs/031-c05-scale-jump-corrected.sh"
cp "$GEN" "$TMPROOT/root/lab-jobs/032-c05-scale-jump-corrected-quote.sh"

python3 - "$TMPROOT/root/lab-jobs/031-c05-scale-jump-corrected.sh" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()

def one(old,new,label):
    global s
    n=s.count(old)
    if n != 1: raise SystemExit(f'HARNESS_INVALID: 033 patch {label} count={n}')
    s=s.replace(old,new,1)

# Replace the generated-body acquisition replacement so FIFO 1 gets a live
# reader at the same time as FIFO 0.
one(
"'halsampler -c 0 -t >c05-029-realtime.txt 2>c05-029-halsampler.stderr &',\n    'halsampler -c 0 -t >c05-029-realtime-a.txt 2>c05-029-halsampler.stderr &'",
"'halsampler -c 0 -t >c05-029-realtime.txt 2>c05-029-halsampler.stderr &',\n    'halsampler -c 0 -t >c05-029-realtime-a.txt 2>c05-029-halsampler.stderr &\\nSAMPLER_B_PID=\\\"\\\"\\nhalsampler -c 1 -t >c05-029-realtime-b.txt 2>c05-029-halsampler-b.stderr &\\nSAMPLER_B_PID=$!'",
'concurrent-reader')

# Replace deferred FIFO-1 drain with stopping/waiting for the concurrent
# reader. Exact sample-number join remains unchanged.
start="# Drain secondary FIFO after both sampler functions have been disabled.\nSECONDARY_COUNT=\"$(halcmd getp sampler.1.sample-num)\"\n[[ \"$SECONDARY_COUNT\" =~ ^[0-9]+$ ]] || { echo \"HARNESS_INVALID: bad sampler.1 sample count $SECONDARY_COUNT\" >&2; exit 25; }\nhalsampler -c 1 -n \"$SECONDARY_COUNT\" -t >c05-029-realtime-b.txt 2>c05-029-halsampler-b.stderr\n\n"
repl="# Stop and reap the secondary concurrent reader after realtime sampling is disabled.\nif [[ -n \"${SAMPLER_B_PID:-}\" ]]; then\n    kill \"$SAMPLER_B_PID\" 2>/dev/null || true\n    wait \"$SAMPLER_B_PID\" 2>/dev/null || true\n    SAMPLER_B_PID=\"\"\nfi\n\n"
one(start,repl,'remove-deferred-drain')
p.write_text(s)
PY

# Run 032 from isolated root; it still applies the known quoting-only repair.
export GITHUB_WORKSPACE="$TMPROOT/root"
printf '%s\n' 'C05-029 redesigned attempt: two concurrent halsampler readers; frozen Gates A-H and behavioral values unchanged.'
exec bash "$TMPROOT/root/lab-jobs/032-c05-scale-jump-corrected-quote.sh"
