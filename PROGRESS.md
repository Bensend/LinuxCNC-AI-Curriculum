# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative.

## Current critical-path state

All modules through **T05**, **C01**, **C02**, **C03**, **C04**, **C05**, and **C06** are **GRADUATED at 1000 level**. Phase 10 remains active. Highest-priority unblocked work is **C07 — state-machine sequencing**, state **EXPERIMENT / AUTHORITATIVE HARNESS CONSTRUCTION**.

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
- `results/C06-046-authoritative-phase-first-reconciliation.md` — accepted TEST-CONFIRMED evidence.
- `exams/C06-adversarial-exam-and-corrections.md` — **10/10 PASS**.
- `handoffs/C06-novel-transport-watchdog-transfer.md` — novel scenario PASS, promotion and counterfactual audit PASS.

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

The asymmetric observability correction is explicit in the main guide. Current official HostMot2 documentation remains internally divergent about whether a watchdog bite stops all communication; that version/firmware question is promoted rather than silently generalized.

C06-046 workflow `34312802937`, job `102342754452`, artifact `10089037385`, authoritative runtime **3.4 min**, retained 2,976 ordered samples and passed frozen Gates A–H. C06 satisfied the minimum graduation evidence floor, adversarial exam, novel handoff, promotion queue, and counterfactual audit.

**Decision: C06 GRADUATED at 1000 level. Do not rerun C06-030 absent a newly discovered specific defect.**

## C07 — state-machine sequencing

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Status: **EXPERIMENT / AUTHORITATIVE HARNESS CONSTRUCTION**.

Durable artifacts:
- `guides/C07-state-machine-sequencing-research.md`
- `guides/C07-source-resolution-addendum.md`
- `call-flows/C07-halui-task-state-request-status.md`
- `guides/C07-function-symbol-guide.md`
- `experiments/C07-047-request-achieved-state-sequencing-plan.md` — **Gates A–J frozen before implementation/output inspection**.
- `experiments/C07-047-sequencer-construction-notes.md`
- `lab-jobs/047-c07-blocked-on-preflight.sh`
- `results/C07-047-blocked-on-preflight-reconciliation.md` — **NON-AUTHORITATIVE PREFLIGHT PASS**.

Source-confirmed findings:

- HALUI request pins such as `halui.machine.on`, `.off`, `estop.activate/reset`, home-all, and joint-home are rising-edge-triggered at the pinned revision: `check_bit_changed()` returns true only on a changed-to-true input. Holding a request high does not continuously resend it; the pin must return low before a later fresh request edge.
- `halui.machine.on` rising edge -> `sendMachineOn()` -> NML `EMC_TASK_SET_STATE(ON)` -> Task dispatch -> `emcTaskSetState(ON)` -> `emcTrajEnable()` -> `EMCMOT_ENABLE`.
- HALUI publishes achieved state on a separate return path: `halui.machine.is-on` is driven from received `emcStatus->task.state == ON`; homed pins likewise come from motion status rather than request history.
- `emcTrajEnable()` only writes an `EMCMOT_ENABLE` command. Realtime `command.c` then checks the actual `motion.enable` HAL input. If false it reports `can't enable motion, enable input is false` and does not set `emcmotInternal->enabling`; if true it requests deferred enable for the controller cycle.
- `motion.enable` is a real HAL_IN created by `motion.c`, default TRUE when disconnected. It is therefore a deterministic, production-source-grounded blocked-transition seam for a software-only test.
- The servo controller can subsequently revoke enabling if `motion.enable` falls while active, or on joint/spindle/misc faults. Successful controller entry sets `EMCMOT_MOTION_ENABLE_BIT`; Task-side trajectory status sets `enabled` only from that returned flag, and `determineState()` derives Task ON from achieved trajectory enabled plus out-of-estop status.
- `emcTaskAbort()` clears pending/interpreter execution state and resynchronizes the plan; a post-fault sequencer must not silently reuse stale pre-fault execution authorization.
- OFF/ESTOP unhome only the `volatile_home` subset through `emcJointUnhome(-2)`. HALUI's homed outputs come from actual returned motion joint status, so homing must be observed, not inferred universally from state-command history.

Frozen C07-047 prediction:

```text
machine-on request while motion.enable=false -> no achieved ON
motion.enable restored without a fresh HALUI rising edge -> still no achieved ON
fresh request edge after prerequisite restoration -> achieved ON may follow; sequencer advances only after status
loss of motion.enable while ON -> active achieved state revoked
fault-input restoration alone -> no automatic pre-fault resume
fresh authorization + fresh request + achieved-state confirmation -> guarded recovery permitted
```

The authoritative plan explicitly requires a blocked-transition adversarial case, active-state interruption, no implicit retry, no automatic restart, ordered observation evidence, and a retained non-functional-safety boundary.

### C07-047 topology preflight — accepted

Workflow **`34314733007`**, job **`102348466843`**, artifact **`10089716849`**, digest `sha256:c458fde6dfa4a52b9ac51a568e4d2c6f57665b78d8a3c2bbfa52e3b53dba67a7`, wall runtime **3m26s (3.43 min)**.

The preflight checked out the exact pinned source and retained production-file SHA-256 values. Actual HAL object readiness passed, not merely command-exit readiness. With an out-of-estop/machine-off baseline:

```text
motion.enable=FALSE + one fresh halui.machine.on edge
    -> halui.machine.is-on=FALSE
    -> motion.motion-enabled=FALSE

motion.enable restored TRUE, no new request edge
    -> halui.machine.is-on=FALSE

new fresh halui.machine.on edge
    -> halui.machine.is-on=TRUE
    -> motion.motion-enabled=TRUE
```

This is **PREFLIGHT PASS ONLY**. Frozen C07-047 Gates A–J remain **UNSCORED**. It proves that the selected software-only topology can exercise the requested-vs-achieved-state discriminator and HALUI no-implicit-retry edge semantics without modifying production HALUI/Task/Motion source.

## Exact next-work checkpoint

1. Do not rerun the accepted topology preflight unless the topology changes.
2. Construct the test-only C07-047 sequencer on the passing topology using `experiments/C07-047-sequencer-construction-notes.md`: one fresh `start_authorize` -> one machine-on request edge -> wait for achieved `halui.machine.is-on`; no hidden retry; loss of achieved ON revokes cycle permission; post-fault recovery consumes all prior authorization and requires a fresh one.
3. Add ordered observability for P0–P8: phase ID, sequencer state, `start_authorize`, machine-on request, `motion.enable`, `motion.motion-enabled`, `halui.machine.is-on`, and cycle permission. HALUI is userspace-mediated, so use a single monotonic userspace observer if it can read all objects consistently; otherwise prove cross-stream ordering with an explicit synchronization marker before scoring.
4. Run one **non-authoritative full phase/ordering preflight** to prove phase publication occurs before each decisive mutation and the observer cannot hide transition ordering. Do not score Gates A–J from that run.
5. If that full preflight passes, execute one authoritative C07-047 run against the **unchanged** P0–P8 semantics and Gates A–J, retain exact harness/config/source hashes/raw trace, and reconcile each gate.
6. Preserve the boundary: ordinary Task/HAL sequencing is state-integrity logic, not functional-safety certification; physical state, external E-stop/energy removal and restart interlocks remain machine-specific higher-level work.
