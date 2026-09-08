#!/usr/bin/env bash
set -euo pipefail

# C05-029 attempt after attempt-8 reconciliation.
# Keep the source-audited one-FIFO/20-field transport from job 037, but correct
# two observation-generator defects only:
#   1. retain the generated analyzer's closing PY here-doc delimiter;
#   2. patch the pinned-tree userspace halsampler HAL_REAL printf from %f to
#      %.17g before build, preserving round-trip precision for frozen 1e-9 gates.
# No realtime component/control/fault/gate/threshold value changes.

ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE030="$ROOT/lab-jobs/030-c05-scale-jump.sh"
BASE037="$ROOT/lab-jobs/037-c05-scale-jump-single-atomic-sampler.sh"
FIX030="${RUNNER_TEMP:-/tmp}/038-c05-030-fixed.sh"
RUN037="${RUNNER_TEMP:-/tmp}/038-c05-037-driver.sh"

[[ -f "$BASE030" ]] || { echo "HARNESS_INVALID: missing $BASE030" >&2; exit 90; }
[[ -f "$BASE037" ]] || { echo "HARNESS_INVALID: missing $BASE037" >&2; exit 90; }
[[ -f "$ROOT/lab-jobs/028-c05-feedback-freeze.sh" ]] || { echo "HARNESS_INVALID: missing inherited 028 source" >&2; exit 90; }

python3 - "$BASE030" "$FIX030" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()

def one(old,new,label):
    global s
    n=s.count(old)
    if n != 1:
        raise SystemExit(f'HARNESS_INVALID: 038 patch {label} count={n}')
    s=s.replace(old,new,1)

# Attempt 8 proved this splice deleted the shell's analyzer here-doc terminator.
one('src=src[:ana_start]+analyzer+src[ana_end+len("\\nPY"):]',
    'src=src[:ana_start]+analyzer+src[ana_end:]',
    'retain-analyzer-heredoc-end')

# Insert an observer-only source serialization patch into the generated 028 body
# after exact pinned checkout verification and before configure/build. The
# realtime sampler, HAL components, motion, PID, plant and fault paths are not
# modified. %.17g is sufficient to round-trip a binary64 HAL_REAL through text.
marker="# Replace HAL heredoc while retaining the proven INI/build/startup envelope."
if s.count(marker) != 1:
    raise SystemExit('HARNESS_INVALID: 038 observer insertion marker mismatch')
inject=r'''# Observation-only precision correction for frozen 1e-9 residual gates.
# Pinned sampler_usr.c serializes HAL_REAL with %f (six decimals); replace only
# that userspace printf before build and retain explicit diff/hash evidence.
build_anchor=''' + repr('''[[ "$ACTUAL_COMMIT" == "$LINUXCNC_COMMIT" ]] || { echo 'HARNESS_INVALID: pinned checkout mismatch' >&2; exit 20; }

./debian/configure uspace''') + r'''
observer_patch=r''' + repr('''[[ "$ACTUAL_COMMIT" == "$LINUXCNC_COMMIT" ]] || { echo 'HARNESS_INVALID: pinned checkout mismatch' >&2; exit 20; }

python3 - <<'PYPREC'
from pathlib import Path
p=Path('src/hal/components/sampler_usr.c')
s=p.read_text()
old='printf ( "%f ", buf[n].f);'
new='printf ( "%.17g ", buf[n].f);'
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: pinned halsampler real-format anchor count={s.count(old)}')
p.write_text(s.replace(old,new,1))
PYPREC
printf 'observer-format=HAL_REAL-%.17g observer-only-patch=yes\\n'
printf 'observer-source-sha256=%s\\n' "$(sha256sum src/hal/components/sampler_usr.c | awk '{print $1}')"
git diff -- src/hal/components/sampler_usr.c

./debian/configure uspace''') + r'''
if src.count(build_anchor) != 1:
    raise SystemExit(f'HARNESS_INVALID: observer build anchor count={src.count(build_anchor)}')
src=src.replace(build_anchor,observer_patch,1)

'''
s=s.replace(marker,inject+marker,1)
Path(sys.argv[2]).write_text(s)
PY

chmod +x "$FIX030"
export C05_FIXED_030="$FIX030"

# Reuse the reviewed job-037 atomic-transport patch verbatim, changing only its
# base input path to the corrected temporary 030 generator above.
python3 - "$BASE037" "$RUN037" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()
old='BASE="$ROOT/lab-jobs/030-c05-scale-jump.sh"'
new='BASE="${C05_FIXED_030:?}"'
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: 038 job-037 base anchor count={s.count(old)}')
Path(sys.argv[2]).write_text(s.replace(old,new,1))
PY
chmod +x "$RUN037"

printf '%s\n' 'C05-029 attempt 9: one 20-field atomic realtime FIFO; round-trip-safe userspace float serialization; frozen Gates A-H unchanged.'
printf 'base-030-sha256=%s\n' "$(sha256sum "$BASE030" | awk '{print $1}')"
printf 'base-037-sha256=%s\n' "$(sha256sum "$BASE037" | awk '{print $1}')"
printf 'fixed-030-sha256=%s\n' "$(sha256sum "$FIX030" | awk '{print $1}')"
printf 'driver-037-sha256=%s\n' "$(sha256sum "$RUN037" | awk '{print $1}')"
exec bash "$RUN037"
