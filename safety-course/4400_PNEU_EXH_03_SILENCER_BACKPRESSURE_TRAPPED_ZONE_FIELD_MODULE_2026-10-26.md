# PNEU-EXH-03 field module — The valve vented; did the pressure zone?
**PUBLIC PAPER ONLY / NON-GRADUATED. 10 scenarios UNSCORED, 10 documentary gates NOT RUN.** [Direct Parker/SMC/ROSS manufacturer audit](../research/4400_PNEU_EXH_03_PARKER_SMC_ROSS_CLOGGED_EXHAUST_TRAPPED_ZONE_AND_RESET_SOURCE_AUDIT_2026-10-26.md).

## Competency
Separate **normal LinuxCNC command**, **independent safety-output demand**, **valve actuation**, **actual exhaust flow**, **every trapped pressure zone**, **gravity/workpiece holding**, **service energy isolation** and **deliberate restart**. A clean valve sensor is not a whole-machine physical safe-state witness.

## Ten adversarial public paper scenarios — UNSCORED
1. A guarded robot cell E-stop causes the safety valve's position feedback to change, but a pneumatic cylinder remains pressurized. Which downstream obstructions/pressure zones must be considered?
2. An exhaust muffler fills with oil/dust. Explain how output/valve status can remain healthy while stop performance deteriorates.
3. A mechanic removes the silencer permanently to make exhaust faster. Identify noise/maintenance/flow verification and bypass incentives; propose a safer accessible OEM-compatible solution.
4. An SMC DXT1215 ordinary valve is labeled 'safety' in a retrofit drawing. What does its own manual actually permit and prohibit?
5. A Parker P33 safety exhaust product is assumed to be an E-stop final element. Explain the manufacturer's explicit distinction between energy isolation and emergency stop.
6. A check valve is discovered between a monitored exhaust valve and a clamping cylinder. Why does upstream pressure-zero not establish safe clamp release/holding?
7. A pneumatic gripper holds a heavy workpiece with air pressure. Should the E-stop always dump pressure immediately? Identify competing drop/hold hazards and physical support.
8. A soft-start feature is installed and the held cycle-start command persists after air restoration. Identify the fresh-start authorization boundary.
9. A residual-voltage reading is compared to SMC's 3% recommendation. Why is that a product-specific DXT1215 criterion, not a universal safe-state threshold?
10. A technician must remove a guard to change a silencer. Propose a captive, accessible, correctly rated maintenance redesign and the change-control/revalidation it triggers.

For every response: hazard, energy path, evidence label, normal vs independent safety authority, physical witness, UNKNOWN and HOLD criterion. No numerical pressure/flow/stop time invented.

## Ten desk verification gates — NOT RUN
| ID | Required qualified selected-machine evidence | Status |
|---|---|---|
| PNEU-EXH-V01 | Dated proof of relevant pneumatic equipment or N/A | NOT RUN |
| V02 | Exact valve/variant/safety function, current OEM manual | NOT RUN |
| V03 | Full pneumatic zone/port map including check/closed-center devices | NOT RUN |
| V04 | Exhaust silencer type, rated flow, clogging and service access | NOT RUN |
| V05 | Coil/suppression/leakage and independent safety-output compatibility | NOT RUN |
| V06 | Pressure witness for every isolated downstream hazardous zone | NOT RUN |
| V07 | Physical cylinder/gripper/tool load support after venting | NOT RUN |
| V08 | E-stop versus lockable maintenance isolation separation | NOT RUN |
| V09 | Fresh restart after air return, fault and guard reset | NOT RUN |
| V10 | Qualified validation, cleaning/replacement schedule and CHG record | NOT RUN |

**No pressurization, venting, fault injection, machine motion or lab compute authorized.** If basic safe-to-operate threshold cannot be met, no personnel exposure; isolated/remote experimental operation only under a separately qualified plan. G0/G1 HOLD.
