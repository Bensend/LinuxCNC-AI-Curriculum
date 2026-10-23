# 4400 — ENETR reset-duration unit conflict and diagnostic-parser fail-closed review

**Scope / evidence date:** 2026-10-23. Documentary audit of Rockwell 440R-ENETR Series B manual **440R-UM009E-EN-P (February 2026)**, printed pp. 6, 39, 43–44, 62–63 and 75. Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/um/440r-um009_-en-p.pdf . Original PDF text and rendered printed pp. 39 and 44 inspected. **No selected machine, device firmware, HMI decoder or physical test.** Companion already published: `research/4400_440R_ENETR_2026_TABLE5_DIAGNOSTIC_QUALITY_GATE_2026-10-23.md`. This note addresses *additional* reset-unit and diagnostic-set ambiguity rather than replacing that audit.

## New documentation conflict R-01: seconds versus milliseconds

The same manufacturer manual prints two irreconcilable reset-duration statements:

| Location | Documented text / meaning | Evidence class |
|---|---|---|
| Printed p. 39, Table 2, `Reset1` | Network-issued relay reset is equivalent to reset-terminal pushbutton; pulse **0.25–3 seconds**; only optical link 3. | DOC-CONFIRMED |
| Printed p. 44, Table 6, diagnostic 03 | For a held reset input, recommended action prints **250–3000 seconds** (literally `s`, not `ms`). | DOC-CONFIRMED as *printed*, not accepted as correct engineering instruction |
| Printed p. 6, definitions | Monitored manual reset requires OFF–ON–OFF with reset accepted on trailing edge; automatic/manual reset differs. | DOC-CONFIRMED |

The two numbers differ by a factor of **1,000** if both unit labels are interpreted literally. The p. 44 recommendation is inconsistent with the p. 39 command range. **INFERENCE:** the p. 44 `s` may be a unit typo for milliseconds; that explanation is *not manufacturer-confirmed*. Do not implement a 250–3000-second reset, and do not silently edit the manual's printed value. Verify the selected relay's own reset specification and exact firmware/configuration, obtain manufacturer clarification if needed, and use the independently supported selected-device requirement. The 0.25–3 s `Reset1` statement does not itself authorize an HMI to perform personnel-safety rearm.

## Diagnostic-set ambiguity D-02: XOR is not necessarily a fault set

Printed p. 43, Table 5 defines `DeviceTrip` as a bitmap of operational nodes, with **0 bits for tripped nodes**. The manual's four-node examples support that narrow interpretation: all operational = 15; nodes 1 and 3 tripped = 10; only node 2 tripped = 13. The same table states `DeviceDiagnostic` identifies only one diagnostic device, then proposes `DeviceTrip XOR DeviceCount` to obtain *all devices in diagnostic mode*. That XOR instead computes bits that are **not operational relative to configured presence** under the stated `DeviceTrip` semantics. A protective trip need not be a diagnosed fault. **UNKNOWN:** whether the intended diagnostic-set statement is imprecise, conditional on a particular mode, or product/firmware specific. It cannot be used as a universal all-faults decoder without selected-firmware evidence.

A second Table 5 contradiction was previously recorded: `DeviceFault=6` is labeled as nodes 1 and 4 despite the node-to-bit convention suggested by the `DeviceTrip` examples. Preserve this unresolved contradiction; do not assume the fields share one undocumented mapping.

## Narrow architecture consequence (INFERENCE)

A LinuxCNC/OpenPressBrake diagnostic page should distinguish at least:
- **Device identity:** exact interface, relay, tap class, firmware, AOP version, topology revision and logical/physical zone mapping.
- **Quality:** link connected, `Active` mode, observation timestamp/age, update epoch after power cycle/replacement, uncertainty and absent/inactive data. Zero-filled inactive tags are *unknown*, not proof of healthy guards.
- **Meaning:** live per-node state versus first-event cause versus historical event versus diagnostic code versus fault code. Do not label `DeviceTrip XOR DeviceCount` as a proven all-fault set.
- **Actions:** fault-clear/power-cycle, relay reset, guard-lock request and **new ordinary cycle start** are distinct. No automatic restart from retained start or a recovered green display.
- **Physical witness:** selected independent safety logic, final-element action, real stopping/holding, access/occupancy, residual energy and maintenance isolation. HMI telemetry cannot substitute.

The manufacturer explicitly identifies **440R-ENETR as non-safety-rated** on printed p. 75. By contrast, the distinct 432ES-IG3 product family has a manufacturer-documented CIP Safety architecture (Rockwell GLINK-AT001A-EN-P, July 2023, printed p. 3: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/glink-at001_-en-p.pdf ). Do not conflate the products or move the safety decision into ordinary LinuxCNC/FPGA software.

## Adversarial commissioning / HMI acceptance cases (not executed)

| Case | Correct documentary disposition | Physical release |
|---|---|---|
| Diagnostic 03, p. 44 duration recommendation used literally | Mark R-01 as manufacturer conflict; inspect selected reset specification; no unqualified timing setting | NOT RUN |
| Four nodes, `DeviceCount=15`, `DeviceTrip=10` | Infer nodes 1 and 3 *tripped* for documented mapping; do **not** infer both faulted | NOT RUN |
| `DeviceDiagnostic` reports one node while XOR yields two bits | Display separate reported single diagnostic and inferred tripped-node set; mark all-diagnostics set UNKNOWN | NOT RUN |
| `Active=0` and remaining tags zero | Display INACTIVE/UNKNOWN; do not show four healthy guards | NOT RUN |
| `FaultResetCmd` followed by `Reset1` while ordinary start remains held | Require independent rearm and fresh separate ordinary start; inspect selected logic | NOT RUN |
| Guard output says OFF but beam/spindle/robot still moving | Physical safe-state proposition FAILED/UNPROVED; no exposed-person release | NOT RUN |

## Evidence ledger / next information gain

- **R-01 DOC-CONFIRMED:** conflicting unit labels printed on pp. 39 and 44; **UNKNOWN** manufacturer intent. Resolution: selected relay manual/firmware or manufacturer correction.
- **D-02 DOC-CONFIRMED:** Table 5's `DeviceTrip` examples and diagnostic-XOR sentence; **INFERENCE** that XOR is only a tripped-node mask in the generic case; **UNKNOWN** intended diagnostic qualification.
- **A-03 DOC-CONFIRMED:** p. 75 ENETR non-safety authority; 432ES separate CIP Safety path in GLINK-AT001A p. 3.
- **VAL-04 NOT RUN:** no selected controller image, HMI implementation, physical guard/stop/rearm test, stopping distance, hydraulic truth table, DCavg, PL or SIL.
- **LAB DECISION:** no lab frozen. This is a documentation/selected-firmware clarification question; no GitHub-hosted Actions compute. If a real selected-interface discrepancy remains after vendor clarification, design a bounded isolated bench verification using only `[self-hosted, openpressbrake]`, with no personnel-exposed hazard.

**Course rule:** diagnostic truth, reset eligibility, actual physical safe state and ordinary cycle authority are four different propositions. Preserve `SRS/AUTH/DEP/ARC/VAL/PT/CHG/UNK` traceability and keep 2520–25F0 external evaluation gates OPEN.
