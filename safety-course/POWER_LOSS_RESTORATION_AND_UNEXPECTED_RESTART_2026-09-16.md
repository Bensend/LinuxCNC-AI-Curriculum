# Power Loss, Restoration, Cold Start, and Unexpected Restart

Date: 2026-09-16
Status: RESEARCH / professional-pattern synthesis
Scope: safety-course / 4000 safety boundary

## Learning objective

A learner must be able to distinguish loss/restoration of mains, safety-control power, ordinary controller power, communications, and actuator power, and must not assume that power restoration is equivalent to safety reset, machine start, or restored actuator authority.

## Manufacturer evidence

### Rockwell GuardLogix safety instructions

Rockwell's current DCST documentation exposes a separate **Cold Start Type** in addition to restart behavior. With manual cold start, Output 1 is not energized merely because controller power returns and input status becomes valid; required enabling/test/reset behavior must occur. Automatic cold start can energize Output 1 when valid active inputs return. Rockwell explicitly limits automatic restart to applications where it cannot create an unsafe condition or where reset is provided elsewhere in the safety circuit.

Evidence: https://www.rockwellautomation.com/en-be/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/dcst.html
Classification: DOC-CONFIRMED.

Rockwell's SS2/SOS safe-motion instructions likewise expose independent Restart Type and Cold Start Type choices. Manual restart requires a reset transition after the safety request is removed. Automatic restart is accompanied by an explicit warning that it is only appropriate when its use cannot create unsafe conditions.

Evidence: https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-00/contents-ditamap/instruction-set/drive-safety-instructions/ss2.html
Classification: DOC-CONFIRMED.

Rockwell Guardmaster safety-relay documentation distinguishes automatic/manual reset from monitored manual reset. Automatic reset is described as appropriate only when risk assessment does not require additional manual intervention, such as partial-body access or where another machine-control start action exists after safety inputs close.

Evidence: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um013_-en-p.pdf
Classification: DOC-CONFIRMED.

### Siemens STO boundary

Siemens SINAMICS Safety Integrated documentation states that STO pulse suppression safely disconnects the torque-generating energy supply so the motor cannot start accidentally, while the power unit and motor are **not electrically isolated**. This remains a critical restoration distinction: drive mains/DC-bus presence after restoration is not equivalent to torque authority, and STO is not maintenance isolation.

Evidence: https://cache.industry.siemens.com/dl/files/220/109812220/att_1109754/v1/MC_SI_commiss_man_0722_en-US.pdf
Classification: DOC-CONFIRMED.

## State-separation rule

Never collapse these into one `POWER_OK` or `RESET` state:

1. incoming mains available;
2. safety-control supply healthy;
3. safety controller initialized and diagnostics valid;
4. protective devices valid;
5. downstream final elements proven in expected state (EDM/valve/drive feedback where applicable);
6. restart interlock satisfied/reset;
7. ordinary LinuxCNC/FPGA controller booted and communications fresh;
8. normal machine enable granted;
9. separate operator start/cycle command issued;
10. actuator authority actually restored.

A transition in an earlier item must not silently manufacture the later transitions.

## Failure/restoration matrix

