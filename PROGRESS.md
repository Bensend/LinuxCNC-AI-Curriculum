# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current session marker

- Session start (UTC): `2026-09-09T12:11:23Z`
- Session end: OPEN
- Active work: D01 runtime preflight validated numerically; redesigned preflight evidence-publication lineage reached three attempts and is retired pending a clean evidence-retention redesign.

## Current critical-path state

All modules through **T05** and **C01–C09** are **GRADUATED at 1000 level**.

The 1000-series critical path is complete. The initial 2000-series promotion inventory has been deduplicated and scored in `guides/2000-dependency-graph.md`. Highest-priority unblocked work remains **D01 — coupled-control stability and tandem-joint authority**, state **EXPERIMENT / ESSENTIAL-NOW EVIDENCE REDESIGN**.

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

## D01 — coupled-control stability and tandem-joint authority — EXPERIMENT / ESSENTIAL-NOW EVIDENCE REDESIGN

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Durable artifacts include:

- `guides/D01-coupled-control-stability-authority-research.md`;
- `guides/D01-community-tandem-homing-vs-runtime-authority.md`;
- `call-flows/D01-duplicated-coordinate-command-feedback.md`;
- `call-flows/D01-servo-cycle-feedback-ferror-fault-order.md`;
- `results/D01-001-pinned-kinematics-source-probe.md`;
- `results/D01-002-frozen-runtime-experiment.md` — P0–P8 and Gates A–J frozen before implementation;
- `results/D01-003-preflight-three-attempt-reconciliation.md` — first-lineage **ESSENTIAL NOW / REDESIGN** decision;
- `results/D01-004-redesigned-preflight-attempt-1-mux16-interface.md`;
- `results/D01-005-redesigned-preflight-attempt-2-helper-order.md`;
- `lab-jobs/015-d01-redesigned-observer-preflight.sh`;
- `lab-jobs/016-d01-redesigned-observer-preflight-mux16-fix.sh`;
- `lab-jobs/017-d01-redesigned-observer-preflight-phase-helper-fix.sh`.

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

The original three-attempt preflight lineage is retired. Its third attempt reached a valid real `motmod + trivkins` topology but failed in the old `linuxcncrsh` command driver; frozen Gates A–J remained unscored.

The materially redesigned observer lineage replaced that command path with `linuxcnc.command()`/NML, explicit homing and MDI checks, phase-before-mutation evidence, and one minimal test-only `motion.d01-cart-y-observer` copied immediately after `do_forward_kins()` and sampled atomically with both Y command/feedback paths, ferror/limits/faults, offset, phase and global motion enable.

### Redesigned preflight reconciliation

- **Attempt 1:** workflow `34347323567`, job `102451918581`, artifact `10102345581`, digest `sha256:260208fade1d26cf1859941168648bef4d6e1f1a4e28be6ef25e3a1c1e8fe3d6`. **HARNESS INVALID before P0.** Pinned `mux16` exposes `sel0..sel3` and `out-f`, not aggregate `sel` / `out`.
- **Attempt 2:** workflow `34349942532`, job `102460454507`, artifact `10103396597`, digest `sha256:e7cd694772b0dcb0812557ac2780f64782a1fdbf0e5e81bfb3622b85444820c0`. **HARNESS INVALID before behavioral phases.** Correct mux16 wiring loaded, but generated `set_phase()` was defined after its first use.
- **Attempt 3:** workflow `34350408741`, job `102462004744`, artifact `10103614029`, digest `sha256:28f99131a0d6aa7eb5030cb0d795a425f73f7e0ad26317fcefbb1ad0ee2aa2b6`. **RUNTIME PREFLIGHT PREDICATES PASS / EVIDENCE-PUBLICATION HARNESS INVALID.** The actual runtime reached all numeric discriminators: homing/MDI passed; both Y commands and feedbacks settled at 10; low duplicate offset `0.020` produced duplicate ferror `-0.02` below limit `0.05`, no duplicate fault, Cartesian Y `10`, motion enabled; high offset `0.200` produced duplicate ferror `-0.2` above limit `0.05`, duplicate-only ferror fault, principal clean, Cartesian Y `10`, and global motion disabled. The atomic sampler captured 2,200 monotonic rows with `sampler.0.overruns=0`, and analysis found phase-before-mutation, hidden-low-divergence, principal-Cartesian, duplicate-only-trip and disable witnesses. The script then exited `129` in the final source-diff/provenance export because it attempted `git diff` after changing working directory out of the source repository. The full evidence package was therefore not durably retained to the frozen Gate-J standard.

This third attempt is strong non-authoritative runtime confirmation of the planned numeric fixture, but **does not score Gates A–J**. Per the three-attempt rule, do not make a fourth incremental repair to the `015 -> 016 -> 017` wrapper lineage.

Community research also reinforces a key teaching boundary: LinuxCNC tandem/gantry homing can establish a synchronized/squared reference relationship, but successful homing is not continuous proof that duplicated joints remain physically aligned during later motion. D01 keeps homing authority separate from runtime geometry authentication.

### Exact next-work checkpoint

1. Retire the `015 -> 016 -> 017` incremental wrapper lineage. Do **not** launch a fourth wrapper repair.
2. Build a **clean standalone evidence-retaining D01 harness** from the already validated runtime topology/numeric fixture. It must use the correct `mux16.sel0..sel3/out-f` interface, define phase controls before acquisition, retain the exact observer source patch from the source repository before leaving it, and write/copy the complete atomic stream, topology, thread order, LinuxCNC logs, recorder health, analysis and source diff into a location included in the workflow artifact/repository result package.
3. Run a non-authoritative **evidence-retention/provenance preflight only**. The numeric values are now frozen by successful attempt-3 runtime validation: low offset `0.020`, high offset `0.200`, applicable ferror limit observed `0.050`. Do not retune them.
4. Only after the clean evidence-retention preflight passes, create one separate independent authoritative D01 run using unchanged D01-002 P0–P8 and Gates A–J. Authoritative gate evaluation must be performed from retained evidence, not merely live assertions.
5. Authoritative evidence must retain one atomic realtime stream, zero producer overruns, monotonic sample indices, empty/nonfatal collector stderr, phase-before-mutation witnesses, the exact observer-source diff, config/HAL/test source, startup logs, topology/order and gate-analysis output.
6. Keep F02 blocked until D01 has an accepted authority/fault-containment contract.
7. Preserve the end-of-1000 sealed benchmark information boundary and the separate delayed-retention obligation.
