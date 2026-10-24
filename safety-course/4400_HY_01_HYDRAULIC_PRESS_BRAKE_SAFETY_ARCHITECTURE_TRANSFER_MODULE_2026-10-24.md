# 4400-HY-01 — Hydraulic press-brake safety architecture transfer and source-scope discipline

## Identity

- **Module ID:** `4400-HY-01`
- **Course level:** 4000 / Safety Course, hydraulics and safety-related controls.
- **Title:** Hydraulic valve monitoring, physical load holding, stored energy and OEM-variant transfer.
- **Status:** **source-reading / teaching draft; NOT GRADUATED**.
- **Prerequisites:** 2520 machine-level SRS; 2570/2580 physical proposition and evidence gates; `4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md`; `SAFETY_REPLACEMENT_PART_EQUIVALENCE_VALIDATION_WORKSHEET.md`.
- **Unlocks:** qualified selected-machine `IN-03/04/10` evidence mapping, independent `PHY/DEP/ARC` validation design. **Does not unlock hazardous operation.**
- **LinuxCNC source revision:** no new source trace; existing pinned 2.9.10 ordinary-control evidence applies only to LinuxCNC software, **not** hydraulic safety.
- **Last documentary verification:** 2026-10-24 UTC; no runtime/physical validation.

## Learning objective

A competent builder must be able to identify **which physical component is actually installed**, trace normal motion commands separately from safety-related stop decisions and hydraulic final elements, identify which feedback target is observed, and reject unjustified claims about load holding, pressure isolation, speed or safe restart. They must be able to compare **three genuinely different OEM hydraulic architectures** without copying a product-specific circuit or numerical criterion to OpenPressBrake.

## Course-level scope

This is a **source-to-architecture reasoning module**, not an instruction to open valves, run a press, size a hydraulic circuit, or perform a stopping-time test. Teach first from original OEM manuals, then require as-built evidence before any physical test plan. No fabricated Y1/Y2 truth table, hydraulic pressures, safe speed, stopping distance, PL/SIL/DC, leakage or response time.

## Questions to answer

1. What does a valve-position switch **actually** observe, and what can physically fail without a switch mismatch?
2. What does `OFF`, `PUMP_OFF`, `DRIVE_INACTIVE`, or `ALL_COILS_DEENERGIZED` fail to establish?
3. Which independent safety-related component owns the hazardous-motion stop request and which **physical final element** acts on energy?
4. How do **manufacturer, product family, exact variant, edition, and installed port map** alter safe-state claims?
5. What proof is required before a person may approach a raised ram or a pressurized hydraulic fitting?
6. Why is the safer human workflow (visible supports, accessible labeled ports, easy guard restoration) part of the safety design rather than a procedural nicety?

## Official documentation pass: three contrasting OEM families

| Product/source | Document-confirmed scope | High-value transfer trap |
|---|---|---|
| **Bosch Rexroth general IH04**, RE 63124-B 08.2021; https://www.kraemer24.shop/media/c6/6b/c7/1754488661/RE%2063124-B_2021-08.pdf | General press hydraulic module instructions. Normal valve electronics actual-value must not be used as safety-off output; OFF can retain pressure; safety-valve replacement calls for reaction-time rechecks. | The manual's 5 mm/s statement has a specific load-side measurement condition; **not** an OpenPressBrake ram acceptance limit. |
| **Bosch Rexroth IH04E die cushion**, RE 63129-MON 09.2022; https://www.manualslib.com/manual/2958602/Bosch-Rexroth-Ih04e.html | Lower die-cushion circuit with monitored valve positions but leakage mechanisms not detectable by switches; OEM-specific 1/5 mm/s contexts. | **Not** a press-brake upper beam. Similar numerical units do not establish equivalence. |
| **HAWE ePRAX modular**, B 6340 04-2026; https://productfinder.hawe.com/downloads/B6340-en.pdf ; D 6340 07-2026; https://productfinder.hawe.com/downloads/D6340-en.pdf | Real CNC press-brake with per-axis normal servo-pump control, gravity-assisted FAST DOWN, machine-level safety-related monitored hydraulic valves/linear scales, optional stored-energy Slow Up. | Loss of drive speed control can remove intended hydraulic throttle; **safety valve authority is distinct**. D 6340 `S` monitoring and `X/A/B` Slow Up options must be read from actual order code. |
| **HAWE SAKB + separate NSV**, D 6335 08-2025; https://productfinder.hawe.com/downloads/D6335-en.pdf ; D 6368 06-2026; https://productfinder.hawe.com/downloads/D6368-en.pdf | SAKB `S` lists five monitored central valves, separate normally-open pilot-to-close NSVs; NSV `L` without seal/with leakage; `050/060` reverse A/B pressure/suction. | ePRAX `S` is **not** SAKB `S`; an NSV `L` is not leak-tight; a gauge attached to port A may observe the wrong zone. |

