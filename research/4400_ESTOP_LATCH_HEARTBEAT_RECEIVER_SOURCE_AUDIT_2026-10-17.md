# 4400 — LinuxCNC software E-stop latch heartbeat and receiver contract (2026-10-17)

**Status:** SOURCE-CONFIRMED software behavior; external receiver, actual machine, and safety-function performance **UNKNOWN / NOT TESTED**. Public-source curriculum; not an approved machine circuit.

## Evidence and version pin

- LinuxCNC development commit `b99baf8e3904106a9feb719ab96076b6b296944e`: `src/hal/components/estop_latch.comp`, `src/hal/components/charge_pump.comp`, `docs/src/man/man1/io.1.adoc`, `configs/by_interface/parport/stepper-gantry/estop.hal`.
- LinuxCNC stable 2.9 branch at `a33293f46575c809e082e0806e79ab996f982513`: `src/hal/components/estop_latch.comp` uses the same fault/reset/watchdog branching (older HAL pin syntax). The checked file is not evidence that all 2.9 and master IO/Task transitions are identical.
- Official docs: https://www.linuxcnc.org/docview/html/man/man9/estop_latch.9.html ; https://linuxcnc.org/docs/master/html/en/man/man1/iocontrol.1.html ; https://linuxcnc.org/docs/stable/html/man/es/man9/charge_pump.9.html .
- Inspectable example: https://github.com/LinuxCNC/linuxcnc/blob/b99baf8e3904106a9feb719ab96076b6b296944e/configs/by_interface/parport/stepper-gantry/estop.hal .
- Community implementation discussion (not independent proof): https://forum.linuxcnc.org/47-hal-examples/25861-external-e-stop .

## Precise source trace

`estop_latch` initializes `ok_out=false`, `fault_out=true`, `ok_in=true`, `fault_in=false`; its private `old_reset` remembers the previous invocation's reset level. Each invocation evaluates:

1. If `ok_in && !fault_in`, a **rising** reset edge (`reset && !old_reset`) sets `ok_out=true` and `fault_out=false`.
2. While `ok_out` is true, `watchdog` toggles once per component invocation.
3. If `!ok_in || fault_in`, the component sets `ok_out=false` and `fault_out=true` **without assigning watchdog**.
4. On every invocation, including a fault, `old_reset=reset`.

**SOURCE-CONFIRMED:** A fault leaves the heartbeat at its **last bit value**, which may be HIGH or LOW; it does not force LOW. A level-sensitive receiver that interprets HIGH as permission is not equivalent to an edge/frequency-sensitive heartbeat receiver. This is a receiver-integration hazard, not a claim of a newly discovered runtime defect in the latch.

**SOURCE-CONFIRMED:** A reset held HIGH while a fault clears cannot rearm without a new LOW-to-HIGH edge, because `old_reset` is updated even during fault. A reset rising while the fault is active is likewise consumed. **UNKNOWN:** actual external safety relay reset, rearm and physical motion behavior for any selected machine.

**SOURCE-CONFIRMED:** `charge_pump.comp` differs: `enable=false` explicitly forces `out`, `out-2`, `out-4` LOW; while enabled, its outputs toggle according to the component invocation count. It remains ordinary HAL software and is not a certified safety function.

**DOC-CONFIRMED:** `iocontrol` is non-realtime and documents `emc-enable-in` as a status/input that should go FALSE on an external E-stop. The sample HAL wiring sends `estop-latch.0.ok-out` to that pin and sends `estop-latch.0.watchdog` to parallel-port outputs. This sample does not prove what an attached receiver senses or how it physically removes energy. The latch documentation says `fault-en` in one descriptive sentence, but the actual declared pin is `fault-in`; treat the former as a documentation typo, not an extra pin.

## Fault and reset truth table (source-level predictions, not physical test results)

