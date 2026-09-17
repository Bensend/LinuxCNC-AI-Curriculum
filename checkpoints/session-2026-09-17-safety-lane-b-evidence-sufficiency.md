# Safety curriculum Lane B checkpoint — evidence sufficiency

Date: 2026-09-17
Status: CHECKPOINTED — independent safety lane remains active
Compute: NONE; source/documentation reasoning only. No GitHub-hosted Actions minutes consumed.

## Parallel-work check

At selection time, current main showed the primary lane had just completed `safety-course/RETURN_TO_SERVICE_RESTORATION_SWEEP_WORKSHEET.md` and its checkpoint. Lane B's previous proposed return-to-service branch therefore overlapped and was abandoned before work began.

Lane B selected a separate evidence-method artifact instead. Immediately before the durable artifact commit, main was re-read and still showed the primary return-to-service work as newest durable work; no overlap with the new file was found. Immediately after the artifact commit, main was checked again and no competing primary-lane change had appeared.

## Durable work completed

- Added `safety-course/SAFETY_CLAIM_EVIDENCE_SUFFICIENCY_LADDER.md`.
- Artifact commit: `be8b05dbf0c8e87cd2de3890133960491deb6508`.

## Key freeze

`controller intent -> output state -> final-element witness -> energy-path witness -> physical hazardous-effect response -> fault-path challenge -> configuration/change validity` are distinct evidence layers.

Evidence is sufficient only for the claim it actually observes. A green HMI bit, LinuxCNC Machine-Off, FPGA zero command, safety output OFF, EDM contact, STO status, pressure indication, or pump dropout must not be silently promoted into proof of a stronger physical safety claim.

## Evidence anchors

- OSHA 29 CFR 1910.147(d)(3), (d)(5), and (d)(6): physical energy isolation, stored-energy control, and verification before servicing.
- OSHA Appendix A: practical isolation verification and explicit stored-energy examples.
- SICK deTec4 Core operating instructions: restart interlock and downstream-contact monitoring via EDM are distinct functions; reset readiness is not machine start.

All machine-specific press-brake hydraulic truth tables, pressure thresholds, stopping distances, safe-speed values and diagnostic-coverage claims remain `UNKNOWN` unless supported by the actual design, documentation, calculation or measurement.

## OpenPressBrake boundary

Ordinary LinuxCNC/HAL/FPGA traces remain valuable diagnostic evidence, but they do not become independent personnel-safety authority by correlation. In particular, zero proportional command, ordinary directional command removal, independent safety demand, hydraulic final-element state, energy-path control, gravity/ram restraint and actual hazardous-motion prevention remain separate claims.

## Exact next independent work

Build `safety-course/SAFETY_TEST_WITNESS_INDEPENDENCE_COMMON_CAUSE_REVIEW.md`.

Question: **can the evidence channel fail for the same reason as the safety path it is supposed to prove?**

Cover shared power supplies, shared PLC/FPGA variables, copied software state, common sensors, common network links, contactor auxiliary-contact limitations, pressure-sensor placement, fixture-induced common cause, and criteria for a physically independent witness. Preserve SOURCE-CONFIRMED / DOC-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED / INFERENCE / UNKNOWN. Keep this separate from primary-lane professional-machine wiring, return-to-service, setup/service-mode and restart architecture. No executable verification is presently justified.