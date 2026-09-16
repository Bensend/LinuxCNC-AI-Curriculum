# Safety Spare Inventory Reconciliation / Quarantine Audit

## Purpose

Use this worksheet to reconcile physical safety-relevant spare inventory against approved engineering records before a maintenance emergency turns an unidentified or merely similar part into an unsafe substitution. It complements `SAFETY_SPARE_PARTS_OBSOLESCENCE_LIFECYCLE_WORKSHEET.md` and `SAFETY_SPARE_READINESS_EVIDENCE_CARD.md`; it does not establish machine safety by inventory inspection alone.

## Frozen rule

**Inventory availability is not safety readiness. A physical spare and its engineering record must agree on identity, provenance, revision, approved substitution basis, configuration dependencies, storage condition, and intended safety-function use. Any safety-relevant mismatch stays visible and controlled rather than being normalized by a bin label or stock count.**

Evidence labels: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

A safety-relevant `UNKNOWN` that could defeat the affected safety function blocks `APPROVED-SPARE` status.

## 1. Audit scope

| Field | Record |
|---|---|
| Site / storage area | |
| Machine / asset families covered | |
| Audit date | |
| Auditor(s) | |
| Engineering record / CMMS source | |
| Previous reconciliation reference | |
| Manufacturer lifecycle sources checked | |
| Quarantine location / control method | |

Do not invent a universal audit interval. Choose frequency from actual application, manufacturer requirements, change rate, storage environment, maintenance history and site governance.

## 2. Physical-bin to approved-record reconciliation

Use one row per distinct MPN/revision/firmware/configuration class. Do not merge mixed lots merely because the front label is the same.

| Bin/location | Physical MPN | HW rev | FW/config dependency | Serial/lot/date | Qty physical | Qty record | Approved state | Evidence record | Result |
|---|---|---|---|---|---:|---:|---|---|---|
| | | | | | | | | | |

Result vocabulary:

- `MATCH` — physical item and current approved record agree within the documented scope.
- `REVIEW` — discrepancy exists but safety significance is not yet established.
- `QUARANTINE` — unresolved identity/provenance/condition/equivalence/configuration issue could affect a safety function.
- `MISSING` — approved spare expected but not physically present.
- `SURPLUS-UNREVIEWED` — physical item exists without a current approved-spare basis.

A database count matching the bin count is not sufficient if revision, lot, firmware, provenance or condition differ.

## 3. Mixed-bin and wrong-revision check

For every bin marked as one stock item, physically sample or inspect enough units to answer:

- Are all labels the same exact catalog/part number?
- Are hardware revisions materially identical for the approved use?
- Are firmware/configuration dependencies compatible with the intended machine?
- Are direct and functional successors mixed together?
- Are repaired/refurbished/cannibalized units mixed with new units?
- Are different lot/date codes relevant to a manufacturer notice or lifecycle restriction?
- Is any unit missing a legible identity label?
- Does the bin label point to the current evidence record rather than an obsolete drawing/BOM?

If a mixed population cannot be bounded, separate and identify it before returning the bin to approved service.

## 4. Provenance / authenticity / prior-history gate

| Check | PASS / FAIL / UNKNOWN | Evidence |
|---|---|---|
| Approved or traceable procurement source | | |
| Manufacturer/authorized-channel evidence where required | | |
| Packaging/labels/tamper evidence consistent | | |
| Repair/refurbishment source documented | | |
| Cannibalized part donor asset and history known | | |
| Previous fault/overload/removal reason known where used | | |
| No unexplained relabeling or altered identification | | |
| Safety certificate/approval identity applicable to actual unit | | |

Do not claim manufacturer safety data applies to a physical item whose authenticity cannot be established.

## 5. Storage-condition / aging audit

Inspect the actual inventory rather than assuming unopened packaging proves health.

Record product-specific evidence for storage temperature/humidity limits, shelf/storage life, batteries, capacitors, elastomers/seals, lubricants, optics, calibration, corrosion protection, ESD packaging or other aging-sensitive dependencies where applicable. If no applicable manufacturer limit is found, record `UNKNOWN` or the bounded documented fact; do not invent a generic shelf-life.

Physical findings requiring disposition include water ingress, corrosion, contamination, impact damage, UV/weather exposure, torn protective packaging, connector/contact damage, missing caps/plugs, expired calibration where applicable, and evidence that a hydraulic/pneumatic component was stored contaminated or open to atmosphere contrary to its documented requirements.

## 6. Configuration-package reconciliation

For programmable/configurable safety spares, verify that the physical spare can actually be commissioned with the controlled package intended for its machine.

| Dependency | Current controlled identity | Spare-compatible? | Evidence / blocker |
|---|---|---|---|
| Hardware revision | | | |
| Firmware revision | | | |
| Safety application/configuration | | | |
| Signature/checksum/CRC where supported | | | |
| Safety-network/device identity | | | |
| Device-local parameters | | | |
| Safe-motion parameters | | | |
| Calibration/teach/alignment data | | | |
| Engineering tool/compiler version | | | |
| Required license/key/access method | | | |
| Backup restore procedure | | | |

A spare that physically fits but cannot be configured or whose configuration provenance is missing is not emergency-ready.

## 7. Obsolescence and successor drift