| Event | Personnel-safety expectation | Ordinary LinuxCNC/FPGA expectation | Physical-energy question |
|---|---|---|---|
| mains loss | safety outputs/final elements move to their designed de-energized/fault state as applicable | commands invalidated; no retained actuator command may reappear as authority | what energy remains stored: DC bus, gravity, hydraulic accumulator/pressure, rotating inertia? |
| mains return | no assumption of automatic restart; cold-start behavior is a designed safety property | boot with actuator commands inhibited and stale state invalid | which contactors/drives/pumps become electrically energized merely from supply restoration? |
| safety 24 V loss | safety authority unavailable; machine cannot rely on ordinary control as substitute | normal controller may diagnose but cannot bridge the missing safety chain | what final elements de-energize and is that state physically safe for the hazard? |
| safety 24 V return | initialization/diagnostics/restart rules must complete before safety-ready | wait for independently established safety-ready; do not self-reset it | do valves/contactors move simply from power return before proof/reset? |
| LinuxCNC PC reboot | independent safety system remains authoritative | boot disabled; invalidate previous cycle/run/enable state | safety final elements must not depend on PC software remembering the prior state |
| FPGA reboot/watchdog recovery | not a personnel-safety reset | outputs default inhibited; freshness and explicit normal rearm required | ordinary output recovery must not defeat independent safety final elements |
| network reconnect | safety state is not inferred from ordinary Ethernet recovery | old commands are stale; require fresh generation/state witness | can a cached motion/valve command be replayed? It must not regain authority merely on reconnect |
| protective device clears | clearing demand is not start | may observe clear/ready only | final elements and restart interlock still need their defined state/proof |

## Human-factors architecture

The safe recovery path should be easier than defeating it. Recommended architecture pattern for teaching/design:

- machine powers up into a clear **NOT READY / RESET REQUIRED** state when manual restart is appropriate;
- diagnostic display tells the operator *which* prerequisite is missing (E-stop released, guard open, EDM disagreement, valve feedback, safety controller fault, LinuxCNC not ready) without giving the ordinary HMI authority to bypass it;
- one deliberate, accessible reset action at the proper observation location restores safety readiness only after prerequisites are valid;
- reset does not start motion;
- a separate normal machine-enable/start action follows;
- LinuxCNC/FPGA boot and Ethernet reconnect never emulate the safety-reset edge;
- avoid nuisance reset rituals that provide no safety value, because unnecessary inconvenience encourages bypassing. Use automatic reset only where the validated architecture makes automatic restoration non-hazardous.

## OpenPressBrake consequence

The independent safety system should export status such as `safety_ready`, `restart_required`, and fault/diagnostic state for the HMI. LinuxCNC may refuse normal enable unless `safety_ready` is true. The direction of authority must remain one-way in the critical sense: ordinary LinuxCNC/FPGA recovery must not be capable of manufacturing `safety_ready` or bypassing the independent restart interlock.

A proportional-current driver watchdog recovery is therefore a **normal-control rearm**, not a safety reset. Likewise, Ethernet reconnection and fresh command generation may be necessary for operation but are insufficient to establish personnel safety.

## Adversarial checks

1. **Power fails while RUN is commanded, then returns with E-stops released.** Wrong answer: resume RUN because all inputs are healthy. Correct analysis: cold-start/restart behavior and separate normal start must be evaluated; retained RUN state cannot silently restore hazardous authority.
2. **LinuxCNC reboots while the independent safety relay remains healthy.** Wrong answer: toggle the safety reset automatically during startup. Correct analysis: LinuxCNC must regain normal state/freshness without becoming safety-reset authority.
3. **Safety 24 V returns while hydraulic pressure remains stored.** Wrong answer: power restoration created a safe zero-energy machine. Correct analysis: stored hydraulic/gravity energy is a separate physical hazard boundary.
4. **STO is active but drive mains remain present.** Wrong answer: drive is electrically isolated. Siemens explicitly says STO does not electrically isolate the power unit/motor.
5. **Guard closes after a full-body-access task.** Wrong answer: closing the guard should always automatically restart. Correct analysis: restart interlock/manual reset may be required and reset must remain distinct from normal start.

## Verification plan

For every complete machine drawing studied next, perform four restoration traces:

- mains OFF -> ON;
- safety-control supply OFF -> ON;
- ordinary CNC/controller OFF -> ON while safety remains powered;
- communication loss -> recovery.

For each, record final-element state, feedback/EDM state, reset requirement, whether a separate start is required, stored energy, and what remains energized.

Do not assign a PL/SIL, stopping distance, hydraulic safe state, or automatic-reset acceptability without machine-specific risk assessment and validated design evidence.
