# 4400 open-book technician exercise — Three green indicators, zero verified physical propositions

**Status:** learner-visible training; **NOT RUN** on hardware; not a sealed external competency evaluation. Read `research/4400_OSHA_LED_INDICATION_VS_PHYSICAL_ISOLATION_AND_GUARDLINK_EVENT_2026-10-23.md`, OSHA 1910.147(d)(5–6), (f)(1), the 2012-12-12 OSHA LED interpretation and the selected device's manufacturer instructions.

## Scenario

A LinuxCNC press-brake retrofit displays `E-STOP CLEAR`, `GUARDLINK OK`, `DISCONNECT OFF` and `PRESSURE ZERO`. A maintainer must clear a jam under a raised beam. A second worker reports that the beam shifted after the pump stopped. No exact hydraulic schematic, pressure-tap map, disconnect verification procedure, independent ram restraint or GuardLink model/firmware is available.

### Learner tasks

1. Classify each HMI/LED/gauge indication as **normal-control**, **diagnostic**, **independent safety-related control** or **physical-energy witness**, and identify where the evidence is insufficient or unknown. Do not promote the whole HMI into safety authority.
2. State precisely what OSHA's December 12, 2012 interpretation permits the *described* redundant LED indicator to support and what it does **not** establish under 1910.147(d)(6).
3. Explain why a 432ES `DeviceTripAddress` or `TripTimestamp` cannot prove that all guards are currently healthy, and how `Uncertain` affects diagnostic confidence. Do not transfer these tag semantics to an unverified 440R-ENETR device.
4. Draw separate physical-energy zones for an **unknown** pump, cylinder, accumulator, pilot circuit and elevated load. Use `?` for connections until a selected machine schematic is obtained; do not invent a hydraulic truth table.
5. Specify the missing task-specific lockable isolators, worker locks, trapped-energy disposition, reaccumulation observation, independent elevated-load restraint and verification witnesses. Distinguish a device's status from the physical effect it is claimed to cause.
6. Suppose authorized workers perform a necessary powered repositioning. Identify the 1910.147(f)(1) transition back to a newly isolated, secured and verified maintenance state. Does the previous proof survive?
7. Propose two low-cost ergonomic changes that make proper verification and guard reinstallation easier than bypass, without compromising the required protective function.
8. For each unknown, add `BND/ENE/HAZ -> SF/PHY/SRS -> AUTH/ARC/DEP -> VAL/PT -> CHG/UNK/RR` traceability, mark machine validation **NOT RUN**, and state the operational restriction.

## Adversarial transfer

On a lathe, an illuminated spindle-drive `STO ACTIVE` indication coexists with a spinning chuck. On a plasma table, `ARC OFF` coexists with charged capacitors or a moving gantry. Identify the same evidence/authority mismatch without assuming the press-brake hydraulic remedy transfers to these machines.

## Evaluation criteria (open practice, not external score)

A competent answer must explicitly retain the reported physical beam motion as a contradiction; avoid treating a green HMI or LED as isolation proof; distinguish ordinary LinuxCNC from independent safety functions; preserve missing machine facts as UNKNOWN; reject unsafe personnel-exposed testing; and make physical verification accessible. No specific PL/SIL, pressure, stopping distance, diagnostic coverage or physical test result is supplied.

**Minimum restriction:** do not perform personnel-exposed hazardous operation or servicing until appropriate independent physical energy-control and restraint evidence exists. Any research-only motion must be isolated/remote with people outside the danger zone and residual risk assessed.
