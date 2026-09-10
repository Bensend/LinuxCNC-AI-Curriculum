#!/usr/bin/env bash
set -euo pipefail

# X01-002 NON-AUTHORITATIVE preflight, new materially redesigned lineage.
# Frozen contract: experiments/X01-002-sampler-retention-redesign.md.
# Preserve X01-001 attempt-3 fixture/timing/counts; replace only the falsified
# consumer-tag loss oracle with deterministic payload discontinuity + producer
# sampler overrun evidence. `halsampler -t` remains retained ordering evidence.

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/lab-jobs/027-x01-sampler-retention-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/x01-030-redesign-preflight.sh"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()

# Harness corrections already established by X01-001 attempts 1-3.
s = s.replace('pin out float value[15];', 'pin out float value-##[15];')
s = s.replace('echo "net x01-v$i x01-source.0.value-$i => sampler.0.pin.$i"',
'''printf 'net x01-v%d x01-source.0.value-%02d => sampler.0.pin.%d\\n' "$i" "$i" "$i"''')
s = s.replace('x01-source.0.value-0', 'x01-source.0.value-00')

# New frozen lineage/provenance labels only; no behavioral parameter changes.
s = s.replace('X01-001 NON-AUTHORITATIVE preflight.', 'X01-002 NON-AUTHORITATIVE preflight, redesigned loss oracle.')
s = s.replace('experiments/X01-001-sampler-retention-perturbation.md',
              'experiments/X01-002-sampler-retention-redesign.md')
s = s.replace('x01-027-preflight-evidence', 'x01-030-redesign-preflight-evidence')
s = s.replace('X01-027 NON-AUTHORITATIVE PREFLIGHT', 'X01-030 / X01-002 NON-AUTHORITATIVE PREFLIGHT')
s = s.replace('X01-027 PREFLIGHT RUNTIME PREDICATES PASS', 'X01-030 / X01-002 PREFLIGHT RUNTIME PREDICATES PASS')

old = '''# Consumer loss evidence can appear either as the explicit 'overrun' marker or a numerical tag gap.\ntag_gaps=sum(1 for i in range(len(forced)-1) if forced[i+1][0] != forced[i][0]+1)\nassert forced_overrun_lines>0 or tag_gaps>0, (forced_overrun_lines,tag_gaps)\nassert float(post['source-counter']) > float(pre['source-counter']), (pre,post)'''
new = '''# X01-002 loss oracle: producer overrun + missing deterministic payload cycle(s).\n# `-t` sequence is retained only to characterize ordering of successful stream records.\ntag_gaps=sum(1 for i in range(len(forced)-1) if forced[i+1][0] != forced[i][0]+1)\npayload_gaps=sum(1 for i in range(len(forced)-1) if round(forced[i+1][1][0]) - round(forced[i][1][0]) > 1)\nassert payload_gaps>0, (payload_gaps, forced_overrun_lines, tag_gaps)\nassert float(post['source-counter']) > float(pre['source-counter']), (pre,post)'''
if old not in s:
    raise SystemExit('frozen-oracle replacement target not found')
s = s.replace(old, new)

old_summary = "consumer_overrun_markers={forced_overrun_lines} tag_gaps={tag_gaps}"
new_summary = "consumer_overrun_markers={forced_overrun_lines} tag_gaps={tag_gaps} payload_gaps={payload_gaps}"
if old_summary not in s:
    raise SystemExit('summary replacement target not found')
s = s.replace(old_summary, new_summary)

# Prevent accidental survival of the falsified required oracle.
if "assert forced_overrun_lines>0 or tag_gaps>0" in s:
    raise SystemExit('old consumer-tag loss oracle still present')
if 'assert payload_gaps>0' not in s:
    raise SystemExit('new deterministic payload loss oracle missing')
if 'pin out float value[15];' in s:
    raise SystemExit('known indexed-pin declaration defect remains')
if 'x01-source.0.value-$i' in s:
    raise SystemExit('known unpadded array-pin reference remains')

p.write_text(s)
PY

chmod +x "$TMP"
printf '%s\n' 'X01-030: executing frozen X01-002 redesigned preflight; fixture/counts/depths/timing unchanged from validated attempt-3 behavior.'
exec "$TMP"
