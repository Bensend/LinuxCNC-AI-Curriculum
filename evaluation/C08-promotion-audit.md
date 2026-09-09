# C08 — promotion and counterfactual audit

Decision: **GRADUATED — 1000 level**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Required evidence

- documentation/community research: present in `guides/C08-diagnostics-trace-research.md`, including official sampler/Halscope semantics and community failure/capture cases;
- pinned-source analysis: present in `guides/C08-function-symbol-guide.md`, `call-flows/C08-fault-to-retained-evidence.md`, and the `hal_stream` producer/consumer source trace;
- documentation/source conflict handling: explicit in `guides/C08-hal-stream-doc-source-conflict.md`, with version boundary rather than silent harmonization;
- predeclared experiment: `experiments/C08-050-diagnostic-discrimination-trace-plan.md` frozen before implementation/output review;
- non-authoritative implementation preflight: C08-051 PASS with authority boundary preserved;
- authoritative reproducible experiment: C08-052 TEST-CONFIRMED, unchanged frozen Gates A–J all PASS, retained artifact `10094968899`;
- raw realtime evidence: 285 main rows, producer overrun state, function order, collector stderr/exit, provenance and hashes retained;
- independent trace-validity adversary: depth-4 FIFO accumulated 32 rejected producer writes while successfully retained tags `[0,1,2]` remained contiguous;
- frozen adversarial exam: **10/10**;
- novel fresh-AI handoff: **PASS**.

## Counterfactuals the learner must still answer correctly

1. If two `halcmd getp` reads appear numerically consistent, do not infer one atomic servo-cycle state.
2. If a sampler trace is clean, do not interpret its row causally until relevant producer/sampler function order is known.
3. If sampler HAL objects exist, do not infer that a userspace collector has attached successfully or that retained evidence exists.
4. If consumer sample tags are contiguous, do not infer zero attempted-sample loss without producer-side overrun evidence at the pinned revision.
5. If the same coarse symptom is observed in two runs, do not infer the same cause when an ordered atomic trace can distinguish their histories.
6. If Task/NML/process-log events occur around a HAL fault, do not place them on one atomic global timeline without explicit synchronization/correlation evidence.
7. If diagnostic evidence identifies a likely software cause, do not infer physical plant truth or safe-restart authority.

All seven are preserved by the accepted source, experiment, exam and handoff artifacts.

## Minimum-evidence audit

Removing any one of these would materially weaken the C08 claim:

- source-level producer/consumer semantics;
- explicit function-order evidence;
- actual collector lifecycle/output evidence;
- producer-side overrun telemetry;
- a retained atomic realtime trace;
- the independent tiny-FIFO loss adversary;
- the Task/NML/log cross-surface call-flow analysis;
- the safety/physical-state boundary.

No additional similar laboratory rerun is justified at 1000 level merely for confidence accumulation. C08-050 should not be rerun absent a newly discovered defect.

## 2000/3000-level promotion queue

Defer rather than block 1000-level graduation:

- quantify instrumentation perturbation/jitter with controlled load and scheduler telemetry;
- compare Halscope versus sampler trigger/retention semantics under the same injected transient;
- build an explicitly synchronized multi-surface correlation experiment spanning realtime HAL, Task/NML and process logs;
- test high-rate long-duration capture, overflow recovery and bounded recorder design;
- validate revision-specific `hal_stream` semantics across released LinuxCNC branches;
- incorporate hardware timestamping/external instrumentation where physical-cause discrimination is required.

These are higher-level diagnostic-engineering extensions, not missing prerequisites for the present 1000-level claims.

## Durable promotion boundary

C08 competence is summarized as:

```text
trace value without recorder validity/order is weak evidence
consumer continuity without producer-overrun state is not a no-loss proof
cross-surface correlation is not an atomic global clock
software diagnostics are evidence, not physical truth or safety authority
```

## Forward dependency

C09 — fresh-AI architecture handoff — is now the highest-priority unblocked module. It should test whether a fresh architecture/design request preserves the accumulated LinuxCNC boundaries from timing, HAL/NML/Task state, tandem-axis control, fault evidence and diagnostics without relying on private machine-specific drawings.
