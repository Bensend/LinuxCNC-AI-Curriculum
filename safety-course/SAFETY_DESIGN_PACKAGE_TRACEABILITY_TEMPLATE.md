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

**Guard egress mechanical qualification:** where a guard lock/inside escape is selected, independently witness guard retained under required load, release actuation, actual door opening, unobstructed exit, and separately proven machine stopping/holding. A low OSSD, healthy lock signal, or valid catalog holding-force figure cannot establish a physically passable escape path. Treat changed brackets, hinges, actuator, cabling, access geometry and release route as `CHG/DEP` invalidating relevant `VAL/PT`. Use `safety-course/4400_GUARD_EGRESS_DEPENDENCY_CHANGE_WORKSHEET_2026-10-22.md` with `research/4400_GUARD_RELEASE_STOP_REQUEST_VS_PHYSICAL_EGRESS_2026-10-22.md`. Do not test a trapped-person case with anyone exposed to live hazards.

## 11D. Guard diagnostic/reset data-quality and physical-rearm contract (4400)

**Manufacturer-specific documentary example, not a selected-machine SRS:** Rockwell 440R-UM009E-EN-P (February 2026) printed Table 2 p. 39 gives `Reset1` a 0.25–3 s pulse, while Table 6 p. 44 prints 250–3000 **s** for reset-held diagnostic 03. The unit labels conflict; preserve as `UNK`, not an automatic reset setting. Table 5 p. 43 describes `DeviceTrip` operational-node bitmap and suggests XOR with `DeviceCount` for all diagnostics, but a trip need not mean a diagnostic fault. Do not treat XOR as a validated all-faults decoder. Source audit: `research/4400_ENETR_RESET_UNITS_AND_DIAGNOSTIC_XOR_CONFLICT_2026-10-23.md`.

| Package ID | Required qualification | Release status |
|---|---|---|
| `ARC/DEP` | Record selected 440R-ENETR Series B versus 432ES CIP Safety architecture, exact relay/tap/firmware/AOP, supply, topology, reset and feedback dependencies. | UNKNOWN |
| `AUTH/SRS` | Keep non-safety ENETR/HMI command and diagnostic roles separate from independent safety rearm; distinguish relay reset, relay/tap power-cycle, lock request and fresh ordinary start. | UNKNOWN |
| `SRS/UNK` | Resolve reset duration against selected relay manufacturer instructions; do not implement conflicting p. 44 literal seconds or assume monitored-reset semantics for all configurations. | OPEN |
| `DEP/VAL` | Distinguish link mode, data age/quality, per-node live state, first-trip event, historical fault, trip bitmap and confirmed fault bitmap. Zeroed inactive data is not healthy. | NOT RUN |
| `PHY/VAL/PT` | Witness independent final-element and physical stop/hold, guard/occupancy, energy isolation, power recovery and absence of retained-start restart. | NOT RUN |
| `CHG/HF` | After tap/firmware/guard replacement, invalidate dependent proof; show precise per-device fault and easy safe restoration instead of one-click indiscriminate fault reset. | OPEN |

A displayed green status, cleared fault, reset accepted or safety output OFF **cannot** establish physical safe state. The 440R-ENETR manual p. 75 explicitly identifies the interface as **non-safety-rated**; the distinct 432ES safety path requires its own selected controller and validation. See learner cards `4400_GUARDLINK_AUTHORITY_AND_RESET_ARCHITECTURE_CARD_2026-10-23.md` and `4400_GUARDLINK_FAULT_RECOVERY_CHANGE_CONTROL_WORKSHEET_2026-10-23.md`. No selected-machine physical proof or personnel-exposed operation is authorized.

**432ES diagnostic provenance supplement:** Rockwell 432ES-UM001E Table 6 calls `Ch0.Status` a SIL3/PLe safety bit in its documented 432ES architecture; `DeviceTripAddress` is the **first** cause of the last operational-to-safe transition, `Uncertain` marks questionable data, and `TerminatorFault` explicitly does not detect a missing terminator. The manufacturer Safety Device Library's fault rows 2–4 are historical, not live fault count. These facts cannot be transferred to the non-safety-rated 440R-ENETR or treated as physical machine proof. See `research/4400_432ES_FIRST_TRIP_UNCERTAIN_HISTORICAL_FAULT_TAG_SCOPE_2026-10-23.md` and `safety-course/4400_432ES_FIRST_EVENT_STALE_DIAGNOSTICS_TECHNICIAN_EXERCISE_2026-10-23.md`. Exact selected firmware and live `VAL/PT` remain UNKNOWN/NOT RUN.

