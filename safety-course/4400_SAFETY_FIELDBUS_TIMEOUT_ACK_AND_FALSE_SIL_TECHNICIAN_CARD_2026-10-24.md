# 4400 technician card — Safety fieldbus timeout, acknowledgment and misleading SIL label

**Status:** open-book paper practice, not a hidden assessment, simulation, machine test or selected safety design. Read [Rockwell Logix SIS versus Beckhoff TwinSAFE original-source audit](../research/4400_CIP_SAFETY_CRTL_VS_FSOE_WATCHDOG_ACK_AND_SIL_UI_TRAP_SOURCE_AUDIT_2026-10-24.md).

## Three distinct propositions

1. **Safety communication health:** the configured CIP Safety/FSoE connection receives valid, correctly identified, timely safety data.
2. **Electrical safety output:** the selected qualified output/receiver is in the manufacturer's defined OFF/safe state when a fault is detected.
3. **Machine physical safety:** the actual hazardous motion stops, gravity load stays restrained, occupied areas are protected and stored energy is controlled.

A status screen proving (1) cannot establish (2) or (3). A controller reporting (2) still cannot prove (3).

## Ten source-grounded hypothetical cases

| Case | Technician observes | Required discriminator |
|---|---|---|
| **FB-01** | GuardLogix Logix SIS input RPI 10 ms and defaults; someone calls its 40 ms CRTL the press stopping time. | Rockwell **connection packet-age limit** versus full sensor/controller/output/actuator/physical stopping path. |
| **FB-02** | Ethernet traffic causes nuisance connection faults; operator doubles CRTL. | Manufacturer requires changed **system reaction-time** assessment; no blind nuisance-trip tuning. |
| **FB-03** | Safety network disconnected; normal LinuxCNC Ethernet link still green. | Separate safety connection age/identity/validity from ordinary network connectivity. |
| **FB-04** | Safety data OFF after timeout, hydraulic ram remains elevated. | OFF data does not establish gravity holding, safe access or maintenance isolation. |
| **FB-05** | TwinSAFE project uses two logic terminals with a repeated FSoE address; local verifier is green. | Beckhoff says per-terminal verifier checks only one; owner must ensure **system-wide uniqueness**. |
| **FB-06** | EL6910 connection communication error; group `ErrAck` pressed but connection still faulted. | Configured `ComErrAck` may be required **in addition to** group `ErrAck`. |
| **FB-07** | Technician sets 'SIL 3' in TwinCAT 2 field and declares the machine SIL 3. | Beckhoff's **unsupported SIL selection has no safety behavior effect** in cited edition. |
| **FB-08** | Network recovers, safety group RUN, ordinary LinuxCNC retains a prior cycle command. | Deliberate local safety reset/rearm and separate fresh start; invalidate stale ordinary commands. |
| **FB-09** | Controller task period/watchdog changes after an update. | Logix SIS OEM formula and system timing review, exact controller/edition required; no copied numbers. |
| **FB-10** | Someone proposes unplugging the live safety network on a press brake with an operator at the tool to 'prove' safe state. | Reject personnel-exposed live fault injection; only separately authorized isolated/remote qualified validation after full intake. |

For each case record: source/edition, `DOC-CONFIRMED` narrow statement, `INFERENCE` failure mechanism, `UNKNOWN` selected-machine facts, physical `PHY` witness, human-factors improvement, and **HOLD/GO** decision. A complete paper response cannot produce a GO for the selected machine without actual physical validation.

## Blank safety connection contract

| Field | Selected value |
|---|---|
| Exact safety PLC, firmware, original OEM manual revision and configuration checksum | UNKNOWN |
| Protocol (CIP Safety/FSoE/other/none) and connection owner | UNKNOWN |
| Safety identity/address and cross-project uniqueness | UNKNOWN |
| RPI, timeout multipliers/CRTL or FSoE watchdog and fault response | UNKNOWN |
| Connection/group error and acknowledgment path | UNKNOWN |
| Qualified safety output, receiver and independent physical final element | UNKNOWN |
| Independent stop/hold/occupancy/energy/restart evidence IDs | NOT RUN |
| Change owner, reviewed timeout/EMC changes and operator recovery workflow | UNKNOWN |

## Practical design and assessment

Use clear labelled addresses, a single version-controlled safety-network contract, protected wiring, a readable fault screen that differentiates **communication fault / ack pending / physical proof unknown**, and a separate local intentional restart. The easy fix for nuisance trips must be fixing the source of loss, not bypassing protection.

This card is **learner-visible practice**, not a fresh-AI blind score. The source manuals are Rockwell Logix SIS 1756-RM015C-EN-P December 2025 and Beckhoff TwinSAFE Logic FB v4.3.0 2025-12-03. Neither is claimed installed on OpenPressBrake. No numeric machine stop time, PL/SIL, hydraulic truth table, safety release, physical fault injection or compute is claimed.
