# Safety curriculum Lane B checkpoint — maintenance handoff / shift continuity

Date: 2026-09-16
Status: CHECKPOINTED / independent safety lane remains active
Compute: NONE. Documentation/source analysis only; no GitHub-hosted Actions minutes consumed.

## Parallel-work check

Lane B re-read `START_HERE.md`, `LEVEL_ORDER.md`, `CURRICULUM.md`, `WORK_SELECTION_POLICY.md`, `PROGRESS.md`, the active primary checkpoint, recent commits, its prior checkpoint, and the primary lane's newest durable work before selecting work.

The primary lane's newest durable artifact at selection time was `safety-course/SETUP_SERVICE_MODE_AND_BYPASS_RESISTANCE_2026-09-16.md` (`1aac6c7b7ff9d0756f74e14f45d27dfcce9b506c`), focused on engineered setup/service modes, safe operating-mode selection, enabling devices, access management, and bypass resistance. Lane B selected the previously checkpointed maintenance handoff/shift-change continuity task, using different files and evidence.

After the Lane-B artifact commit, current `main` was re-read via recent commits. HEAD was `b90f0f046d12b918f5090c9c24f772f1808dc3b4`, immediately after the primary lane's checkpoint `d0ac2dc444a355f2ae47f82e9d2e5ce077f33901`; no overlapping primary files changed during the Lane-B write.

## Durable work completed

Added:

- `safety-course/SAFETY_MAINTENANCE_HANDOFF_SHIFT_CHANGE_CONTINUITY_WORKSHEET.md`

Artifact commit:

- `b90f0f046d12b918f5090c9c24f772f1808dc3b4` — `safety: add maintenance handoff shift continuity worksheet`

## Frozen learning

1. A handoff record transfers information/responsibility, not proof of hazardous-energy control.
2. Incoming authorized workers must not rely solely on outgoing statements, job briefings, CMMS/HMI status, or a lockbox as proof; applicable isolation/deenergization verification is required for the incoming work/shift.
3. Shift transfer must preserve continuity of personal/group LOTO protection without an unprotected gap.
4. OUT OF SERVICE status while awaiting parts does not replace required LOTO when exposed servicing resumes.
5. Stored/residual and reaccumulable energy plus gravity/mechanical restraint must be explicitly carried through the handoff rather than hidden behind `machine locked out`.
6. Temporary jumpers, software forces, test plugs, bench supplies, overrides, removed guards, and fixtures require positive reconciliation; reboot-cleared software state does not prove physical restoration.
7. `INSTALLED-PENDING-VALIDATION` remains distinct from `IN-SERVICE-VALIDATED` across a shift change.
8. Safety-relevant `UNKNOWN`s survive handoff unchanged until evidence closes them.
9. LinuxCNC/HAL/FPGA/HMI may improve visibility and inhibit ordinary commands but cannot replace energy isolation, independent safety authority, or incoming physical verification.

## Evidence provenance

- OSHA 29 CFR 1910.147(f)(4): `SOURCE-CONFIRMED` for orderly shift/personnel transfer and continuity of lockout/tagout protection.
- OSHA 29 CFR 1910.147(d)(5)-(6): `SOURCE-CONFIRMED` for stored/residual/reaccumulating energy control and verification of isolation.
- OSHA LOTO shift-change guidance and 1999 interpretation: `SOURCE-CONFIRMED` that incoming workers should not depend on outgoing workers/supervisors and that briefing/lockbox review alone does not replace required verification.
- OSHA 2025-11-24 interpretation: `SOURCE-CONFIRMED` that continuity/out-of-service locks while awaiting parts do not replace LOTO before exposed servicing resumes.
- No machine-specific hydraulic state, pressure threshold, gravity blocking method, stopping distance, PL/SIL/category, or other measurement-dependent fact was invented.

## Exact next independent work

Build `safety-course/RETURN_TO_SERVICE_RESTORATION_SWEEP_WORKSHEET.md`.

Focus narrowly on the final maintenance/test-to-production transition. Cross-check:

- all temporary jumpers, shorts, grounds, software forces, diagnostic overrides, test plugs, fixtures, external supplies and service tooling;
- guard/interlock/protective-device physical restoration and alignment;
- wiring/configuration/firmware/device identity against the approved baseline;
- replacement/change-impact state and required physical revalidation;
- contactor/EDM/STO/safe-motion/final-element observations where applicable;
- hydraulic/pneumatic/mechanical restoration without inventing machine-specific truth tables;
- removal of blocking/restraint only at the correct controlled stage;
- personnel/tool clearance;
- safety reset/restart/rearm versus separate normal start;
- explicit release of OUT OF SERVICE state only after bounded evidence supports it.

Before starting, re-read current `main` and the primary lane's newest durable artifact. If primary work has entered return-to-service restoration, switch to another independent open safety evidence package rather than duplicate it.