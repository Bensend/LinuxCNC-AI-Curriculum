# ESTOP-MECH-01 — E-stop actuator/contact-block detachment, mounting monitoring and proof limits

Status: original manufacturer-source investigation; **NON-GRADUATED**; 2026-10-26. No selected OpenPressBrake device identified. No tests.

## Frozen question and novelty check
Can an emergency-stop mushroom latch and visibly move while its rear electrical contact block has detached, leaving a conventional normally-closed (NC) channel permissive? What additional evidence does a mounting-monitoring block provide, and what does it **not** prove?

Before source selection, inspected the full safety-course learner index (207,165 characters) for contact block, self-monitoring, mounting and pushbutton, and the repository research directory (502 filenames) for emergency-stop/contact-block/detachment. Existing E-stop latch, cable-pull tension, EDM, reset, and guard-lock mounting lessons are **related**, but no actuator-to-contact-block detachment source audit was found. This is a new *specific mechanical coupling failure path*, not the first E-stop lesson.

## Original sources and access
1. **Siemens SIRIUS ACT 3SU1 system manual**, 02/2016, A5E03457306020A/RS-AE/005, p.149, § contact modules with installation monitoring, indexed original PDF: https://cache.industry.siemens.com/dl/files/462/107542462/att_880825/v1/manual_SIRIUS_ACT_3SU1_en-US.pdf . Search-indexed manufacturer text was read. Direct full-PDF fetch failed because file is ~21 MB; **DOC-CONFIRMED from indexed original excerpt**, not a full-manual inspection. The 3SU1400-1AA10-.HA0 block monitors correct mounting/connection; improper installation or detachment triggers shutdown. Manufacturer states the contact circuit becomes ready only after first activation/function test. Positions 1 and 2 are allowed in ordinary 3SU1 holder combinations, with an exception for a non-illuminated E-stop (all three positions). The suffix x/terminal variants and installation geometry matter.
2. **Siemens original exact datasheet**, 3SU1400-1AA10-1HA0, dated 2025-10-24, indexed manufacturer PDF: https://support.industry.siemens.com/teddatasheet/?caller=SIOS&format=pdf&language=en&mlfbs=3SU1400-1AA10-1HA0 . Indexed text identifies 1 NC installation-monitoring contact, positive opening, front-panel mount. Direct fetch returned 403; product/variant scope only.
3. **Rockwell Automation, Machinery Safebook 5**, revision 5, pp.39–40 (PDF physical pages 39–40): https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/safebk-rm002_-en-p.pdf . Directly opened. p.40 describes a spring-actuated mounting-monitor contact that closes when the rear assembly is correctly snapped in place. Also states emergency stop is complementary safeguarding, not primary access prevention; resetting the E-stop must not initiate hazardous restart.
4. **Rockwell original product data**, 800FP-MT44PX02S (800F, 22 mm, twist-release, 2 NC, **self-monitoring**, latch mounting): https://www.rockwellautomation.com/en-us/products/details/800fp-mt44px02s.html . Directly inspected current catalog page, not a machine wiring diagram.
5. **Rockwell original product data**, 800HC-TFRXT6A5S (800H, 30 mm, trigger-action, 2-NCLB **self-monitoring**): https://www.rockwellautomation.com/en-us/products/details.800HC-TFRXT6A5S.html . Directly inspected current catalog page. The 800F and 800H descriptions are **not** evidence of identical internal contacts or interchangeability.

## Mechanism and fault discrimination
- **DOC-CONFIRMED / manufacturer description:** An actuator and a removable rear block are separate physical parts. Siemens and Rockwell sell specific monitoring blocks to detect missing/incorrectly installed rear assemblies. Rockwell describes the extra mounting-dependent spring contact; Siemens describes automatic shutdown when mounting integrity fails.
- **INFERENCE / conditional failure path:** In a *conventional non-monitoring* NC block, loss of the actuator-to-block mechanical coupling can leave the NC contact closed while the front mushroom is pressed. Both nominally redundant NC channels can share the same detached holder, so electrical dual-channel logic alone need not detect this common mechanical failure. Actual behavior depends on the exact device's positive-opening design, assembly, wiring and failure.
- **DOC-CONFIRMED, bounded:** Siemens says its monitoring circuit requires initial actuation/function test before ready. Do **not** generalize this first-press behavior to Rockwell 800F/800H or all monitored E-stops.
- **INFERENCE:** A mounting-monitoring block can improve coverage for a *specific* missing-block fault but does not establish an independent safe stop, an unbroken conductor, correct wiring, safety controller fault coverage, physically stopped Y1/Y2 axes, gravity restraint, hydraulic energy isolation or no unexpected restart.
- **UNKNOWN:** Siemens internal spring-contact arrangement beyond the indexed text; exact monitoring wiring; selected machine part/revision; achieved diagnostic coverage, PL/SIL, stopping time and physical test.

## Three distinct proof propositions
1. **Mechanical coupling:** rear block actually attached and correctly actuated by mushroom.
2. **Electrical input:** correct NC/monitoring signals reach a compatible independent safety receiver and cause an appropriate stop demand.
3. **Physical safety:** monitored final elements stop hazardous movement, restrain gravity loads and prevent hazardous restart.

Passing (1) does not prove (2) or (3). A LinuxCNC HAL E-stop flag proves none of them independently.

## Fault-path table
| Fault | Conditional input symptom | Appropriate independent evidence | Invalid shortcut |
|---|---|---|---|
| Rear block physically detaches | Conventional NC can remain closed despite front actuation | Exact-part installation/monitoring documentation; isolated mechanical inspection; qualified independent receiver witness | “Two NC channels mean a loose common holder is detected.” |
| Monitoring block missing or wrong variant | Mounting diagnostic may not exist or be connected | Complete part number, bill of materials, wiring, as-built photo under qualified access | “The mushroom is red so the rear block is self-monitoring.” |
| Siemens monitored block first installed | OEM requires initial functional actuation before ready | Edition-specific commissioning record, qualified witness | “A new unused block must already be permissive.” |
| E-stop reset after a successful stop | Reset can clear input demand | Separate deliberate restart interlock and physical final-element validation | “Twist-release authorizes movement.” |
| Common mounting defect affects two NC paths | Both channels may falsely look healthy | Mechanical integrity plus design-level fault analysis | “Input agreement proves actuation.” |

## Human-factors design consequence
Choose a qualified assembly with robust captive mounting, easily inspectable rear connection, positive part/variant labeling and suitable self-monitoring where justified. Provide accessible, isolated inspection and fast replacement so technicians do not have to work behind a live panel or defeat the circuit. Record any post-panel-service change as requiring renewed installation and functional checks. Avoid designs whose nuisance trips tempt removal of the monitoring contact.

## Safety / release
The selected OpenPressBrake E-stop part, contact blocks, safety receiver, physical Y1/Y2 stopping, gravity holding and pressure isolation remain **UNKNOWN**. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No energized fault injection, deliberate detachment under power, personnel-exposed operation, physical tests, Actions jobs, hosted/local compute, or TEST-CONFIRMED claim.

## Open follow-up
Obtain exact machine part/holder/contact-block identifiers, OEM mounting instructions, qualified isolation/access photographs, safety circuit diagram and independent stop/hold witness. The Siemens full manual should be visually inspected if its edition-specific commissioning/position rules become a selected-machine design input. Do not infer Rockwell 800F/800H internal behavior from the Siemens diagram.
