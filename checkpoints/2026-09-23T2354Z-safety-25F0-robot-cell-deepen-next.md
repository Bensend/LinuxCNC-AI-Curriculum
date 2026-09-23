# Safety curriculum checkpoint — 25F0 robot/cell deepening next

UTC checkpoint: 2026-09-23T23:54Z

## Durable state

- Mill/VMC baseline and lathe/turning-center delta remain durable.
- `research/25F0_ROBOT_CELL_CAPSTONE_DELTA_2026-09-23.md` now opens the robot/cell transfer with whole-body access, occupancy/restart, manual/setup enabling, associated machinery/peripheral energy, maintenance isolation, authority allocation and human-factor boundaries.
- Authoritative anchors currently include OSHA robot barrier/restart guidance, ABB manual-operation/enabling/reset guidance and Rockwell presence-sensing examples.
- New freezes include `PERIMETER GATE CLOSED != SAFEGUARDED SPACE KNOWN EMPTY`, `ROBOT STOPPED != CELL SAFE STATE PROVED`, `ROBOT CONTROLLER SAFE STATE != PERIPHERAL MACHINE SAFE STATE`, `SAFETY RESET COMPLETE != CELL OCCUPANCY CLEARED`, and `SOFTWARE JOG LIMIT != SAFE MANUAL OPERATION PROVED`.
- No executable compute was justified; no GitHub-hosted compute was used.

## Exact next work

1. Deepen the robot/cell case with authoritative manufacturer documentation for safeguarded-space entry, enabling-device/manual-mode behavior, restart and coordinated peripheral safety.
2. Build the explicit transferred/modified/new SRS matrix against the mill/lathe baselines.
3. Add adversarial cases for hidden person after gate closure, robot stopped/peripheral active, reset from poor visibility, enabling-device misuse and multi-person entry.
4. Keep stop times/distances, separation distances, safe-speed values, PL/SIL targets and proof-test intervals UNKNOWN until justified.
5. Then begin the press-brake capstone with gravity, hydraulic stored energy, point-of-operation access and independent safety-boundary emphasis.
6. Compute remains question-driven and self-hosted-only `[self-hosted, openpressbrake]`.