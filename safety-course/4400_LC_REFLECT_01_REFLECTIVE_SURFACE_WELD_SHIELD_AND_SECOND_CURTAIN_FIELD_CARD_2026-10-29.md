# 4400-LC-REFLECT-01 — Light curtain "green" can coexist with a missed object

**2026-10-29 | UNSCORED PAPER FIELD CARD | DO NOT TEST LIVE MACHINERY**

Read [original SICK deTec4 Core 2025 / Rockwell GuardShield 2024 OEM audit](../research/4400_LIGHT_CURTAIN_REFLECT_01_SICK_DETEC4_CORE_2025_REFLECTION_WELD_GUARD_AND_MUTUAL_INTERFERENCE_OEM_AUDIT_2026-10-29.md) after 2590 safeguards and 2530/RST-01 reset. Exact machine model/option/geometry remain UNKNOWN. Do not assume OpenPressBrake uses these products.

## Five paper challenges

**LC-R1 — shiny material bin beside a correctly aligned light curtain.** Is green OSSD proof that a hand is detected? **No.** SICK §4.3.3 and Rockwell p.7 warn reflective surfaces can divert beams so an object is not detected. The qualified design must maintain the selected OEM clearance on **all sides**; no one should use their body to check this.

**LC-R2 — numerical *example*, not an acceptance limit.** SICK deTec4 Core 8014253/1S7O/2025-04-08 Table 2 states `a=131 mm` for `D≤3 m`, and `a≈43.66×D` mm for `D>3 m` (D in m). At a hypothetical D=5 m, arithmetic gives **218.3 mm**. Do **not** copy this number to another model or to a real machine without exact qualified geometry/edition review.

**LC-R3 — maintenance adds a weld spark guard.** For a **30-mm resolution deTec4 Core**, SICK §14.3 p.66 says **double** the calculated reflective clearance and scanning range is **15% lower**. The same hypothetical D=5 m gives **436.6 mm** under the OEM conditional rule. This is a `CHG` event, not a cosmetic accessory; no claim about 14-mm versions or other models.

**LC-R4 — a second curtain is installed alongside the first.** SICK §4.3.4 warns sender-to-neighbor receiver interference can defeat detection. Use the exact OEM layout method (optical separation or reversed transmission direction where appropriate) and qualified revalidation, not ordinary CNC/HMI green indications.

**LC-R5 — someone wants to pass a rod through the curtain while the machine can move.** **Do not do that.** SICK §4.5.1 requires the dangerous state off and kept off and outputs prevented from affecting the machine during the check. A green OSSD even briefly in a properly controlled rod check is a **STOP-WORK** finding. Only a qualified, separately approved isolated procedure may perform actual validation; this card authorizes none.

## Passive inventory, no cabinet access or movement

From existing dated as-built documents/photos only: record exact curtain and receiver model/edition, resolution, installed weld guard/mirrors, transmitter–receiver span, reflective stock/bin/fixture proximity in all directions, second optical devices, OSSD safety path, independent final elements, physical stop/hold evidence, reset/zone-clear and deliberate fresh-start evidence. Do not move a bin into a protected field, enter the danger zone, open cabinets, defeat interlocks, power equipment or perform an energized test for this worksheet.

**Human-factor redesign:** make the reflective-clearance envelope easy to keep clear; mark safe material-bin parking, make cleaning/repair convenient, and make an OEM-approved shield/guard easy to identify and reinstall. Do not accept nuisance faults or inaccessible cleaning as reasons to bypass a safeguard.

**Evidence:** OEM manuals **DOC-CONFIRMED**; hypothetical scenarios **INFERENCE**; machine and physical stop **UNKNOWN**; **TEST-CONFIRMED none**. **G0/G1 HOLD; independent evaluator OPEN; no personnel-exposed hazardous operation.**