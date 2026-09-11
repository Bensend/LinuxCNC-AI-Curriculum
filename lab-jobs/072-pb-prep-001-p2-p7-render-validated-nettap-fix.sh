#!/usr/bin/env bash
set -euo pipefail

# Harness-only HAL observability wiring correction after 071 retained fixture
# proved that the sampler tap lines attempted to treat existing signal names as
# pins. Start from the render-validated 070 construction path, retain its static
# validation, invoke temp generator through bash, and change only sampler taps to
# join the already-created command/feedback/reference/PID-output signals.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/070-pb-prep-001-p2-p7-render-validated-packed.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-072-nettap-fix.sh"
cp "$SRC" "$FIXED"

python3 - "$FIXED" <<'PATCH072'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()

# Preserve 071's execution-mode correction.
old_exec='exec "$GEN"\n'
if s.count(old_exec) != 1:
    raise SystemExit(f'HARNESS_INVALID: expected one generator exec, found {s.count(old_exec)}')
s=s.replace(old_exec,'exec bash "$GEN"\n',1)

# Insert the HAL net-tap correction into 070's transformation of the frozen 068
# packed harness, after raw-string terminal ownership has been normalized.
anchor="strip_raw_terminal('analyzer', 'PY')\n"
if s.count(anchor) != 1:
    raise SystemExit(f'HARNESS_INVALID: nettap insertion anchor count={s.count(anchor)}')
insert=r'''

# HAL `net` takes a signal name followed by pins. The original packed newnets
# block attempted `net sr1 y1cmd => sampler...`, where y1cmd is already a signal,
# not a pin. Join the sampler directly to each existing signal instead.
for old, new in (
    ('net sr1 y1cmd => sampler.0.pin.2', 'net y1cmd => sampler.0.pin.2'),
    ('net sr2 y2cmd => sampler.0.pin.3', 'net y2cmd => sampler.0.pin.3'),
    ('net sy1 y1fb => sampler.0.pin.4', 'net y1fb => sampler.0.pin.4'),
    ('net sy2 y2fb => sampler.0.pin.5', 'net y2fb => sampler.0.pin.5'),
    ('net sref1 ref1 => sampler.0.pin.9', 'net ref1 => sampler.0.pin.9'),
    ('net sref2 ref2 => sampler.0.pin.10', 'net ref2 => sampler.0.pin.10'),
    ('net spid1 pid1out => sampler.0.pin.11', 'net pid1out => sampler.0.pin.11'),
    ('net spid2 pid2out => sampler.0.pin.12', 'net pid2out => sampler.0.pin.12'),
):
    if s.count(old) != 1:
        raise SystemExit(f'HARNESS_INVALID: expected one packed sampler tap {old!r}, found {s.count(old)}')
    s=s.replace(old,new,1)
'''
s=s.replace(anchor,anchor+insert,1)

p.write_text(s)
PATCH072

bash -n "$FIXED"
printf '%s\n' 'PB-PREP-001 072: sampler taps now reuse existing HAL signals; frozen behavioral contract unchanged.'
exec bash "$FIXED"
