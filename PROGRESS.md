# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, **C05**, **C06**, and now **C07** are **GRADUATED at 1000 level**.

Phase 10 remains active. Highest-priority unblocked work is now **C08 — diagnostics and trace capture**, state **RESEARCH**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, 10/10, 95% confidence.
- Delayed retention remains separate; do not count the immediate transfer retest as delayed retention.
- A new blind challenge is not required merely because C08 has activated; follow `evaluation/BLIND_FEEDBACK_PROTOCOL.md` cadence and preserve evaluator/learner information separation.

## C06 — communication/watchdog fault handling — GRADUATED

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`.

Accepted central teaching remains:

```text
packet/read error != watchdog bite
io-error != necessarily watchdog.has_bit
watchdog.has_bit=false during broken transport != proof FPGA watchdog did not bite
transport recovery != watchdog recovery
fault reset != proof plant is physically safe to resume
ordinary HostMot2/HAL fault handling != functional-safety certification
```

Primary graduation evidence is in `results/C06-046-authoritative-phase-first-reconciliation.md`, `exams/C06-adversarial-exam-and-corrections.md`, and `handoffs/C06-novel-transport-watchdog-transfer.md`. Do not rerun C06-030 absent a newly discovered specific defect.

## C07 — state-machine sequencing — GRADUATED at 1000 level

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

### Core source model

- HALUI machine/estop/home request pins are rising-edge request surfaces at the pinned revision; holding a request high does not continuously resend it.
- `halui.machine.on` rising edge -> `sendMachineOn()` -> NML `EMC_TASK_SET_STATE(ON)` -> Task `emcTaskSetState(ON)` -> `emcTrajEnable()` -> realtime `EMCMOT_ENABLE`.
- Realtime Motion can reject that request when `motion.enable=false` and can later revoke enabling on several fault classes.
- Returned achieved state is a separate path: realtime motion-enable flag -> Task trajectory status -> `determineState()` -> HALUI `halui.machine.is-on`.
- `emcTaskAbort()` invalidates/resynchronizes execution state; stale pre-fault authorization is not a valid restart policy.
- OFF/ESTOP unhoming is configuration-sensitive through the `volatile_home` path; returned homed state is controller state, not independent physical-position proof.

### Durable C07 artifacts

- `guides/C07-state-machine-sequencing-research.md`
- `guides/C07-source-resolution-addendum.md`
- `guides/C07-function-symbol-guide.md`
- `guides/C07-current-master-edge-semantics-spotcheck.md`
- `call-flows/C07-halui-task-state-request-status.md`
- `experiments/C07-047-request-achieved-state-sequencing-plan.md` — P0–P8 / Gates A–J frozen before implementation/output inspection.
- `experiments/C07-047-sequencer-construction-notes.md`
- `results/C07-047-blocked-on-preflight-reconciliation.md` — topology preflight PASS.
- `results/C07-048-full-sequencer-preflight-reconciliation.md` — full P0–P8 phase/ordering preflight PASS; Gates deliberately unscored.
- `results/C07-049-authoritative-request-achieved-reconciliation.md` — **accepted TEST-CONFIRMED Gates A–J PASS**.
- `exams/C07-adversarial-exam-questions.md` — questions frozen before authoritative output inspection.
- `exams/C07-adversarial-exam-answers-and-score.md` — **16/16 = 10/10 PASS**.
- `handoffs/C07-novel-state-sequencing-transfer.md` — amplifier-fault novel transfer PASS.
- `results/C07-graduation-and-promotion-audit.md` — minimum-evidence floor, promotion queue and counterfactual audit PASS.

### Accepted laboratory evidence

C07-048 full phase/ordering preflight:
- workflow `34318296679`
- job `102359108023`
- artifact `10090952801`
- exact job runtime **3.47 min**
- 109 ordered rows; all phase-before-mutation and one-authorization/one-request prechecks passed.

C07-049 authoritative run:
- workflow `34318656849`
- job `102360226472`
- artifact `10091082214`
- artifact digest `sha256:25a569a8ef09e90560c1037e7b38b27e3ce017f437671bdaaed655a836a6c8cd`
- exact job runtime **3.15 min**
- complete raw authoritative evidence retained under `lab-results/c07-049-authoritative-evidence/`
- frozen Gates **A–J all PASS**.

The accepted runtime behavior is:

```text
machine-on request while motion.enable=false -> no achieved ON
restore motion.enable without a fresh request -> still no achieved ON
fresh authorization + fresh request -> wait for returned achieved ON before active permission
loss of achieved ON -> revoke active permission / enter recovery
fault-cause restoration alone -> no automatic restart
fresh post-fault authorization + fresh request + achieved-status confirmation -> guarded logical recovery
```

Retrieval rules:

```text
request != achieved state
prerequisite restored != request retried
fault cleared != achieved state restored
achieved state restored != stale start authorization valid
Task/HAL logical recovery != physical safe restart
```

Current-master HALUI spot-check on `64efb28cd77a16b45ade81e576c784cdc574f40e` still showed the same rising-edge helper pattern, but full cross-version Task/Motion equivalence is **not claimed**.

**Decision: C07 GRADUATED at 1000 level. Do not rerun C07-047 absent a newly discovered concrete defect.**

## C08 — diagnostics and trace capture — ACTIVATED

Status: **RESEARCH**.

1000-level objective: build the generic diagnostic/trace model needed by the capstone so another AI engineer can select the right observation surface for a failure, preserve ordering/provenance, distinguish command/request from returned state and root-cause evidence, and avoid claiming atomicity or physical truth from an inappropriate trace.

### Exact next-work checkpoint

1. Read current official LinuxCNC debugging/diagnostics material for HAL (`halcmd`, `halscope`, `sampler/halsampler`), Motion/Task error/status surfaces, NML/logging, and relevant runtime debug options.
2. Search community reports for realistic diagnostic failures: stale GUI status, realtime-vs-userspace timing confusion, sampler/HAL stream pitfalls, misleading single-pin evidence, and cases where logging changed or obscured timing.
3. Inventory the pinned source behind at least these observation layers: HAL object inspection, realtime sampler/stream path, Task/NML error/status publication, and LinuxCNC process logging/error channel.
4. Build a **diagnostic evidence matrix** with columns: observation question, preferred surface, execution context, ordering/timing guarantee, failure mode, retention method, and what the observation cannot prove.
5. Trace one end-to-end diagnostic call flow from an actual realtime/Task fault to a user-observable retained artifact.
6. Only after that source/matrix pass, freeze the highest-value C08 experiment. Prefer a test that deliberately creates two plausible fault interpretations and requires the retained traces to discriminate them; do not simply demonstrate that a logging command runs.
7. Preserve the safety boundary: diagnostic visibility is evidence, not by itself a safety function or physical-state guarantee.
