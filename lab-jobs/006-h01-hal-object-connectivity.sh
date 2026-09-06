#!/usr/bin/env bash
set -euo pipefail
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-h01-hal"
printf '== LinuxCNC H01 HAL object/connectivity lab ==\n'; date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'; printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
sudo apt-get update; sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"; git clone --filter=blob:none "$UPSTREAM" "$WORK"; cd "$WORK"; git checkout --detach "$LINUXCNC_COMMIT"; ./debian/configure uspace; sudo apt-get build-dep -y .; cd src; ./autogen.sh; ./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation; make -j"$(nproc)"; cd ..
set +u; source scripts/rip-environment; set -u
cleanup(){ trap - EXIT; timeout --signal=TERM --kill-after=2s 5s halcmd stop >/dev/null 2>&1 || true; timeout --signal=TERM --kill-after=2s 5s halcmd unload all >/dev/null 2>&1 || true; timeout --signal=TERM --kill-after=2s 8s realtime stop >/dev/null 2>&1 || true; }; trap cleanup EXIT
realtime start
printf '\n== Load object providers ==\n'; halcmd loadrt threads name1=h01-thread period1=1000000; halcmd loadrt siggen; halcmd loadrt sampler depth=32 cfg=F
halcmd show comp | tee /tmp/h01-comp.txt; halcmd show pin 'siggen.*' | tee /tmp/h01-pins.txt; halcmd show funct | tee /tmp/h01-functs-before.txt
grep -q 'siggen.0.update' /tmp/h01-functs-before.txt
printf '\n== Pin dummy -> signal pointer behavior ==\n'; halcmd setp sampler.0.pin.0 1.25; PRE_LINK="$(halcmd getp sampler.0.pin.0 | tr -d '[:space:]')"; printf 'pre-link-pin=%s\n' "$PRE_LINK"; halcmd net h01-scalar sampler.0.pin.0; LINKED_PIN="$(halcmd getp sampler.0.pin.0 | tr -d '[:space:]')"; LINKED_SIG="$(halcmd gets h01-scalar | tr -d '[:space:]')"; printf 'after-link-pin=%s signal=%s\n' "$LINKED_PIN" "$LINKED_SIG"; halcmd sets h01-scalar 2.5; [[ "$(halcmd getp sampler.0.pin.0 | tr -d '[:space:]')" == "2.5" ]]; halcmd unlinkp sampler.0.pin.0; SNAP="$(halcmd getp sampler.0.pin.0 | tr -d '[:space:]')"; halcmd sets h01-scalar 3.5; printf 'unlink-snapshot=%s pin-after=%s signal-after=%s\n' "$SNAP" "$(halcmd getp sampler.0.pin.0 | tr -d '[:space:]')" "$(halcmd gets h01-scalar | tr -d '[:space:]')"; [[ "$SNAP" == "2.5" ]]
printf '\n== Single-writer invariant ==\n'; halcmd net h01-writer siggen.0.sine; set +e; halcmd net h01-writer siggen.0.cosine >/tmp/h01-second-writer.out 2>/tmp/h01-second-writer.err; RC=$?; set -e; printf 'second-writer-rc=%s\n' "$RC"; cat /tmp/h01-second-writer.err >&2 || true; [[ "$RC" -ne 0 ]]
printf '\n== Exported function -> addf scheduling link ==\n'; halcmd addf siggen.0.update h01-thread; halcmd show thread | tee /tmp/h01-thread.txt; grep -q 'siggen.0.update' /tmp/h01-thread.txt; halcmd start; sleep .25; THREADBEAT="$(halcmd getp h01-thread.threadbeat | tr -d '[:space:]')"; printf 'h01-thread-threadbeat=%s\n' "$THREADBEAT"; [[ "$THREADBEAT" =~ ^[0-9]+$ ]] && [[ "$THREADBEAT" -gt 0 ]]
printf '\nH01 HAL object/connectivity observation completed successfully.\n'; date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