## 11F. Hydraulic feedback-coverage and pressure-zone witness (4400)

**Manufacturer scope example:** HAWE D 6335 (2025) SAKB S version enumerates position monitoring on **two proportional directional valves, two holding valves and one 4/2-way valve**. The SAKB product family also includes two separate NSV suction/anti-cavitation valves, whose monitoring must be qualified from the selected NSV variant and its own wiring/feedback. The five-position list is **not** proof that the separate NSVs are monitored, and absence from that list is not proof they are never monitored. See `research/4400_HAWE_SAKB_FIVE_MONITORED_VALVES_VS_NSV_SOURCE_SCOPE_2026-10-23.md` and learner `4400_HYDRAULIC_COVERAGE_TECHNICIAN_CARD_2026-10-22.md`.

| Linked IDs | Machine-specific obligation | Status |
|---|---|---|
| `ARC/DEP` | Exact manifold S option, both NSV suffixes, sensors, feedback destinations, pilot pressure, hydraulic ports and shared dependencies | UNKNOWN |
| `PHY/SRS` | Distinguish valve-position feedback, actual physical ram/beam holding, pressure-zone state, gravity restraint and maintenance isolation | UNKNOWN |
| `VAL/PT` | Identify each gauge tap/volume, test only under qualified isolated procedures, independently witness load restraint and contradictions | NOT RUN |
| `CHG/HF` | Moved gauge, valve replacement or test-port redesign invalidates dependent evidence; make authorized pressure checks accessible without defeating guards | OPEN |

**Accumulator transfer:** HAWE D 7969 versus D 7571 families and OSHA 1910.147 require selected product and system energy-control review, not an assumption that `PUMP OFF`, `SAFE VALVE OK` or one `PRESSURE=0` tag proves all gas/fluid/trapped/load energy safe. See `4400_ACCUMULATOR_FAMILY_PRESSURE_ZONE_TECHNICIAN_EXERCISE_2026-10-22.md`. A contradictory independent beam-motion or pressure witness blocks the broader safe-state claim and rearm. Do not invent hydraulic truth tables, leakage rates, pressure limits or PL/SIL.

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

## 11E. Component-substitution and maintenance-reverification gate (4400)

**DOC-CONFIRMED product-family example:** EUCHNER CTP-I1 order 136595 explicitly provides **process-protection locking without safe guard-lock monitoring**, while CTP-L1 order 123375 documents a distinct guard-lock-monitoring characteristic. The published FZh value alone cannot substitute for a required safety function; the former uses M12 8-pin, the latter M23 19-pin. See `research/4400_EUCHNER_PROCESS_LOCK_VS_SAFETY_LOCK_MONITORING_2026-10-22.md` and learner `4400_EUCHNER_LOCK_SUBSTITUTION_ADVERSARIAL_2026-10-22.md`. Product claims are not selected-machine wiring, PL/SIL or physical acceptance.

| Linked IDs | Required evidence after guard-lock component replacement | Status |
|---|---|---|
| `SRS/PHY/AUTH` | Required **guard-position**, **guard-lock**, **safe-unlock** and independent machine stop/hold propositions separately; identify each safety authority owner. | UNKNOWN |
| `ARC/DEP/CHG` | Exact catalog and manual, connector/pin mapping, supply, mechanical actuator, lock-force application, controller/feedback dependencies; mark downstream proof STALE. | OPEN |
| `VAL/PT` | Causally witness new guard/lock participation and physical safe access, stopping/holding and escape without exposing people; no green `OL` or equal force shortcut. | NOT RUN |
| `HF/UNK/RR` | Convenient non-defeatable replacement/alignment, safe release and restoration workflow, unresolved risks and no exposed-person operation until minimum proof. | OPEN |

**DOC-CONFIRMED maintenance boundary:** OSHA 29 CFR 1910.147(b), (d), (e), (f) distinguishes physical energy isolation, stored energy and reaccumulation, worker protection, temporary powered positioning and restoration from production E-stop or HMI reset. A powered test invalidates the previously verified isolation state for subsequent service; re-isolate and re-verify. See `research/4400_OSHA_LOTO_TEST_POSITION_REISOLATION_STATE_MACHINE_2026-10-23.md` and learner `4400_LOCKABLE_ISOLATOR_TAGOUT_RETROFIT_TECHNICIAN_CARD_2026-10-22.md`. Exact applicability, installed hydraulic topology, gravity restraint and machine validation remain UNKNOWN/NOT RUN.

