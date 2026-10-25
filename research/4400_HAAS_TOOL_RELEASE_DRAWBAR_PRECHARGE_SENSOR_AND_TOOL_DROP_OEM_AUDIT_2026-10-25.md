# 4400-ATC-01 — CNC toolchanger retention, release precharge, and false sensor confidence
**2026-10-25 | direct original Haas service HTML | DOC-CONFIRMED model-specific | no physical test**

## Question
If a spindle is stopped, the CNC shows "tool clamped", and the tool release valve is uncommanded, is the suspended tool mechanically secure? **Not established.** Actual clamp force, retention parts, pneumatic valve/precharge and toolchanger-arm transfer must be separately qualified.

## Direct manufacturer source
1. Haas VF/VM-Series Service Manual, **9.4 40T Spindle Drawbar Troubleshooting Guide TG0132, Revision A 12/2025**, https://haascnc.com/service/online-manuals/vf-vm-series---service-manual/vf-vm---40t---spindle.html.html.html.html.html , §9.4 "Introduction", "Symptom Table", "TRP Sensor(s)", "Air Pressure", "Belleville Springs". Original OEM HTML directly inspected 2026-10-25.
2. Haas Mill Tool Changer Service Manual, **9.2 Side Mount Tool Changer — Double Arm/Cambox Troubleshooting TG0128 Revision B 08/2025**, https://haascnc.com/service/online-manuals/mill-tool-changer---service-manual/tool-changer-troubleshooting-guides.html , §§9.1/9.2 "Double Arm", "Double Arm Alignment", "Cambox Proximity Sensors". Original OEM HTML directly inspected.
3. OSHA **2002-06-21** letter on tool/carrier changes and the 1910.147 minor-servicing exception: https://www.osha.gov/laws-regs/standardinterpretations/2002-06-21 ; **official search-index excerpts only, original returned 403**. This was a **motion packaging machine**, not a Haas mill, and the exception is task-specific rather than a blanket CNC toolchange exemption.
4. OSHA LOTO eTool machine guarding/normal production: https://www.osha.gov/etools/lockout-tagout/hot-topics/relationship-subpart-o/normal-production ; official indexed excerpt only, direct 403. Do not treat excerpts as a complete legal interpretation.

## OEM-specific facts
| ID | DOC-CONFIRMED OEM evidence | Unsafe shortcut to reject |
|---|---|---|
| ATC-01 | Haas TG0132 identifies drawbar, retention balls, pull stud and **Belleville springs**. Worn/broken springs can cause tool pull-out. | "Spring clamped" always guarantees enough retention force. |
| ATC-02 | Haas describes **toolholder dropping before toolchanger grabs it** when clamp force is too low or TRP precharge is incorrect. | "Clamp switch on" proves mechanical force or tool capture. |
| ATC-03 | Haas links **Alarm 9970 Unexpected Tool Release** on some 40T/50T belted spindles to delayed I/O precharge-solenoid turnoff and documents service kits for the fault. | Uncommanded release cannot occur if the CNC normal command bit is off. |
| ATC-04 | TRP sensor misalignment and insufficient air pressure/volume cause tool release/clamp faults; Haas prescribes sensor alignment and mechanical inspection. | A diagnostic bit independently measures pull force. |
| ATC-05 | Haas toolchanger guide documents worn/damaged **extractor fingers and springs** allowing tool to fall from pocket. | Spindle drawbar retention covers carousel/pocket transfer. |
| ATC-06 | Haas SMTC double arm's **spring-loaded slide** and adjuster retain tool; too-loose adjustment allows tools to rock or fall; sensor/cable failures can make machine believe arm is at home and command Z motion that damages arm. | An arm-home proximity switch proves clear mechanical travel and held tool. |
| ATC-07 | Haas HSK-A63 push-out service documentation applies only to named HSK spindle variants and requires an OEM clamp-force gauge; model-specific acceptance values are not transferable. | Reuse HSK clamp/push-out specifications on generic 40T, BT or other toolholder designs. |

**No conclusion that these faults occur on any LinuxCNC machine.** They are documented OEM failure mechanisms to test the architecture of a generic machine design. These OEM documents are not a personnel-safety certification of any spindle/toolchanger.

## Distinct physical propositions (INFERENCE)
- **R1:** spindle motor stopped / STO active.
- **R2:** drawbar physically grips pull stud with adequate force for the actual tool.
- **R3:** toolchanger arm/pocket has captured the tool before drawbar release.
- **R4:** pneumatic TRP release path is incapable of unintended actuation under the selected safety condition, including trapped air, valve faults and precharge.
- **R5:** Z/arm/pocket motions are independently prevented during access; the enclosure excludes people and parts from drop/crush zones.
- **R6:** service hazardous energy is isolated and stored energy verified; deliberate new start is required after rearm.

No single CNC/HAL bit, position switch or servo-enable command proves R1–R6. Even R1 true does not prove R2/R3.

## Failure-path review
**F-ATC1 precharge:** tool release piston precharge/solenoid fault causes insufficient clamp or unintended release; a heavy tool drops while arm has not captured it. OEM documents symptom; selected actual electrical/pneumatic failure tree remains UNKNOWN.

**F-ATC2 misposition:** arm home sensor or cable fault produces false arm-home state, Z axis advances into toolchanger. This is a manufacturer-described failure, not a tested LinuxCNC call path.

**F-ATC3 worn spring/retainer:** normal "clamp" switch reads expected position but force is below needed capacity; tool pull-out/drop hazard remains. The switch is not a force sensor.

**F-ATC4 service:** technician reaches into enclosure to replace tool/unjam arm and treats MDI/JOG, software E-stop or pneumatic off command as energy isolation; residual compressed air and mechanical gravity/counterbalance remain. Applicable LOTO and alternative protective means depend on the exact task, not on a generic tool-change label.

## Human factors and machine-neutral safety design
Prefer tool access without reaching under suspended tools, a secure external tool-change station where feasible, positive independent tool capture before release, fault messages that distinguish sensor state from measured retention, an accessible guarded jam-clear/isolation workflow and simple reinstallation of guards. If changing a tool safely requires repeated inconvenient manual steps, redesign the workflow rather than normalizing bypass.

**DOC-CONFIRMED** ATC-01..07 only within cited Haas models/editions; **DOC-CONFIRMED INDEXED ONLY** OSHA excerpts; **INFERENCE** R1..R6 and failure-tree transfers; **SOURCE-CONFIRMED** none (no LinuxCNC/PLC source); **TEST-CONFIRMED** none; **UNKNOWN** selected machine hardware/retention force/safety design. No universal pressure, force, PL/SIL, or stopping time; no live drop tests with exposed people.
