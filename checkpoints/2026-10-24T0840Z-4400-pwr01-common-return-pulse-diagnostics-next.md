# Active continuation checkpoint — 4400-PWR-01 common 0 V and safety-output diagnostics

**Session start UTC:** 2026-10-24T08:40:42.742Z (captured before substantive work).  
**Checkpoint:** 2026-10-24 UTC; **status SOURCE-READING / NOT GRADUATED**.  
**Authoritative branch:** 4400 safety, not older 3300 or closed 1000/2000/F02/3000. Routine controller board development belongs to the separate OpenPressBrake Board Design automation.

## Durable work

Four original documents:

1. [SICK lost-0 V / reverse-current common-cause source audit](../research/4400_SICK_FLEXISOFT_LOST_0V_REVERSE_CURRENT_COMMON_CAUSE_SOURCE_AUDIT_2026-10-24.md).
2. [12-case lost-ground/power-dip technician card](../safety-course/4400_LOST_GROUND_FALSE_HIGH_AND_POWER_DIP_TECHNICIAN_CARD_2026-10-24.md).
3. [SICK FX3-XTIO disabled-test-pulse all-output degradation and transient-high source audit](../research/4400_SICK_XTIO_DISABLED_TEST_PULSE_ALL_OUTPUTS_DEGRADE_AND_TRANSIENT_HIGH_AUDIT_2026-10-24.md).
4. [Integrated non-graduated 4400-PWR-01 module](../safety-course/4400_PWR_01_SAFETY_IO_SUPPLY_RETURN_AND_DIAGNOSTIC_CONFIG_MODULE_2026-10-24.md).

**Original OEM evidence:** SICK Flexi Soft modular safety controller hardware instructions 8012478, web text showing 1WLY/2026-05-05, §§4.4.6, 6.1, 11.3–11.5, XTIO technical tables; SICK Safe Linear Positioning 8020941/1FB9/2022-07-19 §13.2 p.80, visually checked. **Provenance caution:** SICK's live PDF URL is mutable and screenshot services exposed historical footer differences; save actual PDF bytes and identify edition/checksum for selected implementation. **DOC-CONFIRMED** warnings include actuator unintended switching on broken common return, reverse-current false-high inputs, common encoder reference/supply, version-specific 20/2 mA reverse-current maxima, all-Q safety parameter degradation when one XTIO output test pulse is disabled, and 3/43 ms electrical LOW threshold plus ≤10/≤50 ms internal fault detection/reaction distinctions. None of these numbers are selected machine stop time, PL/SIL, threshold or hydraulic fact.

Integrated `CURRICULUM.md`, `PROGRESS.md`, learner index, cumulative Safety Design Package **§§11BM–11BN**, and selected conditional `IN-04k/l`. All four original files independently fetched from main; learner index **147 Markdown relative link occurrences / 145 distinct targets**, all four new links independently verified. **No complete current tree audit claimed.**

## Safety, compute and evaluator state

- Actual OpenPressBrake Y1/Y2 hydraulic, safety PLC, 24 V/0 V/FE/PE, final element, pressure/ram restraint, guard, occupancy, reset/restart and physical stopping/holding evidence: **UNKNOWN / NOT RUN**.
- `LG-01..12` and `TP-01..08` paper only. 4400-PWR-01 not graduated; independent fresh evaluator **NOT RUN**. Existing 2520–25F0 and 4400-HY/ESPE/RET independent gates OPEN.
- Selected `G0/G1 HOLD`, `G3/G4 NOT AUTHORIZED`; no personnel-exposed hazardous operation or energized wire-disconnect experiment.
- GitHub-hosted compute **0 min**; local lab **0 min**; no workflow dispatched. Previous self-hosted-only run **39919548510** job **120301190483** completed/cancelled without authoritative start/end runtime; not re-dispatched. `LAB_COMPUTE_LOG.md` unchanged.
- Historical archive exact original backlog **6/85 pending**; new documents are not recovered historical originals.
- No new blind score, physical evidence, simulations or runtime. `FEEDBACK_SCORE_LOG.md` unchanged.

