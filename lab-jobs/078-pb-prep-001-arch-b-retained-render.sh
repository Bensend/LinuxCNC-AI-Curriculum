#!/usr/bin/env bash
set -euo pipefail

# Harness-only timeout correction after 077. Execute architecture B from the
# exact 076-retained frozen render while skipping A/C packaging calls. No
# behavioral constant, phase, threshold, sampler semantic, or outcome rule is
# changed. A/B/C evidence is audited together only after all three traces exist.
SRC="${GITHUB_WORKSPACE:?}/lab-results/pb-prep-001-076-preflight/behavioral-rendered.sh"
EXPECTED="7c185fb0af4b056d7e9406de164a79ae6eb30d06510a6b3ce77ed12d46c4a0e6"
[[ -f "$SRC" ]] || { echo 'HARNESS_INVALID: retained 076 render missing' >&2; exit 41; }
ACTUAL="$(sha256sum "$SRC" | awk '{print $1}')"
[[ "$ACTUAL" == "$EXPECTED" ]] || { echo "HARNESS_INVALID: retained render digest drift expected=$EXPECTED actual=$ACTUAL" >&2; exit 42; }
TMP="${RUNNER_TEMP:-/tmp}/pb-prep-001-078-b-only.sh"
python3 - "$SRC" "$TMP" <<'PY'
import sys
src,dst=sys.argv[1:]
s=open(src).read()
# Packaging-only transform: preserve function/model verbatim, suppress only the
# top-level A and C invocations so B gets the runner budget by itself.
repls=[('run_arch A 0', ': # 078 packaging skip run_arch A 0'),
       ('run_arch C 2', ': # 078 packaging skip run_arch C 2')]
for old,new in repls:
    if s.count(old) != 1:
        raise SystemExit(f'HARNESS_INVALID: expected exactly one top-level token {old!r}, found {s.count(old)}')
    s=s.replace(old,new)
open(dst,'w').write(s)
PY
bash -n "$TMP"
# Prove that the frozen constants and B invocation survived unchanged.
grep -Fx 'run_arch B 1' "$TMP" >/dev/null || { echo 'HARNESS_INVALID: B invocation missing' >&2; exit 43; }
for frozen in 'ROWS=12000' 'U_MAX=2.0' 'SYNC_GAIN=1.0' 'DIFF_MAX=0.25' 'PGAIN=6.0' 'LINUXCNC_REF="8bf4605ae81042248add031e94c77300406e0413"'; do
  grep -F "$frozen" "$TMP" >/dev/null || { echo "HARNESS_INVALID: frozen token missing: $frozen" >&2; exit 44; }
done
printf '%s\n' "PB-PREP-001 078 source digest verified: $ACTUAL"
printf '%s\n' 'PB-PREP-001 078 packaging-only execution: B enabled; A/C top-level calls suppressed; frozen behavioral contract unchanged.'
exec bash "$TMP"