For each approved safety spare, re-check current manufacturer lifecycle information when appropriate and preserve the manufacturer's exact terminology: exact replacement, direct replacement, functional replacement, migration path, discontinued without replacement, or other stated category.

Flag:

- approved MPN now discontinued;
- named successor changed since the last review;
- firmware/toolchain needed for the old spare is no longer available;
- a successor requires wiring, mounting, sensing, OSSD/test-pulse, EDM, safe-motion, hydraulic/pneumatic or configuration changes;
- old and successor parts have been mixed in one bin;
- engineering documentation still calls a functional successor "drop-in" without an equivalence/change-impact basis.

Feed any changed substitution basis through `SAFETY_REPLACEMENT_PART_EQUIVALENCE_SUBSTITUTION_WORKSHEET.md` before approval.

## 8. Missing-spare pressure analysis

A safety inventory audit should identify not only questionable parts but **absence that predictably encourages bypass or improvisation**.

For each safety-relevant component with no approved ready spare, record:

| Component / safety role | Failure consequence | Approved replacement path exists? | Lead/support risk | Unsafe shortcut pressure | Action |
|---|---|---|---|---|---|
| | | | | | |

Examples of shortcut pressure to expose, not normalize: bypassing a failed interlock, fitting a similar relay because the connector matches, defeating EDM to use an available contactor, substituting a non-equivalent valve, or leaving a safeguard unavailable while production continues.

**Human-factors rule:** make the approved replacement path easier to find and execute than the unsafe workaround. Clear bin state, evidence links, quarantine controls and pre-reviewed successors reduce pressure to improvise.

## 9. Quarantine control

Quarantine is an engineering state, not merely a shelf location.

For every quarantined item record:

- exact physical identity and quantity;
- reason for quarantine;
- affected safety function(s);
- evidence gap or observed defect;
- whether the item can be confused with approved stock;
- physical segregation/labeling method;
- owner for disposition;
- evidence required to release it;
- final disposition: approved, repaired/revalidated, returned, scrapped, retained for investigation, or other controlled outcome.

Do not return a part from quarantine merely because an urgent breakdown occurs.

## 10. Inventory discrepancy failure paths

Challenge the audit against these cases:

1. Correct bin label, wrong hardware revision inside.
2. Two successor generations mixed under one old MPN description.
3. Safety controller spare has the right MPN but incompatible firmware/toolchain.
4. Light-curtain spare is a functional successor with different mounting/configuration dependencies.
5. Contactor has matching coil voltage/current rating but different feedback/contact architecture.
6. Hydraulic valve looks equivalent but the exact safety-related spool/monitoring behavior is undocumented.
7. Cannibalized device still carries configuration from another machine.
8. CMMS says one approved spare exists; physical unit is missing.
9. Physical spare exists; controlled configuration/backup media is missing.
10. Packaging is unopened but product-specific storage/aging evidence is absent.
11. Quarantined part can be accidentally picked because it remains in the normal bin.
12. A missing approved spare creates pressure to bypass a guard/interlock or use a merely similar substitute.

For each applicable case, preserve the evidence label and unresolved `UNKNOWN`s.

## 11. Reconciliation disposition

| Item / bin | State before | Audit finding | State after | Required action | Owner / evidence link |
|---|---|---|---|---|---|
| | | | | | |

Allowed state transitions should remain consistent with the lifecycle worksheet: `UNREVIEWED`, `QUARANTINE`, `APPROVED-SPARE`, `INSTALLED-PENDING-VALIDATION`, `IN-SERVICE-VALIDATED`, `FAILED / INVESTIGATION`.

An inventory audit may establish or withdraw **spare readiness**. It cannot establish `IN-SERVICE-VALIDATED` for an uninstalled part.

## 12. LinuxCNC / FPGA / CMMS boundary

Ordinary LinuxCNC, HAL, FPGA, HMI, ERP, CMMS or inventory software may improve traceability by storing identity, stock state, configuration hashes, lifecycle evidence and validation records. It may alert when an approved spare is missing or quarantined. That convenience does not make ordinary software personnel-safety authority and does not validate the physical hazardous-energy boundary.

## 13. Audit closeout

- [ ] Physical quantities reconciled to records.
- [ ] Mixed lots/revisions separated or explicitly bounded.
- [ ] Unidentified/unknown-provenance parts quarantined.
- [ ] Storage/aging findings dispositioned using product-specific evidence.
- [ ] Programmable-spare configuration packages checked.
- [ ] Lifecycle/successor changes routed to equivalence review.
- [ ] Missing approved spares and resulting unsafe-shortcut pressure recorded.
- [ ] Quarantine physically prevents accidental normal picking.
- [ ] Evidence records/bin labels updated without calling uninstalled parts `SAFE` or `VALIDATED`.

Unresolved safety-relevant `UNKNOWN`s:

Required procurement/engineering actions:

Reviewer/date:

## Next-work checkpoint

Build a **maintenance emergency substitution decision tree** that starts from `approved spare unavailable` and forces controlled choices: stop/out-of-service, exact/direct replacement search, engineered equivalence review, temporary safe state, or escalation. It must explicitly reject bypassing personnel-safety functions merely to restore production and must keep physical hazardous-energy control separate from inventory/CMMS status.