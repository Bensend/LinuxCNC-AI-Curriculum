# Pressure-sensitive mat occupancy, reset, and restart authority study

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Question

What does a pressure-sensitive safety mat actually prove, how should its reset/restart behavior be treated, and which facts remain outside its authority?

This is intentionally separate from the primary lane's current final-element physical-feedback comparison. It studies a protective-device/occupancy boundary rather than contactor EDM, drive STO feedback, or hydraulic valve/spool monitoring.

## Evidence labels

- **SOURCE-CONFIRMED** — directly stated by a manufacturer/authoritative source cited below.
- **DOC-CONFIRMED** — established by durable repository documentation.
- **TEST-CONFIRMED** — established by an executed, recorded test. None in this study.
- **COMMUNITY-REPORTED** — community report not independently verified. None used here.
- **INFERENCE** — engineering conclusion derived from identified evidence.
- **UNKNOWN** — machine-specific fact requiring design data, inspection, or physical validation.

## Manufacturer evidence

### Rockwell MatGuard reset behavior

**SOURCE-CONFIRMED.** Rockwell's 440F MatGuard manual states that in Manual Reset mode, removing actuating force from the mat does not restore the safety outputs by itself; a reset is required. After power-on or restoration of lost power, outputs remain off until reset even when the mat is clear. The manual also states that Auto Reset mode still requires a separate machine-control reset function to prevent machine startup merely because a person steps off the mat or supply power returns.

Source: Rockwell Automation, *MatGuard Control Unit with MatGuard Pressure Sensitive Safety Mat System User Manual*, 440F-UM003A-EN-P, January 2024, Reset Modes. https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440f-um003_-en-p.pdf

### Rockwell complete safety-mat circuit example

**SOURCE-CONFIRMED.** Rockwell's Guardmaster wiring publication gives a concrete mat-to-final-function example using two 440F mats, a DI safety relay, and a PowerFlex 755. Stepping on either mat initiates the safety stop; the DI relay removes the relevant enable paths and the drive executes STO. The example uses monitored manual reset. It also treats a channel cross fault as equivalent to mat actuation and states that mat applications require the appropriate dual-input logic/wiring rather than being treated as an ordinary E-stop contact pair.

Source: Rockwell Automation, *Next Generation Guardmaster Safety Relay (GSR) Wiring Diagram*, SAFETY-WD001M-EN-P, September 2025, safety-mat example. https://literature.rockwellautomation.com/idc/groups/literature/documents/wd/safety-wd001_-en-p.pdf

### SICK reset/restart separation and visibility

**SOURCE-CONFIRMED.** SICK defines reset as returning a protective device to monitoring state after a stop demand; reset must not itself introduce movement, and restart follows only after a separate start command. SICK also states that automatic reset is only appropriate in special cases where people cannot remain in the hazardous area undetected or presence is otherwise excluded.

Source: SICK, *Safeguard Detector — Flexi Soft variant*, 8019465, glossary/reset and restart-interlock definitions. https://www.sick.com/media/docs/8/88/588/operating_instructions_safeguard_detector_flexi_soft_variant_en_im0064588.pdf

**SOURCE-CONFIRMED.** In another safeguarding system SICK requires reset/restart controls outside the hazardous area with a complete view of the hazardous area. This is not a claim that every safety-mat installation must copy that exact implementation; it is strong manufacturer evidence for the personnel-clear/restart-authority boundary.

Source: SICK, *Safeguard Detector Safety System*, 8026276, section 4.3.7. https://www.sick.com/media/docs/4/84/784/operating_instructions_safeguard_detector_safety_system_en_im0104784.pdf

## Architecture freeze

**INFERENCE, supported by the manufacturer evidence above:**

`MAT NOT ACTUATED != HAZARD AREA PERSONNEL-CLEAR`.

A pressure-sensitive mat proves its sensing zone is not currently being actuated above its validated detection conditions. It does not prove that nobody is standing beside it, beyond it, on an excluded/dead region, above it, or inside a larger hazard zone not covered by that mat.

`PERSON STEPPED OFF MAT != RESTART AUTHORIZED`.

`MAT CLEAR != SAFETY RESET COMPLETE != FRESH ORDINARY START`.

`MAT INPUT HEALTHY != MAT COVERAGE/PLACEMENT VALID != REQUIRED SEPARATION DISTANCE VALID`.

