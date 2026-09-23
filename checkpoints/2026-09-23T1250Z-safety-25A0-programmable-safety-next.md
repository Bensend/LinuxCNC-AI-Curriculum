# Safety curriculum checkpoint — 25A0 programmable safety next

## Durable state

- 2590 line-item syllabus audit found no material learner-facing gap.
- `research/2590_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md` and `evaluation/2590_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` now release 2590 to fresh external evaluation without self-graduation or answer contamination.
- 25A0 is the active named safety-course branch.
- Initial manufacturer-grounded source prep separates safety-controller internal diagnostics, safe input test pulses, discrepancy timing, safe-output test behavior, application program logic, field wiring/final elements and machine physical proof.
- No executable compute is currently justified.

## Exact next work

1. Trace one safety-controller family end-to-end: CPU/internal self-tests -> safe input diagnostics -> application execution -> safe output diagnostics -> external final element. Record the narrow proposition each layer supports.
2. Build a wiring/fault matrix for dual-channel dry contacts, OSSD devices and test-pulse/PNP variants. Include opens, cross-shorts, shorts to 24 V/0 V, discrepancy/timing faults, and device incompatibility; mark detection as documented, topology-dependent or unknown.
3. Study an authoritative black-channel safety communication implementation/application guide. Separate safety-code/counter/time/authenticity mechanisms from ordinary transport availability and do not infer safety from Ethernet reliability.
4. Inspect at least one open/inspectable functional-safety project with published hazard analysis, tests and known limitations, satisfying the syllabus research requirement without equating openness to certification.
5. Create an adversarial case where a safety PLC program is logically correct yet the physical safety function is invalid because of a field-interface, response-time, common-cause or final-element assumption.
6. Preserve all 2520–2590 external information-separated gates.

## Compute

Do not use GitHub-hosted compute. The current questions are source/documentation questions. If a later concrete question genuinely requires execution, use only `[self-hosted, openpressbrake]` and record authoritative runtime.
