#!/usr/bin/env bash
set -euo pipefail

# D01 clean retention lineage attempt 2. Fixes only the 018 rewrite defect:
# 018 accidentally deleted the early provenance-producing git commands while
# trying to remove the known-bad final source-tree commands. Runtime fixture,
# frozen values, P0-P8 semantics and D01-002 Gates A-J are unchanged/unscored.

BASE="lab-jobs/018-d01-clean-evidence-retention-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/d01-019-clean.sh"

python3 - "$BASE" "$TMP" <<'PY'
from pathlib import Path
import sys
src,dst=map(Path,sys.argv[1:])
s=src.read_text()
old="s=re.sub(r'\\n(?:git diff|git status|git rev-parse)[^\\n]*(?:\\n|$)', '\\n', s)"
new="""# Remove only the known-bad *final* provenance block inherited from 015.\n# Keep the earlier git diff/rev-parse/status commands that create retained provenance.\nfinal_start=s.index('# Only the three explicit observer edits may touch production motion source.')\nfinal_end=s.index(\"printf '\\\\nD01 redesigned non-authoritative preflight completed successfully.\\\\n'\", final_start)\ns=s[:final_start] + s[final_end:]"""
assert old in s
s=s.replace(old,new,1)
dst.write_text(s)
PY

chmod +x "$TMP"
printf '%s\n' 'D01-019: retention-lineage attempt 2; fixes only 018 provenance rewrite defect; frozen runtime semantics unchanged; Gates A-J remain UNSCORED.'
exec bash "$TMP"
