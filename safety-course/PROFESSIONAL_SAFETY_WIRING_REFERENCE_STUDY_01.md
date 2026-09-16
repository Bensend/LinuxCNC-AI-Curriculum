# Professional machine safety wiring reference study 01

Status: RESEARCH / architecture extraction
Date: 2026-09-16
Priority: complete E-stop/interlock chains and explicit hazardous-energy boundary

## Objective

Learn how professional machine safety systems are actually wired end-to-end, not merely how individual safety devices work. For every reference, trace:

`protective device -> safety logic -> final switching element -> hazardous energy/motion boundary -> feedback/EDM -> reset/restart`

Also record **what remains energized after the safety function operates**. A stopped actuator, disabled command, STO state, open contactor, and electrical/hydraulic isolation are not interchangeable claims.

This study deliberately keeps ordinary LinuxCNC/HAL/FPGA control outside personnel-safety authority unless independently justified by safety-rated evidence.

## Reference A — Pilz PNOZ X3.1: classic E-stop / safety-gate / dual-contactor pattern

Official source: Pilz, *PNOZ X3.1 Operating Manual 20133-EN-10*  
https://www.pilz.com/download/open/PNOZ_X3_1_Operating_Manual_20133-EN-10.pdf

**DOC-CONFIRMED** — Pilz publishes example wiring for E-stop and safety-gate inputs, automatic versus monitored start, and a feedback loop containing contacts from external contactors K5/K6.

**DOC-CONFIRMED** — Pilz explicitly warns that automatic start can restart the unit automatically when the safeguard is reset and says external circuit measures are required to prevent unexpected restart.

### Extracted professional pattern

1. E-stop/guard contacts are safety inputs, not ordinary PLC permission bits.
2. Safety relay evaluates the input channels.
3. Safety relay output contacts energize external final elements such as K5/K6.
4. Positively guided/mirror feedback contacts from the external final elements return through the feedback loop before restart is permitted.
5. A monitored reset/start is distinct from simply restoring the input channels.

**INFERENCE** — In a complete machine, K5/K6 must be traced on the power drawings to determine what hazardous power they actually interrupt. The safety-relay page alone is insufficient to claim motor, hydraulic, spindle, or drive power removal.

## Reference B — SICK deTec4 Prime + UE48-2OS: light curtain -> safety relay -> K1/K2

Official sources:

- SICK deTec4 Prime operating instructions: https://www.sick.com/media/docs/2/52/152/operating_instructions_detec4_prime_en_im0062152.pdf
- SICK connection diagram, deTec4 Prime to UE48-2OS: https://www.sick.com/dk/en/technicaldrawings/im0061236_ZOOM

**DOC-CONFIRMED** — SICK's application diagram uses OSSD1 and OSSD2 from the light curtain to the UE48-2OS safety relay. Reset S1 enables the relay only with a clear field and fault-free de-energized K1/K2 state. The safety relay's output contacts energize K1 and K2; interruption of the protective field switches the OSSDs off, causing K1/K2 to switch off.

**DOC-CONFIRMED** — SICK's EDM description uses positively guided normally-closed feedback contacts from K1/K2. If a contactor does not return to its de-energized state, EDM prevents restart.

**DOC-CONFIRMED** — SICK states that OSSD cross-circuits/short circuits are detected and can cause lockout in the cited configuration.

### Energy-boundary lesson

The light curtain itself does not remove machine power. It requests a safe state through its two OSSDs. The UE48 evaluates that request and switches K1/K2. **The machine power drawing must then show what K1/K2 interrupt.** That final mapping is the actual hazardous-energy boundary.

This is the pattern the curriculum must look for in complete OEM schematics: do K1/K2 remove mains to drives, control contactors, hydraulic pump motor power, valve power, or some combination?

## Reference C — Siemens SINAMICS: STO removes torque-producing authority but does NOT electrically isolate the power unit/motor

Official sources:

