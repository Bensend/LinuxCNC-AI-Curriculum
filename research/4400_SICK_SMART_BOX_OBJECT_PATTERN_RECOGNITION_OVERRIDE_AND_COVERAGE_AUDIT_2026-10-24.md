# 4400 — SICK deTec4 HG Smart Box Detection and object-pattern recognition versus muting
**Date:** 2026-10-24 | **Status:** independent second source-reading branch, not an installed-machine design or physical test.

## Question
Can material passage be achieved **without fully muting** a protective light curtain, and which human-material confusion, override and commissioning faults remain?

## Original source
**DOC-CONFIRMED directly inspected:** SICK AG *deTec4 HG Safety Light Curtain*, 8023856/1SWC/2026-02-05, original 284-page [manufacturer PDF](https://www.sick.com/media/docs/5/75/275/operating_instructions_detec4_hg_en_im0082275.pdf), §§4.3.7 (printed pp61–71), 4.3.11 (pp87–102), 7.6.1.5 (p170) and 7.6.3.1 (pp172–173). This is a product/firmware/configuration-specific reference, not a generic algorithm for LinuxCNC.

## Distinct protection concepts
| Function | OEM-supported behavior | Boundary |
|---|---|---|
| General muting | Qualified material sensor sequence temporarily bypasses protective action | Field may be muted for configured time; override recovery is separate. |
| Smart Box Detection (SBD) | Rectangular, gap-free material shadows may pass while field remains **actively monitored** for invalid objects/beam interruption above valid box | **Not** universal detection of people: the OEM requires ruling out people or body parts being recognized as valid objects and side entry. |
| Object pattern recognition (OPR) | With a **horizontal** field, configurable goods/pallet/object sequences may pass while invalid patterns cause OSSD OFF | OEM explicitly requires ruling out person-as-valid, person carrying a box, and person riding with an object. |
| SBD override | Recovery from invalid/stalled object: **protective field is not monitored** during override; OSSD can switch ON | The word 'Smart' does not make override safe for exposed personnel. Independent visibility/exclusion and final elements remain mandatory. |

## SBD source details
- **p61–62:** SBD on **14 mm resolution** deTec4 HG with SP2 or DCM4 package; rectangular shadow without gaps, nonreflective objects, defined minimum height/width/separation, speed **0.1–1.0 m/s**, field perpendicular to transport; no side intrusion. These are **OEM-specific application prerequisites**, not generic numerical safety thresholds.
- **p63–66:** OEM permits configurable edge tolerance for damaged boxes; tolerances depend on speed, coding and reduced resolution. The device must be configured and validated against actual material envelope. Do not import a numeric tolerance from one mode or product into another.
- **pp66–68:** Minimum distance to hazard requires machine stopping time and application-dependent approach/reach analysis. An optical classifier does not eliminate stopping-distance or whole-body-access requirements.
- **p69:** SBD Override can cause OSSD ON while field not monitored. OEM requires actuator outside zone, entire area visible; SP2 'override required' delay is **5 s**, consecutive override limit **5**, and counter resets on startup; these are not personnel-safety guarantees. Total SBD time SP2 **24 h**.
- **pp70–71:** Mode change and override state must be assessed; an interrupted field may delay a mode change. Exact mode/configuration is a prerequisite.
- **p172–173 Table 69:** SBD and general muting are **not combinable** in the same configured function set, likewise SBD with OPR. Configurator incompatibility is a design constraint, not evidence that either function is safe for the application.

## OPR source details
- **pp87–88:** horizontal field, DCM4 software configuration, manually set protective width, internal/external restart interlock and application-specific valid-object classification. SICK calls OPR an alternative to muting **only where it demonstrably improves reliability/safety**.
- **pp87, 93:** explicit false-recognition scenarios: a person, person carrying a box, or person riding with transported material. This defeats a simplistic 'AI object recognition means human-safe' claim.
- **p101:** object recognition changes the amount a person may penetrate before detection; protective distance calculation must account for this, not merely use nominal light-curtain resolution.
- **p170:** configuration verification reads back actual device settings; a displayed project configuration alone is not sufficient. After successful transfer/verification the safety function remains stopped pending explicit reactivation path; downstream machine restart must still be independently controlled.

## Practical engineering selection
For uniform boxes with controlled geometry, SBD might reduce muting-sensor complexity and nuisance trips, **but only** if all OEM prerequisites and independent physical guarding can be met. For irregular loads, neither SBD nor generic OPR can be assumed suitable; a qualified four-sensor muting arrangement with side guarding may be more defensible, or physical gates/interlocks may be preferable. For personnel service/jam clearing, no optical classification substitutes for isolation and gravity/mechanical restraint.

**Human factors:** choose accessible, captive-guard, cleanable sensors and a quick safe recovery process; if damaged cartons regularly trip the classifier, operators will be tempted to defeat it. Address material handling/geometry first, not an override jumper.

## Failure-path challenge
Operator changes from uniform cartons to reflective shrink-wrapped packages -> SBD prerequisites may no longer hold -> nuisance stop -> operator presses SBD Override -> field is **not monitored** while OSSD ON -> if a person can follow material through a side gap, the claimed protection is invalid even though normal SBD kept field active. Require independent guard geometry, mode control, recovery sightline, physical stop/hold and fresh start.

## Evidence ledger
**DOC-CONFIRMED:** exact cited OEM manual sections and conditions. **SOURCE-CONFIRMED:** none for software implementation. **TEST-CONFIRMED:** none. **INFERENCE:** comparative human-factors selection and bypass incentives. **UNKNOWN:** whether any selected machine uses SBD/OPR, actual firmware, material envelope, protection geometry, measured stopping time, integrity and independent external evaluator. No personnel-exposed operation authorized; if basic protection cannot be established, any experimental operation must be isolated/remote with people outside hazard and residual risk recorded.

## Reopen
Obtain as-built configuration/readback verification, material sample envelope and speed, actual access geometry, effective detection and stopping measurements by qualified personnel; verify actual IEC 62046:2026 and ISO 13855 adopted editions with licensed standards review. No speculative simulation warranted.
