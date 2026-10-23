# Safety Design Package — Cross-Course Traceability Template

Status: CANONICAL LEARNER WORKING PACKAGE TEMPLATE
Applies: 2520 through 25F0

This package is cumulative. Do not restart it at each course. Preserve stable IDs and provenance. If an upstream item changes, review and mark dependent downstream items STALE until re-verified/revalidated.

## Route-continuity invariant

Every 2520–25F0 learner route operates on this same cumulative package. On entry to each course, review the current upstream IDs, provenance, status, residual risks and UNKNOWNs. New course work must declare dependencies on those IDs rather than silently copying assumptions into unlinked prose. Before handoff, run the stale-dependency check.

A local module worksheet is not sufficient if its claims cannot be traced through this package. `UNKNOWN`, `RETIRED`, `STALE`, residual-risk and operational-restriction state persist until explicitly closed with evidence; omission in a later module does not close them.

If a human-factors change, architecture choice, machine-transfer assumption, requirement edit, boundary change or new energy/hazard materially changes an upstream item, create a `CHG` record and review affected dependents before crediting old evidence.

## Claim/provenance labels

Use only: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

A controller indication may be evidence for a controller proposition; it is not automatically evidence for a physical safe-state proposition.

## Stable ID families

- `BND-###` machine/lifecycle boundary
- `ENE-###` hazardous-energy source
- `HAZ-###` hazardous event/exposure
- `SF-###` required safety function
- `PHY-###` physical safe-state proposition
- `SRS-###` safety requirement
- `AUTH-###` authority allocation
- `DEP-###` dependency/common-cause assumption
- `HF-###` human-factor/foreseeable-defeat finding
- `ARC-###` architecture decision
- `VAL-###` verification/validation case
- `PT-###` proof-test/inspection item
- `CHG-###` change/revalidation record
- `RR-###` residual risk
- `UNK-###` unresolved fact

Never recycle an ID after deletion; mark it RETIRED with rationale.

## 1. Machine and lifecycle boundary

| ID | Machine/system included | Lifecycle/mode | People/exposure | Interfaces excluded or external | Provenance | Status |
|---|---|---|---|---|---|---|

## 1A. Standards and manufacturer-instruction applicability

| BND/UNK ID | Machine class and jurisdiction | Regulation/standard and exact edition | Applies to this machine/task? Basis | Manufacturer product/manual revision | What the cited source does NOT establish | Status |
|---|---|---|---|---|---|---|

Before transferring a safety rule or numeric criterion between machine types, verify its actual scope. **OSHA 29 CFR 1910.217(a)(5) expressly excludes press brakes** from that mechanical-power-press section; OSHA 1910.212 addresses general machine guarding and OSHA's press-brake interpretation identifies 1910.212(a)(3)(ii). Thus 1910.217 PSDI clauses may be useful hazard analogies but must not be represented as binding press-brake clauses. Evidence: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217 ; https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212 ; https://www.osha.gov/laws-regs/standardinterpretations/1986-05-27 . Record product instructions separately from legal requirements; do not infer uninspected consensus-standard provisions.

**2026 press-brake scope update:** ISO 6909:2026 was published 2026-05-29. Its official abstract defines included/excluded drive and machine types and states non-applicability to press brakes manufactured before publication. This is a DOC-CONFIRMED scope finding, not an inspected technical-clause or legal-applicability conclusion. Preserve the machine-specific applicability decision as BND/UNK evidence. Source: https://www.iso.org/standard/83403.html ; audit: `research/ISO_6909_PUBLIC_SCOPE_NOTE_2026-10-11.md`.

## 2. Hazardous-energy register

| ID | Energy source | Stored/generated/transmitted how | Isolation/control point | Residual/stored-energy concern | Related hazards | Provenance |
|---|---|---|---|---|---|---|

## 3. Hazardous events and exposure

| ID | Hazardous event | Person/task/mode | Initiating conditions | Potential consequence | Existing measure | Related energy IDs | Provenance |
|---|---|---|---|---|---|---|---|

## 4. Safety functions and physical propositions

| SF ID | HAZ IDs | Required protective behavior | PHY IDs | Trigger/demand | Reset/restart constraint | Assumptions/UNKNOWNs |
|---|---|---|---|---|---|---|

| PHY ID | Physical proposition that must become true | What does NOT prove it | Candidate physical witness | Provenance | Status |
|---|---|---|---|---|---|

## 5. SRS

| SRS ID | SF/PHY IDs | Requirement | Modes/preconditions | Acceptance criterion | Integrity target/source or UNKNOWN | Dependencies | Status |
|---|---|---|---|---|---|---|---|

Do not invent PL/SIL, stopping distance/time, pressure threshold, diagnostic coverage, safe speed or proof-test interval.

## 6. Authority allocation

