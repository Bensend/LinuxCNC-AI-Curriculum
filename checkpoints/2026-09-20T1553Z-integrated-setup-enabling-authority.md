# Checkpoint — integrated setup/enabling authority

Date: 2026-09-20

## Durable work

- `safety-course/SICK_SAFE_STATIONARY_MACHINE_SERVICE_MODE_RESET_ENABLE_START_AUTHORITY_TRACE_2026-09-20.md`
- `safety-course/ROCKWELL_ENABLING_SWITCH_HELD_JOG_PHYSICAL_POWER_REMOVAL_TRACE_2026-09-20.md`
- `PROGRESS.md` advanced to reflect the new information-gain boundary.

## Result

Manufacturer evidence now establishes a useful integrated authority ladder: selected setup/service mode, healthy safety preconditions, reset, valid enabling-device state and separate jog/start are distinct authorities. SICK's worked setup training implementation restricts setup motion to reduced speed. Rockwell's worked safety function traces release/full squeeze through safety relay outputs to K1/K2 de-energization and physical hazardous-motion power removal/coast stop.

Preserve the source difference around exact post-panic re-entry: SICK explicitly prohibits reactivation while returning 3->2; the Rockwell worked application does not itself prove that detailed transition semantic. Do not silently generalize.

## Exact next work

Do not spend another session on generic enabling-switch architecture. Seek an explicit manufacturer/OEM acceptance procedure that tells a commissioner to hold jog/inch while physically challenging release, full squeeze and 3->2 recovery, then exits setup, restores/requalifies the ordinary safeguard, rejects stale commands and requires a fresh production start. If unavailable after a bounded search, mark this combined acceptance path source-limited and rotate to the highest-value open safety module.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted runner was used.
