# PENDANT-01 — Detachable tethered HMI E-stop, bridge/Plus/Basic and false availability

Status: original manufacturer-document audit; **NON-GRADUATED**; 2026-10-26. No selected OpenPressBrake pendant known.

## Frozen question and novelty
When a detachable wired operator panel is removed, does its E-stop remain a protective stop input, disappear from the circuit, or automatically restore the circuit? Could an unplugged panel with a red E-stop be left within reach and falsely trusted? This differs from existing RAD-01 wireless-link and RAD-02 general-purpose tablet/cableless control research. Full learner-index and research-directory filename checks found the IEC 62745/FME mobile-device scope note, but no original Siemens **Basic/Plus** or Rockwell **bridge connector** comparison.

## Original manufacturer evidence
1. **Siemens SIMATIC Mobile Panel 170 Equipment Manual**, Release 09/02, order 6AV6591-1DC30-0AB0, §4.4.1–4.4.2, printed pp.4-5–4-6. Original PDF directly inspected: https://cache.industry.siemens.com/dl/files/223/13506223/att_108909/v1/mobile_panel_170_ghb_e.pdf . The **Connectivity Box Plus** closes the STOP/E-stop loop on unplug, including if the pendant STOP was previously pressed; the manufacturer expressly warns that unplugging can release the stop status. The **Connectivity Box Basic** does not loop around the unplugged panel: disconnection opens the stop circuit and initiates a stop. These are **product/connection-box-specific** behaviors, not universal safe/un-safe judgments.
2. **Rockwell MobileView Tethered Operator Terminal Bridge Connector Installation Instructions**, publication 2711T-IN001, original two-page PDF directly inspected: https://literature.rockwellautomation.com/idc/groups/literature/documents/in/2711t-in001_-en-p.pdf . It states the 2711T-JUMP and 2711T-22JUMP are intentional bridge accessories for using a machine without the tethered terminal, **not E-stop devices**, and explicitly requires another E-stop to be present before using the bridge. Manufacturer lists connector-generation/box compatibility; **not** an authorization to improvise a bypass.
3. **Rockwell MobileView Guard G750 User Manual**, 2727-UM002D-EN-P, printed p.2-8 and p.2-10, directly inspected: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/2727-um002_-en-p.pdf . It warns that a pendant whose E-stop is not in the circuit must be stored away from operators, who may instinctively press the nearest red E-stop; after a drop, the E-stop and enabling switches must be tested before operation. Its internal software System Check utility cannot test the E-stop/enabling switches (p.4-? / indexed around PDF p.53).
4. **Rockwell 2711T-22JUMP current product catalog**, https://www.rockwellautomation.com/en-us/products/details.2711T-22JUMP.html , lists bridge purpose and June 1, 2026 discontinuation/replacement. Exact replacement part and instructions require fresh review; do not equate generational pinouts.

## Critical distinction
| Hardware arrangement | What the OEM says happens to stop loop on unplug | What remains UNKNOWN |
|---|---|---|
| Siemens Mobile Panel 170 + **Basic** box | Opens stop loop and commands stop | Physical stop/hold, load restraint, fresh rearm |
| Siemens Mobile Panel 170 + **Plus** box | Automatically closes loop; prior pressed STOP state may be released | Machine-level restart inhibit, stop/hold and occupancy |
| Rockwell MobileView + specified **bridge accessory** | Permits operation without MobileView pendant E-stop; OEM requires another E-stop | Selected machine alternative E-stop coverage, guarding and fresh restart |
| Disconnected panel still lying in operator reach | Rockwell warns of dangerous false reliance on inactive nearest E-stop | Whether a selected machine has this layout |

## Failure path and practical human factors
- **DOC-CONFIRMED:** A visible red button can be electrically absent from the active stop circuit, depending on the selected pendant/connector. A deliberately provided OEM bridge is a system configuration, not a substitute E-stop.
- **INFERENCE:** A worker may press the nearest disconnected pendant and receive no protective response; unplugging after an E-stop demand may clear that demand on a Siemens Plus installation unless machine-level independent stop/restart interlocks preserve safety. Do not infer automatic hazardous motion merely from loop closure.
- **Practical design:** keep independent fixed E-stops reachable at all legitimate operator positions; use dedicated clearly marked pendant storage outside operating reach when disconnected; make the active control station and E-stop availability unambiguous; prefer keyed/managed connector and qualified changeover design rather than a loose dummy connector; prevent unplug/replug/bridge from creating a fresh start. Provide simple safe station handoff so users do not improvise connections.
- **No unsafe procedure:** this audit intentionally does not describe connector pinouts, wiring bridges, bypass steps, or energized fault injection.

## Source/claim ledger
**DOC-CONFIRMED:** Siemens 09/02 Basic/Plus unplug distinctions and stop-state release warning; Rockwell 2711T-IN001 bridge-purpose/other-E-stop requirement; Rockwell G750 storage/drop-test warning. **INFERENCE:** cross-system false-availability and rearm hazard. **SOURCE-CONFIRMED LinuxCNC:** none new. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **UNKNOWN:** actual OpenPressBrake pendant, wiring, E-stop coverage, machine physical stop/hold, PL/SIL, tests and independent evaluator.

## Selected-machine gate
G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Require private exact product/box/bridge records, qualified field layout and physically validated independent Y1/Y2 stop/hold, hydraulic isolation, guards, restart. No people-exposed operation or live bridge test.
