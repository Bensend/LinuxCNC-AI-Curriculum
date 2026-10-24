# 4400 — Brownfield CNC retrofit: retained safety controller, changed control boundary, and lockable energy isolation

**Status:** ORIGINAL SOURCE/REGULATORY AUDIT; documentary teaching only; **NOT** a selected-machine validation, electrical drawing, commissioning authorization, or external competency score.  
**Research date:** 2026-10-24 UTC. **Scope:** a hypothetical hydraulic press-brake CNC replacement that retains a separate safety controller; transfers to other machines only after machine-specific hazard review. No proprietary machine documents are reproduced.

## Concrete engineering question

When the old CNC is removed and a LinuxCNC/FPGA controller is installed while an existing safety PLC remains, **what evidence is necessary to prove that safety functions were not silently lost or moved into ordinary control?** This is distinct from asking whether the old safety PLC still powers up or whether the new CNC receives a `SAFETY_OK` bit.

## Original authoritative evidence and scope

| ID | Original evidence inspected | Narrow documentary/source conclusion | Classification |
|---|---|---|---|
| R1 | OSHA [29 CFR 1910.147(c)(2)(iii)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) (official current standard) and [1910.302(c)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.302) | Following qualifying replacement or major repair/renovation/modification, energy-isolating devices must be designed to accept a lockout device; electrical disconnect requirements can apply in addition. Whether a particular retrofit meets the factual trigger must be evaluated, not guessed. | DOC-CONFIRMED |
| R2 | OSHA [1910.147 definitions, (d), (e), (f)](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) and [2021-09-30 energy-isolation interpretation](https://www.osha.gov/laws-regs/standardinterpretations/2021-09-30) | A pushbutton/control-circuit device is not an energy-isolating device; a pneumatic line that must be disconnected by dismantling is not thereby a lockable isolator. Isolation, stored energy, verification and release are distinct operations. | DOC-CONFIRMED; exact installed isolator UNKNOWN |
| R3 | OSHA [2008-01-25 PLC alternative-measures interpretation](https://www.osha.gov/laws-regs/standardinterpretations/2008-01-25) | An ordinary PLC safety/stop control is not a general substitute for maintenance LOTO; the narrowly conditioned minor-servicing exception needs effective alternative protection and a case-specific hazard analysis. | DOC-CONFIRMED, limited to the interpretation's stated scope |
| R4 | OSHA [1910.212](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212) | General point-of-operation and machine guarding remains applicable. Changing the CNC does not remove the underlying machine hazard. | DOC-CONFIRMED |
| R5 | [Pilz retrofit guidance](https://www.pilz.com/en-US/services/retrofit) and [Pilz/Grass press-line case study, March 2024](https://pilz-magazine.com/en/retrofit-press-grass/) | Manufacturer/integrator practice includes a new safety assessment, machine-wide scope, separate ordinary/safety controls, safety circuit changes and validation. The Grass example is an eccentric press line, **not** proof of a hydraulic press-brake retrofit. Its EU CE discussion is jurisdiction-specific, not automatically a US legal requirement. | DOC-CONFIRMED example; transfer is INFERENCE |
| R6 | LinuxCNC [2.9 `iocontrol` manual](https://linuxcnc.org/docs/2.9/html/man/man1/io.1.html), especially `emc-enable-in`, `user-enable-out`, `user-request-enable` | `iocontrol` is non-realtime ordinary I/O; its external E-stop input is a software-facing interface and its user reset request is not an independent safety reset. | DOC-CONFIRMED for 2.9 docs |
| R7 | LinuxCNC pinned [`estop_latch.comp`](https://github.com/LinuxCNC/linuxcnc/blob/514be4f657b2f1c432ebaaebd117ef112e3e7565/src/hal/components/estop_latch.comp) at commit `514be4f657b2f1c432ebaaebd117ef112e3e7565`, blob `f8b0e60b2784d6ca4c456fddd49e7308fa669795` | Source explicitly calls it a **software ESTOP latch**. Initial state Faulted, `ok_in=true` and `fault_in=false` defaults, rising reset edge required to become OK, software watchdog toggles in OK. The example connects `iocontrol.0.user-request-enable` to reset and `ok_out` to `emc-enable-in`. | SOURCE-CONFIRMED for pinned revision |
| R8 | Prior [2530 source-boundary trace](../safety-course/2530_LINUXCNC_ESTOP_LATCH_BOUNDARY_TRACE_2026-09-22.md) | Existing course already establishes that a LinuxCNC software E-stop latch and watchdog do not prove physical safe state. This new audit concerns **retrofit cutover and evidence continuity**, not a replacement for 2530. | Prior SOURCE-CONFIRMED synthesis |

**No physical test or LinuxCNC executable lab was performed.** No selected safety-PLC program, hydraulic diagram, safety final element, PL/SIL, stop time, or pressure limit was inspected or inferred. OSHA requirements are presented as US federal provisions with applicability depending on workplace and facts; state plans and other jurisdictions may differ.

## New result: retention is a component claim, not a function claim

A machine can retain its safety PLC, safety devices, and their indicator lights yet lose a protective function during a controller retrofit. For example, the former CNC may have provided a handshake, permissive, or controlled deceleration that the new CNC implements differently. A replacement controller can also introduce a fresh motion source, hold an output across reconnection, invert an enable polarity, or wire a safety output only to an FPGA input. These are **credible INFERENCE failure hypotheses**, not claims that any particular machine has these faults.

The required trace is per **hazardous motion and exposure**, not per controller box:

`hazard/exposure → sensing/guard → safety controller input/configuration → independent safety decision → safety final-element output → actual contactor/drive/valve/restraint → physical stop/hold/energy witness → deliberate reset and separate new start`.

Alongside it, trace the **ordinary** path:

`operator/HMI/G-code → LinuxCNC Task/HAL → FPGA or ordinary motion controller → proportional valve/VFD/actuator`.

A third path is **diagnostic only**:

`safety controller status → isolated/appropriately protected input → LinuxCNC/HMI indication and logging`.

A fourth path is **maintenance**:

`energy source → physically lockable isolator(s) → stored energy discharge/restraint → independent verification → service → controlled restoration`.

A single `SAFETY_OK` bit can legitimately coordinate ordinary CNC operation. **It is not evidence that the independent safety controller physically removes or contains all relevant hazardous energy.** The direction of authority must not reverse: LinuxCNC/FPGA must not become the sole owner of personnel-protective final-element withdrawal, reset, guard bypass, or gravity holding.

## Before/after cutover reconciliation contract

For **each** safety function and each relevant operating/service mode, preserve the following without inventing values:

| Evidence record | Before retrofit | Proposed after retrofit | Required disposition |
|---|---|---|---|
| `BND/HAZ/ENE` — hazardous motion, access and energy zones | Identified from actual machine | Reassess added motion sources, cabling, access, control modes | UNKNOWN blocks safety claim |
| `SF/SRS` — protective trigger and required reaction | Actual old-machine design and witnessed behavior | Revised requirement independent of old CNC implementation | Change review; no unexamined inheritance |
| `AUTH` — who owns reset, safety permissive, cycle start, final-element command | Trace safety PLC, old CNC and manual controls | Trace safety PLC, LinuxCNC, FPGA and HMI | No personnel-safety authority silently moved |
| `ARC/DEP` — independent final elements and common dependencies | Exact relay, valve, contactor, drive, supply, cable | Exact retained/replaced parts and failure paths | A retained label does not prove retained wiring |
| `PHY` — stop, hold, occupancy and stored-energy propositions | Physical witness and its limits | Required physical witness after retrofit | Independent machine-specific validation remains open |
| `HF` — use, diagnosis, guard reinstallation, bypass incentives | Real work practice | Make correct use/reset/repair easier than defeat | Correct ergonomic defects; never bypass as default |
| `VAL/PT` — negative/fault and power-cycle cases | Valid old evidence and version | New predeclared acceptance cases and safe test methods | Old evidence marked STALE where affected |
| `CHG` — change control and release | Baseline drawing/program/parameter revisions | Controlled delta, responsible reviewer and restoration record | HOLD until affected evidence reconciled |

**Cutover states:** `OLD_BASELINE_DOCUMENTED` → `CHANGE_SCOPE_FROZEN` → `SAFE_WIRING_REVIEWED` → `ISOLATED_VERIFICATION_APPROVED` → `PHYSICAL_VAL_PT_COMPLETE` → `RELEASE_REVIEWED`. These are **proposed curriculum states**, not an OEM procedure. If an intermediate state fails, preserve the old baseline and **HOLD** rather than treating a green HMI as a shortcut to production.

## Four high-consequence fault hypotheses

1. **Safety signal becomes diagnostic only.** PLC output goes to a general FPGA input; the physical valve/contactor enable no longer has an independent safety cut-off. The HMI reports STOP but hazardous motion remains possible. **INFERENCE**; trace actual final-element circuit and physical witness.
2. **Old CNC handshake removed.** A safety PLC expected a qualified old-controller acknowledgement, safe-state sequence or monitored output. A constant replacement signal appears healthy. **INFERENCE**; verify old/new program, signal semantics, timeout/fault behavior and any safety-credited response before redesign.
3. **Reset becomes start.** PLC reset, LinuxCNC `user-request-enable`, an old foot command and a retained motion request can align after power restoration. **INFERENCE**; require separate deliberate local reset, cleared stale ordinary command and a new intentional start; source `estop_latch` edge does not validate the PLC or occupancy.
4. **Electrical retrofit overlooks service isolation.** Replacing the cabinet may leave an un-lockable isolator, trapped hydraulic pressure, or unsupported gravity load. OSHA 1910.147(c)(2)(iii) is an explicit design review trigger for qualifying major modifications; a software E-stop, contactor or control button is not maintenance LOTO. The precise retrofit applicability and installed isolation **UNKNOWN**.

## Practical low-friction architecture

- Retain an independent, identifiable safety controller and final-element path; label safety versus normal I/O distinctly. If a physical final element is absent or its authority cannot be demonstrated, **do not commission personnel-exposed operation**.
- Use **one-way status/permissive interfaces** into ordinary LinuxCNC/FPGA, with a separately qualified independent hardware withdrawal path. Never infer that an FPGA `disable` bit by itself satisfies a personnel-safety function.
- Use keyed/labelled connector sets, photographed terminal identity, source-controlled safety configuration identity, controlled change list and a visible local reset station. Design service access so guards, test points and isolators are easier to use correctly than to defeat.
- Make ordinary machine start a **new, deliberate action** after the safety system has separately accepted a qualified reset; prohibit reusing an old foot/HMI/remote request.
- Prefer source/document and isolated de-energized wiring review before any experiment. If physical testing is necessary, a qualified team must freeze the test question, fixture, containment, independent restraint, energy control and remote/personnel-exclusion method first. **No live test recipe is supplied here.**

## Transfer to other LinuxCNC machines

The same four-path separation applies to mills (spindle and axis STO/contactor, stored rotation), lathes (chuck/spindle and door access), plasma (arc/torch supply, fume/fire), robots (safeguarded space and gravity axes) and automation cells (shared E-stops, conveyors, rearm). Their **actual** safe states and final elements differ. Do not transfer hydraulic press-brake pressure/holding assumptions or component integrity ratings across machines.

## Evidence disposition and information-gain stop

- **SOURCE-CONFIRMED:** pinned LinuxCNC `estop_latch.comp` software behavior; no selected retrofit source inspected.
- **DOC-CONFIRMED:** LinuxCNC 2.9 I/O semantics; OSHA 1910.147/1910.302/1910.212 and cited interpretation; Pilz retrofit case as **a distinct commercial machine**.
- **INFERENCE:** cutover hazard hypotheses, proposed architecture/phase gates and usability improvements.
- **UNKNOWN / MACHINE-VALIDATION-BLOCKING:** actual old/new safety wiring, controller program and checksum, safety final elements, lockable isolators, ram gravity holding, hydraulic energy, guard geometry, reset/start, physical stop and release evidence.
- **TEST-CONFIRMED:** none. No hosted or local compute, physical validation, or independent evaluator.
- **Information-gain stop:** no amount of source-only argument can establish a selected machine's physical stop/hold/isolation. Request machine evidence privately, not in this public course; rotate to other safety work when unavailable.

**Freeze:** `RETAINED SAFETY PLC != RETAINED SAFETY FUNCTION`; `LINUXCNC SOFTWARE ESTOP != INDEPENDENT PHYSICAL STOP`; `SAFETY_OK INPUT != FINAL-ELEMENT WITHDRAWAL PROVED`; `RETROFIT COMPLETE != MAINTENANCE ISOLATION REQUALIFIED`. No personnel-exposed hazardous operation is authorized by this research.
