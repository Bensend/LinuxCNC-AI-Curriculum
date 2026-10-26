# 4400-G0-HF-01 — An evidence intake can itself become a safeguard-defeat pressure

**2026-10-26 | Original repository process audit / safety human factors | NON-GRADUATED.** This is a curriculum-workflow correction, not a machine safety validation or claim that a specific worker bypassed anything.

## Concrete evidence, not speculation
Read [canonical selected-machine physical witness intake](../safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) and [one-page G0 request](../safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) at the same repository revision. **Repository-content count at this session:** canonical intake **98,726 characters, 374 lines, 76 Markdown headings, 91 distinct IN-identifier strings**; first-contact request **4,536 characters, 28 lines**. These are **SOURCE-CONFIRMED for this repository snapshot** (not LinuxCNC runtime behavior). Counts include historical/conditional appendices and are not a claim of 91 universally required fields.

**Problem:** an owner faced with the full 98k-character intake before identifying installed components may abandon the process, give inaccurate "N/A" answers, or regard documentation as an obstacle to work. This is a **human-factors INFERENCE**, not an observed OpenPressBrake behavior. The existing short handoff is already a good mitigation; the course must make it the mandatory entry point and treat the long document as a **conditional technical reference**, not an operator checklist.

## Revised two-stage intake without weakening any safety gate
**Stage A — minimum non-invasive first contact:** ask for only the existing seven packets A–G in the one-page request: machine identity, people/hazards, actual independent safety path, hydraulic/load holding, installed safeguards, safety requirements, and proposed independent no-exposure proof logistics. Qualified owner returns **existing** drawings/manuals/photos/revision references to a restricted location. Do not ask a technician to derive PL, stop times, valve truth tables or to perform a test.

**Stage B — qualified targeted expansion:** independent reviewer first makes a **component-presence map** (installed / absent with dated evidence / unknown) and a **hazard-to-physical-proposition map** (STOP, HOLD, ACCESS, ESCAPE, ENERGY, RESTART). Only then open the exact relevant conditional sections of the canonical intake. Every optional branch must have an applicability witness and a source/owner; a product named in a manufacturer study does not make it installed.

| State | Meaning | Consequence |
|---|---|---|
| RECEIVED / UNREVIEWED | Artifact exists, no independent coherence check | G0 still HOLD |
| ACCEPTED / IN-SCOPE | Exact model/revision and physical proposition reviewed | Can support a specific G0 field, not G2 physical proof |
| N/A / EVIDENCED | Qualified as-built evidence proves component/hazard not present | Close only that conditional branch |
| UNKNOWN / CONTRADICTORY | Missing, conflicting, stale or unsupported | G0 HOLD for affected essential function |
| SUPERSEDED / STALE | Component, mode, software or structure changed | Reopen affected dependencies and proof |

**Critical rule:** absence of a gas strut, accumulator or named safety PLC is **not** proof that Y1/Y2 independent stopping, hydraulic load holding, guarding or personal energy isolation is adequate. The essential G0/G1 release gates are never reduced by triage.

## Low-friction safety engineering actions
- Make the one-page request the default first-contact link; do not hand a shop technician 91 identifiers.
- Ask for *what already exists* (BOM, OEM drawings, maintenance manual, photos taken without exposure) rather than inventing new measurements.
- Provide a reviewer-generated one-screen status: **what received, what contradictory, what blocks release, who owns next evidence**. Never use a single green "READY" as physical proof.
- Keep sensitive as-built details in a restricted machine workspace; publish only redacted evidence IDs/status.
- Require independent reviewer and operator/maintainer usability review before G0 completion. Unclear guard access or hard-to-engage restraints are design issues, not merely training defects.
- Preserve the full canonical technical intake for qualified follow-up, so staged collection cannot become a shortcut to commissioning.

## Source hierarchy and open questions
**SOURCE-CONFIRMED (repository):** document counts and existence of A–G first-contact request. **DOC-CONFIRMED:** [OSHA 1910.147(d)(5)–(6)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) stored-energy control/verification; existing [G0 intake](../safety-course/4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) and [course research plan](../SAFETY_COURSE_RESEARCH.md) are curriculum design, not external standards. **INFERENCE:** overload/bypass risk and staged-collection benefit. **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none; **UNKNOWN:** actual owner completion time, errors, bypass frequency, selected-machine evidence and qualified acceptance. Measure Stage A completion and contradiction closure in a future real intake before claiming the redesign improves outcomes.

**G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** No live test or personnel-exposed operation authorized.
