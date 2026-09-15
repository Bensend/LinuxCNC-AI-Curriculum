# 4000 Safety Reset / Restart / Rearm Contract — 2026-09-15

Status: **DOC-CONFIRMED working safety-course contract**

Purpose: keep three commonly conflated actions separate in OpenPressBrake/LinuxCNC designs and teaching: (1) resetting a safety function, (2) restarting normal machine operation, and (3) rearming ordinary FPGA/controller output authority after a non-safety fault or watchdog event.

This artifact is intentionally independent of the human-first safety-simulator work. It defines architecture and verification questions; it does not assign a machine-specific PL/SIL, stopping distance, hydraulic state, or reset location without a machine risk assessment.

## Evidence

### DOC-CONFIRMED — monitored manual reset is an edge/sequence, not a maintained permissive

Rockwell Guardmaster Safety Relays User Manual, publication 440R-UM013, defines monitored manual reset as an OFF→ON→OFF reset signal within a prescribed interval, with reset occurring on the trailing edge. It distinguishes this from automatic/manual reset, which can execute immediately when the reset input is held ON and the safety inputs become active.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um013_-en-p.pdf

Engineering consequence: a stuck, taped, shorted, or permanently asserted reset input must not be treated as equivalent to a deliberate monitored reset when the safety concept requires deliberate reset.

### DOC-CONFIRMED — reset/restart requires the safety conditions to be satisfied

Rockwell's GuardLogix Dual Channel Input Stop documentation states that its safety output can energize only when both safety inputs are active as configured and the correct reset actions have been carried out.

Source: https://www.rockwellautomation.com/en-ua/docs/studio-5000-logix-designer/37-00/contents-ditamap/instruction-set/safety-instructions/dual-channel-input-stop--dcs-.html

Engineering consequence: reset is not a bypass around an unresolved input discrepancy or active protective-device demand.

### DOC-CONFIRMED — external-device feedback can inhibit the next restart

Schneider's TeSys Island SIL Stop 0 wiring guidance describes Category 2/3 arrangements in which mirror-contact feedback is externally monitored; failure of the mirror contact to return to the expected state prevents the next restart.

Source: https://www.se.com/us/en/faqs/FAQ000258623/

Engineering consequence: where the safety design relies on contactors or other final switching elements, a reset/restart request must not erase evidence that the final element failed to reach its expected de-energized state. The exact feedback architecture remains machine/design specific.

### DOC-CONFIRMED — industrial safety products explicitly distinguish monitored reset modes

Current Rockwell Guardmaster safety-relay product data identifies devices with `Manual Monitored` reset and devices configurable for `Automatic/Manual or Manual Monitored Reset`.

Sources:
- https://www.rockwellautomation.com/en-us/products/details.440R-N23120.html
- https://www.rockwellautomation.com/en-us/products/details.440R-G23110.html

Pilz PNOZ s5 documentation separately identifies automatic/manual start, monitored start, and reset with start-up test as distinct behaviors.

Source: https://www.pilz.com/download/open/PNOZ_s5_Operat_Man_21397-EN-11.pdf

## Working architecture contract

### 1. Safety reset

A **safety reset** acknowledges a satisfied safety function after the safety-related control system has independently verified the conditions required by its validated safety design.

Working rules:
- Reset does **not** command ram motion, pump start, valve energization, backgauge motion, or cycle start.
- Reset does **not** cause an active E-stop, open guard, active light curtain, discrepant dual channel, failed final switching element, or other unresolved safety demand to become healthy by software convention.
- Where deliberate monitored reset is required, use a discrete reset action with the required transition/sequence rather than a permanently true permissive.
- LinuxCNC/HMI may display reset state and may request reset only where the validated safety architecture explicitly permits that interface; ordinary LinuxCNC/FPGA state must not become the sole authority for a personnel-safety reset.
- Exact reset-device location and whether the operator must have a view of the hazard zone are risk-assessment/standards/application questions and remain **UNKNOWN / DESIGN-SPECIFIC** here.

### 2. Restart / cycle start

A **restart** is a separate normal-control action after the safety system is already in a state that permits operation.

Working rules:
- Restoration of safety inputs alone must not be interpreted by ordinary machine logic as an instruction to resume a previously interrupted hazardous cycle unless the validated machine safety concept explicitly permits that behavior.
- Safety reset and machine cycle start should be represented as separate state transitions in teaching diagrams and simulators.
- A reset button should not double as an implicit ram-down/cycle-start command.
- Final-element feedback required by the safety design must be healthy before restart authority is restored.

### 3. Ordinary FPGA/controller output rearm

