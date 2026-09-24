# Safety curriculum checkpoint — 25F0 press-brake fault matrix next

UTC checkpoint: 2026-09-24T01:50Z

## Durable state

- Professional architecture comparison is durable in `research/25F0_PRESS_BRAKE_PROFESSIONAL_ARCHITECTURE_TRACE_2026-09-24.md`.
- Fiessler AKAS-F + AKFH/AKFR gives an inspectable chain from optical/door/E-stop demand through safety evaluation to safe valve-enable contacts, with hydraulic valve-position transmitters fed back to AKAS-F and optional Y1/Y2 motion/overtravel sensing through AMS3.
- Bosch Rexroth's 2024 pump-controlled press-brake package independently demonstrates a normal servo-motor/four-quadrant-pump motion path plus a separate safety block with end-position-monitored on/off valves.
- HAWE evidence adds a third architecture family: press-beam holding/monitoring is a named requirement and EV2D provides safety-related valve shutdown; HAWE's functional-safety guidance reinforces safety-sub-function decomposition.
- New freezes: `VALVE POSITION EXPECTED != RAM SAFE STATE PROVED` and `SERVO PUMP ZERO COMMAND != HYDRAULIC SAFETY FUNCTION PROVED`.
- Controlled stopping, supply/actuation inhibition, valve feedback, load holding/gravity restraint, dump/decompression and maintenance isolation remain separate propositions.
- No executable compute was justified; no GitHub-hosted compute was used.

## Exact next work

1. Expand the seed fault table into SRS-linked validation cases.
2. Cover stuck motion-permitting valve, false valve-position feedback, broken safety channel, common electrical/pilot/hydraulic supply, safety-output removal, mains/control-power restoration, trapped/accumulator pressure, gravity-loaded beam and maintenance access inside the die space.
3. For each case record: demand, failed component/path, expected independent response, physical witness, residual hazardous-energy proposition, rearm condition and evidence class.
4. Keep `FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED` explicit.
5. Do not infer machine-specific spool truth tables, gravity behavior, stop limits, pressure limits, DC/PL/SIL or proof-test intervals.
6. If a fault case cannot be resolved from professional evidence, mark the physical proposition `UNKNOWN`; do not create a simulation merely to fill the row.
7. Any genuinely justified executable compute must use `[self-hosted, openpressbrake]` only.
