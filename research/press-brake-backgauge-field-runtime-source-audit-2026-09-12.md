# 3600 Press-Brake Research — Real Backgauge Auto-Cycle Runtime Source Audit

Date: 2026-09-12
Status: SOURCE-CONFIRMED bounded field-implementation audit; external project's physical-use claims remain COMMUNITY/PROJECT-REPORTED

## Why this source matters

The current 3600 checkpoint deliberately stopped adding synthetic ownership fixtures and asked for real implementation evidence. A new public source became available during the bounded search:

- repository: `aleadvea/press-brake-cnc-upgrade`
- pinned commit: `95cf12f639b036f80541b00128e0a31c5dcc9050` (2026-05-09)
- project scope: dual-ESP32 press-brake backgauge controller with HMI, programs, homing, bend-sensor-driven auto sequencing, retract handling and alarms.
- project README reports a working prototype tested on real hardware. Treat that physical-use statement as project-reported rather than independent verification.

This is not LinuxCNC and is not a model to copy blindly. It is useful because it exposes a real operator-program/runtime implementation at source level, letting the curriculum test its existing ownership/recovery contracts against field-oriented code.

## Source inventory

| Path | Symbols / structures | Why it matters |
|---|---|---|
| `motor_test/src/ui_auto.cpp` | `AutoState`, `go_to_step`, `auto_timer_cb`, `start_cb`, `stop_cb` | operator program state machine and row advance |
| `motor_test/src/data_model.h` | `Program`, `ProgramStep`, `Material`, `MachineState` | persistent recipe vs runtime state |
| `motor_test/src/espnow_hmi.h/.cpp` | `CmdPacket`, `StatusPacket`, send/receive functions | command/status protocol and observability |
| `motor_brain/src/espnow_motor.cpp` | `on_recv`, `espnow_motor_send_status` | command dispatch and status producer |
| `motor_brain/src/motor_ctrl.cpp` | `motor_ctrl_move_abs`, homing/alarm/retract logic, `motor_get_position_mm` | low-level authority and recovery |
| `motor_brain/lib/StepperRMT/StepperRMT.*` | `_pos`, `getPosition`, pulse-batch position update | meaning of reported position |
| `motor_brain/src/main.cpp` | `status_task` | periodic sensor/alarm/status execution |

## Data model

`ProgramStep` contains one value: `position_mm`. `Program` is a name, material index, step count and an array of those positions. Material contributes a global `offset_mm`, and `go_to_step()` forms the runtime target as:

`target = ProgramStep.position_mm + Material.offset_mm`

This is a useful real-world example of a compact recipe model, but it does not carry the richer provenance established by the curriculum's `ImportedPart -> BendFeature -> BendStep -> GaugePlan -> TargetCalculation -> TargetSet -> ExecutionEpisode` chain. In particular, it contains no source revision, bend identity, target generation, datum/tooling provenance or runtime command-episode identifier.

## Operator auto-cycle call flow

Pinned source reconstructs this HMI-side flow:

1. `start_cb()` rejects AUTO start if `g_machine.is_homed == false`.
2. AUTO takes retract ownership from the motor-side automatic retract feature.
3. `go_to_step(0)` chooses the first recipe row, calculates target + material offset, calls `espnow_hmi_send_move_abs()`, records `s_target_pos_mm`, and enters `AS_MOVING`.
4. HMI serializes a `CmdPacket { cmd, value_mm, speed_mmps }` and calls `esp_now_send()`.
5. Motor `on_recv()` dispatches `CMD_MOVE_ABS` directly to `motor_ctrl_move_abs()`.
6. `motor_ctrl_move_abs()` applies homed soft-limit clamping and optional overshoot/final-approach shaping, then queues step pulses.
7. Motor `status_task()` executes limit/alarm/bend processing and sends `StatusPacket { position_mm, motor_state, is_homed, alarm_code, bend_sensor }` periodically.
8. HMI receive callback overwrites `g_machine` fields from the latest received packet.
9. `auto_timer_cb()` watches HMI-cached state and advances `AS_MOVING -> AS_WAIT_BEND -> AS_RETRACTING -> AS_PAUSE -> next row`.
10. At end of the row list, the implementation increments the part count and automatically starts row 1 again.

The architecture cleanly separates the HMI program state machine from pulse generation, but the protocol does not carry command IDs, acknowledgements, generations or status freshness.

