#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
PINNED="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c06-watchdog-load-preflight"

printf '== C06 watchdog-bearing hm2_test load preflight ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$PINNED"
printf '%s\n' 'Purpose: non-behavioral fixture proof only. Prove a new lab-only hm2_test pattern can register one IOPort plus one watchdog and export the real watchdog HAL objects.'
printf '%s\n' 'Prediction: patched test_pattern=15 will register successfully and export hm2_test.0.watchdog.has_bit plus hm2_test.0.watchdog.timeout_ns.'
printf '%s\n' 'Evidence boundary: no transport-failure, watchdog-bite, recovery, physical-I/O, timing, or safety claim is made by this preflight.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$PINNED"
[[ "$(git rev-parse HEAD)" == "$PINNED" ]]

HM2=src/hal/drivers/mesa-hostmot2/hm2_test.c
CORE=src/hal/drivers/mesa-hostmot2/hostmot2.c
TRAM=src/hal/drivers/mesa-hostmot2/tram.c
WD=src/hal/drivers/mesa-hostmot2/watchdog.c
LLIO=src/hal/drivers/mesa-hostmot2/hostmot2-lowlevel.h

printf '\n== Production-source hashes before lab-only fixture patch ==\n'
sha256sum "$CORE" "$TRAM" "$WD" "$LLIO" | tee /tmp/c06-production-before.sha
sha256sum "$HM2" | tee /tmp/c06-hm2test-before.sha

python3 - <<'PY'
from pathlib import Path
p=Path('src/hal/drivers/mesa-hostmot2/hm2_test.c')
s=p.read_text()
needle='''        default: {\n            LL_ERR("unknown test pattern %d", test_pattern); '''
assert needle in s
case='''        // Lab-only C06 fixture: one valid IOPort plus one valid watchdog.\n        // Existing upstream patterns 0-14 remain byte-for-byte unchanged.\n        case 15: {\n            int num_io_pins = 24;\n            int pd_index;\n\n            set32(me, HM2_ADDR_IOCOOKIE, HM2_IOCOOKIE);\n            set8(me, HM2_ADDR_CONFIGNAME+0, 'H');\n            set8(me, HM2_ADDR_CONFIGNAME+1, 'O');\n            set8(me, HM2_ADDR_CONFIGNAME+2, 'S');\n            set8(me, HM2_ADDR_CONFIGNAME+3, 'T');\n            set8(me, HM2_ADDR_CONFIGNAME+4, 'M');\n            set8(me, HM2_ADDR_CONFIGNAME+5, 'O');\n            set8(me, HM2_ADDR_CONFIGNAME+6, 'T');\n            set8(me, HM2_ADDR_CONFIGNAME+7, '2');\n\n            set32(me, HM2_ADDR_IDROM_OFFSET, 0x400);\n            set32(me, 0x400, 2);       // standard IDROM type\n            set32(me, 0x404, 0x40);    // module descriptors at 0x440\n            set32(me, 0x408, 0x200);   // pin descriptors at 0x600\n            set32(me, 0x41c, 1);       // IOPorts\n            set32(me, 0x420, num_io_pins);\n            set32(me, 0x424, 24);      // PortWidth\n            set32(me, 0x428, 2000000); // ClockLow\n            set32(me, 0x42c, 20000000);// ClockHigh\n            set32(me, 0x430, 4);       // InstanceStride0\n            set32(me, 0x434, 4);       // InstanceStride1\n            set32(me, 0x438, 4);       // RegisterStride0\n            set32(me, 0x43c, 4);       // RegisterStride1\n\n            // MD0 @ 0x440: IOPort gtag=3, v0, ClockLow, 1 instance.\n            set32(me, 0x440, 0x01010003);\n            set32(me, 0x444, 0x00051000); // base 0x1000, 5 regs, stride selectors 0/0\n            set32(me, 0x448, 0x0000001F);\n\n            // MD1 @ 0x44c: Watchdog gtag=2, v0, ClockLow, 1 instance.\n            set32(me, 0x44c, 0x01010002);\n            set32(me, 0x450, 0x00032000); // base 0x2000, 3 regs, stride selectors 0/0\n            set32(me, 0x454, 0x00000000);\n\n            // MD2 terminator.\n            set32(me, 0x458, 0x00000000);\n            set32(me, 0x45c, 0x00000000);\n            set32(me, 0x460, 0x00000000);\n\n            me->llio.num_ioport_connectors = 1;\n            me->llio.ioport_connector_name[0] = "P3";\n\n            for (pd_index = 0; pd_index < num_io_pins; pd_index ++) {\n                set8(me, 0x600 + (pd_index * 4) + 0, 0);\n                set8(me, 0x600 + (pd_index * 4) + 1, 0);\n                set8(me, 0x600 + (pd_index * 4) + 2, 0);\n                set8(me, 0x600 + (pd_index * 4) + 3, HM2_GTAG_IOPORT);\n            }\n            break;\n        }\n\n'''
s=s.replace(needle, case+needle, 1)
p.write_text(s)
PY

printf '\n== Retained lab-only patch ==\n'
git diff -- "$HM2" | tee /tmp/c06-hm2test.patch
[[ -s /tmp/c06-hm2test.patch ]]

printf '\n== Production-source hashes after fixture patch; must match ==\n'
sha256sum "$CORE" "$TRAM" "$WD" "$LLIO" | tee /tmp/c06-production-after.sha
cmp /tmp/c06-production-before.sha /tmp/c06-production-after.sha

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

cat >/tmp/c06-watchdog-load.hal <<'EOF'
loadrt hostmot2
loadrt hm2_test test_pattern=15
show pin hm2_test.0.watchdog.has_bit
show param hm2_test.0.watchdog.timeout_ns
show funct hm2_test.0.read
show funct hm2_test.0.write
unloadrt hm2_test
unloadrt hostmot2
EOF

printf '\n== Load-only HAL preflight ==\n'
halrun -f /tmp/c06-watchdog-load.hal 2>&1 | tee /tmp/c06-halrun.out

grep -F 'hm2_test.0.watchdog.has_bit' /tmp/c06-halrun.out
grep -F 'hm2_test.0.watchdog.timeout_ns' /tmp/c06-halrun.out
grep -F 'hm2_test.0.read' /tmp/c06-halrun.out
grep -F 'hm2_test.0.write' /tmp/c06-halrun.out

printf '\nLOAD_PREFLIGHT_PASS: watchdog-bearing lab-only hm2_test pattern registered and exported real watchdog HAL objects.\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
