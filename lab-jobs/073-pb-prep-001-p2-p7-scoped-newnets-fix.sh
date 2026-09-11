#!/usr/bin/env bash
set -euo pipefail

# PB-PREP-001 material harness redesign after the explicit 070-072 three-attempt
# decision. This revision changes construction mechanics only: it scopes the HAL
# sampler-tap rewrite to the packed `newnets` raw-string block, proves `oldnets`
# is unchanged, retains 071's generator execution-mode correction, and extends
# rendered static validation. Frozen behavioral parameters/Gates are unchanged.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/070-pb-prep-001-p2-p7-render-validated-packed.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-073-scoped-newnets.sh"
cp "$SRC" "$FIXED"

python3 - "$FIXED" <<'PATCH073'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()

# Retain 071's execution-mode correction for the temporary generator.
old_exec='exec "$GEN"\n'
if s.count(old_exec) != 1:
    raise SystemExit(f'HARNESS_INVALID: expected one generator exec, found {s.count(old_exec)}')
s=s.replace(old_exec,'exec bash "$GEN"\n',1)

# Inject the structural rewrite into 070's inner Python transformer. At runtime
# that transformer operates on 068, where oldnets/newnets are literal payloads.
anchor="strip_raw_terminal('analyzer', 'PY')\n"
if s.count(anchor) != 1:
    raise SystemExit(f'HARNESS_INVALID: structural insertion anchor count={s.count(anchor)}')
insert=r"""

# 073 structural sampler-tap correction: edit ONLY the packed newnets block.
def _raw_block(text, varname):
    marker = varname + "=" + "'''"
    a = text.index(marker) + len(marker)
    b = text.index("\n'''", a)
    return a, b, text[a:b]

_old_a, _old_b, _old_before = _raw_block(s, 'oldnets')
_new_a, _new_b, _new_before = _raw_block(s, 'newnets')
_pairs = (
    ('net sr1 y1cmd => sampler.0.pin.2', 'net y1cmd => sampler.0.pin.2'),
    ('net sr2 y2cmd => sampler.0.pin.3', 'net y2cmd => sampler.0.pin.3'),
    ('net sy1 y1fb => sampler.0.pin.4', 'net y1fb => sampler.0.pin.4'),
    ('net sy2 y2fb => sampler.0.pin.5', 'net y2fb => sampler.0.pin.5'),
    ('net sref1 ref1 => sampler.0.pin.9', 'net ref1 => sampler.0.pin.9'),
    ('net sref2 ref2 => sampler.0.pin.10', 'net ref2 => sampler.0.pin.10'),
    ('net spid1 pid1out => sampler.0.pin.11', 'net pid1out => sampler.0.pin.11'),
    ('net spid2 pid2out => sampler.0.pin.12', 'net pid2out => sampler.0.pin.12'),
)
_new_after = _new_before
for _bad, _good in _pairs:
    if _new_after.count(_bad) != 1:
        raise SystemExit(f'HARNESS_INVALID: newnets expected one {_bad!r}, found {_new_after.count(_bad)}')
    _new_after = _new_after.replace(_bad, _good, 1)
for _bad, _good in _pairs:
    if _bad in _new_after:
        raise SystemExit(f'HARNESS_INVALID: invalid packed sampler form remains in newnets: {_bad}')
    if _new_after.count(_good) != 1:
        raise SystemExit(f'HARNESS_INVALID: corrected packed sampler form count != 1: {_good}')

# Replace exactly the previously located newnets body; no global replacement.
s = s[:_new_a] + _new_after + s[_new_b:]
_old2_a, _old2_b, _old_after = _raw_block(s, 'oldnets')
if _old_after != _old_before:
    raise SystemExit('HARNESS_INVALID: oldnets changed during scoped newnets transformation')
"""
s=s.replace(anchor,anchor+insert,1)

# Extend the fully rendered-script validation so the direct signal joins are
# independently checked after 068 has transformed 067 into the executable job.
validate_anchor="print('PB-PREP-001 070 rendered-script static validation: PASS')\n"
if s.count(validate_anchor) != 1:
    raise SystemExit(f'HARNESS_INVALID: rendered validation anchor count={s.count(validate_anchor)}')
extra=r"""for bad in (
    'net sr1 y1cmd => sampler.0.pin.2',
    'net sr2 y2cmd => sampler.0.pin.3',
    'net sy1 y1fb => sampler.0.pin.4',
    'net sy2 y2fb => sampler.0.pin.5',
    'net sref1 ref1 => sampler.0.pin.9',
    'net sref2 ref2 => sampler.0.pin.10',
    'net spid1 pid1out => sampler.0.pin.11',
    'net spid2 pid2out => sampler.0.pin.12',
):
    if bad in q:
        raise SystemExit(f'HARNESS_INVALID: rendered invalid sampler tap remains: {bad}')
for good in (
    'net y1cmd => sampler.0.pin.2',
    'net y2cmd => sampler.0.pin.3',
    'net y1fb => sampler.0.pin.4',
    'net y2fb => sampler.0.pin.5',
    'net ref1 => sampler.0.pin.9',
    'net ref2 => sampler.0.pin.10',
    'net pid1out => sampler.0.pin.11',
    'net pid2out => sampler.0.pin.12',
):
    if q.count(good) != 1:
        raise SystemExit(f'HARNESS_INVALID: rendered direct sampler join count != 1: {good}')

"""
s=s.replace(validate_anchor,extra+validate_anchor,1)

p.write_text(s)
PATCH073

bash -n "$FIXED"
printf '%s\n' 'PB-PREP-001 073: scoped newnets construction validation passed; running render-validated frozen experiment.'
exec bash "$FIXED"
