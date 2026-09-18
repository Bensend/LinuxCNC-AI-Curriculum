# Safety study — muting, material flow, override, and restart authority

Date: 2026-09-18
Lane: independent safety curriculum Lane B

## Why this branch

The newest primary durable work is advancing multiperson trapped-key / blind-spot restart authority and explicitly asks next for integration with physical-hazard/final-element witness. This study intentionally does not touch that evidence package or its files. It addresses a different safeguarding problem: when an electro-sensitive protective device (ESPE), typically a light curtain, may be temporarily suspended for material flow without turning an ordinary machine-control condition into personnel-safety authority.

This is architecture study, not an OpenPressBrake design decision.

## Evidence labels

- **SOURCE-CONFIRMED** — stated by a cited manufacturer/standards-facing source.
- **DOC-CONFIRMED** — confirmed by repository curriculum/documentation.
- **TEST-CONFIRMED** — demonstrated by an executable or physical test. None in this study.
- **COMMUNITY-REPORTED** — community evidence. None relied upon here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence and explicitly marked.
- **UNKNOWN** — not established for OpenPressBrake or a specific installation.

## Architecture freeze

**PROTECTIVE FIELD CLEAR != VALID MUTING REQUEST != VALID MATERIAL SEQUENCE != MUTING ACTIVE != PERSON EXCLUDED != HAZARD SAFE.**

**MUTING ACTIVE != BYPASS/OVERRIDE AUTHORIZED.**

**OVERRIDE AUTHORIZED != NORMAL PRODUCTION AUTHORITY.**

**MUTING SEQUENCE COMPLETE != RESET COMPLETE != FRESH START/JOG/CYCLE INTENT.**

**LINUXCNC MATERIAL/CONVEYOR STATE != PERSONNEL-SAFETY MUTING AUTHORITY.**

The essential point is that muting is not a generic `ignore_light_curtain` bit. It is a safety-side, temporary, application-constrained suspension of a protective function whose validity depends on evidence that the passage corresponds to intended material flow rather than personnel access.

## Source trace 1 — Pilz: muting is temporary safety-function suspension

Source: Pilz, “Muting: a simple explanation”
https://www.pilz.com/en-US/lexicon/muting

**SOURCE-CONFIRMED:** Pilz defines muting as safe, automatic, temporary suspension of electro-sensitive protective equipment during operation so material can enter/leave a danger zone.

**SOURCE-CONFIRMED:** dedicated muting sensors are arranged so that the controller starts muting only for transported material; the sensor arrangement must prevent a person from activating the muting sensors. If a person accesses the protected area, hazardous movement is shut down.

**SOURCE-CONFIRMED:** Pilz distinguishes sequential and cross-muting sensor arrangements. Sequential muting requires a defined sensor order; cross muting requires the relevant sensors to be active together.

**SOURCE-CONFIRMED:** the illustrated four-phase sequence has the light barrier active before material arrives, suspended only while the muting condition exists, and active again after the material has passed.

**INFERENCE:** the safety claim depends on the geometry/sequence discriminating expected material from a person. A PLC/HAL boolean saying “workpiece present” is not equivalent evidence unless the safety design explicitly establishes it as part of the safety function.

## Source trace 2 — Rockwell GuardLogix: sequence, input validity, indication, and override are separate

Source: Rockwell Automation, Four Sensor Bi-Directional Muting (FSBM), Studio 5000 safety instruction documentation
https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/fsbm.html

**SOURCE-CONFIRMED:** the FSBM safety instruction temporarily disables the protective function of a light curtain for material transport and requires muting sensors plus the light curtain to follow a specific switching sequence.

**SOURCE-CONFIRMED:** direction is an explicit part of the expected material sequence.

**SOURCE-CONFIRMED:** input validity is separately represented by `Input Status`; invalid safety-I/O/derived input status is not the same thing as a valid muting sequence.

**SOURCE-CONFIRMED:** Rockwell separately exposes muting-lamp status. In this implementation, a defective/missing muting lamp prevents the light curtain protective function from being muted.

**SOURCE-CONFIRMED:** an incorrect muting sequence makes the safety output go safe and can require the sensing field/muting sensors to be cleared before processing continues.

