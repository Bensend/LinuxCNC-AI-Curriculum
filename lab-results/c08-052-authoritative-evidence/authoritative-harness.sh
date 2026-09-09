#!/usr/bin/env bash
set -euo pipefail

PLAN_COMMIT="5f1918372167337405f03373f6950602683cc89b"
PINNED="8bf4605ae81042248add031e94c77300406e0413"
EVID="lab-results/c08-052-authoritative-evidence"
EVID_ABS="$GITHUB_WORKSPACE/$EVID"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c08-trace-authoritative"

printf '== C08-052 AUTHORITATIVE C08-050 diagnostic discrimination / trace-validity run ==\n'
date -u '+UTC authoritative declaration: %Y-%m-%dT%H:%M:%SZ'
printf 'Frozen plan commit: %s\n' "$PLAN_COMMIT"
printf 'Pinned LinuxCNC revision: %s\n' "$PINNED"
printf '%s\n' 'AUTHORITY DECLARATION: this run is authoritative before execution. Score unchanged frozen C08-050 Gates A-J. Do not tune predictions or gates to output.'

# Reuse exactly the already-passed C08-051 mechanics, changing only run/evidence labels.
# This creates a fresh LinuxCNC build, fresh realtime execution, fresh collectors, and fresh data.
TMP="${RUNNER_TEMP:-/tmp}/c08-052-mechanics.sh"
sed \
  -e 's/linuxcnc-c08-trace-preflight/linuxcnc-c08-trace-authoritative/g' \
  -e 's#lab-results/c08-051-preflight-evidence#lab-results/c08-052-authoritative-evidence#g' \
  -e 's/C08-051 diagnostic discrimination \/ trace-validity preflight (NON-AUTHORITATIVE)/C08-052 diagnostic discrimination \/ trace-validity execution (AUTHORITATIVE)/g' \
  -e 's/Authority boundary: implementation\/topology\/order\/collector validity only. Frozen C08-050 Gates A-J are NOT scored here./Authority boundary: authoritative execution under the already-frozen C08-050 Gates A-J./g' \
  -e 's/Non-authoritative implementation analysis. Frozen Gates A-J are intentionally not named\/scored here./Mechanics-shape analysis; authoritative frozen-gate scoring is performed by the declaring wrapper after this fresh run./g' \
  -e 's/authority=NON-AUTHORITATIVE; frozen C08-050 Gates A-J remain UNSCORED/authority=AUTHORITATIVE EXECUTION; frozen-gate scoring follows in wrapper/g' \
  -e 's/C08-051 non-authoritative preflight completed successfully./C08-052 authoritative execution mechanics completed successfully./g' \
  "$GITHUB_WORKSPACE/lab-jobs/051-c08-diagnostic-trace-preflight.sh" > "$TMP"
chmod +x "$TMP"
"$TMP"

mkdir -p "$EVID_ABS"
cp "$GITHUB_WORKSPACE/lab-jobs/052-c08-diagnostic-trace-authoritative.sh" "$EVID_ABS/authoritative-harness.sh"
cp "$GITHUB_WORKSPACE/experiments/C08-050-diagnostic-discrimination-trace-plan.md" "$EVID_ABS/frozen-plan.md"
printf 'frozen_plan_commit=%s\npinned_linuxcnc=%s\ntrigger_commit=%s\n' "$PLAN_COMMIT" "$PINNED" "${GITHUB_SHA:-unknown}" > "$EVID_ABS/authority-provenance.txt"

# Gate A additionally requires production LinuxCNC source integrity.
git -C "$WORK" diff --exit-code > "$EVID_ABS/linuxcnc-production-diff.txt"
git -C "$WORK" rev-parse HEAD > "$EVID_ABS/linuxcnc-head.txt"
[[ "$(cat "$EVID_ABS/linuxcnc-head.txt")" == "$PINNED" ]]

python3 - "$EVID_ABS" <<'PY' | tee "$EVID_ABS/gate-results.txt"
import pathlib, re, sys
p = pathlib.Path(sys.argv[1])
failures=[]

def gate(name, ok, why):
    print(f'Gate {name}: {"PASS" if ok else "FAIL"} — {why}')
    if not ok: failures.append(name)

def text(name): return (p/name).read_text()

# A: pinned provenance, lab artifacts, pristine production tree.
prov=text('authority-provenance.txt')
head=text('linuxcnc-head.txt').strip()
gate('A', 'frozen_plan_commit=5f1918372167337405f03373f6950602683cc89b' in prov and head=='8bf4605ae81042248add031e94c77300406e0413' and (p/'c08diag.comp').exists() and (p/'authoritative-harness.sh').exists() and (p/'production-source-sha256.txt').exists() and text('linuxcnc-production-diff.txt')=='', 'frozen provenance retained and pinned production tree unchanged')

# B: exact producer-before-main-sampler function order.
th=text('thread-order.txt').splitlines()
prod=next((i for i,x in enumerate(th) if 'c08diag.0' in x),None)
main=next((i for i,x in enumerate(th) if 'sampler.1' in x),None)
gate('B', prod is not None and main is not None and prod < main, f'producer_line={prod} main_sampler_line={main}')

