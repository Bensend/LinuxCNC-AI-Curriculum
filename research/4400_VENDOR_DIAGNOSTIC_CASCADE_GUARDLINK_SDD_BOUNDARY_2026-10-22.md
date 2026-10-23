# 4400 — Concrete diagnostic-cascade options: Rockwell GuardLink and Pilz SDD

**Status:** manufacturer-documentary comparison only; no product selection, bench test, safety-function certification or machine release. Prepared 2026-10-22. Supplements the passive-series fault-masking note.

## Why compare these products?

A cheap multi-gate series contact loop may make it hard to tell **which** gate is open and may mask a dangerous contact fault when a different gate operates. The engineering objective is not simply to add Ethernet: it is to preserve independent safety authority and obtain useful per-device diagnostics that reduce repair time and foreseeable defeat pressure.

## Architecture A — Rockwell GuardLink

Rockwell's official GuardLink product page describes GuardLink-enabled devices and connection taps supplying contextual sensor/health diagnostics, with a separate Guardmaster safety-relay family and optional EtherNet/IP integration. Manufacturer source: https://www.rockwellautomation.com/en-us/products/hardware/safety-products/guardlink-technology.html . The official Guardmaster DG/GuardLink manual is publication **440R-UM015J-EN-P (June 2025)** at https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um015_-en-p.pdf ; the search-indexed manual excerpt describes a four-conductor chain with power, return, a dynamic safety/diagnostic conductor, and a lock/unlock conductor, with initialization, safe, operational and fault states. **Scope limitation:** the manufacturer-indexed page-13 excerpt identifies initialization checks for tap/node identity, compatible firmware, a terminator, and four logical chain states; it distinguishes the safety/diagnostic conductor in safe versus operational states. The full 38 MB manual was not downloaded/inspected page by page in this session; do not assign pin-level semantics, exact chain length, receiver timing or integrity figures without reviewing the exact selected revision.

**Teaching architecture:** device/tap diagnostics -> documented safety-relay interpretation -> selected safety output -> final element. For the described DG relay with optional 440R-ENETR, treat ordinary EtherNet/IP/HMI status as **monitoring/diagnostics** unless the selected manufacturer application establishes a separate safety-related network path. Ethernet alone grants no safety authority. Other product families can have different safety-rated network interfaces; do not generalize from one model. Confirm selected safety path and output separately. An individual tap's status cannot prove actual guard geometry, lock strength, stopped spindle, held beam, occupancy or maintenance isolation.

## Product-family trap — first-trip event is not complete gate-state history

Rockwell's **different** 432ES-IG3 GuardLink EtherNet/IP interface manual, **432ES-UM001E-EN-P (June 2025)**, describes a `DeviceTripAddress` field retaining the node responsible for the **first** operational-to-safe transition; later device trips do not change that address because they did not cause the same state transition. Manufacturer source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf (indexed Chapter 6 tag definition). The same manual identifies `Ch0.Uncertain` and `Ch0.Status`, including safety-rated channel-status semantics. **Do not conflate 432ES with 440R-ENETR** or claim all EtherNet/IP is diagnostics-only. The exact safety-related communication architecture and selected application determine authority.

**Important practical inference:** a “first device tripped” dashboard is **not** a current list of every open guard and cannot establish protected-space occupancy or complete gate-state chronology. Record additional device-state evidence when the machine requires it. This is `DOC-CONFIRMED` for the 432ES published tag behavior and `INFERENCE` for the HMI/occupancy consequence. No 432ES physical machine was tested.

## Architecture B — Pilz Safety Device Diagnostics (SDD)

Pilz's official SDD product page describes a fieldbus module, junction box and supported safety devices (such as PSENcode), remote/display diagnostics, and the possibility of series connection in the field. It describes a product-family configuration suitable for **up to 16 sensors**; that figure is **specific to the documented family/configuration**, not a universal series wiring allowance. Source: https://www.pilz.com/en-US/products/networks/device-diagnostics-system/safety-device-diagnostics . The safety device's signals and the separate diagnostics must be traced through the exact supported arrangement and receiver. Do not assume an SDD diagnostic fieldbus command can replace safety-related output removal.

## Engineering tradeoff

| Question | Passive series NC contacts | Documented diagnostic cascade |
|---|---|---|
| Can one input identify which gate is open? | Not from shared loop alone | May provide per-device diagnostics if exact selected system supports it |
| Can normal operation mask a dangerous contact fault? | Yes, under documented conditions | Must inspect device/tap/receiver diagnostic contract; not automatically the same fault model |
| What proves safe output removal? | Selected relay/controller plus final-element evidence | Selected safety logic and output path, not Ethernet diagnostics alone |
| What remains shared? | Cable, terminals, receiver, supplies | Power, chain conductor, terminator, taps, configuration and output path; identify common-cause faults |
| Is the system cheap/easy to service? | Lower initial wiring cost, potentially poor fault localization | More components but potentially faster repair; actual cost/time must be measured |
| What establishes machine PL/SIL? | Complete SRS and validated system analysis | Same complete SRS and validated system analysis; product labels are inputs, not results |

## Evidence classification

- `DOC-CONFIRMED`: Rockwell GuardLink and Pilz SDD official product descriptions; product family diagnostic capabilities as stated.
- `INFERENCE`: diagnostics can reduce fault-location time and hence foreseeable bypass incentive; must be confirmed in user workflow.
- `UNKNOWN`: exact catalog and firmware, pinout, protocol state transitions, selected receiver, power and common-cause behavior, actual PFHd/PL/SIL, chain size and device compatibility, machine physical stop/hold/occupancy/isolation proof.
- `TEST-CONFIRMED`: none. `SOURCE-CONFIRMED` for selected machine/LinuxCNC: none.

## Next selected-interface question, not a lab yet

Obtain the exact manufacturer manual and selected part numbers for one candidate chain. Trace what is **safety-related** versus **diagnostic-only**, each fault latch and reset path, and the final-element outputs. Only freeze a bounded bench experiment if a specific important ambiguity survives the manufacturer's application documentation. Never dispatch GitHub-hosted compute; if justified use only `[self-hosted, openpressbrake]`.
