# 4000-LC-M66-139 — Task deadline-versus-input evaluation ordering

**Audited:** 2026-11-01. **Status:** SOURCE-CONFIRMED conditional / runtime NOT RUN / NON-GRADUATED. This is a companion to [M66-138](4400_LINUXCNC_M66_138_TIMEOUT_STALE_WAIT_TRUNCATES_G4_DWELL_SOURCE_AUDIT_2026-11-01.md), not a duplicate of earlier [M66-01](4400_LINUXCNC_M66_WAIT_TIMEOUT_AND_NONSAFETY_INPUT_AUTHORITY_AUDIT_2026-10-27.md).

## Specific question

If Task first observes an M66 timeout deadline on the **same polling pass** that the current input status satisfies the wait condition, does timeout win, success win, or is the result undefined?

## Exact implementation evidence

Stable [`src/emc/task/emctaskmain.cc` L2737–2792](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2737-L2792) and pinned development [L3051–3101](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emctaskmain.cc#L3051-L3101) implement **two independent `if` statements**, not an `if/else`:

1. `if (etime() >= taskExecDelayTimeout)` first sets `execState=DONE`, `delayLeft=0`, and `input_timeout=1` if it was nonzero.
2. Immediately afterward, `if (emcAuxInputWaitIndex >= 0)` checks the selected `synch_di`. If `WAIT_MODE_HIGH` sees nonzero, or `WAIT_MODE_LOW` sees zero, it sets `input_timeout=0`, clears the index, and sets `execState=DONE` again.
3. Interpreter later samples `#5399` using [`rs274ngc_pre.cc` L1459–1472](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/rs274ngc_pre.cc#L1459-L1472) and [`GET_EXTERNAL_DIGITAL_INPUT` L3081–3093](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L3081-L3093): only `input_timeout==1` forces -1, otherwise it returns the **then-current** digital level.

**Source-derived precedence:** when the Task deadline test is true and the Task input-condition test is also true in one pass, the input branch is the **last writer**, so the stored timeout flag is 0. This is not an unconditional claim that a physically late edge is accepted: Task does not timestamp the actual input transition here, and the observed HIGH may have arrived before the deadline but only become visible on this poll. Nor does the code prove that the input remains HIGH until the interpreter reads it.

## Truth table: `M66 P0 L3 Q0.5`

| Task pass at deadline | `synch_di[0]` on same pass | Stored `input_timeout` after pass | Expected `#5399` if status remains stable until interpreter read |
|---|---|---|---|
| Before deadline | LOW | 2 (pending) | Not yet readable; wait still pending |
| Before deadline | HIGH | 0 (success) | 1 |
| At/after deadline | LOW | 1 (timeout); index remains armed | -1 |
| At/after deadline | HIGH | 0 (input branch overwrites timeout); index cleared | 1 |

**No physical event timestamp** is captured by this Task code. At a coarse Task polling interval, Q is a software deadline test, not a certified edge-time cutoff. If a controller implementation requires strict deadline precedence, that policy needs an explicit check and regression tests rather than being inferred from the current branch order.

## Separate issue: stale index persists on timeout

The at/after-deadline LOW row also explains [M66-138](4400_LINUXCNC_M66_138_TIMEOUT_STALE_WAIT_TRUNCATES_G4_DWELL_SOURCE_AUDIT_2026-11-01.md): unlike the HIGH row, the LOW timeout path does not disarm `emcAuxInputWaitIndex`. The next `EMC_TRAJ_DELAY` may be completed by the old input watcher. Do not conflate these two mechanisms: **deadline precedence** concerns the M66 result at its own completion; **stale index** concerns a subsequent G4's completion.

## Proposed isolated test and limitations

A qualified, disconnected Task harness should freeze the same `etime()` and `synch_di` samples for four rows above, capture `input_timeout`, `emcAuxInputWaitIndex`, `execState`, and the eventual `#5399`. Inject a status transition just before, at, and just after the deadline to distinguish polling-order semantics from actual edge-time semantics. **No such harness has been run.** Source arithmetic and control-flow review only. Not a physical interlock, no personnel-safety release, and no change to graduated levels.
