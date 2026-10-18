# 4400 — HBH primary-source contradiction audit and no-credit gate (2026-10-18)

**Session UTC start:** 2026-10-18T02:40:17Z. **Status:** DOC-CONFIRMED manufacturer web/catalog excerpts, UNKNOWN selected model/revision and actual mechanical holding. No test, physical validation, or hosted compute. This is a *delta* to the pending `research/4400_ROSS_HBB_HBH_HYDRAULIC_SAFE_STATE_AND_DOCUMENT_CONFLICT_2026-10-18.md`; do not duplicate that investigation when publication is reconciled.

## New source discrimination

The manufacturer's **2024 HBH product catalog PDF**, titled *Hydraulic Block & Stop Valve Systems* (document URL below), contains an especially important **within-document** inconsistency. Its warning states that HBH is a **spool-type** permissive valve with normal leakage, unsuitable as the sole extended-duration holding device; elsewhere the same PDF's feature table describes **poppet-type cartridge elements for blocking** and **spool-type solenoid pilot valves**. This is not merely an apparent difference between a web marketing page and an operating-instructions landing page. Search-indexed PDF text supports both statements. The original PDF binary/page rendering was **not directly inspected** in this session; preserve this provenance limit.

The current manufacturer HBH product-family page emphasizes poppet-based load holding, including vertical loads; the manufacturer RC-HBH-OI document landing page says **momentary stop** and supplemental holding for prolonged loads. The exact-variant technical-data page `HBHDDXX682FBAEXA` identifies redundant spool construction (per earlier pending research). Therefore:
- **DOC-CONFIRMED:** conflicting descriptions exist across manufacturer surfaces and in the indexed 2024 catalog.
- **INFERENCE:** pilot-stage versus primary blocking-stage terminology *might* explain part of the discrepancy; it cannot reconcile the explicit long-duration holding contradiction.
- **UNKNOWN:** which internal elements the installed feedback sensors actually detect; applicable selected model/revision/certificate; acceptable leakage, gravity-load holding, failure behavior and proof interval.
- **NOT CLAIMED:** HBH is universally poppet, universally spool, approved for sustained load holding, or that any catalog PL/SIL phrase establishes a complete machine safety function.

## Engineering acceptance rule

Until exact manufacturer instructions for the selected nameplate/revision, circuit diagram and independent physical validation are available, **do not credit HBH position feedback as proof of load support or safe access**. At most it is candidate evidence for the *particular element position* the selected sensor is proven to observe. Maintain distinct `PHY-STOP`, `PHY-HOLD`, `PHY-RELIEVE` and maintenance isolation propositions. Blocking may retain pressure; bleeding may remove a support path on a gravity-loaded axis. Neither is an automatic safe-to-enter state.

**Selected-machine gate** (all UNKNOWN / NOT RUN):
1. Identify installed full catalog/serial/revision and manufacturer's signed/revisioned operating instructions, drawings and certificates.
2. Resolve manufacturer contradiction in writing for that exact part, including pilot versus blocking stage, switch target, leakage and duration.
3. Trace pressure source, cylinder A/B, check/counterbalance, accumulator, return, pilot and gravity/load paths on *as-built* schematic.
4. Identify separate independent safety-controller authority, normal LinuxCNC/FPGA status-only role and final physical holding/energy-removal mechanisms.
5. Link `SRS/PHY/AUTH/DEP/ARC/VAL` and `UNK/CHG` IDs. Mark downstream proof STALE if substitution or selected device revision changes.
6. Freeze adversarial `VAL`: switches expected/healthy but independently observed ram displacement or trapped pressure contradicts safe state. Acceptance remains **NOT RUN** pending safe physical test setup, real acceptance criteria and personnel exclusion.

## Technician transfer scenario

A replacement HBH arrives with the same nominal connector and two PNP switch outputs. The service screen says `BLOCKED`; an operator asks to enter beneath a raised beam. The learner must reject access authorization, identify the exact switch target and selected valve revision, prove the separate load restraint/pressure path, preserve maintenance isolation, and require machine-level validation. A green controller status is not an independent witness. No one should be exposed to the raised-beam hazard while the minimum protective proposition is unverified.

## Sources and provenance

- ROSS, *Hydraulic Block & Stop Valve Systems*, ©2024, catalog PDF (indexed text, binary not directly inspected): https://ross-admin-global-us-east.s3.amazonaws.com/production/uploads/document_language_file/file/321/Hydraulic_Block_and_Stop_Valve_Systems_ROSS_HBH.pdf
- ROSS, HBH product family page (poppet and sustained holding statements): https://www.rosscontrols.com/en/series/1312-hbh
- ROSS, RC-HBH-OI document landing page (spool leakage and momentary-stop limitation): https://www.rosscontrols.com/en/documents/242/block-stop-hbh-series-valve-systems
- ROSS, *Fluid Power Machinery Safety Guidebook* (block/stop versus residual pressure and leakage concerns): https://assets-ross-controls.s3.amazonaws.com/global_websites/ross_controls/industries_and_applications/Fluid_Power_Machinery_Safety_Guidebook_ROSS-FPMS-Guide_EN.pdf

## Next branch / publication

Resolve authorized publication and the occupied `LESSON_LOG.md` safe append first. This branch reaches an information-gain stop without exact selected valve/manual or physical evidence. Rotate to another high-value safety topic rather than inventing a hydraulic truth table or running a simulation. No GitHub-hosted runners.