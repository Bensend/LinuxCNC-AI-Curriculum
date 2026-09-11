#!/usr/bin/env bash
set -euo pipefail

# Harness-only correction to 073's oldnets immutability oracle. The permitted
# newnets edit is strictly after oldnets, so preserve and compare the exact byte
# prefix through oldnets instead of re-parsing the already-mutated generator.
# Frozen behavioral contract remains unchanged.

SRC="${GITHUB_WORKSPACE:?}/lab-jobs/073-pb-prep-001-p2-p7-scoped-newnets-fix.sh"
FIXED="${RUNNER_TEMP:-/tmp}/pb-prep-001-074-prefix-proof.sh"
cp "$SRC" "$FIXED"

python3 - "$FIXED" <<'PATCH074'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()

old="_old_a, _old_b, _old_before = _raw_block(s, 'oldnets')\n_new_a, _new_b, _new_before = _raw_block(s, 'newnets')\n"
new="_old_a, _old_b, _old_before = _raw_block(s, 'oldnets')\n_old_prefix = s[:_old_b]\n_new_a, _new_b, _new_before = _raw_block(s, 'newnets')\n"
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: 074 prefix-capture patch point count={s.count(old)}')
s=s.replace(old,new,1)

old2="_old2_a, _old2_b, _old_after = _raw_block(s, 'oldnets')\nif _old_after != _old_before:\n    raise SystemExit('HARNESS_INVALID: oldnets changed during scoped newnets transformation')\n"
new2="if s[:_old_b] != _old_prefix:\n    raise SystemExit('HARNESS_INVALID: bytes through oldnets changed during scoped newnets transformation')\n"
if s.count(old2) != 1:
    raise SystemExit(f'HARNESS_INVALID: 074 prefix-proof patch point count={s.count(old2)}')
s=s.replace(old2,new2,1)

p.write_text(s)
PATCH074

bash -n "$FIXED"
printf '%s\n' 'PB-PREP-001 074: oldnets immutability now proven by preserved byte prefix; frozen behavioral contract unchanged.'
exec bash "$FIXED"
