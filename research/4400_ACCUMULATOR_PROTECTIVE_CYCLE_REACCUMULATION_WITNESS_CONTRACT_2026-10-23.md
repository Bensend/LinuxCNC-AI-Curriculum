# 4400 — Accumulator protective-cycle energy, reaccumulation, and independent witness contract

**Date:** 2026-10-23 UTC. **Status:** learner-visible safety architecture and source adjudication; **no selected-machine validation**. Complements [the exact archived accumulator dual-role study](../research/4400_ACCUMULATOR_DUAL_ROLE_SAFE_CYCLE_VS_ISOLATION_2026-10-22.md) rather than replacing it.

## Specific unresolved question

An accumulator may be intentionally retained to finish a protective motion after supply loss, but the same energy can later drive unexpected motion or reaccumulate behind a supposedly isolated service boundary. What must be known before (a) crediting the protective cycle, (b) admitting a person to service, and (c) permitting a fresh restart?

**Conclusion:** these are **three separately justified transactions**, not one `safe` Boolean. Ordinary LinuxCNC/FPGA status, a pressure switch, a commanded dump valve, and a maintenance padlock cannot individually prove all three. The controller may request a response and record diagnostics; the selected independent safety system and physical energy-control mechanisms own the credited protection.

## Source ledger and narrow claims

| Claim | Evidence | Classification | Limit |
|---|---|---|---|
| Bladder accumulators may provide reserve power for a fail-safe cycle after loss of pump/electric power. | Parker Hannifin, *Bladder Accumulators — Maintenance & Installation*, HY10-1632-M2/US (2016), intended-use section, printed p. 1; official PDF indexed at https://test.parker.com/content/dam/Parker-com/Literature/Accumulator---Cooler-Division---Americas/Catalogs---Bulletins/HY10-1632-M2.pdf | **DOC-CONFIRMED** intended application | Not proof a particular accumulator, valve, motion direction or sequence is safe. The indexed main `www.parker.com` PDF endpoint returned 404 on 2026-10-23; retain edition and URL provenance rather than silently replacing it. |
| Stored energy must be relieved, disconnected, restrained or otherwise rendered safe after isolation; if hazardous reaccumulation is possible, verification continues. | OSHA 29 CFR 1910.147(d)(5)(i–ii), https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 | **DOC-CONFIRMED**, regulatory text rechecked 2026-10-23 | Applicability and the machine-specific procedure require assessment; this does not define a press-brake hydraulic circuit. |
| Authorized workers must verify isolation/deenergization before servicing. | OSHA 1910.147(d)(6), same official text | **DOC-CONFIRMED** | A display or one gauge is not inherently a complete verification. |
| An accumulator-equipped hydraulic system can move unexpectedly during improper disassembly. | HAWE D 7571, 03-2024 rev 1.1, printed p. 12, https://productfinder.hawe.com/downloads/D7571-en.pdf | **DOC-CONFIRMED** manufacturer warning | Product example, not the selected OpenPressBrake assembly. |
| Independent stop, holding, isolation and rearm witnesses must be separately traced. | Derived from source boundaries and failure analysis below | **INFERENCE / design requirement** | Not a measured stopping distance, pressure threshold, PL/SIL or diagnostic coverage. |

**SOURCE-CONFIRMED:** no new LinuxCNC source behavior is asserted here. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied upon. **UNKNOWN:** exact machine pressure topology, accumulator purpose, pilot dependencies, gas precharge, safe-cycle energy budget, response times, stop/hold performance and maintenance energy-control procedure.

## Three transaction contracts

| Transaction | Authority / prerequisite | Required physical proposition | Common false shortcut |
|---|---|---|---|
| **P — protective demand during power loss** | Defined safety function and independent safety controller/final element; determine whether reserve energy is needed to finish the specified response. | Hazardous motion reaches its specified safe result and remains acceptably restrained; physical evidence independent of the command is recorded. | `E-stop=1`, motor off, or valve command accepted therefore beam safely held. |
| **M — transition to exposed servicing** | Authorized personnel establish energy isolation, personal protection and mechanical restraint appropriate to the machine; identify every relevant hydraulic/gas/gravity zone. | Hazardous stored energy is rendered safe, actual isolated zones are verified and reaccumulation is addressed during the service interval. | A single S-side gauge reads zero, or a safety valve reports closed, therefore every zone and elevated load is safe. |
| **R — restoration and fresh production start** | Workers cleared, guarding restored, faults reconciled, applicable lockout release and independent safety rearm; ordinary cycle start remains a separate deliberate action. | Physical stop/hold/guard/occupancy conditions still valid for the selected operating mode; no retained motion command starts the machine. | Power restored, reset button held, HMI green or old diagnostic packet therefore automatic motion permitted. |

