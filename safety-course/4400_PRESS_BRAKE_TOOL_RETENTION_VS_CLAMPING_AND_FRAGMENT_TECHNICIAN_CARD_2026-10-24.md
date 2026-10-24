# 4400 — Tool retention, clamping and die-fragment safety: technician card

**Status:** learner-facing documentary exercise; `TR-01..12 PAPER ONLY`, no machine test, no blind score, no safety release. Read [the original WILA/Mate/AMADA source audit](../research/4400_PRESS_BRAKE_TOOL_RETENTION_MAGLOCK_SAFETY_CLICK_AND_CLAMP_AUTHORITY_2026-10-24.md) first.

## Distinct propositions

`Temporary upper-tool anti-drop` **is not** `bending-force clamp` **is not** `die-fragment protection` **is not** `ram load holding` **is not** `maintenance energy isolation`.

- WILA original documentation says its **Safety-Click** vertical top-tool loading feature is suitable for tools **up to 12.5 kg** in that product context; the holder still has its own clamping system.
- Mate's original **Maglock** 2017 statement explicitly requires the holder clamp to be engaged after magnetic seating; it does not replace the clamp.
- AMADA's **fly-off prevention dies** address fracture fragment risk, a separate failure class.

## Twelve paper scenarios

| ID | Given | Required decision and evidence |
|---|---|---|
| TR-01 | Mate Maglock punch magnetically sticks to the holder; clamp not engaged. | Is bending authorized? Identify exact OEM statement and the missing bending clamp witness. |
| TR-02 | Operator hears a WILA Safety-Click; holder clamp indicator is OFF. | Separate anti-drop from process clamping; do not treat a click as clamp proof. |
| TR-03 | Tool mass is above WILA's stated 12.5 kg Safety-Click suitability. | Refuse to extrapolate; identify alternate OEM-approved handling/retention and selected model. |
| TR-04 | 12.5 kg WILA figure is copied to a Mate Maglock-equipped punch. | Identify the wrong-manufacturer transfer and return the Mate limit to UNKNOWN. |
| TR-05 | A lower die cracks and ejects a fragment; top punch is retained. | Which hazard remains despite perfect upper anti-drop retention? |
| TR-06 | Upper tool remains attached while the entire press ram moves downward unexpectedly. | Why does upper-tool retention not prove gravity ram support? |
| TR-07 | A magnetic punch remains seated after pump shutdown. | Which independent clamp, ram support and trapped-pressure checks remain for maintenance? |
| TR-08 | Tool-holder adapter is replaced with a different brand but same nominal tang dimension. | Which exact compatibility and change-control evidence becomes STALE? |
| TR-09 | Safety-Click mechanism is damaged, but CNC reports TOOL PRESENT. | Why is normal software status not physical anti-drop proof? |
| TR-10 | Operator removes a guard to reach a difficult tool segment. | Redesign handling/support and guard access to make correct installation easier than bypass. |
| TR-11 | Hydraulic clamp status is healthy; tool shoulder is misseated. | What independent physical witness is missing and how should restart be blocked pending qualified review? |
| TR-12 | Tool change is required and the ram is raised; no mechanical support or energy-zone drawing exists. | State minimum no-exposure/isolated-service threshold and reject an improvised unclamp/drop test. |

## Empty evidence matrix

| Case | `HAZ/ENE` | `SF/PHY` | Actual selected tool/holder | `AUTH/DEP` | Missing witness | Status |
|---|---|---|---|---|---|---|
| TR-__ | | | UNKNOWN | | | HOLD / NOT RUN |

## Reviewer checks

A competent answer (1) cites exact WILA/Mate/AMADA source scope, (2) refuses a universal 12.5 kg limit or an unverified magnetic clamp claim, (3) distinguishes temporary retention, bending clamp, die-fragment containment, ram hold and servicing isolation, (4) designs easy-to-use mechanical/ergonomic support, and (5) leaves selected `IN-04f`, `PHY/VAL/PT`, actual tool condition and release state **UNKNOWN/NOT RUN**. No numerical PL/SIL, clamp force or safe tool mass is invented.

**No personnel-exposed hazardous operation** when the minimum safety proposition is unverified. Any experimental physical work needs qualified isolated/remote planning, people outside danger zones and explicit residual risk; this card prescribes no energized or destructive test. External competency evaluation remains independent and unscored.
