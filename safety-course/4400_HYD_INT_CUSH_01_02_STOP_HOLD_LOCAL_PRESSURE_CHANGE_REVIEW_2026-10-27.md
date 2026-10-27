# 4400 HYD-INT × HYD-CUSH — Local-pressure and physical-safe-state architecture review
2026-10-27; public **documentary** design artifact, NON-GRADUATED. [HYD-INT original audit](../research/4400_HYD_INT_01_ROSS_AGGRESSIVE_HYDRAULICS_TRAPPED_ROD_SIDE_PRESSURE_INTENSIFICATION_AUDIT_2026-10-27.md) and [HYD-CUSH original audit](../research/4400_HYD_CUSH_02_AGGRESSIVE_HYDRAULICS_INTERNAL_CUSHION_PRESSURE_VS_PORT_GAUGE_AUDIT_2026-10-27.md). No selected OpenPressBrake schematic or test.

## Authority / energy chain (not an as-built diagram)
```text
Normal LinuxCNC/HAL/FPGA -> motion demand / ordinary STOP / HMI diagnostics
                         -> normal proportional/directional control
Independent protective input -> independent safety logic -> qualified final elements
                                                            |
                  pressure source / relief -> cap chamber --+-- piston/rod -- external load/gravity
                                     rod chamber <- block / pilot / check / return path
                                       |
                                  possible local cushion pocket
Physical witnesses: independent stop + hold + guarding + service isolation
                    AND qualified pressure protection for each trapped volume
```
The **normal-control arrow never becomes personnel-safety authority**. A hydraulic block may be a valid element of one safety function but may create a pressure hazard unless every credible driving force and isolated volume is reviewed. An ordinary pressure transducer or EDM proves only its defined measurement.

## Adversarial failure paths (INFERENCE unless explicitly OEM supported)
| Path | Apparent reassurance | Missing physical proposition | Review action |
|---|---|---|---|
| Pump pressure normal, rod end trapped | Pump relief OK | Local rod pressure below selected ratings | Map `A_cap/A_ann`, loads, isolated zones, relief paths |
| STOP command accepted | LinuxCNC/HMI STOP | Both Y axes stop and remain supported | Separate independent final elements and gravity retention |
| Valve coil de-energized | Electrical output OFF | Actual spool/port state and pressure bleed/hold | Exact valve manual, pilot supply, physical witness |
| End cushion slows ordinary stroke | Position/velocity trace smooth | Cushion pocket integrity and safety-rated stop | Internal section view, rating and validation |
| Port gauge zero during maintenance | Pump off | All trapped volumes depressurized | Selected OEM isolation, verified each zone, positive mechanical support |
| Replacement cylinder same stroke | Fit/geometry appears identical | Same internal cushion and local-pressure envelope | CHG event, requalify pressure/stop/hold |
| Guard removed for difficult pressure checks | Technician gains access | Protection against unintended movement/injection | Redesign accessible diagnostics; no bypass |

## SRS/PHY/DEP/CHG/VAL transfer into cumulative package
- **BND/ENE/HAZ:** select machine, both Y axes, fluid chambers, stored hydraulic/gravity energy, person and task. Keep installation UNKNOWN until qualified Stage A.
- **SRS:** stopping and holding **both** axes, relief/protection of each isolated pressure volume, independent guarding and maintenance isolation; derive numeric criteria only from selected design and applicable standards.
- **AUTH/ARC:** safety-related control and physical final elements independently justified; LinuxCNC/HAL/FPGA only normal motion, requests and diagnostics.
- **DEP/CCF:** shared pump/pilot, valve spools, quick couplings, contamination, cushion restriction, common manifold/sensor, mismatched cylinder.
- **HF:** make correct labeled port maps, service access, captive adjustment records and guard restoration easier than shortcuts.
- **CHG:** new cylinder, rod size, cushion setting, return restriction, relief, gauge location, valve spool, hose or software mode => dependent stop/pressure/hold evidence STALE.
- **VAL/PT/UNK:** physical verification and qualified review NOT RUN; exact selected pressure, geometry, ratings, valve truth, Y1/Y2 stop/hold, guard, PL/SIL and evaluator UNKNOWN.

## Information-gain decision
No compute is justified: force balance and manufacturer evidence answer the general mechanism; a toy simulator cannot establish the installed cylinder's actual local pressure or independent personnel-safety performance. A lab becomes justified only after a selected design reveals a concrete unresolved interface/diagnostic question that documentary evidence cannot settle. Never run a hazardous physical intensification demonstration. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.**
