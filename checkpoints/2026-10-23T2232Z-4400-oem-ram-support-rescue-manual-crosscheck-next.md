# 4400 safety continuation checkpoint — 2026-10-23T22:32Z
**Supersedes:** `checkpoints/2026-10-23T2137Z-4400-osha-press-brake-scope-service-zone-next.md`. START_HERE/governance, safety-course syllabus/index and newest PROGRESS state remain authoritative. 1000/2000/F02/3000 formally closed; 2500 independent external evaluations OPEN; 4400 safety research active. Routine controller-board work belongs to separate automation.

## Session provenance
- UTC start recorded **2026-10-23T22:32:51Z**, before substantive work.
- Original new source audit: [Cincinnati PROFORM+ ram support / LOTO / rescue / figure errata](../research/4400_CINCINNATI_PROFORM_RAM_RESTRAINT_LOTO_RESCUE_MANUAL_ERRATA_AUDIT_2026-10-23.md).
- New paper technician exercise: [Ram support, isolation and rescue](../safety-course/4400_RAM_SUPPORT_LOTO_AND_POWER_LOSS_RESCUE_TECHNICIAN_CARD_2026-10-23.md).
- Primary source: Cincinnati official 90–350 PROFORM+ EM-560 (N-06-14) 2014 manual printed pp. 1-1 to 1-3, 8-6, 9-1/9-2, official PDF https://wwwassets.e-ci.com/PDF/Preinstallation/Press-Brakes/em-560-n-06-14-osmm-90-350-proform-plus.pdf . Independent current source: Haas 2026 HPB safety and maintenance public manual.
- Manufacturer figure legends contradict multiple printed section-9 item references; no live inspection or figure-image proof. OEM-specific 10%-capacity support rule and pressure bleed/wait examples **not transferred**.
- Design package §11AP, safety-course index, publication ledger and PROGRESS updated.

## Evidence and limits
**DOC-CONFIRMED:** exact manual text/legend discrepancies, distinct physical ram support and residual pressure/LOTO, two emergency rescue power states, Haas limited public maintenance warning. **INFERENCE:** usability/bypass and generic failure-path lessons. **SOURCE-CONFIRMED:** no new LinuxCNC source trace. **TEST-CONFIRMED:** none. **UNKNOWN:** as-built selected machine, ram/support capacity, hydraulic topology, actual pressure, stopping/holding, escape, restart, applicable compliance. Selected machine `IN-01..10 UNKNOWN`, all `PHY-*` UNKNOWN, `VAL/PT NOT RUN`, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No people exposed to unproven hazard. External 2520–25F0 competency gates OPEN.

**Compute:** No GitHub-hosted Actions, no self-hosted lab, simulation, physical machine test or blind score this session. No runtime invented; `LAB_COMPUTE_LOG.md` unchanged. Historical exact-source archive remains **6/85 pending** (original bytes absent). No workflow dispatched.

## Highest-value next work
1. Obtain actual selected-machine `IN-01..10` drawings/serial/version, ram load and engineered mechanical support, cylinder/counterbalance/pilot/accumulator zone map, safety final elements, guard/laser/helper/rear access, escape and fresh restart proof. Without those inputs, no machine-specific acceptance threshold or energized proof.
2. If still unavailable, source a **different OEM's inspectable mechanical ram restraint / service-access arrangement** or independently documented safety-related energy isolation and review the failure paths. Compare with this 2014 manual **without** copying its sizing/timing.
3. If the manufacturer figure-item mismatch can be resolved with a verified newer OEM errata or revision, record exact revised edition and visual/physical evidence; do not guess.
4. Recover six missing exact historical archive bytes only from verifiable original archive + SHA. Never synthesize historical release.
5. No lab merely to stay busy; no GitHub-hosted runners. Bounded justified compute only on `[self-hosted, openpressbrake]` when access exists and the question requires it. Do not update compute ledger without authoritative job runtime.
6. Immediately before ending, append actual UTC end, elapsed minutes, overlap to complete `LESSON_LOG.md` using SHA-guarded update and verify. Keep hourly automation enabled.

**Short-session continuation:** source evidence is sufficient for a documentary lesson; selected physical branch is blocked by missing as-built evidence. Next invocation should rotate to a new independent mechanical support/safety manufacturer branch, not repeat Parker/HYDAC/OSHA source summaries.