**Secondary hazard:** a front AKAS laser/device test cannot independently prove sheet-sweep, frame pinch or ejection hazards controlled. Use `4400_OVERTRAVEL_SOURCE_CONFLICT_AND_WORKPIECE_SWEEP_CASE_2026-10-23.md` for an unexecuted multi-hazard validation design; the manufacturer 11/13 mm statements are not generic acceptance limits.

## 11G. Indicator-versus-verification boundary — 2026-10-23

**DOC-CONFIRMED:** OSHA's December 12, 2012 interpretation states that the *described* redundant LED disconnect indicator cannot replace 29 CFR 1910.147(d)(6) verification of isolation/deenergization; properly installed and maintained it may only supplement indication of disconnect-open position. OSHA 1910.147(d)(5–6) separately requires stored-energy disposition, reaccumulation attention and verification before service; (f)(1) requires renewed energy controls after necessary temporary powered positioning. See [original source audit](../research/4400_OSHA_LED_INDICATION_VS_PHYSICAL_ISOLATION_AND_GUARDLINK_EVENT_2026-10-23.md) and [open-book technician exercise](4400_THREE_INDICATORS_ZERO_ISOLATION_PROOF_TECHNICIAN_EXERCISE_2026-10-23.md).

**DOC-CONFIRMED:** Rockwell 432ES-UM001E-EN-P (June 2025), p.64 distinguishes first-transition `DeviceTripAddress`, last-transition `TripTimestamp` and `Uncertain` data validity. An event tag is not a complete current guard/occupancy state and cannot prove hydraulic/mechanical isolation.

| Trace IDs | Physical/authority proposition | Evidence and operational gate |
|---|---|---|
| `BND/ENE/HAZ` | List every selected electrical feed, trapped hydraulic volume, gravity load and hazard boundary. | Installed circuit/schematic and task; **UNKNOWN** without them. |
| `SF/PHY/SRS` | Separate protective stop, safe access, load restraint and maintenance isolation. | No single HMI/LED/gauge/first-trip field substitutes for all. |
| `AUTH/ARC/DEP` | Identify normal controller, safety controller, final element and physical isolator separately. | Selected device/firmware, wiring, independent safety path and physical dependency. |
| `VAL/PT` | Establish task-specific physical isolation, reaccumulation checks, stop/hold and escape with qualified witnesses. | **NOT RUN**; machine acceptance blocked until appropriate proof. |
| `HF/CHG/UNK/RR` | Make isolation/test points accessible, label measured zones, re-install guards easily, invalidate evidence after powered tests or design changes. | Preserve contradiction, STALE dependencies and exposed-person restriction. |

This is an **evidence-architecture supplement**, not a numerical safety rating, a selected machine circuit, or a performed physical test. A claimed safe state contradicted by independent actual motion must not be rescued by a green diagnostic indication.

## 11H. Safety-controller configuration transfer versus installed function (Pilz PNOZ s30 example)

**DOC-CONFIRMED:** Pilz PNOZ s30 manual 1001715-EN-24 §§8.5–10 documents CRC comparison after chip-card/USB configuration transfers, warns that USB download overwrites existing data, describes project-name and older-device-version effects on CRC, and requires safety-device function checks after configuration changes/downloads. See [source audit](../research/4400_PILZ_PNOZS30_CONFIG_CRC_TRANSFER_VS_FUNCTION_TEST_2026-10-23.md).

| Change-control proof | Required selected-machine evidence | Status |
|---|---|---|
| `CHG/ARC` identity | Full device order/version, project identity, selected parameter set, download route, original and installed CRC | UNKNOWN |
| `SRS/AUTH/DEP` appropriateness | Application-specific sensor/mechanical coupling, selected function, reset/auto-start semantics, outputs/final elements | UNKNOWN |
| `VAL/PT` behavior | Qualified fault, stop/hold, guard-unlock and rearm verification with independent physical witnesses | NOT RUN |
| `HF/UNK/RR` continuity | Accessible post-download checklist, retained project provenance, changed-CRC explanation and safe operational restriction | OPEN |

A matching CRC is **transfer evidence**, not a replacement for selected-machine functional validation. An unexpected CRC mismatch, configuration change, project rename or firmware-version transfer requires a documented review; do not assume every CRC change proves a safety defect or every match proves safety. Do not credit ordinary LinuxCNC software as independent personnel-safety authority.