| AUTH ID | SRS IDs | Normal LinuxCNC/HAL/FPGA role | Monitoring/diagnostics role | Independent safety-related control | Physical final element / mechanical protection | Personnel-safety authority owner |
|---|---|---|---|---|---|---|

Ordinary LinuxCNC/HAL/FPGA logic may command, request, display or diagnose safety-related state. Do not assign it personnel-safety authority merely for convenience.

## 7. Dependencies and common-cause paths

| DEP ID | Dependent SRS/ARC/VAL IDs | Shared dependency or assumption | Failure/common-cause mechanism | Detection/mitigation | Provenance | Status |
|---|---|---|---|---|---|---|

Include shared power, reference, wiring/connector, pilot pressure, hydraulic supply, software/configuration, environmental exposure, routing and maintenance dependencies where applicable.

## 8. Human factors / foreseeable defeat

| HF ID | Safeguard/task | Foreseeable shortcut or defeat | Why user would be motivated | Consequence | Design change making safe path easier | Related SRS/ARC IDs | Status |
|---|---|---|---|---|---|---|---|

Inconvenience that predictably encourages defeat is a design input, not an excuse to blame the operator.

**Task-based defeat-incentive evidence:** for common safeguarded work (load/unload, nuisance-trip recovery, setup/jam clearing, and guard maintenance), document the legitimate workflow, visibility, observed time/friction, operator/maintainer feedback and the concrete incentive to bypass. Propose captive hardware, repeatable alignment, accessible diagnostics, approved setup access and convenient safe restoration **without reducing the independently required protective function**. If the work has not been observed, record `UNKNOWN` rather than inventing time savings. Link any redesign to `CHG/DEP/SRS/PHY/VAL` and mark dependent evidence STALE until revalidated. Official IFA/DGUV MaSeM methodology is DOC-CONFIRMED for task/mode/benefit assessment; no site assessment is implied. Learner worksheet: `4400_GUARD_DEFEAT_INCENTIVE_DESIGN_REVIEW_2026-10-22.md`.

## 9. Architecture decisions

| ARC ID | SRS IDs | Selected architecture | Rejected alternative | Failure paths addressed | Remaining dependencies/UNKNOWNs | Source/provenance | Status |
|---|---|---|---|---|---|---|---|

Keep stopping, isolation, stored-energy discharge, load holding/restraint and access prevention separate unless evidence justifies combining them.

## 10. Verification / validation matrix

| VAL ID | SRS/PHY IDs | Verification or validation | Precondition/mode | Stimulus/fault | Expected independent response | Required physical witness | Acceptance criterion | Result/evidence | Status |
|---|---|---|---|---|---|---|---|---|---|

Use `NOT RUN`, `PASS`, `FAIL`, `BLOCKED`, or `STALE` for execution status. A software/status indication cannot substitute for the physical witness unless the SRS proposition is specifically about that indication.

**Diagnostic-source validity gate:** if a `VAL` or HMI evidence item relies on a device/event tag, record exact product/firmware/manual, whether it is live state or first/historical event, data validity/age, interface mode, raw value and physical zone mapping. A field that defaults to zero when a channel is inactive cannot be decoded as a live guard-state bitmap. Manufacturer example: Rockwell 440R-ENETR Series B `440R-UM009E-EN-P` (February 2026), Table 5: `Active=0` forces other GuardLink tags to zero and `DeviceFault=6` has an unresolved bit-mapping interpretation relative to `DeviceTrip`. See `research/4400_440R_ENETR_2026_TABLE5_DIAGNOSTIC_QUALITY_GATE_2026-10-23.md` and `safety-course/4400_GUARDLINK_DIAGNOSTIC_DECODER_ADVERSARIAL_WORKSHEET_2026-10-23.md`. These are DOC-CONFIRMED documentary distinctions plus INFERENCE for display design, **not** machine safe-state evidence.

## 11. Commissioning / proof test / inspection

| PT ID | SRS/VAL IDs | Latent failure sought | Method | Interval/trigger and basis | Acceptance | Evidence | Status |
|---|---|---|---|---|---|---|---|

If an interval lacks a justified basis, record `UNKNOWN`; do not invent a calendar interval.

## 11A. Maintenance energy-control continuity

When servicing can expose people to hazardous energy, link the production safety-function evidence to the separate maintenance energy-control record. Preserve the chain from hazardous-energy source and actual isolating mechanism through residual/stored-energy disposition, verification, any credible reaccumulation, any bounded test/positioning transition, re-isolation, personnel/shift handoff where applicable, and final restoration/release evidence.

Do not treat a production interlock, controller inhibit, feedback indication, previous-shift verification, or group coordinator status as a substitute for the narrower physical/personnel-control proposition it does not prove. Carry relevant ENE/SRS/PHY/AUTH/DEP/ARC/HF/VAL/PT/CHG/UNK IDs and mark affected evidence STALE after a material change until reviewed.

