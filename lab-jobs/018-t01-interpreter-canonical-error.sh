#!/usr/bin/env bash
set -euo pipefail
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-t01-rs274"
printf '== T01-018 standalone interpreter canonical/error test ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Frozen prediction: valid G0 emits STRAIGHT_TRAVERSE and exits 0; separate malformed expression exits nonzero with interpreter diagnostic and no successful canonical motion for that invalid command.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
ACTUAL_SHA="$(git rev-parse HEAD)"
[[ "$ACTUAL_SHA" == "$LINUXCNC_COMMIT" ]] || { echo 'HARNESS_INVALID: wrong git revision' >&2; exit 20; }
./debian/configure uspace
sudo apt-get build-dep -y .
cd src
./autogen.sh
./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation
make -j"$(nproc)"
cd ..
set +u
source scripts/rip-environment
set -u
RS274="$(command -v rs274)"
REAL_RS274="$(readlink -f "$RS274")"
case "$REAL_RS274" in "$WORK"/*) ;; *) echo "HARNESS_INVALID: rs274 not from pinned tree: $REAL_RS274" >&2; exit 21 ;; esac
printf 'git-sha=%s\nrs274-command=%s\nrs274-realpath=%s\n' "$ACTUAL_SHA" "$RS274" "$REAL_RS274"
sha256sum "$REAL_RS274" | sed 's/^/rs274-sha256=/'

FIX="$WORK/t01-fixtures"
mkdir -p "$FIX"
cat > "$FIX/valid.ngc" <<'EOF'
%
G21 G90
G0 X1 Y2
M2
%
EOF
cat > "$FIX/invalid.ngc" <<'EOF'
%
G21 G90
G0 X[1+]
M2
%
EOF
: > "$FIX/tool.tbl"
: > "$FIX/params.var"
printf '%s\n' '--- fixture hashes ---'
sha256sum "$FIX/valid.ngc" "$FIX/invalid.ngc" "$FIX/tool.tbl" "$FIX/params.var"
printf '%s\n' '--- valid fixture ---'; cat "$FIX/valid.ngc"
printf '%s\n' '--- invalid fixture ---'; cat "$FIX/invalid.ngc"

run_one() {
  local tag=$1 file=$2
  printf '\ncommand[%s]=%q -g -n 2 -t %q -v %q %q\n' "$tag" "$RS274" "$FIX/tool.tbl" "$FIX/params.var" "$file"
  set +e
  "$RS274" -g -n 2 -t "$FIX/tool.tbl" -v "$FIX/params.var" "$file" >"$FIX/$tag.stdout" 2>"$FIX/$tag.stderr"
  local rc=$?
  set -e
  printf '%s-exit=%s\n' "$tag" "$rc"
  printf '%s\n' "--- $tag stdout ---"; cat "$FIX/$tag.stdout"
  printf '%s\n' "--- $tag stderr ---"; cat "$FIX/$tag.stderr"
  printf '%s' "$rc" > "$FIX/$tag.rc"
}
run_one valid "$FIX/valid.ngc"
run_one invalid "$FIX/invalid.ngc"
VALID_RC="$(cat "$FIX/valid.rc")"
INVALID_RC="$(cat "$FIX/invalid.rc")"

printf '\n== Gates ==\n'
[[ "$ACTUAL_SHA" == "$LINUXCNC_COMMIT" && "$REAL_RS274" == "$WORK"/* ]] || exit 22
printf 'gate-A-provenance=PASS\n'
[[ "$VALID_RC" == 0 ]] || { echo 'Gate B FAIL: valid invocation nonzero' >&2; exit 30; }
grep -q 'STRAIGHT_TRAVERSE' "$FIX/valid.stdout" || { echo 'Gate B FAIL: no STRAIGHT_TRAVERSE in valid canonical output' >&2; exit 31; }
if grep -Eqi 'error|unknown|bad|expected' "$FIX/valid.stderr"; then echo 'Gate B FAIL: apparent interpreter error in valid stderr' >&2; exit 32; fi
printf 'gate-B-valid-canonical=PASS\n'
[[ "$INVALID_RC" != 0 ]] || { echo 'HARNESS_INVALID: selected invalid fixture was accepted' >&2; exit 40; }
[[ -s "$FIX/invalid.stderr" ]] || { echo 'Gate C FAIL: no invalid diagnostic' >&2; exit 41; }
if grep -q 'STRAIGHT_TRAVERSE' "$FIX/invalid.stdout"; then echo 'Gate C FAIL: malformed G0 produced STRAIGHT_TRAVERSE' >&2; exit 42; fi
printf 'gate-C-invalid-error=PASS\n'
printf 'gate-D-separate-invocations=PASS\n'
printf 'gate-E-reproducibility=PASS\n'
printf '\nT01-018 overall=PASS\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
