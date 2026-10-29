# 2026-10-29T06:42:45Z — 4400 safety: hose rupture versus vented disconnection

**Session start:** `2026-10-29T06:35:17.456Z` in [start marker](2026-10-29T063517Z-session-start-safety.md). Supersedes [air-receiver source checkpoint](2026-10-29T064121Z-4400-air-receiver-relief-vs-safe-exhaust-physical-evaluator-next.md) and earlier BR-01 exact-source checkpoint. Actual UTC end/elapsed/overlap are in safe-appended LESSON_LOG.

## This session's three coherent increments
1. **Existing BR-01 exact OEM depth**: found missed 2026-10-24 predecessor, retired duplicate, preserved [ABB 2011/ACS800 R7/R8/Schneider source delta](../research/4400_BRAKE_RESISTOR_2026_10_29_ABB_2011_ACS800_FRAME_EXCEPTION_AND_SCHNEIDER_SUFFIX_SOURCE_DELTA.md) in existing BR-01 audit/field card and §11BU. This is **NOT a new chopper-failure mechanism**.
2. **New AIR-RECEIVER-01**: [OSHA 1910.169/SMC VBAT original source](../research/4400_AIR_RECEIVER_01_OSHA_1910_169_SMC_VBAT_RELIEF_DRAIN_AND_SAFE_EXHAUST_BOUNDARY_AUDIT_2026-10-29.md) separates vessel overpressure relief/condensate/inspection from actuator safe exhaust and service isolation. OSHA 1981/1978/2008 scope distinctions documented. No machine pressure values.
3. **New AIR-HOSE-01**: [OSHA 1926.302/1983 interpretation and CEJN vented coupling audit](../research/4400_AIR_HOSE_01_OSHA_1926_302_CONSTRUCTION_SCOPE_CEJN_VENTED_COUPLING_RUPTURE_BOUNDARY_AUDIT_2026-10-29.md) → [field card](../safety-course/4400_AIR_HOSE_01_VENTED_DISCONNECT_IS_NOT_RUPTURE_SHUTOFF_TECHNICIAN_CARD_2026-10-29.md). Positive coupling retention, vent-before-intentional-disconnect and source-side rupture-responsive flow reduction are different functions. OSHA construction >1/2-inch hose requirement is **pneumatic power-tool-specific**, not universal to CNC machine hoses.

## Evidence and work policy
DOC-CONFIRMED original SMC PDF, ABB PDF, CEJN original HTML and exact OSHA indexed texts; SOURCE-CONFIRMED repository novelty check; INFERENCE generic failure paths; UNKNOWN actual OpenPressBrake components, pressure, stop/hold, qualified evaluation; TEST-CONFIRMED none. No workflows, simulations, builds, physical machine/pressure tests or independent evaluator; GitHub-hosted 0 min, self-hosted 0 min. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Runner inventory/physical isolation UNKNOWN; no local compute justified.

## Exact next priority
- Qualified OpenPressBrake Stage A A–G installed Pilz/AKAS, K1/K2/EDM, independent Y1/Y2 stopping/gravity holding, guards, energy isolation and fresh restart. Air receiver/hose are **conditional only if relevant hardware actually exists**; no new first-contact owner questionnaire, no proprietary drawings in public.
- Independent 2520–25F0 evaluator OPEN/NOT RUN; use information-separated dispatch, never self-score.
- If external gates unchanged, choose a truly nonduplicate safety/4000 question by searching index, progress, **all research filenames and existing design-package headings**, then nearest predecessor before source work. Prefer exact physical/architecture evidence to another case bank.
- Local compute only if a bounded question cannot be answered by source, local runner [self-hosted, openpressbrake] is accessible **and physically isolated**; no GitHub-hosted fallback.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation.** Ordinary LinuxCNC/FPGA is normal control/diagnostics, not independent personnel safety.

**Cross-repository freshness witness (2026-10-29 UTC):** Direct GitHub ref/commit read of `Bensend/OpenPressBrake` `main` gives `92cf5424be90f45f664ba2652dc725b38e1895f9`, authored `2026-09-24T13:23:20Z` (“relay contactor: publish Rev1 board resource contract”). This is **published design evidence**, not newly published today, not a physical Pilz/AKAS/Y1/Y2 witness. Other OpenPressBrake branches exist but are not evidence of installed safety function without qualified as-built corroboration. The Stage A gate remains OPEN.
