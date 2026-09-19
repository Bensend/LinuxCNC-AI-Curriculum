# Muting, Override, and Protective-Device Bypass Authority Study

Date: 2026-09-19
Lane: independent safety curriculum Lane B

## Question

What must the curriculum teach when an electro-sensitive protective device is intentionally suspended so material can pass, or when an operator uses an override to clear a failed/incomplete muting sequence?

This is deliberately independent of the primary lane's current hydraulic press-brake function/proof work.

## Evidence

### Rockwell four-sensor bidirectional muting — DOC-CONFIRMED

Rockwell GuardLogix FSBM documentation defines muting as temporary automatic disabling of a light-curtain protective function so material can pass. The muting sensors must distinguish material from personnel and operate with the light curtain in a defined sequence. Rockwell warns that sensor arrangement must prevent a person from reproducing the material sequence and entering while a hazardous condition exists; application risk assessment may require additional guarding.

The same instruction treats an invalid sequence as a fault/de-energized output condition. Its Override input is not ordinary muting: override temporarily energizes the output regardless of the protective input/fault state so material can be cleared. Rockwell requires override activation through a hold-to-run device where the operator can see the hazard/light-curtain sensing field, and limits override duration through a maximum-override timer.

Source: Rockwell Automation, *Four Sensor Bi-Directional Muting (FSBM)*, Studio 5000 Logix Designer v38 online help, accessed 2026-09-19: https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/fsbm.html

### Rockwell dual-channel mute boundary — DOC-CONFIRMED

Rockwell DCSTM documentation states the key architecture rule directly: while a safety device is muted, that device is no longer protecting the hazard, so some other protection must be in place. This prevents curriculum language from treating `MUTED` as a harmless mode bit.

Source: Rockwell Automation, *Dual Channel Input Stop with Test and Mute (DCSTM)*, Studio 5000 Logix Designer v38 online help, accessed 2026-09-19: https://www.rockwellautomation.com/en-pl/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/dcstm.html

### Pilz muting and override — DOC-CONFIRMED

Pilz describes muting as safe, automatic, temporary suspension of electro-sensitive protective equipment during operation. Dedicated sensors identify transported material; sensor arrangement must prevent personnel from activating the muting condition, and personnel entry must still cause dangerous movement to shut down.

Pilz PSEN opII documentation separately defines override as recovery from a muting error. Override may permit manual operation to remove material, but activating override must not itself initiate motion; a separate control device must initiate motion. Where the danger zone and light curtain are visible from the override location, Pilz requires hold-to-run override operation and placement that prevents entering the danger zone while that control is held.

Sources:
- Pilz, *Muting: a simple explanation*, accessed 2026-09-19: https://www.pilz.com/en-US/lexicon/muting
- Pilz, *PSEN opII4H Operating Manual*, section 19.2.7 Override, accessed 2026-09-19: https://www.pilz.com/download/open/PSEN_opII4H_Operat_Man_1003501-EN-12.pdf

### SICK override state-machine evidence — DOC-CONFIRMED

SICK Flexi Compact documentation exposes override as a constrained recovery state, not a general bypass. Override becomes possible only under defined conditions involving muting state, at least one muting sensor, interrupted protective device, and disabled enable output. It requires a valid transition at the override input and limits repeated override cycles. Once sensors and protective field return to normal, the system expects the next valid muting cycle.

Source: SICK, *Flexi Compact Operating Instructions 8026634*, override/muting section, accessed 2026-09-19: https://www.sick.com/media/docs/9/79/279/operating_instructions_8026634_en_im0096279.pdf

## Engineering conclusion

**DOC-CONFIRMED:** Professional muting implementations distinguish automatic material-qualified muting from exceptional operator override. Both are safety-side functions with constrained state transitions; neither is equivalent to an ordinary LinuxCNC/HAL `ignore_light_curtain` bit.

Freeze:

**MATERIAL PRESENT != VALID MUTING SEQUENCE != PROTECTIVE DEVICE SAFELY MUTED != OVERRIDE PERMITTED != OVERRIDE HELD != MOTION COMMAND != HAZARD SAFE != ORDINARY PRODUCTION AUTHORITY.**

