# 4400-LC-CASCADE-01 — Cascading a safety light curtain can silently invalidate an old stop-distance worksheet

**2026-10-29 | 4000 safety | original OEM manual and arithmetic audit | NON-GRADUATED | NO PHYSICAL TEST**

## Distinct question / novelty

If a CNC retrofit adds a rear or horizontal safety-light-curtain segment to an existing front field while keeping a common pair of safety outputs, can the old response-time and separation-distance evidence be reused? What happens when blanking is enabled to pass material?

**No automatic reuse.** The [original reflection/weld-guard audit](4400_LIGHT_CURTAIN_REFLECT_01_SICK_DETEC4_CORE_2025_REFLECTION_WELD_GUARD_AND_MUTUAL_INTERFERENCE_OEM_AUDIT_2026-10-29.md) concerns optical **missed detection** from reflections and cross-curtain interference. This source trace concerns **increased response latency and changed resolution with cascading/blanking even when detection and outputs function correctly**. Full safety index/progress were scanned for `cascaded response`, `cascaded Micro`, `segment response` and `light curtain cascade`; no earlier exact Rockwell Micro 400 timing audit found. Existing 2590 safety-distance and 4400 muting lessons remain prerequisites; do not create a new scored competency.

## Original manufacturer evidence

**Rockwell Automation**, *GuardShield Micro 400 Safety Light Curtains — Installation Instructions*, **445L-IN005C-EN-P, January 2024**, **24 pages**, original OEM PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/in/445l-in005_-en-p.pdf . Directly opened the original rendered PDF and inspected printed **pp.2, 5, 6–8 and 14–16** (PDF zero-index p.4 image visually checked for the exact Table 1). No immutable byte hash retained. All device/option-specific technical claims below are **DOC-CONFIRMED** for this edition, not a claim about every safety light curtain.

- Printed **p.2**: the cascadable Micro 400 permits one or two additional sensor pairs, potentially different 14/30-mm resolutions, with a **common OSSD pair**; **system response time is the sum of all segment-pair response times plus MSR41/MSR42 and other safety stop-circuit devices**. Common outputs are a wiring convenience, not a proof that response time is unchanged.
- Printed **p.5**, Table 1: explicit example with cascade 1 **41.9 ms**, cascade 2 **18.5 ms**, standard **26.3 ms**, giving **86.7 ms + tC**, where `tC` is controller/extension response. The OEM's label response assumes **Double Scan** mode; controller mode/configuration can increase timing. The OEM says recalculate safety distance and potentially relocate the light curtain after configuration changes.
- Printed **p.5**, blanking: with **MSR42** fixed/floating blanking, both **resolution and response time change**; use the *new longer response time and larger effective resolution* for safety-distance calculation and apply the configuration label. Stop-delay, muting and MSR45E extension are also cited as possible timing contributors.
- Printed **p.6**: actual machine stopping/run-down time is a distinct term to be established from machine documentation or measurement. The example safety-distance formula cannot replace actual machine stop proof.
- Printed **pp.2 and 5**: standard sensor must be last in cascade; total cable length and beam count have OEM constraints; model, segment order and selected module matter.
- Printed **p.2**: MSR41 on/off vs MSR42 configurable blanking/muting/reset/EDM; safety outputs remain part of the external final-element path, not ordinary LinuxCNC authority.

## Exact independent arithmetic — not a physical acceptance result

| Term | OEM Table 1 example | Independently checked |
|---|---:|---:|
| `tN1` (first cascade) | 41.9 ms | 41.9 ms |
| `tN2` (second cascade) | 18.5 ms | 18.5 ms |
| `tLC` (standard pair) | 26.3 ms | 26.3 ms |
| Sum of optical segments | **86.7 ms** | `41.9+18.5+26.3=86.7 ms` |
| Whole protective-device chain | `86.7 ms + tC` | **tC remains additional/unknown** |
| Error if only standard pair 26.3 ms is used | Not endorsed | **60.4 ms plus omitted controller/extension timing** |

