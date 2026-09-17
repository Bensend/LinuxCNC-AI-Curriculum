# Professional Safe-Motion Vertical-Load Brake Proof Trace

Date: 2026-09-17
Lane: independent safety curriculum lane B
Scope: manufacturer-evidence trace for servo/safe-motion machinery where a vertical or externally loaded axis can move after motor torque is removed. This is not an OpenPressBrake design specification and does not assign machine-specific stopping, brake, load, PL/SIL, timing, or test values.

## Provenance labels

- `DOC-CONFIRMED` — stated by cited manufacturer documentation.
- `SOURCE-CONFIRMED` — stated by an authoritative non-manufacturer source.
- `TEST-CONFIRMED` — established by a documented physical test of the actual machine; none is claimed here.
- `COMMUNITY-REPORTED` — community observation; none is used as design proof here.
- `INFERENCE` — engineering conclusion drawn from labeled evidence.
- `UNKNOWN` — not established by the inspected evidence.

## 1. Why this branch is independent

The immediately preceding primary safety work traces TRUMPF/SICK BendGuard physical protective-device validation on a hydraulic press brake. Existing cross-machine safe-motion work already establishes the broad distinction among normal CNC inhibition, safety-rated motion monitoring, STO, maintenance isolation, and mechanical/gravity retention.

This trace goes deeper on a different unresolved proof problem: **when a safe drive function removes torque from a gravity/external-force axis, what evidence establishes that the load is actually retained?** It concentrates on the brake/vertical-load chain and the distinction between drive safety status and physical load retention.

## 2. STO removes torque authority; it does not inherently retain a gravity load

### Schneider Lexium 32M

`DOC-CONFIRMED` — Schneider Electric's Lexium 32M user guide states that triggering STO immediately disables the power stage. For vertical axes or external forces, additional measures may be necessary to bring the load to and keep it at standstill. Where suspension of a hanging/pulling load is a safety objective, Schneider calls for an appropriate external brake as the safety-related measure and explicitly says not to use the internal holding brake as the safety-related measure.

`INFERENCE` — therefore these are separate claims:

1. drive cannot intentionally produce motor torque via the normal power stage;
2. axis has stopped;
3. gravity/external-force load is physically retained;
4. retained load will remain retained for the required exposure period;
5. machine is isolated for hands-on servicing.

A drive reporting `STO ACTIVE` can support claim 1 within its validated architecture. It does not by itself prove claims 2–5.

## 3. Controlled stop, torque removal, brake control and brake proof are distinct functions

### Siemens SINAMICS S120 Safety Integrated

`DOC-CONFIRMED` — Siemens documents multiple separate drive-integrated safety functions, including STO, SS1, SBC and SBT.

`DOC-CONFIRMED` — Siemens describes SS1 as braking an enabled motor and subsequently reaching STO; its extended implementation can monitor the braking process using Safe Brake Ramp or Safe Acceleration Monitor. This is materially different from immediately removing torque.

`DOC-CONFIRMED` — Siemens describes Safe Brake Control (SBC) as two-channel control of a holding brake and states that SBC is executed when STO is selected. Siemens also documents electrical diagnostics in the brake-control path, such as detection of short circuit or wire break under stated conditions.

`DOC-CONFIRMED` — Siemens separately provides Safe Brake Test (SBT), which applies a defined test torque/force against a closed brake and evaluates permitted position deviation over a configured test duration. SBT has explicit preconditions, including standstill/safe axis position and an encoder-based configuration in the cited implementation.

`INFERENCE` — this separation is extremely useful for curriculum architecture:

`SAFE STOP COMMAND/MONITORING != STO != SAFE BRAKE CONTROL != BRAKE HOLDING-CAPABILITY PROOF`

Electrical proof that a brake coil/control path changed state is not the same as proof that the friction/mechanical brake can hold the hazardous load. Conversely, a successful brake test does not prove mains isolation or eliminate every other stored/mechanical energy hazard.

## 4. Safe Brake Test is a physical-capability challenge, not merely a status-bit check

`DOC-CONFIRMED` — the SINAMICS S120 SBT sequence can test an internal motor holding brake or an external brake, with configured holding torque/force, test torque/force factor, permitted position deviation and test duration. The drive records SBT state and actual/test torque or force information.

`INFERENCE` — the important transferable pattern is:

`known safe test state -> close brake -> deliberately apply bounded challenge -> observe physical axis response -> compare against machine-specific acceptance basis -> record result -> restore normal state`

The curriculum must not copy Siemens parameter values into another machine. The value is the proof architecture: challenge the credited mechanical retention function instead of assuming that commanded brake engagement equals adequate holding capability.

## 5. Acceptance testing is not a source of universal worst-case stopping numbers

`DOC-CONFIRMED` — Siemens requires a new acceptance test after changes to accepted safety functions and requires an acceptance report. Siemens also warns that measured acceptance-test distances/times and observed responses are typical values representing machine behavior at the time of measurement; they are not worst-case values and cannot be used to derive maximum overtravel values.

`INFERENCE` — this is a critical evidence-discipline rule for OpenPressBrake and the broader curriculum:

> A measured successful stop is evidence about the tested machine/configuration/condition. It is not permission to promote that single observation into a universal or worst-case safety distance.

Where stopping distance/time matters to protective-device placement or access, the real machine design must establish the applicable worst-case basis using the relevant standard/manufacturer/risk-assessment method and validated machine data.

## 6. Vertical-axis failure paths that status-only validation can miss

### A. STO succeeds; load falls or creeps

