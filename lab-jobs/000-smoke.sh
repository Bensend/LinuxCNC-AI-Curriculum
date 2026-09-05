#!/usr/bin/env bash
set -euo pipefail

echo "== LinuxCNC lab smoke test =="
echo "UTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo

echo "== Runner environment =="
uname -a
printf 'OS: '
. /etc/os-release
printf '%s %s\n' "$NAME" "$VERSION_ID"
printf 'Git: '
git --version
printf 'Python: '
python3 --version
printf 'CPU count: '
nproc
printf 'Memory:\n'
free -h
printf 'Disk:\n'
df -h .

echo
echo(){ builtin echo "$@"; }
echo "== Upstream LinuxCNC source access =="
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

git clone --depth 1 https://github.com/LinuxCNC/linuxcnc.git "$TMPDIR/linuxcnc"
cd "$TMPDIR/linuxcnc"

echo "Repository: https://github.com/LinuxCNC/linuxcnc"
echo "Branch: $(git branch --show-current)"
echo "Commit: $(git rev-parse HEAD)"
echo "Commit date: $(git show -s --format=%cI HEAD)"
if [[ -f VERSION ]]; then
  echo "VERSION file: $(cat VERSION)"
fi

echo
echo "== Source landmarks =="
for p in src docs tests scripts configs; do
  if [[ -e "$p" ]]; then
    printf 'FOUND %s\n' "$p"
  else
    printf 'MISSING %s\n' "$p"
  fi
done

echo
echo "Smoke test completed successfully."
