# 4400 — GuardLink 432ES first-event, channel-quality and historical-fault semantics

**Status:** DOC-CONFIRMED manufacturer documentation, **not** selected firmware runtime or machine validation. Studied 2026-10-23. This narrow source note complements (does not replace) the staged comprehensive HMI diagnostic contract.

## Source trace

1. Rockwell **432ES-UM001E-EN-P**, June 2025, Chapter 6 Table 6 p.64: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf . Manufacturer-indexed Table 6 text was inspected; full 22 MB PDF was too large for the web reader. **DOC-CONFIRMED for indexed text with extraction limitation**.
2. Rockwell **DEVICE-RM500G-EN-P**, September 2025, Chapter 19 p.339: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/device-rm500_-en-p.pdf . Manufacturer-indexed text explicitly distinguishes active versus historical rows of the example 432ES fault faceplate. **DOC-CONFIRMED for that library's displayed behavior**.
3. Separate product-family comparator: Rockwell **440R-UM009E-EN-P**, February 2026, p.75: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um009_-en-p.pdf . The 440R-ENETR is not safety-rated. **Do not transfer this classification to the 432ES CIP Safety interface.**

## Exact manufacturer semantics and failure consequences

| 432ES tag or UI row | Narrow source-confirmed meaning | Invalid shortcut |
|---|---|---|
| `Ch0.Status` | Table 6 calls this the channel's SIL3/PLe safety bit, 0=safe channel state, 1=operational | Concluding that the ram is physically held or the safeguarded space is empty |
| `Ch0.Fault` | Roll-up detected channel fault; disabled channel can set Fault=1 | Concluding that `Fault=0` proves all device wiring and mechanics sound |
| `Ch0.Uncertain` | Channel data validity questionable when 1 | Reusing last green value as current |
| `Ch0.DeviceTripAddress` | First cause of last operational→safe transition; subsequent device trips do not replace the first address | Displaying it as the only guard currently open |
| `Ch0.DeviceTripAddress=-2` | Unknown cause, including open link/unresponsive node examples | Naming a particular gate from -2 |
| `Ch0.DeviceTripAddress=-3` | Unlock-command-related transition for documented configuration/firmware | Claiming physical unlocking/clear access |
| `Ch0.TerminatorFault` | Faulted terminator, explicitly not a missing-terminator detector | `TerminatorFault=0` proves a terminator installed |
| `Ch0.TooManyDevices` | Can set on missing terminator or broken link as well as count conditions | Treating it as literal >32 nodes only |
| `Ch0.UnverifiedDevice` | Verification problem; missing terminator and selected broken-link cases can set it | Clearing it proves device-to-guard physical mapping |
| `Ch0.TripTimestamp` | Last operational→safe transition, for multiple causes | Time the machine physically stopped |
| Library fault table row 1 | Shows active fault when one exists, otherwise most recent historical fault | Every first-row fault is currently active |
| Library rows 2–4 | Historical faults/warnings, not currently active | Displaying four rows as four simultaneous live failures |

**Key distinction:** `Ch0.Status` is a manufacturer-described safety bit in the documented **432ES** arrangement, but the ordinary LinuxCNC/HMI display of this value is not a safety-certified controller. A legitimate selected CIP Safety design must be evaluated independently; downstream safety output and physical final-element response remain separate propositions.

## Adversarial diagnostic timeline (INFERENCE, not TEST-CONFIRMED)

At t0, gate B trips first; `DeviceTripAddress` captures B. At t1, gate A opens while the channel is already safe; the address remains B. At t2, communication quality becomes uncertain; the HMI retains B's green/healthy gate-icon cache. A technician sees only B highlighted and closes it, then requests reset. **The UI cannot infer that A is closed, current diagnostics are valid, physical hazards stopped or rearm is eligible.** Present `FIRST EVENT: B`, `CURRENT DEVICE STATE: UNKNOWN`, `DATA QUALITY: UNCERTAIN`, and independent safety-controller/rearm status separately. This is a proposed human-factors diagnostic contract, not a new safety logic design.

## Technician proof obligations

Record exact catalog, firmware, AOP and selected safety-controller program; raw tags and timestamps with quality/freshness; guard-to-node and node-to-zone mapping; disabled channel states; event versus live-state fields; and observed physical final-element/ram/guard responses. A topology or firmware change marks dependent `SRS/PHY/AUTH/DEP/ARC/VAL/PT` evidence STALE. Do not manufacture a live fault by bypassing a safeguard. If a causal proof cannot be done without exposing people, mark it BLOCKED and keep hazardous operation isolated/remote.

**UNKNOWN / NOT RUN:** selected firmware, actual CIP Safety program, physical channel map, current device state implementation, stopping time/distance, hydraulic load holding, pressure zones, occupancy and reset/restart behavior. No numeric PL/SIL is assigned to a machine from these catalog statements; external 2520–25F0 blind competency gates remain open. No laboratory simulation or physical test was justified.
