# Safety Spare Readiness Evidence Card

Purpose: compact record for a physical spare bin, maintenance store, or CMMS entry. This card does **not** establish that a component is safety-equivalent by itself. Use it with `SAFETY_SPARE_PARTS_OBSOLESCENCE_LIFECYCLE_WORKSHEET.md` and `SAFETY_REPLACEMENT_PART_EQUIVALENCE_SUBSTITUTION_WORKSHEET.md`.

## Frozen rule

**A stocked part is not a ready safety spare until identity, provenance, substitution basis, storage condition, configuration dependencies, affected safety functions, and post-installation revalidation are bounded. Installation does not restore a validated safety function until the required physical challenges have passed.**

Evidence labels used here: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

## 1. Spare identity

| Field | Record |
|---|---|
| Asset / machine family | |
| Spare description | |
| Manufacturer | |
| Exact catalog / part number | |
| Hardware revision | |
| Firmware revision / compatibility range | |
| Serial / lot / date code | |
| Safety certificate / approval identity if applicable | |
| Procurement source | |
| Receipt date | |
| Evidence label + source | |

**Reject the shortcut:** same connector, voltage, current, dimensions, or mounting pattern is not sufficient evidence of safety equivalence.

## 2. Readiness state

Select exactly one:

- [ ] `UNREVIEWED`
- [ ] `QUARANTINE`
- [ ] `APPROVED-SPARE`
- [ ] `INSTALLED-PENDING-VALIDATION`
- [ ] `IN-SERVICE-VALIDATED`
- [ ] `FAILED / INVESTIGATION`

State owner: __________  Date: __________  Evidence record: __________

`APPROVED-SPARE` means approved for controlled installation under the documented substitution/configuration/revalidation conditions. It does **not** mean the machine safety function has already been validated with this physical unit.

## 3. Why this spare is acceptable for controlled installation

Classification:

- [ ] Exact replacement
- [ ] Manufacturer-documented direct replacement
- [ ] Manufacturer-documented functional successor
- [ ] Engineered equivalent with documented comparison
- [ ] Not established — `UNKNOWN` / quarantine

Authoritative substitution/equivalence reference: ______________________________

Required adapter, wiring, parameter, firmware, mounting, sensing-target, feedback, or diagnostic changes: ______________________________

Unresolved safety-relevant `UNKNOWN`s: ______________________________

If an unresolved unknown could defeat the safety function, this card cannot authorize `APPROVED-SPARE` state.

## 4. Storage / aging / provenance check

| Check | PASS / FAIL / UNKNOWN | Evidence / observation |
|---|---|---|
| Sealed / protected as required by product documentation | | |
| Storage temperature/humidity/environment within documented limits where specified | | |
| No corrosion, contamination, impact, water ingress, UV or packaging damage evident | | |
| Product-specific shelf/storage-life requirement checked, if one exists | | |
| Battery/capacitor/elastomer/grease/optical or other age-sensitive element addressed where applicable | | |
| Calibration / teach / certificate validity addressed where applicable | | |
| Provenance traceable; counterfeit/tamper concern addressed | | |
| Cannibalized/repaired/refurbished status explicitly recorded | | |
| Firmware/configuration media and required tools remain available | | |

Do not invent a generic shelf-life. If the manufacturer provides no applicable limit, record that fact and preserve the remaining inspection/test uncertainty rather than manufacturing an interval.

## 5. Safety-function dependency map

Affected safety function(s): ______________________________

For each affected function record whether the spare participates in:

- [ ] protective-device sensing
- [ ] dual-channel/discrepancy path
- [ ] safety logic
- [ ] reset/restart/rearm path
- [ ] EDM / external-device monitoring
- [ ] STO / safe-motion interface
- [ ] contactor / motor-power interruption
- [ ] hydraulic/pneumatic final element
- [ ] mechanical holding/restraint
- [ ] diagnostic/fault-detection path
- [ ] calibration/position/teach dependency
- [ ] other: __________

Ordinary LinuxCNC/HAL/FPGA/HMI state is not personnel-safety authority merely because it can display, command, or diagnose the component.

## 6. Installation controls

Before installation:

- [ ] identify and control electrical, hydraulic/pneumatic, gravity and stored mechanical energy appropriate to the task;
- [ ] preserve required blocking/restraint and isolation;
- [ ] record removed component identity and reason for replacement;
- [ ] compare actual field wiring/mounting/configuration to the approved basis;
- [ ] preserve original parameters/configuration where legitimately transferable;
- [ ] do not treat software download success or a healthy status bit as physical validation.

Installed unit serial/lot: __________  Installer: __________  Date: __________

Observed deviations from approved basis: ______________________________

Any unexplained deviation returns the item/machine to `INSTALLED-PENDING-VALIDATION` or `QUARANTINE`, as appropriate.

## 7. Mandatory post-installation revalidation

Define the physical challenges **before** claiming restored safety operation.

| Safety function / claim | Physical stimulus | Independent witness / observation | Required reset/restart check | Result / evidence label |
|---|---|---|---|---|
| | | | | |
| | | | | |
| | | | | |

Minimum reasoning questions:

1. Did the test stimulate the real physical path, or only force a software value?
2. Did it exercise the replaced component's sensing/final-element/feedback role?
3. Was the observation independent enough to establish the claimed physical result?
4. Were fault detection, reset, restart and rearm behaviors challenged where affected?
5. Did configuration identity, calibration, mounting or field wiring change enough to invalidate prior evidence?
6. What remains `UNKNOWN` after the test?

Never invent stopping distance, pressure threshold, valve truth table, PL/SIL/category, diagnostic coverage, or proof-test interval from this card.

## 8. Release decision

- [ ] `IN-SERVICE-VALIDATED` — required bounded revalidation passed and evidence retained.
- [ ] `INSTALLED-PENDING-VALIDATION` — physical installation complete but safety evidence incomplete.
- [ ] `FAILED / INVESTIGATION` — challenge failed or behavior contradicted the approved basis.
- [ ] `QUARANTINE` — identity/provenance/equivalence/storage/configuration uncertainty blocks use.

Released by: __________  Date: __________
Evidence package / work order / CMMS link: ______________________________

## 9. Change invalidation triggers

Re-open this evidence if any dependency relevant to the function changes, including controller/firmware, safety I/O identity, field wiring, protective-device mounting, final element, drive/safe-motion configuration, calibration/teach data, safety-network identity, replacement-part revision, or a newly discovered manufacturer restriction.

A previous PASS survives only for claims whose dependency chain remains valid.

## 10. Practical bin label

For a physical bin, the visible label should contain only the minimum unambiguous retrieval information and point to this full evidence record:

`SAFETY SPARE — [PART NUMBER] — STATE: [APPROVED-SPARE / QUARANTINE / ...] — RECORD: [ID] — VERIFY CURRENT RECORD BEFORE INSTALLATION`

Do not print `SAFE`, `DROP-IN`, or `VALIDATED` on an uninstalled spare. Those words can erase the distinction between procurement readiness and validated machine behavior.
