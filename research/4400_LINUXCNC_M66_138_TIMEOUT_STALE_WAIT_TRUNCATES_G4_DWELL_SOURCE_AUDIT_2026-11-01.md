# 4000-LC-M66-138 — Timed-out input wait can remain armed across a later G4 dwell

**Date audited:** 2026-11-01. **Status:** SOURCE-CONFIRMED at v2.9.10 / pinned development; **historical TEST-CONFIRMED at 8bf4605** (M66-140); **new A–E and current-version runtime NOT RUN**, NON-GRADUATED. **Transfer:** 3300 plasma/pierce timing, 3100 tool-change, 3400 process waits, 4000 Task/NML. No machine-release or personnel-safety claim.

> **EVIDENCE CORRECTION (2026-11-01, M66-140):** This same stale-wait → premature-G4 mechanism was **already TEST-CONFIRMED in a historical disconnected LinuxCNC run on 2026-09-11**, on pinned commit `8bf4605ae81042248add031e94c77300406e0413`. The original claim of “TEST-CONFIRMED none” was incorrect at the repository level. [Read the executable-oracle reconciliation](4400_LINUXCNC_M66_140_HISTORICAL_RUNTIME_ORACLE_RECONCILIATION_2026-11-01.md) and [lab 079 retained stdout](../lab-results/run-34593401753-1/stdout.log). This document's *new* L3 A–E matrix and v2.9.10 / `06864e` runtime comparisons remain NOT RUN. Source/version trace and plasma transfer remain useful, but **not a first discovery of the defect**. The old hosted runner was historical; no new hosted compute is permitted.

## Incremental source/version analysis and plasma transfer (not first discovery)

The existing [M66-01 source audit](4400_LINUXCNC_M66_WAIT_TIMEOUT_AND_NONSAFETY_INPUT_AUTHORITY_AUDIT_2026-10-27.md) already establishes L1/L3 semantics, timeout returning `#5399=-1`, normal HAL input provenance, and the need to reject timeouts. This source audit re-examines an **already historically reproduced Task-state lifetime problem** on two newer source revisions and applies it to plasma: a timed-out M66 leaves its input index armed; the later **G4 dwell uses the same Task execution state**, so a subsequent change on that old input can complete the dwell before its programmed duration. Prior M66-01 did not trace the M66→G4 state ownership. The [QtPlasmaC material M66 audit](4400_LINUXCNC_QTPLASMAC_M190_M66_MATERIAL_HANDOFF_SOURCE_AUDIT_2026-10-30.md) concerns a different M190/material handshake.

## Pinned source inventory

