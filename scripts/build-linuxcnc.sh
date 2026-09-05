#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${LINUXCNC_SRC:-$ROOT/.lab/linuxcnc}"

if [[ ! -d "$SRC/.git" ]]; then
  echo "LinuxCNC source not found at $SRC. Open this repository in Codespaces first." >&2
  exit 1
fi

cd "$SRC/src"
./autogen.sh
./configure --with-realtime=uspace
make -j"$(nproc)"

cd "$SRC"
printf 'Built LinuxCNC revision %s\n' "$(git rev-parse HEAD)"
printf 'To enter the RIP environment: source %q\n' "$SRC/scripts/rip-environment"