**INDEPENDENT ARITHMETIC-CONFIRMED** sum, **not TEST-CONFIRMED machine timing**. There is no universal distance penalty in millimeters here: it depends on the applicable safety-distance method, actual stop response, selected resolution, approach geometry and other terms. Do not invent a stopping distance or infer the selected machine's stop time.

## A subtle configuration failure path

1. A builder adds a second curtain to guard a rear access route, keeps one OSSD pair and sees both devices green.
2. The existing SRS/validation packet still lists the **single-pair** response time and old resolution.
3. MSR42 blanking is enabled to avoid stopping for a workpiece; the new resolution and response-time label are not updated.
4. A person can potentially approach the hazard during the unaccounted latency or through a larger undetected object region, even though the electrical chain functions as configured.

Steps 1–4 describe an **INFERENCE/adversarial hypothetical**, not an observed fault. The manufacturer **DOC-CONFIRMS** the timing/resolution change and recalculation requirement. No runtime or physical test was performed.

## Separate protective functions and physical authority

`person approach / hazard -> selected curtain geometry and effective resolution -> cascaded segment response + controller/extension delay -> OSSD safety channels -> independent safety logic -> final electrical/hydraulic/mechanical elements -> physical stop/hold -> occupancy/zone clear -> manual reset as required -> fresh deliberate start`.

Do not replace the independent safety controller with ordinary LinuxCNC/HAL/FPGA just because a common OSSD pair is convenient. A green OSSD or successful normal CNC feed-hold does not establish the final-element response, gravity-load holding, stopping distance or personnel clearance.

## Practical change-control / low-bypass design

- Require a single visible `ESPE-CONFIG-ID` identifying **every segment** (part suffix, height, resolution, order, cable length), MSR41/MSR42 revision, scan/blanking/muting/stop-delay/extension settings, label and SRS.
- Derive **total response** from the selected exact OEM configuration, not a sensor sticker alone. Independently check sum/units; update safety-distance/physical witness records and invalidate stale `VAL/PT` on any change.
- Keep blanking explicit and mode-limited; do not make nuisance stoppages disappear by silently relaxing resolution. If material handling encourages bypass, redesign fixture/guard geometry and the validated blanking scheme.
- Provide easy-to-reach inspection points, protected cabling, clear mode indication, and a simple approved revalidation checklist. Do not instruct an operator to reach into an energized field to prove response.

## Evidence ledger and release boundary

- **DOC-CONFIRMED:** Rockwell original 445L-IN005C-EN-P Jan 2024 pp.2,5,6: cascading sum, Table 1, MSR42 blanking/resolution/timing and recalc requirement; product-specific restrictions.
- **INDEPENDENT ARITHMETIC:** `41.9+18.5+26.3=86.7`, omitted `60.4` ms if single-pair value is incorrectly reused.
- **SOURCE-CONFIRMED LinuxCNC:** none; no LinuxCNC code was needed to establish this OEM behavior.
- **TEST-CONFIRMED:** none; no workflow, simulation, machine operation, stop-time or force measurement.
- **COMMUNITY-REPORTED:** none used.
- **INFERENCE:** stale configuration, bypass incentives and increased exposure from omitted latency.
- **UNKNOWN:** actual selected sensor topology, MSR configuration, physical stopping, target PL, response measurement, restart/hold and qualified evaluator.
- **OpenPressBrake:** no assertion any Micro 400 is installed. Stage A A–G missing; **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD**; no personnel-exposed hazardous operation.
- **Compute:** zero GitHub-hosted and zero self-hosted lab minutes. Document and hand arithmetic only.

**Next exact discriminator:** selected machine's as-built curtain segment inventory, controller configuration export, revisioned timing/resolution label and independent qualified stop/hold/restart validation; no field operation or ad hoc live beam interruption authorized.