# SC-CORE — Independent Safety Controller Implementation Spec Template

Status: reusable curriculum engineering template; not a machine-specific certified design.

## 1. Traceability

Record instance ID and linked `SRS-*`, `PHY-*`, `AUTH-*`, `DEP-*`, `ARC-*`, `VAL-*`, `HF-*`, `CHG-*`, plus current UNKNOWNs and selected controller/product evidence.

## 2. State semantics — do not collapse to one enable bit

Define independently:

| State | Meaning / owner / evidence |
|---|---|
| safety demand | protective/fault condition requiring the allocated safety response |
| reset request | deliberate request to clear/rearm eligible safety state |
| reset accepted | reset sequence met controller/product requirements |
| rearm eligible | required inputs/dependencies/feedback/occupancy conditions permit rearm |
| safety permissive | safety-related outputs may assume their permitted state |
| ordinary start/cycle request | separate normal-control command for hazardous operation |

**Freezes:**
- `RESET ACCEPTED != HAZARDOUS MOTION COMMANDED`.
- `RESET INPUT ACTIVE != DELIBERATE RESET EVENT PROVED`.
- `RESET DEVICE ACCESSIBLE != SAFEGUARDED SPACE CLEAR PROVED`.
- `POWER RESTORED != REARM ELIGIBLE`.

Restoring an input, communications link or power SHALL NOT silently substitute for a required deliberate reset. Reset SHALL NOT itself initiate hazardous motion unless a machine-specific SRS and selected safety architecture explicitly justify that behavior.

## 3. Reset/rearm implementation

- reset type supported by selected product: monitored manual / manual / automatic / other;
- exact documented sequence/timing: product value or UNKNOWN;
- reset-device wiring and stuck/held behavior;
- whether the selected architecture requires a transition/edge and which layer owns that check;
- reset location and visibility assumptions;
- safeguarded-space occupancy proposition before reset/rearm;
- fault latch owner and clearing prerequisites;
- power-cycle and power-restoration behavior;
- LinuxCNC/HMI reset request authority: request only unless explicitly justified.

Where a person can enter a safeguarded space, closing a gate or accepting reset does not prove the space is empty. Provide a separately justified occupancy/restart strategy. A maintained reset level is not credited as a fresh deliberate reset unless selected-product/application evidence explicitly establishes that semantics.

## 4. Inputs and dependencies

For every safety input, final-element feedback/EDM, mode/service input, reset input, watchdog/internal diagnostic and normal-control request, record electrical interface, freshness, validity, fault response, authority and shared dependencies.

Normal LinuxCNC/FPGA requests are non-authoritative unless a separately justified safety architecture says otherwise.

## 5. Output semantics

For each safety output record demanded state, permissive state, power-up state, controller-fault state, supply-loss state and destination `SO-*` interface. Do not claim physical safe state at the controller output layer.

## 6. Internal dependency / CCF inventory

Record selected controller safety manual claims and application assumptions for supply, clock/reset/watchdog, internal diagnostics, channel independence, communications, common connector/PCB resources and environmental conditions. Do not infer diagnostic coverage or PL/SIL from architecture appearance.

A matching command/feedback pair is not independent proof when both can be made plausible by the same failed supply, wiring resource, processor/resource, pilot source, sensor target or mechanical path.

## 7. Service / bypass / muting / setup

If any feature can reduce normal protection, specify entry eligibility, alternate protection, bounded authority, indication, timeout/exit behavior, power-cycle behavior, accessible controls, restoration test and `VAL-*`. If these are absent, the feature is prohibited.

## 8. Validation

At minimum cover safety demand, reset sequence errors, held/stuck reset, input restoration without reset, reset without ordinary start, power loss/restoration, controller reset, feedback disagreement, communications loss/recovery, mode/service transitions and every permitted bypass/muting path. Validate observable output/final-element/physical propositions at their appropriate layer.

Adversarial validation SHALL include at least one plausible-but-wrong feedback case and one common-dependency case where command and feedback can agree while the required physical proposition is not established.

## 9. Freeze gate

No schematic/implementation freeze until the selected controller/product evidence, state semantics, reset/rearm behavior, occupancy assumptions, output behavior, dependency/CCF inventory, service features and validation witnesses are explicit. Before schematic capture, the instance SHALL satisfy the repository minimum selected-block evidence package: exact product/revision, traceability allocation, electrical interface evidence, state/restart semantics, energy-path definition, witness proposition, dependency/CCF record, failure-state table, human/service boundary, validation plan, integrity-claim boundary and disposition of every remaining UNKNOWN. Any UNKNOWN capable of changing interface compatibility, fail-safe state, diagnostic behavior, reset/rearm behavior, energy-path authority or a safety-critical dependency is schematic-blocking.

Passing this template does not establish machine-level safety integrity or validation.