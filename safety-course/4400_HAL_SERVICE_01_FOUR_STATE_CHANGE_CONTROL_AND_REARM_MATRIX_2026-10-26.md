# 4400-HAL-SERVICE-01 — Four service-change states that a green HMI cannot distinguish

**Status:** integrative engineering worksheet, **PAPER ONLY / NON-GRADUATED**. Source bases: [unlinked scalar input](../research/4400_LINUXCNC_HAL_UNLINK_STALE_TRUE_AND_SETS_WRITER_BOUNDARY_SOURCE_TRACE_2026-10-26.md), [stopped realtime callbacks](../research/4400_LINUXCNC_HAL_STOP_THREADS_NO_FINAL_ELEMENT_SAFE_STATE_TWO_REVISION_SOURCE_AUDIT_2026-10-26.md), [optional remote HAL edit](../research/4400_LINUXCNC_HALRMT_REMOTE_TOPOLOGY_CHANGE_AUTHORITY_AND_PHYSICAL_SAFETY_BOUNDARY_2026-10-26.md), and [snapshot all/allu fidelity](../research/4400_LINUXCNC_HAL_SAVE_ALL_VS_ALLU_UNCONNECTED_INPUT_RESTORATION_AUDIT_2026-10-26.md). Pinned LinuxCNC v2.9.10 and development `062dc7c097693bb68e76192516cd92878dd5ecdf`; no selected-machine physical evidence.

## State separation

| Normal-control service state | What source establishes | What a displayed TRUE/READY cannot establish | Human-friendly safe response |
|---|---|---|---|
| **A — input unlinked while TRUE** | `unlink_pin` copies last scalar signal value into dummy; subsequent writer changes no longer reach that pin | Live sensor, guard condition, independent stop or load hold | Show `input unlinked / last value`; restore approved topology under independently safe maintenance conditions |
| **B — realtime callbacks stopped** | `hal_stop_threads` disables cyclic function list; development ULAPI may wait for current pass | That output is now FALSE, watchdog fired, ram/spindle/arc physically safe | Separate `control loop stopped` from `safety function active`; require independent final-element/load witness |
| **C — optional remote HAL change accepted** | `halrmt` has HELLO/ENABLE access tiers and ordinary HAL setters when explicitly running | Correct safety program, empty hazard zone, local fresh-start consent | Disable unnecessary service; read-only support by default; log edits and require local service release |
| **D — snapshot saved/restored** | `save all` omits unconnected input dummy values; `allu` includes them | Complete machine config, physical sensor health, approved safety reset | Baseline comparison includes HAL graph, device/drive/safety config, physical wiring and independent validation |

**Evidence labels:** source mechanisms **SOURCE-CONFIRMED**, official manuals **DOC-CONFIRMED**, safe architecture **INFERENCE**, actual OpenPressBrake installed topology and physical outcomes **UNKNOWN**. No TEST-CONFIRMED or blind scores.

## Coupled adversarial chain — conditional, not a claimed incident
1. During service, an ordinary process permissive is TRUE and its input is unlinked; its dummy initially remains TRUE.
2. A technician saves `all` believing it captures that disconnected input value; the source says it does not.
3. Realtime callbacks are stopped; no physical safe state follows from that scheduler flag.
4. A separate authorized remote service interface may change ordinary HAL values/topology **if installed and enabled**; no source evidence says OpenPressBrake has it.
5. The local HMI says READY after restoration. **Nothing above independently proves Y1/Y2 stopped and held, trapped hydraulic energy isolated, guards/escape effective, or fresh hazardous motion authorized.**

Do **not** conclude that any of these events necessarily starts motion, that a safety-rated controller is bypassed, or that a selected press brake has this defect. The chain is an **INFERENCE-based diagnostic design challenge**, not a physical failure observation.

## Simple safe-to-service architecture
- **Personnel safety:** independent qualified guard/E-stop/safety logic and monitored final elements, with separate physical gravity restraint and lockable hydraulic/electrical isolation as needed. Never transfer this authority to LinuxCNC, a normal FPGA, HAL lock or remote HMI.
- **Normal control:** startup/read-only diagnostics should flag unlinked pins, missing writers, changed graph, stopped callbacks, stale process signals and mismatched approved baseline. Make faults specific enough that technicians do not bridge guards to troubleshoot.
- **Service mode:** local owner deliberately selects maintenance, follows accessible lockout/physical restraint, performs changes, compares versions and approved wiring, then requests independent safety reset. A **new local start** must be distinct from reset, rearm and remote configuration.
- **Validation:** qualified engineer separately witnesses protective input -> safety logic -> final elements -> physical load/pressure/guard condition. Record variant-specific parameters only from actual design/measurement. Never invent stop times, PL/SIL, pressure thresholds or hydraulic truth tables.

## Release status and next work
[12 blank documentary gates](4400_HAL_MUTATION_01_TWELVE_GATE_NO_ENERGY_CONFIG_REVIEW_2026-10-26.md) **NOT RUN**; [independent fresh evaluator](../evaluation/4400_HAL_MUTATION_01_INDEPENDENT_UNSEEN_TOPOLOGY_TRANSFER_HANDOFF_2026-10-26.md) **PREPARED/NOT RUN**. OpenPressBrake G0/G1 **HOLD**, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No energized or personnel-exposed test authorized. If safe minimum is unmet, do not operate with people exposed; any separately authorized experiment must be remote/isolated with everyone outside the hazard zone and residual risk documented.