## Dependency and witness ledger to instantiate for a selected machine

Assign a stable `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/ARC/VAL/PT/HF/CHG/UNK/RR` ID to each claim. The following fields are **unfilled design inputs**, not invented as-built facts.

| Record | Required selected-machine evidence | Present state |
|---|---|---|
| `ENE-ACC` | Exact accumulator model, fluid/gas compartments, connected ports, available stored energy, charging/recharging paths and safe servicing provisions | **UNKNOWN** |
| `DEP-PORT` | Hydraulic schematic tracing each gauge/transducer tap to volumes under every isolation/check-valve state; include pilot, tool-clamp and gravity load paths | **UNKNOWN** |
| `SF-STOP` | Safety demand, permitted protective motion direction, retained-energy requirement, final elements, independent feedback and safe result | **UNKNOWN** |
| `PHY-HOLD` | Credible independent restraint/load witness after protective cycle and after power loss; address leakage and shared mechanical dependencies | **NOT RUN** |
| `PHY-ENERGY` | Isolation device position and lockability, controlled discharge/relief, verified fluid/gas hazards, gravity support and reaccumulation surveillance | **NOT RUN** |
| `PHY-RESTART` | Fresh fault-clear/rearm and deliberate start; guards and mode correctly selected, no retained motion request | **NOT RUN** |
| `HF-SERVICE` | Readable permanent zone labels, accessible protected test points, easy-to-reinstall guards, non-defeatable practical service workflow | **NOT ASSESSED** |
| `CHG` | Invalidate dependent evidence on gauge relocation, hose/check-valve changes, accumulator/valve replacement, guard changes or firmware/config change | **OPEN** |

**Independence check:** a PLC `pressure_ok` derived from the same transducer as the HMI is one sensor path, not two independent witnesses. Two gauges on the same isolated manifold port are not independent coverage of a downstream trapped cylinder chamber. A valve spool sensor establishes its target, not the physical ram position or structural holding. Even a genuinely independent ram sensor does not itself establish zero pressure or maintenance isolation.

## Adversarial causal cases (document review, not a live test script)

1. **Power failure during approach:** supply pump stops; accumulator retains energy; ordinary controller reports stopped. Identify which selected safety function permits or forbids continued movement, what element executes it and what independent measurement would falsify completion.
2. **After an apparently successful protective stop:** a pressure indication is low at a drain-side port but a check valve may trap a load-side chamber. Do not declare `PHY-ENERGY` true; require actual port connectivity and mechanical restraint evidence.
3. **Maintenance reaccumulation:** an isolated chamber can be re-pressurized by thermal effects, leakage across a valve, gravity-driven cylinder motion or an unisolated accumulator path. These are **candidate failure mechanisms**, not proven properties of a selected circuit. Identify a valid means of continued verification without requiring a worker to enter the hazard.
4. **Restoration with a retained command:** a reset or start input is already active when power returns. Demand independent rearm logic and a fresh deliberate ordinary start, rather than treating LinuxCNC's software state as safety authority.
5. **Human-factors shortcut:** the only useful pressure tap is behind a heavy guard requiring removal and special hoses. Reject the design as operationally fragile; propose accessible, labeled, protected service points and guard hardware that is easy to reinstall without sacrificing protection.

## Verification freeze rule

Do **not** run a hydraulic or software lab merely to populate this table. First obtain the selected hydraulic/electrical schematics, device manuals, hazard and task boundaries, and credible physical witness arrangement. Freeze one falsifiable question and the acceptance method before any bounded test. Physical stop/hold/energy tests require a qualified plan and isolation/remote observation with personnel outside the danger zone until the minimum safe-to-operate threshold is independently established. Simulation cannot validate physical machine stopping, hydraulic load holding or exposed-person access.

**Current release:** G0/G1 **HOLD**; G2 **NOT RUN**; G3/G4 **NOT AUTHORIZED**; G5 **HOLD**. No machine-specific pressure threshold, hydraulic truth table, stopping distance, safety integrity or personnel-exposed operation is authorized.

## Fresh-AI transfer prompt

For a lathe with a hydraulic chuck and an accumulator, distinguish loss-of-power workholding, emergency stop, spindle standstill, chuck clamping, a technician's stored-energy isolation and deliberate restart. State what a pressure sensor can legitimately witness and what remains unknown. Do not transfer a press-brake's gravity-loaded ram architecture or assume a hydraulic pressure reading proves grip force.
