# Safety curriculum checkpoint — return-to-service restoration

Date: 2026-09-17
Status: CHECKPOINTED / safety course remains primary active priority
Compute: NONE. No GitHub-hosted Actions minutes and no self-hosted compute were used; the question was resolved by source/documentation and engineering analysis.

## Session result

Created `safety-course/RETURN_TO_SERVICE_RESTORATION_SWEEP_WORKSHEET.md`.

Artifact commit: `097901a8954a4a35fbb3d9f25ee07f80aaceefd3`.

## Frozen learning

1. LOTO release, successful repair, LinuxCNC reboot, cleared diagnostics and successful jog are distinct from production release.
2. Restoration needs positive reconciliation of temporary physical and software states: jumpers, test plugs, external supplies, forces/overrides, diagnostic firmware, removed guards, temporary hoses/gauges, blocks/restraints and service tooling.
3. A software restart cannot prove physical restoration.
4. OSHA 1910.147(e) requires pre-reenergization inspection/employee positioning and controlled LOTO removal/notification; 1910.147(f)(1) makes energized testing/positioning a bounded transition that returns to deenergized energy control before exposed servicing continues.
5. Removal of gravity/mechanical blocking is itself a safety transition: establish what protective function takes over before removing the restraint. Some blocking can require bounded reenergization for safe removal; this does not justify open-ended servicing under power.
6. Replacement/change state must be compared with the approved baseline. Physical interchangeability does not prove safety-function equivalence.
7. Distinguish safety-output command, electrical output state, final-element physical state, feedback/EDM agreement and actual hazardous-actuator state.
8. Safety reset/restart-interlock release, safety fault acknowledgment, LinuxCNC/FPGA recovery, ordinary actuator rearm and production START remain separate transitions.
9. `OUT OF SERVICE` remains until restoration and required validation evidence are complete. Safety-relevant UNKNOWNs are not converted to PASS by schedule pressure or an apparently healthy HMI.

## Evidence classification

- OSHA 29 CFR 1910.147(d)(5)-(6), (e), and (f)(1): `SOURCE-CONFIRMED`.
- OSHA Appendix A restoration sequence and enforcement guidance on safeguard replacement: `SOURCE-CONFIRMED`.
- Requirement that safety-relevant modifications receive applicable validation/revalidation beyond mere LOTO release: `INFERENCE`, bounded to the machine's applicable safety design/validation requirements; no generic PL/SIL/category is assigned.
- No machine-specific hydraulic state, pressure, stopping distance, safe speed, diagnostic coverage or safety rating was invented.

## Exact next work

Apply the restoration sweep to a complete professional implementation and mark every cell `CLOSED FROM EVIDENCE`, `NOT APPLICABLE`, or `UNKNOWN`.

Priority order:

1. modern CNC press brake with complete safety-controller + electrical + hydraulic documentation;
2. if that source remains incomplete, a complete servo machine tool or automation-cell reference with inspectable final elements;
3. use the application to identify gaps in the worksheet and correct them;
4. then build a bounded validation/commissioning evidence package: demand each safety function, observe final elements/feedback, exercise representative detected faults, verify reset/restart behavior, and preserve as-built baseline identity.

Do not run simulation merely to populate the worksheet. Compute is justified only for a concrete unresolved behavior that authoritative documentation/source cannot settle; if needed, target `[self-hosted, openpressbrake]` only.