## 11I. Lockable OPEN is not isolation — current SAF catalog correction

**DOC-CONFIRMED:** HYDAC *SAF/DSV EN 3551.25/05.24*, §4 printed pp.171–172, states the main shut-off `L` lock option can be padlocked in **OPEN or CLOSED** position; `LPI` and `LPM` add position monitoring, while `LS` locks the **pressure-release** valve. This updates the earlier August 2003 historical-only evidence scope without establishing any installed circuit. See [May 2024 source comparison](../research/4400_HYDAC_2024_SAF_LOCK_OPEN_CLOSED_OPTION_CURRENT_SCOPE_2026-10-23.md).

`PHY/VAL/PT` must distinguish: (a) padlock physically present, (b) selected shut-off actually CLOSED, (c) correct flow/pressure path isolated, (d) relevant trapped energy and reaccumulation controlled, (e) gravity-loaded member restrained, and (f) task-specific isolation independently verified. All selected-machine results **UNKNOWN/NOT RUN**. Provide unambiguous lock-position labeling and accessible verification points so safe maintenance is easier than locking the wrong position or bypassing a guard. `CHG` must invalidate dependent evidence after any model/option/port/handle/indicator change.

## 11J. Protective-cycle energy versus automatic bleed (qualitative)

See [HYDAC SAF/HAWE D 7571 source-based adversarial review](../research/4400_HYDAC_SAF_PROTECTIVE_STOP_VS_AUTO_BLEED_ADVERSARIAL_REVIEW.md). **DOC-CONFIRMED:** product families can provide manual or automatic accumulator discharge, and some accumulators can support an emergency protective action. **INFERENCE:** blindly de-energizing every valve to discharge pressure may conflict with a selected machine's required load-holding or protective cycle. This is **not** an as-built hydraulic truth table.

For `SRS/PHY/AUTH/DEP`, explicitly resolve which hazardous event is prevented, whether stored energy is required to complete the protective action, which independent safety-related authority controls it, what physical final elements and load restraints exist, and how loss of power/pump/pilot/feedback affects the response. `VAL/PT` remain **NOT RUN** until selected-machine schematics, instrumentation, safe remote validation and acceptance criteria exist. Production protective stopping and maintenance LOTO must have distinct evidence; all unresolved machine facts remain `UNK/RR`.


## 11K. GuardLink diagnostic epochs, reset scope and physical release authority

**DOC-CONFIRMED, product-specific:** Rockwell `440R-UM009E-EN-P` (February 2026) documents 440R-ENETR Series B as **not safety-rated**; its `Reset1`, `FaultReset`, per-tap `FaultResetCmd`, and `UnlockCmd/LockCmd` have different effects. `GLINK-AT001A-EN-P` (July 2023) separately documents the 432ES-IG3 CIP Safety architecture. The 432ES `DeviceTripAddress` is a first-event address, whereas ENETR `DeviceTrip` is documented as a node bitmap. Their semantics must not be exchanged. Sources: [reset/fault recovery](../research/4400_GUARDLINK_RESET_FAULT_RECOVERY_AND_SAFETY_AUTHORITY_2026-10-23.md), [ENETR tag conflict audit](../research/4400_ENETR_DIAGNOSTIC_TAG_BITMASK_AND_DOCUMENT_CONFLICT_AUDIT_2026-10-23.md), [432ES HMI state/event contract](../research/4400_HMI_GUARD_DIAGNOSTIC_EVENT_VS_SAFETY_STATE_CONTRACT_2026-10-23.md), and [event epoch/freshness follow-up](../research/4400_GUARDLINK_DIAGNOSTIC_EVENT_EPOCH_FRESHNESS_AND_RELEASE_GATE_2026-10-23.md).

| Trace IDs | Separate proof obligations | Current status |
|---|---|---|
| `BND/HAZ/ENE/SF` | Exact guard/zone/person exposure, selected protective function and energy path | UNKNOWN |
| `AUTH/ARC` | Selected safety-related decision path and physical final elements; ordinary LinuxCNC/HMI diagnostic requests are not personnel-safety authority | UNKNOWN |
| `DEP/CHG` | Product/firmware/AOP, tap type/count, terminator, physical slot/zone mapping, replacement and event epoch | UNKNOWN / change requires revalidation |
| `SRS/PHY` | Stop, hold, guard access/escape, maintenance isolation and fresh restart are different propositions | NOT ESTABLISHED |
| `VAL/PT` | Cause-and-effect test of each guard, additional trip after first event, stale network, device reset, retained start, output/final-element and physical witness | NOT RUN |
| `HF/UNK/RR` | Diagnose per guard without nuisance-trip bypass pressure; expose stale/unknown status and simple repair/reinstallation route | OPEN |