| Evidence | Stable v2.9.10 | Development `06864e23559e70463fc7112d5ce77138bcbc288c` |
|---|---|---|
| Task wait globals, including `emcAuxInputWaitIndex=-1` | [emctaskmain.cc L419–425](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L419-L425) | [L471–475](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emctaskmain.cc#L471-L475) |
| `EMC_AUX_INPUT_WAIT` initialization | [L1923–1938](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L1923-L1938) | [L2032–2044](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emctaskmain.cc#L2032-L2044) |
| `EMC_TRAJ_DELAY` handler | [L1872–1878](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L1872-L1878) | [L1947–1953](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emctaskmain.cc#L1947-L1953) |
| Both commands share `WAITING_FOR_DELAY` postcondition | [L2492–2498](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2492-L2498) | [L2637–2643](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emctaskmain.cc#L2637-L2643) |
| Deadline and input check | [L2737–2792](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2737-L2792) | [L3051–3101](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emctaskmain.cc#L3051-L3101) |
| Canonical `DWELL` appends `EMC_TRAJ_DELAY` | [emccanon.cc L1849–1857](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L1849-L1857) | Same source-path mechanism; no independent development execution |
| Interpreter M66 `input_flag` → `#5399` | [rs274ngc_pre.cc L1459–1472](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/rs274ngc_pre.cc#L1459-L1472) and [emccanon.cc L3081–3093](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L3081-L3093) | Source-path parity not independently executed |

The inspected stable `emctaskmain.cc` blob is `7292a172023a5b42b023447c2458cb766c93fc9b`; development blob is `049c640f1af1b21c18161d6c065ff6f3e35fd83b`. These are **pinned source** observations, not runtime tests.

## Causal trace: two different commands share one lingering input index

1. Interpreter `M66 P0 L3 Q0.5` queues `EMC_AUX_INPUT_WAIT`. Task sets `emcAuxInputWaitType=WAIT_MODE_HIGH`, `emcAuxInputWaitIndex=0`, `input_timeout=2`, and deadline `now+0.5`. The postcondition enters `WAITING_FOR_DELAY`.
2. If input 0 stays LOW until Task sees `etime() >= taskExecDelayTimeout`, Task sets `execState=DONE`, `input_timeout=1`, and `delayLeft=0`. **This timeout branch does not reset `emcAuxInputWaitIndex`**. It remains 0 unless a later input-success branch or another M66 explicitly changes it.
3. Interpreter resumes and reads `#5399=-1` from `input_timeout=1`; `rs274ngc_pre.cc` clears its **interpreter** `input_flag`, not Task's static input index. Thus reading the timeout result does not disarm the Task input watcher.
4. Interpreter issues `G4 P4`; canonical `DWELL(4)` queues `EMC_TRAJ_DELAY`. Task assigns a new deadline `now+4` but **does not clear `emcAuxInputWaitIndex`**. Both G4 and M66 use `WAITING_FOR_DELAY`.
5. During G4, if input 0 becomes HIGH before four seconds elapse, the lingering `WAIT_MODE_HIGH` branch sets `execState=DONE`, `delayLeft=0`, and `emcAuxInputWaitIndex=-1`. The G4 wait can therefore end early **because an unrelated previous M66 input changed**. If the input never changes, G4 expires normally; the stale index can persist to another delay.

**Conditional timeline (illustrative, not measured):** at t=0 M66 begins; t=0.5 M66 times out; t≈0.6 G4 P4 starts; t≈1.0 input 0 becomes HIGH; the next Task poll can finish G4 near t≈1.0 rather than t≈4.6. Scheduling and status polling introduce unmeasured delays; these numbers are an illustrative oracle, not predicted exact timestamps.

## Real upstream program with the same command adjacency

LinuxCNC's [`nc_files/touchoff.ngc` at v2.9.10](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/nc_files/touchoff.ngc#L1-L19) contains `M3 S1` → `M66 P0 L1 Q5` (wait for torch Arc OK) → `G4 P#2` (pierce delay) → `Z#3` (cut-height move), with no `#5399` timeout branch in between. This is **upstream example source**, not evidence that any installed plasma machine uses it or that a dwell has actually been shortened. For L1, the stale state after timeout may be `WAIT_MODE_RISE` or `WAIT_MODE_HIGH` depending on sampled levels; an appropriate later low→high transition can satisfy it during G4.

This is more consequential than a generic timeout reminder: the old wait can alter a **different** command's completion semantics, even when the G-code has already consumed the timeout result.

## Falsifiable predictions and controls (new A–E matrix NOT RUN; historical L1 test confirmed)

| Disconnected scenario | Predicted Task effect | Discriminator |
|---|---|---|
| A: M66 L3 Q0.5 held LOW through timeout, then G4 P4, input HIGH ~1 s into G4 | G4 ends early after next Task poll; `#5399` saved before G4 is -1 | Compare actual G4 wall-clock, Task execState and `input_timeout` |
| B: same but input remains LOW for full G4 | G4 runs full programmed duration; stale input index persists | Distinguishes normal deadline path |
| C: same but `M66 P0 L0` inserted after saving first `#5399` and before G4 | Immediate M66 disarms index; G4 runs full duration even if input rises | **Test-only** disarming control, not recommended production workaround |
| D: G4 P4 with no preceding timed-out M66 | G4 runs full duration | Baseline |
| E: preceding M66 succeeds before timeout | Success branch clears index; later G4 unaffected by that input | Success-path control |

Minimal program fixtures: [exposure](../examples/4000_m66_dwell/m66_timeout_then_g4.ngc) and [disarming control](../examples/4000_m66_dwell/m66_timeout_clear_then_g4.ngc). These are **disconnected software fixtures only**; no HAL producer or live machine has been configured or tested.

## Corrective design hypothesis, not a patch

The Task timeout path should disarm the input watcher when completing an M66, or the `WAITING_FOR_DELAY` input-check should be explicitly conditioned on the **currently active command being an input wait**, rather than relying on a process-static index left from earlier commands. Any fix must preserve `input_timeout=1` until the interpreter reads `#5399` and must not introduce a new read-ahead or abort race. A one-line index reset is plausible but requires qualified isolated regression tests before proposing an upstream change.

## Evidence and limitations

**SOURCE-CONFIRMED:** static variable lifetime, timeout missing reset, shared postcondition, G4 deadline-only initialization, interpreter result read, and the upstream torch example. **DOC-CONFIRMED:** [M66 Q/#5399 and non-realtime warning](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/m-code.adoc#L385-L431). **TEST-CONFIRMED (historical 8bf4605 only):** prior lab 079 reproduced early total program completion with M66 L1 Q0.20 → G4 P0.50 (0.311439 s total vs 0.505165 s G4-only control). **INFERENCE / NOT RUN:** exact G4 start/end, v2.9.10 and 06864e runtime, and new L3 A–E controls. No LinuxCNC build, Task execution, simulation, physical machine, Actions runner, independent evaluator, or measured latency. Do not promote this to an observed plasma failure or independent safety-system claim. The existing graduated levels and personnel-safety G0/G1 HOLD are unchanged.

## Existing upstream test coverage: nearby, but not this failure path

Inspected [`tests/mdi-queue-length/test-ui.py` L85–121](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/tests/mdi-queue-length/test-ui.py#L85-L121), stable blob `44ddaeef7411bf0876b9113a87bab025b28aa0e7`. It queues `M66 P0 L3 Q30` → `G4 P0` → `M66 P0 L4 Q30` → `G4 P0` and toggles the simulated digital input to **satisfy** both waits. The G4 commands have **zero dwell**, and the test asserts MDI queue length, not post-timeout dwell duration. This is useful existing Task/MDI infrastructure but **does not exercise M66 timeout, a nonzero G4, or the stale-index branch**. Reuse its disconnected input-poker pattern where possible instead of building a duplicate LinuxCNC test environment. Existing test **inspected, NOT RUN**.

## Follow-through: Task abort and program re-open do not visibly clear this static field

The same stale-index ownership deserves a **separate lifecycle discriminator**, not a new course module. Stable [`src/emc/task/emctask.cc::emcTaskAbort` L226–260](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctask.cc#L226-L260) aborts motion, clears the queued command/interpreter list, marks Task DONE/IDLE, queues interpreter synchronization, and closes/resets the interpreter. It does **not** reference `emcAuxInputWaitIndex`, which is a separate file-static in `emctaskmain.cc`. The [Task abort dispatch](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2108-L2122) calls that abort path. [`emcTaskPlanOpen` / `Close` / `Reset`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctask.cc#L545-L655) manipulate interpreter state, not the Task static index. Development [abort dispatch](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emctaskmain.cc#L2196-L2209) retains the same broad structure. The direct full-file stable/development `emctaskmain.cc` search found no index reset in those paths; the only index writes are initialization, M66 issue, and input-success branches.

**Conditional inference:** after an operator/program abort while M66 is pending, a subsequent G4 in the **same running Task process**, without an intervening M66 reset or Task process restart, may inherit the old input watcher. This is a broader possible scope than timeout→G4 in one program. It is **NOT** evidence of a reproduced cross-program fault; mode-switch, GUI and restart sequences may insert additional commands and must be recorded. A future isolated two-program test should arm an M66 wait, issue an actual Task abort, open a G4-only program, toggle the original input during the dwell, and compare with a clean Task process restart. Capture the exact abort/open/init command sequence; do not infer that GUI 'Reset' equals process restart. The first priority remains the simpler same-program timeout→G4 A–E matrix.
