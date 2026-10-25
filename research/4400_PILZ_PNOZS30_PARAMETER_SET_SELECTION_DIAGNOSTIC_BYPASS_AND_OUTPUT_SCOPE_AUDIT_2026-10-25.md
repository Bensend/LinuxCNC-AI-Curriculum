# 4400 — PNOZ s30 safety integrity changes with parameter-selection mode
**2026-10-25 | Direct original manufacturer manual | DOC-CONFIRMED for PNOZ s30 1001715-EN-24 only | No physical test**

## Unresolved question and why this is new
Can a setup/automatic-mode selector, parameter copy, or output substitution weaken a speed-monitoring safety function while normal LinuxCNC motion appears to work? Earlier curriculum research established PNOZ standstill threshold, broken coupling, automatic output reenable and CRC limitations. This investigation addresses **select-mode integrity, diagnostic bypass, output class, fault acknowledgment and delayed reaction**; do not treat it as a duplicate of those earlier audits.

## Primary source
Pilz, *PNOZ s30 Operating Manual*, **1001715-EN-24**, 133 PDF pages, original manufacturer PDF:
https://www.pilz.com/download/open/PNOZ_s30_Operat_Man_1001715-EN-24.pdf
Directly inspected §§5.3.12–5.3.13 (printed pp.25–26), §5.4.1–5.4.3 (pp.31–35), §5.4.4 (pp.35–37), §13.4 (pp.123–126). The manual is a product/edition contract, not an OpenPressBrake as-built.

## Source-confirmed documentary findings
1. **DOC-CONFIRMED (§5.4.1, pp.31–32):** In **1-of-4** selection, only P1/P2/P4/P8 one-hot input states are valid for the cited higher integrity application, up to PL e / SIL CL 3 according to the manual. Invalid selection caused by open/short/drift yields error and outputs off. The **All 16** mode admits up to 16 binary selections but is specified for applications up to **PL d / SIL CL 2**, not the same claim as 1-of-4. These are product-configuration limits, **not achieved machine ratings**.
2. **DOC-CONFIRMED (§5.4.1, p.32):** In All 16 mode, an open selection conductor can silently choose a **lower-numbered** parameter set (manual example P7→P3). Pilz says arrange speed thresholds in ascending set order and place the special diagnostic-suppression function in a higher-numbered set to avoid accidental selection. A broken wire is not universally equivalent to an all-off safety fault across modes.
3. **DOC-CONFIRMED (§5.4.3, pp.34–35):** The special **No 2 encoder diagnostics** option disables plausibility comparison for supported sensor combinations. Its use changes the required safety assessment. Selecting an **Error acknowledgement** parameter set acknowledges recoverable faults on transition and restarts the monitor; **Restart** is a separate special function. Neither is an ordinary machine cycle-start authorization.
4. **DOC-CONFIRMED (§5.3.12, p.25):** Rel.1 and Rel.2 are the device's **safety relay outputs**; Out1–Out4 are **semiconductor outputs for standard applications**. Copying a convenient Out1 warning/status into a personnel-safety chain is an authority substitution, not proof of equivalent output integrity. External safe relay expansion has its own supported conditions.
5. **DOC-CONFIRMED (§5.3.13, p.26):** Configured output **switch-off delay on overspeed adds to reaction time** and must be accounted for in risk assessment and safe-condition arrival. Input select filtering likewise delays activation of a new parameter set (§5.4.1, p.32). The manufacturer does not give a universal press-brake permissible stop delay.
6. **DOC-CONFIRMED (§5.4.4, pp.35–37):** Basic configurations may use **automatic output start** and have different default standstill thresholds by sensor type. Factory defaults are not application-specific validation.
7. **DOC-CONFIRMED (§13.4, pp.123–126):** Illustrative setup/automatic speed thresholds and feedback loops are **worked examples**. Their Hz values must not be transferred to Y1/Y2, backgauge, spindle, ram, or robot.

## Failure-path review (INFERENCE)
| Change/fault | Potential false conclusion | Required independent check |
|---|---|---|
| Technician enables All 16 to gain more modes | Same integrity as 1-of-4 | Actual selected mode, edition, required PL/SIL and assessment |
| SEL conductor opens | Always safe-off | Enumerate actual valid selection states, thresholds and broken-wire path |
| Parameter set disables 2-encoder diagnostics | Two sensors still fully cross-checked | Actual function and selected sensor arrangement |
| Switch into error-acknowledgment set | Fault cannot clear without maintenance | Event/reset ownership, fresh-start interlock, physical cause removal |
| Out1 status used instead of Rel.1 | All device outputs are safety-rated | Terminal/output class and final-element path |
| Delayed overspeed output | Faster CNC loop guarantees stop | Sum response/actuator/mechanical stop and verify on selected machine |
| Encoder on motor shaft reads low speed | Gravity ram cannot move | Mechanical coupling, independent hydraulic holding and gravity restraint |

## Scope and cross-machine transfer
For a press brake, speed monitoring may be relevant to backgauge or an appropriate moving axis **only after actual drive/sensor/load coupling and safety-function design are established**. Hydraulic ram holding cannot be inferred from motor speed. Mills/lathes have spindle coast and chuck/tool hazards; robots and feeders have mode/occupancy dependencies. The selected LinuxCNC/FPGA is normal control, never the independent personnel-safety decision maker.

## Evidence and promotion
SOURCE-CONFIRMED: no new LinuxCNC source trace in this audit. DOC-CONFIRMED: exact manual paragraphs above. TEST-CONFIRMED: none. COMMUNITY-REPORTED: none. INFERENCE: fault paths and transfer. UNKNOWN: installed PNOZ s30, parameter dump, actual selector wiring, encoder coupling, final elements, reaction/stopping distance, PL/SIL, Y1/Y2 physical stop/hold. No hazardous machine test authorized. G0/G1 HOLD; G3/G4 NOT AUTHORIZED; G5 independent evaluation OPEN.

Related preexisting audits: [standstill sensor scope](4400_SAFE_STANDSTILL_UNLOCK_PNOZ_S30_SENSOR_DIAGNOSTIC_SCOPE_2026-10-22.md), [automatic reenable](4400_PNOZ_S30_AUTOMATIC_OUTPUT_REENABLE_VS_FRESH_MACHINE_RESTART_2026-10-23.md), [configuration CRC](4400_PILZ_PNOZS30_CONFIG_CRC_TRANSFER_VS_FUNCTION_TEST_2026-10-23.md).