**Manual hydraulic isolation versus dynamic safety stopping:** manufacturer-documented ROSS H L-O-X manual lockout valves illustrate a padlockable OFF state, optional A-port pressure indication and separate downstream-bleed/pump-bypass connections. These are DOC-CONFIRMED product-family functions, **not** proof of every cylinder chamber, accumulator, pilot line or gravity-loaded ram state. An optional OFF limit switch or one zero gauge is not a substitute for independent physical restraint/pressure-zone verification. A manual padlocked isolator is not an automatically actuated E-stop final element. See `research/4400_ROSS_HLOX_MANUAL_ISOLATION_VS_RAM_PROOF_SOURCE_NOTE_2026-10-22.md`; the selected hydraulic truth table and actual maintenance release remain UNKNOWN.

## 11B. Whole-body-access and reset/restart continuity

For machines large enough to enter, retain one linked record from access geometry to restart authorization. A cleared entry field, closed gate, available escape release, successful reset, and proof that no person remains exposed are **distinct propositions**.

| Linked package IDs | Required machine-specific evidence | Status / UNKNOWN |
|---|---|---|
| BND/HAZ | Entry/egress paths, blind spaces, persons/tasks/modes, credible person remaining inside after entry field clears | |
| SF/PHY | Actual protection/occupancy proposition; what guard-closed, field-clear and controller indications do not prove | |
| SRS | Independent protective demand, deliberate reset, separate ordinary start, retained start, power loss/restoration and reset-fault behavior | |
| AUTH/ARC | Safety-related decision owner, final energy-removal/holding elements, normal LinuxCNC/FPGA role | |
| DEP/HF | Reset visibility/location, sensing blind zones, escape, personal restart prevention, common dependencies and foreseeable bypass pressure | |
| VAL/PT | Trapped-person/field-clear contradiction, guard restoration, reset with incomplete visibility, retained start, power restoration and independent physical witness | |
| UNK/RR/CHG | Unmeasured geometry/coverage, unresolved manufacturer instructions, operational restriction and stale downstream evidence | |

