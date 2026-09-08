#!/usr/bin/env bash
set -euo pipefail
PINNED=8bf4605ae81042248add031e94c77300406e0413
ROOT="$PWD/.lab-c06-preflight"
rm -rf "$ROOT"
git clone -q https://github.com/LinuxCNC/linuxcnc.git "$ROOT"
cd "$ROOT"
git checkout -q "$PINNED"
ACTUAL=$(git rev-parse HEAD)
[[ "$ACTUAL" == "$PINNED" ]]

echo "C06-030 fixture construction preflight"
echo "Pinned checkout: $ACTUAL"

HM2=src/hal/drivers/mesa-hostmot2/hm2_test.c
CORE=src/hal/drivers/mesa-hostmot2/hostmot2.c
WD=src/hal/drivers/mesa-hostmot2/watchdog.c
HDR=src/hal/drivers/mesa-hostmot2/hostmot2.h

sha256sum "$HM2" "$CORE" src/hal/drivers/mesa-hostmot2/tram.c "$WD" src/hal/drivers/mesa-hostmot2/hostmot2-lowlevel.h

echo "--- hm2_test available patterns ---"
grep -nE 'case [0-9]+:' "$HM2"
echo "--- existing watchdog descriptors in hm2_test ---"
if grep -n 'HM2_GTAG_WATCHDOG' "$HM2"; then
  echo "EXISTING_WATCHDOG_DESCRIPTOR=yes"
else
  echo "EXISTING_WATCHDOG_DESCRIPTOR=no"
fi

echo "--- module descriptor decode ---"
grep -n -A24 -B4 'md->gtag = d\[0\]' "$CORE"
echo "--- watchdog parser consistency contract ---"
grep -n -A35 -B8 'hm2_watchdog_parse_md' "$WD" | head -n 90
echo "--- watchdog gtag constant ---"
grep -n 'HM2_GTAG_WATCHDOG' "$HDR" | head -n 10

echo "--- final hm2_test pattern construction ---"
python3 - <<'PY'
from pathlib import Path
s=Path('src/hal/drivers/mesa-hostmot2/hm2_test.c').read_text()
a=s.index('        case 14:')
b=s.index('\n        default:', a)
print(s[a:b])
PY

echo "--- candidate descriptor packing fields ---"
python3 - <<'PY'
from pathlib import Path
s=Path('src/hal/drivers/mesa-hostmot2/hostmot2.c').read_text()
a=s.index('md->gtag = d[0]')
print(s[a:a+1800])
PY

echo "PREFLIGHT_PASS: exact pinned fixture/parser evidence retained in workflow output"
