#!/usr/bin/env bash
set -euo pipefail

# Clean standalone D01 evidence-retention/provenance preflight.
# This intentionally does NOT score frozen D01-002 Gates A-J.
# It reuses the validated attempt-3 runtime fixture without retuning:
# low offset 0.020, high offset 0.200, applicable ferror limit 0.050.

BASE="lab-jobs/015-d01-redesigned-observer-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/d01-018-clean.sh"
OUT="${GITHUB_WORKSPACE:-$PWD}/lab-results/d01-018-evidence"
mkdir -p "$OUT"

python3 - "$BASE" "$TMP" "$OUT" <<'PY'
from pathlib import Path
import re,sys
src,dst,out=Path(sys.argv[1]),Path(sys.argv[2]),sys.argv[3]
s=src.read_text()
# Correct the validated mux16 interface.
s=s.replace('setp mux16.0.sel 0\n','setp mux16.0.sel0 0\nsetp mux16.0.sel1 0\nsetp mux16.0.sel2 0\nsetp mux16.0.sel3 0\n',1)
s=s.replace('net D01-phase mux16.0.out => sampler.0.pin.0','net D01-phase mux16.0.out-f => sampler.0.pin.0',1)
phase='''set_phase(){\n  local n="$1"\n  halcmd setp mux16.0.sel0 $(( n & 1 ))\n  halcmd setp mux16.0.sel1 $(( (n >> 1) & 1 ))\n  halcmd setp mux16.0.sel2 $(( (n >> 2) & 1 ))\n  halcmd setp mux16.0.sel3 $(( (n >> 3) & 1 ))\n}\n'''
s=s.replace('trap cleanup EXIT\n','trap cleanup EXIT\n'+phase,1)
s,n=re.subn(r'halcmd setp mux16\.0\.sel ([0-9]+)',r'set_phase \1',s)
assert n==8,n
# Retain provenance before any cd can invalidate source-relative git commands.
needle="git diff -- src/emc/motion/mot_priv.h src/emc/motion/motion.c src/emc/motion/control.c | tee /tmp/d01-observer.patch\n"
repl=needle+f'''mkdir -p "{out}"\ncp /tmp/d01-observer.patch "{out}/observer.patch"\ngit rev-parse HEAD > "{out}/linuxcnc-commit.txt"\ngit status --short > "{out}/linuxcnc-status.txt"\n'''
assert needle in s
s=s.replace(needle,repl,1)
# Remove the known-bad final provenance command(s); provenance is already retained above.
s=re.sub(r'\n(?:git diff|git status|git rev-parse)[^\n]*(?:\n|$)', '\n', s)
# Before cleanup, package all complete evidence from the fixture.
marker='trap cleanup EXIT\n'+phase
# append an EXIT packaging helper after phase helper; it copies whatever exists even on failure.
pack=f'''retain_evidence(){{\n  mkdir -p "{out}"\n  cp -f /tmp/d01.samples "{out}/atomic.samples" 2>/dev/null || true\n  cp -f /tmp/d01-halsampler.stderr "{out}/halsampler.stderr" 2>/dev/null || true\n  cp -f /tmp/d01-halsampler.stdout "{out}/halsampler.stdout" 2>/dev/null || true\n  cp -f /tmp/d01/d01.ini "{out}/d01.ini" 2>/dev/null || true\n  cp -f /tmp/d01/d01.hal "{out}/d01.hal" 2>/dev/null || true\n  for f in topology.txt thread.txt linuxcnc.stdout linuxcnc.stderr settled.txt low.txt high.txt recorder-health.txt observer.patch; do cp -f "/tmp/d01/$f" "{out}/$f" 2>/dev/null || true; done\n}}\ntrap 'retain_evidence; cleanup' EXIT\n'''
# replace original cleanup-only EXIT trap, leaving set_phase defined before first use.
s=s.replace(marker,phase+pack,1)
# Successful completion must explicitly retain and inventory evidence.
s += f'''\nretain_evidence\nprintf '%s\\n' 'D01-018 retention inventory:'\nfind "{out}" -maxdepth 1 -type f -printf '%f %s bytes\\n' | sort | tee "{out}/inventory.txt"\npython3 - "{out}" <<'PY2'\nfrom pathlib import Path\nimport sys\np=Path(sys.argv[1])\nrequired=['observer.patch','linuxcnc-commit.txt','atomic.samples','halsampler.stderr','d01.ini','d01.hal','topology.txt','thread.txt','linuxcnc.stdout','linuxcnc.stderr','recorder-health.txt']\nmissing=[x for x in required if not (p/x).exists()]\nassert not missing, missing\nassert (p/'observer.patch').stat().st_size>0\nassert (p/'atomic.samples').stat().st_size>0\nassert 'sampler-overruns=0' in (p/'recorder-health.txt').read_text()\nassert (p/'halsampler.stderr').stat().st_size==0\nprint('D01-018 EVIDENCE RETENTION PREFLIGHT PASS')\nPY2\n'''
dst.write_text(s)
PY

chmod +x "$TMP"
printf '%s\n' 'D01-018: clean standalone retention/provenance preflight; frozen runtime semantics unchanged; Gates A-J remain UNSCORED.'
exec bash "$TMP"
