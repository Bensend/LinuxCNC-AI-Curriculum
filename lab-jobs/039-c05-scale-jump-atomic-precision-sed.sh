#!/usr/bin/env bash
set -euo pipefail

# C05-029 harness correction after attempt 9. Preserve job 037's one-FIFO
# 20-field atomic realtime transport and frozen Gates A-H. Correct only:
#  (a) the inherited 030 generator's deleted analyzer here-doc terminator; and
#  (b) userspace halsampler HAL_REAL text precision, using a simple verified sed
#      edit rather than a nested generated Python here-doc.

ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE030="$ROOT/lab-jobs/030-c05-scale-jump.sh"
BASE037="$ROOT/lab-jobs/037-c05-scale-jump-single-atomic-sampler.sh"
FIX030="${RUNNER_TEMP:-/tmp}/039-c05-030-fixed.sh"
RUN037="${RUNNER_TEMP:-/tmp}/039-c05-037-driver.sh"

[[ -f "$BASE030" && -f "$BASE037" && -f "$ROOT/lab-jobs/028-c05-feedback-freeze.sh" ]] || {
  echo 'HARNESS_INVALID: required C05 ancestor missing' >&2; exit 90;
}

python3 - "$BASE030" "$FIX030" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()

def one(old,new,label):
    global s
    n=s.count(old)
    if n != 1:
        raise SystemExit(f'HARNESS_INVALID: 039 patch {label} count={n}')
    s=s.replace(old,new,1)

one('src=src[:ana_start]+analyzer+src[ana_end+len("\\nPY"):]',
    'src=src[:ana_start]+analyzer+src[ana_end:]',
    'retain-analyzer-heredoc-end')

marker="# Replace HAL heredoc while retaining the proven INI/build/startup envelope."
if s.count(marker) != 1:
    raise SystemExit('HARNESS_INVALID: 039 observer insertion marker mismatch')

# This code executes inside the outer 030 Python generator and modifies the
# generated 028 shell body. Avoid nested generated here-docs completely.
inject = r'''# Observer-only text precision patch. This changes only the userspace
# sampler_usr.c printf format before build; realtime sampler/controller code is untouched.
obs_anchor = './debian/configure uspace'
obs_shell = r''' + repr('''OBS_SRC=src/hal/components/sampler_usr.c
OBS_OLD='printf ( "%f ", buf[n].f);'
OBS_NEW='printf ( "%.17g ", buf[n].f);'
OBS_COUNT="$(grep -F -c "$OBS_OLD" "$OBS_SRC" || true)"
[[ "$OBS_COUNT" == "1" ]] || { echo "HARNESS_INVALID: pinned halsampler %f anchor count=$OBS_COUNT" >&2; exit 23; }
sed -i 's/printf ( "%f ", buf\[n\]\.f);/printf ( "%.17g ", buf[n].f);/' "$OBS_SRC"
grep -Fq "$OBS_NEW" "$OBS_SRC" || { echo 'HARNESS_INVALID: %.17g observer patch missing after sed' >&2; exit 24; }
printf '%s\\n' 'observer-format=HAL_REAL %.17g; observer-only source patch=yes'
printf 'observer-source-sha256=%s\\n' "$(sha256sum "$OBS_SRC" | awk '{print $1}')"
git diff -- "$OBS_SRC"

./debian/configure uspace''') + r'''
if src.count(obs_anchor) != 1:
    raise SystemExit(f'HARNESS_INVALID: generated configure anchor count={src.count(obs_anchor)}')
src=src.replace(obs_anchor, obs_shell, 1)

'''
s=s.replace(marker, inject+marker, 1)
Path(sys.argv[2]).write_text(s)
PY
chmod +x "$FIX030"
export C05_FIXED_030="$FIX030"

python3 - "$BASE037" "$RUN037" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()
old='BASE="$ROOT/lab-jobs/030-c05-scale-jump.sh"'
new='BASE="${C05_FIXED_030:?}"'
if s.count(old) != 1:
    raise SystemExit(f'HARNESS_INVALID: 039 job-037 base anchor count={s.count(old)}')
Path(sys.argv[2]).write_text(s.replace(old,new,1))
PY
chmod +x "$RUN037"

printf '%s\n' 'C05-029 attempt 10: one 20-field atomic realtime FIFO; verified %.17g userspace observer serialization; frozen Gates A-H unchanged.'
printf 'fixed-030-sha256=%s\n' "$(sha256sum "$FIX030" | awk '{print $1}')"
printf 'driver-037-sha256=%s\n' "$(sha256sum "$RUN037" | awk '{print $1}')"
exec bash "$RUN037"
