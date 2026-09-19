# 4000 safety checkpoint — Lane B muting / override authority

Date: 2026-09-19

## Durable advance

Added `safety-course/MUTING_OVERRIDE_PROTECTIVE_DEVICE_BYPASS_AUTHORITY_STUDY_2026-09-19.md`.

This lane was selected only after reading current curriculum policy/progress and the primary lane's newest hydraulic proof-boundary work. It deliberately avoids the primary hydraulic files/evidence package.

Freeze:

`MATERIAL PRESENT != VALID MUTING SEQUENCE != PROTECTIVE DEVICE SAFELY MUTED != OVERRIDE PERMITTED != OVERRIDE HELD != MOTION COMMAND != HAZARD SAFE != ORDINARY PRODUCTION AUTHORITY`.

Additional boundary: while a protective device is muted, that device is not currently protecting the hazard; the architecture must identify the alternate credited protection/state rather than treating `MUTED` as an ordinary mode bit.

## Evidence state

- DOC-CONFIRMED: Rockwell FSBM/TSAM-class muting uses defined sensor sequence/state to distinguish transported material from personnel; invalid sequence removes output authority/faults.
- DOC-CONFIRMED: Rockwell says muting removes the muted device's protection, so other protection must exist.
- DOC-CONFIRMED: Rockwell and Pilz constrain override to recovery use with hold-to-run/hazard-visibility conditions in their documented implementations.
- DOC-CONFIRMED: Pilz separates override activation from the control that initiates motion.
- DOC-CONFIRMED: SICK exposes override as a bounded state-machine recovery requiring defined muting/protective-device conditions and a valid override transition.
- UNKNOWN: OpenPressBrake applicability, sensor geometry/timing, override location, permitted recovery motion, safety performance level, and all machine-specific numeric parameters.

## Parallel-work check

Immediately before the substantive write, current main showed the primary lane on `PRESS_BRAKE_HYDRAULIC_FUNCTION_DECOMPOSITION_AND_PROOF_BOUNDARY_2026-09-19.md` / hydraulic proof checkpoint. After the Lane-B write, current main showed the Lane-B commit directly above that state with no intervening overlapping write. No shared primary safety file was modified.

## Compute

No simulation, synthesis, benchmark, or executable verification was justified. No GitHub-hosted runner or self-hosted runner compute was consumed.

## Precise next Lane-B work

Find a complete professional implementation exposing:

`normal protective field -> valid material-qualified muting sequence -> protective field interrupted while alternate protection/state remains valid -> invalid sequence fault -> production inhibited -> constrained hold-to-run override -> separate motion command -> material cleared -> protective field and muting sensors restored -> override exits -> safety-side normal state restored -> application-specific ordinary production restart`.

Prefer a manufacturer implementation with wiring/safety logic, actual final-element behavior, and deliberate invalid-sequence/override commissioning evidence. Do not infer that OpenPressBrake requires muting.