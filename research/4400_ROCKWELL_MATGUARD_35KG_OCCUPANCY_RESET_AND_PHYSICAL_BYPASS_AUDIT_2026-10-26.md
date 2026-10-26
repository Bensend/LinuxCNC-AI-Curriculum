# 4400 MAT-PRES-01 — A clear floor sensor is not proof that the guarded space is empty

**Status:** original OEM documentary comparison, 2026-10-26; no simulation or physical test. **Scope:** Rockwell MatGuard publications 440F-UM001C-EN-P (Dec 2024) and 440F-UM003A-EN-P (Jan 2024).

## Primary manufacturer evidence
1. https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440f-um001_-en-p.pdf — PDF p.13: intended to detect **adults weighing 35 kg or more**. This is a product detection statement, not a universal threshold for all pressure mats and not an assurance of detecting a lighter person, person supported on a machine base, or load distributed outside the effective area. **DOC-CONFIRMED.**
2. Same manual pp.19–22: mat must cover all accessible floor between perimeter and hazard; fixed guarding must prevent bypass via other routes; illustrated sloping cover plate prevents standing on a machine baseplate, cable troughs should not provide a path, and reset should be placed with full visibility. **DOC-CONFIRMED.**
3. Same manual pp.25–26 and pp.51–53: manual reset requires actuation removed plus separate reset after power-up; in auto-reset, removal of actuation can restore safety outputs, and machine control needs a separate reset function to prevent unexpected machine start after stepping off or a power dip. **DOC-CONFIRMED.**
4. Same manual pp.26–27: auxiliary status output is explicitly **non-safety**; output should not be used as the safety function. **DOC-CONFIRMED.**
5. https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440f-um003_-en-p.pdf — PDF pp.20–22: when used as a secondary protected-perimeter occupancy measure, mat coverage is required across the enclosure and ordinary approach-distance calculation is not the same proof proposition. **DOC-CONFIRMED.**
6. Both manuals' stopping-time worked examples include an **assumed measured machine response** and a model-specific sensor time (35 ms). Their worked distances are **not** selected-machine measurements or a universal rule. **DOC-CONFIRMED / scope limit.**

## Four distinct propositions
- **Trip:** a person applies sufficient pressure to an active mat; safety outputs demand a protective response.
- **Presence:** the person remains on an effective sensing surface. This is not a general person detector throughout the enclosure.
- **Clear:** all active mat sensors report no actuation. This does **not** prove no person remains in an uncovered pocket, on a machine support, beyond a sensing boundary, or below the manufacturer's assured detection scope.
- **Restart:** even if all active sensors are clear, deliberate rearm and a distinct start authorization must be validated with a visible, physically safe hazard zone.

## Adversarial physical examples (INFERENCE, not manufacturer-tested here)
- A worker stands on the machine baseplate or a pipe/cable trough, stepping around a mat. Sensor reports clear even though exposure exists.
- A small person or unusual supported posture is outside the stated detection assurance. 'No actuation' does not establish absence.
- A worker enters via a door, steps across the mat and stands in an uncovered recess. Door subsequently closes and the mat becomes clear.
- After power restoration, auto-reset recovers mat outputs; if downstream normal-control logic treats this as permission to resume a latched motion request, unexpected restart is possible. Actual response depends on wiring/logic and must be assessed, not assumed.
- Grease, swarf and a protruding trim edge make the safe walkway difficult; workers seek an alternate route. The friction is an engineering defect, not a reason to defeat sensing.

## Architecture and human factors
Use fixed guards and geometry to make the mat the **unavoidable, comfortable, clean, non-trip** route; avoid exposed wires and unserviceable trim. Provide a visible outside-zone reset, separate fresh motion start, independent safety-related output control and physical safe-state verification. Where full occupancy cannot be assured, add appropriate supplementary presence sensing and access control. Maintenance requires personal energy isolation and independent gravity-load restraint, not a mat signal. A floor sensor is not a substitute for press-brake point-of-operation safeguarding without machine-specific risk analysis.

## Evidence limits
**SOURCE-CONFIRMED LinuxCNC:** none new. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied upon. **UNKNOWN:** selected OpenPressBrake mat presence, geometry, sensing performance, stopping time/distance, Y1/Y2 holding, reset logic, PL/SIL. **G0/G1 HOLD** and no personnel-exposed hazardous operation.
