# Safely limited speed, setup-mode feedback, and stop authority

Date: 2026-09-19
Lane: independent safety curriculum Lane B

## Question

When access/setup work permits hazardous motion at reduced speed, what must remain independent of ordinary LinuxCNC/FPGA motion control, and what evidence is required before reduced-speed motion can be treated as a safety function rather than merely a slow command?

## Evidence

### Rockwell GuardLogix / drive-integrated SLS

**DOC-CONFIRMED.** Rockwell's Safely-Limited Speed (SLS) instruction monitors motor/axis speed from a CIP Safety drive through a Safe Feedback Interface. Exceeding the active limit is not merely an HMI warning: the safety result is intended to initiate an application-specific safety action such as SS1/SS2/STO.

**DOC-CONFIRMED.** Rockwell's SLS application technique uses a maintained key selector to request SLS. Access through a locking gate is permitted only after the SLS transition/check delay and verified speed below the configured limit. If speed exceeds the limit after the delay, SS1 is initiated and proceeds to STO at standstill. Rockwell explicitly requires the application risk assessment to determine the actual safely-limited speed; this study therefore does not transplant a numeric speed into OpenPressBrake.

Sources:
- Rockwell Automation, Studio 5000 Logix Designer, `Safely-Limited Speed (SLS)` instruction documentation.
- Rockwell Automation, `Safely-limited Speed and Safely-limited Position via a GuardLogix Controller Safety Function Application Technique`, SAFETY-AT185.

### Pilz safe-motion boundary

**DOC-CONFIRMED.** Pilz describes SLS as a defined transition from automatic operating speed to reduced setup speed. A violation of the monitored speed limit requires a safe shutdown; Pilz describes SS1 followed by removal of power-generating energy as a preferred pattern where appropriate.

**DOC-CONFIRMED.** Pilz also warns that speed limitation alone does not eliminate every hazard. Its safe-speed-range discussion gives a coupled-axis example in which an unexpected reduction in only one axis can itself create a crushing hazard. This is important for press-brake reasoning: proving each axis is below a ceiling is not automatically proof that a multi-axis physical state is safe.

Sources:
- Pilz, `Safely limited speed (SLS)` lexicon / safe-motion guidance.
- Pilz, `Safe speed range (SSR)` guidance.

### SICK independent speed-monitor architecture

**DOC-CONFIRMED.** SICK documents independent safe speed/standstill monitoring products for maintenance operation, including SLS and safe speed monitoring and architectures using two independent initiator signals or diverse signal paths. This is useful evidence that a normal motion controller's commanded velocity is not itself the safety witness.

Source: SICK, `Speed Monitor` safe motion monitoring product documentation.

## Architecture freeze

**LINUXCNC COMMANDED SLOW SPEED != SAFELY LIMITED SPEED.**

**ORDINARY ENCODER VALUE PLAUSIBLE != SAFETY FEEDBACK VALID != SLS MONITOR HEALTHY.**

**SLS REQUESTED != REDUCED SPEED REACHED != SLS ACTIVE/VALID != ACCESS/SETUP MOTION AUTHORIZED.**

**EACH AXIS BELOW ITS SPEED CEILING != MULTI-AXIS CRUSHING HAZARD CONTROLLED.**

**SLS LIMIT VIOLATION DETECTED != PHYSICAL STOP COMPLETED != STO/FINAL ELEMENT RESPONDED != HAZARD SAFE.**

**SLS HEALTHY != ENABLING DEVICE VALID != DELIBERATE JOG COMMAND PRESENT != ORDINARY PRODUCTION START AUTHORIZED.**

The personnel-safety authority must therefore remain in an independent safety path. LinuxCNC/FPGA/HMI may request setup mode, command motion and display safety status, but a normal LinuxCNC velocity command, HAL clamp, GUI slider, FPGA register, or ordinary encoder channel does not become a safety-rated SLS function merely because it makes the machine move slowly.

## Failure-path / commissioning worksheet

For any future machine-specific implementation, challenge at least these questions without inventing acceptance numbers:

1. Request reduced-speed/setup mode while the axis is still above the allowed safety envelope. Verify access or setup-motion authority is not granted merely because the mode request exists.
2. Once SLS is valid, command a deliberate speed-limit violation through an approved test method. Verify the independent safety monitor detects it and demands the documented safe response.
3. Distinguish `safety monitor demanded stop` from `drive/final element actually stopped hazardous motion`; witness the physical result required by the application.
4. Challenge loss, disagreement, stale data, scaling/configuration error, or replacement of the safety feedback path using the manufacturer's approved method. A plausible ordinary LinuxCNC encoder display must not mask invalid safety feedback.
5. For coupled axes, challenge asymmetric behavior. Do not assume `Y1 below limit AND Y2 below limit` proves beam-level/crushing risk is controlled.
6. Challenge transition back to normal/automatic mode. SLS release must not resurrect a retained LinuxCNC START/JOG/CYCLE command.
7. Challenge power cycle and safety-controller/drive restart while setup/SLS mode is selected. Do not assume the pre-power state is valid after restart.
8. Where access is allowed during SLS, separately validate the required enabling device, guard/access state, operator action, and restart/rearm behavior. SLS alone is not permission for arbitrary exposed motion.
9. After safety encoder/drive/safety-controller replacement or configuration change, require the applicable identity/configuration and functional revalidation before accepting SLS again.
10. Preserve diagnostics as diagnostics: LinuxCNC may show `SLS active`, `feedback fault`, `SS1 active`, etc., but the display is not the safety evaluator.

## OpenPressBrake unknowns

**UNKNOWN:** whether OpenPressBrake requires SLS at all; which motions could be allowed during setup/access; safe speed values; safe feedback architecture; encoder independence/diversity; transition timing; final safe-stop action; hydraulic interaction; beam-level constraints; enabling-device policy; guard state; PL/SIL/category/DC/CCF; commissioning test method; physical stopping acceptance; and revalidation triggers.

No numeric safe speed, check delay, stopping time, safety distance, hydraulic truth table, pressure threshold or performance level is assigned here.

## Evidence provenance

- `DOC-CONFIRMED`: manufacturer documentation described above.
- `SOURCE-CONFIRMED`: none newly claimed; no source-code implementation was inspected for this study.
- `TEST-CONFIRMED`: none; no machine or executable verification was performed.
- `COMMUNITY-REPORTED`: none used.
- `INFERENCE`: the OpenPressBrake architectural separation and commissioning questions derived from the documented safety-function boundaries.
- `UNKNOWN`: all machine-specific values and topology listed above.

## Compute

No simulation, synthesis, benchmark or executable test is justified by this source-tracing question. No GitHub-hosted runner was used, and no self-hosted compute was consumed.

## Precise next evidence target

Find a complete professional setup/maintenance implementation exposing:

`mode selection -> independent safety feedback -> SLS transition proof -> guard/access release where applicable -> enabling device + deliberate jog -> deliberate overspeed/fault challenge -> SS1/other documented safe response -> actual final element -> physical motion witness -> fault correction -> SLS revalidation -> safety rearm -> fresh ordinary production initiation`.

Prefer a machine-tool or hydraulic-machine example with a schematic plus commissioning/fault procedure, and preserve the distinction between safe speed feedback and ordinary LinuxCNC motion feedback.