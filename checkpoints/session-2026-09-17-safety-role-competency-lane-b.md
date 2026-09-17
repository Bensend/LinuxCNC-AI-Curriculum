# Safety Lane B — role authorization / competency / retraining checkpoint — 2026-09-17

- Compute: NONE. No GitHub-hosted Actions minutes consumed; no executable question justified self-hosted compute.
- Status: CHECKPOINTED — safety course remains active.
- Parallel check: current main was re-read before durable work. Primary/newest durable work was document provenance/supersession and its proposed change-impact matrix; Lane B selected a different artifact and evidence package.

## Durable work

Added `safety-course/SAFETY_ROLE_AUTHORIZATION_COMPETENCY_AND_RETRAINING_MATRIX.md` in commit `a582c804`.

Frozen distinction:

`access != authorization != training attendance != demonstrated competence != current machine/configuration competence`

The artifact separates normal operator, setup, LOTO/service, safety reset/restart, controlled energized test, safety-configuration maintenance, LinuxCNC/HAL/FPGA maintenance, validation witness, and return-to-service release roles. It preserves the ordinary-controller/personnel-safety boundary and leaves machine-specific hydraulic/electrical/mechanical facts UNKNOWN until installed evidence exists.

## Evidence gain

OSHA 29 CFR 1910.147(c)(7) confirms hazardous-energy-control training requirements and retraining triggers when assignments, machines/processes/hazards, or energy-control procedures change, and when inspections or other evidence reveal knowledge/use deficiencies. Training certification must be current.

OSHA 1910.147(c)(6) confirms periodic LOTO inspection independence from the employee(s) using the inspected procedure, correction of deviations/inadequacies, responsibility review, and inspection certification fields. The curriculum keeps that rule bounded to its actual LOTO scope rather than falsely generalizing it to every functional-safety validation.

Pilz lifecycle documentation was used only as a professional documentation example for maintaining machine inspections, employee qualifications, validation and maintenance records; it was not promoted into a normative requirement.

## Exact next independent work

Build `SAFETY_CONTRACTOR_VISITOR_AND_TEMPORARY_PERSONNEL_INTERFACE_CARD.md` unless the primary lane enters that topic first. Cover host/contractor exchange of energy-control procedures, affected-vs-authorized role boundaries, visitor/observer exclusion, temporary-worker competence, responsibility for reset/restart/release, shift/personnel changes, and explicit prohibition on treating badge/access permission as safety authorization. Keep machine-specific hazard values UNKNOWN.

If that overlaps current primary work, switch to `SAFETY_SAFEGUARD_DEFEAT_KEY_OVERRIDE_ACCESS_REGISTER.md` focused on controlled keys/passwords/override tools, issuance/recovery, audit trail, temporary use, restoration, and why access control cannot substitute for the independent safety function.