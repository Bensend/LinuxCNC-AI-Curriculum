# 4000 Safety Lane B Checkpoint — 2026-09-16g

## Completed

Added `safety-course/WHOLE_BODY_ACCESS_TRAPPED_PERSON_RESTART_PREVENTION.md`.

The study freezes whole-body-access restart-prevention semantics: `guard_closed` is not `space_clear`; personnel accounting, presence detection, blind-spot inspection, escape-release state, safety reset, ordinary rearm and ordinary start remain distinct. Pilz Key-in-pocket documentation supplies an authoritative multi-person safe-list example and explicitly calls for a blind-spot check on large plants without an overall view. Rockwell trapped-key and stopped-motion products provide independent examples of mechanically sequenced access architecture. Presence-sensing field geometry remains a physical validation claim rather than a generic software bit.

Frozen boundary: LinuxCNC/ordinary FPGA may display/inhibit ordinary commands but cannot be sole authority that declares a whole-body-access space empty. Restart inhibition is also not equivalent to verified hazardous-energy isolation/LOTO.

No compute consumed; documentation/source reasoning answered the question.

## Next independent work

Study **safety reset location, line-of-sight, blind-spot confirmation and remote-reset defeat resistance** as a focused source-tracing module. Compare authoritative reset-ownership/manual-reset guidance with large-cell blind-spot-check patterns. Build a state/evidence contract that distinguishes `protective_device_clear`, `whole_space_checked`, `reset_request`, `reset_accepted`, `safety_permission`, `ordinary_rearm`, and `start`.

Do not invent universal visibility distances, scanner geometry, reset timing, PL/SIL, or a press-brake-specific restart rule. If the primary lane moves into reset-location/blind-spot work before the next run, switch instead to an independent **lost-personnel-key / administrative safety-state recovery** study covering fail-closed restart prevention after lost keys, controller reboot, corrupted accounting state and exceptional authorized list reset.