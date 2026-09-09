# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**.

The 1000-series critical path is complete. Highest-priority unblocked work is now **2000-series dependency-graph construction from the accumulated promotion/uncertainty queue**, state **RESEARCH / CURRICULUM DESIGN**. Do not mechanically repeat the 1000 series.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, 10/10, 95% confidence.
- Delayed retention remains separate; do not count the immediate transfer retest as delayed retention.
- End-of-1000 is now a meaningful sealed-benchmark checkpoint. Preserve information separation; do not expose a sealed answer to the learner merely to satisfy cadence.

## C06 — communication/watchdog fault handling — GRADUATED

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Accepted teaching:

```text
packet/read error != watchdog bite
io-error != necessarily watchdog.has_bit
watchdog.has_bit=false during broken transport != proof FPGA watchdog did not bite
transport recovery != watchdog recovery
fault reset != proof plant is physically safe to resume
ordinary HostMot2/HAL fault handling != functional-safety certification
```

Do not rerun C06-030 absent a newly discovered specific defect.

## C07 — state-machine sequencing — GRADUATED at 1000 level

Accepted runtime model:

```text
request != achieved state
prerequisite restored != request retried
fault cleared != achieved state restored
achieved state restored != stale start authorization valid
Task/HAL logical recovery != physical safe restart
```

Primary evidence: `results/C07-049-authoritative-request-achieved-reconciliation.md`, adversarial exam, novel transfer, and graduation audit. Do not rerun absent a concrete defect.

## C08 — diagnostics and trace capture — GRADUATED at 1000 level

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Accepted evidence and durable teaching remain in:

- `guides/C08-diagnostics-trace-research.md`
- `guides/C08-function-symbol-guide.md`
- `call-flows/C08-fault-to-retained-evidence.md`
- `guides/C08-hal-stream-doc-source-conflict.md`
- `evaluation/C08-promotion-audit.md`

```text
sequential point reads != one atomic realtime state
trace values require retained function-order provenance
HAL object existence != collector readiness/retention proof
consumer tag continuity != no attempted-sample loss at the pinned revision
producer-side overrun evidence is mandatory for a no-loss claim
same coarse symptom != same realtime causal history
HAL/Task/NML/process-log evidence != one atomic global clock unless explicitly synchronized
diagnostic evidence != physical plant truth != safety/restart authority
```

Do not rerun C08-050 absent a newly discovered concrete defect.

## C09 — fresh-AI architecture handoff — GRADUATED at 1000 level

Durable artifacts:

- `guides/C09-architecture-invariants.md`
- `evaluation/C09-architecture-handoff-rubric.md` — frozen before handoff answer review
- `evaluation/C09-fresh-ai-handoff-answer.md`
- `evaluation/C09-architecture-handoff-result.md` — **20/20 PASS**

C09 integrated the already-graduated source/lab evidence into a generic public two-actuator architecture and rejected all frozen attractive errors: userspace servo control, sensor self-authentication, request=achieved, stale authorization reuse, transport/watchdog conflation, invalid atomicity/no-loss claims, software=physical truth, and ordinary LinuxCNC=safety authority.

Accepted architecture retrieval contract:

```text
servo-critical control -> realtime execution
request != achieved state
fault cleared != achieved state restored
fresh authorization required after interruption
measured feedback != independently proven physical truth
transport failure != watchdog bite
transport recovery != watchdog recovery
sequential observations != atomic realtime state
consumer continuity != no producer-side attempted-sample loss
software diagnostics != physical truth != safety authority
```

C09 is an integration/handoff capstone; it does not claim new physical-machine evidence. Hardware-specific loop stability, sensor diversity, physical stopping/actuator authority and safety certification remain later/hardware work.

## 2000-series activation — RESEARCH / CURRICULUM DESIGN

### Initial high-value promotion clusters extracted at the 1000 boundary

1. **Advanced coupled-control dynamics — HIGH**
   - cross-coupling stability and authority with asymmetric plants, delay, saturation and realistic disturbances;
   - quantify when synchronization logic improves measured disagreement versus destabilizes/obscures local loops.

2. **HostMot2/hm2_eth fault internals across versions — HIGH**
   - compare packet-error escalation, watchdog observability/recovery and driver/firmware behavior across development/stable revisions;
   - resolve documentation/source version conflicts rather than generalizing the pinned capstone behavior.

3. **Advanced diagnostic correlation — HIGH**
   - explicitly synchronized realtime HAL + Task/NML + process-log correlation;
   - recorder perturbation/jitter, long-duration capture, overflow recovery and bounded evidence design.

4. **Feedback integrity / common-cause reasoning — HIGH**
   - sensor diversity, common-mode faults, plausibility and independent evidence architectures;
   - preserve the rule that two agreeing software measurements do not authenticate the physical plant by themselves.

5. **Custom FPGA/driver/distributed realtime engineering — 3000 candidate, not yet promoted to a 3000 module**
   - only create 3000 work if 2000-level evidence shows the topic genuinely needs specialized prerequisites/infrastructure.

6. **Physical safety/commissioning — CRITICAL consequence, separate evidence domain**
   - external safety-system architecture/certification, stopping performance, sensor mechanical coupling, actuator/drive authority and energized commissioning require human/physical evidence;
   - these do not become ordinary LinuxCNC software claims.

### Exact next-work checkpoint

1. Inventory all existing module promotion/uncertainty artifacts, not only C04/C08/C09, and build a deduplicated 2000-series candidate ledger with source module, evidence gap, consequence if wrong, prerequisite value, information gain and required infrastructure.
2. Apply the counterfactual and re-promotion safeguards: no item moves to 3000 merely because it is difficult.
3. Build the initial 2000 dependency graph and choose the first module by prerequisite value + uncertainty + consequence + expected information gain.
4. Preserve the end-of-1000 sealed blind benchmark requirement with evaluator/learner information separation; execute it when a valid sealed oracle can be presented without contamination.
5. Begin the selected 2000 module with the normal docs -> community -> source -> call-flow -> experiment -> evaluation evidence chain rather than rewriting 1000 prose.
