# 25E0 — Non-Brake Common-Cause Degradation and Recurrence Escalation

Date: 2026-09-22
Status: learner-facing safety-course method

## Learning objective

Recognize safety evidence that can become stale or invalid through environmental, supply, sensing, mounting, or other shared physical degradation even when no brake failure and no safety-logic change exists; then decide when repeated findings require broader engineering escalation rather than another isolated repair.

## Evidence basis

### SICK safety laser scanner contamination — DOC-CONFIRMED

SICK's S200 safety laser scanner operating instructions require regular cleaning of a contaminated optics cover, continuously measure contamination, and require a new optics-cover calibration after replacement because that calibration becomes the reference for contamination measurement. The manual also requires the machine/system to be isolated during the work.

Source: SICK, `S200 Safety Laser Scanner` operating instructions, care and maintenance, accessed 2026-09-22: https://www.sick.com/media/docs/8/58/858/operating_instructions_s200_safety_laser_scanner_en_im0018858.pdf

SICK's S300 operating instructions expose an explicit `optics cover is dirty` status and distinguish the protective field, whose interruption drives OSSDs OFF, from a warning field that must not be used for personnel protection.

Source: SICK, `S300 Safety Laser Scanner` operating instructions, accessed 2026-09-22: https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf

Engineering consequence: optical contamination is a concrete non-brake physical dependency. Cleaning can restore a device condition, but replacement/calibration requirements show why `surface looks clean` is not a universal substitute for the device-specific commissioning/proof obligation. A contamination finding can also be evidence of a recurring environmental source rather than an isolated sensor defect.

### Rockwell safety power and environmental dependencies — DOC-CONFIRMED

Rockwell's Compact GuardLogix 5380 safety documentation requires SELV/PELV-listed supplies for module power and sensor/actuator power used by local safety I/O. Rockwell's PointMax documentation states that sensor/actuator power must be connected to safety I/O modules to provide the required safety function. GuardLogix environmental specifications separately bound temperature, humidity, vibration/shock, EMC and enclosure/environment conditions.

Sources, accessed 2026-09-22:
- Rockwell Automation, `Compact GuardLogix 5380 Controller Hardware`: https://www.rockwellautomation.com/en-ca/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/guardlogix-and-compact-guardlogix-controller-syste/compact-guardlogix-5380-controller-hardware.html
- Rockwell Automation, `System Power Consideration` (PointMax): https://www.rockwellautomation.com/en-se/docs/technical/i-o/current/5034-pointmax/_online/5034-in001-ditamap/plan-the-pointmax-io-system/system-power-consideration.html
- Rockwell Automation, `ControlLogix 5590 Safety Partner Environmental Specifications`: https://www.rockwellautomation.com/en-au/docs/technical/logix5000/_online/control-logix-5590-specs-ditamap/clx5590-lsp-enviro-specs.html

Engineering consequence: a shared field-power or environmental dependency can cross multiple nominally independent input channels. Separate logic channels do not prove independence from the same supply, enclosure temperature, condensation, contamination, wiring environment, or mechanical installation.

### Pilz lifecycle inspection — DOC-CONFIRMED

Pilz states that construction/upgrades, manipulation, changed work processes, heavy use, and exceptional events can impair safeguards, and describes inspection of installation, condition, function, and overrun/safety distance.

Source: Pilz, `Inspection of safeguards`, accessed 2026-09-22: https://www.pilz.com/en-CA/services/workplace-safety/inspection-of-safeguarding-devices

Engineering consequence: recurrence is not restricted to repeated component failure. Repeated adverse conditions can indicate that use, environment, maintenance, installation, or work process is undermining the protective measure.

## Common-cause case A — contamination across protective sensing

A cell uses two electro-sensitive protective devices with separate safety input channels. Both devices are exposed to the same airborne coolant mist/dust source.

One device reports repeated contamination findings and is cleaned each time. The other remains apparently healthy.

Required reasoning:

1. Preserve each adverse observation as its own `FIND-*`; do not erase history when cleaning restores status.
2. Link the contamination source/environment as a candidate shared `DEP-*`, initially `INFERENCE` unless demonstrated.
3. Reverse `show where used` from that dependency. Do not declare every protective function failed merely because it shares the room; identify actual exposure/dependency.
4. Treat the healthy second channel's current diagnostic state as evidence about its present device state, not proof that the common environmental mechanism cannot affect it.
5. Repeated contamination after correct cleaning is an escalation signal: inspect shielding/location, enclosure/airflow/process source, maintenance/proof method, and whether the safe architecture is needlessly difficult to keep serviceable.
6. Do not invent a universal cleaning interval or contamination threshold. Use manufacturer/device/application evidence.

Freeze: **SEPARATE SAFETY INPUT CHANNELS != SEPARATE ENVIRONMENTAL DEPENDENCIES.**

## Common-cause case B — shared safety field power

Two different safety functions use separate sensors and separate safety input points but draw field-side sensor power from the same permitted supply/distribution path.

A finding shows intermittent field-power degradation. Ordinary LinuxCNC remains running and may even display both safety functions as healthy between disturbances.

Required reasoning:

