# Protective-field blanking configuration and revalidation boundary study

Date: 2026-09-19
Lane: independent safety curriculum Lane B

## Question

When a safety light curtain or other electro-sensitive protective field uses fixed/floating/teach-in blanking, what must remain separate between configuration, indicated operating state, achieved detection capability, safety distance, validation, and ordinary machine authority?

This lane was selected only after reading the current curriculum state and the primary lane's newest durable work. The primary lane is advancing multi-zone E-stop span-of-control/restart authority. This study intentionally uses different files, evidence, and failure paths.

## Evidence

### DOC-CONFIRMED — Rockwell GuardShield Micro 400 / MSR42 blanking changes the protective field

Rockwell's MSR42 / GuardShield Micro 400 manual documents fixed, floating, and teach-in blanking. It warns that blanking can change both response time and effective resolution and that those changes must be included in the minimum-safety-distance calculation. The configuration documentation reports the resulting response time/resolution.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/safety-um001_-en-p.pdf

The same manual requires the user to test light-curtain resolution after blanking configuration and to test the protective field with the specified test rods. It also requires clear indication of blanking; where blanking-lamp monitoring is enabled, a failed/disconnected indication lamp cancels blanking and returns the controller to standard safety mode.

This is strong evidence that `configuration accepted` is not the same claim as `modified protective field physically validated`.

### DOC-CONFIRMED — Rockwell GuardShield restart interlock remains a separate function

Rockwell GuardShield documentation describes restart interlock as preventing OSSD re-energization after protective-field interruption/clearance until a deliberate reset. It separately documents blanking as modification of which beam interruptions are tolerated.

Source: https://configurator.rockwellautomation.com/api/Doc/guardshield_20857.pdf

Therefore blanking does not by itself define restart behavior, and restart interlock does not prove that the blanked field still has the intended detection capability.

### DOC-CONFIRMED — SICK restart interlock depends on whether undetected occupancy is possible

SICK S3000/S300/S200 configuration guidance requires restart interlock where a protective field can be left in the direction of the hazard or a person cannot be detected at every point in the hazard area. Automatic/time-delayed restart is restricted to cases where the field cannot be left toward the hazard and people remain detectable throughout the hazardous area.

Source: https://www.sick.com/media/content/h40/hff/9693003546654.pdf

This independently reinforces the architecture rule that a clear protective field is not necessarily proof that the hazard area is clear of people.

### DOC-CONFIRMED — SICK replacement/configuration change can require renewed acceptance

Current SICK S3000 operating instructions state that when the system plug is replaced and configuration must be transferred, acceptance by qualified safety personnel is required. The same manual exposes periodic protective-device checks separately from ordinary ready/clear indications.

Source: https://www.sick.com/media/docs/3/63/863/Operating_instructions_S3000_Safety_Laser_scanner_en_IM0011863.PDF

This is not evidence that every blanking edit on every device has an identical regulatory workflow. It is useful professional evidence that safety-sensor configuration/replacement is a commissioning/acceptance boundary, not merely a software convenience.

## Durable freezes

**BLANKING CONFIGURED != REQUIRED OBJECT/PERSON DETECTION CAPABILITY PROVED.**

**CONFIGURATION DOWNLOAD SUCCESS != PROTECTIVE FIELD PHYSICALLY VALIDATED.**

**PROTECTIVE FIELD CLEAR != HAZARD AREA PERSONNEL CLEAR** when a person can leave the sensing field or occupy an undetected area.

**BLANKING INDICATOR ON != BLANKING CONFIGURATION VALID != SAFETY DISTANCE VALID.**

**RESTART RESET ACCEPTED != PROTECTIVE FIELD VALIDATED != HAZARD AREA CLEAR != ORDINARY START AUTHORITY.**

**LINUXCNC/HMI KNOWS BLANKING STATE != LINUXCNC/HMI OWNS THE PERSONNEL-SAFETY FUNCTION.**

Blanking can alter response time and/or effective resolution. Any safety-distance conclusion that depends on those properties must use the validated configuration's actual documented/measured properties rather than a value copied from an unblanked configuration or another machine.

## Failure-path / commissioning worksheet

A question-driven validation should challenge at least these cases where applicable:

1. prove the intended fixed/floating/teach-in blanked region using the manufacturer's prescribed physical test method;
2. test the edges and transitions between blanked and non-blanked regions rather than only the center of each region;
3. verify objects/person-sized intrusions that must still be detected actually force the safety response;
4. verify an allowed blanked object does not create an unintended path around or through the protective field;
5. record the configured response time and effective resolution and re-evaluate the application-specific safety-distance calculation when either changes;
6. challenge a failed/disconnected blanking-status indication where the architecture monitors that indication and verify the documented safe reaction;
7. interrupt and clear the protective field and verify the intended restart-interlock/reset behavior independently of blanking behavior;
8. where a person can stand beyond the field, verify that field-clear alone cannot restore hazardous-motion authority;
9. power-cycle or replace/configure the protective device and verify the required configuration identity/acceptance/revalidation before production release;
10. hold or preserve an ordinary LinuxCNC START/CYCLE/JOG request through a safety trip/reset and verify return of safety authority does not silently convert stale ordinary intent into hazardous motion;
11. after maintenance that moves the sensor, reflector, mounting, guarded opening, blanked object, or relevant machine geometry, repeat the affected physical validation rather than relying on the old acceptance record.

## OpenPressBrake boundary

Whether OpenPressBrake needs blanking at all is UNKNOWN. No blanked region, light-curtain model, resolution, response time, safety distance, reset policy, mounting geometry, stopping performance, PL/SIL/category/DC/CCF, or allowed object profile is assigned here.

If a future press-brake safeguarding design uses blanking, the machine-specific configuration and physical validation must establish the actual detection capability and any resulting safety-distance implications. LinuxCNC and the ordinary FPGA may display diagnostics, mode, and permissives, but must not become the sole authority validating or bypassing the protective field.

## Evidence classification

- SOURCE-CONFIRMED: manufacturer documents linked above are primary manufacturer sources.
- DOC-CONFIRMED: blanking can alter response time/resolution; Rockwell requires post-configuration resolution/protective-field testing; restart interlock is distinct from blanking; SICK ties restart-interlock need to possible undetected occupancy and requires qualified acceptance after the cited configuration-transfer replacement case.
- TEST-CONFIRMED: none for OpenPressBrake.
- COMMUNITY-REPORTED: none relied upon.
- INFERENCE: a future OpenPressBrake blanking change should be treated as a safety validation/change-control event whose affected physical detection and distance assumptions are re-proved.
- UNKNOWN: whether OpenPressBrake requires blanking and all machine-specific physical/configuration values.

## Compute decision

No simulation, synthesis, or executable test was justified. The unresolved questions are physical safeguarding geometry, manufacturer configuration, stopping behavior, and machine validation facts. No GitHub-hosted Actions compute was used.

## Precise next-work checkpoint

Find a professional machine implementation or manufacturer validation procedure exposing `blanking/configuration change -> changed resolution/response-time record -> physical test-piece validation across the complete protective field -> safety-distance/reach reassessment -> restart-interlock/personnel-clear behavior -> failed validation prevents safety release -> correction -> renewed acceptance -> separate fresh ordinary production start`.

Prefer a real machine or current safety-device commissioning manual with explicit failed-test disposition. Do not transfer numerical response times, resolutions, distances, or blanking geometry to OpenPressBrake.