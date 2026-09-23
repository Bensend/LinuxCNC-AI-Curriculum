# 25A0 — Programmable safety lifecycle, evidence separation, and release gate

Session start: 2026-09-23T14:37:01Z

## Purpose

Close the remaining learner-facing gap in 25A0: a safety PLC is not only an execution device. Its validated state includes hardware identity, safety program, safety parameters, communication identity/timing, field wiring assumptions, final elements, and the physical machine behavior established during validation.

## Evidence classes

- **DOC-CONFIRMED — Siemens Programming Guideline Safety V1.6 (07/2024):** F-signatures identify fail-safe project state. Siemens distinguishes collective F-signature, F-HW signature, F-SW signature, and F-communication address signature. A changed signature requires renewed validation/acceptance. Siemens recommends signatures for reliable change tracking and notes that after hardware replacement an unchanged F-SW signature can establish only that the safety software itself is unchanged.
- **DOC-CONFIRMED — Siemens S7-1200 Functional Safety Manual V4.6 (11/2022):** safety message CRC/signature protects process data/address/parameter integrity; communication errors cause passivation. Firmware update and restart are explicit lifecycle operations rather than transparent non-events.
- **DOC-CONFIRMED — Pilz PNOZmulti Configurator:** completed configurations can be certified/protected against unwanted changes; configuration documentation is part of commissioning/maintenance practice.
- **DOC-CONFIRMED — Pilz PNOZmulti replacement behavior:** controller startup compares the removable-card program and internal program and faults on mismatch; accepting a new program is an explicit operation.
- **DOC-CONFIRMED — Pilz machinery validation guidance:** validation applies through the machine lifecycle and is used to establish that protective measures were implemented correctly.
- **INFERENCE:** therefore a replacement CPU, I/O module, firmware revision, communication-address change, diagnostic parameter change, or program change cannot be treated as safe merely because the machine returns to RUN. The required revalidation scope depends on what evidence changed.

## Lifecycle/change-control model

Treat the accepted safety configuration as an evidence bundle, not a file:

`SRS + HW identity + F-I/O configuration + safety program + safety parameters + communication identity/timing + field wiring + final-element assumptions + validation results + proof-test assumptions`

A change request must identify which terms changed and which prior evidence remains valid.

### Change examples

| Change | Evidence that may remain valid | Evidence requiring review/revalidation |
|---|---|---|
| safety-program logic edit | unchanged mechanical drawings may remain useful | F-SW identity, logic verification, affected safety functions, response/restart behavior |
| discrepancy time increased | program topology may be unchanged | response-time assumptions, fault-detection timing, affected SRS requirements |
| F-I/O module replacement same order number | safety logic may be unchanged | exact compatible HW/FW identity, parameters/address, wiring, channel diagnostics, functional proof |
| substitute I/O family | hazard/SRS may remain | compatibility, test-pulse behavior, timing, diagnostics, integrity claims, validation |
| firmware update | machine hazard model may remain | vendor compatibility/release constraints, safety signatures/configuration, affected validation evidence |
| F-address/network topology change | application logic may remain | communication identity/signature, timeout assumptions, commissioning tests |
| contactor/valve replacement | PLC program may remain | load/switching suitability, feedback behavior, mechanical/fluid safe-state proof, proof-test assumptions |
| proof-test interval extended | hardware may be unchanged | reliability/latent-fault assumptions and maintenance validation |

## Freeze statements

- **MACHINE RUNS AFTER CHANGE != SAFETY EVIDENCE PRESERVED.**
- **F-SW SIGNATURE UNCHANGED != COMPLETE SAFETY FUNCTION UNCHANGED.**
- **SAME PART NUMBER != SAME VALIDATED CONFIGURATION.**
- **FIRMWARE UPDATE SUCCESS != SAFETY REVALIDATION COMPLETE.**
- **PARAMETER-ONLY CHANGE != NON-SAFETY CHANGE.**
- **REPLACEMENT DEVICE PASSES SELF-TEST != FIELD SAFETY FUNCTION PROVED.**
- **BACKUP RESTORED != PHYSICAL MACHINE STATE VALIDATED.**
- **PROOF-TEST ASSUMPTION CHANGED != RELIABILITY CLAIM UNCHANGED.**

## Compact learner exercise — five evidence layers

A guarded spindle uses an OSSD interlock into fail-safe I/O, a safety PLC, PROFIsafe remote output, dual contactors, and a speed sensor used for guard release. Maintenance replaces the remote F-I/O and increases a communication monitoring time to suppress intermittent trips. The safety program's F-SW signature is unchanged. The machine starts and the guard-release lamp behaves normally.

For each claim below, label the strongest evidence layer that could establish it and state what remains unproved:

1. The OSSD channels and input wiring are being diagnosed as intended. **Input-diagnostic evidence.**
2. The safety application still implements the accepted Boolean/state logic. **Safety-program identity/verification evidence.**
3. Safety telegram identity, freshness and timeout behavior remain within the accepted design. **Communication evidence.**
4. The contactors actually interrupt the intended hazardous-energy path and feedback detects the specified failures. **Final-element evidence.**
5. The spindle is below the validated release condition before the guard unlocks. **Physical-safe-state evidence.**

Required conclusion: an unchanged F-SW signature is useful evidence for item 2 only. It cannot, by itself, establish 1, 3, 4 or 5. The F-I/O replacement and monitoring-time change create revalidation work even if no safety-program source changed.

## 25A0 syllabus audit

Active syllabus requirements are now learner-facing:

- safety PLC versus ordinary PLC — covered in source preparation;
- redundant/diverse processing, self-tests/watchdogs — source preparation;
- safe I/O, test pulses, cross-short detection and discrepancy timing — source preparation + end-to-end fault matrix;
- black-channel communication — end-to-end PROFIsafe trace;
- software configuration as only one part of the safety case — end-to-end trace + this lifecycle artifact;
- inspectable/open functional-safety project with tests/limitations — end-to-end artifact;
- lifecycle/change control — this artifact;
- evidence-layer separation — compact exercise above.

No material learner-facing syllabus gap remains.

## Canonical learner route

1. `SAFETY_COURSE_RESEARCH.md` — 25A0 syllabus only.
2. `research/25A0_PROGRAMMABLE_SAFETY_SOURCE_PREP_2026-09-23.md`.
3. `research/25A0_END_TO_END_AND_BLACK_CHANNEL_2026-09-23.md`.
4. This artifact.
5. Attempt a fresh competency evaluation without reading evaluator-only scoring/solution material.

## Release gate

25A0 is **READY FOR EXTERNAL/FRESH EVALUATION**, not graduated.

A fresh evaluator should require the learner to handle a novel programmable-safety architecture and demonstrate that they can:

- separate controller self-diagnostics from field/final-element/physical proof;
- reason about test pulses, discrepancy timing and interface compatibility;
- explain black-channel safety without calling ordinary Ethernet safety-rated;
- trace safe communication timeout through to the actual final element;
- identify common-cause/dependency failures that software diagnostics cannot eliminate;
- identify which changes invalidate which evidence;
- preserve reset/restart and LinuxCNC/non-safety authority boundaries;
- refuse to infer machine PL/SIL or physical safe state from component certification or correct logic alone.

Critical failure: granting ordinary LinuxCNC/FPGA logic sole personnel-safety authority, inventing application-specific physical facts, or accepting a machine for exposed operation when the physical safe state is not established.

## Compute decision

No executable question is unresolved here. No simulation, build, synthesis, benchmark or test suite is justified; therefore no runner is dispatched and no GitHub-hosted compute is used.
