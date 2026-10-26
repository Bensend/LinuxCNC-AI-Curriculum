# 4400 PNEU-COLD-01 — cold-weather exhaust and conflicting OEM specifications

Date: 2026-10-26. **Public non-blind technician field card, NOT SCORED.** Read the [direct-source audit](../research/4400_ROSS_18_QUICK_EXHAUST_FREEZE_AND_CONFLICTING_TEMPERATURE_OEM_SCOPE_AUDIT_2026-10-26.md) and the prior [PNEU-MUFFLER maintenance extension](../research/4400_PNEUMATIC_EXHAUST_SILENCER_CLOG_MAINTENANCE_DRIFT_OEM_RECONCILIATION_2026-10-26.md).

## Core lesson

A pneumatic valve advertised for cold ambient operation can still have an exhaust path that freezes when moisture is present. A catalog contradiction is an engineering **UNKNOWN**, not an invitation to pick a convenient rating. Valve OFF/READY is not independent pressure/load evidence. The selected safety function may require pressure removal, controlled venting, physical load holding or a combination; identify it before choosing a device.

## Six paper-only technician scenarios — UNSCORED

1. **Contradictory table:** ROSS page prose says -40 °F; adjacent table says 40 °F while showing -40 °C. Record the conflict, selected part/edition, and obtain OEM clarification before cold qualification. Do not convert one into an invented acceptance rating.
2. **Wet air and freezing:** A cylinder exhaust slows only on cold mornings. Separate source-confirmed manufacturer moisture/icing warning from untested hypotheses about actual machine fault; preserve HOLD until safe no-energy review and approved physical validation.
3. **Healthy output:** Safety controller drops the solenoid, but an exhaust port is ice-blocked. Explain why electrical safety output and physical pressure decay are different propositions; independent witness required.
4. **Cold bypass temptation:** Operator proposes leaving a guard open to access/heat a frozen valve. Reject bypass; redesign access, air preparation and maintenance response so safe servicing is straightforward.
5. **Loss-of-air load:** A gripper holding a part releases when air vents normally. Explain why fast vent alone is not safe and why independent mechanical retention is needed for that load.
6. **False transfer:** A hydraulic press-brake Y1/Y2 safety report cites ROSS pneumatic 18 Series cold rating. Reject product/machine transfer; require hydraulic as-built and qualified stop/hold evidence.

## Seven documentary gates — all NOT RUN

| Gate | Required qualified evidence | Status |
|---|---|---|
| C1 | Actual machine/actuator and physical safe-state proposition, exposed person/task | NOT RUN |
| C2 | Exact installed part number, manufacturer manual revision, and resolved contradictory ambient/media rating | NOT RUN |
| C3 | Compressed-air moisture/pressure dew point and lowest expected valve/exhaust conditions | NOT RUN |
| C4 | Port 3, exhaust silencer/remote vent, air treatment, check valves and all trapped volumes traced | NOT RUN |
| C5 | Independent personnel-safety authority and load retention distinguished from normal LinuxCNC/FPGA diagnostics | NOT RUN |
| C6 | Qualified physical pressure/stop/hold witnesses and environmental acceptance method, no invented numeric values | NOT RUN |
| C7 | Accessible lockable maintenance isolation, safe cold-start, guard restoration and deliberate restart | NOT RUN |

No tests, simulations, external evaluation or physical commissioning were performed. A machine that cannot establish a basic minimum safe-to-operate threshold must not operate with people exposed. Experimental operation, if later justified, must be isolated/remote with all people outside danger zones and residual risk stated. **OpenPressBrake selected equipment UNKNOWN; G0/G1 HOLD.**
