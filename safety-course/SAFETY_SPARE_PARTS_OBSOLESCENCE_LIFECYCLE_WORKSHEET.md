# Safety Spare-Parts / Obsolescence Lifecycle Worksheet

## Purpose

Use this worksheet when a spare, repaired, refurbished, cannibalized, long-stored, discontinued, or successor component can affect a personnel-safety function. It complements `SAFETY_REPLACEMENT_PART_EQUIVALENCE_SUBSTITUTION_WORKSHEET.md`; it does not replace machine-specific validation.

## Frozen rule

**A part sitting on the shelf is not a validated safety spare merely because its label matches the installed part.**

Safety-spare acceptance follows identity, provenance, lifecycle status, storage/environment, firmware/configuration dependencies, physical condition, affected safety-function dependencies, and bounded revalidation after installation.

Do not invent generic shelf-life intervals. Where useful life, storage life, maintenance interval, battery life, capacitor reforming, seal aging, calibration interval, firmware support, or other time-dependent limitation matters, obtain it from the applicable manufacturer documentation or mark it `UNKNOWN`.

## Evidence vocabulary

- `SOURCE-CONFIRMED` — authoritative public source supports the claim.
- `DOC-CONFIRMED` — machine/OEM/project documentation supports the claim.
- `TEST-CONFIRMED` — a controlled physical test supports the bounded claim.
- `COMMUNITY-REPORTED` — credible field/community report, not authoritative proof.
- `INFERENCE` — engineering conclusion from identified evidence.
- `UNKNOWN` — evidence is absent or insufficient.

A safety-relevant `UNKNOWN` capable of defeating the safety function blocks an unqualified return-to-service claim.

## 1. Spare identity and provenance

| Field | Record |
|---|---|
| Machine / asset | |
| Safety function(s) affected | |
| Hazard boundary affected | |
| Installed component MPN / revision | |
| Spare component MPN / revision | |
| Serial / date / lot code if relevant | |
| Manufacturer | |
| Source / supplier | |
| Purchase / receipt date | |
| New / repaired / refurbished / cannibalized / unknown | |
| Manufacturer-approved repair? evidence | |
| Manufacturer-approved successor? evidence | |
| Authenticity/provenance evidence | |
| Prior service history | |
| Prior configuration / machine identity | |
| Evidence classification | |

### Stop condition

If identity or provenance cannot be established and a plausible mismatch/counterfeit/unknown-history failure could defeat the safety function, classify the spare `QUARANTINE / ENGINEERING REVIEW`, not `READY`.

## 2. Lifecycle / obsolescence status

Record the manufacturer's actual lifecycle classification rather than using one generic meaning for "obsolete."

| Question | Evidence / answer |
|---|---|
| Current lifecycle state | |
| Discontinuance / last-order date | |
| Repair support available | |
| Manufacturer named replacement | |
| Replacement category: exact/direct/functional/migration/none | |
| Required migration instructions | |
| Firmware/toolchain support implications | |
| Safety certification/manual revision implications | |
| Device-local configuration conversion required | |
| Existing validation evidence invalidated? why | |

### Important distinction

A manufacturer may call a successor a **direct replacement** or a **functional replacement**. Preserve that exact classification. Do not silently promote a functional replacement to an exact safety-equivalent part. Feed the successor through the replacement-equivalence worksheet and change-impact/revalidation matrix.

## 3. Storage and aging evidence

Do not assume unused means unchanged.

| Dependency | Required evidence | Result |
|---|---|---|
| Manufacturer storage temperature/humidity | applicable datasheet/manual | |
| Actual storage environment known? | records/inspection | |
| Manufacturer shelf/storage-life limit | source or `UNKNOWN` | |
| Battery / RTC / memory-retention dependency | source + inspection/test | |
| Electrolytic-capacitor / power-supply aging concern | product-specific source or `UNKNOWN` | |
| Elastomer/seal/diaphragm aging where relevant | product-specific source or `UNKNOWN` | |
| Corrosion/contamination/moisture | physical inspection | |
| Connector/contact condition | physical inspection | |
| Mechanical actuator freedom/alignment | physical inspection/test where safe | |
| Calibration / teach / alignment retention | product-specific evidence | |
| Packaging / ESD / environmental protection intact | inspection | |

