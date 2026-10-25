# 4400-SCAN-01 — SICK S300 EFI field-status versus OSSD restart-interlock authority
**2026-10-25 | ORIGINAL MANUFACTURER DOCUMENT | NON-GRADUATED | no selected-machine verification**

## Concrete question
If an S300 has its *internal* restart interlock enabled, does a downstream Flexi Soft safety controller necessarily inherit that interlock? **No.** The 2025 OEM manual explicitly distinguishes consuming *OSSD status* from consuming *protective-field status*. This is a configuration-dependent integration counterexample, not an assertion that any such system is installed on OpenPressBrake.

## Primary provenance (directly inspected)
SICK AG, *S300 Safety Laser Scanners*, operating instructions **8010948/ZD76/2025-08-19**, original manufacturer PDF:
https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf

- Printed **p.88**, §7.10, 'Restart behavior ... Flexi Soft': internal interlock affects scanner OSSDs. When Flexi Soft consumes **OSSD status**, it also sees the interlock. When Flexi Soft consumes **protective-field status**, the internal interlock **does not** affect the safety controller; the controller must implement its own restart interlock. **DOC-CONFIRMED exact product/integration**.
- Printed **p.88**, §7.10: with no restart interlock, OSSDs return ON immediately after field clears; only permitted subject to the manual's external interlock or continuous coverage conditions. A mobile-only restart delay is conditional, not a general stationary machine recipe. **DOC-CONFIRMED**.
- Printed **pp.88–90**, §7.10: where a person can leave the field toward the hazard or be undetected anywhere in the hazardous area, a restart interlock is imperative; reset control must be outside the hazard with full view. The manual distinguishes start interlock from restart interlock and describes separate internal/external controls when both are present. **DOC-CONFIRMED**.
- Printed **p.87**, §7.9.1: EDM can detect a welded contactor, but its fault reaction differs depending on internal restart configuration (lock-out versus OFF and error indication). **DOC-CONFIRMED**, not proof of actual contactor opening.
- Printed **p.90**, §7.11: universal I/O signals are explicitly **non-safe** and not suitable for safety-related functions. **DOC-CONFIRMED**.

## Counterexample / failure path
```
person interrupts scanner protective field -> scanner OSSDs OFF
person walks through and stands beyond field -> field clear
scanner internal restart interlock keeps scanner OSSDs OFF
BUT controller consumes EFI field-clear status, not OSSD state
field-clear status becomes true -> downstream controller may see permissive
unless an independent restart interlock is explicitly implemented there
```
The OEM confirms **loss of propagation of the internal interlock** through this specific signal selection. Whether any machine actually moves depends on downstream logic, safety allocation, final elements, and fresh command; **UNKNOWN**. A 'green field' display is not a safety-reset oracle. Merely configuring the interlock in the sensor is not enough to prove the downstream safety function.

## Engineering requirement / proof obligation
Record exact scanner model/firmware, internal interlock settings, EFI signal mapping, Flexi Soft logic revision, OSSD physical wiring, external reset inputs, EDM and final-element design. Independently review the *signal actually used to authorize the safety function*. A qualified, de-energized configuration walk-through should demonstrate that field-clear status cannot independently rearm hazardous motion. Later physical commissioning must verify final-element stopping, holding and deliberate restart under approved safe test controls.

For OpenPressBrake: ordinary LinuxCNC/FPGA may log scanner status and request stops; it must **not** substitute for an independent safety-related restart or for verified hydraulic Y1/Y2 stop and gravity hold. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**.

## Evidence and limitations
**SOURCE-CONFIRMED LinuxCNC:** none new. **DOC-CONFIRMED:** exact SICK sections above. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **INFERENCE:** stale motion request plus field-status mapping can create a dangerous rearm path if no separate rated interlock; requires downstream design inspection. **UNKNOWN:** actual OpenPressBrake sensor/logic, personnel detection, stop time, PL/SIL, physical stop/hold and evaluator outcome. No simulation or physical experiment; no claim that SICK is installed. Do not copy this S300 behavior to other scanner families without their manuals.

## Adversarial discriminator
An installer shows the S300 internal restart checkbox ON and the Flexi Soft program using a field-clear EFI bit. **Question:** what single missing item invalidates the claim 'manual reset is assured'? **Answer for open learning only:** evidence of a correctly implemented downstream restart interlock (or change to appropriate OSSD-status path), followed by independent physical validation. This is a public teaching question, not a blind score.
