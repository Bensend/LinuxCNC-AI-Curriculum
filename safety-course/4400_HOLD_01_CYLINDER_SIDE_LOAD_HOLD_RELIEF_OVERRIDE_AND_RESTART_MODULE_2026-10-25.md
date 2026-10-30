# 4400-HOLD-01 — Cylinder-side load holding: pilot, shock relief, emergency override and deliberate restart
**4000 safety implementation | 2026-10-25 | NON-GRADUATED | No physical test or machine approval**

## Learning objective and prerequisites
A fresh engineer must distinguish **normal metered descent**, **load holding after pilot/power loss**, **overpressure relief**, **manual emergency lowering**, **maintenance isolation**, **independent gravity restraint**, and **fresh safety rearm**. Trace each to a physical energy path and the evidence required before personnel exposure. Prerequisites: 2520 hazard-to-SRS, 2530/2540 final elements, 2580 fluid-power energy, 4400-HYD/HYDAC/Parker valve variants, and [G0 evidence request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md). Source: [direct OEM audit](../research/4400_REXROTH_AVBC90_EMERGENCY_SCREW_RELIEF_AND_PARKER_E2_LOAD_HOLD_SOURCE_AUDIT_2026-10-25.md).

## Hazard boundary
The ram, tools and any held sheet are gravity loads even when LinuxCNC has stopped requesting motion. A valve's catalog *load-holding* label is not a substitute for its actual installation, chamber/pilot/return map, failure response, diagnostics, independent restraint and validation.

| Layer | Legitimate authority | Cannot establish alone |
|---|---|---|
| LinuxCNC/HAL/FPGA | ordinary Y1/Y2 position, servo output, commanded stop, diagnostics | independent stop/hold, isolation, absence of stored pressure |
| Independent safety-related controls | hazard-specific stop/guard/rearm logic and selected final-element actuation | hydraulic chamber actually held, no residual energy, mechanical block engaged |
| Hydraulic circuit | selected valve, chamber, pilot, vent, relief, pressure return, seals and hoses | universally safe response to every rupture/overload/service override |
| Physical restraint and qualified energy control | supported load, isolation, verified residual-energy control for the task | normal cycle readiness or automatic permission to move |
| Operator/maintenance interface | clear mode/override/LOTO state, accessible diagnostics, deliberate start | certification from an HMI green icon |

## Six separate propositions to put in the safety requirements specification
**HOLD-STOP:** hazardous Y1/Y2 motion reaches a hazard-appropriate stop when a protective demand occurs; derive response and actual witness for this machine.

**HOLD-STATIC:** after stopping, the gravity load cannot enter the danger zone under the design's specified faults and exposure; do not assume a single check valve covers every failure.

**HOLD-PILOT/RELIEF:** pilot, vent, thermal/shock relief, return, pressure-source and manual override effects are traced; unknown cross-connection is a HOLD, not a guessed truth table.

**HOLD-RESCUE:** trapped-person release is separately designed and reviewed; restoring power, manually opening a valve or defeating E-stop is **not** an improvised rescue plan.

**HOLD-LOTO:** servicing or tool change with possible human exposure requires task-specific physical restraint, isolation, stored/reaccumulating energy control and qualified verification. Control circuit STOP/inch/servo-disable is not a physical energy isolator.

**HOLD-REARM:** after maintenance, manual override, fault or power restoration: inspect and restore original mechanical configuration, clear people/tools, validate safeguards and final elements, reset independent safety fault state, then require a **new deliberate** motion command. No retained pedal, HMI resume or auto-cycle command may substitute.

## Source-grounded design lesson
Bosch Rexroth RE 18309-03/-04 describes the same **category** of A-VBC-90 check/metering function with three opening mechanisms: ordinary pilot, overload/shock relief that pilots the spool, and a factory-sealed emergency E screw for lowering. It requires restoring and locking that screw after use. It is explicitly described for excavator boom cylinders with ISO 8643 system-design context; no direct press-brake qualification follows. Parker E2 describes a different counterbalance design whose pilot assist and load-pressure interaction must be evaluated in its own circuit. **DOC-CONFIRMED OEM behavior; INFERENCE safety decomposition.**

## Practical architecture that discourages bypass
Design a **captive, tamper-evident, service-recorded** override boundary when approved by the exact OEM; make post-rescue restoration a visible two-person/checklist handoff instead of a hidden screw forgotten under a cover. Provide clearly labeled pressure-zone diagrams, service points outside pinch zones, accessible lockable isolation, dedicated mechanical support, and a reset station with a view of the hazard area. The mechanical override should not be needed for routine setup; otherwise the design invites predictable bypass. These are **design proposals**, not instructions to modify a selected valve.

## Failure-path review
| Trigger | Unsafe assumption | Required separate evidence |
|---|---|---|
| Pilot lost | “The valve is spring closed, so ram is safe” | actual relief/manual/return paths, chamber isolation and independent load witness |
| Shock/overload | “Check valve means zero return flow” | OEM relief path, load/pressure consequences, safe destination |
| Hose damage | “Fuse or counterbalance protects every leak” | actual protected segment, flow window, cylinder-side location, leakage/fault modes |
| Manual E override left active | “Reset complete because PLC green” | qualified physical restoration, lock/seal and controlled fresh rearm |
| One Y axis drifts | “Other Y axis holds both” | machine-specific tandem mechanical coupling/load redistribution and fault analysis |
| Power returns with foot input held | “HMI READY is permission” | independent fault clear, fresh start and physical final-element proof |
| Die change | “Pump motor off removes pressure” | task-specific LOTO, pressure-zone verification, positive restraint |