- Siemens, *SINAMICS Engineering Manual V6.6*: https://cache.industry.siemens.com/dl/files/185/83180185/att_1023081/v1/SINAMICS_Engineering_manual_V6.6_February_2020_external-e.pdf
- Siemens, *Safety Integrated (with SINAMICS S120), Commissioning Manual*: https://cache.industry.siemens.com/dl/files/347/109779347/att_1019635/v1/MC_SI_commiss_man_0220_en-US.pdf

**DOC-CONFIRMED** — Siemens describes STO as suppressing the power-semiconductor gating pulses so torque-generating energy is safely disconnected from the motor.

**DOC-CONFIRMED** — Siemens explicitly states that with STO active, the **power unit and motor are not electrically isolated**.

**DOC-CONFIRMED** — Siemens warns that motion can still occur after STO, for example coast-down, and identifies safety-relevant brake measures where necessary.

### Energy-boundary lesson

`STO active` must never be drawn or taught as equivalent to `mains isolated` or `safe to service electrical power terminals`.

A professional schematic study therefore needs two separate traces:

- **operational personnel-protection trace:** E-stop/interlock -> safety logic -> STO/safe-motion/final element -> hazardous torque/motion controlled;
- **maintenance isolation trace:** disconnect/isolator/contactors as applicable -> electrical energy physically isolated and verified.

For LinuxCNC machines, ordinary servo-enable or HAL output-disable is even weaker evidence than certified STO and must not be promoted into safety authority merely because it produces a similar normal-control symptom.

## Reference D — HAWE SAKB press-brake hydraulic control: power removal must include the hydraulic final elements

Official source: HAWE Hydraulik, *Control system for CNC press brakes type SAKB*, D 6335, 08-2025.  
https://productfinder.hawe.com/downloads/D6335-en.pdf

Important pages: complete-system hydraulic circuit (document p.8), valve inventory/monitoring (pp.4, 8), sequence diagram (p.16).

**DOC-CONFIRMED** — HAWE's SAKB is specifically a CNC press-brake hydraulic control. The complete-system circuit shows the pump/motor, central control block, two press cylinders and cylinder-side anti-cavitation valves as one hydraulic system.

**DOC-CONFIRMED** — The control block includes two proportional directional valves, two 2/2 directional seated/holding valves, a 4/2 directional spool valve, pressure-control/counterbalance elements, and the anti-cavitation-valve control path.

**DOC-CONFIRMED** — In the `S` monitored version, HAWE states that the two proportional directional valves, two holding valves and the 4/2 directional valve have position monitoring.

**DOC-CONFIRMED** — HAWE states the system is certified for intended press-brake use according to DIN EN 12622 and requires the specified NSV anti-cavitation valves rather than arbitrary substitutes.

### What this changes in the safety model

A press brake cannot be understood by tracing only an electrical pump contactor or only the proportional command.

The professional energy chain is at least:

`electrical supply -> pump/motor and/or servo-pump authority -> hydraulic pressure/flow -> directional + holding/safety-relevant valves -> cylinder chambers -> Y1/Y2 beam motion`

Protective-device action therefore has to be traced to the **hydraulic final state**, including which valves de-energize, what their de-energized positions do, which valve positions are monitored, whether pump power remains available, and what hydraulic/gravity energy remains after the stop.

**UNKNOWN** — The SAKB component document does not by itself provide the complete OEM machine's E-stop/light-curtain safety logic or exact safe-state truth table. Do not infer a machine-specific E-stop valve sequence from the hydraulic diagram alone.

## Cross-reference architecture extracted so far

```text
E-STOP CH1 ----\
                > safety relay / safety PLC ---- safety output A ---- final element A ----\
E-STOP CH2 ----/                                                                   |
                                                                                   +--> hazardous energy / motion boundary
GUARD / AOPD OSSD1 --\                                                             |
                      > independent safety evaluation -- safety output B ---- final element B ----/
GUARD / AOPD OSSD2 --/

final element A mirror/position feedback --\
                                         > EDM / safety feedback -> restart permission
final element B mirror/position feedback --/

ordinary LinuxCNC / PLC / FPGA:
  may receive status and request normal operation;
  is not substituted for the independent personnel-safety path.
```

