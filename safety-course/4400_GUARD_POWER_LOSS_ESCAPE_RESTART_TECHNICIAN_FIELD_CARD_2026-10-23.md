# 4400 — Guard power-loss / escape / restart field card

**Learner-facing technician exercise, 2026-10-23.** Documentary reasoning only. This is a worksheet, **not** an instruction to energize or deliberately trap someone. Prerequisites: 2590 guard/interlock methods, 2530 E-stop/restart, 2580 energy isolation and the [original selected-variant source matrix](../research/4400_GUARD_POWER_LOSS_ESCAPE_AND_REARM_VARIANT_SOURCE_MATRIX_2026-10-23.md).

## Objective

Given an exact guard-lock variant and a machine hazard map, decide what loss of power changes, what remains hazardous, whether someone can escape, and what evidence is necessary before rearming. Distinguish an *electrical request* from *physical safe state*.

## Four frozen paper cases (no physical operation)

| Case | Facts supplied | Learner's required response |
|---|---|---|
| A — trapped worker | A spring-locked power-to-release gate is closed during a blackout; a person might remain inside. No confirmed inside release. | Identify the entrapment path and prohibit relying on HMI unlock. Specify a reachable mechanical escape/occupancy safeguard and the safe, unoccupied method to inspect it. |
| B — premature access | A power-to-lock gate loses solenoid voltage while the spindle/ram can retain hazardous motion. | Explain why immediate mechanical unlocking is not equivalent to safe access. Name the independently controlled stop/hold and physical observation needed. |
| C — recovery ambiguity | A Pilz PSENmlock variant has used its escape release. The owner points to another Pilz product page describing automatic-reset variants. | Demand exact type/manual/revision. Separate device recovery from independent safety rearm, personnel clearance and a new ordinary start. Do not combine two variant descriptions. |
| D — convenient but defeated | An operator must climb behind a fixture to reach the release, and a maintainer props the guard open. | Record a human-factors failure and propose a physically reachable, approved release/guard mounting/diagnostic redesign without bypassing independent protection. |

## Answer-record template (complete per case)

- Exact source and edition; **DOC-CONFIRMED** device behavior:
- Hazardous event and exposed people:
- Locking state after power loss, with uncertainty:
- Independent stop and load-holding mechanism (or **UNKNOWN**):
- Mechanical escape path, mounting and reachability (or **UNKNOWN**):
- What an OSSD/LED/HMI status **does not** establish:
- How maintenance energy isolation differs from restart prevention:
- What must be physically witnessed, without people in the danger zone:
- What resets the device, what rearms the independent safety function, and what creates a *fresh* ordinary motion request:
- Foreseeable shortcut/bypass incentive and a simpler compliant design:
- Disposition: HOLD / documentary-ready / independently physically verified (the last is **NOT AVAILABLE** here).

## Non-negotiable review rules

1. **Do not declare a generic “fail-safe” polarity.** Power-to-release can create entrapment; power-to-lock can permit premature access. Which failure matters depends on machine energy and occupancy.
2. **Do not mistake a released latch for stopped machinery.** A released guard may coexist with coasting motion or an unrestrained gravity-loaded beam.
3. **Do not mistake an escape-stop demand for a completed stop.** Independently observe the final element and hazardous motion/holding, after a qualified no-exposure test plan exists.
4. **Do not mistake a guard padlock hole for maintenance LOTO.** Control of electrical, fluid and mechanical energy remains a separate verified task.
5. **Do not credit LinuxCNC/FPGA or an HMI green icon as personnel-safety authority.** They are normal control/diagnostics, not independent safety functions.
6. **Do not conduct a trapped-person demonstration.** Verify mechanical reach/egress using an isolated, unoccupied fixture and qualified witness.
7. **Do not release operation** when `IN-01..10` or `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART` remain UNKNOWN/NOT RUN. Personnel-exposed operation remains prohibited below the minimum safe-to-operate threshold.

## Original source references

- SICK TR110 Lock **8023119/1K8B/2023-09-15**, §§3.3, 4.4, 8.2–8.3: https://www.sick.com/media/docs/2/82/682/operating_instructions_tr110_lock_en_im0082682.pdf
- EUCHNER CTP-AP **2124217-08-06/21**, §§3, 6.6–6.8, 7: https://assets2.euchner.de/Downloads/Betriebsanleitung/en/MAN_Transponder-Coded-Safety-Switch-With-Guard%E2%80%A6_EN_08_06-21_2124217.pdf
- Pilz PSEN ml b **1003884-EN-17**, §§4.6–4.8: https://www.pilz.com/download/open/PSEN_ml_b_1_12_12_2_Op_Man_1003884-EN-17.pdf
- Pilz PSENmlock product-family reset-variant distinction: https://www.pilz.com/en-AU/products/sensor-technology/safety-switches-with-guard-locking/psenmlock-safety-locking-devices

**Evidence:** product behavior DOC-CONFIRMED at stated editions; architecture/field-card rules INFERENCE; selected-machine physical validation UNKNOWN / NOT RUN; TEST-CONFIRMED none. External blind competency evaluations 2520–25F0 remain separate and open.