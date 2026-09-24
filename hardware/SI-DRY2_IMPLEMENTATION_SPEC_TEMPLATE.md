# SI-DRY2 — Dual Dry-Contact Safety Input Implementation Spec Template

Status: reusable curriculum engineering template; not a certified machine design.

Use this template for a concrete `SI-DRY2` instance only after the selected protective device and safety input/controller architecture are known. Do not fill unknown electrical values with generic 24 V conventions.

## 1. Traceability and authority

- Instance ID:
- Protected hazardous event / `SRS-*`:
- Observed interface proposition / `PHY-*`:
- Safety-decision owner / `AUTH-*`:
- Architecture role / `ARC-*`:
- Dependencies / `DEP-*`:
- Validation cases / `VAL-*`:
- Applicable change record / `CHG-*`:
- Current UNKNOWNs:

**Authority freeze:** this block establishes only the state/health of the selected dry-contact interface. `INPUT CHANNELS HEALTHY != PHYSICAL SAFE STATE PROVED`.

## 2. Selected-device evidence

Record exact manufacturer, part number, manual revision/date and evidence classification for both the field device and receiving safety input/controller.

| Item | Selected product / evidence | Required fact | Status |
|---|---|---|---|
| Protective device |  | contact topology, switching behavior, environmental limits | UNKNOWN |
| Safety input/controller |  | input mode, ON/OFF thresholds, input current, filtering | UNKNOWN |
| Test outputs, if used |  | pulse behavior, source assignment, load limits | UNKNOWN |
| Cable/connector |  | conductor allocation, shielding/environment assumptions | UNKNOWN |

## 3. Channel topology

Document Channel A and Channel B end to end: source/test output -> contact(s) -> field cable -> connector/protection/filter -> safety input. State whether contacts are mechanically linked and whether the device manufacturer permits the chosen topology.

- Channel A source/input:
- Channel B source/input:
- Common 0 V/reference:
- Shared connector/cable bundle:
- Shared protection/filter parts:
- Field shorts considered: A-B, A-24 V, B-24 V, A-0 V, B-0 V, conductor open.

**Freeze:** `DUAL DRY CONTACT != CROSS-SHORT DETECTION`.

## 4. Diagnostic mechanism and credit

Choose exactly one declared discrepancy owner and state what diagnostics are actually supported by product evidence.

- Discrepancy evaluation owner: INPUT HARDWARE / SAFETY LOGIC / OTHER / UNKNOWN
- Discrepancy time: product/application value or UNKNOWN
- Fault latch owner:
- Reset owner and reset prerequisites:
- Cross-short detection claimed? YES / NO / UNKNOWN
- If YES, evidence and exact mechanism:
- Test-source assignment per channel:
- Shared-source limitation:

Do not credit a channel-to-channel short as detectable unless the selected source/input topology explicitly supports it. Two channels assigned to a common test source may share a diagnostic dependency.

## 5. Power/reset/fault behavior

For each condition record the qualified result, diagnostic indication, reset/rearm consequence and evidence.

| Condition | Required analysis |
|---|---|
| field-device supply loss | non-permissive behavior or UNKNOWN |
| safety-input supply loss | non-permissive behavior or UNKNOWN |
| Channel A open | detection/reaction |
| Channel B open | detection/reaction |
| A-B short | detection coverage or explicit non-coverage |
| short to +24 V | detection/reaction |
| short to 0 V | detection/reaction |
| controller reset/startup | default state and qualification sequence |
| power restoration | no automatic hazardous restart; rearm requirements |
| diagnostic/test-output failure | reaction and fault ownership |

## 6. Dependency / CCF declaration

List common 24 V/0 V, fuses/protection, connector bodies, cable routes, test-pulse sources, filters, input ASIC/resources, environmental exposure and maintenance actions that can affect both channels. A shared dependency remains a `DEP-*`; visual duplication does not establish independence.

## 7. Human factors / service

- Keyed/polarized connection where practical:
- Labels distinguish A/B and source/return:
- Safe diagnostic test points:
- Replacement verification procedure:
- Temporary jumper policy: not a normal troubleshooting method.
- Guard/device restoration check:

## 8. Validation matrix

At minimum validate normal demand/restoration, each single-channel open, relevant shorts, test-source failure where used, supply loss/restoration, reset behavior, discrepancy behavior, connector/service errors and any claimed cross-short diagnostic. Record the **physical/electrical witness actually observed**; a software status bit proves only the status path.

## 9. Schematic-freeze decision

Schematic capture is blocked until selected-device electrical limits, topology, diagnostic credit, discrepancy ownership, dependency/CCF inventory, reset behavior and validation plan are supported or explicitly marked UNKNOWN with a reason they cannot affect the intended credit. Passing this template does not validate the machine safety function.