# 3800 — ClassicLadder realtime sequencing and recovery source trace

Date: 2026-09-14
LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: SOURCE-CONFIRMED / DOC-CONFIRMED

## Why this matters for 3800

Automatic saws, feeders and transfer cells spend much of their time in clamp/feed/transfer/cut state rather than continuous contouring. ClassicLadder is therefore a plausible LinuxCNC-native place for deterministic machine sequencing, but only if its scan, stop/run and sequential-state semantics are understood precisely.

## 1. Execution context and scan rate

Pinned source: `src/hal/classicladder/module_hal.c`, function `hal_task()`.

`classicladder_rt` exports the realtime HAL function:

`classicladder.0.refresh`

for insertion into a HAL thread. Official documentation shows it commonly added to `servo-thread`.

The realtime function accumulates thread periods and does not perform a ladder scan until at least 1 ms has elapsed. Therefore placing ClassicLadder in a faster thread does **not** make rung scans faster than 1 kHz. A slower thread slows the scan further.

The scan data path is explicit:

`HAL bool/s32/float inputs`
→ `HalReadPhysicalInputs / HalReads32Inputs / HalReadFloatInputs`
→ `ClassicLadder_RefreshAllSections()`
→ `HalWritePhysicalOutputs / HalWrites32Outputs / HalWriteFloatOutputs`
→ `HAL outputs`

This is useful for automation because physical inputs are snapshotted into ClassicLadder variables before logic, then physical outputs are copied after all sections execute.

## 2. Section ordering is real state authority

Pinned source: `src/hal/classicladder/calc.c`, `ClassicLadder_RefreshAllSections()`.

Each scan calls `CycleStart()`, then iterates the `SectionArray` in numeric order. Used main ladder sections are refreshed and sequential sections are refreshed as encountered, then `CycleEnd()` is called.

This means section order is behaviorally significant when sections share internal variables. A saw/feeder playbook must not treat section organization as cosmetic.

Official documentation separately warns about scan semantics and the "Last One Wins" behavior for duplicated outputs. Therefore a production cell should assign one explicit owner per actuator command where practical instead of scattering writes across sections/rungs.

## 3. Sequential/Grafcet transition semantics

Pinned source: `src/hal/classicladder/calc_sequential.c`.

`PrepareSequential()` is the explicit state initializer. It:

- clears every step's active/time state;
- reactivates steps marked `InitStep`;
- clears transition activation.

`RefreshTransi()` evaluates the transition condition and then requires all configured steps-to-deactivate to be active. If eligible, it deactivates those steps and activates the configured successor steps.

`RefreshSequentialPage()` repeatedly rescans transitions while any transition changes state, bounded by `LoopSecurity < 50`, then publishes step activity/time variables.

### Important automation consequence

Multiple transitions can therefore cascade during a **single ClassicLadder scan** if successor transition conditions are already true. For clamp/feed/cut logic this means:

- a transition condition should represent a real edge/state qualification when the machine requires physical settling or proof;
- simply placing a sequence into adjacent Grafcet steps does not itself guarantee one servo scan or one physical-event dwell per step;
- explicit witness, timer, generation/edge, or other transition qualification may be necessary to prevent unintended same-scan step collapse.

This is source-visible and does not require a synthetic lab.

## 4. STOP/RUN freezes rather than reconciles outputs

The most important recovery result is visible by combining `classicladder.c` and `module_hal.c`.

`DoFlipFlopRunStop()` only toggles `InfosGene->LadderState` between `STATE_RUN` and `STATE_STOP`. It does not call `PrepareSequential()`, clear sequential state, or clear output variables.

Inside realtime `hal_task()`:

- `classicladder.ladder-state` is updated;
- input read, section refresh, and output write occur **only** when `LadderState == STATE_RUN`;
- when STOPPED, the function does not call `HalWritePhysicalOutputs()`.

Therefore an actuator HAL output that was already asserted on the previous scan is not generically forced false merely by stopping ClassicLadder. The HAL output pin retains the last value unless some other owner/hardware layer changes it.

Likewise, STOP/RUN does not automatically reset the Sequential Function Chart to initial steps. Since the active step structures are not reinitialized by the Run/Stop toggle, Run resumes from the retained ClassicLadder state.

### 3800 rule

**ClassicLadder STOP is not a machine-safe-state primitive and is not a partial-cycle recovery primitive.**

For a saw/feed/transfer machine, safety/recovery must be separately designed. Examples:

