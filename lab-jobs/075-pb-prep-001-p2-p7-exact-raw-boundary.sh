#!/usr/bin/env bash
set -euo pipefail

# Third attempt in the 073-075 materially redesigned construction cycle.
# Source inspection shows 068 closes oldnets/newnets on the SAME line as the
# final HAL command (`...false'''`), so 073's helper incorrectly searched for
# a newline before the closing triple quote and overran the intended block.
# Correct only that parser boundary and assert oldnets ends before newnets.
# Frozen A/B/C behavioral contract remains unchanged.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/074-pb-prep-001-p2-p7-scoped-prefix-proof.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-075-exact-raw-boundary.sh"
cp "$SRC" "$FIXED"

python3 - "$FIXED" <<'PATCH075'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()

old='    b = text.index("\\n\'\'\'", a)\n    return a, b, text[a:b]\n'
new='    b = text.index("\'\'\'", a)\n    return a, b, text[a:b]\n'
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: 075 raw-boundary helper patch point count={s.count(old)}')
s=s.replace(old,new,1)

anchor="_new_a, _new_b, _new_before = _raw_block(s, 'newnets')\n"
insert="if not (_old_b < _new_a < _new_b):\n    raise SystemExit(f'HARNESS_INVALID: structural block order old_b={_old_b} new_a={_new_a} new_b={_new_b}')\n"
if s.count(anchor) != 1:
    raise SystemExit(f'HARNESS_INVALID: 075 ordering assertion anchor count={s.count(anchor)}')
s=s.replace(anchor,anchor+insert,1)

p.write_text(s)
PATCH075

bash -n "$FIXED"
printf '%s\n' 'PB-PREP-001 075: exact same-line raw-string boundary parser installed; third redesigned-cycle attempt.'
exec bash "$FIXED"
