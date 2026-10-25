# 4400-SD-01 — A convenient diagnostic bus is not a safe guard-unlock authority
**Safety course / 4000 | 2026-10-25 | NON-GRADUATED | PAPER only**

## Learning objective
Trace five separate propositions: (1) the guard is physically closed; (2) the guard is mechanically retained; (3) the safety circuit prevents hazardous motion; (4) the hazard has independently stopped/been held and access may be granted; (5) a person inside can escape and motion cannot restart from a stale request. None follows merely from the previous LED or message.

## Exact original sources
Use [Schmersal/Pilz OEM audit](../research/4400_SCHMERSAL_SD_NONSAFE_LOCK_COMMAND_WARNING_DELAY_AND_PILZ_ESCAPE_SOURCE_AUDIT_2026-10-25.md) before teaching. The Schmersal 2023 serial diagnostics brochure depicts ordinary SD commands/telemetry **alongside** separate safety OSSD signals and says non-safe SD gateway lock/unlock can only serve process protection. It also distinguishes a noncritical diagnostic warning whose outputs may stay enabled from a safety-critical error. Pilz separately teaches conditional personnel unlock, power-loss lock retention and inside escape. These are **product/architecture-specific manufacturer statements**, not selected-machine proof.

## Four authority boundaries
| Layer | May legitimately do | Must NOT be treated as proof of |
|---|---|---|
| Normal LinuxCNC / FPGA / HMI / SD gateway | Request access, display warning, log door status | Safety-rated release, safe hydraulic state, personnel-clear, independent stop |
| Selected safety-related controller and I/O | Evaluate rated interlock/lock status, command rated final elements, enforce selected unlock permission | Actual ram gravity hold or machine release without verification |
| Final energy/mechanical elements | Physically stop/hold Y1/Y2, isolate hazardous energy, retain guard and permit escape | Safe configuration or person absence merely from contact feedback |
| Qualified witness/release | Verify as-built model, wiring, hazard geometry, faults, occupancy, reset and fresh start | Transfer of a vendor brochure's PL/SIL to an untested machine |

## Engineer the easy safe path
Provide a clearly labeled ACCESS REQUEST near the gate; show an understandable WAIT FOR SAFE STATE rather than inviting operators to tug the gate. Ensure the rated safety architecture, not LinuxCNC, determines permission to unlock when required for personnel protection. Provide a reachable **inside** escape route for full-body entry; a red lever only outside does not solve entrapment. Use mechanically secure and accessible mountings, documented replacement part numbers, visible fault descriptions, keyed/restricted service override, and mandatory physical restoration before normal mode. The practical goal is to make correct use less work than wedging an actuator or leaving a bypass.

## Six distinct faults to reason about
1. Normal SD unlock despite moving tool/ram: process command is not rated safe-unlock.
2. Warning on HMI: Schmersal brochure allows some noncritical warning periods before output shutdown; warning != physical safe state. Do **not** generalize the brochure's 30 minutes.
3. Power failure: retained locking may protect from overrun while simultaneously trapping someone; escape path must remain viable.
4. Gate replacement: matching connector and LED do not verify safety output, actuator coding, suffix, control mode or mechanical engagement.
5. Person behind a closed guard: status does not prove zone empty; deliberate occupancy verification and fresh-start separation are needed.
6. Maintenance release: guard unlocked for service is not hazardous-energy isolation; qualified LOTO, pressure verification and independent ram support remain separate.

## Machine transfer
- **Press brake:** Y1/Y2 asymmetric gravity load, front/rear access, foot-pedal and guard/laser safeguarding, hydraulic pressure and emergency lowering must each be assessed. A gate interlock cannot establish ram hold.
- **Mill/lathe:** spindle overrun, chuck/tool/projectile exposure and powered axes can demand different release criteria.
- **Robot cell:** full-body occupancy, trapped personnel, and inside escape can dominate even when motion stops.
- **Plasma table:** torch high voltage, fume extraction and fire/thermal hazards may persist after axis stop.
No single machine's stop time, access distance or PL/SIL is transferable.

## Competency test (not scored)
Explain why a serial "LOCKED" bit and a non-safe unlock telegram cannot be the entire personnel safety case. Produce a causal path from access request to qualified physical safe state, guard unlock, inside escape, zone-clear, independent reset and a new ordinary motion request. Cite the exact original OEM statements and list all selected-machine UNKNOWNs.

## Graduation and release
This is a **source-supported lesson**, not a graduated physical safety function. External blind evaluator NOT RUN; selected-machine G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. If physical stop/hold/escape cannot be established, **no operation with people exposed**. Any separately approved experiments must be isolated/remote with people outside the danger zone and residual risk assessed. No LinuxCNC or FPGA safety authority is created.
