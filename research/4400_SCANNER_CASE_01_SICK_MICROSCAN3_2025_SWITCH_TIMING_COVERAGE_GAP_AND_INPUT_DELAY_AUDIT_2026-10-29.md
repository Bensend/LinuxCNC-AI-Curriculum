# 4400-SCANNER-CASE-01 — Monitoring-case selection can be correct and still become protective too late

**2026-10-29 | Safety course / 4000 implementation | documentary engineering investigation, NOT machine validation.** This is a source-specific extension of the existing S300/S3000 EFI/restart lessons and Leuze multilane field-selection case study, not a replacement or another unscored examination bank.

## Question and novelty

A safety scanner shows the intended field *after* a mode or lane change. Does that prove that a person could not reach the new hazard during the transition? **No.** The important proposition is continuous, timely coverage of the hazardous access path, including the transition interval and any previously guarded area. The [S300 EFI audit](4400_SICK_S300_EFI_RESTART_INTERLOCK_SIGNAL_SELECTION_AND_REAR_ZONE_SOURCE_AUDIT_2026-10-24.md) already establishes that selected signal semantics and scanner restart interlocks matter. The [Leuze five-lane implementation audit](4400_LEUZE_SPG_MULTILANE_DYNAMIC_FIELD_REAL_INSTALLATION_TRANSFER_AUDIT_2026-10-24.md) already identifies the late-selection risk qualitatively. **New evidence here** is the exact microScan3 2025 local-input timing budget, antivalent input rules, and a concrete coverage-overlap alternative. Do not claim a new finding merely because an old case-study warning is now expressed numerically.

## Original manufacturer evidence and limits

**SICK AG, microScan3 Core I/O, operating instructions 8016346/1SK3/2025-07-04**, original English manufacturer PDF as indexed at
https://cdn.sickcn.com/media/docs/7/57/757/operating_instructions_microscan3_core_i_o_en_im0063757.pdf .
Inspected manufacturer-indexed text for printed **p. 32, §4.3.5 monitoring-case switching**, and **p. 105–106, §7.12 monitoring-case tables/input delay** on 2026-10-29. The web viewer could not fetch the entire 17.7 MB PDF, so this is **DOC-CONFIRMED for the indexed printed excerpts only**, not a claim to have audited all pages or verified an immutable full-file hash. The device variant, edition and indexed-page scope matter. A future qualified reviewer should retain the exact installed-device PDF and a stable hash.

Additional variant-specific comparator: **SICK microScan3 – EFI-pro**, operating instructions **8021913/15ZW/2019-11-14**, indexed p. 33 at
https://cdn.sick.com/media/docs/1/71/671/Operating_instructions_microScan3_EFI_pro_en_IM0077671.PDF .
The historical indexed text gives **28 ms** network-input processing and explicitly requires network/controller propagation delay. This is **not** a 2025 Core I/O local-input constant, and the older URL was not fully retrievable during this session. Do not combine timing terms from different variants.

| Evidence | Exact source location | Claim | Classification |
|---|---|---|---|
| SC-CASE-01 | Core I/O p.32 §4.3.5 | `tCSR = tID + tI`; `tID` is configured input delay; local-input processing `tI = 12 ms`. | DOC-CONFIRMED excerpt, exact 2025 variant |
| SC-CASE-02 | Core I/O p.32 §4.3.5 | `tCSA = (n - nCS) × tS`; `n` is multiple sampling, `nCS` after-case-change sampling, `tS` scan period including applicable interference supplement. If `tCSA < tCSR`, advance case selection by `tCSP = tCSR - tCSA`. | DOC-CONFIRMED excerpt |
| SC-CASE-03 | Core I/O p.32 §4.3.5 | Upstream control propagation time must also be considered; late changeover can fail to detect a person in time. When exact advance is impractical or early retirement of the old area is unsafe, partially overlap protective fields (and evaluate simultaneous protection where supported). | DOC-CONFIRMED excerpt for overlap; **INFERENCE** for broader system strategy |
| SC-CASE-04 | Core I/O p.105–106 §7.12 | Static control-input delay must accommodate real switching/bounce. OEM examples: complementary electronic outputs **12 ms**, relay contacts **30–150 ms**, independent sensors **130–480 ms**. These are illustrative OEM ranges, not selected-machine settings. | DOC-CONFIRMED excerpt |
| SC-CASE-05 | Core I/O p.105–106 §7.12 | In antivalent evaluation, paired input channels must be inverted even when a case's input is marked irrelevant; otherwise safety outputs go OFF and a fault is displayed. Cases are activated by their exact configured input combinations. | DOC-CONFIRMED excerpt |
| SC-CASE-06 | Core I/O p.105–106 §7.12 | Configuration supports a **sleep mode** on a selected monitoring case; a case name/green indicator alone is not proof that the required protective field is active. | DOC-CONFIRMED excerpt; safe interpretation is INFERENCE |
| SC-CASE-07 | Selected OpenPressBrake | Installed scanner, field geometry, input hardware, delays, guard/rear access, safety-PLC logic and actual stop/hold are **UNKNOWN**. | UNKNOWN; TEST-CONFIRMED none |

**Scope warning:** a 12 ms scanner input-processing term is not a machine stop time. The OEM case-switch equation is not a substitute for overall response-time/separation assessment under the selected applicable standards and [ISO 13855:2024 source-scope audit](4400_ISO13855_2024_SEPARATION_DISTANCE_SCOPE_STOP_TIME_AND_GRAVITY_EXCEPTION_2026-10-24.md). No physical stopping distance, required advance, field dimensions or PL/SIL is asserted.

