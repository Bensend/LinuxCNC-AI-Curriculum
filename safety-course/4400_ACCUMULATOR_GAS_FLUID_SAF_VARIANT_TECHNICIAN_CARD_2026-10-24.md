# 4400-ACC-02 — 18 technician scenarios: gas/fluid boundaries and SAF variant substitution
**PAPER ONLY / learner-visible / 2026-10-24. No physical execution, blind score or release authorization.**

For each case write: hazard; observed versus inferred fact; selected energy zone; normal/safety/physical/worker authority; one discriminating witness; required HOLD or further action. Do **not** invent a pressure, valve truth table, response time or PL/SIL. Work from [ACC-02](4400_ACC_02_GAS_FLUID_DISCHARGE_VARIANT_AND_SERVICE_AUTHORITY_MODULE_2026-10-24.md), [Parker source audit](../research/4400_PARKER_PVSI_GAS_FLUID_RESIDUAL_ENERGY_DISASSEMBLY_OEM_AUDIT_2026-10-24.md) and [HYDAC variant audit](../research/4400_HYDAC_SAF_Y_Z_BLEED_VARIANT_AND_PHYSICAL_WITNESS_AUDIT_2026-10-24.md).

| ID | Scenario / adversarial premise | Required discriminator |
|---|---|---|
| ACC-01 | Pump disconnect locked OFF; accumulator tap not checked. 'Hydraulic energy is gone.' | Stored energy and tap-to-zone map. |
| ACC-02 | One pressure gauge reads zero after drain; cylinder A chamber isolated by check valve. | Independent chamber/isolated volume verification. |
| ACC-03 | Fluid-side gauge reads zero; gas-side cap remains fitted. 'Vessel can be opened.' | Separate qualified gas-side service proof. |
| ACC-04 | Gas-side charge reportedly released; oil-port resistance is encountered. 'Use more force.' | Manufacturer stop sign and qualified escalation. |
| ACC-05 | Parker safety-block fluid gauge zero; technician assumes every auxiliary hydraulic line is zero. | Exact connected zone, pilots, accumulators, check valves. |
| ACC-06 | HYDAC SAF code ends in Y; service orders Z as 'equivalent'. | Catalog Y/Z state, CHG/STALE review, physical revalidation. |
| ACC-07 | E model replaced by M with identical mounting. | Loss of automatic discharge path. |
| ACC-08 | Solenoid de-energized and marked normally open; return line blocked. | Actual flow path and independent fluid pressure witness. |
| ACC-09 | Safety PLC reports 'bleed valve open'; gauge is an optional feature not installed. | External qualified measurement plan, not PLC image. |
| ACC-10 | Relief valve lifted once. 'This means the accumulator is depressurized.' | Overpressure versus isolation/discharge functions. |
| ACC-11 | An accumulator supplies protective retract after pump failure. 'Always dump instantly on E-stop.' | Selected SRS, safe motion result, load restraint and later service boundary. |
| ACC-12 | Bleed command opens with gravity-held ram and no restraint proof. | Separate PHYSICAL HOLD before hazardous access. |
| ACC-13 | A pressure gauge reads low once, then a thermal/return-feed condition may change. | Reaccumulation review and continued verification. |
| ACC-14 | New gauge installed upstream of isolation valve; old acceptance test reused. | Port identity and CHG evidence invalidation. |
| ACC-15 | Nitrogen precharge service needed; unqualified operator proposes a makeshift gas line. | Qualified OEM procedure only, no improvised servicing. |
| ACC-16 | Two accumulators share a manifold; only one discharge path documented. | Per-vessel and per-zone energy inventory. |
| ACC-17 | E-stop reset returns normal control 'ready'; pedal still held. | Safety rearm separated from fresh normal start. |
| ACC-18 | Safe gauge point behind awkward guard; technician leaves guard off after service. | Design usable, protected test access and easy guard reinstatement. |

## Technician evaluation rubric (non-blind, not an answer key)
Award credit only for preserving the **fluid vs gas**, **Y vs Z**, **M vs E**, **command vs physical witness**, **safe stop vs service isolation**, and **fresh restart** boundaries; any unsupported 'safe to open', guessed numeric setting, or ordinary LinuxCNC safety authority is a critical miss. No self-score may be added to FEEDBACK_SCORE_LOG.

## Cross-machine transfer
For a mill's hydraulic drawbar, distinguish tool retention, spindle stop, hydraulic isolation and accumulator gas-vessel servicing. For a lathe, distinguish chuck grip from pressure indication and service pressure absence. For a press brake, gravity holding adds a separate independent proposition. No generic hydraulic truth table transfers across these machines.