Do not create a universal "replace after N years" rule. For example, a published useful-life value for one safety-controller family is evidence about that family under its stated assumptions, not a generic lifetime for every safety component.

## 4. Firmware, configuration, and identity dependencies

For programmable/configurable safety components record:

- hardware revision;
- firmware revision;
- safety application/configuration revision;
- checksum/signature/CRC or other manufacturer-supported identity where applicable;
- safety-network/device identity;
- option modules and safe-motion features;
- device-local parameters not contained in the main controller backup;
- calibration/teach data;
- engineering software/compiler compatibility;
- whether a spare was previously commissioned on another machine.

**`project downloaded successfully` is not physical validation of the safety function.**

## 5. Cannibalized, repaired, and used parts

A used component can carry hidden state and unknown history that a new packaged spare does not.

Check for:

- unknown operating hours/cycles/environment;
- previous fault or overload history;
- undocumented repair;
- firmware/configuration from another asset;
- mechanical wear or contact wear;
- calibration drift;
- defeated or altered safety features;
- missing labels/tamper evidence;
- obsolete revision with different diagnostics;
- uncertain authenticity.

Record unresolved items as `UNKNOWN`; do not convert absence of records into evidence of health.

## 6. Inventory state model

Recommended safety-spare states:

1. `UNREVIEWED` — present in inventory but not qualified.
2. `QUARANTINE` — identity/provenance/condition problem or unresolved safety-relevant uncertainty.
3. `APPROVED-SPARE` — engineering/document review supports intended substitution, subject to installation checks and revalidation.
4. `INSTALLED-PENDING-VALIDATION` — physically installed but affected safety function has not yet passed required challenges.
5. `IN-SERVICE-VALIDATED` — affected function passed the bounded required validation and evidence is retained.
6. `REMOVED / FAILED / INVESTIGATION` — not eligible for reissue until disposition is complete.

A bin label saying `spare` is not one of these evidence states.

## 7. Periodic inventory reconciliation

At an appropriate maintenance/documentation interval chosen from the actual application and manufacturer requirements, reconcile:

- approved MPN/revision against current machine documentation;
- manufacturer lifecycle status and named successors;
- support/firmware/toolchain availability;
- storage condition evidence;
- calibration/storage-life limits where applicable;
- quantity and physical location;
- quarantine status;
- repair/refurbishment records;
- asset-specific configuration packages;
- authenticity/procurement records.

Do **not** invent a universal reconciliation interval in this curriculum.

## 8. Installation change-impact gate

Before installation, classify the change using `DISASTER_RECOVERY_CHANGE_IMPACT_REVALIDATION_MATRIX.md` and `SAFETY_REPLACEMENT_PART_EQUIVALENCE_SUBSTITUTION_WORKSHEET.md`.

### Evidence that may survive unchanged

Examples, only when dependencies truly remain unchanged:

- hazard identification unrelated to the replaced part;
- physical guard geometry not touched by an electrical controller replacement;
- unrelated safety-function tests whose dependencies are independent of the changed component.

### Evidence commonly requiring review or repetition

Depending on the affected dependency:

- wiring/terminal identity;
- safety-network/device identity;
- configuration/signature;
- OSSD/test-pulse compatibility;
- EDM/final-element feedback;
- reset/restart/rearm behavior;
- safe-motion configuration;
- protective-device alignment/coverage;
- final-element physical response;
- fault detection and diagnostic behavior;
- calibration/teach data;
- affected fault-insertion/proof-test challenge.

Do not retest unrelated functions merely to create paperwork; do not preserve old evidence for a dependency that actually changed.

## 9. Return-to-service physical challenge

For each affected safety function record:

| Item | Record |
|---|---|
| Safety demand / stimulus | |
| Physical path expected to change | |
| Independent witness | |
| Diagnostic/EDM witness | |
| Reset behavior | |
| Restart/rearm behavior | |
| Fault challenge required | |
| Raw evidence retained | |
| Result | |
| Evidence classification | |

