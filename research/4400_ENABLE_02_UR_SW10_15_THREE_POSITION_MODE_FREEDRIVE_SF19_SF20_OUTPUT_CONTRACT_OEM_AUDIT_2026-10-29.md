# 4400-ENABLE-02 — Three-position enabling output is mode- and Freedrive-dependent, not a universal grip-healthy bit
**2026-10-29 | original online manufacturer documentation, UR g-Series / PolyScope X SW10_15 | documentary source audit | NON-GRADUATED**

## Question and predecessor
The existing [Rockwell 440J ENABLE-01 audit](4400_ROCKWELL_440J_THREE_POSITION_ENABLING_VS_PEDAL_AND_MULTI_PERSON_SOURCE_AUDIT_2026-10-25.md) already proves a three-position grip is a *permissive* rather than a motion-start command, and addresses panic release, reduced performance, guard suspension and multiple entrants. This audit answers a narrower, **not previously indexed** integration question: can an external safety controller interpret the *named* 3PE safety output from a selected robot as a universal "grip held, person protected" signal? What changes in automatic mode and Freedrive?

## Original manufacturer sources inspected 2026-10-29
1. Universal Robots, **g-Series User Manual / PolyScope X SW10_15, Safety Functions Table**, official online manual: https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/safetyFunctionsAndinterfaces/safety_functions_table1.htm — directly read SF18, SF19, SF20 and footnotes 4, 8–11 (web lines 132–154 and 171–181).
2. Universal Robots, **g-Series / PolyScope X SW10_15, Operational Mode**: https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/complianceG7/PolyX_SW/psx_ops_mode.htm — directly read mode/3PE/restart/occupancy sections (lines 92–123).
3. Universal Robots, **PolyScope X SW10_15, Manual High Speed**: https://www.universal-robots.com/manuals/EN/HTML/SW10_15/Content/prod-usr-man/software/PolyScopeX/polyx-safety/polyX-ManualHighSpeed.htm — directly read requirements, footer, separate start and inactivity reset (lines 67–95).
4. IDEC, **HE2B Series**, current official product-family page: https://www.idec.com/en-us/safety-explosion-protection/safety-components/enabling-switches/he2b-series — directly read three-position contact behavior and B10d product-family listing (lines 167–181). This supports *device* contact behavior only, not UR output semantics or a system-level PL.
5. Rockwell 440J February 2026 original PDF: see predecessor audit. No hidden evaluator material consulted.

These are manufacturer-hosted *online* pages; exact SW10_15 URL and retrieved text are preserved, but no immutable PDF byte hash or installed firmware identity was obtained. Do not generalize to other UR versions, robots or safety-PLC configurations.

## Direct documentary findings (DOC-CONFIRMED, product/version scope only)
- **3PE is active in manual, not automatic:** UR Operational Mode says the center-ON grip is required for motion in Manual Mode; the 3PE **has no effect in Automatic Mode**. Automatic operation requires its own validated safeguards. A mode transition Automatic → Manual requires complete release and a new press before motion. Suspended safeguards must be restored before returning to Automatic.
- **SF18 is a safety input/stop function:** fully released and fully squeezed are both OFF; in Manual Mode an OFF input invokes SF2 Safeguard Stop, **Stop Category 2 / SS2** for this UR implementation. Category 2 **retains drive power** after stopping; it is not STO, maintenance isolation, or proof a carried load is secure (SF table footnote 4).
- **SF19 is not a generic "all grips held" signal:** the manufacturer states **SF19 outputs HIGH in Automatic Mode**, where the 3PE does not act as a manual enable. In Manual Mode *without Freedrive*, SF19 is HIGH when **all** enabling devices are ON and LOW if **any** is OFF. In Manual Mode **with Freedrive activated**, the table reverses this aggregation: **all OFF → HIGH; any ON → LOW**.
- **SF20 is not a generic "grip released" signal:** the manufacturer calls SF20 the inverted SF19 output. Thus it is LOW in Automatic; in Manual Mode its values also depend on Freedrive and all/any 3PE state. Exact table context is mandatory.
- **Manual high speed is a distinct selected mode:** the OEM allows an operator to raise the permitted manual speed under specific safety configuration, with 3PE still held and a **separate motion start**. The footer displays the *permitted limit*, not actual speed. The product's 250 mm/s default reduced limit and 160–250 mm/s configurability are **UR SW10_15-specific**, not a universal safe approach speed or machine-level validation. The setting requires application risk assessment.
- **Multi-person scope:** UR explicitly says an additional enabling device must be configured if another person can enter during Manual Mode. The existence of one 3PE cannot prove the space is empty, every entrant is protected, or the automatic safeguard has been restored.

## Causal failure-path audit (INFERENCE, not observed faults)
| Scenario | Mistaken external interpretation | Source counterexample | Engineering disposition |
|---|---|---|---|
| Automatic mode selected while someone is in a cell | SF19 HIGH means a person holds the grip | SF19 HIGH in Automatic even though 3PE has no effect | Require independently validated mode/guard/occupancy and safety functions; do not use SF19 alone for a hazardous final-element enable. |
| Manual Freedrive activated | SF19 HIGH means all grips are centered | Manufacturer says all grips OFF → HIGH in Freedrive | Freeze exact selected mode and complete truth table before integration. |
| Operator squeezes grip in panic | Opening SF18 implies motor torque removed | UR SF2 uses Category 2, power retained | Verify stop/standstill and selected load/energy safe state; do not claim STO or hydraulic isolation. |
| Mode transition to Automatic | Guard suspended in Manual remains safe because grip exists | 3PE ineffective in Automatic; safeguards must be restored | Prevent automatic rearm until independent safeguard restoration, personnel clearance and fresh start. |
| Operator uses high-speed manual | Footer shows 250 or another value, therefore physical speed is proven | Footer is permitted speed limit, not measured speed | Qualified safety limits and application validation; no ordinary HMI or FPGA substitute. |

