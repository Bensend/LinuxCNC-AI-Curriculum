# HYD-HOLD-01 — Six-state stop/hold/isolation/rearm authority matrix
**2026-10-26 | DESIGN PATTERN, NOT INSTALLED MACHINE VALIDATION.**

| State | Ordinary LinuxCNC/FPGA | Independent safety-related control | Physical hydraulic/mechanical evidence | Fresh motion authorization |
|---|---|---|---|---|
| A. Normal operation | Motion commands and diagnostics | Risk-derived protective functions armed | Holding circuit, load/guard configuration qualified | Valid run request under safeguards |
| B. Protective stop | Commands stop; may cease control | Independent safety stop and final-element monitoring | Verify gravity retention; upstream shut-off not enough | No automatic restart |
| C. Electrical power loss | Normal output may vanish/stale | Deenergize-to-safe where appropriate | Load may still move without actuator-side holding/support | New deliberate start after recovery |
| D. Hydraulic line/pilot fault | Alarm may be absent/delayed | Fault detection/stop where designed | Actual hose location, retained pressure and mechanical load path govern | Hold pending qualified fault resolution |
| E. Maintenance isolation | HMI status informational only | Prevent unexpected energization | Personal LOTO, rated support, verified pressure zones, no suspended unrestrained load | No ordinary operation until release complete |
| F. Rescue/return to service | Normal control not rescue authority | Independently controlled fault recovery | Safe load support, controlled access, qualified restoration | Separate reset, clear-zone verification, new local start |

**Adversarial checks:** no output or software state substitutes for physical load retention; no shut-off label substitutes for maintenance isolation; a trapped-pressure holding valve is not a zero-energy witness; reset is not start; no one enters a gravity hazard zone without qualified independent restraint.

**Evidence:** [Parker source audit](../research/4400_PARKER_HAS_LOAD_HOLD_CODE_N_MANUAL_RELEASE_PO_CHECK_AND_TRAPPED_PRESSURE_OEM_AUDIT_2026-10-26.md) and [Bosch source audit](../research/4400_BOSCH_REXROTH_STOM_HYDRAULIC_STO_SDE_SLS_VS_RAM_HOLD_OEM_SCOPE_AUDIT_2026-10-26.md). OEM statements DOC-CONFIRMED, this matrix INFERENCE, selected machine UNKNOWN. **No tests or compute. G0/G1 HOLD.**