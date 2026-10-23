# 4400 — GuardLink diagnostic event epochs, freshness and the release-authority boundary

**Session:** 2026-10-23T12:39:59Z onward. **Status:** source/documentation-backed architecture study, no selected-machine validation. **Course:** 4400 safety implementation, dependent on 2520/2530/2590/25F0; external evaluations OPEN. This note does not supersede the three still-staged original GuardLink/HMI source audits in the 85-file publication archive.

## Question

Can an ordinary LinuxCNC HMI show a meaningful "which guard tripped" diagnostic while refusing to misrepresent a historical event, stale network state, or device reset as permission to restart? **Yes, as a diagnostic interface design (INFERENCE), provided the selected product/firmware semantics are preserved and the independent safety system remains the sole personnel-safety authority.** This is not a claim that the interface has been implemented or validated.

## Manufacturer evidence and conflicts

- **DOC-CONFIRMED:** Rockwell *Guardmaster EtherNet/IP Network Interface*, **440R-UM009E-EN-P**, February 2026, pp. 39, 43–44, 62–65, 75, defines ENETR Series B command/tag families and states the ENETR interface is **not safety-rated**. Official: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um009_-en-p.pdf .
- **DOC-CONFIRMED:** Rockwell *GuardLink Systems Application Technique*, **GLINK-AT001A-EN-P**, July 2023, pp. 3–9, distinguishes the 432ES-IG3 **CIP Safety** architecture from DG safety relay plus ENETR ordinary EtherNet/IP diagnostics. It also describes different OSSD/EMSS tap input testing, node/link states, and topology-change requirements. Official: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/glink-at001_-en-p.pdf .
- **DOC-CONFIRMED, separately scoped:** Rockwell **432ES-UM001E-EN-P**, June 2025, Ch. 6 Table 6, documents a **first-event** `DeviceTripAddress` rather than a complete live list of all open guards. Official: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf . A 432ES channel's safety-related status bit must **not** be casually reclassified as ENETR's non-safety data.
- **UNKNOWN:** the selected firmware/AOP, installed node-to-guard mapping, full validity/quality and event-epoch semantics. The February 2026 ENETR manual has conflicting reset-duration units and an internally inconsistent `DeviceFault=6` node example; neither ambiguity may be silently repaired. See existing `4400_ENETR_RESET_UNITS_AND_DIAGNOSTIC_XOR_CONFLICT_2026-10-23.md`.

## Four-layer architecture contract

| Layer | Owns | Can establish | Cannot establish |
|---|---|---|---|
| Normal LinuxCNC / FPGA | Normal motion command, UI and fault reporting | A request, local software state, display update | Personnel-safety stop, rearm, occupied-space clearance |
| Diagnostic transport/HMI | Tagged source/firmware, raw value, freshness, first-event history | Narrow reported device/event proposition if quality is valid | Physical machine stopped; a first-event address means all other guards closed |
| Independent safety-related control | Qualified protective demand, safety outputs, monitored reset and selected safety communication | Defined safety-related logic/output response, subject to application validation | That every final element actually acted or a gravity load is held merely from a status bit |
| Physical final elements / isolation | Actual energy removal, holding, restraint and service isolation | Machine safe-state propositions only when independently verified | Universal absence of residual energy from one gauge or switch |

**Design invariant (INFERENCE):** a diagnostic display is allowed to make the operator *less confident* on loss of evidence, never *more confident*. `UNKNOWN/STALE` must not become `OK` through default-zero bitmasks, retained event rows, network reconnection or power cycling.

## Minimal ordinary-HMI record contract (proposed, not a safety protocol)

```text
device_product, catalog, firmware, aop_or_config_id
channel, physical_guard_zone_id, mapping_revision
tag_name, raw_value, decoded_value, decode_rule_revision
event_epoch_id, observation_time_utc, source_time_if_known
quality_valid, age_or_freshness_basis, current_vs_historical
source_active, safety_output_reported, physical_witness_reference
unknown_reason, last_change_id
```

**Why event epochs?** A first-trip address can remain fixed while additional doors open. A power cycle, reset command, replaced tap, firmware change or reconfigured node map can change the meaning of subsequent records. Preserve the raw history and start a new diagnostic epoch at the boundary; never present an old row as current. This epoch rule is an **INFERENCE** for ordinary HMI auditability, not a manufacturer-required safety control.

## Adversarial causal cases and expected disposition

1. **Guard B opens, then Guard A:** first-event address still B. HMI must say "first reported trip B"; it cannot say "only B open." Selected live per-device data, if available, is separate.
2. **`Active=0` and ENETR tag fields zero:** the manufacturer describes zeroing of other GuardLink fields. A zero word is **UNKNOWN/inactive**, not "all guards good."
3. **DeviceFault numeric example conflicts with bit order:** retain raw DINT and flag `UNVERIFIED NODE MAP`; do not assign a physical guard label by an assumed bit order.
4. **Tap fault reset/power cycle followed by operational link:** this may recover communications; it does not prove guard mounting, correct physical zone, final-element stop/hold, or a fresh human start request.
5. **Safety output OFF while physical beam drifts:** physical contradiction defeats a proposed safe-state conclusion. Withhold personnel exposure and rearm; investigate under an isolated/remote plan.
6. **Identical replacement relay in wrong physical slot:** successful electronic type/keying cannot by itself prove machine-zone mapping. Require `CHG` and revalidation of downstream evidence.

## Traceability / human factors

Create `BND/HAZ/ENE` for each guard and exposed person, `SF/PHY/SRS` for independent stop/hold/access/restart, `AUTH` for selected safety controller versus LinuxCNC, `DEP` for network/firmware/zone mapping, `HF` for nuisance-trip bypass pressure, `CHG` for device replacement, and `VAL/PT` for **independent** physical causal proof. All selected-machine `VAL/PT` are **NOT RUN**. Present a clear per-guard fault path and accessible repair instructions rather than one reassuring green light or an indiscriminate "Reset All" button.

**Lab decision:** no simulation is justified for source-defined tag semantics or simple bit arithmetic. If selected firmware ambiguity actually blocks integration and manufacturer clarification is insufficient, freeze a **bench-only**, bounded raw-tag observation with firmware/AOP identity and no personnel hazard. Only `[self-hosted, openpressbrake]` is permitted for justified compute. No GitHub-hosted runner.

**Restriction:** documentary source evidence cannot authorize operation with people exposed. Unproved minimum protection requires isolated/remote experimentation with people outside the danger zone and explicit residual-risk controls.
