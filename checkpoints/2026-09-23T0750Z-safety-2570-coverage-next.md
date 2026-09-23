# Safety curriculum checkpoint — 2570 coverage audit next

## Durable state

- 1000/2000/3000 remain GRADUATED/CLOSED; 4000 safety remains primary.
- 2520–2560 information-separated external gates remain OPEN and uncontaminated.
- 2570 now has a concrete SINAMICS S120 physical-proposition map and an ordinary-drive contactor fallback pattern grounded in manufacturer documentation.
- Spindle/coast and vertical/gravity hazards are traced without inventing machine data.
- A 2570 adversarial assessment now tests label substitution, STO/standstill confusion, SBC/brake-effect confusion, contactor fallback, feedback provenance, reset/restart and isolation boundaries.

## New freezes

- TORQUE-PRODUCING CAPABILITY INHIBITED != MOTION PROVED STOPPED.
- SAFE MONITORED STANDSTILL != DE-ENERGIZED DRIVE.
- SAFE BRAKE COMMAND != MECHANICAL BRAKE EFFECT PROVED.
- SUCCESSFUL BRAKE TEST != PERMANENT BRAKE HEALTH.
- CONTACTOR POWER REMOVAL != INTEGRATED STO BY LABEL SUBSTITUTION.
- CONTACTOR OPEN != DC BUS PROVED SAFE.
- SAFETY RESET != NORMAL MOTION START AUTHORIZATION.

## Exact next work

1. Audit 2570 against the current safety-course syllabus: STO, SS1/SS2/SOS, braking/holding, high-inertia coast, gravity loads, ordinary-drive fallback, stored energy, reset/restart, isolation, LinuxCNC authority boundary and validation.
2. Fill only material learner-facing gaps found by that audit.
3. If coherent, create the concise 2570 entry map/release gate and information-separated external evaluator handoff without hidden solutions.
4. Then recover the next named safety-course module and begin authoritative source preparation rather than manufacturing more 2570 notes.
5. Keep all machine-specific stopping times, brake capacities, safe distances, load behavior and integrity claims UNKNOWN unless applicable evidence exists.

## Compute

No executable compute was justified or consumed. No GitHub-hosted runner was used. Any later justified compute must target only `[self-hosted, openpressbrake]`.