**SOURCE-CONFIRMED:** the Override function is a distinct temporary recovery path. Rockwell states that override requires a hold-to-run device and that the operator must be able to see the hazard/light-curtain sensing field. Override is bounded by a maximum override timer.

**SOURCE-CONFIRMED:** reset clears instruction/circuit faults only after the fault condition is absent; the documentation notes that some safety applications require monitored reset transitions.

**INFERENCE:** normal muting, fault reset, and recovery override must remain separate authority states in curriculum diagrams. Collapsing them into one `LIGHT_CURTAIN_OK` signal hides exactly the failure paths a commissioning test must expose.

## Source trace 3 — Rockwell 450L: failed sequence and mute-dependent override

Source: Rockwell Automation, GuardShield 450L Safety Light Curtain User Manual, publication 450L-UM001H-EN-P (June 2024)
https://literature.rockwellautomation.com/idc/groups/literature/documents/um/450l-um001_-en-p.pdf

**SOURCE-CONFIRMED:** an error in the muting sequence does not establish a muting condition. If the protective field is then interrupted, the safety outputs switch off.

**SOURCE-CONFIRMED:** Rockwell provides Mute Dependent Override (MDO) specifically to clear material after a failed muting sequence/timing case; it is not presented as ordinary production muting.

**SOURCE-CONFIRMED:** MDO is risk-assessment dependent, uses a pushbutton or spring-loaded keyswitch located where the hazardous area is visible, and terminates when its maximum duration expires or when the protective field is no longer interrupted, whichever occurs first.

**SOURCE-CONFIRMED:** the manual requires manual reset of the muting function block in muting applications.

**INFERENCE:** a jam-recovery override should be taught as an exceptional, constrained recovery authority with explicit operator observation and termination conditions. It must not silently become a permanent bypass or production-mode shortcut.

## Source trace 4 — SICK: failed concurrence/sequence remains a fault/recovery state

Source: SICK deTec4 technical information, diagnostic data
https://www.sick.com/media/docs/7/87/987/technical_information_detec4_io_link_device_and_diagnostic_data_en_im0096987.pdf

**SOURCE-CONFIRMED:** SICK exposes an override-required diagnostic when muting-signal concurrence time is exceeded and the protective field is interrupted.

**SOURCE-CONFIRMED:** SICK also exposes override-required when the field is interrupted with only one muting signal active and therefore no valid muting condition exists.

**SOURCE-CONFIRMED:** after clearing the object, SICK directs the user to check the hazardous area for people before reset where required, and to investigate muting-sensor function/positioning.

**INFERENCE:** “material eventually got through” is not evidence that the preceding sequence was valid. Sequence faults are diagnostic evidence that should survive long enough to support fault finding rather than being normalized by ordinary LinuxCNC state.

## Hazard-boundary model

A curriculum architecture should draw these as distinct nodes:

`material approaching`
→ `muting sensors / safety inputs`
→ `input validity`
→ `direction + sequence + concurrence evaluation`
→ `valid muting state`
→ `ESPE protective function temporarily suspended`
→ `other application constraints still effective`
→ `material clears opening`
→ `muting terminates`
→ `ESPE protective function restored`

A fault/recovery branch is separate:

`invalid/stalled muting sequence`
→ `protective output safe / process stops`
→ `fault diagnosed`
→ `operator observes hazard area`
→ `bounded hold-to-run override, if the validated application permits it`
→ `material cleared`
→ `override terminates`
→ `protective function restored`
→ `manual reset/rearm as required`
→ `separate fresh ordinary production command`

LinuxCNC/HAL/ordinary FPGA may display state, request ordinary material motion, or consume a safety permissive. They must not be taught as the sole authority that decides a person is equivalent to material or that an invalid muting sequence may be ignored.

## Commissioning / failure-path worksheet

The following are questions, not assumed OpenPressBrake tests or parameters.

