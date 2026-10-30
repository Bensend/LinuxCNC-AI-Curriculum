# 4400-DANFOSS-STO-REARM-01 — STO can remove torque while selected restart mode re-enables motion without a manual drive reset
**2026-10-30 | original OEM programming guide | NON-GRADUATED | NO PHYSICAL TEST**

## Specific safety question and predecessor
A safety-rated STO input is asserted and the motor coasts. Once the external STO circuit is restored, does the **drive itself** always require a manual reset before accepting a retained run command? **No: the exact Danfoss drive parameter selection changes this behavior.** This is an exact 2026 manufacturer source/parameter delta to existing [RST-01](../safety-course/4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md), [FDI-01](4400_SIEMENS_S210_FDI_ASYMMETRIC_DISCREPANCY_FAULT_TO_STO_SOURCE_AUDIT_2026-10-26.md), [VFD-EXIT-01](4400_VFD_EXIT_01_LINUXCNC_2910_SHUTDOWN_HAL_MODBUS_LAST_COMMAND_VS_INDEPENDENT_STOP_SOURCE_AUDIT_2026-10-29.md) and the same-session [ATV12 ordinary fault-retry audit](4400_VFD_RESTART_01_SCHNEIDER_ATV12_2018_RETRY_MASKED_R1_HELD_RUN_FLYING_RESTART_OEM_AUDIT_2026-10-30.md). Do not re-teach a general reset competency or conflate STO activation with independent occupancy checking.

## Direct original document and exact scope
**DOC-CONFIRMED:** Danfoss Drives A/S, *VLT AutomationDrive FC 301/FC 302 Programming Guide*, original PDF [manufacturer-hosted latest document](https://assets.danfoss.com/documents/latest/431896/AU275636650261en-003201.pdf), inspected 2026-10-30. **The retrieved PDF's actual cover/footer is edition `AU275636650261en-003301`, copyright 2026.02, software versions `10.00` and `49.1x`; the URL's `-003201` suffix is stale and must not be treated as the inspected edition.** This live URL is not an immutable archive. Directly inspected printed pp. **225–226**, §**5-19 Terminal 37 Safe Stop**, and printed **843**, Warning 73. Product/firmware applicability requires selected drive identity; terminal 37 is marked "where available" in the wiring example.

### Exact OEM option behavior (not generic across drives)
| `5-19` option | OEM-described reaction when STO is activated | OEM-described reaction when external STO circuit is restored | What still must be independently established |
|---|---|---|---|
| **[1] Safe stop alarm** | Motor coasts; drive alarm | Drive requires a **manual reset** through LCP, digital input or fieldbus | Reset is not an area-clear check, fresh normal START, standstill, isolation or proof of brake holding |
| **[3] Safe stop warning** | Motor coasts with terminal 37 off | Drive **continues without manual reset** when STO circuit is re-established | External independent safety logic must prevent unexpected restart, with validated restart policy and physical protection |
| **[4] PTC 1 alarm / [5] PTC 1 warning** | Option-specific STO behavior with MCB 112 | Warning variant can resume without manual reset under the stated PTC-input condition; alarm variant requires reset | Exact optional card, inputs and interlocks are application-specific |
| **[6]–[9] PTC/relay combinations** | Option-specific warning/alarm combinations | Not interchangeable with [1]/[3]; exact MCB 112 and input conditions govern | Do not assume a selected machine has these options |

**DOC-CONFIRMED, printed p.843:** the guide's **Warning 73, Safe Stop Auto Restart** states that the motor may start after the condition clears when automatic restart is enabled. This is a warning about a *possible drive response*, not proof that any selected spindle will start or that a safety system is absent.

**Important separation:** STO removes the drive's torque-producing capability while selected; it does not guarantee instant mechanical standstill, electrical galvanic isolation, gravity-load support or absence of personnel. Restoring STO permission and a retained ordinary RUN command can be hazardous without independent reset/restart interlocks. Conversely, the [1] manual drive reset option does **not** itself provide whole-cell safe restart or physical stopping proof.

## Failure-path review
1. **Guard opens:** qualified external safety logic selects STO; motor can coast. No claim of a selected stop category or stopping distance is possible without exact machine evidence.
2. **Guard closes while operator remains in danger zone:** if `5-19=[3]`, the OEM says the drive can continue without manual reset when STO is restored. This is **not** an independent authorization to restart. External occupancy/whole-body access, deliberate reset and new normal start must be assessed.
3. **A technician presses drive reset with `5-19=[1]`:** drive fault can clear, but the technician's button is not a qualified check that guards are restored, the tool is stopped or the work area is clear.
4. **Controller/fieldbus retains RUN:** the ordinary run command may remain present after STO is deselected; do not infer a fresh operator edge from a returned green drive status. The actual result depends on selected drive control mode and safety architecture.
5. **Service/maintenance:** STO alone is not electrical isolation. A coasting spindle, suspended load or residual energy requires separate physical controls.

## Practical low-bypass design
Provide distinct operator indications **STO REQUESTED**, **DRIVE STO STATUS**, **STANDSTILL/SAFE ACCESS (only if independently proven)**, **SAFETY RESET PERMITTED**, **NEW CYCLE START REQUIRED**. Do not collapse a restored terminal-37 circuit or an ordinary drive alarm acknowledgment into a personnel-clear signal. Use accessible reset sightlines and guard/maintenance provisions so technicians are not incentivized to defeat the device.

The **selected independent safety system** must own personnel-protective stop/rearm authority; ordinary LinuxCNC/HAL/FPGA may command normal motion and report diagnostics only. The actual safety function may be designed to allow automatic restart only where risk assessment and guarding make it safe, but this cannot be inferred from the drive's option name. No blanket prohibition or universal restart category is invented.

## Evidence and decision
- **DOC-CONFIRMED:** exact original 2026.02 Danfoss FC301/FC302 guide, §5-19 pp.225–226, Warning 73 p.843, edition/URL mismatch.
- **SOURCE-CONFIRMED:** repository RST/FDI/VFD-EXIT/ATV12 predecessor scope; no new LinuxCNC implementation behavior claimed.
- **INFERENCE:** retained normal RUN plus STO warning mode can create unexpected restart if external logic permits; needs application-specific design and validation.
- **UNKNOWN:** selected drive, exact firmware/5-19 setting, installed STO wiring, independent safety program, physical coast time, guarding/occupancy, load holding and qualified release.
- **TEST-CONFIRMED:** none. No workflow, simulation, build, physical test, machine operation or compute.
- **Reopen:** selected exact drive/firmware, as-built safety circuit and parameter export, qualified remote/isolated physical witness and independent 2520–25F0 evaluation. Do not add an owner questionnaire; use applicable restricted Stage A/conditional Stage B evidence.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed hazardous operation is authorized by this source audit.