This is a conceptual extraction, **not a build-ready safety schematic**. The actual final elements and required architecture depend on the machine risk assessment and validated design.

## Required questions for every complete professional-machine schematic

1. Which devices detect the demand: E-stops, guard switches, guard locks, AOPDs/light curtains, mats, two-hand controls, enabling devices?
2. Are the safety inputs one-channel or two-channel, and where are shorts/cross-faults detected?
3. What evaluates them: safety relay, configurable safety relay, safety PLC, drive-integrated safety, hydraulic safety electronics?
4. What is the reset/restart architecture? Can clearing the device itself restart hazardous motion?
5. Which physical final elements are switched?
6. **Exactly where is hazardous electrical power/torque/hydraulic or pneumatic energy interrupted or controlled?**
7. What remains energized after the safety demand?
8. How are contactors, valves, brakes, STO channels, etc. monitored?
9. Which single faults are detected before the next hazardous demand/restart?
10. What does ordinary CNC/PLC/LinuxCNC know, and what can it command without owning the safety decision?
11. What separate maintenance isolation exists beyond the operational safety function?
12. For hydraulic/gravity loads, what prevents unintended descent when electrical commands are absent?

## Home-shop maintenance emphasis

The home-shop course should not become an administrative workplace-LOTO course. The practical rules are:

1. **Before working on the machine, remove, isolate, discharge, block, restrain or otherwise control the hazards relevant to the task.**
2. **Never leave a machine unattended in an unsafe, incomplete, bypassed, partially disassembled or otherwise not-safe-to-operate state without making that condition unmistakable with OUT OF SERVICE / DO NOT OPERATE tag-out or equivalent conspicuous status.**
3. Tag-out communicates/preserves the state; it does not replace physical hazard control.

## Adversarial checks from this pass

- `The E-stop opened the safety relay, therefore all electrical power is gone.` **FALSE.** The final power elements must be traced; STO explicitly can leave the power unit and motor electrically energized.
- `The light curtain removes power.` **FALSE as a generic statement.** Its OSSDs signal a safety demand; downstream safety logic/final elements terminate the hazardous state.
- `The pump contactor is off, therefore a press-brake ram cannot move.` **UNSUPPORTED.** Stored hydraulic/gravity energy and valve state must be traced.
- `LinuxCNC drive-enable off is equivalent to STO.` **FALSE/UNSUPPORTED.** Ordinary enable inhibition is not certified STO.
- `A valve command is off, therefore the valve reached its safe position.` **UNSUPPORTED.** Position monitoring/feedback and the validated hydraulic architecture matter.

## Evidence gaps / next work

1. Locate **complete OEM machine electrical schematics** (preferably press brakes first) where E-stop/guards/light curtains can be followed through the safety controller to contactors, drive STO and hydraulic valve outputs.
2. Pair each electrical drawing with its hydraulic/pneumatic drawing so the actual energy boundary is visible.
3. Prefer OEM service manuals, manufacturer application manuals and publicly inspectable industrial machines over anonymous/redrawn internet schematics.
4. Build a comparison matrix across at least three professional machines: press brake, servo machine tool, and automated/robotic cell.
5. For press brakes, specifically trace whether a safety demand removes pump power, disables proportional valve electronics, de-energizes monitored holding/directional valves, invokes a dedicated hydraulic safety block, or combines these mechanisms.
6. Do not convert component-level examples into an OpenPressBrake design until enough complete-machine references establish the recurring professional patterns.

## Current conclusion

The strongest reusable professional pattern from this pass is not simply "dual channel E-stop." It is **dual-channel protective demand + independent safety evaluation + physical final elements + monitored return state + deliberate reset/restart**, with a separate explicit map of where hazardous energy is actually interrupted or controlled.

For a press brake, the final map must cross the electrical/hydraulic boundary. A complete safety analysis that stops at a relay contact, PLC bit, FPGA output, STO terminal, or proportional-valve command is incomplete.
