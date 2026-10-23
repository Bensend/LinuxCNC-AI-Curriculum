# 4400 technician exercise — GuardLink first trip is not all guards currently safe

**Learner-visible, open-book adversarial case. Not an external blind evaluator key. NOT RUN.** Source: `../research/4400_432ES_FIRST_TRIP_UNCERTAIN_HISTORICAL_FAULT_TAG_SCOPE_2026-10-23.md`, Rockwell 432ES-UM001E-EN-P Table 6 (June 2025) and DEVICE-RM500G-EN-P p.339 (September 2025). No machine-specific values are supplied.

## Scenario

A cell with three guards has a 432ES-IG3 GuardLink channel and a separate safety-related controller. The ordinary LinuxCNC HMI shows the last `DeviceTripAddress` as Gate B, `Status=0`, and a green icon for Gate A from a previous poll. The link later reports `Uncertain=1`. An operator closes Gate B, sees no new first-trip address, and requests a one-click reset. A service technician says that `TerminatorFault=0` proves the end-of-line terminator is installed; another technician notes `TooManyDevices=1` despite fewer than 32 physical devices. The HMI's fault table shows four entries, three older than the current event. A heavy axis may coast or a hydraulic beam may continue under gravity after the safety demand.

## Required work

1. Build a **timestamped event ledger** for B first, A later, and communications quality loss. Explain why `DeviceTripAddress` does not report all currently open guards. Mark unknown current device states UNKNOWN, not closed.
2. Explain the difference between the manufacturer's 432ES `Ch0.Status` safety bit and the non-safety-rated **440R-ENETR** interface. Assign normal LinuxCNC/HMI, independent safety-related controller, and physical final-element authority separately.
3. Explain why `TerminatorFault=0` cannot alone prove a terminator is present, and why `TooManyDevices=1` need not mean the physical device count exceeds 32. Record any apparent manual-label contradictions and exact firmware dependencies.
4. Distinguish **active**, **first-event**, **historical**, **uncertain** and **stale** information. The manufacturer Safety Device Library's first row can show a current active fault or the last fault; rows 2–4 are historical. Do not label them four simultaneous active faults.
5. Write an HMI display contract that exposes raw source/product/firmware, device/channel, timestamp/age, quality, event epoch, last transition cause, available current state, and UNKNOWN/STALE. Do **not** turn the contract into personnel-safety logic.
6. Design a **non-executed** validation plan for actual guard-to-zone mapping, independent safety demand, downstream final element, physical stopping/holding, power restoration, reset/rearm and fresh ordinary start. Show how a prior protective demand can mask a new guard's causal response.
7. Propose an ergonomic fault-localization and repair workflow that makes correct guard reinstallation easier than defeating the guard. Include restoration/change control and the conditions that make exposed-person operation unacceptable.

## Evaluation rubric

A passing answer preserves the product-family distinction and source provenance, refuses to infer current guard state from first-event data, marks uncertain/stale signals unknown, keeps reset separate from start and physical stopping, and leaves all selected-machine response limits, PL/SIL and hydraulic/occupancy truth UNKNOWN until measured or design-justified.

Fail an answer that declares the machine safe because the safety channel reports OFF, because the HMI is green, because the last fault points only to B, or because the terminator tag is zero. No live fault injection, guard bypass, trapped-person trial or exposed operation is authorized. If a required causal proof cannot be safely performed, mark it BLOCKED and retain remote/isolated restrictions.