## Practical safety architecture contract (INFERENCE; design, not implementation)
1. **NORMAL CONTROL:** LinuxCNC/HAL/FPGA may request selected manual jog, trajectory, status display and logs. It does not grant personnel-safety permission.
2. **SAFETY-RELATED CONTROL:** a qualified, selected safety system must resolve actual operating mode, task-specific guard suspension, all exposed entrants' enabling devices, stop category, safety speed/space limits and fault handling. SF19/SF20 may be used only with the OEM's complete mode/Freedrive truth table and compatible selected safety input architecture.
3. **PHYSICAL FINAL ELEMENTS:** selected drives/valves/brakes/retainers must be shown to stop and hold the actual hazard, including external-force and gravity loads. Category 2 and a high digital output are not isolation or a safe-access witness.
4. **RESET/RESTART:** restore guards, confirm clearance, exit special mode, clear faults deliberately and require a new motion command. Do not automatically reuse a held jog/start request or treat 3PE center position as a start.
5. **HUMAN FACTORS:** use ergonomic grip, visible mode status and a setup workflow that does not encourage taping the switch or leaving a guard defeated. If a task is too awkward to perform safely, redesign the task/fixture/access rather than weaken the safety condition.

## Evidence/unknowns and verification gate
- **DOC-CONFIRMED:** exact UR SW10_15 SF18–20/footnotes and mode/manual-high-speed descriptions; IDEC component-family contact descriptions.
- **SOURCE-CONFIRMED (repository):** existing Rockwell ENABLE-01 predecessor; no new LinuxCNC implementation behavior asserted.
- **INFERENCE:** external integration failure paths and recommended independent architecture.
- **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none used.
- **UNKNOWN:** selected robot/version, actual SF19/20 wiring and Freedrive option, safety controller/PL/SIL, actual stop time/distance, loads, occupancy, physical safety, OpenPressBrake applicability and external evaluator.
- **Question-driven lab:** none justified. Manufacturer's table answers the logic question; a simulator would not validate physical machine safety. A future selected-machine verification must be qualified and isolated, not a public live bypass experiment.

**Do not operate with people exposed if the selected independent protection and physical safe state are unproven.** Experimental operation, if later justified, requires separate qualified approval, isolated/remote execution and exclusion of people from the hazard zone. OpenPressBrake G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.

## Adversarial OEM wording tension and version corroboration
**Potential documentation ambiguity (not a confirmed firmware defect):** within the same SW10_15 SF19 table, the general Manual-mode sentence says an OFF enabling device triggers SF2 and drives SF19 LOW, while the **specific Manual+Freedrive** subcase says **all OFF → SF19 HIGH**. Those statements cannot safely be collapsed into "HIGH means no 3PE stop." The precise internal stop state during Freedrive, and whether the subcase is a deliberate exception to the general sentence, requires selected OEM clarification or an independently qualified isolated integration review. **UNKNOWN** until resolved; never resolve the ambiguity by assuming a convenient high-level permission. The source text itself is **DOC-CONFIRMED**; any inferred contradiction in runtime is **UNKNOWN**, not TEST-CONFIRMED.

**Independent manufacturer version cross-check:** UR SW5_25 UR12e original PDF indexed table (https://www.universal-robots.com/manuals/EN/PDF/SW5_25/user-manual-UR12e-PDF_online/733-429-00_UR12e_User_Manual_en_Global.pdf) and UR SW10_14 UR3e online SF19/20 (https://www.universal-robots.com/manuals/EN/HTML/SW10_14/Content/prod-usr-man/complianceUR3e/safetyFunctionsAndinterfaces/safety_functions_table1.htm) repeat the documented SF19 Automatic-HIGH and Manual Freedrive inversion. These were **indexed/HTML evidence**, not full immutable-PDF visual inspection or a proof of universal cross-version behavior. Selected model/software and external receiver remain essential.

## Compact OEM SF19/SF20 output-state table (source transcription, not a complete stop-state truth table)
| Selected mode | Freedrive state | 3PE aggregation | SF19 | SF20 | What cannot be concluded |
|---|---|---|---|---|---|
| Automatic | not applicable | any grip state | HIGH | LOW | No inference that a grip is held or automatic guarding is valid. |
| Manual | not active | **all** center ON | HIGH | LOW | Still requires separate start, guards/occupancy and physical safety. |
| Manual | not active | **any** OFF | LOW | HIGH | Cannot infer drive torque removal (SF2 Cat2). |
| Manual | active | **all** OFF | HIGH | LOW | **Not proof no stop:** generic Manual sentence conflicts in scope with this special-case output row. |
| Manual | active | **any** ON | LOW | HIGH | Cannot infer hazardous motion is stopped or all entrants are protected. |

The table records *manufacturer-described output levels only*; it does not reconstruct undocumented safety-state transitions, electrical test pulses, channel fault behavior, or a selected safety PLC program. The [Safety I/O source-depth](4400_ROBOT_STATUS_01_UR_SW10_15_MOVING_NOT_STOPPING_TOOL_IO_AND_SAFEGUARD_STOP_SEMANTICS_AUDIT_2026-10-29.md) further documents optional OSSD LOW test pulses while a logical output is HIGH.
