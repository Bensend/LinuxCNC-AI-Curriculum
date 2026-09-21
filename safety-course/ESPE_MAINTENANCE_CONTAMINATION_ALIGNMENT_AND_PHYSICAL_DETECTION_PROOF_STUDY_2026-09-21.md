# ESPE maintenance, contamination, alignment, and physical-detection proof study

Date: 2026-09-21
Lane: independent safety curriculum Lane B

## Why this branch

The newest primary lane is working temporary commissioning/test states, forces/simulations/overrides, production blocking, and return-to-service handoff. This study deliberately uses a different evidence family and different files: degradation and maintenance of electro-sensitive protective equipment (ESPE), with emphasis on proving the physical protective field after cleaning, optical-part replacement, alignment/configuration work, or other changes that can affect detection.

No OpenPressBrake-specific ESPE selection, geometry, safety distance, resolution, response time, PL/SIL/category, test interval, or acceptance threshold is asserted here.

## Evidence vocabulary

- **SOURCE-CONFIRMED** — directly stated by the cited manufacturer source.
- **DOC-CONFIRMED** — confirmed by durable project documentation.
- **TEST-CONFIRMED** — demonstrated on the actual implementation under a defined test.
- **COMMUNITY-REPORTED** — reported by a community source but not independently established.
- **INFERENCE** — engineering conclusion derived from evidence and explicitly marked as such.
- **UNKNOWN** — requires machine/design-specific authority or measurement.

## Manufacturer evidence

### SICK C4000 daily physical detection test

**SOURCE-CONFIRMED:** SICK C4000 Standard/Advanced operating instructions require daily effectiveness checks using the correct test rod. The test is not confined to the light-curtain mounting line: the rod is moved through the complete hazardous area to be protected and along the edges, with additional checks around deflector mirrors and every protected sub-area when blanking is used. If the receiver shows a permissive green/yellow indication during the test, work must stop and mounting/configuration must be checked by qualified safety personnel.

Source: SICK, *C4000 Standard and C4000 Advanced Safety Light Curtains*, Commissioning §7.3.3, manufacturer operating instructions.
https://www.sick.com/media/docs/5/45/945/operating_instructions_c4000_standard_and_c4000_advanced_safety_light_curtains_en_im0011945.pdf

This is stronger than a controller/status-bit check: the manufacturer deliberately inserts a physical test object into the actual protected geometry.

### SICK C4000 Palletizer post-change inspection

**SOURCE-CONFIRMED:** SICK's C4000 Palletizer instructions require regular inspection to detect machine changes or manipulation of the protective device. If the machine/protective device is modified, or the light curtain is changed or repaired, the system must be checked again using the specified checklist. The same manual requires a daily functional test and says the machine must not be operated if the expected protective response is absent.

Source: SICK, *C4000 Palletizer Standard/Advanced Safety Light Curtain*, Commissioning §§7.3.2–7.3.3.
https://www.sick.com/media/docs/3/73/873/operating_instructions_c4000_palletizer_standard_advanced_safety_light_curtain_en_im0013873.pdf

### SICK S200 optics-cover maintenance boundary

**SOURCE-CONFIRMED:** SICK's S200 instructions require the machine/system to be isolated from power while replacing the scanner optics cover. After optics-cover replacement, an optics-cover calibration is required; that calibration establishes the reference used for contamination measurement. The manual requires a new, uncontaminated cover for that calibration and specialist replacement in a clean environment.

Source: SICK, *S200 Safety Laser Scanner*, Care and Maintenance §§9.1–9.2.
https://www.sick.com/media/docs/8/58/858/operating_instructions_s200_safety_laser_scanner_en_im0018858.pdf

**SOURCE-CONFIRMED:** SICK's current replacement tutorial also ends optics-cover replacement with calibration and scanner alignment rather than treating mechanical replacement alone as completion.

Source: SICK, *microScan3 + nanoScan3: How to replace and calibrate the optics cover*.
https://video.sick.com/media/t/0_1z69xa4i

## Durable distinctions

Freeze these distinctions for later curriculum work:

**DEVICE REPORTS HEALTHY != PHYSICAL PROTECTIVE FIELD PROVED**

**OPTICS CLEANED != ALIGNMENT/GEOMETRY UNCHANGED PROVED**

**OPTICS COVER REPLACED != CONTAMINATION REFERENCE CALIBRATED != SCANNER ALIGNED != PROTECTIVE FUNCTION PHYSICALLY REVALIDATED**

