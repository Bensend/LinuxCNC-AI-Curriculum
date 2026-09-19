# External Device Monitoring, Contactor Feedback, and Physical-State Boundary Study

Date: 2026-09-19
Lane: independent safety curriculum Lane B

## Selection / overlap check

Current main was re-read before this write. The primary safety lane's newest durable package is `PRESS_BRAKE_OEM_STOP_TIME_MAINTENANCE_AND_INITIAL_REVALIDATION_TRACE_2026-09-19.md`, focused on OEM stop-time maintenance, hydraulic final-element replacement, physical ram/load witnessing, and machine-level revalidation. Lane B therefore selected a different evidence package: external-device monitoring (EDM), contactor feedback, welded/stuck final switching devices, reset permissives, and the boundary between electrical switching-state evidence and physical hazardous-state proof.

This study does not modify the primary lane's hydraulic/stop-time files.

## Question

What does a professional EDM/feedback loop actually prove, what faults can it inhibit, and what must remain separate from EDM when validating an OpenPressBrake/LinuxCNC safety architecture?

## Sources

1. Rockwell Automation, Guardmaster Safety Relays User Manual, publication 440R-UM013I-EN-P, July 2024. The reset/monitor input can include normally-closed contacts from external safety control relays/contactors in series with the reset signal; manual reset requires the safety inputs to be closed and the reset input to be cycled.
2. Rockwell Automation, SafeShield Safety Light Curtain Hardware User Manual, publication 442L-IN002. Its EDM description states that EDM checks whether external contactors actually de-energize after a protective-device response, using positively driven/linked N.C. feedback contacts; failure of the expected feedback prevents machine restart.
3. Rockwell Automation, MSR42 Safety Module User Manual, publication 440R-UM008. When external relays/contactors are used, their feedback contacts are monitored. The manual distinguishes a start-release check (feedback must be correct before start) from continuous EDM monitoring.
4. Pilz, PNOZ e1vp operating manual 21236-EN-08. The device includes feedback loops for monitoring external contactors and separately includes test-pulse outputs for cross-short detection.

## Evidence ledger

### DOC-CONFIRMED — EDM closes the loop around commanded switching and external switching-device feedback

Rockwell's SafeShield EDM description explicitly checks whether the external contactors de-energize when the protective device responds. Positively linked N.C. feedback contacts return the external switching-device state to the safety evaluator. If the expected de-energized feedback does not appear, restart is inhibited.

This is materially stronger than assuming `safety output OFF` means the external contactor opened.

### DOC-CONFIRMED — feedback can be part of reset/start permission

The Guardmaster relay manual shows external-device N.C. contacts in series with the reset/monitor signal. The MSR42 manual separately documents start-release and continuously monitored EDM forms. Therefore `reset request` and `external device returned to its expected state` are distinct facts even when the chosen implementation combines them in one feedback/reset circuit.

### DOC-CONFIRMED — EDM is not input wiring test-pulse diagnostics

Pilz PNOZ e1vp documents feedback loops for external contactors and, separately, test-pulse outputs for detecting cross-shorts. The curriculum must not collapse field-input diagnostics and output/final-switching-device feedback into one generic `safety diagnostics` concept.

### INFERENCE — auxiliary feedback is evidence about the monitored switching device, not universal proof of hazardous-energy removal

A correctly designed positively linked feedback contact can support detection of a contactor that failed to return to its expected de-energized state. It does not, by itself, prove that downstream motor terminals are electrically isolated, that a drive has ceased producing torque, that a hydraulic valve moved, that pressure decayed, that a gravity load is retained, or that physical motion stopped.

Those claims require their own architecture-specific witnesses.

### UNKNOWN — OpenPressBrake final-element feedback topology

The present public/project evidence reviewed in this lane does not establish which OpenPressBrake hazards will use contactors, force-guided relay feedback, drive STO feedback, hydraulic valve monitoring, or other final-element diagnostics. It also does not establish the required PL/SIL/category/DC/CCF, discrepancy timing, contactor model, reset topology, or physical stop criteria. Do not invent them.

## Durable safety freeze

**SAFETY OUTPUT OFF != EXTERNAL CONTACTOR OPENED.**

**CONTACTOR FEEDBACK OPEN/CLOSED AS EXPECTED != HAZARDOUS ENERGY PHYSICALLY REMOVED.**