## Evaluation, uncertainty and graduation
Use [18 paper cases + blank witness](4400_HOLD_01_18_TECHNICIAN_CASES_AND_BLANK_WITNESS_2026-10-25.md), [12-gate no-energy review](4400_HOLD_01_12_GATE_NO_ENERGY_REVIEW_2026-10-25.md), and [sealed independent fresh handoff](../evaluation/4400_HOLD_01_FRESH_VALVE_OVERRIDE_TRANSFER_HANDOFF_2026-10-25.md). Do **not** self-score. No experiment is justified by available evidence: selected as-built hydraulic truth and qualified safe setup are missing. **No people-exposed operation**; any future experimental operation must be separately designed for remote/isolated testing with personnel outside danger zones and residual risk stated.

**Claim ledger:** DOC-CONFIRMED exact Bosch Rexroth/Parker manufacturer functional statements; INFERENCE requirements, human factors and fault propagation; SOURCE-CONFIRMED no new LinuxCNC source; TEST-CONFIRMED none; COMMUNITY-REPORTED none; UNKNOWN selected machine, numeric values, safety integrity, physical proof and independent evaluator. **Promotion:** as-built Y1/Y2 independent stop/hold, relief and override restoration is CRITICAL and **blocks machine release**, not merely a deferred optional detail. This non-graduated documentary module does not assert completion of any external competency gate.

**Edition/scope warning:** The [ISO official ISO 8643:2024 scope](https://www.iso.org/standard/87986.html) is excavator/backhoe loader boom/arm lowering control devices, while [B11 Standards ANSI B11.3-2022](https://www.b11standards.org/storeitems/b113-2022) is the power-press-brake machine-specific standard. The 2022 Rexroth sheet does not identify which ISO 8643 edition it references. Do not credit its catalog claim as 2024 certification or press-brake acceptance; paid normative clauses not inspected.


## 2026-10-30 OEM paired-cylinder pilot-check addendum (HOLD-01 source depth; NON-GRADUATED)
[Direct one-page Bosch Rexroth paired-cylinder pilot-check warning and qualified no-energy review](../research/4400_POC_PAIR_01_BOSCH_REXROTH_PAIRED_CYLINDER_PILOT_CHECK_LOAD_TRANSFER_OEM_AUDIT_2026-10-30.md) adds a **distinct failure path** to the existing "one Y axis drifts" row. The OEM explicitly warns that on paired cylinders a **non-modulating pilot-operated check** can open first on the less-loaded side, transferring load to the other cylinder, increasing pressure and potentially failing it. It separately describes hunting on overrunning loads and recommends actuator-near mounting for its hose-failure holding application. Its annular-chamber pilot-ratio requirement is **not** a numeric design rule for unknown Y1/Y2 cylinders. A June 2023 Sun Hydraulics indexed manufacturer excerpt distinguishes non-modulating pilot checks from modulating counterbalance cartridges; full Sun PDF retrieval was blocked (403), so no whole-manual inspection claim.

**Design-screening discriminator:** do not replace two-cylinder safety/holding with cheap ordinary pilot checks based on an individual leakage rating. Before considering any selected valve, obtain the actual paired-cylinder mechanical/load-sharing architecture, part numbers, pilot/return paths, pressure relief, hose placement, independent safety final elements and physical support. **UNKNOWN** whether the actual OpenPressBrake Y1/Y2 circuit uses pilot checks; existing Pilz-owned valves must not be relabeled as such without evidence. The existing HOLD-01 six safety propositions, public unscored practice, and qualified physical HOLD remain unchanged. No fault-injection, movement, pressure setting or exposed-person test is authorized by this source note.


## 2026-10-30 original Bosch Rexroth IH04C hydraulic-press module source comparison
[Direct 2024-07 RE 63142 manufacturer-authored PDF audit](../research/4400_IH04_01_REXROTH_2024_PRESS_MODULE_EXTERNAL_SAFETY_PLC_POSITION_MONITORING_FALL_PROTECTION_AUDIT_2026-10-30.md) shows what a **purpose-designed press hydraulic safety module** demands beyond a single check valve. For its named Cat 4/PL e **example**, printed p. 10 requires an **external safety PLC** to detect faults of position-monitored valves and prevent the **next dangerous movement** after an error, with immediate stop on direction error. It distinguishes S11a/S11b direction/center, S13 pressure-path position, S14 load-holding cartridge position, relief/intensification protection and machine-specific muting. Printed p. 40 separately describes an example PL d safe-reduced-velocity/fall-protection braking-force check with active guarding. These are exact **option-specific OEM examples**, not an achieved machine PL, generic <10-mm/s limit or authority to copy the hydraulic circuit or perform hazardous tests. Manufacturer-authored 44-page PDF was distributor-hosted; certificate HSM20005 was not independently retrieved. The **actual** Y1/Y2 Pilz program, final elements, physical holding, rearm and guard remain UNKNOWN; G0/G1 HOLD.

**Edition control:** A newer RE 63142 **2025-07** explicitly supersedes 2024-07. Its cover cites **DGUV Test HM 250065** instead of the earlier HSM20005; the actual certificates were not inspected. The 2025 p. 10 still requires an external safety PLC, and p. 39 still describes guarded fall-protection checking for the separate PL d option. See the linked audit's version-delta section. No machine-level approval follows.
