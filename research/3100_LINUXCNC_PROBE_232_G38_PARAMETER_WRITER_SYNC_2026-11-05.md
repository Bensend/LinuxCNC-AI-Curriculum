# PROBE-232 — G38 result publication and interpreter synchronization (3100 Mills; NON-GRADUATED)

## Scope and evidence
Continuation of PROBE-230/231; LinuxCNC **v2.9.10** only. Source-inspection result, **not** a runtime or hardware test. This closes the previously missing interpreter parameter-writer trace.

Upstream pinned-tag sources:
- [interp_internal.cc, set_probe_data around L445–476](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_internal.cc#L445-L476)
- [rs274ngc_pre.cc, read_inputs around L1439–1455](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/rs274ngc_pre.cc#L1439-L1455)
- [interp_parameter_def.hh, G38 indices around L25–40](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_parameter_def.hh#L25-L40)
- [interp_execute.cc, probe_flag completion around L319](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_execute.cc#L319)
- [emccanon.cc, GET_EXTERNAL_PROBE_* accessors](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc)
See [PROBE-231](3100_LINUXCNC_PROBE_231_CANON_TASK_MOTION_BRIDGE_2026-11-05.md) for the preceding canonical→Task→motion command path and pinned blob IDs.

## Confirmed writer and sequencing
1. The interpreter finishes the probing block with `INTERP_EXECUTE_FINISH` when `probe_flag` is set, requiring a synchronization boundary before subsequent interpreter processing.
2. `Interp::read_inputs` checks `probe_flag`, refuses to publish while `GET_EXTERNAL_QUEUE_EMPTY()==0`, calls `set_probe_data(&_setup)`, then clears `probe_flag`.
3. `Interp::set_probe_data` invokes `refresh_actual_position(settings)` and assigns `settings->parameters[5061..5069]` from `GET_EXTERNAL_PROBE_POSITION_{X,Y,Z,A,B,C,U,V,W}()`. It assigns `parameters[5070]` from `GET_EXTERNAL_PROBE_TRIPPED_VALUE()`.
4. Rotary A/B/C values are reduced modulo 360 and made nonnegative when their corresponding `*_axis_wrapped` flag is set; X/Y/Z/U/V/W are assigned directly from the canonical accessors.
5. `interp_parameter_def.hh` explicitly documents 5061–5069 as probe-result coordinates in the coordinate system of the G38 operation, and 5070 as success (1) versus failed closure (0). The code proves *assignment* from canonical accessors, not the entire coordinate-transformation algebra. That remains to be traced through `GET_EXTERNAL_PROBE_POSITION_*` and canonical motion status conversion.

**Important correction to consumer design:** #5061–#5069 are not independently validated contact coordinates. On no-contact G38.3/G38.5, #5070 must be checked before treating them as a touch. The parameter writer itself does not branch on success before assigning the coordinate slots. A stale previous flag is cleared by the command sequence documented in PROBE-231, but full Task/status refresh timing is not runtime-confirmed.

## Reproducible inspection and falsifiable scenarios
At tag v2.9.10, inspect `rs274ngc_pre.cc::read_inputs`, `interp_internal.cc::set_probe_data`, and the G38 enum in `interp_parameter_def.hh`. Independently verify:
- **A:** probe_flag set + queue nonempty: expected error before parameter update; **SOURCE-CONFIRMED conditional path**, not executed.
- **B:** probe_flag set + queue empty + no contact: expected all coordinate slots assigned and #5070=0, provided canonical status says not tripped; **SOURCE-CONFIRMED writer**, upstream status provenance not fully traced.
- **C:** wrapped rotary angle -10° from canonical getter: expected 350° for that axis; **ANALYTICAL from code**, no runtime.
- **D:** probe_flag false: read_inputs does not call set_probe_data; **SOURCE-CONFIRMED conditional path**.
- **E:** a G38 block immediately followed by a conditional `o<...> if [#5070]`: inspect the Task queue drain and status refresh before claiming the branch sees the current result; **UNTESTED end-to-end**.

## Minimal disconnected G-code review fixture (do not run on an unqualified machine)
```ngc
G21 G90 G17
G38.3 Z-2 F30
(DEBUG, probe success=#5070 result Z=#5063)
o100 if [#5070 EQ 0]
  (DEBUG, no contact: do not treat #5063 as a measured surface)
o100 endif
M2
```
This is an **inspection fixture only**. It assumes a properly configured, homed, safely staged simulation with an appropriate initial Z position and probe input. It is not a ready-to-run real-machine program.

## Evidence ledger / dependency boundaries
| Claim | Classification | Evidence / limitation |
|---|---|---|
| 5061–5069 and 5070 written in set_probe_data | SOURCE-CONFIRMED v2.9.10 | interp_internal.cc |
| Queue-empty check before writer and flag clear | SOURCE-CONFIRMED v2.9.10 | rs274ngc_pre.cc |
| Rotary wrapped modulo adjustment | SOURCE-CONFIRMED v2.9.10 | interp_internal.cc |
| Exact coordinate transform and status freshness | OPEN | Trace canonical getters, motion status, Task synchronization |
| HAL probe polarity, debounce and real mill wiring | OPEN | Inspect pinned real HAL/INI config |
| Physical contact timestamp / stop overshoot | NOT CLAIMED | Needs qualified machine and instrumentation; not implied by sampled status |

No build, test, self-hosted compute, GitHub Actions, or machine action performed. Preserve graduated prerequisites, blind-evaluation separation, and independent personnel-safety authority.

## Next
Find a pinned real mill HAL/INI probe input net and follow its polarity/filtering and read→motion execution order. Then, if useful, inspect canonical probe coordinate transforms and Task status publication; otherwise rotate to mill tool change/spindle controls for greater information gain.
