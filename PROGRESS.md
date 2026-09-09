# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current session marker

- Session start (UTC): `2026-09-09T11:39:19Z`
- Session end: OPEN
- Active work: D01 redesigned runtime preflight with atomic Cartesian-feedback observer.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**.

The 1000-series critical path is complete. The initial 2000-series promotion inventory has been deduplicated and scored in `guides/2000-dependency-graph.md`. Highest-priority unblocked work remains **D01 — coupled-control stability and tandem-joint authority**, state **EXPERIMENT / REDESIGNED PREFLIGHT ACTIVE**.

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

## D01 — coupled-control stability and tandem-joint authority — EXPERIMENT / REDESIGNED PREFLIGHT ACTIVE

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Durable artifacts include:

- `guides/D01-coupled-control-stability-authority-research.md`;
- `call-flows/D01-duplicated-coordinate-command-feedback.md`;
- `call-flows/D01-servo-cycle-feedback-ferror-fault-order.md`;
- `results/D01-001-pinned-kinematics-source-probe.md`;
- `results/D01-002-frozen-runtime-experiment.md` — P0–P8 and Gates A–J frozen before implementation;
- `results/D01-003-preflight-three-attempt-reconciliation.md` — **ESSENTIAL NOW / REDESIGN** decision;
- `lab-jobs/015-d01-redesigned-observer-preflight.sh` — new materially redesigned non-authoritative preflight.

Accepted source model remains:

```text
duplicated Cartesian coordinate command
    -> inverse kinematics copies the coordinate to every mapped joint

process_inputs()
    -> each joint independently forms feedback, ferror and ferror limit

do_forward_kins()
    -> ordinary duplicated-coordinate trivkins reports the principal/first mapped joint
       rather than averaging or validating duplicate feedback

check_for_faults()
    -> a qualifying per-joint fault can revoke machine-wide motion authority
```

The first preflight lineage reached three materially similar harness failures and is retired. Attempt 3, workflow `34345951372` / job `102447454146`, did reach a valid real `motmod + trivkins` duplicated-Y topology and correct realtime thread ordering, but its userspace `linuxcncrsh` command driver returned `SET MDI NAK`; both Y commands therefore remained zero and no D01 fault behavior was scored. Frozen Gates A–J remain **UNSCORED**.

Per the three-attempt rule this is **ESSENTIAL NOW**, not PROMOTE or DROP: the principal-joint Cartesian-feedback rule is central to the 2000-level coupled-authority contract and still requires independent runtime verification.

The redesigned preflight removes `linuxcncrsh` from the command-driving causal path, uses `linuxcnc.command()`/NML with explicit homing and MDI state checks, adds phase-before-mutation evidence, and adds one minimal test-only `motion.d01-cart-y-observer` HAL output that copies already-computed `emcmotStatus->carte_pos_fb.tran.y` immediately after `do_forward_kins()`. That observer is sampled atomically with both Y command/feedback paths, ferror/limits/faults, offset, phase and global motion enable. It is instrumentation only and is never consumed by motion control.

Redesigned workflow run `34347323567` for commit `8afb5c9c17fcf7b5343e30ff018573be1cfbe6a5` is currently **in progress**. Do not launch a duplicate while it is running.

### Exact next-work checkpoint

1. Inspect only redesigned preflight workflow `34347323567` when it completes; capture its job ID, actual job runtime, artifact ID/digest, exit code, full logs, exact observer patch, topology/thread order, full atomic stream and recorder-health evidence.
2. If it fails, classify it as **redesigned cycle attempt 1** and correct only the source-grounded harness defect; do not weaken D01-002 hypotheses or Gates A–J.
3. If it passes, reconcile it as non-authoritative topology/order/numeric/observer validation. Freeze the exact test-only observer patch and confirmed numeric thresholds without scoring Gates A–J.
4. Only after a passing redesigned preflight, create one separate independent authoritative D01 run using the unchanged P0–P8 semantics and Gates A–J. Do not tune behavioral gates from preflight output.
5. Authoritative evidence must retain one atomic realtime stream, zero producer overruns, monotonic sample indices, empty/nonfatal collector stderr, phase-before-mutation witnesses, and the exact observer-source diff.
6. Keep F02 blocked until D01 has an accepted authority/fault-containment contract.
7. Preserve the end-of-1000 sealed benchmark information boundary and the separate delayed-retention obligation.
