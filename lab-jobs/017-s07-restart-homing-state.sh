#!/usr/bin/env bash
set -euo pipefail
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-s07-restart"
printf '== S07-017 fresh-runtime homing-state reset ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Prediction: ordinary joint.0 homed state established in runtime A is absent in genuinely fresh runtime B using the same unchanged INI, and can be re-established by homing B.'
printf '%s\n' 'Boundary: software lifecycle fixture only; no claim of physical position truth or safety integrity.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
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
cd tests/linuxcncrsh
INI=linuxcncrsh-test.ini
INI_HASH_BEFORE="$(sha256sum "$INI" | awk '{print $1}')"
rm -f /tmp/linuxcnc.lock s07-A.stdout s07-A.stderr s07-B.stdout s07-B.stderr

read_pin() { timeout 3s halcmd getp "$1" | tr -d '[:space:]'; }
is_true() { [[ "$1" == TRUE || "$1" == 1 ]]; }
is_false() { [[ "$1" == FALSE || "$1" == 0 ]]; }
wait_ready() {
  local label=$1
  for i in $(seq 1 120); do
    if nc -z localhost 5007 >/dev/null 2>&1 && timeout 3s halcmd show pin joint.0.homed >/tmp/s07-${label}-homed-pin.txt 2>/dev/null; then
      printf '%s-ready-probe=%s\n' "$label" "$i"
      return 0
    fi
    sleep 0.25
  done
  return 1
}
rsh_control() {
  local tag=$1; shift
  {
    printf '%s\n' 'set timestamp off'
    printf '%s\n' "hello EMC $tag"
    printf '%s\n' 'set echo off'
    printf '%s\n' 'set enable EMCTOO'
    printf '%s\n' 'set wait_mode done'
    for c in "$@"; do printf '%s\n' "$c"; done
    sleep 0.2
  } | timeout 8s nc localhost 5007
}
wait_homed() {
  local want=$1
  for _ in $(seq 1 120); do
    v="$(read_pin joint.0.homed)"
    if [[ "$want" == true ]] && is_true "$v"; then return 0; fi
    if [[ "$want" == false ]] && is_false "$v"; then return 0; fi
    sleep 0.05
  done
  return 1
}

printf '\n== Gate A/B: runtime A initial state then home ==\n'
linuxcnc -r "$INI" >s07-A.stdout 2>s07-A.stderr &
A_PID=$!
wait_ready A || { cat s07-A.stderr >&2 || true; exit 2; }
A_INITIAL="$(read_pin joint.0.homed)"
printf 'A-launcher-pid=%s A-initial-homed=%s\n' "$A_PID" "$A_INITIAL"
is_false "$A_INITIAL" || { echo 'HARNESS_INVALID: runtime A started homed' >&2; exit 20; }
timeout 3s halcmd show comp | tee /tmp/s07-A-components.txt
rsh_control s07A 'set estop off' 'set machine on' 'set mode manual' 'set home 0' >/tmp/s07-A-rsh.txt 2>/tmp/s07-A-rsh.err || true
cat /tmp/s07-A-rsh.txt || true
wait_homed true || { echo 'Runtime A failed to establish homed state' >&2; cat s07-A.stderr >&2 || true; exit 3; }
printf 'A-established-homed=%s\n' "$(read_pin joint.0.homed)"
printf 'gate-AB=PASS\n'

printf '\n== Gate C: orderly teardown and independent disappearance barrier ==\n'
kill -TERM "$A_PID"
for _ in $(seq 1 150); do
  if ! kill -0 "$A_PID" 2>/dev/null; then break; fi
  sleep 0.1
done
if kill -0 "$A_PID" 2>/dev/null; then echo 'HARNESS_INVALID: A launcher survived orderly wait' >&2; exit 21; fi
wait "$A_PID" 2>/dev/null || true
PORT_GONE=0; HAL_GONE=0
for _ in $(seq 1 120); do
  if ! nc -z localhost 5007 >/dev/null 2>&1; then PORT_GONE=1; fi
  if ! timeout 2s halcmd show pin joint.0.homed >/tmp/s07-afterA-pin.txt 2>/tmp/s07-afterA-hal.err; then HAL_GONE=1; fi
  if [[ "$PORT_GONE" == 1 && "$HAL_GONE" == 1 ]]; then break; fi
  sleep 0.1
done
printf 'A-pid-gone=1 port-gone=%s hal-pin-gone=%s\n' "$PORT_GONE" "$HAL_GONE"
[[ "$PORT_GONE" == 1 && "$HAL_GONE" == 1 ]] || { echo 'HARNESS_INVALID: teardown barrier ambiguous' >&2; exit 22; }
printf 'gate-C=PASS\n'

printf '\n== Gate D/E/F: fresh runtime B starts unhomed then rehomes ==\n'
linuxcnc -r "$INI" >s07-B.stdout 2>s07-B.stderr &
B_PID=$!
trap 'kill -TERM "$B_PID" 2>/dev/null || true; wait "$B_PID" 2>/dev/null || true' EXIT
[[ "$B_PID" != "$A_PID" ]] || { echo 'HARNESS_INVALID: launcher PID reused immediately' >&2; exit 23; }
wait_ready B || { cat s07-B.stderr >&2 || true; exit 4; }
B_INITIAL="$(read_pin joint.0.homed)"
printf 'B-launcher-pid=%s B-initial-homed=%s\n' "$B_PID" "$B_INITIAL"
is_false "$B_INITIAL" || { echo 'PREDICTION FALSIFIED: fresh runtime B inherited homed=true' >&2; exit 30; }
printf 'gate-DE=PASS\n'
rsh_control s07B 'set estop off' 'set machine on' 'set mode manual' 'set home 0' >/tmp/s07-B-rsh.txt 2>/tmp/s07-B-rsh.err || true
cat /tmp/s07-B-rsh.txt || true
wait_homed true || { echo 'Runtime B failed to re-establish homed state' >&2; cat s07-B.stderr >&2 || true; exit 5; }
printf 'B-reestablished-homed=%s\n' "$(read_pin joint.0.homed)"
printf 'gate-F=PASS\n'

INI_HASH_AFTER="$(sha256sum "$INI" | awk '{print $1}')"
printf '\n== Gate G: unchanged persistent configuration ==\n'
printf 'ini-hash-before=%s\nini-hash-after=%s\n' "$INI_HASH_BEFORE" "$INI_HASH_AFTER"
[[ "$INI_HASH_BEFORE" == "$INI_HASH_AFTER" ]]
printf 'gate-G=PASS\n'
printf '\nS07-017 overall=PASS\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