## SOURCE-CONFIRMED findings

### F1 — command acceptance is not tied to an episode/generation

`CmdPacket` carries only command type, position/delta and speed. `StatusPacket` carries only position, state, homed, alarm and bend sensor. There is no command sequence, target generation, execution-episode ID, command acknowledgement or completed-target identity.

Consequence: a later IDLE/status observation cannot prove which MOVE command it belongs to. This independently supports the curriculum's earlier requirement for application-owned command/target episode identity when completion has safety/reliability consequences.

### F2 — `AS_MOVING` has a target-distance check only for the "never saw movement" case

The state machine has two completion branches:

- if no movement was observed and motor is IDLE, it requires `abs(position-target) <= 0.02 mm` before moving to `AS_WAIT_BEND`;
- after any non-IDLE state has been observed (`s_move_started == true`), the later transition back to IDLE advances to `AS_WAIT_BEND` **without rechecking target error**.

Therefore `moving -> idle` is treated as completion after motion begins, even though the state packet itself does not identify why motion stopped or which target completed. An alarm is checked separately, but non-alarm early termination is not discriminated by final target error.

This is a concrete field-source example of why "motion stopped" and "target completed" must remain separate predicates.

### F3 — reported `position_mm` is generated-step position, not independently measured physical feedback

`motor_get_position_mm()` returns `stepper.getPosition()/steps_per_mm`. `StepperRMT::getPosition()` reads its internal atomic `_pos`; the implementation increments `_pos` after emitting RMT pulse batches. The motor controller does not ingest an encoder feedback channel.

The README identifies a closed-loop stepper motor/drive, but the inspected MCU status protocol does not receive that drive's actual encoder position. Thus the HMI `position_mm` is the controller's generated-step position estimate, not independent physical position verification.

Consequence: even the 0.02 mm target-distance test cannot, by itself, prove physical gauge location after lost motion, mechanical slip or an unobserved drive-side condition.

### F4 — status has no explicit freshness/generation witness

Motor status is periodically transmitted and the HMI callback simply overwrites `g_machine`. The inspected protocol/state model contains no status sequence, source boot ID, receive timestamp, timeout/stale bit or freshness predicate used by `ui_auto.cpp`.

If status delivery stops, the HMI AUTO logic can continue evaluating the last cached `motor_state`, `position_mm`, `is_homed` and `bend_sensor` values. This does not prove that a harmful transition necessarily occurs in every packet-loss timing case, but the source provides no explicit stale-data rejection mechanism.

### F5 — bend edge is the row-advance process event; retract completion is not independently qualified

`AS_WAIT_BEND` detects a rising bend-sensor edge and commands a retract, then enters `AS_RETRACTING`. `AS_RETRACTING` advances to the pause state when the bend signal falls. It does not require a retract target-error predicate, command completion identity or explicit motor-IDLE qualification before starting the pause timer. After the pause expires, `go_to_step(next)` may issue the next target.

This is another concrete example of two physical/process events being collapsed: bend-end and retract-complete are not independently witnessed.

### F6 — alarm handling is state-dependent

`AS_MOVING` and `AS_WAIT_BEND` explicitly stop AUTO progression on `MSTATE_ALARM`. The shown `AS_RETRACTING` and `AS_PAUSE` branches do not perform the same explicit alarm check before their own transition logic.

A motor-side alarm stops pulse generation and is reported, but the HMI state machine's recovery semantics are not uniformly centralized across every AUTO state.

### F7 — different alarm causes intentionally differ in homing recovery

`motor_ctrl_clear_alarm()` keeps homing valid for the overtravel case and explicitly resets the logical position to the configured home location; other alarms clear `s_homed` and require homing again. This is a useful field example of cause-specific recovery rather than one universal reset path.

The correctness of retaining reference after this particular overtravel mechanism is machine/implementation-specific and must not be generalized to LinuxCNC or another brake.

### F8 — STOP is ordinary software motion handling, not the hardware emergency-stop boundary

The HMI `STOP` command calls `motor_ctrl_stop()`, which requests a ramped `softStop()`. Separately, the project documentation says the emergency stop is hardware-wired directly to driver enable independent of firmware.

This supports the curriculum boundary: operator/software Stop, fault recovery and the external safety function are distinct authorities.

## Call-flow/ownership comparison with current 3600 contracts

