# 4400 — LinuxCNC internal E-stop reset is a userspace/NML state request, not a safety relay
**2026-10-24 | SOURCE-CONFIRMED at pinned LinuxCNC commit `062dc7c097693bb68e76192516cd92878dd5ecdf` | NO EXECUTION / NO PHYSICAL VALIDATION**

## Question and source revision
What does a rising edge on `halui.estop.reset` actually do, how does it differ from `halui.machine.on`, and what happens to `iocontrol.0.user-enable-out`? This is **normal LinuxCNC control**, not a personnel-safety function.

Pinned upstream source paths, exact commit:
- `src/emc/usr_intf/halui.cc`, blob `c40e2831e737b3ff8bc4a8b9e750092b5a951379`, lines 56–61, 663–665, 766–795, 1374–1382, 1426–1455.
- `src/emc/task/emctaskmain.cc`, blob `72afc74b7bb5ea626a5d328543ef48ec0b9fcae0`, lines 2257–2260.
- `src/emc/task/emctask.cc`, blob `6e88b3593729fcc4c7c4057852c8a44ea30d4f02`, lines 323–369 and 416–435.
- `src/emc/task/taskclass.cc`, blob `2de1c714641330d77fa5eea4dcfcdd1c82e7c2f7`, lines 107–108 and 403–424.
- Official documentation: `halui(1)` and `io(1)`, https://linuxcnc.org/docs/master/html/en/man/man1/halui.1.html and https://www.linuxcnc.org/docs/master/html/en/man/man1/io.1.html . The documentation is live master and may differ from the pinned source; do not imply exact version identity.

## Reconstructed command path (SOURCE-CONFIRMED)
```text
HAL input halui.estop.reset (halui.cc export near 664)
  -> halui.cc check_hal_changes() (1428 onward)
  -> check_bit_changed(new.estop_reset, old.estop_reset) (1453)
     - helper at 1374 returns the new value only when it changes
     - therefore a low->high edge issues a command; high->low returns 0
  -> sendEstopReset() (790–795)
  -> EMC_TASK_SET_STATE{state=ESTOP_RESET} over NML
  -> emctaskmain.cc command dispatch (2257–2260)
  -> emcTaskSetState(ESTOP_RESET) (emctask.cc 348–357)
  -> emcAuxEstopOff()
  -> Task::emcAuxEstopOff() (taskclass.cc ~413)
  -> HAL iocontrol user_enable_out=1 and user_request_enable=1
     plus emcioStatus.aux.estop=0
```

**Important detail:** `emcTaskSetState(ESTOP_RESET)` calls task/IO/spindle abort/cleanup and plan sync; **it does not call `emcTrajEnable()` in that branch**. The separate `EMC_TASK_STATE::ON` branch calls `emcTrajEnable()` (emctask.cc 342–346). The `halui.machine.on` input has its own `sendMachineOn()` NML state request (halui.cc 766–772, 1443–1445). These are different software commands, not evidence of physical safe-state or an approved operator fresh-start interlock.

**Status reporting:** `determineState()` in emctask.cc 416–435 reports ESTOP when `io.aux.estop` is set, ESTOP_RESET when trajectory is disabled and estop clear, and ON when trajectory is enabled and estop clear. This is a **normal Task state derived from software-visible IO/motion status**, not an independent physical stop/hold sensor.

**HAL I/O implementation:** `Task::emcAuxEstopOn()` in taskclass.cc 403–412 drives `user_enable_out=0` and `user_request_enable=0`; `Task::emcAuxEstopOff()` drives `user_enable_out=1` and `user_request_enable=1`. Official `io(1)` calls these **non-realtime** IO controller pins, with `emc-enable-in` expected FALSE on an external E-stop. **No safety integrity or stopping-time claim follows.**

## Fault/architecture consequence
A retrofit that directly wires `iocontrol.0.user-enable-out` to a hydraulic motion-authority contactor/valve without an **independent safety-rated boundary** could allow an ordinary software E-stop reset request to influence an energized actuator. Whether any particular machine does so is UNKNOWN. The source does **not** show that LinuxCNC automatically restarts a program on reset; that requires separate analysis and machine-specific testing. It does show why the output name 'enable' must not be mistaken for a safety-rated permission.

**COMMUNITY-REPORTED lead (not safety evidence):** the LinuxCNC forum's 2012–2013 `estop_latch` HAL example connects `iocontrol.0.user-enable-out`, `user-request-enable` and `emc-enable-in` to an external E-stop loop, https://forum.linuxcnc.org/47-hal-examples/25861-external-e-stop . This is a practical integration example, **not a validated independent safety architecture**. A 2024 2.9/2.10 forum discussion reports reset/feedback wiring differences, https://forum.linuxcnc.org/qtvcp/51205-unable-to-exit-estop-after-upgrading-to-2-10-from-2-9 ; it is an investigation lead, not a pinned version verdict.

## Evidence and limits
| Claim | Classification | Scope |
|---|---|---|
| Rising edge on halui.estop.reset sends ESTOP_RESET NML command | SOURCE-CONFIRMED | Pinned 062dc7c halui.cc |
| Task ESTOP_RESET calls emcAuxEstopOff, not emcTrajEnable | SOURCE-CONFIRMED | Pinned emctask.cc |
| Task::emcAuxEstopOff sets user_enable_out and user_request_enable high | SOURCE-CONFIRMED | Pinned taskclass.cc |
| Internal Task state and HAL status prove physical contactor/valve/ram safe | **UNKNOWN / NOT PROVEN** | Independent safety and physical evidence required |
| Behavior is identical in all LinuxCNC releases and every custom IO controller | **UNKNOWN** | Version/config-specific source review required |
| Pinned software behavior reproduced in local lab | **NOT TEST-CONFIRMED** | No lab needed for this source-level authority distinction |

## Integration with 4400-RST-01
A safe retrofit must **not** delegate personnel-safety reset, guard rearm, hydraulic load holding or final-element isolation to `halui.estop.reset`, `user-enable-out`, or ordinary FPGA/HAL logic. Use them for normal-control state and diagnostics behind a separately qualified safety architecture. Independently verify that a software reset, brownout or held command cannot initiate hazardous motion; a distinct deliberate new start and physical stop/hold proof are selected-machine requirements.

## Lab decision
The source trace resolves the narrow **which software command drives which normal HAL pin** question. No simulation, workflow or self-hosted runner job is justified. A later bounded normal-control lab could compare exact version transitions if an actual integration defect emerges, but it would not certify personnel safety. No personnel-exposed operation authorized.
