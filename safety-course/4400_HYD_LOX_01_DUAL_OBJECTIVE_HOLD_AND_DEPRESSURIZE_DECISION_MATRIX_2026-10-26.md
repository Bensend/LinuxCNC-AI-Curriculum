# HYD-LOX-01 — Dual-objective hydraulic hold and energy-release matrix
**2026-10-26 | PAPER ENGINEERING AID / NOT A PRESS-BRAKE SERVICE PROCEDURE.**

| Objective | Required witness | Dangerous shortcut |
|---|---|---|
| Stop commanded movement | Independent protective stop and final-element evidence | Treat HMI STOP as load holding |
| Prevent gravity descent | Qualified holding circuit, physical support and line-break fault review | Treat upstream hydraulic STO as ram lock |
| Prevent maintenance reenergization | Personal lockable energy isolation and verified boundaries | Treat software inhibit as LOTO |
| Release trapped fluid energy | Qualified zone-specific bleed/isolation proof and pressure witnesses | Infer all chambers from upstream zero gauge |
| Preserve support during release | Independently rated restraint and approved service state | Vent a load-bearing chamber first |
| Restore operation | Guards, bypasses, physical zone clear, distinct reset and fresh start | Treat pressure restoration as motion authorization |

**Sources:** [ROSS](../research/4400_ROSS_HYDRAULIC_LOX_T1_T2_BLEED_VS_CYLINDER_HOLD_ISOLATION_SOURCE_AUDIT_2026-10-26.md), [Parker](../research/4400_PARKER_HAS_LOAD_HOLD_CODE_N_MANUAL_RELEASE_PO_CHECK_AND_TRAPPED_PRESSURE_OEM_AUDIT_2026-10-26.md), [Bosch](../research/4400_BOSCH_REXROTH_STOM_HYDRAULIC_STO_SDE_SLS_VS_RAM_HOLD_OEM_SCOPE_AUDIT_2026-10-26.md). Product statements DOC-CONFIRMED, matrix INFERENCE, selected machine UNKNOWN, tests none. G0/G1 HOLD.