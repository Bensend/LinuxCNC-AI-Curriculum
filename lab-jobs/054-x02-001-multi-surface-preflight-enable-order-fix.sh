#!/usr/bin/env bash
set -euo pipefail

# X02-001 preflight harness-only correction, attempt 2.
# Session start marker: 2026-09-10T09:13:11Z.
#
# Attempt 1 attached sampler.0 to the running servo thread before disabling its
# default enable state. The retained artifact proves this admitted setup-time
# records (depth-before=11), including 0-valued payloads and jumps while the
# witness continued running. That invalidated the recorder-continuity guard
# without testing the frozen X02 behavioral predicates.
#
# Preserve 053's frozen P0-P4 phases, rates, fields, scorer, and Gates A-J.
# Change only sampler setup ordering: disable sampler BEFORE addf makes it
# runnable. This ensures the FIFO is empty when the explicit measurement enable
# occurs and prevents setup-time records from contaminating the 20,000 rows.

SRC="lab-jobs/053-x02-001-multi-surface-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/x02-054-preflight.sh"
python3 - "$SRC" "$TMP" <<'PY'
from pathlib import Path
import sys
src=Path(sys.argv[1]).read_text()
old='''halcmd loadrt x02_source\nhalcmd loadrt sampler depth="$RECORDER_DEPTH" cfg=ss\nhalcmd addf x02-source.0 servo-thread\nhalcmd addf sampler.0 servo-thread\nhalcmd net x02-cycle x02-source.0.cycle '=>' sampler.0.pin.0\nhalcmd net x02-motion-type motion.motion-type '=>' sampler.0.pin.1\nhalcmd setp sampler.0.enable 0\n'''
new='''halcmd loadrt x02_source\nhalcmd loadrt sampler depth="$RECORDER_DEPTH" cfg=ss\n# Harness-only correction: sampler must be disabled before it becomes runnable.\nhalcmd setp sampler.0.enable 0\nhalcmd addf x02-source.0 servo-thread\nhalcmd addf sampler.0 servo-thread\nhalcmd net x02-cycle x02-source.0.cycle '=>' sampler.0.pin.0\nhalcmd net x02-motion-type motion.motion-type '=>' sampler.0.pin.1\n'''
if src.count(old) != 1:
    raise SystemExit('HARNESS_INVALID: expected unique sampler setup block not found')
Path(sys.argv[2]).write_text(src.replace(old,new))
PY
chmod +x "$TMP"
exec "$TMP"
