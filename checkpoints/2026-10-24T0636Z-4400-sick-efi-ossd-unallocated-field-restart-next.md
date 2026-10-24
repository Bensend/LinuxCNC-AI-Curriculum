# Active 4400 safety continuation — 2026-10-24T06:36Z SICK scanner EFI integration and restart

**Supersedes:** [2026-10-24T05:31Z workpiece/follower/tooling checkpoint](2026-10-24T0531Z-4400-sheet-whip-up-follower-safety-next.md).

**Session start UTC:** **2026-10-24T06:36:49.073Z** captured by local UTC clock before substantive work. Read START_HERE, mission, LEVEL_ORDER, WORK_SELECTION_POLICY, CURRICULUM, SOURCE_POLICY, MODULE_TEMPLATE, PROGRESS, latest checkpoint, 4400-HY-01, safety learner index/design/intake, blind evaluation and lab compute ledger. Graduated 1000/2000/F02/3000 stay closed. 4400 safety is primary; no old 3300 or routine board work.

## New original source-confirmed documentary results

**SICK S300, 8010948/ZD76/2025-08-19**, original manufacturer PDF inspected, especially §7.10 pp.88–89: when Flexi Soft consumes S300 scanner OSSD status, internal scanner restart interlock affects controller; if it consumes raw protective-field status, the scanner's internal restart interlock **does not** govern that controller path and an interlock must be implemented in Flexi Soft. Access plane does not see people behind it; blind mounting zones, unsafe universal I/O and monitoring-case timing are distinct concerns.

**SICK S3000, 8009942/ZE09/2026-09-09**, original 172-page manufacturer PDF inspected, especially §§7.6.5/7.9/7.10 pp.93/98–101: unallocated protective field defaults **logical 1 = clear**, manufacturer instructs transfer-unallocated-as-interrupted when evaluating field status (automatic in cited dual protective field mode); if local OSSDs are unused, EFI OSSD bit is **always active** and **not safety-authoritative**; dual protective field 2 does not switch local OSSDs and needs external independent cut-off. Warning fields do not provide personnel protection. This **qualifies** the S300 OSSD path: never generalize 'always use OSSD bit' or 'always use raw field status'. Model, configured mode and signal semantics govern.

Published **six original documentary artifacts**, all independently fetched from `main` with blob SHAs:

1. [S300 signal selection source audit](../research/4400_SICK_S300_EFI_RESTART_INTERLOCK_SIGNAL_SELECTION_AND_REAR_ZONE_SOURCE_AUDIT_2026-10-24.md).
2. [S300 16-case paper technician card](../safety-course/4400_S300_EFI_SIGNAL_SELECTION_RESTART_AND_REAR_ACCESS_TECHNICIAN_CARD_2026-10-24.md).
3. [Rear-access blank integration worksheet](../safety-course/4400_REAR_ACCESS_AND_EFI_RESTART_SAFETY_INTERFACE_REVIEW_WORKSHEET_2026-10-24.md).
4. [S3000 unallocated-field / OSSD-bit exact source audit](../research/4400_SICK_S3000_EFI_UNALLOCATED_FIELD_CLEAR_AND_OSSD_BIT_INTEGRATION_TRAPS_2026-10-24.md).
5. [S3000 10-case paper technician card](../safety-course/4400_S3000_UNALLOCATED_FIELD_AND_EXTERNAL_OSSD_SIGNAL_TRAPS_FIELD_CARD_2026-10-24.md).
6. [4400-ESPE-01 integrated source-reading module](../safety-course/4400_ESPE_01_SAFETY_SCANNER_EFI_SIGNAL_SEMANTICS_AND_RESTART_MODULE_2026-10-24.md) — **NOT GRADUATED**.

Cumulative Safety Design Package **§11BH–11BI**, selected-machine conditional **IN-04g**, safety learner index, publication ledger, CURRICULUM and PROGRESS updated. Index now **134 relative Markdown link occurrences / 132 distinct targets**; all six new targets independently fetched and indexed. **No complete current repository-tree audit** claimed. Historical exact archive remains **6/85 pending**, no new historical restorations.

## Machine release and evaluation gates

Actual OpenPressBrake Y1/Y2 hydraulic/physical safety, independent final elements, backgauge X/R/Z, rear scanner or fixed fence, safety PLC, EFI status wiring, physical stop/hold/occupancy, deliberate restart and maintenance isolation **UNKNOWN**. `EF-01..16` and `UF-01..10 PAPER ONLY`. `VAL/PT NOT RUN`, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. External 2520–25F0 evaluations still OPEN; 4400-HY-01 fresh handoff PREPARED/NOT RUN/NOT SCORED; 4400-ESPE-01 new handoff NOT RUN/NOT SCORED. No self-scoring or hidden-key exposure.

No GitHub-hosted Actions workflows dispatched, no local compute, no simulation, physical tests or new authoritative job runtime. `LAB_COMPUTE_LOG.md` unchanged. Earlier self-hosted-only run **39919548510/job 120301190483** was previously **QUEUED**; no fresh job-state query was available this session, so do not assert its current status or count runtime. Never use hosted fallback.

## Precise next highest-value work

1. **Selected physical evidence first:** obtain actual OpenPressBrake Y1/Y2 as-built hydraulics, independent safety controller/final-element wiring, mechanical ram holding, pressure/energy zones, guard/rear occupancy geometry, backgauge X/R/Z drive safety and local restart. Do not invent physical criteria or authorize people-exposed motion.
2. If any safety scanner is installed, collect **exact family/variant/manual edition/firmware/config checksum**, local/external OSSD mode, allocated/unallocated fields, protective vs warning field, EFI bit polarity and consumed PLC variables, case switching, restart owner, final elements, physical witness and revalidation after changes. If none installed, mark SICK-specific branch NOT APPLICABLE and evaluate actual fixed/monitored rear guarding.
3. Arrange information-separated external paper evaluation for 4400-HY-01 or new ESPE-01 without revealing hidden answers to learner. Do not self-score.
4. Reconcile HYDAC 710028 contradictory OEM port/flow documentation **only if selected**; no open-line fault test.
5. If machine/evaluator blocked, rotate to a **different genuinely open 4400 safety source branch** (e.g. emergency rescue/trapped-person occupancy or robotized cell interface), not completed 3000 or repeated 2580.
6. Before end append UTC end/actual elapsed/overlap to complete SHA-guarded `LESSON_LOG.md`, verify and commit. Hourly automation remains enabled.

**Safety boundary:** an S300/S3000 manufacturer's configuration warning is not a selected-machine failure report. No personnel-exposed hazardous operation; any experimental work must be isolated/remote with all people outside the hazard zone and residual risks assessed.

## Same-session deeper OEM case-switching source trace

Inspected SICK S3000 2026 §4.3.3 printed pp.39–40, §7.8.2 pp.97–98 and §7.13.1 pp.111–112. **DOC-CONFIRMED:** field-switch timing must account for input delay and external EFI control/OSSD paths; late switching may expose a person already in the new field; OEM discusses overlap or simultaneous monitoring when switching cannot be timed reliably. Complementary dual-channel and 1-of-n mode input schemes have different invalid-state semantics, and the field-selection control itself must meet the required safety level. Updated source audit, integrated module, technician card and §11BI. Added `UF-11..13`; paper cases now **29** (16 S300 + 13 S3000). No product-specific numeric timing transplanted to machine acceptance. The current documentary branch has reached a genuine information-gain stop: selected physical design and independent evaluator evidence, not synthetic simulations, are needed for further safety claims. Other unblocked safety branches remain for subsequent sessions; automation stays active.
