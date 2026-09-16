# 4000 Safety Course — Lane B Next Checkpoint

Date: 2026-09-16
Status: ACTIVE — INDEPENDENT LANE B

Completed: `safety-course/VALIDATION_FIXTURE_STORAGE_CONTROL_HUMAN_FACTORS.md` in commit `c89c990ef424dc794789b09b4b7a69328b1bae2e`.

## Parallel-lane separation

At selection, current `main` primary work was `checkpoints/session-2026-09-16-safety-wiring.md` / `safety-course/PROFESSIONAL_SAFETY_WIRING_REFERENCE_STUDY_01.md`, focused on complete OEM/professional E-stop/interlock wiring and electrical-to-hydraulic hazardous-energy boundaries. Lane B intentionally did not modify those files or pursue another OEM wiring trace.

The previous Lane-B checkpoint suggested a commissioning evidence-package structure, but `safety-course/COMMISSIONING_PERIODIC_VALIDATION_EVIDENCE_WORKSHEET.md` already substantially covers that evidence space. To avoid duplication, Lane B used its documented fallback: validation-fixture storage/control and technician human-factors failure analysis.

## Frozen findings

- A fixture capable of altering a safety-related signal, energy path, interlock state, or validation result is a temporary machine configuration, not merely a loose tool.
- `fixture removed`, `original wiring restored`, `software forces cleared`, and `affected safety function physically re-challenged` are distinct claims.
- Reboot or lost accounting must not promote fixture state to clear; unresolved state becomes `UNKNOWN`.
- Human-factors design should make normal restoration easier than improvised bypass retention: conspicuous/keyed fixtures, controlled storage, issue/return accounting, explicit alternate-energy/backfeed mapping, and post-removal challenge.
- OSHA 1910.333(b)(2)(v)(A) explicitly requires tests/visual inspections as necessary before reenergization to verify removal of tools, electrical jumpers, shorts, grounds, and similar devices.
- OSHA 1910.334(c) requires electrical test instruments and associated leads/connectors to be inspected and appropriately rated.
- OSHA machine-guarding/LOTO guidance supports physical guard/safety-device restoration and controlled temporary reenergization transitions.
- LinuxCNC/HAL and ordinary FPGA may assist accounting, display, logging, and restrictive inhibits, but cannot prove a physical jumper absent, guard restored, energy isolated, or hydraulic state safe.
- No machine-specific performance, pressure, speed, stopping distance, hydraulic truth table, PL/SIL/category, or proof-test interval was invented.

No executable verification was justified or consumed. No GitHub-hosted compute was used.

## Precise next independent work

First check the primary lane's newest durable work. If independent, build **safety configuration backup/restore provenance and disaster-recovery failure paths** covering controller replacement, stale backups, parameter/config restores, firmware downgrade, safety signature/configuration identity, lost calibration/configuration metadata, field-wiring mismatch, restore after hardware revision, and the exact validation boundary after recovery. Keep `backup restored` separate from `machine safety function validated`.

If the primary lane has moved onto configuration recovery/provenance, rotate to **spares/substitution and obsolete-component safety change control**: apparently equivalent relays, contactors, valves, sensors, drives/STO interfaces, firmware variants, terminal reassignment, and what evidence is invalidated by substitution.