**INFERENCE (ordinary diagnostic contract):** retain raw tags, source/firmware, timestamp, validity, event epoch and physical zone mapping. Display `UNKNOWN` rather than an inherited green state when `Active=0`, data are stale, or `DeviceFault` bit mapping is unresolved. Manufacturer's February 2026 `DeviceFault=6` example and reset-duration units are internally inconsistent; do not silently normalize either. A link becoming Operational or a fault reset completing is not a machine-safe-state or fresh-start proof.

**No selected-machine validation:** no machine `VAL/PT`, PL/SIL, stopping distance, pressure threshold or hydraulic truth table has been established. Where minimum safe-to-operate protection is unproved, do not operate with people exposed. Any necessary experiments must be isolated/remote, with people outside the danger zone and residual risk stated.


## 11L. AKFR valve and pressure sensor target versus actual hydraulic hazard

**DOC-CONFIRMED:** Fiessler's historical AKAS-F + AKFR original German document 1257 (2010-04-01) and English internal document 1264 (2010-07-16; hosted filename contains `doc1268`) both describe **valve-position indicators AND pressure sensors** feeding AKAS-F through AKFR, and five potential-free normally open release contacts. The German text calls the released loads valve controls; the English translation calls them contactor controls; both example diagrams label valve release. This conflict is preserved, not silently corrected. See [original-language audit](../research/4400_AKFR_PRESSURE_AND_VALVE_WITNESS_SOURCE_AUDIT_2026-10-23.md) and [sensor-target technician exercise](4400_AKFR_SENSOR_TARGET_AND_PHYSICAL_WITNESS_TECHNICIAN_EXERCISE_2026-10-23.md).

| Trace IDs | Required selected-machine proof | Status |
|---|---|---|
| `BND/ENE/HAZ` | Exact AKAS-F/AKFR variant, machine mode, gravity load, all relevant trapped pressure volumes and access geometry | UNKNOWN |
| `AUTH/ARC/DEP` | Each of five contacts mapped to its actual load, valve state targets, pressure tap zones, shared pilot/common power and final-element dependencies | UNKNOWN |
| `SRS/PHY` | Distinct protective stop, beam/load holding, residual pressure disposition, guard/escape and maintenance isolation | NOT ESTABLISHED |
| `VAL/PT` | Qualified independent beam motion/holding and pressure-zone witnesses; negative evidence after feedback contradiction; maintenance restraint/isolation | NOT RUN |
| `HF/CHG/UNK/RR` | Clear sensor-target labeling, accessible safe test points, simple guard reinstallation, revalidation after variant/contact/port changes | OPEN |

**INFERENCE:** five electrical release contacts do not prove five independent hydraulic stopping paths, and one pressure sensor does not prove every cylinder chamber/accumulator is depressurized. A valid physical motion witness contradicting a claimed stopped/held state must block acceptance regardless of healthy status bits. Do not transfer this **2010 AKAS-F/AKFR** contract to **2024 AKAS-5M/LC-5M M variants** without exact source evidence. No selected-machine PL/SIL, pressure limit, stopping distance, valve truth table or `VAL/PT` is established.


## 11M. Historical press-brake laser-guard interpretation and selected-machine release gate (2026-10-23)

**DOC-CONFIRMED source correction:** OSHA's February 11, 2004 interpretation rescinded its March 2003 categorical objection to laser guarding on hydraulic press brakes, **without** approving a particular device or installation. OSHA's archived March 25, 2004 follow-up emphasizes effective and reliable protection on the specific machine, including stopping before body contact; 29 CFR 1910.212 remains the machine-guarding framework. Do not misapply mechanical-power-press 1910.217 stopping-distance formulas to press brakes merely because an OSHA eTool shows them. See [historical interpretation and causal proof study](../research/4400_OSHA_2003_2004_PRESS_BRAKE_LASER_GUARD_REVERSAL_AND_PHYSICAL_PROOF_2026-10-23.md). Exact standards edition/application must be resolved for each machine.

