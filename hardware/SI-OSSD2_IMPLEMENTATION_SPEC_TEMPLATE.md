# SI-OSSD2 — Dual OSSD Safety Input Implementation Spec Template

Status: reusable curriculum engineering template; not a certified machine design.

Use only for a selected self-monitoring OSSD protective device paired with a selected receiving safety input/controller. `SI-OSSD2` is not `SI-DRY2` with a different connector.

## 1. Traceability and authority

- Instance ID:
- `SRS-*`:
- Observed `PHY-*` interface proposition:
- `AUTH-*` safety-decision owner:
- `ARC-*`:
- `DEP-*`:
- `VAL-*`:
- `CHG-*`:
- UNKNOWN register entries:

**Authority freeze:** OSSD state/health does not prove final-element actuation, standstill, pressure removal, gravity restraint or empty safeguarded space.

## 2. Exact device-pair evidence

Record manufacturer, part number, firmware/configuration where relevant, manual revision/date and evidence classification.

| Compatibility item | OSSD device value/evidence | Receiver value/evidence | Compatible? |
|---|---|---|---|
| supply range/reference |  |  | UNKNOWN |
| OSSD ON voltage/current behavior |  |  | UNKNOWN |
| OSSD OFF/residual/leakage behavior |  |  | UNKNOWN |
| receiver ON/OFF thresholds | n/a |  | UNKNOWN |
| receiver input current/loading |  |  | UNKNOWN |
| OSSD diagnostic pulse width/period |  | tolerated/filter behavior | UNKNOWN |
| cable capacitance/length/loading |  | receiver limit | UNKNOWN |
| fault/restart behavior |  |  | UNKNOWN |

Do not copy values from a different OSSD product family merely because both use nominal 24 V PNP signaling.

## 3. Diagnostic pulse semantics

- Does the selected device deliberately pulse OSSD1/OSSD2 OFF for diagnostics? YES / NO / UNKNOWN
- Exact documented pulse behavior:
- Receiver mode/filter explicitly qualified for it:
- Maximum tolerated pulse/filter assumption:
- Cable/load conditions under which compatibility applies:
- Evidence:

**Conditional freeze:** `OSSD TEST PULSE != PROTECTIVE-DEVICE DEMAND` only when the selected device defines the pulse as diagnostic and the selected receiver is qualified/configured to tolerate it. Otherwise the behavior remains UNKNOWN and cannot be filtered by assumption.

## 4. Pair/discrepancy ownership

- OSSD internal self-monitoring functions credited:
- Receiver diagnostics credited:
- Pair/discrepancy evaluation owner: INPUT HARDWARE / SAFETY LOGIC / OTHER / UNKNOWN
- Permitted discrepancy time: documented value or UNKNOWN
- Fault latch owner:
- Reset/restart owner:
- Are duplicate discrepancy mechanisms intentionally configured? If yes, justify visibility and fault semantics.

## 5. Wiring and dependency topology

Trace OSSD1 and OSSD2 from sensor to receiver, including supply/reference, cable, connector, surge/EMC parts and receiver resources.

Explicitly analyze:
- common protective-device supply and 0 V/reference;
- receiver supply/reference;
- shared fuse/protection/filter parts;
- shorts OSSD1-OSSD2, to +24 V and to 0 V;
- conductor opens;
- cable capacitance/loading and common cable damage;
- supply/reference offsets that can invalidate thresholds;
- connector pin swaps/miswiring;
- environmental/EMC dependencies.

## 6. Power/reset/fault behavior

For device supply loss, receiver supply loss, OSSD1/2 faults, field demand, diagnostic pulse, cross-short, open conductor, receiver reset, sensor reset, power restoration and communications recovery, record qualified result, fault state, reset/rearm requirement and evidence.

Restoration SHALL NOT itself initiate hazardous motion.

## 7. Human factors / replacement

Replacement must require confirmation that the new sensor's OSSD electrical/test-pulse behavior remains compatible with the receiver configuration. Treat substitution with a superficially similar 24 V PNP sensor as a `CHG-*` event requiring stale-evidence review.

Provide keyed/polarized connectors where practical, clear OSSD1/OSSD2 labels, non-defeating diagnostic access, and a restoration test that is easier than bypassing the device.

## 8. Validation matrix

At minimum validate protective-field demand/restoration, each OSSD conductor open, relevant shorts, device/receiver supply loss and restoration, documented diagnostic pulses, discrepancy behavior, reset/restart, cable/load edge conditions relevant to the selected pair, and replacement/configuration restoration. Validation records must identify the actual electrical or physical witness used.

## 9. Schematic-freeze decision

Do not freeze a schematic until the exact OSSD/receiver pair has a completed compatibility table, pulse/filter semantics, discrepancy ownership, dependency/CCF inventory, reset behavior and validation plan. Universal OSSD thresholds, leakage values, pulse timing or filtering are prohibited.