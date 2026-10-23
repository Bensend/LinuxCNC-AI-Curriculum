# 4400 — HMI diagnostic semantics must not silently become safety authority

**Status:** architecture reasoning / source provenance, 2026-10-23. No selected GuardLink hardware, firmware, HMI implementation or machine test. The companion staged research on 432ES and 440R-ENETR remains unpublished; do not treat this note as an implementation specification for either product.

## Why this is a practical safety problem

The Rockwell **432ES-IG3** GuardLink EtherNet/IP manual (publication `432ES-UM001E-EN-P`, June 2025) describes `DeviceTripAddress` as a **code for the cause of the operational-to-safe transition**, including negative special-event codes and 0–31 for the documented non-locking client-device case; later device trips do not replace that first-event address. The prior staged source audit also distinguishes 432ES CIP Safety arrangements from the separate **440R-ENETR** monitoring interface, which the manufacturer explicitly calls non-safety-rated. These product families and tag contracts are not interchangeable.

- Official 432ES manual: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf (manufacturer document, Chapter 6; large PDF unavailable for complete fresh page-by-page inspection in this run; statement retained from prior staged manufacturer-source review).
- Official 440R-ENETR manufacturer product information: https://www.rockwellautomation.com/en-us/products/details.440R-ENETR.html ; manual `440R-UM009E-EN-P` February 2026, official document search/catalog. The manual states that ENETR is not a safety-rated device (prior staged direct manual review; fresh secondary index corroboration).
- **DOC-CONFIRMED with provenance caveat:** device-family roles and first-trip semantics are documentary, not selected-machine runtime facts. **UNKNOWN:** exact firmware, tag validity and timing, selected receiver/safety-program ownership, whether live per-device state is available.

## Source-traced 432ES tag semantics — publication 432ES-UM001E-EN-P (June 2025)

The official Rockwell manual's **Chapter 6, Table 6, page 64** is available in manufacturer-indexed text even though a fresh full 22 MB PDF fetch failed. These are **DOC-CONFIRMED for this manual revision**, not runtime-verified for selected firmware:

| Exact 432ES channel tag | Manufacturer-described meaning | Dangerous HMI shortcut to reject |
|---|---|---|
| `Ch0.Status` | Operational (`1`) versus channel safe state (`0`); manual identifies it as the SIL3/PLe **safety bit** | Treating `0` as proof of physically stopped/held machine, or treating `1` as occupancy clear |
| `Ch0.Fault` | Roll-up of detected channel diagnostic faults | `0` = no possible latent fault or all guards verified mechanically |
| `Ch0.Uncertain` | `1` means channel data validity is questionable | Continuing to show last green state without quality/age |
| `Ch0.DeviceTripAddress` | Code for cause of most recent operational-to-safe transition; later device trips do not replace first cause; 0–31 has the manual's non-locking-device scope | Interpreting address as the only/currently open gate |
| `Ch0.DeviceTripAddress=-2` | Unknown trip cause, e.g. open link cable or node unable to respond | Treating `-2` as a particular gate number |
| `Ch0.DeviceTripAddress=-3` | Unlock-command-related transition in the documented firmware/configuration case | Treating command event as guard physically unlocked and safe to access |
| `Ch0.TerminatorFault` | Detects a **faulted** terminator; the manual explicitly says this does **not** indicate a **missing** terminator | `TerminatorFault=0` means the end terminator is present |
| `Ch0.TooManyDevices` | Includes a missing terminator or broken link-cable diagnostic case, not only literal >32 devices | Literalizing the label as only a device-count overflow |
| `Ch0.UnverifiedDevice` | Device-keying verification issue; missing terminator and some broken-cable configurations can set it | All physical gate-to-device mapping verified if it clears |
| `Ch0.DeviceCount` | Number of devices detected, not necessarily a continuous topology-integrity witness | Stable count means no link interruption or no device replacement |
| `Ch0.TripTimestamp` | Time of last operational-to-safe transition, for multiple possible causes | Time each gate last opened or last time physical motion stopped |

**Source:** Rockwell official manual, Chapter 6 Table 6 (p. 64), https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf . Its **Chapter 5 p. 51** illustrates a broken link during node insertion: channel `Status` transitions 1→0, `Fault` and `UnverifiedDevice` set, `DeviceTripAddress=-2`, and the `DeviceCount` can temporarily remain at the prior count before dropping. This is a documented *example sequence*, not a universal response/timing specification for every firmware or fault.

