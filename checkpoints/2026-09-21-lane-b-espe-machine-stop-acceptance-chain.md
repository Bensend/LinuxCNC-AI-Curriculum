# Lane B checkpoint — ESPE physical-field to machine-stop acceptance chain

Date: 2026-09-21

## Reconciliation

Read current governance/progress and recent commits before selection. The newest primary checkpoint `6fd85073` is advancing exceptional commissioning-state force/simulation/override persistence and positive-clear production handoff. Lane B therefore stayed on the independent ESPE physical validation branch from checkpoint `d9b7fbbd` and did not modify primary-lane files.

Immediately before checkpointing, re-read recent `main`: no newer primary commit appeared after Lane B began, and no overlapping file changed. The Lane-B study commit is `621e6406`.

## Durable work

- `safety-course/ESPE_PHYSICAL_FIELD_TO_MACHINE_STOP_RESET_AND_FRESH_START_ACCEPTANCE_CHAIN_2026-09-21.md`

## New evidence

SICK Safe Presence Detection provides an integrated manufacturer validation sequence where a test rod breaches the safety light curtain while the machine is running; expected behavior is safety-controller outputs OFF **and the machine stopped**. Its restart tests separately distinguish safety reset from machine restart.

SICK C4000 Palletizer commissioning guidance requires the correct test rod across the complete protected hazardous area and explicitly says not to operate the machine if the expected protective-device response does not occur; machine/protective-device modification or light-curtain repair/change triggers rechecking.

Pilz PSEN op2H documents the restart-mode hazard boundary: automatic restoration after the field clears can be unsafe for access protection when a person can pass beyond the sensitive area.

## Freezes

- **TEST ROD DETECTED != MACHINE PHYSICALLY STOPPED**
- **OSSD OFF != FINAL ELEMENT PHYSICALLY IN SAFE STATE**
- **MACHINE STOPPED ONCE != QUANTITATIVE STOPPING PERFORMANCE ACCEPTED**
- **PROTECTIVE FIELD CLEAR != HAZARDOUS AREA PERSONNEL-CLEAR**
- **PROTECTIVE FIELD RESTORED != RESET/REARM ACCEPTED != ORDINARY START AUTHORIZED**
- **FAILED PHYSICAL FIELD TEST != CONDITION THAT MAY BE ACKNOWLEDGED BACK INTO PRODUCTION**

## Evidence discipline

Manufacturer validation behavior is `DOC-CONFIRMED`. The OpenPressBrake authority-chain transfer is `INFERENCE`. OpenPressBrake ESPE geometry/resolution, final-element topology, reset scheme, personnel-clear method, hydraulic response, stopping performance, PL/SIL/category/DC/CCF and acceptance thresholds remain `UNKNOWN`.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Precise next work

Seek one authoritative OEM/manufacturer acceptance procedure that adds the still-missing explicit downstream final-element witness to the ESPE chain: **physical field challenge -> safety output -> physical contactor/STO/hydraulic final element -> actual hazardous-motion stop -> failed-test production lockout -> correction/full affected retest -> reset/rearm -> fresh ordinary start**. Prefer a press, press brake, robot cell or other high-energy machine. If the next source cannot add a physical final-element witness beyond the current SICK integrated machine-stop sequence, mark this ESPE branch information-gain limited and rotate Lane B to another independent safety branch rather than collecting more generic light-curtain material.
