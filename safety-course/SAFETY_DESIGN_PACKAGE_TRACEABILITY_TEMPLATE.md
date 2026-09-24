# Safety Design Package — Cross-Course Traceability Template

Status: CANONICAL LEARNER WORKING PACKAGE TEMPLATE
Applies: 2520 through 25F0

This package is cumulative. Do not restart it at each course. Preserve stable IDs and provenance. If an upstream item changes, review and mark dependent downstream items STALE until re-verified/revalidated.

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

## 9. Architecture decisions

| ARC ID | SRS IDs | Selected architecture | Rejected alternative | Failure paths addressed | Remaining dependencies/UNKNOWNs | Source/provenance | Status |
|---|---|---|---|---|---|---|---|

Keep stopping, isolation, stored-energy discharge, load holding/restraint and access prevention separate unless evidence justifies combining them.

## 10. Verification / validation matrix

| VAL ID | SRS/PHY IDs | Verification or validation | Precondition/mode | Stimulus/fault | Expected independent response | Required physical witness | Acceptance criterion | Result/evidence | Status |
|---|---|---|---|---|---|---|---|---|---|

Use `NOT RUN`, `PASS`, `FAIL`, `BLOCKED`, or `STALE` for execution status. A software/status indication cannot substitute for the physical witness unless the SRS proposition is specifically about that indication.

## 11. Commissioning / proof test / inspection

| PT ID | SRS/VAL IDs | Latent failure sought | Method | Interval/trigger and basis | Acceptance | Evidence | Status |
|---|---|---|---|---|---|---|---|

If an interval lacks a justified basis, record `UNKNOWN`; do not invent a calendar interval.

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

## 15. Release checklist

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