| Concern | Field implementation | Curriculum contract implication |
|---|---|---|
| Program row identity | HMI `s_step` only | keep row/BendStep identity explicit |
| Runtime target | position + material offset | keep TargetSet generation/provenance explicit |
| Command identity | none in packet | fresh ExecutionEpisode/command ID remains justified |
| Command completion | IDLE after movement; no final error recheck in normal branch | completion must bind target + episode + validity + feedback |
| Position witness | generated pulse count | distinguish command estimate from measured physical feedback |
| Status freshness | no explicit timeout/sequence | stale/fresh status must be explicit |
| Process event | bend sensor edges | process-phase identity must not imply motion completion |
| Retract completion | bend end + timer, no independent target qualification | retract authority/completion needs its own witness |
| Alarm recovery | cause-specific homing behavior | preserve fault cause and recovery prerequisites |
| Safety stop | hardware E-stop separate from HMI STOP | ordinary control is not the safety function |

## Adversarial source review

The following assertions were checked directly against pinned source rather than inferred from README prose:

1. **Does AUTO require homing before START?** PASS — yes, `start_cb()` gates on `g_machine.is_homed`.
2. **Does every moving-to-wait transition prove final target error?** FAIL premise — no; only the never-moved branch performs the 0.02 mm check.
3. **Does status identify which MOVE completed?** FAIL premise — no command/generation ID exists.
4. **Is `position_mm` actual encoder feedback?** FAIL premise — it derives from emitted step count.
5. **Is cached status invalidated on communication loss?** FAIL premise — no explicit freshness field/timeout found in the inspected path.
6. **Does bend end prove retract complete?** FAIL premise — source treats bend end as the transition out of `AS_RETRACTING` without independent retract completion qualification.
7. **Is alarm handling identical in every AUTO state?** FAIL premise — explicit alarm gates appear in MOVING and WAIT_BEND, not in the shown RETRACTING/PAUSE transition logic.
8. **Is UI STOP the safety E-stop?** FAIL premise — README explicitly separates hardware emergency stop from firmware/UI actions.

Result: **8/8 source questions resolved**. The purpose is not to grade the external project; it is to test whether the curriculum's abstractions survive contact with real field-oriented source. They do, and several previously synthetic-looking requirements are now independently motivated by concrete implementation failure surfaces.

## Corrections / changes to current 3600 understanding

No reversal of the existing PB-BG contracts is required. One refinement is warranted:

> The runtime completion predicate should distinguish at least **controller command completion**, **target-error qualification**, **physical feedback validity/freshness**, and **process-phase events**. A controller-generated position estimate must not silently stand in for independent physical feedback.

The operator-program branch is no longer SOURCE UNAVAILABLE in the broad sense: we now have inspectable public field-oriented source for row persistence/advance, homing gate, software Stop, bend-triggered retract and alarm handling. However, this implementation is not LinuxCNC and does not resolve LinuxCNC-specific Task/UI integration or machine-specific backgauge datums.

## Evidence classification

- SOURCE-CONFIRMED: packet contents, HMI state transitions, command dispatch, generated-step position, homing/alarm semantics, software Stop behavior at pinned commit.
- COMMUNITY/PROJECT-REPORTED: prototype tested on real hardware; claimed reliability/industrial behavior.
- UNKNOWN: actual packet-loss field behavior, closed-loop drive's internal reaction, mechanical accuracy under lost steps/slip, machine-specific overtravel/reference validity, and whether later unpublished revisions changed these behaviors.

## Information-gain decision

This source **does** satisfy the checkpoint's exception for genuinely new implementation evidence. It does not justify another synthetic laboratory fixture. The important information came from tracing a real implementation and comparing its failure surfaces to the frozen ownership contracts.

## Next work

1. Re-check the information-separated F02 evaluator first.
2. Preserve this field-source audit as a real implementation case in the eventual 3600 integration playbook.
3. If F02 remains blocked, further 3600 work should again require genuinely new source. Highest-value unresolved sources remain:
   - tandem Y1/Y2 correction/saturation/fault ordering;
   - active sensor-bending acquisition/correction/recovery;
   - tooling/datum-aware flange-to-backgauge target solver or measured-coupon fitting/table generation.
4. Do not weaken the existing ExecutionEpisode/TargetSet/freshness contracts merely because a working prototype omits them; instead treat the omission as a concrete diagnostic/reliability surface.

No curriculum laboratory compute was consumed in this pass.
