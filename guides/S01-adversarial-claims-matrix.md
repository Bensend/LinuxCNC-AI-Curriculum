# S01 — adversarial safety claims matrix

LinuxCNC revision context: `8bf4605ae81042248add031e94c77300406e0413` for source-derived controller behavior.

Purpose: force a fresh AI to state the **strongest valid inference** and reject attractive but unsupported safety claims.

| Observation | Valid inference | Invalid inference | Evidence needed to strengthen |
|---|---|---|---|
| `iocontrol.0.emc-enable-in = FALSE` | LinuxCNC's external E-stop input reports an E-stop condition | the physical safety circuit necessarily removed hazardous energy | external circuit architecture, device state/feedback, fault analysis, validation |
| `emcStatus->io.aux.estop = 1` | Task has sampled/reported E-stop status | every external E-stop contact/channel is healthy | independent channel/device diagnostics and validation |
| `iocontrol.0.user-enable-out = FALSE` | LinuxCNC commands its external enable interface inactive | contactor/STO/drive torque is physically off | physical output path + feedback + device behavior testing |
| `iocontrol.0.user-request-enable` pulses | software requested E-stop clear/reset | safe restart conditions are satisfied | machine-specific reset/restart interlock design and validation |
| Task state is `ESTOP` | LinuxCNC controller state is ESTOP | an emergency-stop safety function with a defined PL/SIL has operated | defined safety function, target integrity, architecture and validation evidence |
| Task state is `ESTOP_RESET` | external/software E-stop status is clear enough for LinuxCNC to be out of ESTOP while motion remains disabled | the machine is safe to restart | hazard controls, reset rules, external permissives, human/process controls |
| `motion.motion-enabled = FALSE` | realtime motion controller is disabled | zero torque / zero stored energy / stopped motion | drive/STO/brake/energy-isolation evidence and stopping-time measurement |
| `joint.N.amp-enable-out = FALSE` | LinuxCNC commands that joint amplifier path disabled | amplifier cannot produce torque | drive interface and fault/disable/STO validation |
| HostMot2 watchdog `has_bit = TRUE` | HostMot2 watchdog bite was detected/reported | safety-rated stop occurred | FPGA/board/field-output behavior plus complete safety-function evidence |
| software limit trips | LinuxCNC detected/enforced a configured software travel limit | physical hard-stop/limit protection is adequate | physical limit devices, stopping distance and machine risk analysis |
| physical limit switch HAL input changes | LinuxCNC received that switch state | switch is safety-rated/redundant/fault tolerant | device architecture, wiring diagnostics, validation and standard-specific evidence |
| STO feedback says inactive torque | the drive reports its STO-related status as defined by that drive | complete machine emergency-stop function is validated | entire safety function including inputs, logic, outputs, diagnostics, timing, reset and fault testing |
| same-servo-cycle disable observed | software controller reaction was bounded to the observed cycle in that test | physical machine stopping time is one servo period | end-to-end physical timing measurement under worst credible conditions |
| two software channels agree | two software observations agree | independence/redundancy required by safety standard exists | common-cause/independence analysis and suitable architecture |

## Misleading premises and corrections

### “It is called E-stop, therefore it is safety-rated.”

Rejected. Naming identifies machine-control semantics, not safety integrity.

### “Realtime code is deterministic, therefore it is functional safety.”

Rejected. Realtime execution properties do not establish systematic capability, diagnostic coverage, hardware fault tolerance, PL, SIL, or validated reaction time.

### “The output went false, therefore the actuator is safe.”

Rejected. A command/status boundary cannot be silently promoted into physical-state evidence.

### “A safety relay example on the forum proves my machine is compliant.”

Rejected. Community wiring practice is useful investigation context; applicability and compliance remain machine/jurisdiction/function specific.

## Adversarial scenario set

1. **GUI says ESTOP but servo drive still produces holding torque.** Correct response: LinuxCNC's software state may be functioning while the downstream physical risk-reduction path is absent, failed, or intentionally different. Do not reinterpret the GUI state as torque evidence.
2. **External E-stop input clears after the button is released and Task reaches ESTOP_RESET.** Correct response: this proves only controller status transition. Restart permission and reset behavior belong to the complete machine safety/control design.
3. **Watchdog bite and amp-enable false happen together.** Correct response: two control fault-containment observations strengthen diagnosis of controller behavior but still do not establish a safety integrity level or physical stopping performance.
4. **STO is wired independently, while LinuxCNC loses Ethernet and freezes displayed feedback.** Correct response: physical STO may still provide risk reduction, while LinuxCNC stale feedback becomes a separate diagnostic/recovery concern. Analyze the channels separately.
5. **A future LinuxCNC revision changes E-stop implementation but keeps the same HAL pin names.** Correct response: pin-name continuity does not prove source behavior continuity; re-trace the implementation and rerun bounded verification for the new revision.

## Small design-change test

If asked to “make E-stop safer” by adding a HAL latch, a fresh AI must refuse to claim that the latch upgrades the machine to a safety-rated architecture. It may explain the latch's software behavior and propose it for ordinary control-state retention/diagnostics, while separately identifying the need for machine-specific safety engineering for the physical function.

## S01 graduation implication

The claims matrix is part of the module's adversarial evidence. S01 should not graduate until a bounded independent software experiment confirms at least one representative E-stop state path and a fresh-AI handoff demonstrates that these inference boundaries are retained under a novel scenario.