**EDM HEALTHY != DRIVE TORQUE ABSENT != HYDRAULIC PRESSURE SAFE != RAM PHYSICALLY STOPPED/RETAINED != PERSONNEL SAFE.**

**RESET REQUESTED != EDM SATISFIED != SAFETY REARMED != ORDINARY PRODUCTION START AUTHORIZED.**

**INPUT TEST-PULSE DIAGNOSTICS != OUTPUT/FINAL-DEVICE EDM.**

## Practical architecture for the curriculum

Teach each safety function as a chain with distinct witnesses:

`protective demand -> independent safety evaluator -> safety output command -> external final switching device -> EDM/feedback state -> physical hazardous-energy/motion witness -> reset/rearm policy -> fresh ordinary START`.

LinuxCNC/HAL and the ordinary FPGA may display EDM state, contactor diagnostics, or maintenance messages. They must not be treated as the personnel-safety authority merely because they can observe those signals. The independent safety function decides whether its monitored conditions permit rearm; ordinary control receives only the authority it is intentionally given afterward.

## Question-driven commissioning / failure-path plan

Do not perform destructive fault injection on energized machinery. Use the machine/OEM-approved commissioning method and safe isolation as appropriate.

1. Establish the documented normal protective demand and identify the safety output plus every external switching device in that function.
2. Verify the evaluator's expected EDM state before energization and after a normal safety demand.
3. Challenge a documented stuck/welded-contact simulation or approved feedback fault so the safety output command can no longer be mistaken for proof that the external device changed state.
4. Confirm that reset/restart is inhibited when the expected external-device feedback is absent or inconsistent.
5. Where two external devices are used, verify that the validation method can reveal disagreement rather than accepting one aggregate `power off` indication as proof of both devices.
6. Verify that restoring feedback alone does not create automatic hazardous restart. A fresh ordinary LinuxCNC START/CYCLE/JOG command must remain separate where the application requires it.
7. Verify the physical hazardous-state witness appropriate to the machine function independently of EDM: e.g. measured stop/standstill, electrical isolation where service isolation is claimed, or authoritative hydraulic/mechanical witness where those hazards are involved.
8. After replacement of a contactor/relay or feedback wiring, re-prove the affected safety function rather than accepting correct terminal state or PLC/HAL indication alone.

## Common commissioning traps

- Treating `safety relay output OFF` as proof the external contactor opened.
- Using an ordinary auxiliary contact without confirming that the safety design relies on an appropriate mechanically linked/positively guided feedback arrangement.
- Hiding multiple final devices behind one undifferentiated HMI `EDM OK` indication and losing which device failed.
- Allowing LinuxCNC reset or a GUI acknowledgement to bypass the independent feedback/rearm requirement.
- Treating EDM as lockout/tagout or service isolation.
- Treating contactor feedback as proof that a hydraulic or gravity hazard is physically safe.
- Replacing a final device and checking only that the machine runs, rather than re-proving both demand-to-safe-state behavior and restart inhibition.

## Evidence provenance labels

- SOURCE-CONFIRMED: source identity/publication metadata as listed above.
- DOC-CONFIRMED: EDM behavior, feedback-loop use, start/reset monitoring, and separation from test-pulse diagnostics described by the cited manufacturer manuals.
- TEST-CONFIRMED: none in this study.
- COMMUNITY-REPORTED: none relied upon.
- INFERENCE: architecture conclusions that separate monitored switching state from physical hazardous-state proof.
- UNKNOWN: all OpenPressBrake-specific device choices, performance levels, timings, hydraulic/electrical physical behavior, and acceptance thresholds requiring machine-specific evidence or measurement.

## Compute decision

No simulation, synthesis, benchmark, or executable verification is needed to establish this documentation boundary. No GitHub-hosted compute was used. If a future concrete executable question is justified, it must target the repository's self-hosted runner labeled `[self-hosted, openpressbrake]` only.

## Precise next Lane-B checkpoint

Find a complete professional machine implementation that exposes:

`protective device -> independent safety evaluator -> two external final switching devices -> individual/appropriate feedback -> deliberate one-device stuck/welded fault -> restart inhibited -> physical hazardous-state witness -> repair/replacement -> feedback re-proof -> physical function re-proof -> safety rearm -> fresh ordinary START`.

Prefer an OEM or manufacturer example that shows both the electrical schematic and commissioning/fault procedure. Keep this independent from the primary lane's press-brake hydraulic stop-time/replacement evidence package.