A separate Rockwell **Safety Device Library** manual (`DEVICE-RM500G-EN-P`, September 2025, p. 339) explains that its 432ES fault-table **row 1** displays the active fault when present; **rows 2–4** are historical events. A multirow fault list therefore cannot be labeled "all active faults" without distinguishing current from historical. Manufacturer source: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/device-rm500_-en-p.pdf . This is a specific library HMI behavior, not a universal 432ES protocol guarantee.

**Critical product-family boundary:** unlike the non-safety-rated 440R-ENETR, the documented 432ES `Ch0.Status` is explicitly described as a safety bit. The *selected* 432ES safety-network/controller architecture must still be verified; even a safety-rated channel bit does not itself prove downstream physical final-element action, occupancy, gravity-load restraint or maintenance isolation. Do not downgrade the 432ES bit to "non-safety" simply because another GuardLink interface is diagnostics-only.

## Four distinct authority paths (conceptual, not a wiring diagram)

```text
Physical guard/actuator -> selected safety-capable device/interface
                           -> independent safety-related controller/logic
                           -> selected safety output/final element
                           -> actual hazardous-motion/energy response

Selected diagnostic/event tags ----------------------> HMI/LinuxCNC display
Ordinary LinuxCNC/FPGA control ----------------------> normal motion request
Independent physical witnesses ---------------------> validation record
```

The exact 432ES application can carry a manufacturer-described safety-rated `Ch0.Status` over its **selected** CIP Safety arrangement; ordinary diagnostic tags and the HMI are not thereby safety-rated. A normal controller stop request can be useful, but the safety demand must not depend solely on ordinary LinuxCNC, FPGA logic, a desktop application or a stale diagnostic field. A safety output state is still one step removed from actual contactor/drive/valve response and the physical safe-state proposition.

## Required semantic contract for any displayed field

| Display field concept | Scope/meaning | Must not be used to conclude |
|---|---|---|
| `FirstTripAddress` | Historical **first transition cause** in a specified event epoch/channel, when documented | All other guards closed now; no additional trips occurred; occupancy clear |
| `CurrentDeviceState` | Current *diagnostic* indication for a selected device, if actually supported and fresh | Device mechanically sound; complete safety function valid; load stopped |
| `SafetyDemandActive` | Safety-related controller's reported demand/output status, where sourced from documented safety path | Contactor opened, valve moved, load restrained, stored energy absent |
| `GuardLockMonitored` | Only the lock/guard proposition that the **exact** selected product safely monitors | Escape is mechanically possible; guard force sufficient; danger ended |
| `PhysicalHazardStopped` | Machine-specific independent physical observation/validated monitor, with acceptance criterion | Maintenance isolation or absence of all hazardous energy unless specifically proven |
| `MaintenanceIsolationVerified` | Authorized physical energy-control procedure and witnesses for the specific task | All future reaccumulation impossible without continued controls |

Every diagnostic record should identify **device/channel, source/product/firmware, event epoch, timestamp/age, validity/quality, transition cause versus live state, and stale/unknown condition**. This is an **INFERENCE / proposed ordinary-HMI data contract**, not a safety-certified communications protocol. A missing/stale field must display UNKNOWN rather than inheriting an earlier reassuring value. Ordinary LinuxCNC/FPGA/HMI logic may show diagnostics and request a stop but cannot authorize hazardous motion by interpreting these fields.

## Failure-path audit

1. Gate B trips first; Gate A opens later. The first-trip address can continue to show B. A dashboard label `Only Gate B Open` would be unsupported.
2. A device is swapped for another same-type device, or tap/relay positions are exchanged. Successful electronic identification may not prove correct **physical zone mapping**; compare wiring and device-to-guard geometry, then revalidate.
3. A stale EtherNet/IP field remains green after communication loss. Without quality/age, a human may believe protection has recovered. Display UNKNOWN/STALE, retain independent safety control.
4. A safety relay reports OFF but a gravity-loaded beam is still moving or accumulator energy remains. Controller status cannot override contradictory physical witnesses; block personnel exposure and rearm until investigated.
5. A mechanic cannot find which gate causes a nuisance trip and considers bypassing it. Better per-device fault localization, accessible service instructions and easy guard restoration are protective engineering, not merely convenience.

## Acceptance and change control

Before deploying a diagnostic HMI, demand selected-firmware tag definitions, event/state distinction, stale-data behavior, per-device identity mapping, independent safety-output architecture, and a `VAL-*` plan that deliberately creates **multiple sequential diagnostic events** without exposing personnel to hazards. Record any tag/firmware/zone-mapping change as `CHG-*`; mark dependent `ARC/VAL/PT` evidence STALE. No machine release from HMI status alone.