OpenPressBrake also has a separate **normal-controller rearm** after transport watchdog, stale-feedback, overcurrent, or other non-safety fault containment removes ordinary output authority.

Working rules:
- This rearm is **not a safety reset** and must never be presented as one.
- Rearm requires fresh command/feedback state and explicit recovery conditions defined by the affected block.
- Stale PWM duty, stale integrator state, stale motion command, or pre-fault actuator demand must not be replayed merely because communications return.
- Safety permission is a prerequisite to normal output authority, but normal-controller rearm cannot grant safety permission.
- A safe teaching state model is therefore at least two-dimensional: `safety_permission` from the independent safety system, and `normal_output_armed` from the ordinary controller. `normal_output_armed = true` can never substitute for `safety_permission = true`.

## Human-factors rule

Reset/restart design should make the intended safe sequence easier than bypassing it. Do not create nuisance reset behavior merely for ceremony; each required acknowledgement should correspond to a real state transition or verification purpose. Conversely, do not remove a deliberate reset because it is inconvenient when the risk assessment requires prevention of unexpected restart.

If a safeguard is routinely defeated because the reset/restart workflow obstructs normal production, treat that as an engineering problem to solve in the safeguarding/workflow design rather than as an operator-training problem alone.

## Failure-path teaching matrix

| Condition | Safety reset accepted? | Normal restart allowed? | Normal-controller rearm allowed? | Evidence class |
|---|---:|---:|---:|---|
| E-stop/protective input still demanded | No | No | May be internally prepared, but cannot create actuator authority | DOC-CONFIRMED architecture consequence |
| Dual-channel discrepancy unresolved | No | No | Cannot override safety permission | DOC-CONFIRMED architecture consequence |
| Required final-element feedback wrong | No/blocked by safety design | No | Cannot override safety permission | DOC-CONFIRMED from Schneider example; exact implementation design-specific |
| Reset input stuck asserted where monitored reset is required | No valid monitored reset event | No new restart authority from that signal | Independent | DOC-CONFIRMED reset-sequence consequence |
| Safety conditions healthy but deliberate reset not yet completed | No | No | Normal controller may be healthy but outputs remain subordinate to safety permission | DOC-CONFIRMED architecture consequence |
| Safety reset completed, cycle start not requested | Yes | No motion merely from reset | May arm only under its own recovery rules | Working contract |
| Safety healthy, FPGA watchdog stale | Safety may remain healthy | No hazardous output through stale ordinary controller | No until fresh-state/rearm contract is met | Existing 4000 watchdog contract |
| Communications return after stale-output trip | Safety state unchanged | No automatic replay of stale cycle demand | Explicit fresh-state rearm required | Existing 4000 watchdog contract |

## Simulator / curriculum acceptance tests

These are logic-level tests and do not claim physical stopping performance:

1. Hold the monitored-reset input asserted before clearing the protective demand; clearing the demand must not manufacture a fresh monitored-reset edge.
2. Clear a protective demand without reset; machine normal-start authority remains absent where deliberate reset is configured.
3. Perform a valid reset with no cycle-start request; no hazardous motion command is generated solely by reset.
4. Inject failed final-element feedback; reset/restart remains inhibited when that feedback is part of the safety design.
5. Trip only the ordinary FPGA watchdog while the independent safety system remains healthy; demonstrate that `safety_permission` and `normal_output_armed` are separate states.
6. Restore communications after watchdog trip; stale PWM/motion/current-loop state is not replayed and explicit normal-controller rearm is required.
7. Trip the independent safety function while the normal controller reports healthy/armed; physical safety authority still removes the hazardous-output permission.
8. Exercise HMI reset/restart controls and verify that UI state cannot directly forge the independent safety permission signal.

## Open questions / do not invent

- Required PL/SIL/category for any specific OpenPressBrake safety function.
- Whether a particular function may use automatic restart, manual reset, monitored reset, start-up test, or another validated sequence.
- Exact reset button location, visibility requirements, escape/restart prevention measures, and zone logic.
- Exact contactor/valve feedback architecture and diagnostic coverage.
- Physical stopping time/distance and hydraulic residual-energy behavior.

Those require the machine-specific risk assessment, applicable standards, selected safety components, and physical validation.

## Next useful independent work

Build a similarly explicit **energy-state / isolation / residual-energy contract** separating electrical power removal, hydraulic pressure/accumulator state, gravity/stored mechanical energy, normal stop, emergency stop, and verified zero-energy maintenance state. Keep it source-driven and do not infer the actual press-brake hydraulic truth table without drawings/measurements.