**CONFIGURATION CHECKSUM UNCHANGED != MOUNTING/ALIGNMENT/PROTECTED GEOMETRY UNCHANGED**

**EXPECTED OSSD/SAFETY INPUT TRANSITION != DANGEROUS MACHINE RESPONSE PHYSICALLY PROVED**

**MAINTENANCE COMPLETE != RETURN TO PRODUCTION AUTHORIZED**

The first four are supported directly or conservatively by the manufacturer procedures above. The fifth is an **INFERENCE** consistent with the curriculum's existing final-element witness ladder: a sensor transition proves the sensor/output layer, not by itself the complete downstream machine stop. The last is an **INFERENCE**: maintenance completion must be followed by whatever affected-function validation the actual machine requires.

## Failure-path analysis

A useful ESPE maintenance validation must distinguish at least these failure paths:

1. Optical surface contamination or damage changes detection performance.
2. Replacement of an optical cover establishes a new physical optical interface but required calibration/alignment is omitted.
3. Sender/receiver or scanner is bumped, remounted, or realigned while controller configuration remains unchanged.
4. Blanking/reduced-resolution configuration changes the effective detection requirement, but the wrong physical test object is used.
5. Deflector mirrors or field edges leave a gap that a test only at the sensor mounting line misses.
6. A protective-device output changes correctly, but the downstream safety logic/final element does not produce the required machine response.
7. A maintenance action changes physical geometry while software/configuration identity remains unchanged, causing a false confidence based on checksums/status alone.

## Question-driven commissioning worksheet

This is a reusable plan, not an OpenPressBrake acceptance specification.

| Question | Required witness | Evidence class |
|---|---|---|
| Is the intended protective geometry physically detected? | Correct manufacturer test object challenged through the required field/edges/sub-areas | TEST-CONFIRMED on the actual machine |
| Did optical replacement/calibration complete correctly? | Manufacturer-required calibration/alignment records plus physical field challenge | DOC-CONFIRMED + TEST-CONFIRMED |
| Does every intended protective demand reach the safety controller? | Physical interruption correlated with safe input/output state | TEST-CONFIRMED |
| Does the demand reach the actual hazardous-motion final element? | Physical machine/final-element response appropriate to the design | TEST-CONFIRMED |
| Did maintenance change safeguard geometry or effective resolution? | Before/after configuration and physical geometry review | DOC-CONFIRMED / TEST-CONFIRMED as applicable |
| Is production restart separately authorized? | Affected validation complete, reset/rearm rules satisfied, fresh ordinary start required | TEST-CONFIRMED on implementation |

## LinuxCNC/OpenPressBrake boundary

**INFERENCE:** LinuxCNC, HAL, an FPGA, or an HMI may display ESPE diagnostics, contamination warnings, OSSD state, or safety-controller state, but those ordinary-control observations do not become personnel-safety authority merely because they are convenient to display.

For any future OpenPressBrake ESPE implementation, the actual safety architecture must independently define the protective device, geometry, required response, final elements, reset/restart behavior, diagnostics, validation method, and maintenance/revalidation requirements. Those facts are currently **UNKNOWN** unless separately frozen by machine-specific design evidence.

## Practical curriculum lesson

Maintenance can invalidate a safety claim without changing a line of safety logic. A replaced optics cover, shifted bracket, mirror adjustment, contaminated window, changed blanking setting, or repaired light curtain can alter the physical sensing boundary. Therefore the revalidation question is not merely "does the safety controller show healthy?" but "does the intended physical object/person intrusion still produce the required complete safety response throughout the protected geometry?"

## Compute decision

No simulation, synthesis, benchmarking, or executable verification is justified for this evidence question. No GitHub-hosted runner is to be used. A future executable lab is justified only if it answers a concrete unresolved question that documentation/physical commissioning cannot answer; any such repository compute must target `[self-hosted, openpressbrake]`.

## Precise next-work checkpoint

Find an authoritative OEM/manufacturer commissioning or maintenance procedure that closes the whole chain after ESPE service: **physical field challenge across the required geometry -> protective-device output -> safety logic -> actual machine/final-element stop -> failed-test production lockout -> correction -> complete retest -> reset/rearm -> separate fresh ordinary start**. Prefer a press/press-brake or another high-energy machine. If authoritative evidence stops at the protective-device output, mark that boundary explicitly rather than inventing the downstream machine behavior.