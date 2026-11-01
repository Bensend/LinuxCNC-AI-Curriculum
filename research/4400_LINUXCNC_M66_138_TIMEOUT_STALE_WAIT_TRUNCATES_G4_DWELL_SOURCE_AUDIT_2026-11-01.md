# 4000-LC-M66-138 — Timed-out input wait can remain armed across a later G4 dwell

**Date audited:** 2026-11-01. **Status:** SOURCE-CONFIRMED conditional control-flow defect; **runtime NOT RUN**, NON-GRADUATED. **Transfer:** 3300 plasma/pierce timing, 3100 tool-change, 3400 process waits, 4000 Task/NML. No machine-release or personnel-safety claim.

## Why this is incremental, not another M66 primer

The existing [M66-01 source audit](4400_LINUXCNC_M66_WAIT_TIMEOUT_AND_NONSAFETY_INPUT_AUTHORITY_AUDIT_2026-10-27.md) already establishes L1/L3 semantics, timeout returning `#5399=-1`, normal HAL input provenance, and the need to reject timeouts. This investigation adds a **distinct Task-state lifetime problem**: a timed-out M66 leaves its input index armed; the later **G4 dwell uses the same Task execution state**, so a subsequent change on that old input can complete the dwell before its programmed duration. Prior M66-01 did not trace the M66→G4 state ownership. The [QtPlasmaC material M66 audit](4400_LINUXCNC_QTPLASMAC_M190_M66_MATERIAL_HANDOFF_SOURCE_AUDIT_2026-10-30.md) concerns a different M190/material handshake.

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

## Falsifiable predictions and controls (all NOT RUN)

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

**SOURCE-CONFIRMED:** static variable lifetime, timeout missing reset, shared postcondition, G4 deadline-only initialization, interpreter result read, and the upstream torch example. **DOC-CONFIRMED:** [M66 Q/#5399 and non-realtime warning](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/m-code.adoc#L385-L431). **INFERENCE:** actual premature G4 completion under the described timing. **TEST-CONFIRMED:** none. No LinuxCNC build, Task execution, simulation, physical machine, Actions runner, independent evaluator, or measured latency. Do not promote this to an observed plasma failure or independent safety-system claim. The existing graduated levels and personnel-safety G0/G1 HOLD are unchanged.
