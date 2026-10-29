# 4400-G0-BOARD-01 — One-screen evidence and owner-action board
**2026-10-26 | public status-only template | NOT a machine inspection, commissioning approval, or test**

## Why this exists
The canonical [G0 physical witness intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) is a deep technical reference; the [seven-packet Stage A request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) is the actual first-contact entry point. The [human-factors audit](../research/4400_G0_SELECTED_MACHINE_INTAKE_PROGRESSIVE_DISCLOSURE_HUMAN_FACTORS_AUDIT_2026-10-26.md) found that handing a shop technician the entire technical intake is an avoidable burden. This **single-screen board** tells a qualified owner what evidence is not yet verified in this public curriculum without exposing confidential machine design or pretending that a green software status proves safety.

## Current public board — all UNKNOWN (no qualified redacted public status; restricted receipt unknown)
| Packet | Question for qualified reviewer | Evidence state | Next owner role | Public evidence pointer |
|---|---|---|---|---|
| A | Which actual machine/revision/modes/devices? | UNKNOWN | Machine owner | No public status |
| B | Who can enter each hazard and where? | UNKNOWN | Designer + operator | No public status |
| C | Which independent safety logic and final elements actually stop Y1/Y2? | UNKNOWN | Safety/controls engineer | No public status |
| D | What physically holds the gravity-loaded ram and isolates stored energy? | UNKNOWN | Hydraulic/mechanical engineer | No public status |
| E | Which guards, protective geometry, escape and reset sightlines exist? | UNKNOWN | Safety designer | No public status |
| F | Which hazard-specific stop/hold/access/restart criteria apply? | UNKNOWN | Independent reviewer | No public status |
| G | How could a qualified isolated/remote witness be performed without exposure? | UNKNOWN | Qualified tester + owner | No public status |

**Gate display:** G0 **HOLD** · G1 **HOLD** · G2 **NOT RUN** · G3/G4 **NOT AUTHORIZED** · G5 **HOLD**. No personnel-exposed operation.

## Allowed evidence states
- **UNKNOWN:** no evidence, unresolved contradiction, or unverifiable claim; does not pass.
- **RECEIVED / UNREVIEWED:** an artifact exists in the restricted workspace; does not pass.
- **REVIEWED / IN-SCOPE:** qualified reviewer has matched exact identity/revision to one hazard/function; only that proposition may be credited.
- **N/A WITH PROOF:** dated as-built evidence confirms a *conditional* component/hazard is absent; never mark a fundamental STOP/HOLD/ACCESS/ENERGY/RESTART requirement N/A merely for convenience.
- **STALE / REOPENED:** relevant hardware, software, guard geometry, tooling or operating mode changed; dependent evidence must be re-evaluated.
- **CONTRADICTORY:** records disagree; explicit hold and named owner for resolution.

## Three handoff questions, not 91 fields
**1. What already exists?** Request existing BOM, manual, dated drawings, photos safely taken, safety-program revision and known maintenance records in a restricted workspace. No energized probing or new physical tests.

**2. What is missing?** The independent reviewer assigns each gap a named **role**, next documentary artifact and a private due date. Do not record personal identities, sensitive topology or machine drawings publicly. One clear status per packet beats a large ambiguous green checklist.

**3. What changes the decision?** A reviewer may mark G0 documentary readiness only after coherent Stage A/conditional Stage B evidence; that never itself proves physical stopping, load holding, personnel absence or maintenance isolation. Qualified physical validation remains a separate later gate.

## Minimal private status record schema (illustrative, not machine data)
`Packet ID | Evidence ID + revision | Received date | Reviewer role | Hazard/SF covered | State | Contradiction ID | Next artifact + owner role | Review date`

Publish only redacted status IDs, counts and gate disposition; preserve real evidence in a restricted machine workspace. Do not publish terminal wiring, hydraulic truth tables, plant location, credentials or personal information.

## Failure/shortcut resistance
If a guard is frequently removed, a reset is unreachable without entering a hazard, or a support requires awkward tools, assign an **engineering usability defect** rather than telling the operator to be more careful. A diagnostic status cannot substitute for actual independent Y1/Y2 stop/hold, and a document upload cannot substitute for validation. A bypass, missing positive support or unresolved energy zone keeps the affected essential gate HOLD.

## Verification and limitation
**SOURCE-CONFIRMED (repository):** the canonical long intake and Stage A request exist; the documented staged-intake process is already in place. **INFERENCE:** this board may improve response/closure and reduce unsafe shortcuts. **TEST-CONFIRMED:** no measured operator adoption or completion improvement. **UNKNOWN:** all OpenPressBrake evidence packets and qualified acceptance. To test this process improvement later, compare time-to-first-complete Stage A packet and contradiction-closure rate without weakening the physical gate.

**Next:** send Stage A to qualified owner privately; collect and review existing evidence; expand only applicable Stage B sections; schedule independent evaluation separately. No machine test or personnel exposure is authorized by this template.


## 2026-10-28 source-provenance hygiene
The [Stage A first-contact request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) was shortened after its accumulated OEM/standards appendices grew to 14,994 characters. All nine dated conditional source headings are now in the [qualified reviewer archive](4400_G0_STAGE_A_DATED_SOURCE_DELTA_ARCHIVE_2026-10-28.md); the [source-grounded audit](../research/4400_G0_STAGE_A_FIRST_CONTACT_APPENDIX_CREEP_AND_PROVENANCE_REFACTOR_AUDIT_2026-10-28.md) records before/after integrity. Continue using this one-screen board for **status only**, the seven-packet A–G request for **first contact**, and the archive/long intake only for **qualified conditional review**. No qualified public status established; restricted receipt UNKNOWN; G0/G1 HOLD.

**Provenance:** [G0-PROVENANCE-01](../research/4400_G0_PROVENANCE_01_PUBLIC_STATUS_ABSENCE_VS_RESTRICTED_EVIDENCE_UNKNOWN_POINT_OF_USE_CORRECTION_2026-10-29.md): private receipt UNKNOWN; public status unverified; G0/G1 HOLD.
