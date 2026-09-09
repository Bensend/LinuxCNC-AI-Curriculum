# C08-051 — Diagnostic Trace Preflight Reconciliation

Status: **PREFLIGHT PASS / NON-AUTHORITATIVE**

Frozen plan: `experiments/C08-050-diagnostic-discrimination-trace-plan.md` committed before implementation/output inspection.

Workflow: `34327928519`
Job: `102389431379`
Artifact: `10093374756` (`lab-results-34327928519`)
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Source commit: `a5ca22019320b3bb7f04eebf8eca4230dcea37e3`
Job runtime: 2026-09-09T08:13:43Z through 08:17:36Z = 233 s = **3.9 min**
Lab script internal runtime: 08:13:24Z through 08:17:03Z.

## Result

The required non-authoritative implementation/topology/collector preflight passed. **Frozen C08-050 Gates A–J remain UNSCORED.** No behavioral evidence from this run is promoted merely because the preflight shape succeeded.

Retained evidence establishes:

- the main collector actually attached before sampling, remained alive, and later exited `0`;
- the main trace retained 280 records with 75 P1 rows and 76 P3 rows;
- main producer validity was `overruns=0`, `full=FALSE`, `curr_depth=0` at shutdown;
- both coarse userspace observations saw `symptom=TRUE`;
- P1 exhibited the intended Cause-A same-invocation signature;
- P3 exhibited a Cause-B-only sampled row strictly before Cause-B+symptom;
- the separate depth-4 FIFO reached `full=TRUE`, `curr_depth=3`, and accumulated **31 producer overruns** while undrained;
- after production stopped, draining the three successfully queued records yielded tags `[0, 1, 2]`, i.e. contiguous consumer tags despite 31 proven rejected producer writes.

The final point is the bounded executable discriminator for the `hal_stream(3)` documentation/source conflict: at the pinned revision, consumer tag continuity is not a sufficient no-loss oracle. Producer-side overrun state is required before claiming attempted realtime samples were not dropped.

## Authority decision

The preflight satisfies the frozen prerequisite for a separate authoritative run. The next run must be declared authoritative before execution and must score the unchanged C08-050 Gates A–J. The implementation mechanics may be copied without changing causal predictions, phase semantics, function ordering, FIFO depths, or gate criteria.
