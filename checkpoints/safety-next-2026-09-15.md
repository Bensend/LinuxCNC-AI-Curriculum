# Safety Curriculum Next Work — 2026-09-15

## Current state

Primary curriculum priority remains Practical Machine Safety Engineering / 4000 safety-oriented boundaries. The 3000 series remains GRADUATED/CLOSED.

Durable evidence foundation includes `research/linuxcnc-safety-patterns.md`, `research/linuxcnc-iocontrol-estop-callflow-2026-09-15.md`, `research/safety-real-machine-integrations-and-relay-matrix-2026-09-15.md`, and `guides/safety-function-contract-first-pass-2026-09-15.md`.

New human-teaching contract: `guides/safety-human-first-course-and-simulator-contract-2026-09-15.md`.

## Human-course freeze

The safety course is deliberately more human-facing than the AI-first LinuxCNC curriculum. The finished learner layer leads with physical hazards, visible authority/energy paths, inexpensive practical protections, deliberate fault injection, troubleshooting and proof of safe-state behavior. Standards/manufacturer evidence remains rigorous underneath, but standards numbers/compliance prose should not dominate ordinary DIY lessons.

Owner principle: **there is always an inexpensive way to be safe.** This does not promise inexpensive retention of every machine capability during human exposure; isolation, guarding, energy removal, remote testing or refusing attended operation can be the inexpensive safe answer.

Industrial training evidence supports the teaching method: Pilz publicly teaches E-stop wiring, positive-guided versus ordinary relays, indicators, deliberate fault simulation/troubleshooting and external contactors; Rockwell SAF-COM101 similarly uses hands-on safety-relay/device/wiring fault troubleshooting. Borrow teaching patterns and public behavior, not proprietary course text.

## Safety simulator freeze

Proceed with a deterministic logic-level training simulator rather than machine physics simulation. It must model commanded state separately from actual device/energy state and preserve:

**ordinary-control request -> safety input state -> safety authorization -> energy-removal device state -> physical hazardous-energy state -> diagnostic witness**

First scenario family:
1. mill spindle / welded contactor + EDM;
2. router guard / bypassed switch;
3. VFD STO / LinuxCNC freeze;
4. plasma process-energy authority distinct from motion;
5. hydraulic/gravity actuator where electrical OFF does not prove physical safe state.

Component swapping and cost challenges are allowed, but the simulator must never encode `cheap = unsafe` or `expensive = safe`. Score the actual failure paths, reset/restart behavior, diagnostics, bypass resistance, maintainability and cost. Do not assign PL/SIL/category from the teaching simulator.

## Exact next work

1. Build **SIM-SAFE-01** as the first human lesson/state-machine specification using the already-scored welded-contactor/EDM exercise. Freeze state variables, transition rules, fault toggles, learner predictions, progressive diagnostic reveals and pass/fail transfer questions.
2. Reconcile SIM-SAFE-01 behavior against the exact PNOZ s4/X3 feedback/reset evidence already collected; numeric timing remains revision-sensitive and should be omitted unless exact current tables are verified.
3. Find a public LinuxCNC integration with explicit drive STO wiring and use it to ground SIM-SAFE-03 without inventing cabinet wiring.
4. Expand machine-family human examples while keeping physical safe states distinct.
5. Only after the logic specification is stable, prototype the simulator as static browser HTML/JS or equivalent deterministic state engine. No GitHub-hosted compute. If automated execution becomes useful, target only `[self-hosted, openpressbrake]`.

## Lab decision

No lab/compute was justified in this pass. Current work is source/documentation/curriculum/interface design. Do not spend hosted Actions minutes.
