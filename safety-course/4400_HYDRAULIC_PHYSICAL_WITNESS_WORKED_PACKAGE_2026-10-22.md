# 4400 — Worked traceability package: expected valve feedback, unproved beam restraint

**Status:** deliberately fictional instructional case, not an installed-machine hydraulic circuit or validated SRS. No real pressure, stop time, integrity target, fault coverage or circuit truth table is asserted. The exercise demonstrates how to preserve the 2520–25F0 cumulative Safety Design Package chain when a manufacturer data sheet appears to answer only part of a machine safety question.

## Case boundary

An imagined hydraulic press brake uses a normal motion controller, an independent safety controller, a monitored hydraulic manifold and separately specified cylinder-base anti-cavitation devices. A maintenance task requires work near an elevated ram and a hydraulic connection. Exact hardware, hydraulic schematic, stored-pressure zones, service isolation and ram support are deliberately unknown.

**Physical safety question:** What independent facts must be established before a person can be exposed to the ram and pressurized connection, and what can a valve-position feedback bit legitimately prove?

## Cumulative package entries — instructional IDs only

| ID | Record | Evidence and disposition |
|---|---|---|
| `BND-001` | Production stopping versus maintenance under elevated beam; person can reach a cylinder connection. | Fictional boundary, for exercise only. |
| `ENE-001` | Gravity load from elevated beam; independent of electrical power. | INFERENCE (mechanical principle), magnitude UNKNOWN. |
| `ENE-002` | Hydraulic pump, pilot supply, trapped fluid, possible accumulator. | Installed presence/routing UNKNOWN. |
| `HAZ-001` | Crushing from unexpected beam movement during maintenance. | Hazard scenario, machine likelihood UNKNOWN. |
| `HAZ-002` | Injection/ejection from release of trapped hydraulic pressure. | DOC-CONFIRMED hazard class via HAWE B 5488/D 6368; installed magnitude UNKNOWN. |
| `SF-001` | Prevent hazardous beam motion while servicing exposes personnel. | Requirement candidate; actual protective mechanism UNKNOWN. |
| `SF-002` | Prevent hazardous hydraulic pressure release during servicing. | Requirement candidate; actual isolation/discharge method UNKNOWN. |
| `PHY-001` | Beam load is physically restrained by a qualified means for the service task. | NOT ESTABLISHED; valve status cannot prove. |
| `PHY-002` | All relevant service-exposed pressure zones are rendered safe and remain safe. | NOT ESTABLISHED; one gauge port cannot prove. |
| `SRS-001` | Independent safety demand/response for production; final element and physical stopping/holding acceptance criteria to be defined. | BLOCKED — selected-machine design evidence missing. |
| `SRS-002` | Maintenance isolation, personal control, residual-energy and load-restraint procedure. | BLOCKED — installed energy map/procedure missing. |
| `AUTH-001` | LinuxCNC/HAL/normal FPGA owns ordinary motion requests and displays diagnostics; independent safety controller owns safety demand; selected physical final elements and isolators act on energy. | Architecture rule; exact hardware UNKNOWN. |
| `DEP-001` | Common pilot pressure, valve drive supply/reference and shared sensor wiring may affect both actuation and feedback. | INFERENCE / investigation requirement, not a known installed fault. |
| `DEP-002` | Gauge tap and pressure zone connectivity; possible check valves or isolated volumes. | UNKNOWN; requires selected drawing and inspection. |
| `ARC-001` | Proposed monitored manifold plus independent mechanical restraint and selected energy-isolation method. | CANDIDATE, NOT FROZEN. |
| `VAL-001` | Independent observed beam/restraint proposition on safety demand and service state. | NOT RUN; no numerical criterion invented. |
| `VAL-002` | Independent verified pressure-zone proposition before service, including reaccumulation. | NOT RUN; selected pressure map required. |
| `VAL-003` | Contradiction: expected monitored-valve feedback but beam/pressure witness fails. | DESIGN-ONLY; expected disposition: PHY-001/002 NOT ESTABLISHED, no rearm/release. |
| `PT-001` | Inspection/verification of instrument target, calibration, gauge tap, electrical independence and selected test scope. | NOT RUN; no interval invented. |
| `HF-001` | Poorly placed pressure ports and non-removable guards motivate unsafe shortcuts. | INFERENCE; design improvement: labeled accessible test points, safe visual access, captive/hinged guards. |
| `RR-001` | Residual crushing/injection hazard while physical witnesses absent. | OPEN — no personnel-exposed operation. |
| `UNK-001` | Exact manifold and NSV codes, optional branches, pilot pressure and pressure topology. | SCHEMATIC / MACHINE-VALIDATION BLOCKING. |
| `UNK-002` | Exact beam load, physical restraint, sensor independence, accepted safe-state criteria. | MACHINE-VALIDATION BLOCKING. |

