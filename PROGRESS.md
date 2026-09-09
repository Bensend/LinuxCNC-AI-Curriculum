# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, **C05**, and **C06** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C07 — state-machine sequencing**, state **RESEARCH / SOURCE**.

## Blind external-feedback state

- **BL-DEV-001:** VALID, 10/10, 92% confidence.
- **BL-DEV-002:** VALID, 9/10, 88% confidence.
- **BL-DEV-002-TRANSFER-01:** VALID, **10/10**, 95% confidence. Novel numeric same-mechanism retest correctly retrieved the pinned velocity-scaled-plus-`MIN_FERROR` floor and strict `>` comparison. This is transfer evidence, not delayed-retention evidence.
- No new blind challenge is due merely because C07 has begun; delayed retention remains distinct and should be scheduled at a meaningful later checkpoint.

## C06 — communication/watchdog fault handling — GRADUATED at 1000 level

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Primary durable artifacts:

- `guides/C06-communication-watchdog-fault-research.md`
- `call-flows/C06-hostmot2-transport-watchdog-order.md`
- `guides/C06-function-symbol-guide.md`
- `guides/C06-transport-watchdog-injection-source-audit.md`
- `experiments/C06-030-transport-watchdog-fault-plan.md` — Gates A–H frozen before implementation/output inspection.
- `experiments/C06-030-fixture-construction-notes.md`
- `results/C06-036-clean-fixture-preflight-reconciliation.md`
- `results/C06-037-redesigned-authoritative-attempt-1-reconciliation.md`
- `results/C06-038-redesigned-authoritative-attempt-2-reconciliation.md`
- `results/C06-039-sampler-stream-attach-diagnostic-reconciliation.md`
- `results/C06-041-043-readiness-diagnostic-reconciliation.md`
- `results/C06-044-phase-publication-reconciliation.md`
- `results/C06-045-phase-publication-preflight-attempt-1.md`
- `results/C06-046-authoritative-phase-first-reconciliation.md` — accepted TEST-CONFIRMED evidence.
- `exams/C06-adversarial-exam-and-corrections.md` — **10/10 PASS**.
- `handoffs/C06-novel-transport-watchdog-transfer.md` — novel scenario PASS, promotion and counterfactual audit PASS.
- accepted clean fixture patch: `lab-results/run-34306117465-1/c06-clean-hm2test.patch`.

Accepted central teaching:

```text
packet/read error != watchdog bite
io-error != necessarily watchdog.has_bit
host receive timeout != proof FPGA watchdog status
watchdog.has_bit=false during broken transport != proof the FPGA watchdog did not bite
watchdog bite != proof a version-independent communication state
watchdog bite != proof complete physical safe state
transport recovery != watchdog recovery
fault reset != proof plant is safe to resume
ordinary HostMot2/HAL fault handling != functional-safety certification
```

The asymmetric observability correction is now explicit in the main guide: a true host-side `watchdog.has_bit` means the watchdog status was processed in the tested contract, while a false pin during failed transport is not independent negative evidence about the FPGA watchdog.

Current official HostMot2 documentation remains internally divergent: the driver guide describes I/O-pin disconnection without saying all communication stops, while current `hostmot2(9)` still contains the blanket "all communication with the board stops" wording. This is promoted for board/firmware/version-specific study rather than silently generalized.

### C06 accepted experiment

C06-046 workflow `34312802937`, job `102342754452`, artifact `10089037385`, authoritative runtime **3.4 min**. The run retained 2,976 strictly ordered single-stream rows, empty sampler stderr, exact pinned-source/fixture provenance, and frozen Gates A–H all PASS. The preflight-to-authoritative diff changed exactly two labels and no behavior.

### C06 graduation sufficiency

- Source mechanism/end-to-end call flow: PASS.
- Independent verification: PASS via C06-046.
- Representative failure path: PASS.
- Predeclared prediction checked against evidence: PASS.
- Adversarial exam: 10/10 PASS.
- Fresh-AI novel transfer: PASS.
- Promotion queue populated with version/firmware timing, physical output-state, and restart-policy uncertainties.
- Counterfactual promotion test: PASS; if promoted hardware/version details differ, the scoped central teachings above remain valid.

**Decision: C06 GRADUATED at 1000 level. Do not rerun C06-030 absent a newly discovered specific defect.**

## C07 — state-machine sequencing

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Status: **RESEARCH / SOURCE**.

Initial durable artifact:
- `guides/C07-state-machine-sequencing-research.md`

Initial findings:

- Official HALUI is a HAL-to-NML command/status adapter; request pins such as `halui.estop.reset` and `halui.machine.on` must not be treated as achieved-state proof.
- Pinned `emctaskmain.cc` states that Task cyclically calls `emcTaskPlan()` and `emcTaskExecute()`, with command handling dependent on machine mode/state.
- `emctask.cc::emcTaskSetState()` shows materially different actions for OFF, ON, ESTOP_RESET, and ESTOP. In particular ON primarily enables trajectory and does not itself prove homing, drive readiness, physical state, or restart safety.
- `emctask.cc::determineState()` derives Task state from subsystem state (`io.aux.estop` and trajectory enabled state), reinforcing the design rule **command request != achieved machine state**.
- ESTOP/OFF call `emcJointUnhome(-2)`, which applies only to volatile-home joints; homing invalidation is configuration-dependent rather than universal.
- Community field cases expose stale external-toggle state and unsafe assumptions about software E-stop/machine-enable sequencing. These remain investigation leads, not authoritative recipes.

## Exact next-work checkpoint

1. Continue C07; do not reopen C06 unless a specific contradiction appears.
2. Trace the pinned HALUI path for `halui.estop.activate/reset`, `halui.machine.on/off`, and homing requests through NML command generation into Task dispatch. Record edge/pulse semantics and status feedback used to verify achieved state.
3. Trace `emcTrajEnable()` / `emcTrajDisable()` into the motion command/status boundary and identify stable experiment observables.
4. Trace `emcTaskAbort()` and volatile-home behavior far enough to distinguish what state is cleared, preserved, or configuration-dependent after OFF/ESTOP/ESTOP_RESET.
5. Build the C07 function/symbol guide and a complete request -> Task -> Motion/status call-flow artifact.
6. Design and freeze a deterministic C07 experiment before implementation. It must include a blocked-transition adversarial case proving that the capstone state machine does not advance merely because it emitted a request pulse, plus fault interruption and guarded recovery with an explicit fresh restart authorization.
7. Preserve the safety boundary: ordinary Task/HAL sequencing is state-integrity logic, not functional-safety certification.