**Classification:** `DOC-CONFIRMED` for cited OEM statements and exact editions. `INFERENCE` for cross-family design lessons. `UNKNOWN` for selected OpenPressBrake components. No `TEST-CONFIRMED` machine safety claims.

## Community / forum pass

No community or forum report was needed to resolve the current **documentary** OEM-variant questions. Community claims have **not** been used as evidence or silently upgraded to `DOC-CONFIRMED`. Later selected-machine user reports must be recorded as `COMMUNITY-REPORTED` until independently checked. This is an explicit scope decision, not a completed community survey.

## Source inventory and symbol depth

| Source / path | Symbols or structures | Role | Depth/status |
|---|---|---|---|
| Existing pinned LinuxCNC v2.9.10 `linuxcncrsh` → NML → Task source trace in 4400 research | Remote E-stop reset, machine enable and motion request paths | **Ordinary software command** boundary, not safety authority | Reuse existing source trace; no new source inspection claimed |
| Existing pinned LinuxCNC `iocontrol` / `estop_latch` source trace | `user-enable-out`, `user-request-enable`, `emc-enable-in` | Ordinary E-stop handshake versus external physical safety proposition | Reuse; no new source inspection claimed |
| HAWE B 6340 and D 6340 | `QM2..QM5`, `BG2..BG5`, `S`, `X/A/B`, optional Slow Up | OEM-specific safety-related hydraulic valve/feedback/energy variants | Deep **documentary**, not LinuxCNC source code |
| HAWE D 6335 and D 6368 | SAKB `S`, NSV `L`, `050/060`, `BA/BE` | OEM-specific monitored-valve and port/leakage semantics | Deep documentary |
| Bosch RE 63124-B and RE 63129-MON | IH04 analog actual-value, valve switches, hydraulic leakage and replacement | Safety authority and physical-witness transfer boundaries | Deep documentary |

**Function/symbol guide decision:** no new LinuxCNC symbol needed deep tracing to answer this module's OEM hydraulic question; the existing pinned source guides are referenced. A new source call flow or source-level test would be fabricated if claimed here. Any new software implementation belongs to a separate bounded module with its own pinned revision and independent verification.

## Experiments / independent verification status

**None performed.** No simulations, test suites, synthesis, machine motion, hydraulic valve actuation or GitHub-hosted/self-hosted compute were needed for the present source-transfer question. Independent checks of the OEM editions and public document statements are **documentary cross-source checks**, not `TEST-CONFIRMED` machine evidence. The novel prediction and fresh-AI handoff remain open below.

## LinuxCNC source / ordinary-control boundary

Use existing `linuxcncrsh`/NML/Task, `iocontrol`/HAL and `estop_latch` source traces only to show that LinuxCNC can request E-stop reset, motion and output changes. These are **ordinary machine-control state transitions**. The module does **not** assert that LinuxCNC/HAL, a generic FPGA, the motor speed loop, an HMI indication or a remote network command performs a safety-rated hydraulic stop. The selected machine must separately identify the safety-related controller, protective input, final-element drive, valve physical state, independent beam witness, energy-isolation mechanism and deliberate local restart.

## End-to-end authority and energy map

`Person/guard/ESPE demand` → **independent safety-related controller** (fault, mode, speed and restart authority) → **qualified safety final elements** (specific valve/drive/contactors as justified) → **physical energy/flow state** → **actual hazardous beam motion/holding** → **independent witness**.

Parallel, **not substitutable**, path: `LinuxCNC/FPGA normal command` → normal servo-pump speed/torque and proportional-valve commands → production trajectory/diagnostic status. A valid normal trajectory or `all_valves_ok` bit does not close the physical safety proof.

Maintenance is another path: `personal isolation` → `each electrical/hydraulic/gas/gravity zone controlled` → `physically verified absence/containment and load restraint` → `service access`. A protective stop alone does not close this path.

## Failure modes and explicit consequences

