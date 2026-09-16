# 4000 Safety Lane B Checkpoint — 2026-09-16i

## Completed

Added `safety-course/LOST_PERSONNEL_KEY_ADMINISTRATIVE_STATE_RECOVERY.md`.

The module freezes the distinction between credential recovery, personnel-accounting recovery, physical safeguarded-space clearance, safety reset, safety permission, ordinary LinuxCNC/FPGA rearm and start. Pilz documentation confirms individually programmed RFID keys plus a safe list, blocking/reprogramming after a lost transponder, authorized `key list reset`, and separate blind-spot checking where there is no overall view.

Critical rule: `administrative_state_recovered` is not `physical_space_proven_empty`. An authorized list deletion, controller reboot/replacement, replacement token, or restored database must never silently convert indeterminate occupancy into an empty/clear state.

Added adversarial recovery cases for lost keys, duplicate/spare credentials, stale backups, controller replacement, remote list reset, queued reset replay, commissioning master credentials and blind-spot bypass. LinuxCNC/ordinary FPGA remain diagnostics/ordinary-control participants, not sole personnel-safety authority.

No compute consumed; source/documentation work answered the question without simulation.

## Parallel-lane check

Immediately before the durable module commit, current `main` still ended at the Lane-B reset-location checkpoint. Immediately after the module commit, `main` was re-read and no overlapping concurrent files had appeared. This work used new module/checkpoint files and did not overwrite another lane.

## Next independent work

Study **safety-event logging, audit trails, and evidence integrity**. Cover what should be recorded for bypass/override, lost credentials, exceptional list reset, guard/interlock/EDM faults, safety reset/rearm, configuration/firmware changes and validation runs.

Keep `event was logged` separate from `physical safety function occurred`. Analyze clock loss, reordered/stale events, reboot gaps, buffer overflow, log tampering, remote telemetry loss and configuration identity. Logs should support diagnosis/change control and evidence provenance but must not become personnel-safety authority. Preserve SOURCE-CONFIRMED / DOC-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED / INFERENCE / UNKNOWN.