| Challenge | Required observation / question | Evidence state |
|---|---|---|
| Person interrupts light curtain without valid muting sequence | Does the protective function remain effective and hazardous motion receive the intended safe reaction? | application TEST required |
| One muting sensor stuck active before material arrives | Can a valid new mute be created incorrectly, or is the sequence diagnosed/rejected? | SOURCE pattern; application TEST required |
| Wrong sensor order | Is muting rejected and the protective function retained/restored? | SOURCE pattern; application TEST required |
| Material reverses direction mid-sequence | Does the safety evaluator reject or safely handle the sequence according to the validated muting type? | application TEST required |
| Material stalls in opening | Does timeout/concurrence logic leave a defined safe/recovery state rather than indefinite mute? | SOURCE pattern; application-specific values UNKNOWN |
| Light curtain breaks with only one muting signal | Does the system stop and require recovery rather than inventing a valid mute? | SOURCE-CONFIRMED pattern |
| Muting indication fails where monitored | Does the implementation refuse muting or diagnose the fault as designed? | SOURCE-CONFIRMED Rockwell pattern |
| Ordinary LinuxCNC says “material present” with no valid safety sequence | Can that ordinary state accidentally assert muting? It must not unless explicitly validated as safety authority. | INFERENCE / architecture check |
| Override input is stuck/welded | Is override bounded/hold-to-run and unable to become permanent bypass? | SOURCE pattern; application TEST required |
| Operator cannot see hazard during override | Is override prevented by design/procedure/location? | SOURCE-CONFIRMED design requirement pattern |
| Override clears material but a person remains in hazard | What personnel-clear/restart prevention exists before reset/restart? | UNKNOWN for OpenPressBrake |
| Power loss during mute | What state is restored on power return? Can stale sensor states recreate mute? | UNKNOWN; must be validated |
| Safety reset while LinuxCNC START/JOG/CYCLE remains asserted | Can stale ordinary intent become hazardous motion after safety authority returns? | must be prevented by architecture/validation |
| Muting configuration changed | What revalidation proves sensor geometry, sequence, direction and recovery behavior remain correct? | UNKNOWN for installation |

## Muting versus blanking versus bypass

Do not teach these as synonyms.

- **Muting**: temporary, automatic suspension of a protective function under defined application conditions, commonly material transfer.
- **Blanking**: a different protective-field function in which defined beams/areas may be ignored under configured conditions; exact safety implications depend on the device/application.
- **Override/bypass**: exceptional recovery/service authority that may intentionally defeat a normal protective response under additional constraints. It needs its own hazard analysis and must not be disguised as normal muting.

Only the muting architecture above is source-traced in depth here. Blanking remains a separate study if it becomes high-value.

## OpenPressBrake applicability boundary

**UNKNOWN:** whether OpenPressBrake needs muting at all.

**UNKNOWN:** whether any OpenPressBrake safeguard will be an ESPE/light curtain, whether material must pass through it automatically, what muting topology could be appropriate, sensor count/geometry, direction logic, timing/concurrence limits, muting indication, override method, or reset behavior.

**UNKNOWN:** stopping time/distance, hydraulic safe state, pressure/force, final-element behavior, PL/SIL/category/DC/CCF, or whether a press-brake type-C standard permits/restricts a proposed muting arrangement.

No value or topology in this study is an OpenPressBrake design prescription.

## Curriculum takeaways

1. Treat muting as a safety function with its own evidence chain, not a generic bypass bit.
2. Keep material recognition, sensor validity, sequence validity, mute state, protective-field state, override state, reset state, final-element state and ordinary motion command separate.
3. Challenge stuck sensors, wrong sequence, reversal, stalls, failed indication, invalid input status and power recovery during commissioning.
4. Recovery override must be separately constrained and observable; it is not production authority.
5. A successful mute does not prove personnel clear after an abnormal event. Where bodily entry is possible, personnel-clear/restart-prevention remains a separate safety problem.
6. A safety reset/rearm must not turn stale LinuxCNC/HAL motion intent into a fresh hazardous-motion command.

## Compute

No simulation, synthesis, benchmark, or executable verification was needed to answer this evidence question. No GitHub-hosted or self-hosted runner compute was consumed.

## Precise next work

Find a complete professional material-transfer implementation that exposes `material detection -> muting sensor geometry -> safety-side sequence validation -> ESPE mute -> physical final element/hazard behavior -> invalid sequence or stalled material -> bounded recovery override -> protective-function restoration -> reset/rearm -> separate ordinary production command`.

Prefer an implementation with a documented stuck-sensor, wrong-sequence, timeout, or override failure path. Keep it independent of the primary lane's multiperson trapped-key / physical-witness work. If that branch overlaps with newer primary work at the next run, rotate to another independent safeguarding gap rather than duplicating it.
