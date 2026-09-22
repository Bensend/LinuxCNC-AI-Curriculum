# 4000 Safety continuation checkpoint — 2026-09-22T06:47Z

## Durable work completed

- Added `safety-course/FINDING_DISPOSITION_RECORD_TEMPLATE.md`, integrated with `SF-*`, `PROP-*`, `EVID-*`, `DEP-*`, `CHG-*`, `VAL-*` identities.
- Added `safety-course/25E0_NON_BRAKE_COMMON_CAUSE_AND_RECURRENCE_ESCALATION_2026-09-22.md`.
- Traced SICK safety-laser-scanner contamination/calibration evidence and Rockwell safety field-power/environment dependencies.
- Added recurrence classification and escalation review across design, maintenance/proof, environment/process, and human-factors lanes.
- Updated `PROGRESS.md`.

## Frozen distinctions

- `SEPARATE LOGIC CHANNELS != SEPARATE PHYSICAL/ENVIRONMENTAL DEPENDENCIES`.
- `DEVICE DIAGNOSTIC HEALTHY != SHARED ENVIRONMENTAL CAUSE ABSENT`.
- `CLEANED != DEVICE-SPECIFIC CALIBRATION/REPROOF COMPLETE`.
- `POWER RESTORED != ALL DEPENDENT SAFETY PROPOSITIONS REVALIDATED`.
- `RECURRENCE != ROOT CAUSE PROVED`.
- `REPEATED REPAIR SUCCESS != RECURRING DEFECT DISPOSITIONED`.

## Exact next work

1. Connect recurrence escalation to corrective/preventive-action ownership and shift/maintenance handoff persistence.
2. Trace an authoritative mechanical-coupling or mounting/alignment common-cause example.
3. Build a nuisance-trip human-factors adversarial exercise: recurrence is a design/workflow warning, not justification to weaken protection.
4. Keep ordinary LinuxCNC/FPGA as diagnostic/evidence surfaces, not personnel-safety acceptance authority.
5. No compute is currently justified. Future question-driven compute must use `[self-hosted, openpressbrake]` only; never GitHub-hosted runners.