## Validation/acceptance architecture (not a test procedure)

The engineering package must specify, for each physical proposition, the intended safe state, acceptable observed evidence, instrument/source provenance, relevant energy-zone coverage, potential common causes and a fail disposition. The validation plan may then include controlled demand, single-fault, common-cause and plausible-but-wrong feedback cases. Actual hazardous testing requires a separately approved isolation/remote test plan, qualified personnel and site controls; this document does not authorize or prescribe such testing.

| Evidence offered | Narrow claim it may support | Machine claim it cannot alone establish | Correct disposition |
|---|---|---|---|
| Monitored valve reports expected position | Targeted valve sensor indicates expected state, subject to exact wiring/diagnostics | Beam standstill, load support, pressure absence, safe access | Keep PHY-001/002 OPEN pending physical witnesses. |
| Gauge at manifold port reads low | Pressure at a verified port at a particular time | Every cylinder chamber/accumulator pressure zone is safe | Trace port connectivity and reaccumulation before credit. |
| LinuxCNC says E-stop/disabled | Normal software control state | Independent safety function completed or mechanical restraint engaged | No personnel-safety credit. |
| Accumulator discharge command | Command issued to a selected output | Discharge path open or pressure safely dissipated | Require independent selected feedback/physical evidence. |
| Beam witness disagrees with valve feedback | An unresolved evidence contradiction | Cannot dismiss either without investigation | Mark required PHY NOT ESTABLISHED; block rearm/release. |

## Change-control attack

**Change:** an NSV is replaced by a superficially similar part with a different suffix, or a gauge is moved to another port. The controller still reports `all valves OK`.

Open `CHG-001`; mark dependent `DEP-002`, `PHY-002`, `VAL-002`, `PT-001` **STALE** and review `ARC-001`, `SRS-002`, `HF-001`, `RR-001`. A code change or sensor move can alter the physical energy path or the meaning of a measurement without changing a controller status bit. Do not retire `UNK-001` until the actual installed component and connection are established.

## Human-factors acceptance test

The technician should be able to identify the energy-isolation point, locate the correct physical pressure witness, verify beam restraint, restore guards, and document the result without improvising fittings, defeating sensors, guessing gauge ports, or working beneath an unproved suspended load. If this workflow is awkward enough that people predictably bypass it, treat that as a `HF-*` design defect requiring redesign rather than another warning label.

## Transfer across machines

- **Vertical mill:** spindle/tool clamp pressure and drawbar position are distinct from actual tool retention; spindle coast and service isolation are separate.
- **Robot cell:** a hydraulic gripper's valve feedback is distinct from payload retention; gravity and perimeter occupancy add hazards.
- **Pneumatic feeder:** solenoid status differs from downstream trapped air and unexpected feed motion; controlled repressurization and restart remain separate.
- **Plasma table:** an electrical contactor or LinuxCNC disable is not proof that all process gases, fumes, thermal energy and power sources are safe for service.

Do not copy the press-brake's hypothetical energy paths, PL/SIL targets or physical witnesses into another machine without its own `BND/ENE/HAZ/SF/PHY` derivation.

## Evidence, sources and information-separation decision

Manufacturer claims: HAWE D 6335 rev 1.1 pp. 4–5, 9, 13–14; D 6368 rev 1.3 pp. 4, 6, 8, 24; B 5488 rev 3.1 pp. 4, 7–8, 17, 22. OSHA 29 CFR 1910.147(d)(5)–(6). These are **DOC-CONFIRMED** where described in the companion research. Hypothetical machine facts are **INFERENCE** or **UNKNOWN**, not SOURCE/TEST-CONFIRMED. No hidden evaluator solution was inspected; this is a development/teaching exercise and cannot be counted as a blind competency score.

**Graduation/release:** This exercise does not change 2580 READY FOR EXTERNAL/FRESH EVALUATION, 2520–25F0 external gates or the NOT FROZEN schematic status. The next real evidence is a selected public-safe circuit, instrument-port map and independent physical witness plan.

## Pinned LinuxCNC source boundary reused (not a new runtime test)

Repository research `research/linuxcnc-iocontrol-estop-callflow-2026-09-15.md` pins upstream LinuxCNC revision `d1a9d7d04cc274bfb5082caee6accc2489607418`. Its inspected `Task::iocontrol_hal_init()`, `Task::emcAuxEstopOn()`, `Task::emcAuxEstopOff()`, periodic `Task::run()` and `estop_latch.comp` establish the ordinary `user-enable-out`, pulse-like `user-request-enable`, and `emc-enable-in` handshake. **SOURCE-CONFIRMED at that pinned revision** is the software request/feedback behavior, not safety certification. A plausible `emc-enable-in` cannot establish a hydraulic final element's physical state or personnel-safe access. No source claims are extended to other LinuxCNC revisions without rechecking.
