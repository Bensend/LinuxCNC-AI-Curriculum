# 4400 — SICK S300 EFI integration: scanner restart interlock can be bypassed by signal selection

**Original manufacturer-source audit, 2026-10-24 UTC.** Documentary safety reasoning, **not** an OpenPressBrake installation claim or commissioning procedure. No simulation, machine operation or performance rating is claimed.

## Engineering question

When a safety laser scanner has an internal restart interlock enabled, does that prove that a downstream safety PLC cannot re-enable motion when the protective field clears? **No.** The selected *safety-signal path* matters. This is an unusually important integration failure mode because the scanner's own configuration can appear correct while the safety controller consumes a different signal.

## Inspected original sources and precise scope

1. **SICK AG, S300 safety laser scanner, operating instructions 8010948/ZD76/2025-08-19**, official original PDF, 152 pages: https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf . Inspected printed pp. **23–25, 27, 31–34, 57–58, 88–90, 97–98, 107–111** (PDF pages are offset by the front matter). Particularly section 7.10 printed pp. 88–89 and section 3.2.8.2 printed p. 23. **DOC-CONFIRMED only for S300 models/configurations to which this edition applies.**
2. **TRUMPF TruBend Series 2000 B35 operator manual B1161en, 2023-05-01**, official PDF: https://www.trumpf.com/filestorage/TRUMPF_US/user_upload/PIM_TruBend_Serie_2000_B35_us_V3.pdf . Previously inspected and documented in [existing 4400 OEM audit](4400_TRUMPF_B35_SIDE_DOOR_ASYMMETRY_MUTE_REMOTE_SUPPORT_AND_DISASSEMBLY_AUDIT_2026-10-23.md). It describes powered-but-STO backgauge drives and different rear/side guard reactions. Reused evidence; no new original PDF re-inspection claimed here.
3. **OSHA 29 CFR 1910.212(a)(1)–(3)**: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212 . General machine guarding, not a machine-specific scanner design or backgauge performance rating.

## Exact OEM statements and evidence labels

| ID | SICK printed page / location | Documentary finding | Safety consequence / limitation |
|---|---|---|---|
| SC-01 | p. 23, EFI section | In EFI integration, whether an internal scanner restart interlock is effective depends on how scanner information is used in Flexi Soft logic. | **DOC-CONFIRMED** integration dependence, not a generic rule for all scanners. |
| SC-02 | p. 88, §7.10 | If Flexi Soft consumes scanner **OSSD status**, scanner internal restart interlock/delay affects the safety controller. If it consumes **protective-field status**, scanner internal restart interlock/delay **does not** affect Flexi Soft; an interlock/delay must then be implemented in Flexi Soft. | **DOC-CONFIRMED critical trap:** scanner configuration screenshot alone does not prove downstream restart prevention. |
| SC-03 | pp. 88–89, §7.10 | Without interlock, OSSD can re-enable as soon as field is clear, subject to the manufacturer's restricted conditions. With interlock, manual reset is required. Scanner start interlock and restart interlock are distinct. | Do not equate **field clear**, **scanner OSSD enabled**, **safety PLC ready**, **drive ready**, and **deliberate machine start**. |
| SC-04 | p. 89, §7.10 | Reset control must be outside hazard with visibility of hazard area; where both scanner and machine have interlocks, each has its own control and the order is scanner reset then machine restart. | A web/HMI reset or hidden rear-area reset is not proven safe. |
| SC-05 | p. 25, access protection | An access-detection protective field does **not** detect a person standing behind it. | Passage detection is not continuous occupancy detection. Whole-body access and rear blind zones need a separate prevention strategy. |
| SC-06 | pp. 31–32, unsecured areas | Scanner mounting can leave undetected zones; SICK requires measures to prevent entry into them. | A green scanner does not prove rear-corner or under/behind-machine occupancy absence. |
| SC-07 | pp. 24 and 97, case switching | A person can already be in the protective field at switchover; protection depends on switching at the correct time. | **INFERENCE:** a delayed or wrongly selected rear/maintenance field can create exposure even with healthy scanner electronics. |
| SC-08 | pp. 89–90, universal I/O | SICK warns that its universal I/O connections provide **non-safe signals** and must not be used for safety-related functions. | A convenient warning/diagnostic output is not a safety output. |
| SC-09 | pp. 57–58, Fig. 46 | Example S300/S3000 EFI integration with Flexi Soft assigns protective-field evaluation, restart interlock and EDM in controller. | This is a **specific OEM example**, not permission to copy wiring or a universal requirement to use EFI. |
| SC-10 | pp. 107–111, commissioning/maintenance | Manufacturer requires checks of protective-device effectiveness, including selectable modes and checks after relevant changes. | Configuration changes, scanner relocation and replacement require qualified revalidation. |

**Important:** The SICK document is not a press-brake-specific scanner certification, and the manual's product performance data cannot establish OpenPressBrake safety PL/SIL, stopping distance, field geometry, or stop category. The scanner may not even be installed. This is an **architecture transfer exercise**.

## Causal trace: why a seemingly valid interlock can be lost

**Path A — scanner OSSD state consumed by safety controller (DOC-CONFIRMED for S300/Flexi Soft):**

`person enters field → scanner protective field occupied → scanner OSSD OFF → downstream safety controller sees OSSD OFF → qualified safety final element removes/controls hazardous motion → field clears → scanner internal restart interlock holds OSSD OFF until local reset → machine's separate start authority remains controlled`.

**Path B — raw protective-field state consumed (DOC-CONFIRMED signal semantics, downstream failure an INFERENCE until wiring known):**

