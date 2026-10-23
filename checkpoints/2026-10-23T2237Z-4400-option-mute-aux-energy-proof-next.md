# 4400 safety continuation checkpoint — 2026-10-23T22:37Z
**Supersedes** `checkpoints/2026-10-23T2232Z-4400-oem-ram-support-rescue-manual-crosscheck-next.md`. Read START_HERE/governance, current PROGRESS, safety index and syllabus. 1000/2000/F02/3000 closed, 2500 external evaluation OPEN, 4400 safety active. Separate board automation owns ordinary hardware.

## Current session (start UTC 2026-10-23T22:32:51Z)
- Original [ram restraint / maintenance isolation / power-loss rescue / OEM manual-reference mismatch audit](../research/4400_CINCINNATI_PROFORM_RAM_RESTRAINT_LOTO_RESCUE_MANUAL_ERRATA_AUDIT_2026-10-23.md) and [technician card](../safety-course/4400_RAM_SUPPORT_LOTO_AND_POWER_LOSS_RESCUE_TECHNICIAN_CARD_2026-10-23.md). OEM source Cincinnati EM-560 N-06-14 and independent Haas 2026 HPB pages. Figure item references disagree with legends; no guessed correction or machine procedure.
- Second original [OEM option / guard mute / ADI plug / auxiliary hydraulic energy audit](../research/4400_PROFORM_OPTIONAL_MUTING_ADI_PLUG_FOOTSWITCH_AND_HYDRAULIC_ADDON_AUDIT_2026-10-23.md). Manufacturer documents optional rear/front guards, position-dependent muting, step-selectable footswitches, ADI removable default plug, Power Clamp and Auto Crown. **ADI safety-chain semantics UNKNOWN**, not proven bypass. OEM guard mute does remove its AOPD protection; alternative safety must be qualified.
- Design package §§11AP–11AQ, index, progress and archive ledger updated; all new original work, **not** any of six unrecovered historical ZIP releases.

## Evidence / release gates
**DOC-CONFIRMED:** OEM product/revision/option wording and internal figure reference conflicts. **INFERENCE:** transfer/bypass/auxiliary-energy failure paths. **SOURCE-CONFIRMED:** no new LinuxCNC source. **TEST-CONFIRMED:** none. **UNKNOWN:** installed selected-machine options and safety circuits, ADI pinout, pressure zones, physical ram restraint, safe speed/stop/hold/access/escape/restart and standard-specific acceptance. `IN-01..10 UNKNOWN`, `OPT-01..08 UNKNOWN/NOT RUN`, all `PHY-*` UNKNOWN, `VAL/PT NOT RUN`, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed hazardous operation.
No hosted Actions minutes, no local laboratory job, no simulation, no physical test or new blind score. `LAB_COMPUTE_LOG.md` unchanged; existing self-hosted-only lesson-log workflow run 39919548510 still queued on 2026-10-23 (no runtime). External 2520–25F0 competency gates OPEN.

## Exact next highest-value work
1. Selected machine as-built `IN-01..10` plus `OPT-01..08`: actual guard/laser variants, muting, rear/helper access, footswitch selection, auxiliary plug/third-party interfaces, hydraulic clamp/crown/cylinder pressure zones, independent safety final elements, ram mechanical restraint and deliberate restart. No selected thresholds or live acceptance without that evidence.
2. If selected machine unavailable, rotate to a **different manufacturer's** exact mechanical support, guard mute or energy-isolation architecture with inspectable manual and new causal insight; do not repeat Cincinnati/OSHA/Parker notes. Alternatively reconcile an official updated Cincinnati erratum/EM-508 only if accessible and version-scoped.
3. Six historical exact archive candidates remain 6/85 pending original bytes/SHA; never reconstruct. External 2520–25F0 independent evaluations remain open; never self-score.
4. Question-driven compute only via `[self-hosted, openpressbrake]`, never hosted runners. No lab justified on unknown physical configuration.
5. Immediately before ending, SHA-guarded **complete** `LESSON_LOG.md` append with actual UTC end/elapsed/overlap and verify; keep hourly automation enabled.

**Information-gain stop:** current OEM model documentary claims are source-resolved; selected OpenPressBrake physical truth requires as-built evidence. Rotate to a new source/architecture branch next invocation rather than invent a hydraulic circuit.