- hydraulic valve outputs that must de-energize need an independent gating/failsafe path;
- clamp state should not be assumed from ladder RUN/STOP state;
- restart must reconcile retained sequence step with actual clamp/stock/saw state;
- an operator "reset cycle" action should be distinct from merely pressing ClassicLadder Run.

Functional safety remains outside ordinary ClassicLadder/HAL unless separately implemented and validated by safety-rated means.

## 5. Same-scan I/O boundary

The source order gives a bounded data-age model:

1. HAL input pins are copied into ClassicLadder variables at scan start.
2. all ladder/sequential logic runs against that sampled state plus internal state changes occurring during the scan;
3. HAL output pins are updated at the end.

A physical input change after the input-copy point is not observed until a later scan. At the normal maximum scan rate that means ClassicLadder contributes a scan-level latency in addition to hardware/fieldbus/servo scheduling latency.

For normal saw hydraulics this may be acceptable. For sub-millisecond edge capture or safety functions, ClassicLadder is the wrong assumption unless a separate hardware/realtime mechanism supplies the requirement.

## 6. Application to partial-cycle recovery

A robust automatic saw/feeder implementation can use ClassicLadder/Grafcet, but should preserve at least these separate concepts:

- **cycle step** — logical sequence state;
- **actuator command** — requested valve/motor/clamp state;
- **physical witness** — limit, pressure, position, stopped/stable or part-presence feedback;
- **step generation** — prevents stale acknowledgements from a previous cycle satisfying a new request where necessary;
- **fault/recovery state** — timeout, contradictory sensors, stock loss, jam, saw/blade fault;
- **manual/recovery authority** — controlled actuator operation outside automatic sequence;
- **safe output gating** — independent of whether the ladder evaluator is RUNNING.

On recovery, the retained Grafcet step is evidence about **software intent**, not proof of physical machine state.

## 7. Function/call-flow inventory

| Path / symbol | Role | Execution context | Key consequence |
|---|---|---|---|
| `module_hal.c::hal_task` | periodic physical-I/O bridge + logic scan | realtime HAL thread | max 1 kHz ladder scan; RUN-only read/execute/write |
| `calc.c::ClassicLadder_RefreshAllSections` | ordered section dispatcher | realtime scan | section ordering is behaviorally significant |
| `calc.c::RefreshASection` | ladder rung traversal | realtime scan | jumps/subroutine behavior occurs within scan; runaway jump guard can STOP ladder |
| `calc_sequential.c::PrepareSequential` | reset SFC to initial steps | explicit initialization path | not invoked by basic Run/Stop toggle |
| `calc_sequential.c::RefreshSequentialPage` | SFC transition propagation | realtime scan | multiple transitions may cascade, max 50 propagation loops |
| `classicladder.c::DoFlipFlopRunStop` | GUI/userspace ladder run/stop state | non-realtime control path | toggles evaluator state only; no machine-state reconciliation |

## 8. Adversarial review

1. Does putting ClassicLadder in a 100 us thread produce 100 us ladder scans? **No.** Source gates execution to accumulated >=1 ms.
2. Does a STOP clear `%Q` HAL output pins? **No generic clear path was found; output-copy is simply skipped.**
3. Does STOP reset Grafcet to initial steps? **No.** The toggle does not invoke `PrepareSequential()`.
4. Does each Grafcet step necessarily persist for at least one scan? **No.** Successive true transitions can cascade in the same scan.
5. Are sections merely organizational? **No.** They execute in defined array order and shared state can make that observable.
6. Does known software sequence step prove clamp/stock state after an interruption? **No.** Physical witnesses require reconciliation.
7. Is ClassicLadder appropriate as the sole safety function for hazardous machinery? **No evidence supports that; ordinary HAL/PLC logic is not automatically safety-rated.**

Result: **7/7 boundaries preserved.**

## 9. Evidence-gain decision

This source pass closes the first generic LinuxCNC sequencing question for 3800. A lab would mostly restate source-visible STOP/output-retention and same-scan transition behavior, so no lab is justified yet.

The next useful evidence should come from a real complete or near-complete saw/transfer implementation, especially one exposing:

- clamp proof and stock transfer;
- valve neutralization on abort/fault;
- cycle-step/manual-mode reconciliation;
- miter lock/position authority;
- blade running/break/tension witness;
- cut-list/HMI ownership versus realtime sequence ownership.

If no mature public saw config appears, compare a non-saw LinuxCNC automation cell/indexer before searching generic ladder semantics again.
