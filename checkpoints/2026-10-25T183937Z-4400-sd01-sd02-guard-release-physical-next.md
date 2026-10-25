# 4400 safety continuation — SD diagnostic unlock authority, warning timing, exact function ratings
**UTC start:** `2026-10-25T18:39:37.519Z`, runtime clock captured before START_HERE and substantive work; [start marker](2026-10-25T183937Z-session-start-safety.md). Supersedes [17:35 CONFIG/REINT checkpoint](2026-10-25T173503Z-4400-config-reint-physical-evaluator-next.md) for work selection only.

## Governance and current safety state
START_HERE, MASTER_MISSION, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, blind protocol/score log, compute log, safety index, cumulative safety package and selected physical intake read. 1000/2000/F02/3000 **GRADUATED/CLOSED**; 4400 safety primary; routine controller board handled elsewhere. 2520–25F0 independent external evaluation OPEN; do not self-score public cases. Selected OpenPressBrake **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**; independent Y1/Y2 stop/hold, gravity, pressure, guarding, escape, fresh motion and machine-specific safety integrity remain UNKNOWN.

## Seven original artifacts
1. [Direct Schmersal 2023 SD brochure + Pilz guard/escape source audit](../research/4400_SCHMERSAL_SD_NONSAFE_LOCK_COMMAND_WARNING_DELAY_AND_PILZ_ESCAPE_SOURCE_AUDIT_2026-10-25.md)
2. [SD-01 learner module](../safety-course/4400_SD_01_SERIAL_DIAGNOSTICS_LOCK_AUTHORITY_WARNING_DELAY_AND_ESCAPE_MODULE_2026-10-25.md)
3. [16 SD-01 PAPER cases](../safety-course/4400_SD_01_SIXTEEN_GUARD_UNLOCK_WARNING_ESCAPE_PAPER_CASES_2026-10-25.md)
4. [12 blank G0 documentary gates](../safety-course/4400_SD_01_TWELVE_GATE_NO_ENERGY_GUARD_RELEASE_WITNESS_2026-10-25.md)
5. [SD-01 independent fresh evaluator handoff](../evaluation/4400_SD_01_FRESH_GUARD_UNLOCK_DIAGNOSTIC_TRANSFER_HANDOFF_2026-10-25.md)
6. [Exact AZM40 103037334 distinct interlocking/locking rating audit](../research/4400_SCHMERSAL_AZM40_INTERLOCK_VS_GUARD_LOCK_RATING_AND_FAULT_WARNING_VARIANT_AUDIT_2026-10-25.md)
7. [10 SD-02 PAPER transfer cases](../safety-course/4400_SD_02_TEN_FUNCTION_RATING_AND_DIAGNOSTIC_TRANSFER_CASES_2026-10-25.md)

## Original evidence and scope
- **DOC-CONFIRMED** Schmersal 2023 SD brochure pp.3–5, 11: separate safe X/Y signal path and non-safe serial diagnostics; footnote says interlocks whose lock/unlock is commanded by **non-safe SD gateway** can only be used for **process protection**. Product-family warnings may precede safety output shutoff; a warning is not a physical stop.
- **DOC-CONFIRMED** Pilz official manufacturer guidance: personnel guard unlocking conditional on actual safe state; spring-applied/bistable locking can retain state on power loss, but inside escape is separately needed where a person can be trapped.
- **DOC-CONFIRMED** exact Schmersal AZM40Z-I1-ST-1P2P-PH item 103037334 catalog independently lists **interlocking up to PL e/Cat 4** and **guard locking up to PL d/Cat 2**. Never transfer one function's component rating to another or to OpenPressBrake.
- **INDEXED-ONLY / not direct PDF-opened** exact AZM40 30-minute noncritical warning operating paragraph and AZM201 manual text. Schmersal 2023 brochure directly confirms product-family warning distinction, but not selected-machine delay. Explicit limitation retained.
- **INFERENCE:** independent personnel safe-unlock, stop/hold, inside escape, occupancy and fresh motion path. **UNKNOWN:** actual installed interlock, as-built circuit, Y1/Y2 hydraulics and selected PL/SIL. **SOURCE-CONFIRMED new LinuxCNC source:** none; **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none relied on.

## Integration, evidence, compute
CURRICULUM, PROGRESS, SAFETY_COURSE_RESEARCH, safety-course index, selected-machine conditional IN-04an/IN-05g/IN-09e and cumulative Safety Design Package **§§11FF–11FG** updated. **26 PAPER scenarios UNSCORED**, **12 G0 documentary gates NOT RUN**, fresh independent evaluation PREPARED/NOT RUN. No physical test, simulation, build, synthesis, benchmark or GitHub Actions dispatch; **0 GitHub-hosted and 0 self-hosted compute minutes**; no new authoritative job runtime, so LAB_COMPUTE_LOG unchanged. FEEDBACK_SCORE_LOG unchanged. Prior local runner access blocker remains unresolved and was not retested because no compute question justified it. No people-exposed operation authorized.

## Exact next work
1. Highest priority restricted qualified OpenPressBrake **G0**: as-built machine ID, actual interlock/guard/escape geometry and wiring, independent Y1/Y2 stop and gravity hold, hydraulic isolation, stored energy, service restraints, emergency rescue, safety controller, reset/occupancy/fresh command and exact device manuals. Never publish proprietary as-built evidence casually; maintain G0 HOLD until complete. G1 isolated-test permission and G2 physical validation are separate; no G3/G4 exposure.
2. Obtain genuinely **information-separated** external 2520–25F0 and 4400 evaluator results; do not score the 26 public cases as blind.
3. If both blocked, rotate to a **new** source-specific 4400 safety failure path not already in the index; candidate: exact guard-release behavior after diagnostic communication loss and the safety-versus-ordinary output consequences of replacement, but only if a direct manufacturer manual provides an unexamined distinction. Do not multiply generic guard checklists.
4. If any compute becomes essential, only bounded question-driven workflow on `[self-hosted, openpressbrake]`. If dispatch unavailable, source/doc work and record blocker; never hosted fallback.

## Short-session continuation check
After SD-01 brochure/escape study reached an information-gain stop, rotated within this invocation to a distinct exact-part AZM40 rating counterexample (PL e interlocking **versus** PL d guard locking), with ten additional transfer cases. No synthetic test was run merely to consume machine time. The branch remains NON-GRADUATED until independent evaluator and physical evidence.