## Precise next-work selection

1. **Primary selected-machine evidence:** Obtain restricted, revision-controlled as-built OpenPressBrake Y1/Y2 electrical/hydraulic safety drawings and actual safety PLC identity. For each safety function trace E-stop/guard input → independent safety logic/output → physical contactor/valve/drive/ram hold → independent `PHY-STOP/HOLD/ENERGY/ACCESS/RESTART` witness. Add `IN-04k/l` only if applicable; don't put private drawings in public repo.
2. **Qualified physical proof:** With selected intake `IN-01..10` complete, independent reviewer and a designed isolated/remote test envelope, plan selected tests; do **not** invent numerical criteria, intentionally disconnect live 0 V, or expose people.
3. **Information-separated evaluation:** Fresh evaluator for 4400-RET-01/HY-01/ESPE-01/PWR-01 and foundational 2520–25F0; never self-score prepared learner-visible practice.
4. **If external gates remain blocked:** Rotate to a *different* high-value 4400 source gap, e.g. exact safety fieldbus connection-loss/rearm and final-element behavior from OEM source, without duplicating 3000 work. Keep LinuxCNC/normal FPGA out of safety authority.
5. **Compute rule:** no GitHub-hosted runner, no `ubuntu-latest` fallback. Only bounded, question-driven compute via `[self-hosted, openpressbrake]` if justified and available. Update compute ledger only for authoritative actual job runtime.
6. **Session close:** append UTC end, actual elapsed minutes and overlap to the **complete** `LESSON_LOG.md` using SHA-guarded safe append; never overwrite a truncated fetch. Previous canonical end **2026-10-24T07:52:07.735Z**, approximately **48.58 min** before this session start. External concurrent activity cannot be independently excluded.

**Release freeze:** safety CPU RUN ≠ final-element proof; Q low ≠ no coil current under all faults; two high inputs ≠ two healthy sensors; output test-pulse disable may degrade other outputs; diagnostic milliseconds ≠ physical stop time; PLC/FPGA reset ≠ safe load holding.

## Same-session additional 4400 source branch — safety fieldbus

Published [Rockwell Logix SIS CIP Safety CRTL versus Beckhoff TwinSAFE FSoE watchdog/ack original source audit](../research/4400_CIP_SAFETY_CRTL_VS_FSOE_WATCHDOG_ACK_AND_SIL_UI_TRAP_SOURCE_AUDIT_2026-10-24.md) and [10-case paper fieldbus technician card](../safety-course/4400_SAFETY_FIELDBUS_TIMEOUT_ACK_AND_FALSE_SIL_TECHNICIAN_CARD_2026-10-24.md). **DOC-CONFIRMED:** Rockwell 1756-RM015C December 2025 CRTL controls maximum safety packet age, timeout OFF data and response-time calculation; Beckhoff TwinSAFE Logic FB v4.3.0 December 2025 requires system-wide FSoE address uniqueness and may require both `ComErrAck` and `ErrAck`. Beckhoff TwinCAT 2 SIL selector in that manual has no effect on safety behavior. No installed network claimed. Integrated `§11BO`, conditional `IN-04m`. **Six original documents total**, 30 learner-visible paper cases, no tests, no fresh score, no compute, no physical evidence. The first priority remains actual Y1/Y2 safety as-built/physical witnesses; do not substitute documentary safety-network OFF state for gravity hold.

**External handoff prepared:** [4400-PWR-01 fresh information-separated evaluation](../evaluation/4400_PWR_01_FRESH_INFORMATION_SEPARATED_HANDOFF_2026-10-24.md) requires a genuinely fresh learner, evaluator-held different OEM source, immutable precommit and independent scoring. **NOT RUN / NOT SCORED**, not physical proof. Seven original artifacts total this session.
