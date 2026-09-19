# 4000 safety checkpoint — hydraulic function/proof boundary

## Durable advance

Added `safety-course/PRESS_BRAKE_HYDRAULIC_FUNCTION_DECOMPOSITION_AND_PROOF_BOUNDARY_2026-09-19.md`.

Current HAWE press-brake evidence keeps beam holding, switching/overtravel performance, and individual-function monitoring as distinct hydraulic/safety concerns. Freeze: `VALVE POSITION/MONITOR AGREEMENT != BEAM HOLDING PROOF != SWITCHING-TIME/OVERTRAVEL PROOF != COMPLETE SAFETY-FUNCTION VALIDATION != PRODUCTION AUTHORITY`.

## Evidence state

- DOC-CONFIRMED: HAWE press-brake documentation separately identifies beam movement, beam holding, switching time/overtravel, operator safety, and monitoring of individual functions.
- DOC-CONFIRMED: current SAKB architecture has a central control block plus two separate suction valves.
- UNKNOWN: public evidence still does not expose an OEM individual unmasked retention test after service/replacement of one press-brake holding/safety/suction valve.
- UNKNOWN: do not infer that a particular valve replacement automatically forces a specific stopping/start-up test sequence.

## Next work

Primary target remains a professional press-brake OEM/manifold service chain: `specific retaining/safety valve service -> physical ram/load-safe disposition -> replacement -> unmasked individual retention proof -> dynamic stopping-performance re-proof where applicable -> safety reset/rearm -> production initiation`.

If that path remains source-limited, rotate to Lane B final-element replacement/re-proof or the safety-network physical-final-element witness branch rather than inventing a hydraulic procedure.

No simulation/build/test compute was used. No GitHub-hosted runner was used.
