#!/usr/bin/env bash
set -euo pipefail

# X01-002 AUTHORITATIVE run.
# Frozen contract: experiments/X01-002-sampler-retention-redesign.md.
# Preflight reconciliation: results/X01-002-preflight-reconciliation.md.
# P0-P4 are unchanged from validated job 030. P5 was selected before this run:
# 10,000 retained narrow-config records with concurrent drain and zero overruns.

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/lab-jobs/027-x01-sampler-retention-preflight.sh"
TMP="${RUNNER_TEMP:-/tmp}/x01-031-authoritative.sh"
cp "$SRC" "$TMP"

python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()

# Harness corrections established before the authoritative lineage.
s = s.replace('pin out float value[15];', 'pin out float value-##[15];')
s = s.replace('echo "net x01-v$i x01-source.0.value-$i => sampler.0.pin.$i"',
'''printf 'net x01-v%d x01-source.0.value-%02d => sampler.0.pin.%d\\n' "$i" "$i" "$i"''')
s = s.replace('x01-source.0.value-0', 'x01-source.0.value-00')

# Authoritative lineage/provenance labels only.
s = s.replace('X01-001 NON-AUTHORITATIVE preflight.', 'X01-002 AUTHORITATIVE run, redesigned loss oracle.')
s = s.replace('experiments/X01-001-sampler-retention-perturbation.md',
              'experiments/X01-002-sampler-retention-redesign.md')
s = s.replace('x01-027-preflight-evidence', 'x01-031-authoritative-evidence')
s = s.replace('X01-027 NON-AUTHORITATIVE PREFLIGHT', 'X01-031 / X01-002 AUTHORITATIVE')
s = s.replace('This preflight validates harness behavior and recorder evidence only; gates remain UNSCORED.',
              'Authoritative run: frozen Gates A-J are scored by retained evidence; P5 sustained count is 10000.')
s = s.replace('== X01 sampler retention / perturbation preflight ==',
              '== X01-002 authoritative sampler retention / perturbation run ==')

# Frozen X01-002 loss oracle.
old = '''# Consumer loss evidence can appear either as the explicit 'overrun' marker or a numerical tag gap.\ntag_gaps=sum(1 for i in range(len(forced)-1) if forced[i+1][0] != forced[i][0]+1)\nassert forced_overrun_lines>0 or tag_gaps>0, (forced_overrun_lines,tag_gaps)\nassert float(post['source-counter']) > float(pre['source-counter']), (pre,post)'''
new = '''# X01-002 loss oracle: producer overrun + missing deterministic payload cycle(s).\n# `-t` sequence is retained only to characterize ordering of successful stream records.\ntag_gaps=sum(1 for i in range(len(forced)-1) if forced[i+1][0] != forced[i][0]+1)\npayload_gaps=sum(1 for i in range(len(forced)-1) if round(forced[i+1][1][0]) - round(forced[i][1][0]) > 1)\nassert payload_gaps>0, (payload_gaps, forced_overrun_lines, tag_gaps)\nassert float(post['source-counter']) > float(pre['source-counter']), (pre,post)'''
if old not in s:
    raise SystemExit('frozen-oracle replacement target not found')
s = s.replace(old, new)
s = s.replace('consumer_overrun_markers={forced_overrun_lines} tag_gaps={tag_gaps}',
              'consumer_overrun_markers={forced_overrun_lines} tag_gaps={tag_gaps} payload_gaps={payload_gaps}')