`person enters field → field status occupied → downstream controller stops → person crosses through scanner plane and remains behind it → field status clear while scanner internal OSSD interlock still OFF → downstream controller sees raw field clear → if its own restart interlock is absent or wrongly configured, it may re-enable final elements`.

Path B is **not** a claim that a correctly engineered Flexi Soft system will restart. SICK explicitly requires the interlock/delay to be implemented in Flexi Soft when protective-field status is used. The defect is assuming the scanner's local interlock remains authoritative after choosing a different signal.

**Separate machine-start contract (INFERENCE):** even a correctly reset safety system should only permit a *separate intentional start*, with no stored ordinary LinuxCNC/FPGA move, stale MDI command, automatic cycle continuation or remote request triggering unexpected motion. Physical stopping, gravity holding, and maintenance energy isolation remain independent.

## Backgauge and rear-zone transfer (not an installed design)

A press brake can expose helpers to **backgauge X/R/Z movement**, tool/die collisions, sheet sweep, ram hazards and a rear trapped-person zone. TRUMPF's B35 OEM text confirms the backgauge STO and rear-door behavior are distinct from beam guarding. A proposed S300-style scanner could cover some **selected** rear zones only after a site risk assessment and qualified integration; a front ram laser cannot substitute.

`rear door / rear ESPE / E-stop / local maintenance demand → independent safety controller → backgauge safe torque prevention / other qualified final elements + ram safety final elements as required → independently observed hazardous motion and access/occupancy state → separately authorized local reset and new start`.

**Do not confuse** STO with backgauge mechanical brake or beam holding. STO can leave drives electrically powered; a vertical R axis may need separate gravity-hold proof. Actual selected-machine drive type, safety interfaces, stop time, field-set geometry, optical coverage, field switching and restart wiring are **UNKNOWN**.

## Adversarial failure and human-factors review

1. **Scanner LED green, safety PLC using raw field status:** display may look healthy while PLC-side restart interlock is missing. Capture the actual consumed safety variable, logic version and output/final-element witness; **HOLD**.
2. **Person steps over scan plane or into blind corner:** access was detected once, then field clears with person still inside. Physical anti-step-over geometry, presence sensing or trapped-person prevention and deliberate reset are required. Do not assume the scanner can see all heights.
3. **Wrong field selected for production versus setup:** field might omit the backgauge approach corridor. Require safety-controlled case selection and timing validation; do not let ordinary CNC mode bits alone define the protected field.
4. **Remote HMI displays READY:** network state cannot establish physical rear occupancy, local reset or STO function.
5. **Reset switch behind the machine with no sightline:** an inconvenient/unsafe layout predicts shortcut behavior. Put reset and access controls at visible, ergonomic, guarded locations; require positive inspection of blind areas.
6. **Scanner moved to clear a material cart:** coverage, reflection, blind-zone and safe-distance assumptions change. Treat as safety-related change requiring new risk assessment and validation.
7. **Controller drops torque but ram is suspended:** backgauge drive response does not establish hydraulic holding or isolation of the press beam.

## Practical low-friction design contract (INFERENCE)

- Prefer physical fixed rear guarding and simple monitored access doors when those provide adequate protection; use a safety scanner only when the actual task and risk assessment justify it. Do not make a costly/complex scanner a default.
- Provide a clear, protected, easily accessible *local* reset with complete sightline; if complete visibility is impossible, design additional independently validated trapped-person/occupancy prevention. Avoid automatic reset on field-clear.
- In the safety-function trace, record the **exact consumed signal** (scanner OSSD status versus raw protective-field status), where the **restart interlock actually resides**, which final elements it inhibits, and how deliberate new start is enforced.
- Put service isolators, backgauge lockout, support, access gates and inspection points where workers can use them without climbing into pinch zones or bypassing guards.
- Ordinary LinuxCNC/HAL/FPGA may log diagnostics and request motion; they do not own personnel-safety final authority.

## Claim ledger / unresolved questions

- **DOC-CONFIRMED:** SICK S300 2025 edition §§3.2.8, 7.10, 7.11 and project planning; OSHA 1910.212. Prior TRUMPF 2023 backgauge and door behavior.
- **SOURCE-CONFIRMED:** no new LinuxCNC source inspected. Existing v2.9.10 ordinary Task/NML/HAL source trace remains separate.
- **TEST-CONFIRMED:** none. No paper scenario is a hardware test.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** rear-zone transfer, preferred fixed-guard-first architecture, downstream restart failure if controller-side interlock omitted.
- **UNKNOWN:** installed scanner existence/variant/firmware, actual PLC signal selection, rear geometry, backgauge brake/STO, Y1/Y2 physical stop/hold, safe distances/PL/SIL, site risk assessment, external evaluation.
- **Counterfactual:** if no scanner is installed, the OEM signal-selection lesson remains valid for *possible* designs but is not an OpenPressBrake defect. If a scanner is installed, the exact as-built safety logic determines whether this is a hazard.
- **Graduation:** source-based lesson ready for paper study; selected machine **NOT VERIFIED**, external fresh evaluation **NOT RUN**, no personnel-exposed operation.

## Next evidence request / no-lab decision

Collect exact scanner/guard models, firmware and configuration checksum, selected protective field sets and switching input, **which EFI signal the safety PLC consumes**, scanner-versus-PLC reset implementation, physical reset location/sightline, backgauge drive safety manual and STO wiring, independent ram safety/holding, complete rear access geometry, and qualified final-element evidence. Do **not** run a live person-in-field, automatic-restart, or hazardous backgauge test to answer a documentary question. A qualified isolated/remote test plan can only be frozen after as-built and risk assessment.

No GitHub-hosted Actions, local compute, physical test or safety release. Historical exact archive backlog remains **6/85**.
