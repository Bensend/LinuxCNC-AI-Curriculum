# 4400-DSEDM-01 — 12-gate no-energy design/change review
**2026-10-25 | DESK-ONLY | all gates NOT RUN | no ignition, no power-on, no hazardous motion**

Purpose: review a selected die-sinking or oil-wire EDM concept *before* any qualified energized validation. Use [Makino original OEM audit](../research/4400_MAKINO_EDGE3I_SINKER_EDM_DIELECTRIC_FIRE_Z_STARTUP_AND_VARIANT_OEM_AUDIT_2026-10-25.md). No generic thresholds are supplied for another machine.

| Gate | Desk evidence to request | Failure/hold rule | Status |
|---|---|---|---|
| G01 Boundary | Model/serial/manual/SDS, dielectric type, fixture and exposed people | Missing exact edition/fluid -> HOLD | NOT RUN |
| G02 Hazard geometry | Spark, electrode shank, workpiece, tank, rising/descending axes and blind spots | Green level sensor alone -> HOLD | NOT RUN |
| G03 OEM settings | Exact fluid, immersion and temperature instructions, change provenance | Borrowed setpoint from another model -> HOLD | NOT RUN |
| G04 Level protection | Selected sensor/diagnostics and location relative to actual discharge | False-high or unreachable local fluid region -> HOLD | NOT RUN |
| G05 Temperature protection | Selected sensor, response to open/short/stale input, actual hot spots | Last-valid HMI reading treated as physical witness -> HOLD | NOT RUN |
| G06 Abnormal discharge | Selected gap/arc detector and generator's physical inhibition path | Software alarm with no qualified final element -> HOLD | NOT RUN |
| G07 Fire mitigation | Detector type, extinguisher agent, nozzle location, service/charge records | Moved/obstructed nozzle or unknown charge -> HOLD | NOT RUN |
| G08 Guard/access | Tank, pendant dock, setup/cleaning access, defeated guard incentives | Guard must be bypassed for routine legitimate task -> redesign/HOLD | NOT RUN |
| G09 Stop semantics | E-stop, ordinary stop, fire demand, pump stop, actual spark-energy path | Commanded OFF equated with physical safe state -> HOLD | NOT RUN |
| G10 Power-return motion | Exact Z “break” wording resolved from OEM drawing; pump startup and safe occupancy | Mechanical release assumed harmless -> HOLD | NOT RUN |
| G11 Service isolation | Lockable electrical/fluid/motion isolation, residual-energy points, recovery | HMI OFF substituted for LOTO -> HOLD | NOT RUN |
| G12 Fresh restart/change | Repair, nozzle/sensor restoration, configuration hash/revision, occupancy, independent rearm/start | Reset/power return reissues retained machining -> HOLD | NOT RUN |

### Evidence and safety protocol
Every gate needs **document ID/revision, selected component/firmware, claimant, reviewer, date, fault path, independent physical witness proposed, and open unknowns**. Mark STALE if any machine/fixture/fluid/sensor/nozzle/control configuration changes. The reviewer should explicitly separate process readiness, safety-function reaction, suppression performance and maintenance isolation.

No one should conduct an ignition, fire-suppression discharge, sensor bypass, axis-drop, or other hazardous live experiment from this worksheet. Such tests require qualified machine-specific engineering, approved non-hazardous alternatives where possible, independent witness instrumentation, isolation/remote controls and a documented residual-risk plan. This worksheet is a **preflight review**, not a proof-test script.

### Outcome
G01–G12: **NOT RUN**. Selected machine and G0 physical evidence **UNKNOWN**. No independent evaluation, no laboratory compute, no permission for people-exposed operation.
