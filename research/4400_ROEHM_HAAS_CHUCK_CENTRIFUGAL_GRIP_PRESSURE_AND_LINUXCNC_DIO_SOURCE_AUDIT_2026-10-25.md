# 4400-CHUCK-01 — Original workholding and LinuxCNC source audit
**2026-10-25 | 4000 safety | documentary/source only, NON-GRADUATED**

## Engineering question
Does a pressure OK signal, chuck stroke sensor, LinuxCNC output or commanded RPM establish that a rotating workpiece cannot be ejected? **No.** These indicate different propositions, and the selected machine's actual dynamic retention, guard containment and safe stop remain UNKNOWN.

## Original manufacturer and agency evidence
1. **RÖHM KFD power chuck operating instructions**, printed 12/03, document 15318-k001-001, original 48-page PDF (English printed pp.9–13; PDF pp.8–12): https://www.roehm.biz/fileadmin/products/media/en/DC0000345.PDF . **DOC-CONFIRMED:** spindle startup requires prescribed piston stroke range and the manufacturer requires a clamping force check; high speed requires a functioning chuck and allowable actuation force; heavy or extended special jaws require a new permissible-speed/grip analysis; adequate protective enclosure required. The manual differentiates stationary grip force from centrifugal force under rotation, including reduction of outside-in gripping force as speed increases. English pp.10–11 require physical force checks, maintenance/lubrication and inspection after collision; some interrupted-pressure fixtures can lose grip gradually. Historical references to EN 1550/EN 12415/VDI 3106 are NOT a claim of current standard compliance. Do not transfer the manual's numerical intervals, factors or RPM to a different chuck.
2. **Haas Hydraulic Chuck Troubleshooting Guide TG0085**, https://www.haascnc.com/service/troubleshooting-and-how-to/troubleshooting/hydraulic-chuck-troubleshooting-guide.html . **DOC-CONFIRMED:** poor lubrication reduces force, low pressure can permit spinning/pullout, excessive pressure can heel jaws or deform parts, jaw bolts/T-nuts and correct jaw-stroke contact require inspection. Its pressure table is machine/variant-specific.
3. **Haas Programmable Pressure Adjustment Valve TG0113**, last updated 2025-10-14, https://www.haascnc.com/service/troubleshooting-and-how-to/troubleshooting/programmable-pressure-adjustment-valve-troubleshooting-guide . **DOC-CONFIRMED for the named Haas option:** increasing pressure immediately increases grip, but lowering the setpoint while already clamped does not immediately reduce gripping force; a stopped/unclamp/reclamp sequence is required. Do not generalize that behavior to all hydraulic chucks.
4. **HSE metalworking lathe emery-cloth guidance**, https://www.hse.gov.uk/engineering/lathes.htm . **DOC-CONFIRMED:** hand-held emery cloth on rotating manual or CNC lathes is unacceptable due to entanglement; alternative tool-post-mounted methods are discussed for suitable manual work.
5. **OSHA American Spincast citation**, issued 2015-04-07, pp.34–35, https://www.osha.gov/sites/default/files/citations/AmericanSpincast_999111_0407_15.pdf . **DOC-CONFIRMED allegation only:** missing/not-lowered lathe chuck guards and bypassed CNC door interlocks allowing access to rotating chucks. The citation itself warns that issuance is not a final adjudicated finding. This is an adversarial bypass example, not a fact about OpenPressBrake.

## Pinned LinuxCNC source
Revision LinuxCNC/linuxcnc@062dc7c097693bb68e76192516cd92878dd5ecdf:
- docs/src/gcode/m-code.adoc around lines 433–464: M62/M63 motion-synchronized digital outputs queue until a subsequent motion; without that motion a queued output may not change. M64/M65 request immediate outputs as received by the motion controller; HAL wiring is required. **DOC-CONFIRMED at pinned source-tree revision.**
- src/emc/rs274ngc/interp_convert.cc around lines 4055–4088: convert_m dispatches M62/M63 via SET_MOTION_OUTPUT_BIT / CLEAR_MOTION_OUTPUT_BIT and M64/M65 via SET_AUX_OUTPUT_BIT / CLEAR_AUX_OUTPUT_BIT. **SOURCE-CONFIRMED request path.**
- src/emc/task/emctaskmain.cc around lines 2107–2108 dispatches EMC_SPINDLE_ON_TYPE to emcSpindleOn. **SOURCE-CONFIRMED ordinary spindle command only.**
Source links: https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/docs/src/gcode/m-code.adoc ; https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/rs274ngc/interp_convert.cc ; https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/task/emctaskmain.cc .
No selected lathe HAL wiring, chuck actuator or safety controller was inspected. Normal request dispatch is NOT personnel-safety authority.

## Distinct propositions and adversarial failures (INFERENCE)
| Signal | What it can establish | What it cannot establish |
|---|---|---|
| M64/HAL output true | normal command request | actual valve motion or workpiece retention |
| Pressure at a sensor port | pressure at that point | grip at the jaw, contact/friction, dynamic force |
| Piston stroke sensor | sensed travel region | workpiece present, correct grip force or bolt integrity |
| Static force test | force at specified test configuration | adequate force after heavy jaws, overspeed or wear |
| Spindle command zero | requested stop | actual standstill or physical access safety |
| Door closed switch | sensed guard position | ejection containment resistance or no trapped person |

F1: long/heavy jaw + speed rise reduces outside-in grip despite pressure OK. F2: lubrication loss lowers force while pressure remains normal. F3: damaged T-nut/bolt or collision damage defeats retention with a normal stroke signal. F4: changed pressure setpoint and actual grip diverge on the documented Haas option. F5: M62 queued with no next motion never changes output. F6: defeated guard permits entanglement/ejection exposure. These are **INFERENCE failure models, NOT TEST-CONFIRMED**.

## Unknowns / stop rule
Selected chuck and jaw variants, workpiece, actual force/RPM envelope, jaw fastening, hydraulic energy zones, enclosure resistance, safe speed/stop, PL/SIL, physical validation and external evaluation are UNKNOWN. No source supports a universal pressure, speed, stop distance or retention criterion. Do not operate an unverified machine with personnel exposed; experimental operation requires qualified isolated/remote exclusion and residual-risk review. No lab justified before selected-machine evidence exists.
