# 4400 OPB-IO-POINT-OF-USE-01 — Rev1 I/O map safety-authority and mute/reset wording repair

**UTC start 2026-10-29T12:34:19.780Z | 2026-10-29 | SOURCE-CONFIRMED public-document correction | NON-GRADUATED | NO MACHINE TEST**

## Bounded engineering question

Can a builder read the published OpenPressBrake Rev1 I/O map and mistakenly conclude that a retained Pilz/AKAS system is *verified* to be independent, that inactive normal CNC commands guarantee safe Pilz behavior, or that a hardwired proportional-stage inhibit proves the gravity-loaded ram is held?

**Yes, the previous prose permitted those inferences; no, the published mapping cannot substantiate them.** This is an exact **documentation-claim repair**, not a new installed-machine failure or a claim that the proposed electrical design has changed.

## Direct, revisioned source evidence

| Source | Narrow finding | Evidence class |
|---|---|---|
| OpenPressBrake `docs/IO_MAP.md`, old blob `fd839a3c1cabc71436e2e59d0c121ed4d8a62792` | Intro said retained Pilz/AKAS/SICK “remains the independent safety system”; command paragraph said all outputs default inactive; wire75 paragraph said loss “suppresses proportional actuation independently”; on/off valve paragraph said they “stay under Pilz authority”. These are **intended design boundaries** but the text lacked adjacent as-built, selected-PLC and physical-fault qualification. | SOURCE-CONFIRMED published wording, not installed proof |
| [Corrected OpenPressBrake I/O map commit](https://github.com/Bensend/OpenPressBrake/commit/756c52f98fd3eb70cfffe34f120a12a7dbfa1d8c), blob `3b696947a3b2c400340eb005b4c410de8abae132` | Adds explicit design-intent / G0-G1 HOLD warning, separates ordinary inactive outputs from unknown PLC logic, calls wire44 a normal mute *request* rather than reset/override, qualifies wire75 hardware-gate intention, and marks retained valve ownership as source-derived rather than physically validated. | SOURCE-CONFIRMED documentation change |
| [OpenPressBrake safety-interface checklist](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/blocks/safety_interface/STATUS_CHECKLIST.md), blob `2f12be48e4b82523dbb62f11894283f49b765679` | Safety interface **BEHAVIORAL ONLY / NOT SCHEMATIC-READY**; no physical safety final-element qualification. | SOURCE-CONFIRMED design status |
| [OpenPressBrake endpoint audit](https://github.com/Bensend/OpenPressBrake/blob/main/docs/REV1_DNC_PVR_ENDPOINT_AUDIT.md), blob `717e7a07ab2d170b7727bb19c06734f5b31f83aa` | Six ordinary DNC→Pilz inputs 42–47, wire75 Pilz→PVR, wire63 Pilz→X drive, three Pilz-controlled on/off hydraulic valves, switched L7/L07. | SOURCE-CONFIRMED published reconstructed drawing, as-built UNKNOWN |
| [Pilz PNOZmulti Special Applications 1002337-EN-02](https://downloads.pilz.nl/downloads/PNOZMulti/PNOZmulti_Spec_Applic_Op_Man_1002337-EN-02.pdf), ch. 2 pp. 2-4–2-6 | Its *generic conveyor muting element* differentiates reset pulse edge, muting override, muting sensor qualification and reset-location visibility. **This example is NOT the selected OpenPressBrake AKAS function or proof of installed logic.** It was already covered by AKAS-M-01; cited here as a negative transfer check, not new OEM discovery. | DOC-CONFIRMED only for the specified manual/application |
| [Prior AKAS-M-01](4400_AKAS_LCII_M_PILZ_MUTING_SLOW_SPEED_OVERTRAVEL_AUTHORITY_AUDIT_2026-10-27.md) and [OPB-CUTOVER-02](4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_CROSS_REPOSITORY_SOURCE_AUDIT_2026-10-27.md) | Already established external safety PLC authority, the normal wire44 mute request and the danger of transferring generic conveyor muting to a press brake. This investigation **does not create a duplicate new competency**. | SOURCE-CONFIRMED predecessor |

## Four distinct propositions that must not be collapsed

1. **Ordinary CNC request** — six 24-V controller→Pilz lines, including `CTRL_MUTE_COMMAND` (wire44), `CTRL_CNC_OK` (45), TDC (42), end-of-bend (43), manual mode (46), and UP (47). A documented default LOW after boot/watchdog is a *proposed electrical behavior*, not an independently proven safety transition. Actual input polarity, edge qualification, freshness, source validity, reset/override allocation and interaction with mode changes require the selected Pilz application.
2. **Independent safety decision** — exact Pilz/AKAS installed program, selected guard modes, independent position/speed/protective-device evidence, restart interlock and diagnostic coverage. No public I/O label establishes these.
3. **Physical final-element command** — proposed wire75 local proportional-stage gate, separate wire63 X-drive B4 and retained 11Y4/11Y6/11Y8 valve outputs. A proposed hardware inhibit may be useful ordinary fault containment; it cannot prove fault-dominance of the final PCB or complete hydraulic stop.
4. **Actual safe state** — ram stopping/holding, X stopping, stored-energy control, accessible-zone protection and deliberate new start require qualified independent machine evidence. Neither a green PLC bit, de-energized proportional command, nor a healthy source map is a physical witness.

## Conditional adversarial review, NOT machine observations

| Hypothetical condition | Potential shortcut to reject | Documentary discriminator |
|---|---|---|
| FPGA boot/watchdog drops wire44 LOW | “LOW always restores AKAS protection.” | Selected Pilz program and exact guard/mute reset logic; do not assume edge, timer or safe mode. |
| Wire44 stuck HIGH or backfed while FPGA requests LOW | “Our software defaults inactive, therefore no mute can persist.” | Independent input monitoring and alternate safe speed/position/guard conditions in selected safety design. |
| L7/L07 field power OFF→ON while core remains on | “Output default is enough to prevent restart.” | Current board command-state policy, actual 11K2 return/power validity, independent safety restart interlock, separate deliberate new START. |
| Wire75 removed; ordinary proportional command zero | “Ram must be held.” | Exact hydraulic valve/chamber path, independently proven gravity restraint, leakage and stored-pressure conditions. |
| Pilz output status healthy | “Safe for technician to enter.” | Guard/access hazard map, verified physical stop/hold/energy isolation and maintenance procedure. |

These are **INFERENCE** failure hypotheses. No actual polarity, timing, hydraulic truth table, stopping distance, PL/SIL, diagnostic coverage or bypass behavior is asserted. Do not inject faults or energize the machine to answer a public worksheet.

## Point-of-use correction and reviewer workflow

The OpenPressBrake I/O map now gives the caveat beside the relevant descriptions, not only in a separate safety document. Keep the one-page Stage A A–G owner request unchanged. After a qualified owner supplies existing restricted documents, use existing [OPB-D01–D08 reviewer delta](../safety-course/4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md): verify the actual PLC input meanings (D01/D02/D03), independent hardware gate and final elements (D04/D05), switched returns (D06), and physical stop/hold plus deliberate restart (D08). Never assume that a generic Pilz PNOZmulti conveyor-muting reset block is the installed press-brake program.

**Human-factors INFERENCE:** point-of-use wording may prevent a technician from equating inactive I/O, a healthy HMI, or an asserted hardware gate with safe access. Actual adoption/understanding **UNKNOWN**; no external blind evaluator was run.

## Release/evidence accounting

**SOURCE-CONFIRMED:** exact before/after public I/O wording and existing published endpoint map. **DOC-CONFIRMED:** generic Pilz manual distinction, previously studied. **INFERENCE:** conditional misuse paths and human-factors benefit. **COMMUNITY-REPORTED:** none used. **TEST-CONFIRMED:** none. **UNKNOWN:** installed Pilz/AKAS program, final board circuit, actual wire75 fault dominance, independent Y1/Y2 stop/hold, X stop, guards, isolation, reset/rearm, selected-machine revisions and physical witness.

No GitHub Actions, hosted/self-hosted runner, simulation, build, electrical probe, physical operation or independent evaluation. No new authoritative runtime; lab ledger and score ledger unchanged. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation.**


## Same-session configuration source-of-truth follow-through

[OpenPressBrake `hardware/REV1_MACHINE_CONFIG.yaml` commit `e9bf068940820a5d4ee3e4064d1c25e8060d991c`](https://github.com/Bensend/OpenPressBrake/commit/e9bf068940820a5d4ee3e4064d1c25e8060d991c) adds six **comment-only** lines beside `digital_outputs.safe_state: inactive` and `safe_states.controller_to_pilz_handshakes: inactive`. Original blob `2272a4e1dfd50e467d702a69a11224333be59f2b` → new `37119336acf8113fb59c79865de29edd1c70e285`. A direct before/after comparison after removing comment-only lines was **identical**; all YAML keys, values, mappings, wiring and control behavior are unchanged. The comments make the necessary distinction at the machine-readable source: ordinary inactive electrical defaults do not establish actual Pilz input semantics, restored protection, deliberate restart or physical ram holding. **SOURCE-CONFIRMED documentation-only repair; not a tested implementation, safety-rated design, or machine proof.**
