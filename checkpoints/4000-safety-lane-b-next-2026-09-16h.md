# 4000 Safety Lane B Checkpoint — 2026-09-16h

## Completed

Added `safety-course/RESET_LOCATION_BLIND_SPOT_REMOTE_RESET_DEFEAT_RESISTANCE.md`.

The module freezes a seven-stage restart-prevention evidence chain: `protective_device_clear`, `whole_space_checked`, `reset_request`, `reset_accepted`, `safety_permission`, `ordinary_rearm`, and `start_request`. It treats reset-station placement as an observation/evidence problem rather than inventing a universal distance. Remote HMI/network reset is now an explicit bypass/threat path when it can skip required whole-space confirmation. Stuck reset, retained start, controller reboot, commissioning bypasses and camera-only confirmation are adversarial cases.

Rockwell safety-instruction documentation supports deliberate reset-transition semantics and application-dependent manual versus automatic restart. The preceding Pilz whole-body-access evidence remains the source for explicit blind-spot checking on large plants without an overall view.

Frozen boundary: LinuxCNC/ordinary FPGA may display, inhibit, discard stale commands and require ordinary rearm, but may not be sole authority for declaring a whole-body-access space clear or accepting the personnel-safety reset.

No compute consumed; documentation and architecture reasoning were sufficient.

## Next independent work

Study **lost personnel-key / administrative safety-state recovery**. Cover fail-closed restart prevention after lost keys/tokens, corrupted or erased accounting state, controller reboot/replacement, exceptional authorized list reset, duplicate/spare keys, and restoration after maintenance.

Keep `administrative/accounting state recovered` separate from `physical safeguarded space proven empty`. Do not invent a universal key-in-pocket implementation, PL/SIL, timeout, maximum personnel count, or machine-specific recovery procedure.
