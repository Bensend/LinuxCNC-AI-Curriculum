#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c07-preflight"

printf '== C07-047 blocked machine-ON topology preflight (NON-AUTHORITATIVE) ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Predeclared preflight prediction: with motion.enable=false, a fresh halui.machine.on rising edge will not yield halui.machine.is-on=true; restoring motion.enable without a new edge will still not enable; a new edge after restoration can enable.'
printf '%s\n' 'Evidence boundary: topology/readiness and blocked-transition preflight only. Frozen C07-047 Gates A-J are NOT scored by this job.'

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

sha256sum src/emc/usr_intf/halui.cc src/emc/task/emctask.cc src/emc/task/emctaskmain.cc \
  src/emc/task/taskintf.cc src/emc/motion/command.c src/emc/motion/control.c src/emc/motion/motion.c \
  | tee /tmp/c07-production-source-sha256.txt

cd tests/linuxcncrsh
cp linuxcncrsh-test.ini c07-preflight.ini
python3 - <<'PY'
p='c07-preflight.ini'
s=open(p).read()
needle='[HAL]\nHALFILE = lcncrsh_sim.hal\n'
assert needle in s
s=s.replace(needle, needle+'HALUI = halui\n', 1)
open(p,'w').write(s)
PY

rm -f /tmp/linuxcnc.lock c07-linuxcnc.stdout c07-linuxcnc.stderr
linuxcnc -r c07-preflight.ini >c07-linuxcnc.stdout 2>c07-linuxcnc.stderr &
LAUNCHER_PID=$!
cleanup() {
  trap - EXIT
  kill -TERM "$LAUNCHER_PID" 2>/dev/null || true
  for _ in $(seq 1 50); do
    if ! kill -0 "$LAUNCHER_PID" 2>/dev/null; then break; fi
    sleep 0.1
  done
  kill -KILL "$LAUNCHER_PID" 2>/dev/null || true
  wait "$LAUNCHER_PID" 2>/dev/null || true
}
trap cleanup EXIT

printf '\n== Wait for actual HAL objects ==\n'
READY=0
for i in $(seq 1 160); do
  if nc -z localhost 5007 >/dev/null 2>&1 \
     && timeout 3s halcmd show pin halui.machine.on >/tmp/c07-halui-on.txt 2>/tmp/c07-hal.err \
     && timeout 3s halcmd show pin halui.machine.is-on >/tmp/c07-halui-is-on.txt 2>>/tmp/c07-hal.err \
     && timeout 3s halcmd show pin halui.estop.reset >/tmp/c07-estop-reset.txt 2>>/tmp/c07-hal.err \
     && timeout 3s halcmd show pin motion.enable >/tmp/c07-motion-enable.txt 2>>/tmp/c07-hal.err \
     && grep -q 'halui.machine.on' /tmp/c07-halui-on.txt \
     && grep -q 'halui.machine.is-on' /tmp/c07-halui-is-on.txt \
     && grep -q 'halui.estop.reset' /tmp/c07-estop-reset.txt \
     && grep -q 'motion.enable' /tmp/c07-motion-enable.txt; then
    READY=1
    printf 'readiness=PASS probe=%s\n' "$i"
    break
  fi
  sleep 0.25
done
if [[ "$READY" != 1 ]]; then
  echo 'C07 preflight runtime did not become ready.' >&2
  cat c07-linuxcnc.stdout >&2 || true
  cat c07-linuxcnc.stderr >&2 || true
  cat /tmp/c07-hal.err >&2 || true
  exit 2
fi
cat /tmp/c07-halui-on.txt /tmp/c07-halui-is-on.txt /tmp/c07-motion-enable.txt

getp() { timeout 3s halcmd getp "$1" | tr -d '[:space:]'; }
istrue() { [[ "$1" == "TRUE" || "$1" == "1" ]]; }
isfalse() { [[ "$1" == "FALSE" || "$1" == "0" ]]; }
pulse() {
  timeout 3s halcmd setp "$1" 0
  sleep 0.05
  timeout 3s halcmd setp "$1" 1
  sleep 0.10
  timeout 3s halcmd setp "$1" 0
}
wait_false() {
  local pin="$1" v
  for _ in $(seq 1 80); do v="$(getp "$pin")"; if isfalse "$v"; then printf '%s=false\n' "$pin"; return 0; fi; sleep 0.05; done
  printf '%s remained true\n' "$pin" >&2; return 1
}
wait_true() {
  local pin="$1" v
  for _ in $(seq 1 80); do v="$(getp "$pin")"; if istrue "$v"; then printf '%s=true\n' "$pin"; return 0; fi; sleep 0.05; done
  printf '%s never became true\n' "$pin" >&2; return 1
}

printf '\n== Establish out-of-estop / machine-off baseline ==\n'
pulse halui.estop.reset
wait_false halui.estop.is-activated
pulse halui.machine.off
wait_false halui.machine.is-on
printf 'baseline motion.enable=%s machine.is-on=%s estop=%s\n' \
  "$(getp motion.enable)" "$(getp halui.machine.is-on)" "$(getp halui.estop.is-activated)"

printf '\n== Block realtime enable and issue one fresh HALUI ON edge ==\n'
timeout 3s halcmd setp motion.enable 0
isfalse "$(getp motion.enable)"
pulse halui.machine.on
sleep 0.30
BLOCKED_ON="$(getp halui.machine.is-on)"
MOTION_ENABLED="$(getp motion.motion-enabled)"
printf 'after-blocked-request machine.is-on=%s motion.motion-enabled=%s\n' "$BLOCKED_ON" "$MOTION_ENABLED"
isfalse "$BLOCKED_ON"
isfalse "$MOTION_ENABLED"
printf 'blocked-request=PASS\n'

printf '\n== Restore prerequisite WITHOUT a new request edge ==\n'
timeout 3s halcmd setp motion.enable 1
istrue "$(getp motion.enable)"
sleep 0.30
NO_RETRY_ON="$(getp halui.machine.is-on)"
printf 'after-prereq-restore-no-edge machine.is-on=%s\n' "$NO_RETRY_ON"
isfalse "$NO_RETRY_ON"
printf 'no-implicit-retry=PASS\n'

printf '\n== Issue fresh request edge after prerequisite restoration ==\n'
pulse halui.machine.on
wait_true halui.machine.is-on
wait_true motion.motion-enabled
printf 'explicit-retry=PASS\n'

printf '\n== Retained diagnostic output ==\n'
printf 'final motion.enable=%s motion.motion-enabled=%s machine.is-on=%s estop=%s\n' \
  "$(getp motion.enable)" "$(getp motion.motion-enabled)" "$(getp halui.machine.is-on)" "$(getp halui.estop.is-activated)"
printf '%s\n' 'C07-047 PRE-FLIGHT PASS if job exit code is 0. This is not authoritative C07-047 Gate A-J evidence.'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
