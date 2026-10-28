# 4400-ANALOG-QUEUE-01 — An M68 OFF is not an independent safe OFF
**Technician / integrator one-pass field card | 2026-10-28 | source analysis, no machine test**

Read the [exact LinuxCNC v2.9.10 source audit](../research/4400_ANALOG_QUEUE_01_LINUXCNC_2910_M67_M68_PENDING_REASSERTION_AND_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-28.md) after the existing [M62–M65 digital-output audit](../research/4400_LINUXCNC_PINNED_M62_M65_DIO_MOTION_QUEUE_VS_LASER_SAFETY_INHIBIT_SOURCE_TRACE_2026-10-25.md).

**Hazardous misconception:** “I sent M68 E0 Q0, so the analog actuator is safely off.” At the inspected source revision, **M68 writes the normal analog pin immediately but does not cancel an earlier M67 value waiting for the next motion**. An earlier M67 can therefore reassert a different value when motion starts, absent an intervening abort or other relevant command. This is a **source-derived conditional**, not a demonstrated OpenPressBrake failure.

| Distinct event | What it establishes | What it does NOT establish |
|---|---|---|
| M67 E0 Q… | Pending normal analog value for next motion; later M67 on same channel overwrites it | Immediate output change, safety inhibit |
| M68 E0 Q0 | Immediate normal analog request, with possible blending interruption | Cancellation of pending M67, physical zero energy, valve closed |
| LinuxCNC program pause/abort | Ordinary Task/Motion sequence effects; abort clears TP pending synchronized I/O in inspected code | All downstream outputs physically off, hydraulic ram held |
| HAL pin or FPGA “zero” | Software/driver command state, if correctly wired | Independent monitored stop/hold, guard permission, energy isolation |
| Qualified safety chain and physical witness | Only if selected and validated for the actual hazard | No generic PL/SIL or stop distance can be inferred from this card |

**Simple safer architecture:** treat analog outputs as process setpoints only. Route personnel-protective stop and guard access through independent qualified safety logic and correctly selected physical final elements, including a gravity-load holding strategy where applicable. Label the normal analog channel “PROCESS COMMAND — NOT SAFE OFF.” Keep the guard and safe service procedure easier to use than bypassing it.

**Desk-only reviewer prompt (UNSCORED):** a G-code macro sends a queued analog value, then an immediate zero, then a motion command. Before anyone claims safe access, identify pending-command state, physical final element, independent stop/hold, guard state and deliberate rearm. Do not run this scenario on a hazardous actuator. No new evaluator score is awarded.

**Release boundary:** actual OpenPressBrake analog mappings, Pilz/AKAS/K1/K2/EDM, Y1/Y2 final elements, independent stop/hold and selected-machine witnesses remain **UNKNOWN**. **G0/G1 HOLD; no personnel-exposed hazardous operation.** No test, runner dispatch, simulation or physical operation.