**INFERENCE practical release gate:** use [selected-machine physical witness intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md) before designing remote/isolated `VAL/PT`. Intake `IN-01..10` must cover as-built identity, task/exposure, electrical/safety and hydraulic schematics, sensing geometry/modes, `SF/SRS/PHY` criteria, independent instruments, remote exclusion plan, human-factors usability and change-controlled revision identity.

| Stable family | Physical proof obligation | Status in generic curriculum |
|---|---|---|
| `BND/ENE/HAZ` | All operator, setup, maintenance and bystander exposures; gravity, hydraulic trapped volumes and secondary sheet/backgauge hazards | UNKNOWN |
| `SF/SRS/AUTH/ARC` | Independent safety decision and selected final elements; LinuxCNC/HMI/normal FPGA only ordinary control and diagnostics | NOT SELECTED |
| `PHY/VAL/PT` | Independent stop, hold, access, escape, energy isolation and fresh restart; each must have its own falsifiable witness | NOT RUN |
| `DEP/CHG` | Shared pilot/power/receiver dependencies and invalidation on tooling, firmware, guard, valve or pressure-zone change | OPEN |
| `HF/UNK/RR` | Easy guard reinstatement, practical fault localization, accessible safe test points and explicitly unresolved residual risk | OPEN |

**Release state:** documentary intake G0 **HOLD**; isolated/remote test permission G1 **HOLD**; physical validation G2 **NOT RUN**; personnel-exposed operation G3 **NOT AUTHORIZED**; maintenance entry G4 **NOT AUTHORIZED**. No PL/SIL, stop distance/time, pressure threshold or machine hydraulic truth table is inferred. Source evidence is not `TEST-CONFIRMED` selected-machine proof.


## 11N. Temporary maintenance-test energization is a separate safety transition (2026-10-23)

**DOC-CONFIRMED:** OSHA 1910.147(f)(1) permits temporary LOTO removal for testing/positioning only through its specified sequence: clear tools/materials, remove employees from the area, authorized lock/tag removal, test/position, then deenergize and **reapply energy control** before further servicing. OSHA 1910.147(e) separately governs final release, employee clearance/notification and lock ownership. See [technician transition exercise](4400_TEMPORARY_REENERGIZATION_LOTO_TESTING_AND_FRESH_RESTART_2026-10-23.md).

**INFERENCE traceability addition:** record `M0` isolated maintenance, `T0` pretest personnel clearance, `T1` approved remote/isolated test, `M1` re-isolated maintenance and `P0` separate production return. Each transition must preserve `BND/ENE/HAZ` exposure, `AUTH` personal lock ownership, `PHY` stored energy and gravity restraint, `VAL/PT` independent witnesses, `HF` reinstallation usability, and `CHG` stale-evidence review. LinuxCNC ordinary start, HMI ready, safety reset and maintenance LOTO release are **different authorities**. This does not authorize temporary energization of any unqualified machine.

All selected-machine test plans and physical `VAL/PT` remain **NOT RUN**; `G0–G5` from §11M remain HOLD/NOT AUTHORIZED until actual evidence exists.


## 11O. Diagnostic freshness and selected-mode overrun source-conflict gate (2026-10-23)

**DOC-CONFIRMED, Fiessler AKAS-5M document 1581 (2024-02-15):** RS-232 diagnostics have repeated messages, parity and acceptance rules (printed pp. 32–34). The tables distinguish selected box mode, muting, warnings and interlocks; some interlocks can occur without a prior warning. The same manual's printed pp. 5 and 14 use 13 mm and 11 mm in different overrun statements and Table 14/1 supplies setting-dependent values. **Do not turn either number into a universal selected-machine criterion.** See [original diagnostic source trace](../research/4400_AKAS5M_SERIAL_DIAGNOSTIC_REPETITION_FRESHNESS_AND_HMI_AUTHORITY_2026-10-23.md), [exact archived overrun and secondary-hazard study](../research/4400_AKAS_OVERTRAVEL_TEXT_CONFLICT_AND_SECONDARY_HAZARD_SCOPE_2026-10-23.md), [selected DIP-setting/retest source adjudication](../research/4400_AKAS5M_SELECTED_SETTING_OVERRUN_AND_RETEST_2026-10-23.md) and [cross-machine technician transfer](4400_SERIAL_DIAGNOSTIC_STALE_GREEN_CROSS_MACHINE_TECHNICIAN_CARD_2026-10-23.md).

