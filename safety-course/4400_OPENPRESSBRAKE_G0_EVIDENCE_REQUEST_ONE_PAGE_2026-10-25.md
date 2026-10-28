# OpenPressBrake — minimum G0 documentary evidence request (one-page field handoff)
**2026-10-25 | 4400 safety | GENERIC PUBLIC REQUEST TEMPLATE | NO SELECTED-MACHINE EVIDENCE RECEIVED**

**Purpose:** break the repeated “physical proof UNKNOWN” deadlock by asking the actual qualified machine team for a *small, versioned, restricted* evidence package. This is **not** an energized test instruction, release authorization, or request to publish proprietary drawings. Use the full [selected-machine intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) for detailed acceptance.

## Request to qualified OpenPressBrake owner/team
| Packet | Minimum artifact (retain in restricted machine workspace) | Owner role | State |
|---|---|---|---|
| A — Identity | As-built machine/revision, active modes, major retrofit changes, actual front/rear equipment and installed safety devices | Machine owner / maintainer | **MISSING / UNKNOWN** |
| B — Hazard map | Who can be at front dies, rear backgauge, side/under ram, tool change, jam clearing and rescue; part whip and helper exposures | Designer + operator | **MISSING / UNKNOWN** |
| C — Safety path | Selected safety controller and configuration revision; guard/E-stop/foot/reset inputs; outputs and exact physical final elements; **separate** LinuxCNC/FPGA normal commands | Qualified safety/controls engineer | **MISSING / UNKNOWN** |
| D — Hydraulic/hold | Actual Y1/Y2 chambers, valves and part suffixes, pressure/accumulator zones, gravity-restraint path, independent load holding method and isolation points | Hydraulic engineer | **MISSING / UNKNOWN** |
| E — Guards | Exact front/side/rear guard/laser model and configuration; protective geometry/blanking/muting; backgauge access, escape and reset sightline | Safety designer | **MISSING / UNKNOWN** |
| F — Stop/hold/rearm SRS | Hazard-specific STOP, HOLD, ACCESS, ENERGY, RESCUE and deliberate fresh START requirements, applicable press-brake standard/edition, independent witness/acceptance basis | Independent safety reviewer | **MISSING / UNKNOWN** |
| G — Proof logistics | Proposed **no-person-exposure** measurement method, competent tester, physical exclusion, secondary restraint, instrument/calibration plan, abort/containment and emergency response | Qualified tester + owner | **MISSING / UNKNOWN** |

## First review decision (no power)
1. **Inventory only:** collect existing dated photos, BOMs, drawings, safety-PLC export and OEM manuals in the **restricted** project. No connector substitutions, hydraulic disassembly, guard defeat or energized experiments.
2. **Reconcile:** reviewer maps each hazard to safety function, physical final element and independent witness; mark contradictions and missing pressure zones explicitly. Do not treat a “safe” HMI bit or one zero gauge as physical proof.
3. **Fix usability before commissioning:** interview an operator and maintainer about guards they remove, hard-to-see resets, slow die changes, sheet handling and jam access. Prioritize guard/fixture redesign that makes the safe workflow easier than bypass.
4. **Release only a decision:** qualified reviewers may mark **G0 documentary readiness** when all required evidence is coherent. G0 is **not** G1 isolated-test permission, G2 physical proof, G3 personnel-exposed operation or G4 maintenance entry.
5. **No G0 evidence received:** remain **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**. If experimental operation is ever justified, a separate qualified remote/isolated plan must keep people outside the danger zone and state residual risk.

## What the public curriculum may receive
A **redacted status-only** record: artifact IDs and revision hashes (not secrets), owner role, date, hazard/safety-function coverage, unresolved contradiction count, and pass/hold decision. Do **not** copy proprietary machine drawings, precise terminal mapping, sensitive plant locations, personal contacts, or unsafe test procedures into the public repository.

**Source/evidence status:** request design = **INFERENCE** based on OSHA 1910.212/1910.147 and the existing 4400 intake. No selected machine **DOC-CONFIRMED** evidence, **TEST-CONFIRMED** result, performance level, hydraulic truth table, stopping distance or pressure value is asserted. See [GUARD-01 source scope audit](../research/4400_OSHA_CPL_1997_PRESS_BRAKE_SAFE_DISTANCE_SUPERSESSION_AND_JOB_SHOP_SCOPE_AUDIT_2026-10-25.md) for why a historic “safe distance” shortcut does not close the front/rear/ram safety proof.


## 2026-10-26 first-contact clarification — progressive disclosure
**This one-page A–G request is Stage A.** Do **not** ask the shop owner/operator to complete every conditional field in the ~99k-character technical intake before first contact. A qualified reviewer first maps installed components, hazard zones and independent physical safety propositions; only then opens applicable conditional sections as **Stage B**. Mark absent components **N/A only with dated as-built evidence**, not from assumption; missing/contradictory essential Y1/Y2 stop/hold, hydraulic isolation, guarding or restart evidence still means **G0 HOLD**. See [source-based intake usability audit](../research/4400_G0_SELECTED_MACHINE_INTAKE_PROGRESSIVE_DISCLOSURE_HUMAN_FACTORS_AUDIT_2026-10-26.md). This is a collection-sequence improvement, **not** a reduction in safety requirements or permission for live testing.


## Conditional Stage B pointer — hydraulic only
If qualified Stage A confirms hydraulic Y1/Y2 or another relevant hydraulic hazard, use the short [ten-field hydraulic Stage B restricted evidence card](4400_OPENPRESSBRAKE_G0_STAGE_B_HYDRAULIC_ONLY_RESTRICTED_EVIDENCE_CARD_2026-10-26.md). It requests **existing** as-built records only and separates hold, bleed, personal isolation and restart. If hydraulic equipment absent, require dated qualified N/A proof. This is not permission for live testing and does not relax G0/G1 HOLD.

## Reviewer-only source annotations (not part of the owner request)

For applicable, dated source-depth clarifications—**ISO 6909:2026 and EU transition, safety-program identity, guard fasteners, structural eccentric/stripping loads, workpiece ejection, optional crowning and hydraulic temperature/heater hazards**—use the [preserved Stage A dated source-delta archive](4400_G0_STAGE_A_DATED_SOURCE_DELTA_ARCHIVE_2026-10-28.md). This keeps the owner-facing A–G request short and avoids asking for irrelevant equipment. All optional equipment remains **UNKNOWN** unless identified from the selected as-built machine; N/A requires qualified dated evidence. This move changes **presentation only**, not the release criteria or any source claim.

**Gate remains:** G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed operation.
