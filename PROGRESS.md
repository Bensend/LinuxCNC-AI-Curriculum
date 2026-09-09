# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current session marker

- Session start (UTC): `2026-09-09T11:39:19Z`
- Session end: OPEN
- Active work: D01 pinned-source update-order trace and runtime experiment freeze.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**.

The 1000-series critical path is complete. The initial 2000-series promotion inventory has now been deduplicated and scored in `guides/2000-dependency-graph.md`. Highest-priority unblocked work is **D01 — coupled-control stability and tandem-joint authority**, state **RESEARCH / SOURCE**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, 10/10, 95% confidence.
- Delayed retention remains separate; do not count the immediate transfer retest as delayed retention.
- End-of-1000 is a meaningful sealed-benchmark checkpoint. Preserve information separation; do not expose a sealed answer to the learner merely to satisfy cadence.

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

## 2000-series activation — ACTIVE

Durable scheduling artifacts:

- `guides/2000-promotion-candidate-ledger-initial.md` — reconciled promotion inventory;
- `guides/2000-dependency-graph.md` — scored initial dependency graph.

Current priority order is D01 coupled-control authority, then evidence-dependent S02/E20/X01/X02 work, with F02 compound faults deliberately blocked until its prerequisite fault domains are understood. Custom HostMot2 FPGA/driver/distributed-realtime work remains a **3000 candidate only**.

## D01 — coupled-control stability and tandem-joint authority — RESEARCH / SOURCE

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Durable artifacts:

- `guides/D01-coupled-control-stability-authority-research.md`;
- `call-flows/D01-duplicated-coordinate-command-feedback.md`;
- `results/D01-001-pinned-kinematics-source-probe.md` — non-authoritative source-algorithm verification.

Source-grounded finding now requiring runtime verification:

```text
duplicated Cartesian coordinate command
    -> inverse kinematics copies the coordinate to every mapped joint

per-joint feedback
    -> each joint retains independent tracking/ferror state
    -> ordinary duplicated-coordinate trivkins forward mapping reports the principal/first mapped joint
       rather than averaging or validating the duplicate pair
```

Thus command agreement is not measured-joint agreement, and plausible Cartesian feedback is not proof that the duplicate joint—or the physical coupled geometry—agrees. Negative `HOME_SEQUENCE` synchronization is reference-establishment behavior, not a continuous geometry-authentication mechanism.

D01-001 transcribed the pinned mapping algorithm for `XYY`: world Y=10 produced both Y joint commands=10, while feedback `[principal Y=10, duplicate Y=9]` still produced Cartesian Y=10. This is a falsifiable source-level prediction only; it is not yet LinuxCNC runtime evidence.

### Exact next-work checkpoint

1. Finish the pinned-source update-order trace from joint feedback/following-error calculation through `check_for_faults()`, motion enable revocation and forward-kinematics feedback publication.
2. Decide the smallest real-LinuxCNC duplicated-coordinate fixture that preserves independent asymmetric plant controls without fabricating an unavailable Cartesian measurement.
3. **Freeze D01 runtime phases and gates before implementation.** At minimum the frozen experiment must discriminate:
   - common Cartesian command fan-out;
   - principal-joint Cartesian feedback;
   - secondary-joint disagreement/following error;
   - authority revocation after a sufficiently large modeled tracking failure;
   - fault clear versus fresh restart authorization;
   - software measurement agreement versus unobserved physical geometry.
4. Require one atomic realtime evidence stream plus producer-side recorder-validity evidence. Sequential `halcmd` reads cannot score causal gates.
5. Run a non-authoritative topology/ordering preflight before one independent authoritative run; do not tune gates from the authoritative result.
6. Keep F02 blocked until D01 has an accepted authority/fault-containment contract.
7. Preserve the end-of-1000 sealed blind benchmark information boundary; do not inspect a sealed oracle merely to satisfy cadence.
