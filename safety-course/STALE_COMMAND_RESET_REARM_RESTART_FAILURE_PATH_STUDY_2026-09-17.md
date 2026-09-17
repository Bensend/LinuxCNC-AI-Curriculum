# Stale-command reset / rearm / restart failure-path study

Date: 2026-09-17
Lane: independent safety curriculum Lane B

## Question

After a protective stop, E-stop, guard opening, safety fault, power interruption, or safety-controller reset, what prevents an old ordinary-control command from becoming hazardous motion as soon as safety authority returns?

## Evidence labels

- **SOURCE-CONFIRMED** — directly supported by an identified manufacturer/authoritative source.
- **DOC-CONFIRMED** — confirmed by an applicable machine/project document.
- **TEST-CONFIRMED** — demonstrated by a controlled test on the applicable machine/configuration.
- **COMMUNITY-REPORTED** — useful experience report, not design proof.
- **INFERENCE** — engineering conclusion derived from bounded evidence.
- **UNKNOWN** — not established for the installed OpenPressBrake machine.

## Manufacturer evidence

### SICK S3000 / safe-machinery guidance

**SOURCE-CONFIRMED:** SICK defines reset as restoring the protective device to monitoring/restart-interlock state after a stop demand. Reset must not itself introduce movement or a dangerous situation; machine start is a second step requiring a separate start command. SICK further states reset is permitted only when safety functions/protective devices are functional.

Sources:
- SICK, *S3000 Safety Laser Scanner Operating Instructions*, 8009942/ZD76/2025-08-19, glossary entries Reset and Restart interlock.
- SICK, *Safety Guide for the Americas*, section Application of reset and restart.

### SICK deTec4

**SOURCE-CONFIRMED:** deTec4 instructions warn against unexpected starting and require machine control to ensure that OSSD return after reset does not itself restart the machine. Reset and machine-start actions occur in the specified order.

Source: SICK, *deTec4 C4P-EAxxx3SC05 Operating Instructions*, 8028570/1RXH/2025-07-07, §4.4.1 Restart interlock.

### Pilz emergency-stop reset

**SOURCE-CONFIRMED:** Pilz states that releasing/resetting an actuated E-stop prepares the machine for restart but must not automatically restart it; starting requires intentional actuation of the designated command device.

Source: Pilz FAQ, *Emergency stop is operated on a machine*, article 180045.

## Architecture rule

Freeze these as distinct states/actions:

`PROTECTIVE DEMAND CLEARED` != `E-STOP DEVICE RELEASED` != `SAFETY RESET ACCEPTED` != `SAFETY OUTPUT AUTHORITY AVAILABLE` != `ORDINARY CONTROL REARMED` != `NEW START COMMAND` != `HAZARDOUS MOTION`.

A safety system may correctly restore its outputs while an ordinary controller still contains an old motion/output request. Therefore **safety reset alone is not evidence that the ordinary command path is safe to resume.**

For OpenPressBrake, LinuxCNC, HAL, FPGA registers, queued trajectory state, field-output latches, proportional-current requests, step/dir generation, VFD run commands, PLC bits, HMI toggles, network command buffers and drive-local commands are ordinary-control state unless separately proven otherwise. They must not be promoted to personnel-safety authority merely because they are deterministic or watchdog-monitored.

## Failure-path challenge matrix

| Challenge | Unsafe assumption | Required proof before acceptance | OpenPressBrake state |
|---|---|---|---|
| Guard opens while cycle command remains asserted | Guard closure/reset makes prior cycle safe to continue | Demonstrate command cancellation or deliberate new-start requirement across the complete chain | UNKNOWN |
| E-stop during maintained HMI/JOG command | Releasing E-stop makes the old command harmless | Show stale command cannot create motion merely from E-stop release/reset | UNKNOWN |
| Safety PLC resets while LinuxCNC stays powered | LinuxCNC state is automatically synchronized with safety state | Demonstrate generation/freshness/rearm contract and deliberate restart sequence | UNKNOWN |
| LinuxCNC restarts while FPGA/output board stays powered | Outputs cannot retain or replay prior requests | Verify startup defaults, freshness invalidation and explicit rearm | UNKNOWN |
| FPGA/watchdog recovers communications | Fresh communications equal permission to resume old command | Prove old command generation is rejected and a new deliberate command/rearm is required | UNKNOWN |
| Drive STO is removed while run/velocity command remains | STO removal is equivalent to a new start | Manufacturer/application proof must show the complete restart behavior; otherwise inhibit/cancel ordinary request before STO restoration | UNKNOWN |
| Hydraulic safety authority returns with proportional request nonzero | Valve command cannot resume unexpectedly | Prove command is zero/invalidated before ordinary hydraulic authority returns; physical response remains machine-test dependent | UNKNOWN |
| Power dip affects only one controller layer | All layers reset together | Test asymmetric power restoration and retained-state combinations | UNKNOWN |
| Reset pushbutton is mapped through ordinary HMI logic | HMI acknowledgement equals safety reset | Safety reset path and authority must be independently established | UNKNOWN |
| Operator presses reset from a location without hazard-zone visibility | Reset is only acknowledgement | Application must establish reset location/visibility and separate subsequent start behavior | UNKNOWN |

## Commissioning / validation questions

1. With a hazardous ordinary command active, cause each applicable protective demand independently. Does the hazardous result cease as designed?
2. Clear only the protective device. Does motion remain inhibited?
3. Perform only safety reset. Does motion remain inhibited?
4. Restore only safety output authority. Does motion remain inhibited until the defined ordinary-control rearm/new-start action?
5. Repeat with LinuxCNC, FPGA, safety controller, drive/control power and field I/O reset in different orders where the architecture permits those asymmetric states.
6. Repeat after communications loss/recovery and watchdog expiry.
7. Inspect whether queued motion, maintained jogs, HMI toggles, run bits, analog/current requests or field outputs survive the event.
8. Verify that a reset/rearm sequence cannot be collapsed into one ordinary software action where independent personnel-safety authority is required.
9. Record the actual observed physical result. A clean software state is not proof of safe hydraulic/mechanical state.

Actual timings, stopping distances, pressure behavior, valve truth tables, drive restart behavior, retained-state behavior and acceptance thresholds are **UNKNOWN** until applicable documentation and/or installed-machine testing establishes them.

## Practical OpenPressBrake design implication

**INFERENCE:** A robust architecture should treat a safety demand as a reason to invalidate ordinary hazardous-command freshness, not merely gate the final output temporarily. On recovery, safety authority may become *available*, but ordinary control should still need a deliberate rearm/new command generated after the stop/reset boundary. This reduces the chance that removing STO, restoring a safety relay, closing a guard, or recovering a watchdog turns an old command back into motion.

This is an architecture requirement candidate, not a claim that the present OpenPressBrake implementation already behaves this way.

## Boundary with servicing isolation

Restart interlock is not LOTO. Preventing stale-command restart does not prove electrical isolation, hydraulic pressure removal, blocked flow, held load, mechanical restraint, or absence of stored energy. Servicing tasks requiring hazardous-energy control remain governed by the separate isolation/verification procedure.

## Next evidence target

Trace one complete professional machine or drive application where safety demand, STO/safety output restoration, ordinary run/velocity command state, reset, and subsequent start are all visible. Prefer a manufacturer schematic/timing diagram that exposes whether the ordinary command must transition/reissue after STO or protective-stop recovery. Do not infer drive-specific restart semantics from generic STO descriptions.