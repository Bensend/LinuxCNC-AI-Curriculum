# 4000 safety checkpoint — Siemens SBT two-witness proof

UTC checkpoint: 2026-09-21T13:51Z

## Completed

- Traced Siemens SINAMICS Safe Brake Test as a professional active proof architecture combining a final mechanical retaining element with an independent process-motion witness.
- SBT deliberately applies configured force/torque against an applied brake and judges measured axis motion against a configured position tolerance.
- Added adversarial exercise separating brake command/status, challenged holding capability, process response, safety rearm, and ordinary demand freshness.
- Updated PROGRESS.md.
- No simulation/build/test compute was justified; no GitHub-hosted runner was used.

## Frozen boundaries

- BRAKE COMMAND/STATUS != BRAKE HOLDING CAPABILITY PROVED.
- SBT PASS != ALL HAZARDOUS ENERGY SAFE.
- SBT PASS != FUTURE BRAKE PERFORMANCE GUARANTEED.
- MOTION WITHIN TEST TOLERANCE != ZERO MOTION.
- BRAKE TEST PASS != ORDINARY START AUTHORITY.
- Do not copy OEM test torque, displacement tolerance, proof interval, PL/SIL, or reset semantics into OpenPressBrake.

## Exact next work

Prefer one of these evidence-gain paths:

1. Find a professional implementation that combines two witness classes continuously or during every hazardous transition, rather than only during a periodic/commissioning proof test; preferred examples are retaining/brake state + independent motion or valve position + pressure/motion.
2. If stronger authoritative SINAMICS documentation exposes the SBT failure/return-to-service state machine, trace failure latching, retest/reset requirements and held-demand behavior. Do not infer those semantics from Rockwell SBC, Siemens 3SK1, or generic safety-relay behavior.

If neither path gains authoritative evidence promptly, record the source limit and rotate to another high-value 25E0/25C0 branch.