1. Create a `FIND-*` for the observed supply behavior and preserve measurement conditions.
2. Reverse-trace the shared power `DEP-*` to every proposition that depends on valid powered sensing/actuation.
3. Do not claim a specific failure state for each device without its authoritative manual/wiring architecture; classify unknown device behavior `UNKNOWN`.
4. Contain personnel-exposed operation if the affected safety proposition cannot be established.
5. Correct the supply/distribution cause, then perform proposition-specific re-proof. `24 V restored` is not automatically proof of every connected safety function.

Freeze: **POWER RESTORED != ALL DEPENDENT SAFETY PROPOSITIONS REVALIDATED.**

## Recurrence / escalation method

A single finding may be an isolated correctable event. Recurrence changes the engineering question from `how do I restore this instance?` to `why does the accepted system repeatedly produce this safety-relevant finding?`

Do not use a universal count such as `three failures means redesign`. Escalation is consequence- and dependency-driven. Escalate when one or more of these is supported:

- the same `PROP-*` or `DEP-*` repeatedly becomes stale/failed;
- the same corrective action repeatedly restores function only temporarily;
- findings appear across different safety functions sharing a physical/environmental dependency;
- recurrence is becoming more frequent/severe or occurs under a repeatable operating condition;
- the proof method discovers degradation too late to support the accepted exposure assumptions;
- maintenance/cleaning/setup burden predictably encourages bypass, delayed service, test-until-pass, or concealment;
- the original root-cause hypothesis is contradicted by recurrence;
- a design/install/work-process change could remove the recurring cause rather than continually compensate for it.

Escalation review must consider four lanes separately:

| Lane | Question |
|---|---|
| design | Is margin, placement, protection, independence, or physical architecture inadequate? |
| maintenance/proof | Is the inspection/proof interval or method failing to reveal degradation in time? |
| environment/process | Is contamination, supply quality, temperature, vibration, alignment, tooling/load, or work process creating the condition? |
| human factors | Is the safeguard or maintenance process inconvenient enough that predictable defeat/delay is part of the failure mechanism? |

A repeated finding may implicate more than one lane. Preserve `UNKNOWN` where evidence does not identify the cause.

## Recurrence state rule

Link new findings to earlier `FIND-*` records. Never merge them into one latest status that destroys timing and recurrence evidence.

Recommended recurrence classes:

- `FIRST_KNOWN`
- `REPEAT_SAME_DEPENDENCY`
- `REPEAT_SAME_PROPOSITION`
- `CROSS_FUNCTION_PATTERN`
- `UNKNOWN`

The class is an indexing aid, not a root-cause conclusion.

## Adversarial exercise

A safety laser scanner is cleaned after three dirty-optics findings over several weeks. Each time its diagnostics return healthy. A second scanner on another side of the cell has never alarmed. Production wants to close the third finding as `cleaned/pass`.

A competent disposition must reject the shortcut. The learner should:

- preserve all three findings;
- verify device-specific cleaning/calibration/re-proof requirements;
- investigate whether a shared airborne/process source is causing recurrence;
- reverse-trace which protective propositions actually depend on each scanner;
- decide whether inspection/maintenance or physical placement/protection is inadequate;
- avoid declaring the second scanner failed without evidence, but avoid using its green status as proof of environmental independence;
- close only after the affected proposition has required evidence and the recurrence itself has a defensible disposition.

## Human-factors requirement

Recurring cleaning, alignment, reset, or nuisance intervention is not merely a maintenance annoyance when it creates pressure to bypass or ignore a safeguard. The design review must ask whether the safe architecture can be made easier to maintain correctly: accessible cleaning without entering danger, better physical protection/placement, clear contamination indication, practical inspection, and an obvious contained state. Do not solve usability by transferring safety authority into ordinary LinuxCNC/FPGA logic.

## Frozen distinctions

- **SEPARATE LOGIC CHANNELS != SEPARATE PHYSICAL/ENVIRONMENTAL DEPENDENCIES.**
- **DEVICE DIAGNOSTIC HEALTHY != SHARED ENVIRONMENTAL CAUSE ABSENT.**
- **CLEANED != DEVICE-SPECIFIC CALIBRATION/REPROOF COMPLETE.**
- **POWER RESTORED != ALL DEPENDENT SAFETY PROPOSITIONS REVALIDATED.**
- **RECURRENCE != ROOT CAUSE PROVED.**
- **REPEATED REPAIR SUCCESS != RECURRING DEFECT DISPOSITIONED.**
- **MAINTENANCE BURDEN THAT PREDICTABLY DRIVES BYPASS != ACCEPTABLE HUMAN FACTORS.**

## Boundary / UNKNOWN

This lesson does not assign universal contamination limits, cleaning/proof intervals, power-quality thresholds beyond cited device requirements, environmental derating, PL/SIL targets, stopping distances, or escalation counts. Machine/device-specific manuals, risk assessment, measurements, and validation remain authoritative.

## Next study

1. Connect recurrence escalation to corrective/preventive action ownership and verify that closure evidence survives shift/maintenance handoff.
2. Trace one mechanical-coupling or mounting/alignment common-cause example where apparently separate safety sensing shares a physical structure.
3. Build a learner exercise where recurring nuisance trips are a human-factors warning rather than a justification to weaken protection.
