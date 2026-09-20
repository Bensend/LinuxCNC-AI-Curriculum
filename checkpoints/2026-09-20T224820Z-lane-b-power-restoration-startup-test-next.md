# 4000 safety Lane B checkpoint — power restoration and startup-test authority

UTC checkpoint: 2026-09-20T22:48:20Z

## Parallel-lane selection

Primary lane's newest durable work is hydraulic safety actuator repair/recommissioning and safety-time revalidation. Lane B deliberately avoided hydraulic final-element, post-repair timing, and related files and instead advanced the independent power-restoration/unexpected-restart branch.

## Durable advance

Added `safety-course/POWER_RESTORATION_STARTUP_TEST_AND_UNEXPECTED_RESTART_AUTHORITY_STUDY_2026-09-20.md`.

Manufacturer evidence now separates power restoration, safety-input startup/requalification testing, reset/rearm, and ordinary machine start. Pilz documents a startup test specifically preventing automatic restart after power failure/voltage return; PNOZ s5 warns that automatic or defeated manual-start wiring can automatically start when a safeguard resets; Rockwell documents monitored-manual reset as a deliberate off-on-off pulse rather than a continuously high reset level.

## Frozen distinctions

- CONTROL POWER RESTORED != SAFETY INPUTS REQUALIFIED.
- SAFETY INPUTS HEALTHY != STARTUP TEST COMPLETE.
- STARTUP TEST COMPLETE != SAFETY RESET/REARM ACCEPTED.
- SAFETY RESET/REARM ACCEPTED != ORDINARY MACHINE START.
- RESET INPUT HIGH ACROSS POWER RESTORATION != FRESH DELIBERATE RESET ACTION.
- ORDINARY START/JOG/CYCLE HELD ACROSS POWER LOSS/RESTORATION != FRESH POST-RESTORATION MOTION AUTHORITY.

## Boundary

OpenPressBrake power domains, safety reset mode, startup-test requirement, E-stop/guard topology, hydraulic safe state, final elements, PL/SIL/category/DC/CCF and production-release sequence remain UNKNOWN. Do not copy manufacturer-specific reset timing or safety-mat startup sequences into the design.

## Next work

Generic reset-mode cataloging is now low-value. Seek a complete OEM/machine commissioning sequence that deliberately challenges power loss/restoration with an ordinary motion request held, then proves startup requalification, deliberate reset/rearm, stale-command rejection, separate fresh ordinary start and actual downstream final-element/machine response. Prefer a deliberate reset-contact or safety-input fault if authoritative evidence exposes one.

If the primary lane enters this exact evidence package first, rotate Lane B to another independent 4000 safety branch rather than duplicate it.

No executable compute was justified. No GitHub-hosted runner was used.