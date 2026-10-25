# 4400-TEACH-01 — Safety curtain teach-in, output restoration and stale protective distance
**4000 safety implementation | 2026-10-25 | NON-GRADUATED | manufacturer-documentary learning only**

## Prerequisites and learning outcome
Read 2520 hazard-to-SRS, 2530 deliberate reset/restart, 2590 guards/presence sensing, 4400-ESPE-02 blanking/effective resolution and 4400-CONFIG-01 change control. Then read the [original SICK 2026 / Rockwell 2024 audit](../research/4400_SICK_DETEC4_2026_TEACH_IN_AUTO_OSSD_AND_ROCKWELL_MICRO400_RESPONSE_TIME_AUDIT_2026-10-25.md).

A fresh engineer must distinguish **(1) teach-in acceptance; (2) OSSD output state; (3) independent safety rearm; (4) fresh motion authorization; (5) actual physical safe state** and recognize that a reconfigured curtain may need both a *different detection test* and a *new stopping-distance assessment*.

## The deceptively simple failure chain
```text
Fixture/tool changes -> authorized teach-in -> new optical map stored
          |                                   |
          v                                   v
   reach-through geometry changes      OSSD can become ON
          |                                   |
          v                                   v
 hard guard / effective resolution      safety chain may rearm
          |                                   |
          +----------> new stop-distance check
                                              |
                                   fresh motion command still required
                                              |
                                   independently validated final elements
                                              |
                                   physical stop / gravity hold / access
```
This is a conceptual teaching flow, **not** a validated wiring schematic.

## Five crucial source-grounded distinctions
1. **SICK deTec4 HG, 8023856/1SWC/2026-02-05, p.77:** after a valid fixed-blanking teach-in, the product automatically starts with stored configuration; without configured restart interlock its OSSDs go ON. **DOC-CONFIRMED** for that exact OEM product/feature; it does *not* say a press brake strokes.
2. **SICK p.77:** teaching with no object can deactivate fixed blanking. A technician cannot infer the active protective map from the last known job or the normal LinuxCNC HMI.
3. **SICK pp.72–73:** monitored blanking requires expected object occupancy, but an occupied blanked zone is still an optical hole. Reinstall a proper physical guard around the hole and verify the actual reachable volume.
4. **SICK pp.79–80:** unchanged effective resolution in the *remaining field* under fixed blanking with zero size tolerance does not restore coverage within the excluded region. Edge tolerances and mode changes can alter effective resolution.
5. **Rockwell Micro 400, 445L-IN005C-EN-P Jan. 2024 p.5:** blanking changes **response time as well as effective resolution** for its specified MSR42 integration. The old safety-distance result and receiver label become stale; include cascades and controller delays.

## Practical no-energy change-control procedure (not a performed test)
**Before:** identify exact sensor/controller/firmware; as-built mode and stored configuration; optical zone drawing; fixed guards, fixture/stock and alternate reach paths; actual machine stop/hold design and recorded independent validation. Confirm that teach-in is authorized and machine hazard energy is isolated/controlled under a qualified procedure.

**During:** do not accept an HMI green indicator as permission for exposure. Keep physical access isolated and prevent retained LinuxCNC start requests from energizing hazardous motion. Treat any teach-in or device replacement as a safety configuration change.

**After:** compare stored configuration with intended zone geometry; inspect each blanked slot and guard; use the exact manufacturer-required test rod and qualified inspection plan; recalculate/review protective distance using effective resolution and total response/stopping times; verify safety rearm is independent of OSSD ON and requires a fresh motion command; document responsible qualified witness and residual risk.

**Release:** documentary checks are not machine proof. Physical OpenPressBrake Y1/Y2 independent stopping, gravity hold, pressure zones, guard coverage and deliberate restart remain UNKNOWN; **G0/G1 HOLD**. If basic safe-to-operate threshold cannot be shown, no personnel-exposed operation; any experimental motion must be isolated/remote with people outside danger zone.

## Engineering allocation table
| Layer | May legitimately do | Must not be credited for |
|---|---|---|
| LinuxCNC / normal FPGA / HMI | show active job, request a stop, log configuration ID, prompt qualified inspection | sole personnel-safe reset/rearm, optical bypass, hydraulic holding |
| Sensor + rated receiver | detect within configured field, emit OSSDs under documented assumptions | reach detection through blanked aperture, measured machine stopping |
| Independent safety logic | gate reset/rearm and final-element demand to allocated SRS | proving physical stop by software state alone |
| Final elements / mechanics | implement verified stopping, energy removal, gravity holding and guards | certification from generic catalog statements |
| Maintenance isolation | lock out and restrain all hazardous energies under site plan | substituting for a validated production protective stop |

## Practice, provenance, and graduation
[18 open technician scenarios](4400_TEACH_01_EIGHTEEN_CHANGE_CONTROL_TECHNICIAN_CASES_2026-10-25.md) are **PAPER ONLY / UNSCORED**, not blind competency evidence. [12 documentary review gates](4400_TEACH_01_TWELVE_GATE_NO_ENERGY_CONFIGURATION_WITNESS_2026-10-25.md) are **NOT RUN**. Independent evaluator remains unexecuted.

**DOC-CONFIRMED:** exact SICK and Rockwell manufacturer claims in the source audit. **INFERENCE:** transfer to independent safe restart/physical proof. **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **UNKNOWN:** selected machine as-built and PL/SIL. Counterfactual graduation check: if any physical coverage, stop or restart assumption is false, the safety conclusion reverses; **cannot graduate/release** without qualified physical and external evidence.