| Case | Inputs/event | `ok_out` after call | `watchdog` after call | Reset consequence |
|---|---|---|---|---|
| Startup | defaults, no reset edge | FALSE | initialized/unchanged | Requires rising reset edge |
| Valid reset | healthy inputs, reset rises | TRUE | toggles | Software latch clears |
| Sustained healthy | healthy, no new reset | TRUE | toggles every invocation | Remains software OK |
| Fault after heartbeat HIGH | `fault_in=true` | FALSE | **holds HIGH** | New edge required after fault clears |
| Fault after heartbeat LOW | `ok_in=false` | FALSE | **holds LOW** | New edge required after fault clears |
| Reset pressed during fault | fault active, reset rises | FALSE | holds previous level | Edge consumed; release and press again after clearing fault |
| Fault clears with reset held | healthy, reset remains HIGH | FALSE | holds previous level | No new rising edge |
| Unconnected fault sources | `ok_in` defaults TRUE, `fault_in` FALSE | Can become TRUE on reset | toggles | No external fault detection is provided by these defaults |

The heartbeat toggle rate is determined by the actual HAL invocation/thread cadence, not a certified receiver acceptance range. Missing/late realtime execution, output-driver state, electrical faults, stuck-high output, receiver timing and common-cause power loss are separate questions.

## Architecture and human-factor rule

Keep four boundaries separate: **ordinary LinuxCNC/GUI/Task E-stop state**, **ordinary HAL latch/heartbeat/diagnostics**, **independent safety-related control and its verified inputs/outputs**, and **actual physical torque/pressure/energy removal or restraint**. The external safety system must not depend on a LinuxCNC software bit or a normal FPGA status bit as its sole personnel-safety authority. An E-stop button must act through the selected independently validated safety architecture, while LinuxCNC can receive status for operator indication and coordinated normal stopping.

Make recovery simple: one clearly labeled reset point with hazard-zone visibility as required by the SRS, a separate deliberate start, clear fault cause, no automatic restart after a guard clears or power returns, and fault messages that identify the physical device to inspect without encouraging bypass. For a hydraulic press brake, do not confuse motor torque removal with ram restraint, trapped-pressure relief or maintenance blocking.

## SRS / Safety Design Package handoff

- `SRS-ESTOP-HEARTBEAT`: define what independent protective function must occur on E-stop demand and on loss of heartbeat; machine-specific acceptance **UNKNOWN**.
- `PHY-HEARTBEAT`: a software heartbeat toggling proves only that the relevant code path is executing and its output is changing; it does not prove safety-chain actuation or physical standstill.
- `AUTH-HEARTBEAT`: LinuxCNC/HAL is ordinary command/diagnostics; selected safety controller/final element owns personnel-safety authority.
- `DEP-HEARTBEAT`: shared host/thread, parport/FPGA, connector, output power, receiver input, wiring and software configuration.
- `ARC-HEARTBEAT`: independently monitored E-stop channels, safety controller and selected final element; do not freeze without exact products and wiring.
- `VAL-HEARTBEAT`: verify heartbeat lost while HIGH, lost while LOW, missing thread, stuck-high wire, stuck-low wire, reset held during fault, fault clearing under held reset, power restoration, retained ordinary start, feedback-plausible/physical-motion contradiction, and physical safe-state witness. All **NOT RUN**.
- `UNK-HEARTBEAT`: selected receiver, expected frequency/window, loss-detection time, output power-up state, safety-function integrity target, hydraulic/drive final element, stopping/holding evidence.
- `HF-HEARTBEAT`: prevent an awkward fault reset or inaccessible guard from making defeat the path of least resistance.

## Experiment decision and limits

No lab is justified to re-prove the clearly inspectable C branching. A future **bounded, isolated software-only** fixture is justified only if an unresolved timing or interface contract survives exact receiver documentation; run exclusively on `[self-hosted, openpressbrake]` after confirming that runner jobs cannot touch physical I/O. Physical acceptance requires separate controlled commissioning with people outside the danger zone and actual independent energy/standstill witnesses.

**Freeze:** `WATCHDOG OUTPUT HIGH != HEARTBEAT ALIVE`; `SOFTWARE ESTOP CLEARED != INDEPENDENT SAFETY RESET`; `SAFETY RESET != FRESH MOTION START`; `MACHINE OFF INDICATED != PHYSICAL ENERGY REMOVED`.
