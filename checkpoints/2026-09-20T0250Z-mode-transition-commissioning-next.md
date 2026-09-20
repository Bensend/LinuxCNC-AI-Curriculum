# Safety checkpoint — operating-mode transition commissioning

Date: 2026-09-20

## Completed this session

Added `safety-course/OPERATING_MODE_TRANSITION_COMMISSIONING_AND_STALE_COMMAND_WITNESS_STUDY_2026-09-20.md`.

SICK Safe Stationary Machine provides a complete professional commissioning sequence across Automatic <-> Service transitions: mode change causes SS2; destination mode requires its own reset/requalification and a separate Start; Service mode additionally requires the enabling switch and reduced-speed behavior. Its E-stop test explicitly proves that enabling + Start after E-stop release but before Reset does nothing. This is a useful real stale-command/restart-order witness rather than a prose-only rule.

## Durable freeze

**ACCESS PERMISSION VALID != OPERATING MODE SAFELY SELECTED != EXACTLY ONE MODE VALID != MODE TRANSITION SAFELY COMPLETED != DESTINATION-MODE SAFEGUARDS/COMPENSATING FUNCTIONS VALID != RESET/REQUALIFICATION COMPLETE != ORDINARY START REQUEST FRESH != FINAL ELEMENT ACTED != PHYSICAL MACHINE BEHAVIOR SAFE.**

**MODE DISPLAY CHANGED != MODE TRANSITION COMPLETE.**

**MODE CHANGE != START.**

**START INPUT PRESENT != FRESH START AUTHORITY.**

## Evidence classification

- SICK Safe Stationary Machine behavior/checklist: DOC-CONFIRMED.
- Pilz selector/access constraints: DOC-CONFIRMED.
- Rockwell no-mode/multiple-mode fault/reset behavior: DOC-CONFIRMED.
- Application to OpenPressBrake architecture: bounded INFERENCE only; implementation remains UNKNOWN.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted or self-hosted runner compute was consumed.

## Exact next work

Primary priority remains press-brake hydraulic post-service proof. Continue searching for a press-brake OEM/manifold procedure that names the serviced holding/safety valve and connects it to an unmasked retaining/load test, physical ram/load witness, disposition, any dynamic stopping re-proof, safety rearm, and fresh production initiation.

For this Lane-B mode branch, only continue when evidence adds information beyond the SICK sequence, preferably:

`power loss/cold start -> safety mode state -> invalid/no/multiple-mode challenge -> motion remains inhibited -> reset/requalification -> stale ordinary command rejected -> fresh Start -> final element -> physical machine witness`

or a machine-specific hydraulic mode-transition implementation. Otherwise rotate to another safety branch rather than repeating generic selector documentation.