Additional freeze:

**PROTECTIVE FIELD BYPASSED/MUTED => THAT PROTECTIVE DEVICE IS NOT CURRENTLY THE PROTECTION AGAINST THE HAZARD.**

The architecture must therefore identify what safety function remains effective while muting or override is active. Ordinary LinuxCNC/FPGA logic may request or display a production/material state, but personnel-safety authority for muting qualification, override permissibility, timeout/fault handling, and safe output behavior belongs in the independent safety architecture when those functions are credited for personnel protection.

## Failure-path worksheet

A commissioning/validation exercise should challenge at least these cases where applicable to the chosen professional implementation:

| Challenge | Required question / witness |
| --- | --- |
| person attempts to reproduce muting-sensor sequence | does the physical sensor arrangement and safety logic prevent personnel-qualified muting? |
| wrong sensor order or timing | does the safety output go safe / muting fault rather than silently remaining bypassed? |
| light curtain interrupted without valid muting | does the protective demand still cause the required safe reaction? |
| muting lamp/status diagnostic fails where credited | does the implementation respond according to its documented safety design? |
| material stops inside the field and muting sequence cannot finish | is ordinary production blocked and override availability constrained to the documented recovery state? |
| override control tied down or left active | do hold-to-run/transition/time constraints prevent a permanent bypass? |
| operator presses override | does override itself avoid initiating hazardous motion where the implementation requires a separate motion command? |
| operator cannot see the hazard from override location | is the implementation invalid for the documented override method or provided with another validated protection method? |
| LinuxCNC START/CYCLE remains asserted during override recovery | can stale ordinary intent become motion solely because safety-side override/recovery restores an output? It must not be assumed safe. |
| override/recovery completes | does the next state require restoration of valid protective/muting conditions before normal production authority returns? |

## Evidence labels and limits

- **DOC-CONFIRMED:** Rockwell, Pilz, and SICK distinguish muting from override and constrain these functions through sensor/state/sequence conditions.
- **DOC-CONFIRMED:** Rockwell and Pilz require the physical arrangement to prevent a person from defeating the intended material/person discrimination.
- **DOC-CONFIRMED:** Rockwell/Pilz override examples use hold-to-run behavior with hazard visibility; Pilz explicitly separates override activation from the motion-start command.
- **INFERENCE:** A LinuxCNC/OpenPressBrake retrofit should expose muting/override state diagnostically but must not make ordinary LinuxCNC/HAL the sole personnel-safety authority if muting is part of a credited safety function.
- **UNKNOWN:** Whether OpenPressBrake needs any muting function at all.
- **UNKNOWN:** Any OpenPressBrake muting sensor type, geometry, timing, direction, material profile, override location, timeout, safe-distance requirement, PL/SIL/category/DC/CCF, or permitted motion during override.
- **UNKNOWN:** Whether any specific press-brake safeguarding device permits muting/override in a given production mode. Do not transfer conveyor/palletizer examples into a press-brake design without device/OEM/risk-assessment evidence.

## Curriculum rule

Teach muting as a temporary safety-function state with explicit material/person discrimination and a bounded entry/exit state machine. Teach override as exceptional fault/recovery authority, not as a maintenance bypass and not as an ordinary production mode. A learner must identify what protection remains while the primary protective field is suspended and must trace override through the actual final element and physical hazard before calling the architecture safe.

## Next Lane-B evidence target

Find a complete professional implementation that exposes:

`normal protective field -> valid material-qualified muting sequence -> protective field interrupted while alternate protection/state remains valid -> invalid sequence fault -> production inhibited -> constrained hold-to-run override -> separate motion command -> material cleared -> protective field and muting sensors restored -> override exits -> safety-side normal state restored -> application-specific ordinary production restart`.

Prefer a manufacturer application with wiring/safety logic plus actual final-element output behavior and a deliberate invalid-sequence/override commissioning test. Do not invent OpenPressBrake applicability or numeric timing/geometry.