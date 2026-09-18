# HAWE ePRAX monitored hydraulic commissioning fault card

Date: 2026-09-18
Status: durable 4000 safety-course evidence/application artifact

## Purpose

Turn the professional HAWE ePRAX modular evidence into a bounded commissioning/fault-injection method without importing HAWE machine values into OpenPressBrake.

## Evidence basis and provenance

**DOC-CONFIRMED — HAWE B 6340, current English operating/assembly documentation.** The cylinder module lists QM2/QM3 as 2/2 directional seated valves, QM4/QM5 as 4/2 directional spool valves, corresponding position switches BG2/BG3/BG4/BG5, solenoids MB2/MB3/MB4/MB5, and pressure sensor BP1. The optional SLOWUP module contains a diaphragm accumulator CM1 plus its own valve/check/orifice/pressure-limiting elements.

**DOC-CONFIRMED — HAWE product documentation.** ePRAX modular is a press-brake ram-cylinder drive; each axis has its own servomotor/drive, and return stroke can deliberately use temporarily stored hydraulic energy. Therefore loss of electrical drive command is not equivalent to absence of hydraulic stored energy.

**INFERENCE, bounded.** A commissioning test should compare command, valve-position witness, pressure witness, and observed load/beam behavior as separate evidence layers. No one layer should silently substitute for another.

**UNKNOWN for OpenPressBrake.** Installed valve topology, cylinder porting, accumulator presence/volume/precharge, safe-state truth table, pressure thresholds, allowable leakage/drift, stopping time/distance, required PL/SIL/category, sensor diagnostic coverage, maintenance restraint, and actual safety-controller I/O mapping.

## Evidence ladder

For each safety-related hydraulic element preserve these layers separately:

1. safety demand exists;
2. independent safety controller output changes;
3. coil/actuator electrical state changes;
4. BG position witness reports the valve element reached the expected state;
5. hydraulic path is physically in the intended configuration;
6. BP/local pressure evidence supports the claimed pressure state for the claimed volume;
7. beam/load motion evidence supports the claimed physical result;
8. remaining accumulator/gravity/stored energy is identified;
9. reset/re-enable occurs only after fault clearance and required safety reset;
10. ordinary control requires a fresh intentional motion/start action where the machine design requires one.

Freeze: **COMMAND != COIL STATE != VALVE POSITION != HYDRAULIC PATH != PRESSURE STATE != LOAD STATE != ENERGY ABSENT.**

## Commissioning challenge matrix

| Challenge | Required observations | Passing interpretation | Forbidden overclaim |
|---|---|---|---|
| Normal safety demand from moving-capable state | safety input/output, MB state, BG2–BG5, BP, beam motion | documented safety path actuates and witnesses agree | `BG safe` proves pressure zero or maintenance safety |
| One safety-related valve commanded safe but BG does not reach expected state | command, coil, BG, safety diagnostic, re-enable behavior | discrepancy is detected and hazardous re-enable is prevented according to validated design | infer diagnostic coverage/timing not documented |
| BG stuck/replayed in expected state while command is changed | independent physical observation/test method plus controller diagnostic | test exposes whether position feedback can be trusted for the claimed fault class | software bit agreement proves spool/seat physically moved |
| Coil open/disconnected | command, electrical state/fault, BG, BP, beam | failure goes to or is detected before hazardous operation as required by design | coil OFF alone proves valve safe |
| Coil energized unexpectedly/stuck command | independent safety demand, BG, pressure, beam | independent safety architecture still establishes required physical state or prevents operation | ordinary LinuxCNC/FPGA watchdog is personnel-safety authority |
| Pressure sensor stale/frozen | BP plausibility/freshness plus valve witnesses and physical observation | stale/implausible pressure evidence is not accepted as proof of depressurization | zero-looking HMI value proves pressure absent |
| Valve witnesses correct but BP remains inconsistent with claimed decompression | BG2–BG5, BP, hydraulic schematic boundary | commissioning fails the decompression claim until the trapped/parallel energy path is resolved | safe valve state automatically empties every volume |
| Safety state established with beam stationary | BG, BP, measured/observed beam state over validated interval | supports only the validated functional holding claim | stationary beam proves no gravity hazard or maintenance restraint |
| Electrical drive power removed while hydraulic energy is retained | drive state, BP/accumulator evidence, beam/load | retained energy remains explicitly hazardous/controlled | servo OFF means energy-free |
| Restore control power after safety trip | safety state, feedback freshness, ordinary command state, beam | no stale ordinary command becomes a new motion intention; required reset/rearm/start sequence is preserved | power restoration equals start authority |
| Disconnect/restore BG channel | safety diagnostic, state transition, reset behavior | channel fault cannot be hidden by a reassuring HMI state | diagnostic message itself proves final-element state |
| Maintenance preparation | physical restraint/isolation, relevant pressure witnesses, accumulator discharge/isolation, restart prevention | task-specific hazardous energy is physically controlled and verified | functional safe state/STO is maintenance isolation |

## Adversarial combinations

Do not stop at single faults. Challenge combinations that can defeat a superficially good status display:

- one BG channel wrong while BP is stale;
- valve-position feedback agrees but a parallel/accumulator path remains energized;
- safety controller resets while ordinary LinuxCNC/FPGA command remains asserted;
- HMI/network freezes on the last good valve/pressure state;
- beam is stationary because of friction/load balance while the intended holding path is not proved;
- maintenance restraint is removed while functional safety still reports READY/SAFE;
- one axis reports expected valve states while the other axis is stale or faulted.

Any combination that cannot be safely induced on the real machine must be verified by an appropriate non-hazardous method (disconnect/test fixture/manufacturer diagnostic method) or remain an explicit validation gap. Do not create a dangerous physical fault merely to obtain evidence.

## Human-factors acceptance

The operator/maintainer display should name the bounded condition, e.g. `Y1 HOLD VALVE FEEDBACK FAULT`, `Y2 PRESSURE STATUS STALE`, `HYDRAULIC ENERGY NOT PROVED DISCHARGED`, or `MAINTENANCE RESTRAINT REQUIRED`, rather than collapsing these into a generic green `SAFE` lamp.

A bypass or diagnostic override must not be easier to leave active than the normal safeguard is to restore. If a test requires a temporary bypass, the commissioning record must include restoration proof before productive release.

## Minimum-operate gate

If a safety-related valve-position discrepancy can occur without detection before hazardous re-enable, or if the machine relies on a pressure/load-holding claim that has no adequate physical witness/validation, the affected operating mode is **DO-NOT-OPERATE with people exposed** until corrected. Experimental troubleshooting must keep people outside the danger zone and control residual stored/gravity energy.

## OpenPressBrake transfer rule

Use this card as a method, not a copied hydraulic design. Before applying any row to OpenPressBrake, first trace the installed schematic and label the actual cylinders/ports, source and return paths, blocking/holding/dump/prefill elements, accumulators, pressure witnesses, valve-position witnesses, safety outputs, maintenance restraint, and gravity-load path. Unknown items remain UNKNOWN.

## No compute decision

No simulation or runner job is justified by this artifact. The unresolved questions are physical topology, manufacturer behavior, and commissioning evidence questions; source/documentation/installed-machine tracing has higher information gain than synthetic simulation.