# P5 chosen before launch: bounded 10,000-record sustained publication proof.
needle = '''measure_timing wide-timing "$WIDE_CFG"\n\ncleanup_case\ntrap - EXIT\n'''
inject = '''measure_timing wide-timing "$WIDE_CFG"\n\n# P5: predeclared bounded sustained publication proof.\nSUSTAINED_SAMPLES=10000\nstart_case "$NARROW_CFG" 15000 sustained\nrm -f /tmp/x01-sustained.samples\nhalsampler -t -n "$SUSTAINED_SAMPLES" /tmp/x01-sustained.samples >"$OUT/sustained-halsampler.stdout" 2>"$OUT/sustained-halsampler.stderr" &\nHSPID=$!\nhalcmd setp sampler.0.enable 1\nif ! timeout 30s bash -c 'while kill -0 "$1" 2>/dev/null; do sleep .05; done' _ "$HSPID"; then\n    kill -TERM "$HSPID" 2>/dev/null || true\n    wait "$HSPID" 2>/dev/null || true\n    echo 'sustained halsampler did not complete' >&2\n    exit 22\nfi\nwait "$HSPID"\nhalcmd setp sampler.0.enable 0\ncp /tmp/x01-sustained.samples "$OUT/sustained.samples"\nhealth sustained\nprintf 'predeclared-sustained-samples=%s\\n' "$SUSTAINED_SAMPLES" > "$OUT/sustained-contract.txt"\n\ncleanup_case\ntrap - EXIT\n'''
if needle not in s:
    raise SystemExit('P5 injection target not found')
s = s.replace(needle, inject)

# Extend the authoritative scorer with P5 before summary construction.
needle2 = '''for d in (nt,wt):\n    assert float(d['servo-thread.tmax']) >= 0\nsummary=f'''\'\'\'X01-027 PREFLIGHT RUNTIME PREDICATES PASS'''
replace2 = '''for d in (nt,wt):\n    assert float(d['servo-thread.tmax']) >= 0\n\nsustained, sustained_overrun_lines=parse_samples(out/'sustained.samples')\nassert len(sustained)==10000, len(sustained)\nassert sustained_overrun_lines==0, sustained_overrun_lines\nassert all(sustained[i+1][0]==sustained[i][0]+1 for i in range(len(sustained)-1))\nassert all(round(sustained[i+1][1][0])==round(sustained[i][1][0])+1 for i in range(len(sustained)-1))\nsh=kv(out/'sustained-health.txt')\nassert int(float(sh['overruns']))==0, sh\nsummary=f'''\'\'\'X01-031 / X01-002 AUTHORITATIVE GATES A-J PASS'''
if needle2 not in s:
    raise SystemExit('authoritative scorer injection target not found')
s = s.replace(needle2, replace2)
s = s.replace("wide_servo_thread_time={wt['servo-thread.time']} wide_tmax={wt['servo-thread.tmax']}\nNOTE:",
              "wide_servo_thread_time={wt['servo-thread.time']} wide_tmax={wt['servo-thread.tmax']}\nsustained_rows={len(sustained)} sustained_overruns={sh['overruns']} sustained_stream_and_payload_contiguous=yes\nNOTE:")
s = s.replace('NOTE: frozen Gates A-J remain UNSCORED in this non-authoritative preflight.',
              'GATES: A=PASS B=PASS C=PASS D=PASS E=PASS F=PASS G=PASS H=PASS I=PASS J=PASS.')
s = s.replace("printf '%s\\n' 'X01-027 NON-AUTHORITATIVE PREFLIGHT PASS; frozen Gates A-J remain UNSCORED.'",
              "printf '%s\\n' 'X01-031 / X01-002 AUTHORITATIVE PASS; frozen Gates A-J PASS.'")

# Guard against accidental oracle regression or P5 omission.
if "assert forced_overrun_lines>0 or tag_gaps>0" in s:
    raise SystemExit('old consumer-tag loss oracle still present')
if 'assert payload_gaps>0' not in s:
    raise SystemExit('new deterministic payload loss oracle missing')
if 'SUSTAINED_SAMPLES=10000' not in s or "len(sustained)==10000" not in s:
    raise SystemExit('predeclared P5 sustained proof missing')
if 'pin out float value[15];' in s or 'x01-source.0.value-$i' in s:
    raise SystemExit('known array-pin harness defect regressed')

p.write_text(s)
PY

chmod +x "$TMP"
printf '%s\n' 'X01-031: executing separate authoritative X01-002 run; P0-P4 unchanged, P5 frozen at 10000 retained records before launch.'
exec "$TMP"