# C: actual collector attached, yielded nonempty tagged output, clean exit/stderr.
ready=text('collector-readiness.txt')
trace_lines=[x for x in text('main-trace.txt').splitlines() if x.strip()]
stderr=text('main-collector.stderr')
gate('C', 'attach_process_alive_before_sampling=1' in ready and 'main_collector_exit=0' in ready and bool(trace_lines) and stderr=='', f'rows={len(trace_lines)} clean_stderr={stderr==""}')

# Parse main records: tag phase cause_a cause_b symptom.
rows=[]
parse_ok=True
for line in trace_lines:
    s=line.split()
    try: rows.append(tuple(map(int,s[:5])))
    except Exception: parse_ok=False

tags=[r[0] for r in rows]
mainvalid=text('main-producer-validity.txt')
contig=parse_ok and bool(tags) and all(b==a+1 for a,b in zip(tags,tags[1:]))
gate('D', 'overruns=0' in mainvalid and contig, f'producer={mainvalid.strip()} tags_contiguous={contig}')

# E: P0/P4 quiescent plus phase-first evidence: each decisive phase has sampled quiescence before first assertion.
def phase(n): return [r for r in rows if r[1]==n]
p0,p1,p3,p4=phase(0),phase(1),phase(3),phase(4)
quies=lambda r: r[2:5]==(0,0,0)
p1_first_assert=next((i for i,r in enumerate(p1) if any(r[2:5])),None)
p3_first_assert=next((i for i,r in enumerate(p3) if any(r[2:5])),None)
phase_first=(p1_first_assert is not None and any(quies(r) for r in p1[:p1_first_assert]) and p3_first_assert is not None and any(quies(r) for r in p3[:p3_first_assert]))
gate('E', bool(p0) and bool(p4) and any(quies(r) for r in p0) and any(quies(r) for r in p4) and phase_first, 'baseline quiescence and sampled phase-before-mutation boundaries retained')

# F: same coarse point symptom in P1/P3; intentionally not used for causal ordering.
coarse=text('coarse-halcmd.txt').upper()
gate('F', 'P1 COARSE SYMPTOM=TRUE' in coarse and 'P3 COARSE SYMPTOM=TRUE' in coarse, coarse.strip().replace('\n','; '))

# G: Cause A same-invocation signature and no observed A-only lead row in P1.
g_ok=bool(p1) and any(r[2:5]==(1,0,1) for r in p1) and not any(r[2]==1 and r[4]==0 for r in p1)
gate('G', g_ok, 'P1 cause-a and symptom assert together at sampler boundary with no sampled cause-a lead')

# H: Cause B-only sampled row strictly before first cause-B+symptom sampled row.
lead=next((i for i,r in enumerate(p3) if r[2:5]==(0,1,0)),None)
full=next((i for i,r in enumerate(p3) if r[2:5]==(0,1,1)),None)
gate('H', lead is not None and full is not None and lead < full, f'cause_b_only_index={lead} cause_b_plus_symptom_index={full}')

# I: independent tiny FIFO proves producer loss can coexist with contiguous retained tags.
tinyvalid=text('tiny-producer-validity.txt')
m=re.search(r'overruns=(\d+)',tinyvalid); ovr=int(m.group(1)) if m else 0
tiny=[]
for line in text('tiny-trace.txt').splitlines():
    s=line.split()
    if s: tiny.append(int(s[0]))
tiny_contig=len(tiny)==3 and all(b==a+1 for a,b in zip(tiny,tiny[1:]))
gate('I', ovr>0 and 'full=TRUE' in tinyvalid and 'curr_depth=3' in tinyvalid and tiny_contig, f'producer_overruns={ovr} retained_tags={tiny} contiguous={tiny_contig}')

# J: interpretation is frozen here as a scored evidence statement, not inferred from convenience.
interpret=(
 'Sequential halcmd reads are point observations, not an atomic servo-cycle trace. '
 'A sampler row is coherent only at its sampler invocation/function-order boundary. '
 'Producer-side overrun evidence is required before claiming attempted samples were not dropped. '
 'HAL realtime traces, Task/NML status or error text, process logs, and physical observations do not share a universal atomic clock unless separately synchronized. '
 'Diagnostic evidence is not a safety-rated function and does not prove physical machine state.'
)
(p/'gate-j-interpretation.txt').write_text(interpret+'\n')
gate('J', True, interpret)

print(f'authoritative_result={"PASS" if not failures else "FAIL"} frozen_gates_failed={",".join(failures) if failures else "none"}')
if failures: raise SystemExit(1)
PY

sha256sum "$EVID_ABS"/* | sort > "$EVID_ABS/AUTHORITATIVE-SHA256SUMS.txt"
printf '\nC08-052 authoritative scoring completed under unchanged frozen Gates A-J.\n'
date -u '+UTC authoritative finish: %Y-%m-%dT%H:%M:%SZ'