`TWO MAT WIRES PRESENT != CROSS-FAULT DIAGNOSTICS PROVED`.

`MAT SAFETY RELAY OUTPUT OFF != HAZARDOUS MOTION PHYSICALLY CEASED`.

The last boundary intentionally stops before the primary lane's final-element work. Lane B may demand that physical cessation be validated, but this study does not duplicate the current EDM/STO/valve-feedback evidence package.

## LinuxCNC/OpenPressBrake authority boundary

**DOC-CONFIRMED / architecture rule.** LinuxCNC, HAL, an HMI, or the ordinary FPGA may display mat state and safety-system diagnostics, but ordinary control must not become the personnel-safety authority merely because it can see a `mat_clear` or `safety_ready` bit.

A plausible architecture is:

`pressure-sensitive mat -> validated safety input/evaluator -> independent safety function -> final safety elements`

with LinuxCNC receiving status/diagnostics separately.

**UNKNOWN:** whether OpenPressBrake needs a pressure-sensitive mat at all. No mat requirement is created by this study.

## Failure-path / commissioning worksheet

For any future machine where a safety mat is justified, require explicit answers and physical validation for:

1. Step on each intended detection region independently. Does the safety function demand occur?
2. Step near seams, joins, edges, cable exits, and any intentionally excluded regions. Are coverage assumptions documented rather than guessed?
3. Keep one mat actuated while attempting reset. Is restart authorization withheld as designed?
4. Step off the mat without pressing reset. Does the system remain in the required restart-interlocked state?
5. Restore power with the mat clear. Does the selected reset architecture behave as documented?
6. Restore power with the mat actuated. Does the system remain safe and require the documented recovery sequence?
7. Introduce a representative channel cross fault/open-circuit fault using the manufacturer's safe commissioning method. Does the evaluator diagnose/dispose of it as designed?
8. Hold the reset control continuously through mat actuation/clearance. Can a held reset incorrectly substitute for a deliberate valid reset event?
9. Leave a stale LinuxCNC START/CYCLE/JOG request present while clearing and resetting the mat safety function. Does safety recovery remain distinct from ordinary motion initiation?
10. Verify the actual machine hazard response separately. Do not call the test complete merely because the mat relay/OSSD changed state.
11. Re-test after mat, cable, safety evaluator, reset circuit, floor layout, guarding, machine geometry, stopping behavior, or final-element changes that could affect the safety function.

## Human-factors / defeat risks

**INFERENCE.** Mats are especially vulnerable to design mistakes that appear electrically healthy: placing a pallet, fixture, anti-fatigue mat, plate, debris, or bridging surface over the sensing zone; creating a convenient route around the mat; or moving the operator's normal work position outside the protected sensing geometry. These are coverage/usage failures, not merely input-bit failures.

Therefore commissioning and periodic inspection must treat **physical access path and sensing coverage** as evidence, not just relay diagnostics.

## What this study does not establish

The following remain **UNKNOWN** for OpenPressBrake unless separately measured/designed/validated:

- whether a mat is appropriate or required;
- mat dimensions, sensitivity, dead zones, environmental suitability, mounting, or edge treatment;
- minimum safety distance or machine stopping time;
- required PL/SIL/category/DC/CCF;
- exact reset location or visibility requirement;
- number of mats or series/parallel topology;
- exact cross-fault/test-pulse architecture;
- final-element topology;
- hydraulic stop behavior;
- any acceptance threshold tied to physical machine performance.

No such values are invented here.

## Compute decision

No simulation, synthesis, benchmarking, or executable verification is justified for this evidence question. No GitHub-hosted runner is permitted or used. A future executable test must answer a concrete unresolved question and, if needed, use only `[self-hosted, openpressbrake]`.

## Precise next-work checkpoint

Find a professional machine implementation where a floor mat is used as a presence-sensing protective device and the documentation exposes the full chain:

`physical approach path -> mat coverage -> dual-channel/cross-fault evaluation -> safety demand -> machine stopping function -> mat remains occupied -> release/clearance -> manual reset with area visibility -> safety requalification -> stale-command challenge -> separate fresh ordinary START`.

Prefer an implementation that also documents seams/dead zones, multiple mats, or a fault-insertion/commissioning procedure. Do not infer machine stopping distance or OpenPressBrake applicability from the generic examples above.