## Transparent arithmetic check — NOT a selected-machine design

For a deliberately *hypothetical* Core I/O configuration only: let `n=2`, `nCS=1` (Fast), `tS=30 ms`, and `tID=30 ms` for a selected relay-interface example. Then `tCSR = 30+12 = 42 ms`; `tCSA = (2-1)×30 = 30 ms`; the manufacturer's **internal** timing check yields `tCSP = 12 ms`. That arithmetic is **INFERENCE from DOC-CONFIRMED formula**. It excludes upstream switching/PLC propagation, field geometry, scanner output transmission, safety logic, final-element reaction, physical stopping and gravity holding. It is **not** a validated 12 ms advance for any actual machine. An engineer cannot repair an unverified system by simply adding 12 ms to LinuxCNC motion code.

Changing to `tID=150 ms` changes this illustrative internal advance to **132 ms**; this exposes why making a bouncing relay reliable by increasing input delay can change the protective transition. Neither value may be copied into a machine configuration without an exact qualified calculation.

## Failure-path / adversarial architecture review

| Timeline / failure | What a superficial test sees | Hazard proposition that remains unproven | Safer architecture and validation question |
|---|---|---|---|
| A. Ordinary PLC changes lane ID after travel begins | Correct new field eventually displayed | Person may enter new hazard before new field is active. | Select sufficiently early using qualified safety timing and independently verified process state, or monitor both areas through transition. |
| B. PLC preselects new field early | New field appears before motion | Old field may be retired while someone is still in its access path. | Overlap fields/keep both monitored or stop hazardous motion during a bounded handover; validate old and new coverage together. |
| C. Relay bounce / antivalent mismatch | Field selection intermittently faults, causing nuisance trips | Fault may be bypassed by operator or forced into a permissive workaround. | Choose qualified input interface/delay and good diagnostic text; never defeat the scanner to avoid trips. |
| D. Input combination accidentally selects sleep/passive mode | Controller reports a recognized case number | A recognized case is not equivalent to an active protective cut-off path. | Independent safety review of each input combination, field/cut-off mapping, and invalid states; display *active protective coverage* rather than only mode name. |
| E. Scanner status used as the sole stop/hold proof | Scanner OSSD goes OFF | Physical Y1/Y2 hydraulic stop, load holding and access prevention remain unproved. | Independent safety controller/final elements and machine-specific physical witness; no CNC/FPGA safety authority. |
| F. Scanner field clears after passage | Field reports clear | Whole-body presence behind the scan plane may remain. | Occupancy/escape/reset design, deliberate restart and visibility; do not infer zone empty from passage detector. |

These are **INFERENCE / hypothetical** failure paths, not observed faults. A fault-tolerant design must state the effect of late/missing/mismatched case selection, startup/power return, manual/automatic mode changes, network loss and reset. Safety outputs and final elements must be validated for the actual selected architecture; do not invent a universal fault truth table.

## Human-factors design test

An operator should not have to remember the right field number, accept repeated nuisance trips, or bypass a scanner to change tooling. Make field handover automatic **within qualified independent safety logic**, show an understandable *why motion is inhibited* reason, provide safe recovery that preserves the guard, and avoid a reset control located where the person cannot see the entire hazard. If a scanner is repeatedly defeated, investigate the field/geometry/flow and fault-message design as an engineering defect rather than treating operator obedience as the sole safeguard.

**Practical low-cost default:** where a variable field is not demonstrably needed, prefer a fixed guard or a fixed conservative protective field with simple independent stop/restart behavior. Dynamic selection adds timing, configuration, diagnostics and validation obligations. This is a design **INFERENCE**, not a universal mandate.

## Verification plan / information-gain stop

1. **Documentary first, no power:** identify actual scanner part number/firmware/manual revision, configured field sets, monitoring-case input combinations, antivalent wiring, configured delays, scan/sampling/interference settings, safety-controller signal choice, and final elements. Record source revisions in restricted machine workspace.
2. Derive **two-direction** handover proof: old-zone coverage remains effective until no longer needed, and new-zone coverage is effective before access becomes hazardous. Include upstream control latency, all signal propagation, stopping response and degraded/fault states; qualified reviewer sets actual bounds.
3. Independently validate the selected safety-function SRS, physical stop/hold, occupancy and restart requirements before any personnel exposure. For an isolated future test, qualified personnel must establish independent exclusion, restraints, instruments, and fault-safe abort; no physical operation is authorized by this paper audit.
4. **Frozen lab? NO.** OEM equations and failure-path logic already resolve the documentary question. No additional compute/simulation adds useful proof without selected machine geometry, configuration and qualified physical evidence. Local panel PC isolation and runner access remain unverified.

**Cross-machine transfer:** rear press-brake/backgauge access, multi-lane plasma/cutting feed, mill/robot cell shared openings and mobile equipment each have different hazard envelopes. Do not transplant one machine's case timing or safe-state into another.

**Status:** SOURCE-CONFIRMED existing repository predecessors; DOC-CONFIRMED only the exact manufacturer indexed excerpts; INFERENCE arithmetic and failure paths; UNKNOWN installed configuration/physical proof; TEST-CONFIRMED none. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** 2520–25F0 independent evaluation OPEN. No GitHub-hosted or self-hosted compute consumed.