A status screen, matching part number, successful firmware download, or clear diagnostic log does not by itself prove the physical hazardous-energy boundary.

## 10. Counterfeit / unknown-source risk

Treat safety-relevant components from unknown or unverifiable sources as a distinct engineering risk. Check manufacturer/supplier authenticity mechanisms where available. Packaging similarity, matching labels, connector fit, or an online seller's compatibility claim is not provenance.

If authenticity cannot be resolved, do not claim manufacturer safety data/certification applies to the physical item in hand.

## 11. Example bounded cases

### A. Manufacturer-listed direct successor

`SOURCE-CONFIRMED`: manufacturer lifecycle page names a direct replacement.

`INFERENCE`: this is stronger substitution evidence than physical similarity, but machine-specific firmware/configuration/wiring and affected safety-function revalidation still require review.

### B. Manufacturer-listed functional replacement for a light curtain

`SOURCE-CONFIRMED`: manufacturer calls the newer device a functional replacement.

`INFERENCE`: do not assume mounting, resolution, protective field, OSSD behavior, response characteristics, restart semantics, wiring, diagnostics, or safety calculations are unchanged. Re-run equivalence/change-impact analysis.

### C. Ten-year-old unopened spare

`UNKNOWN`: unopened packaging alone does not establish that every time/environment-dependent property remains within specification.

Action: retrieve product-specific storage/useful-life evidence, inspect, configure as required, and physically revalidate the affected safety function. Do not invent a generic ten-year acceptance/rejection rule.

### D. Cannibalized safety controller

`UNKNOWN` until resolved: previous configuration, firmware, fault history, environment, and machine identity.

Action: quarantine until identity/provenance/configuration and change-impact gates are satisfied. A successful boot is not sufficient.

## 12. Source-traced principles

- `SOURCE-CONFIRMED`: OSHA lockout/tagout interpretive guidance distinguishes component replacement such as valves, gauges, linkages and support structure from routine production-mode maintenance and says such maintenance requires energy isolation.
- `SOURCE-CONFIRMED`: Rockwell lifecycle pages explicitly distinguish lifecycle state and replacement category; some GuardLogix products list a direct replacement, while a discontinued GuardShield product lists a functional replacement. Therefore manufacturer replacement terminology must be preserved rather than flattened into "compatible."
- `SOURCE-CONFIRMED`: Rockwell publishes a 20-year useful life for a specific GuardLogix 5580 Logix SIS safety-controller context under stated assumptions. This demonstrates why lifetime evidence is product/context specific; it is **not** a universal safety-component lifetime.
- `SOURCE-CONFIRMED`: OSHA robot-system guidance says maintenance/inspection should include manufacturer recommendations and associated equipment and should be documented, because component malfunction, wear, breakage and documented/undocumented changes can create hazards.
- `INFERENCE`: safety-spare governance must retain manufacturer lifecycle/provenance evidence, storage/aging dependencies, configuration identity, and installation validation instead of treating inventory possession as readiness.

## 13. LinuxCNC / FPGA boundary

Ordinary LinuxCNC, HAL, FPGA, HMI, CMMS, or inventory software may record part identity, lifecycle status, diagnostics, configuration hashes, maintenance history, and validation evidence. These records do not gain personnel-safety authority merely because they are automated. The independent safety function and its physical final elements remain the authority that must be validated.

## 14. Final disposition

- [ ] `APPROVED-SPARE`
- [ ] `QUARANTINE / ENGINEERING REVIEW`
- [ ] `INSTALLATION PENDING CHANGE-IMPACT REVIEW`
- [ ] `INSTALLED-PENDING-VALIDATION`
- [ ] `IN-SERVICE-VALIDATED`
- [ ] `REJECT / DISPOSE PER SITE PROCEDURE`

Decision basis:

Evidence references:

Unresolved `UNKNOWN`s:

Affected safety functions re-challenged:

Reviewer/date:
