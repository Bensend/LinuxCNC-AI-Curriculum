#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAB="$ROOT/.lab"
SRC="$LAB/linuxcnc"
mkdir -p "$LAB"

echo "==> Installing base build tooling"
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  git ca-certificates build-essential dpkg-dev devscripts equivs \
  autoconf automake libtool pkg-config python3 python3-pip python3-venv \
  ripgrep jq curl wget xvfb

if [[ ! -d "$SRC/.git" ]]; then
  echo "==> Cloning upstream LinuxCNC"
  git clone https://github.com/LinuxCNC/linuxcnc.git "$SRC"
else
  echo "==> LinuxCNC source already present"
  git -C "$SRC" fetch --tags --prune
fi

cd "$SRC"
REV="$(git rev-parse HEAD)"
echo "$REV" > "$LAB/LINUXCNC_COMMIT"
printf 'LinuxCNC source: %s\nRevision: %s\n' "$SRC" "$REV"

# Generate Debian packaging metadata and let Debian resolve LinuxCNC's own
# declared build dependencies. Failure is left visible rather than hidden.
echo "==> Preparing LinuxCNC Debian build metadata"
./debian/configure uspace no-docs || ./debian/configure uspace

echo "==> Installing declared LinuxCNC build dependencies"
sudo apt-get build-dep -y .

echo "==> Configuring run-in-place userspace build"
cd src
./autogen.sh
./configure --with-realtime=uspace

echo
printf '%s\n' "LinuxCNC laboratory bootstrap complete." \
  "Next: bash scripts/build-linuxcnc.sh" \
  "Pinned bootstrap revision: $REV"
