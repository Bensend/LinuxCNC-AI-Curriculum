# 4400-AIR-CLEAN-01 — dead-ended nozzle, chip guarding, mist and service: technician field module
Date: 2026-10-27 | Status: PUBLIC PRACTICE, NON-GRADUATED | 12 scenarios UNSCORED; 12 desk gates NOT RUN.

## Learning objective
Given a real cleanup job, distinguish (a) cleaning-nozzle static dead-end pressure, (b) flying chips/bystanders, (c) aerosol and noise, (d) machine-motion and compressed-air stored energy, and (e) deliberate restart. Select a low-defeat, low-cost safer workflow without assigning personnel-safety authority to an M-code, HAL output or FPGA.

**Read first:** [direct OSHA/manufacturer audit](../research/4400_AIR_CLEAN_01_OSHA_DEADEND_CHIP_GUARD_MWF_NOISE_SOURCE_AUDIT_2026-10-27.md). Cross-reference [MWF mist](4400_MWF_MIST_01_SPINDLE_STOP_VS_BREATHING_ZONE_CLEARANCE_FIELD_MODULE_2026-10-27.md), [pneumatic exhaust](4400_PNEU_EXH_03_SILENCER_BACKPRESSURE_TRAPPED_ZONE_FIELD_MODULE_2026-10-26.md), [audible noise](4400_ALARM_NOISE_01_AUDIBLE_WARNING_NOT_SAFETY_INTERLOCK_FIELD_MODULE_2026-10-26.md), and [safety package](SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md). The exact pneumatic-exhaust predecessor path should be verified before treating its name as a working link.

## Work the physical boundary before selecting a device
1. Define task: chip removal, drying, cleaning an enclosure, or maintenance. Identify whether hazardous motion can occur, whether guarding is open, and who else can be hit.
2. Prefer vacuum/containment to avoid generating a projectile/aerosol hazard. If compressed air is genuinely required, identify a purpose-designed nozzle/relief, **less-than-30-psi dead-ended static nozzle criterion for OSHA-covered cleaning**, chip guarding, and PPE.
3. Treat the gun operator, adjacent workers, downstream discharge, mist/particles and noise as distinct exposure routes. A nozzle shield alone may not protect people behind the workpiece.
4. A stopped machine, LinuxCNC M9 or a disabled FPGA output does not physically isolate compressed air, guarantee valve tightness, or prove a zero-energy servicing state.
5. For exposed service, apply the actual energy-control procedure, bleed/verify where applicable, restore guards and require deliberate fresh start. Do not invent universal pressure/stop-time limits or assume every ordinary guarded blow-off is LOTO.

## Twelve novel public paper scenarios — **UNSCORED**, no hidden answers
| ID | Given condition | Required reasoning / decision |
|---|---|---|
| AIR-01 | Gun supply 110 psi, OEM engineered relief nozzle, no proof of dead-ended static pressure | What does upstream pressure establish? What still must be verified? |
| AIR-02 | Line regulator reads 25 psi, added bypass tee feeds a second nozzle | Which physical branch matters? What observation is missing? |
| AIR-03 | Relief slots are taped to improve cleaning force | Identify defeat mechanism and low-friction design correction. |
| AIR-04 | Nozzle cone protects user, helper stands behind workpiece | Distinguish PPE from complete chip guarding. |
| AIR-05 | Blow-off dries coolant-wet parts inside open CNC door | Separate mist exposure from pressure and motion. |
| AIR-06 | M9 stops air request but supply hose remains pressurized | Define physical isolation and safe service witness. |
| AIR-07 | E-stop is pushed, worker reaches into fixture to clear chips | Distinguish hazardous-motion protection and service energy control. |
| AIR-08 | Supplier says 'OSHA approved 83 dBA safety nozzle' | Identify two distinct unsupported conclusions. |
| AIR-09 | Chip shield removed because it catches on tooling | Redesign accessibility/fixture geometry rather than accepting defeat. |
| AIR-10 | Air blast restarts after CNC reboot while guard open | Assign authority, stale-command inhibit and deliberate restart. |
| AIR-11 | Part is dry, but aerosol visibly hangs in enclosure | What is not proved by end of cycle? |
| AIR-12 | Hose disconnects during cleaning and swings toward operator | Identify independent stored-energy and hose-routing issues; avoid inventing a hose whip force. |

## Documentary verification gates — **NOT RUN**
| Gate | Required documentary/physical evidence before credit | Current |
|---|---|---|
| D1 | Actual machine applicability and cleaning task identified | NOT RUN |
| D2 | Nozzle OEM, revision, pressure/relief design identified | NOT RUN |
| D3 | Actual branch and regulator/relief topology mapped | NOT RUN |
| D4 | Qualified safe dead-end pressure verification method and acceptance defined | NOT RUN |
| D5 | Chip trajectories for operator **and** bystanders assessed | NOT RUN |
| D6 | Chip guard, PPE and easy-to-use containment selected | NOT RUN |
| D7 | Wet-chip/MWF aerosol applicability and capture assessment | NOT RUN |
| D8 | Noise measurement need and 85-action/90-PEL distinction documented | NOT RUN |
| D9 | Normal CNC/FPGA request versus physical final elements allocated | NOT RUN |
| D10 | Stored air, isolation, bleed and exposed-service modes reviewed | NOT RUN |
| D11 | Guard replacement and deliberate fresh restart sequence documented | NOT RUN |
| D12 | Change-control and damaged/modified nozzle replacement plan reviewed | NOT RUN |

## Fresh-learner handoff
For a novel air-gun cleanup setup, deliver a five-column hazard/authority/evidence/UNKNOWN/change-control table, not a compliance verdict from a vendor catalog. Mark all scenarios **UNSCORED** until independently assessed. The field module is not a permission to pressure-test a gun against skin, to bypass a guard, or to conduct a live hazardous-machine trial.

## Promotion
Machine-specific nozzle pressure, chip trajectories, aerosol and worker noise measurements require qualified selected-machine evidence. This is not promotable to a blanket 'safe to operate' claim; G0/G1 HOLD, evaluator NOT RUN.