**INFERENCE — required package separation:** `DEP/CHG/UNK` records must identify diagnostic device, exact manual/firmware, transport and host decoder revision, timestamp origin, stale-data policy and selected DIP/mode configuration. A received serial code is not a `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` witness; it cannot close `VAL/PT`. A change of tool, receiver, firmware, safety setting, HMI decoder, wiring or hydraulic final element invalidates affected `SRS/DEP/PHY/VAL/PT` claims until requalification. Display `STALE`, `MUTED`, `INTERLOCK`, `STOP REQUESTED` and `PHYSICAL STATE UNVERIFIED` distinctly rather than a global green `SAFE` state.

**Current status:** selected-machine overrun acceptance, diagnostic maximum age, actual final-element stop/hold, pressure zones, inside escape and maintenance isolation are `UNKNOWN/NOT RUN`. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. No personnel-exposed hazardous operation is authorized by this documentary research.


## 11P. Accumulator family exception and zone-specific witness gate (2026-10-23)

**DOC-CONFIRMED manufacturer family contrast:** HAWE D 7969 (06-2022 rev 1.10, printed p.31) describes a dedicated component-approved accumulator safety valve for its AC diaphragm-accumulator family. HAWE D 7571 (03-2024 rev 1.1, printed p.18) says its described miniature AC family may use the system pressure-limiting valve without a separate specially component-approved accumulator valve, **provided** its stated conditions are met; a local pressure-amplification path may still require a separate limiter. Both documents describe fluid-side release/pressure monitoring for servicing. See [exact archived HAWE family and pressure-zone study](../research/4400_HAWE_ACCUMULATOR_FAMILY_EXCEPTION_AND_PRESSURE_ZONE_WITNESS_2026-10-22.md). This is product-document scope, **not** an independently inspected PED/ISO clause or a selected-machine exemption.

**INFERENCE package requirement:** create distinct `ENE/ARC/DEP/PHY/VAL/PT` records for (a) component overpressure limitation, (b) protective stop/motion prevention, (c) maintenance isolation/controlled discharge and reaccumulation, and (d) gravity/external-load restraint. A pressure gauge proves only its actual connected volume; a supply gauge cannot stand in for an isolated accumulator fluid/gas side, pilot path, load chamber or physical ram restraint. Capture exact installed product family, port graph, gauges, lockable isolation, approved release and independently observed load response before any credit for maintenance entry or exposed-person protection. Improve labeled accessible test points rather than encouraging guard defeat.

**Current state:** selected machine family/pressure-zone map `UNKNOWN`, physical `VAL/PT` `NOT RUN`, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. Do not infer a hydraulic truth table, pressure limit, PL/SIL or maintenance procedure from these component examples.


## 11Q. Normal unlock, inside escape and maintenance entry are three different temporal proofs (2026-10-23)

**DOC-CONFIRMED:** EUCHNER CTP-AP manual 2124217-08-06/21 §§3, 6.8 and 7.3 says the CTP-L FO safety outputs are OFF when unlocking, and inside escape release mechanically unlocks and causes the outputs to switch OFF, which should generate a stop demand. The manual does **not** state that machine stopping is complete before the escape release makes opening possible. Its OD door-position output can be undefined during release. See [exact archived normal-unlock versus emergency-escape source study](../research/4400_NORMAL_UNLOCK_VS_ESCAPE_RELEASE_TEMPORAL_PROOF_2026-10-22.md).

**INFERENCE architecture split:** `PHY-ACCESS` for normal entry requires the selected hazard to be acceptably stopped/contained **before** permitting access; `PHY-ESCAPE` requires a person already inside to be able to operate the physical release even under credible power/load/door-force conditions, while independent stopping/holding/exposure protections remain separately justified; `PHY-ENERGY` for maintenance requires personal isolation, stored-energy and gravity restraint verification, not just a released guard. Create distinct `AUTH/DEP/SRS/VAL/PT/HF/CHG` records for each transaction. Do not collapse `FO OFF`, `GUARD UNLOCKED`, `MOTION STOPPED` and `MAINTENANCE ISOLATED` into one green state. Guard mounting and release access must be practical to restore; inconvenient guards that invite bypass require redesign.

**Current state:** selected guard model, actual release mechanics, installed stop time/distance, trapped-person egress, gravity/hydraulic holding and maintenance isolation `UNKNOWN/NOT RUN`. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. No live escape or stop test is authorized by this template.


## 11R. Qualitative hydraulic fault-tree top events and common-cause gate (2026-10-23)