| Failure / shortcut | Potential hidden physical outcome | Required evidence/disposition |
|---|---|---|
| Normal drive loses speed control during gravity FAST DOWN | Normal throttling may disappear even if speed command is zero | Independent protective stop/final-element behavior and physical beam witness; **HOLD** if unproved |
| Valve feedback indicates expected position | Seal/cylinder/relief/manifold leakage can still move load | Separate physical `PHY-HOLD`, pressure-zone and fault coverage evidence |
| Pump switched off | Trapped pressure, gravity or optional Slow Up accumulator energy remains | `ENE` map, restraint, isolation and pressure witness |
| SAKB `S` mistaken for ePRAX `S` | Missing or differently targeted valve feedback | Complete family/order-code and safety I/O mapping |
| NSV `L` treated as sealed | Designed leakage path overlooked | Exact seal suffix, load-holding architecture and physical proof |
| NSV `050/060` port assumption | Wrong pressure/suction connection measured or serviced | Exact drawing, port orientation and qualified test-point identity |
| Bosch IH04E drift figure copied to Y1/Y2 | False numerical acceptance | Reject and obtain actual risk assessment/standard/machine evidence |
| Same-type safety valve replaced | Response and fault coverage changed without revalidation | `CHG/VAL/PT` affected safety-function reproof |
| Support/guard is awkward to use | Predictable defeat, shortcut or unsafe maintenance | `HF` design correction; support/verification/restoration easier than bypass |

## Learning activity A — source identification (no machine operation)

Given only a **fictional** inventory reading `HAWE SAKB 06 ...`, `NSV060BA03L`, `HAWE ePRAX CM ...`, and `Bosch IH04E`, learners must identify **four different scope questions**: which are complete codes, which are manifold versus separate valve, what the `L` suffix says, what the `S` code can and cannot say, whether an accumulator is proven present, and which part is a die cushion rather than the upper ram. Learners may use the OEM source table but must cite exact edition and page. **No physical test.**

## Learning activity B — paper failure-path tracing

Start with a hypothetical machine where the HMI displays `SAFE`, motor torque command is zero, one pressure gauge is zero and the beam has not yet been independently observed. Construct a `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/ARC/VAL/PT` chain that distinguishes **software command**, **valve feedback**, **pressure zone**, **gravity load** and **actual motion**. Record a credible fault that can make each indicator misleading. Explain why `G3/G4` remains **NOT AUTHORIZED**.

## Learning activity C — practical human-factors redesign

A technician reports that removing a guard is easier than opening the proper inspection access, that pressure test points are hidden, and that the approved ram restraint is stored elsewhere. Propose a **physical redesign**: captive/hardware-supported guards, labeled accessible ports with protective caps, permanently nearby rated restraints, obvious maintenance-isolation points and fault diagnostics that identify repair rather than encouraging bypass. State how to verify that the redesign **actually reduces bypass incentive**, and which safety functions require revalidation after the change. Do not prescribe unqualified live operation.

## Claims ledger and evidence quality

| Claim | Classification | Evidence | Remaining gap |
|---|---|---|---|
| OEM families have different valve/port/monitoring/energy options | DOC-CONFIRMED | Four manufacturer manuals/datasheets above | Actual installed model/variant unknown |
| Healthy valve feedback does not prove physical load holding | DOC-CONFIRMED for IH04E leakage blind spots; INFERENCE for generic transfer | RE 63129-MON p. 28 | Selected `PHY-HOLD` |
| Ordinary LinuxCNC motion command is not safety authority | SOURCE-CONFIRMED for pinned ordinary software paths; INFERENCE for architecture separation | Existing pinned source traces + OEM machine safety control requirements | Actual independent safety controller/final elements |
| ePRAX FAST DOWN can accelerate without active normal speed control | DOC-CONFIRMED | HAWE B 6340 pp. 21–22 | Actual machine stop performance unknown |
| Selected machine is safe to operate | UNKNOWN / NOT ESTABLISHED | No as-built `IN-01..10` or physical `VAL/PT` | **G3/G4 NOT AUTHORIZED** |

## Prediction check — **OPEN / predeclared for future independent evaluation**

These are **predictions made now**, not post-hoc confirmations or passed tests. They require a **fresh reviewer** and only documentary evidence until qualified physical testing is authorized.

| Novel hypothetical scenario | Predeclared predicted reasoning | Independent evidence required | Status |
|---|---|---|---|
| Two drawings show `NSV050...` and `NSV060...`, both with gauge on port A | A observes different functions between the two variants | OEM D 6368 page and drawing reconciliation by fresh reviewer | OPEN |
| A controller reads a valve switch but the ram is reported moving | Broad `PHY-HOLD` fails despite plausible switch | Fresh reviewer traces OEM leakage paths; selected machine still UNKNOWN | OPEN |
| ePRAX `S` option is replaced with no-monitoring variant | Previously credited monitoring proposition becomes invalid | Fresh reviewer traces D 6340 order codes and I/O | OPEN |

No tests or independent evaluator scores have been claimed. These open predictions **cannot** satisfy graduation evidence until genuinely independently checked.

## Adversarial exam (not external blind assessment)

