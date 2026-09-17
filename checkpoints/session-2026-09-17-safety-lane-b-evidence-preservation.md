# Safety curriculum Lane B — incident evidence preservation checkpoint — 2026-09-17

- Status: CHECKPOINTED — independent safety lane remains active.
- Primary-lane state read before selection: newest durable work was the PCSS-A modern press-brake application plus `FIELD_COMMISSIONING_MINIMUM_OPERATE_CARD.md`, commit `e23f04f0e79fc5e1201155620a801c8cd1cd27ed`.
- Parallel-work result: no duplication. Lane B stayed on incident evidence/reconstruction artifacts and did not modify primary commissioning, PCSS-A, mode-integrity, EDM/common-cause, or progress files.
- Compute: NONE. No executable question justified simulation/testing; no GitHub-hosted Actions minutes consumed and no self-hosted runner job was needed.

## Durable work completed

Added `safety-course/SAFETY_INCIDENT_EVIDENCE_PRESERVATION_FIRST_RESPONSE_CARD.md` in commit `f8b80148e8209ee845e2cb601182a39c3a2a5b54`.

Frozen rule: personnel protection, emergency response and physical hazardous-energy control always outrank evidence preservation. Once protected, unnecessary reset/rearm/start, history clearing, power cycling and configuration changes should be avoided until safely obtainable volatile/configuration/physical evidence is captured.

The card separates independent safety-controller evidence, final-element witnesses, hazardous-energy/physical evidence, and ordinary LinuxCNC/HAL/FPGA context. It requires source/time/freshness/configuration identity, records unavoidable evidence-changing safety actions, and preserves `UNKNOWN` rather than inferring machine behavior.

## Evidence basis

- OSHA 29 CFR 1910.147 establishes control of unexpected energization/startup and stored-energy release during covered servicing; energy-isolating devices physically prevent energy transmission/release and ordinary control-circuit devices are not energy-isolating devices.
- OSHA requires stored/residual energy to be relieved/disconnected/restrained/rendered safe and isolation/deenergization verified before work.
- OSHA Appendix A explicitly identifies elevated members, springs, flywheels, hydraulic systems and pressure among stored/residual-energy examples.
- Evidence-preservation sequencing beyond those safety obligations is an engineering/investigation inference and is labeled accordingly rather than represented as a universal OSHA incident-preservation procedure.

## Main re-read / overlap check

Immediately before the Lane-B artifact commit, current main still ended at primary commit `e23f04f0...`; no overlapping primary artifact had appeared. Immediately after Lane-B commit, main showed only the new Lane-B artifact ahead of that primary checkpoint. No reconciliation was required.

## Exact next independent work

Create `safety-course/SAFETY_POST_INCIDENT_CHANGE_REVALIDATION_MATRIX.md` unless the primary lane enters that package first. Map each post-incident repair/change class—safety wiring, safety configuration, sensor/protective device, contactor/valve/final element, hydraulic component, drive parameters, LinuxCNC/FPGA ordinary-control change, guard/mechanical change—to the safety claims invalidated and the document/configuration/physical challenges required before return to service.

Do not invent universal proof-test intervals, machine PL/SIL/DC, stopping distances, hydraulic truth tables, pressure thresholds or response-time acceptance values. If the primary lane takes change/revalidation work before the next run, switch to another independent incident/maintenance evidence artifact rather than editing overlapping files.