**INFERENCE (no selected-machine probability claim):** use distinct top events `T1` unexpected hazardous ram motion during exposure, `T2` pressure release during service boundary opening and `T3` hazardous restart after restoration. Each requires its own `BND/ENE/HAZ/SF/PHY/SRS/VAL/PT` and independent witness. The [exact archived qualitative hydraulic energy fault-tree study](../research/4400_HYDRAULIC_ENERGY_FAULT_TREE_QUALITATIVE_2026-10-22.md) records common-cause candidates: shared pilot, shared sensor reference, falsely shared pressure-tap coverage and shared structural load path. HAWE SAKB D 6335 (2025) and NSV D 6368 (2026) are inspectable manufacturer examples, **not** the selected press-brake circuit or proof of its safety performance.

A monitored valve position is not a measured load stop; a low gauge is not every pressure zone; an accumulator discharge command is not proven depressurization; a safety reset is not a fresh start; and none substitutes for maintenance isolation. Record `DEP/CHG/UNK/HF` when sensor targets, hydraulic topology, guard access or pressure test points change. Prefer accessible labeled witness points and guards easy to reinstall, rather than unsafe improvised maintenance checks. **UNKNOWN/NOT RUN:** all selected-machine circuit states, CCF likelihood, stop/hold/pressure/restart acceptance, achieved PL/SIL and physical validation. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED.


## 11S. SAKB monitored manifold versus NSV/physical holding scope (2026-10-23)

**DOC-CONFIRMED manufacturer example:** HAWE SAKB D 6335 (08-2025 rev 1.1, printed p.9) describes its **S** variant's position monitoring on two proportional directional valves, two holding valves and one 4/2-way valve. HAWE NSV D 6368 (06-2026 rev 1.3, printed p.6) distinguishes an `L` suffix without seal/with leakage flow from a sealed version; printed p.8 identifies nominal pilot-pressure values as guides, not selected-machine safety thresholds. NSV devices are separately located in the documented SAKB arrangement. See [exact archived monitored-valve and NSV witness study](../research/4400_SAKB_MONITORING_COVERAGE_NSV_WITNESS_2026-10-22.md).

**INFERENCE evidence rule:** a manifold valve-position feedback record cannot by itself prove anti-cavitation valve state, accumulator/isolated chamber pressure, load holding, gravity restraint, workpiece protection or maintenance isolation. For any selected machine, record exact SAKB/NSV variant and suffix, sensor target, pilot dependencies, optional tool-clamp/crowning energy paths, gauge connectivity and independent physical beam/pressure witnesses. Do not treat manufacturer `S` monitoring or a component certification statement as a complete machine-level safety-function claim. Any valve/sensor/port substitution creates `CHG` and makes dependent `DEP/PHY/VAL/PT` stale until revalidated.

**Current state:** selected hardware `UNKNOWN`, installed hydraulic truth table and PL/SIL `UNKNOWN`, all physical `VAL/PT` `NOT RUN`; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED.


## 11T. Diagnostic cascade versus safety-rated output and physical proof (2026-10-23)

**DOC-CONFIRMED product-family scope:** [Rockwell GuardLink](https://www.rockwellautomation.com/en-us/products/hardware/safety-products/guardlink-technology.html) offers per-device contextual diagnostics through compatible taps and a documented safety-relay path. [Pilz SDD](https://www.pilz.com/en-US/products/networks/device-diagnostics-system/safety-device-diagnostics) offers device-level diagnostics with supported sensors; its current product page explicitly labels its diagnostic reaction time **not safety-related** and directs users to the individual safety device for safety-related data. The 16-sensor SDD figure belongs to that product-family configuration, not every series loop. See [exact archived GuardLink/SDD comparison](../research/4400_VENDOR_DIAGNOSTIC_CASCADE_GUARDLINK_SDD_BOUNDARY_2026-10-22.md). Distinguish Rockwell 432ES safety-channel semantics from ordinary 440R-ENETR diagnostic status; do not generalize that all EtherNet/IP is or is not safety-rated.

**INFERENCE architecture contract:** `device/tap -> selected safety receiver -> safety outputs -> final element -> physical witness` must be traced independently from `device/tap -> diagnostics gateway -> ordinary HMI`. Preserve first-trip history versus current all-guard state, transport freshness, node/firmware identity, fault reset and change records. A convenient per-device fault display may reduce bypass incentives but does not prove safe stop, lock strength, occupancy, escape or maintenance isolation. `DEP/SRS/VAL/PT` for the actual receiver and machine remain `UNKNOWN/NOT RUN`; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED.