1. A technician argues that two Y-axis servomotors provide personnel-safety redundancy. Explain the common missing evidence.
2. A vendor says `S` guarantees five monitored valves on every HAWE product. Disprove using exact original OEM source pages.
3. A replacement valve is mechanically identical and the HMI remains green. Identify `CHG/DEP/VAL/PT` evidence invalidated.
4. A proposed change moves a pressure gauge from port A on `060` to port A on `050`. Explain the physical observation error without opening any line.
5. A machine with an optional accumulator reports `PUMP_OFF`. Explain why maintenance entry is not automatically safe.
6. An integrator proposes moving guard reset and safe stop into normal LinuxCNC for convenience. Identify the authority boundary and the independent physical final element needed.

Answers must cite source, claim classification, remaining UNKNOWN and safe disposition. This exercise is **not** a substitute for 2520–25F0 information-separated external evaluation.

## Corrections / counterfactual promotion test

**Correction frozen:** an OEM numerical value, product letter, status bit or example circuit must never be promoted into a different machine's safety acceptance. If any actual installed valve, pressure topology, guard geometry or hydraulic load differs, this module's **transfer prohibition remains valid**; its hypothetical machine architecture may change. This is why selected-machine details remain **blocking** for physical release rather than being promoted away.

**Counterfactual:** If OpenPressBrake has no HAWE or Bosch components, every manufacturer-specific claim remains a correctly scoped example, while the **requirement to identify and validate the actual independent safety function remains unchanged**. This module is therefore a useful source-reading lesson, but **not graduated**: fresh-AI handoff and external independent evaluation are open, and selected physical release remains blocked.

## Open questions / promotion queue

| Item | Evidence | Consequence if wrong | Destination | Blocks module graduation? |
|---|---|---|---|---|
| Exact installed Y1/Y2 manifold/valve/port/monitoring options | UNKNOWN | Could invalidate every proposed physical safety test | Selected `IN-03a/04a/10a`, 4400 `ARC/VAL/PT` | **YES for machine release**, not for paper source-reading |
| Independent safety controller/linear-scale/final-element architecture | UNKNOWN | Hazardous motion may not stop as assumed | Selected `SRS/AUTH/DEP/VAL` | **YES for machine release** |
| Qualified physical stop/hold, stored-energy isolation and restart tests | NOT RUN | Person may be exposed to uncontrolled ram/pressure | Selected `PHY/VAL/PT` | **YES for machine release** |
| Fresh AI source transfer and novel prediction evaluation | NOT RUN | Module competency unproven | External 2520–25F0 process | **YES for module graduation** |
| Exact six archived historical files | Missing original bytes | Publication fidelity incomplete | Exact archive recovery | Not a safety-function release substitute |



## Graduation evidence floor and re-promotion status

| Template gate | Current result |
|---|---|
| Mechanism/source identification | OEM hydraulic product-family mechanisms documented; existing LinuxCNC ordinary software source boundary reused |
| Behaviorally significant path | Documented normal drive command versus safety-valve final-element and physical witness paths |
| Independent verification beyond rereading source | **OPEN**: fresh reviewer/source challenge and selected physical witness not completed |
| Representative failure path | Source-traced leakage, gravity drive-inactive, NSV suffix/port reversal and accumulator hazards |
| Predeclared prediction independently checked | **OPEN**; predictions are recorded but not yet tested |
| Fresh-AI novel handoff | **OPEN**; no score fabricated |
| Counterfactual safety boundary | Preserved; actual installed machine remains UNKNOWN |
| External evaluator / physical machine graduation | **NOT MET** |

**Re-promotion test:** no unresolved 1000/2000 prerequisite was moved to 3000/4000 to escape investigation. This 4400 work is independently machine-specific and advanced; existing graduated earlier levels remain closed. Selected-machine physical proof is **blocking for exposed operation**, not something to promote away. Repeated lab failures: none, so no three-attempt disposition required.

## Handoff / graduation decision

**Status: source-reading only, NOT GRADUATED.** Official manufacturer documentation and failure paths are substantial; no new LinuxCNC source trace or runtime test was necessary for this documentary question. The independent fresh-AI handoff, predictions and selected physical validation have **not** occurred. Do not claim 2520–25F0 graduation or machine safety certification. No GitHub-hosted Actions compute, self-hosted simulation, or physical experiment is justified by this lesson alone. **No personnel-exposed hazardous operation** until independently proven minimum safeguards; experimental work must be remote/isolated with all people outside danger zones and residual risk documented.


## Fresh-AI handoff contract prepared (2026-10-24)

The separate [novel two-concept OEM variant transfer handoff](../evaluation/4400_HY_01_FRESH_HANDOFF_CONTRACT_2026-10-24.md) provides an **unscored learner-visible assignment** with a blank evidence matrix and explicit information separation. **Prepared is not performed:** evaluator result `NOT RUN`, module `NOT GRADUATED`, selected machine `PHY/VAL/PT UNKNOWN/NOT RUN`.
