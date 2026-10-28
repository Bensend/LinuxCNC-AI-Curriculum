# 4400-PHASE-MON-01 — Phase relay healthy is not pump rotation or safe restart
**2026-10-28 | one-pass technician/engineering field card | PAPER ONLY / NOT A LIVE TEST PROCEDURE**

Read [original manufacturer source audit](../research/4400_PHASE_MON_01_SIEMENS_3UG4511_3UG5512_R21_BACKFEED_RESTART_AND_PUMP_DIRECTION_AUDIT_2026-10-28.md) after [RST-01](4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md), [RST-UVR-01](../research/4400_RST_UVR_01_SCHNEIDER_MN_MX_DELAY_ANTIPUMP_REMOTE_RESET_SOURCE_ADDENDUM_2026-10-28.md) and the [hydraulic thermal audit](../research/4400_HYD_TEMP_01_CINCINNATI_PARKER_COLD_OIL_THERMAL_TRIP_HEATER_AND_STOP_PROOF_AUDIT_2026-10-28.md).

## Three independent questions, not one green light
1. **Is the electrical supply acceptable?** What exact relay/order code and monitored terminals? Siemens documents that 3UG4511 can miss phase failure when a motor backfeeds the missing phase; 3UG4512 and the specific **3UG5512-..R21** safety-function family have different claims. A similar **-..R20** label is not an interchangeable safety qualification.
2. **Is the pump turning correctly and doing what is expected?** The actual motor/pump direction, coupling and hydraulic function require qualified independent commissioning evidence. A line-side phase monitor does **not** sense pump-shaft direction or pressure.
3. **Is the machine safe to restart?** Automatic phase-relay recovery can restore an electrical permissive; it is **not** a new operator cycle demand. Independent protective-device state, safe physical stop/hold, area clearance and deliberate restart are separate.

## Eight paper review prompts (not scored, no fault injection)
| Prompt | Expected evidence discipline |
|---|---|
| A. A motor loses one phase but a 3UG4511 stays healthy | Identify Siemens-documented load-backfeed blind spot; do not claim detection. |
| B. Incoming phases are correct after a motor replacement | Check motor-to-pump direction and downstream wiring; no inferred shaft direction. |
| C. 3UG5512-..R21 re-energizes after a repaired phase | Separate relay auto-reset, independent safety rearm and fresh machine start. |
| D. Monitor output OFF while main contactor welded | Physical final element and energy-path witness must win over relay status. |
| E. Pump stopped, press-brake ram still gravity loaded | Independently engineered ram stop/hold and stored-energy control remain required. |
| F. Technician installs 3UG5512-..R20 instead of -..R21 | Exact suffix, manufacturer safety data and change-control gate; no generic family transfer. |
| G. Phase monitor is upstream of a drive | No claim it senses downstream motor phase order or actual rotation. |
| H. Extraction fan phase LED green | Prove actual required airflow/capture separately; no green-bit safety inference. |

## Practical change-control return-to-service record (restricted machine workspace)
Record **as-built relay type and full suffix**, electrical line-side vs load-side measurement location, motor starter/VFD/bypass topology, approved wiring change, actual pump/motor nameplate and direction witness, selected safety controller/final elements, contactor feedback, guard/area-clear/rearm, and the qualified physical stop/hold result. Use the OEM's qualified test method, never a public generic phase-swapping instruction.

**Simplest safe design:** clear permanent phase/rotation labels, accessible diagnostics, approved identical spares and a short post-electrical-work checklist. Make correct restoration easier than jumpering a monitor. If required physical protection cannot be demonstrated, **no personnel-exposed hazardous operation**; any authorized experimental work must be remote/isolated with everyone outside the danger zone and residual risk stated.

**Provenance:** Siemens 3UG4/3UG5 OEM indexed manual text, directly inspected Siemens 2025 application-example PDF/figure and Rexroth 2014 PGF/PGP OEM manual. **DOC-CONFIRMED** exact manufacturer scope, **INFERENCE** machine-transfer cases, selected OpenPressBrake **UNKNOWN**, **TEST-CONFIRMED none**, independent evaluator **NOT RUN**. **G0/G1 HOLD.**
