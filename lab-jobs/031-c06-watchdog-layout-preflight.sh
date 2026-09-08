#!/usr/bin/env bash
set -euo pipefail
PINNED=8bf4605ae81042248add031e94c77300406e0413
ROOT="$PWD/.lab-c06-layout"
rm -rf "$ROOT"
git clone -q https://github.com/LinuxCNC/linuxcnc.git "$ROOT"
cd "$ROOT"
git checkout -q "$PINNED"
[[ "$(git rev-parse HEAD)" == "$PINNED" ]]

echo "C06 watchdog fixture layout preflight"
echo "Pinned checkout: $(git rev-parse HEAD)"
python3 - <<'PY'
from pathlib import Path
s=Path('src/hal/drivers/mesa-hostmot2/hm2_test.c').read_text()
for n in (11,12,13):
    a=s.index(f'        case {n}:')
    b=s.index('\n        case '+str(n+1)+':', a) if n < 13 else s.index('\n        case 14:', a)
    print(f'--- PATTERN {n} ---')
    print(s[a:b])
PY

echo '--- IDROM parser fields ---'
grep -n -A100 -B10 'idrom_offset' src/hal/drivers/mesa-hostmot2/hostmot2.c | head -n 180

echo '--- watchdog register setup ---'
grep -n -A130 -B10 'hm2_watchdog_parse_md' src/hal/drivers/mesa-hostmot2/watchdog.c | head -n 180

echo '--- MD consistency helper ---'
grep -n -A100 -B10 'hm2_md_is_consistent_or_complain' src/hal/drivers/mesa-hostmot2/hostmot2.c | head -n 150

echo 'LAYOUT_PREFLIGHT_PASS'
