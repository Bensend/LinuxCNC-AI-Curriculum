# 4000 Safety Primary Checkpoint — 2026-09-18T01:44Z

## Session timing
- Start UTC: 2026-09-18T01:36:01Z
- End UTC: 2026-09-18T01:44:00Z
- Actual elapsed: 8.0 minutes
- Overlap status: parallel Lane B had advanced mirror/EDM semantics before this run; this primary run remained on the distinct hydraulic/fall-protection branch and did not overwrite Lane-B artifacts.

## Governance/current-state check
Read START_HERE first and recovered newest durable state. 1000/2000/3000 remain closed; 4000 safety remains primary. Newest parallel checkpoint was `15e77d7c` (mirror-contact proof boundary); primary hydraulic checkpoint remained `2edf4b88`.

## Durable result
Created `safety-course/HAWE_EPRAX_MONITORED_PRESS_BEAM_HOLDING_TRACE_2026-09-18.md` in commit `068cc61869fb8a46be32f9ae3601b02bbfe7395a`.

The 2026 HAWE B 6340 ePRAX operating instructions close a significant evidence gap: they expose a gravity-accelerated press beam; multiple hydraulic valves explicitly identified as SRP/CS actuators; BG position switches monitored by the safety controller; a separate piston-side pressure sensor; a documented de-energized IDLE state in which QM2/QM3 hold the beam and QM4/QM5 prevent unintended pressurization; optional accumulator energy; and a stronger maintenance requirement to depressurize relevant volumes and secure raised loads.

New freeze:

**SAFETY DEMAND -> SAFETY OUTPUT -> FINAL VALVE ACTUATION -> ACTUAL VALVE POSITION -> HYDRAULIC PATH -> RELEVANT PRESSURE/ENERGY WITNESSES -> LOAD STATE -> RESET/RE-ENABLE -> FRESH ORDINARY START.**

Maintenance additionally requires stored-energy isolation/release and physical load restraint where the task/hazard requires it.

No HAWE valve truth table, pressure value, timing, PL/SIL/category, stopping performance, or leakage allowance is imported into OpenPressBrake. Its installed hydraulic topology remains UNKNOWN pending machine evidence.

## Compute
No simulation/build/test was justified. No GitHub-hosted Actions or self-hosted runner compute was used.

## Precise next primary work
1. Trace the HAWE B 6340 function diagram/circuit appendix far enough to map each monitored QM2-QM5 element to its hydraulic blocking/holding objective across stop/IDLE, without extrapolating beyond the manufacturer drawing.
2. Seek manufacturer evidence for reset/re-enable behavior after a safety-controller stop; if B 6340 does not expose it, preserve UNKNOWN and pair this hydraulic final-element trace with a separate authoritative safety-controller integration document rather than inventing the sequence.
3. Build a commissioning fault-injection card around disagreement between command, BG position feedback, BP pressure evidence, beam motion, accumulator energy, and stale ordinary LinuxCNC commands.

## LESSON_LOG safe append payload
The GitHub connector does not expose an append primitive and LESSON_LOG is known to be large/truncation-sensitive. Do not reconstruct/overwrite it from an incomplete fetch. Safe append row to apply when the repository's append mechanism is available:

`2026-09-18T01:36:01Z | 2026-09-18T01:44:00Z | 8.0 min | 4000 Safety | HAWE ePRAX monitored press-beam holding/fall-protection trace | overlap: Lane B mirror/EDM lane distinct | compute: none | commit 068cc618`
