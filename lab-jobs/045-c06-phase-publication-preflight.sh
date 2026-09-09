#!/usr/bin/env bash
set -euo pipefail

# C06 NON-AUTHORITATIVE phase-publication redesign preflight.
# C06-044 proved real sampler readiness but exposed a distinct observation defect:
# mutations could be consumed by realtime before the phase label was sampled.
# This preflight changes ONLY publication order/timing. Frozen P0-P6 semantics,
# threshold=3, watchdog register 0x2004:0, production HostMot2 behavior, and
# Gates A-H remain unchanged and are NOT accepted from this run.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/044-c06-authoritative-real-readiness.sh"
TMP="${RUNNER_TEMP:-/tmp}/c06-045-preflight.sh"
[[ -s "$BASE" ]] || { echo 'PREFLIGHT_INVALID: C06-044 base missing' >&2; exit 20; }
cp "$BASE" "$TMP"
python3 - "$TMP" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
repls={
"""# P1: exactly one transient failed read; transport must recover without watchdog indication.\necho 'sets c06-fail-remaining 1' >&9\necho 'sets c06-phase 1' >&9\nsleep .40\n""":"""# P1 publication barrier: publish phase, let realtime observe it, then inject one failed read.\necho 'sets c06-phase 1' >&9\nsleep .05\necho 'sets c06-fail-remaining 1' >&9\nsleep .35\n""",
"""# P2: deterministic test analogue escalates at the frozen threshold of three consecutive failures.\necho 'sets c06-fail-remaining 5' >&9\necho 'sets c06-phase 2' >&9\nsleep .40\n""":"""# P2 publication barrier, then unchanged repeated-failure command.\necho 'sets c06-phase 2' >&9\nsleep .05\necho 'sets c06-fail-remaining 5' >&9\nsleep .35\n""",
"""# P3: remove injected transport failure and explicitly clear real generic io_error.\necho 'sets c06-fail-remaining 0' >&9\necho 'setp hm2_test.0.io_error false' >&9\necho 'sets c06-phase 3' >&9\nsleep .40\n""":"""# P3 publication barrier, then unchanged transport recovery actions.\necho 'sets c06-phase 3' >&9\nsleep .05\necho 'sets c06-fail-remaining 0' >&9\necho 'setp hm2_test.0.io_error false' >&9\nsleep .35\n""",
"""# P4: transport remains healthy; inject only fake watchdog status register 0x2004 bit 0.\necho 'sets c06-watchdog-command true' >&9\necho 'sets c06-phase 4' >&9\nsleep .40\n""":"""# P4 publication barrier, then unchanged fake watchdog-status injection.\necho 'sets c06-phase 4' >&9\nsleep .05\necho 'sets c06-watchdog-command true' >&9\nsleep .35\n""",
"""# P6: remove fake status and explicitly clear the real watchdog.has_bit HAL_IO signal.\necho 'sets c06-watchdog-command false' >&9\necho 'sets c06-has-bit false' >&9\necho 'sets c06-phase 6' >&9\nsleep .50\n""":"""# P6 publication barrier, then unchanged watchdog recovery actions.\necho 'sets c06-phase 6' >&9\nsleep .05\necho 'sets c06-watchdog-command false' >&9\necho 'sets c06-has-bit false' >&9\nsleep .45\n""",
}
for old,new in repls.items():
    if s.count(old)!=1: raise SystemExit('PREFLIGHT_INVALID: expected phase block not unique')
    s=s.replace(old,new,1)
s=s.replace("echo '== C06-030 authoritative redesigned run / real-readiness correction =='", "echo '== C06 phase-publication redesign preflight (NON-AUTHORITATIVE) =='",1)
s=s.replace("echo 'AUTHORITATIVE C06-030: frozen Gates A-H PASS'", "echo 'NON-AUTHORITATIVE PREFLIGHT: internal analyzer reached PASS; frozen Gates remain unaccepted'",1)
p.write_text(s)
PY
chmod +x "$TMP"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_EVID"
cp "$TMP" "$RUN_EVID/executed-phase-first-preflight.sh"
diff -u "$BASE" "$TMP" >"$RUN_EVID/phase-publication-only.diff" || true

set +e
"$TMP"
RC=$?
set -e
# The base analyzer is useful as a consistency check, but this run is explicitly
# non-authoritative. Prove the publication property directly from raw rows.
python3 - "$RUN_EVID/c06-trace.txt" "$RUN_EVID/phase-publication-proof.txt" <<'PY'
from pathlib import Path
import sys
rows=[]
for ln in Path(sys.argv[1]).read_text().splitlines():
    p=ln.split()
    if len(p)!=11: continue
    try: rows.append(tuple(int(x,0) for x in p))
    except ValueError: pass
ph={k:[r for r in rows if r[1]==k] for k in range(7)}
checks=[]
# columns n,phase,failrem,wdcmd,iomirror,has,rs,rf,ws,consec,wdmirror
checks.append(('P1', len(ph[1])>20 and ph[1][0][7]==ph[0][-1][7] and any(r[7]>ph[1][0][7] for r in ph[1][1:])))
checks.append(('P2', len(ph[2])>20 and ph[2][0][4]==0 and any(r[4]==1 for r in ph[2][1:])))
checks.append(('P3', len(ph[3])>20 and ph[3][0][4]==1 and any(r[4]==0 for r in ph[3][1:])))
checks.append(('P4', len(ph[4])>20 and ph[4][0][3]==0 and ph[4][0][5]==0 and any(r[3]==1 and r[5]==1 for r in ph[4][1:])))
checks.append(('P6', len(ph[6])>20 and ph[6][0][5]==1 and any(r[5]==0 for r in ph[6][1:])))
text='\n'.join(f'{k} publication-after-label: {"PASS" if v else "FAIL"}' for k,v in checks)+'\n'
Path(sys.argv[2]).write_text(text)
print(text,end='')
if not all(v for _,v in checks): raise SystemExit(92)
PY
PROOF_RC=$?
if [[ "$RC" != 0 ]]; then echo "PREFLIGHT NOTE: embedded unchanged gate analyzer exited $RC"; fi
[[ "$PROOF_RC" == 0 ]] || exit "$PROOF_RC"
echo 'C06-045 PREFLIGHT PASS: decisive mutations were observed after their phase labels. No behavioral gate is accepted from this preflight.'
exit 0