SICK S300 instructions distinguish scanner reset/OSSD restoration from the external restart interlock and require an outside reset location with full view for the documented application (S300 8010948/ZD09/2024-09-12, https://www.sick.com/media/docs/3/13/613/Operating_instructions_S300_Safety_laser_scanner_en_IM0017613.PDF). This is **product/application-specific DOC-CONFIRMED** evidence, not generic proof of occupancy or a universal machine requirement. An adversarial `VAL-*` shall consider a person remaining inside after the initiating field clears, with an ordinary start request retained; guard/field restoration or reset alone must not receive credit for an unproved physical proposition. If minimum protection is not established, block exposed-person operation and limit experiments to isolated/remote conditions.

## 11C. Guard-topology change causal-proof continuity

For a new, moved or replaced guard, the physical device's presence, successful discovery, node count, displayed channel status and a stopped machine are **not individually proof** that the guard participates in the required protective function. The 432ES-IG3 manufacturer documents an append-node sequence that, if not followed, can leave an added device inactive; see `research/4400_432ES_APPENDED_NODE_INACTIVE_SAFETY_FUNCTION_SOURCE_TRACE_2026-10-23.md` and the learner `4400_GUARDLINK_NODE_CHANGE_PHYSICAL_PROOF_TECHNICIAN_CARD_2026-10-23.md`. This is a **product/revision-specific DOC-CONFIRMED example**, not a generic protocol procedure or physical test result.

| Linked IDs | Change-control / causal-proof obligation | Status |
|---|---|---|
| `CHG/DEP/ARC` | Capture as-built guard→node→channel→safety program→zone mapping, terminator/cable, catalog/firmware and any reused tags; mark dependent evidence STALE. | UNKNOWN |
| `BND/HAZ/SF/SRS/PHY` | Specify which person/exposure/mode is protected and the distinct required controller and physical safe-state propositions. | UNKNOWN |
| `AUTH` | Identify independent safety controller, output and final elements; normal LinuxCNC/FPGA/HMI remains diagnostic/request-only. | UNKNOWN |
| `VAL-input` | In an approved isolated/low-energy test, record other active protective demands and demonstrate the **new guard's causal** safety demand, not merely `guard open` coinciding with `output OFF`. | NOT RUN |
| `VAL-physical/PT` | Separately witness actual selected-machine stopping/holding/access/energy response, fault recovery, power restoration, deliberate rearm and separate fresh ordinary start. | NOT RUN |
| `HF/UNK/RR` | Review alignment, maintenance access, visible fault localization, bypass incentives, unresolved machine-specific limits and operational restrictions. | OPEN |

**Masking counterexample:** Guard B is already open and the safety output is already OFF; opening newly installed guard A leaves the output OFF. That observation cannot prove A participates. Do not defeat B to manufacture a favorable result. If an unmasked causal test cannot be performed safely, mark the proof BLOCKED and withhold personnel-exposed operation. Configuration capability (including manufacturer-permitted online changes) does not waive physical revalidation or maintenance isolation requirements. No safety integrity level, hydraulic truth table, stop distance or machine release is inferred from this example.

**Series-contact fault-masking gate:** where multiple two-channel passive guard contacts are wired in series, do not credit the aggregate receiver inputs as per-guard contact integrity. For two guards, `R1=A1 AND B1`, `R2=A2 AND B2`; if `A1` sticks conducting and B opens first, both receiver inputs can remain equally OFF while A opens/closes, then return equally ON when B closes. This is a deductive settled-state counterexample, **not** proof of any selected relay's pulse/timing/fault-latch behavior. Record exact topology, guard opening order/frequency, selected receiver diagnostics, fault memory, common dependencies and required integrity; consult ISO 14119:2024 Annex J and applicable licensed text before any formal claim. Source: `research/4400_ISO14119_2024_SERIES_FAULT_MASKING_EDITION_AND_LOGIC_2026-10-23.md`; exercise: `safety-course/4400_GUARD_SERIES_ORDERED_FAULT_MASKING_FIELD_EXERCISE_2026-10-23.md`. No numeric DCavg/PL, machine stop/hold or personnel-exposed validation follows from this Boolean example.

## 12. Change and revalidation ledger

| CHG ID | Changed item | Reason | Upstream IDs affected | Dependents marked STALE | Required review/retest | Closure evidence | Status |
|---|---|---|---|---|---|---|---|

### Stale-dependency rule

When `BND`, `ENE`, `HAZ`, `SF`, `PHY`, `SRS`, `AUTH`, `DEP`, `HF`, or `ARC` content materially changes:

1. identify every downstream ID that declares that dependency;
2. mark its status `STALE`;
3. retain old evidence for history but do not credit it as current proof;
4. review/re-run only the affected verification/validation/proof items;
5. close the `CHG` record only when the current dependency chain is again justified.

## 13. Residual risk and UNKNOWN register

| ID | Related IDs | Residual risk or unknown fact | Why unresolved | Evidence needed | Operational restriction meanwhile | Owner/status |
|---|---|---|---|---|---|---|

If a basic safe-to-operate proposition is not established, do not expose people to the hazard during experimental operation. Use isolated/remote testing with people outside the danger zone and state residual risk plainly.

## 14. Course handoff map

| Course | Primarily creates/refines | Must consume/check |
|---|---|---|
| 2520 | BND, ENE, HAZ, UNK | prior machine facts/source provenance |
| 2530–2590 | SF, PHY foundations, reset/isolation/guard/diagnostic constraints | BND, ENE, HAZ, UNK |
| 25A0 | PHY, SRS, acceptance propositions | SF plus all upstream hazards/assumptions |
| 25B0 | AUTH, ARC, DEP | SRS/PHY and upstream assumptions |
| 25C0 | DEP, fault/diagnostic refinements, VAL candidates | architecture and physical propositions |
| 25D0 | ARC alternatives/cost decisions, HF refinements | failure paths, CCF and SRS |
| 25E0 | VAL, PT, CHG and commissioning evidence | SRS/PHY/ARC/DEP/HF |
| 25F0 | machine-transfer deltas across all fields | complete package; retain machine-specific UNKNOWNs |

Detailed route-to-package audit: `research/SAFETY_COURSE_ROUTE_TO_TRACEABILITY_PACKAGE_AUDIT_2026-09-24.md`.

## 15. Evaluator package boundary

For an information-separated evaluation, the evaluator may receive the learner's submitted package and learner-visible source/evidence context. The evaluator must not reveal hidden expected architecture, preferred fault tree, scoring key, machine-specific hidden answer or sealed benchmark resolution before learner commitment.

Evaluation should include whether the learner preserved traceability, handled dependencies/stale evidence correctly, used evidence appropriate to physical propositions, retained UNKNOWNs/residual restrictions and preserved the normal-control / diagnostics / independent-safety / physical-final-element authority boundary.

## 16. Release checklist

Before a learner package is eligible for fresh evaluation:

- every safety-relevant architecture decision traces to an SRS and hazard;
- every SRS traces to a physical proposition or explicitly justified non-physical requirement;
- every credited validation has an acceptance criterion and appropriate witness;
- no stale evidence is counted as current proof;
- maintenance/isolation and restart/rearm are represented;
- common-cause and human-defeat paths are represented;
- residual risks and UNKNOWNs remain visible;
- normal control, diagnostics, independent safety control and physical final elements remain explicitly separated;
- any unmet minimum safe-to-operate proposition produces an operational restriction rather than optimistic inference.