Drive torque removal works, but gravity/external force remains. Investigate the credited load-retention mechanism, brake sizing/application, mechanical transmission, brake release/engage sequence, and any redundant restraint required by the machine risk assessment.

### B. Brake command succeeds; brake cannot hold required load

Electrical brake control and diagnostics can appear healthy while friction surfaces, mechanical wear, contamination, adjustment, linkage, spring force, or another physical condition reduces holding capability. A physical brake challenge is stronger evidence for the holding claim than coil/status observation alone.

### C. Brake holds in one tested condition but not another

A test at one load/position/temperature/direction is not automatically worst-case evidence. Define machine-specific challenge conditions from actual design/risk evidence; keep them `UNKNOWN` until established.

### D. Controlled stop depends on normal-control behavior that is not safety-rated

If SS1 or another credited safety function relies on a particular safe-drive implementation, do not silently substitute an ordinary LinuxCNC deceleration command, HAL ramp, FPGA state machine or non-safety drive command and call it equivalent. Ordinary control may participate in production stopping but cannot inherit personnel-safety authority by naming convention.

### E. Brake test creates hazardous motion or stale-command risk

A brake proof deliberately applies force/torque. Its preconditions, exclusion zone, safe axis position, command ownership, abort behavior and restoration/rearm path must therefore be controlled. After the test, stale LinuxCNC/HAL/FPGA commands must not be allowed to cause unexpected motion merely because safety test mode ends.

### F. Successful brake proof is mistaken for servicing isolation

A mechanically held vertical load may still have electrical, hydraulic, pneumatic, gravitational or other stored-energy hazards. Brake proof and energy isolation remain separate claims.

## 7. Commissioning / periodic-proof worksheet

For any machine that credits a brake or restraint against a gravity/external-force hazard, establish these fields from the actual installed design and applicable documentation:

| Field | Required evidence | State in generic curriculum |
|---|---|---|
| Hazardous load / direction | machine drawing + physical inspection | `UNKNOWN` |
| Credited retention device(s) | machine safety architecture + installed identity | `UNKNOWN` |
| Normal brake command path | wiring/configuration trace | `UNKNOWN` |
| Safety brake-control path | manufacturer + machine safety design | `UNKNOWN` |
| Brake feedback/diagnostics | wiring + manufacturer limits | `UNKNOWN` |
| Physical holding-capability test method | OEM/device/risk-derived procedure | `UNKNOWN` |
| Test load/torque/force | machine-specific engineering basis | `UNKNOWN` |
| Permitted movement | machine-specific acceptance basis | `UNKNOWN` |
| Test duration | machine-specific acceptance basis | `UNKNOWN` |
| Test position/direction/condition | machine-specific worst-case basis | `UNKNOWN` |
| Test interval/change triggers | OEM/risk/standard basis | `UNKNOWN` |
| Failure disposition | documented return-to-service rule | `UNKNOWN` |
| Post-test restoration/rearm | validated state transition | `UNKNOWN` |

Do not fill these fields by analogy to SINAMICS, Lexium, a press brake, or another machine.

## 8. OpenPressBrake transfer

OpenPressBrake's ordinary LinuxCNC/FPGA control may command motion, display safety state, log brake-test evidence, or inhibit normal outputs. None of those roles makes it the independent personnel-safety authority.

For a future electrically driven backgauge or other gravity/external-load axis, preserve at least these conceptual boundaries:

`normal motion command -> safety stop/motion function -> torque-producing final element -> mechanical load-retention function -> physical load result`

For the hydraulic ram, do not force-fit servo-brake terminology. The transferable lesson is evidence structure: **commanded safe state, final-element state, and physical hazardous-load retention are different claims and may require different witnesses/challenges.** Hydraulic holding/blocking/pressure-control architecture must be established from the actual machine and hydraulic design.

## 9. Sources inspected

1. Siemens, *Safety Integrated Commissioning Manual (with SINAMICS S120)*, 01/2023, A5E46305916B AF. Relevant sections: SS1; SBC; SBT; acceptance test purpose/requirements. Public PDF: https://cache.industry.siemens.com/dl/files/998/109816998/att_1128535/v1/MC_SI_commiss_man_0123_en-US.pdf
2. Schneider Electric, *Lexium 32M Servo Drive User Guide*, 09/2017, document 0198441113767. Relevant section: Holding Brake and Safety Function STO. Public PDF: https://iportal.se.com/Contents/docs/SQD-VW3M5101R200_USER%20GUIDE.PDF

## Frozen curriculum rules

> STO proves torque-producing drive energy has been safely inhibited only within the validated STO architecture; it does not inherently prove that a gravity or externally forced load is physically retained.

> Brake-command/coil diagnostics and brake holding capability are different evidence claims. Where personnel safety credits the brake, the physical holding function needs an appropriate machine-specific proof method.

> Acceptance-test measurements are evidence from the tested condition, not automatically worst-case stopping or overtravel values.

## Precise next independent branch

Trace a professional robot/automation-cell safe-motion application with **zone-specific** protective functions and final elements: guard/scanner demand -> safety logic -> affected drive STO/SS1/SLS or pneumatic/hydraulic isolation -> unaffected-zone behavior -> reset/restart. Prefer an OEM/manufacturer application guide that exposes enough of the end-to-end chain to distinguish safe-zone authority from ordinary PLC/robot-program state. If the primary lane enters robot/cell work first, rotate to pneumatic dump/monitored-valve periodic proof or hydraulic load-holding valve proof instead.