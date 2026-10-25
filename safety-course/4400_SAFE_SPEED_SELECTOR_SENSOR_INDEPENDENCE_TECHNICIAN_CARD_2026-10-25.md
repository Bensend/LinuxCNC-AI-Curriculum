# 4400-MON-01 — Technician adversarial practice and selected-machine blank witness
**2026-10-25 | PAPER ONLY / learner-visible / NOT BLIND / NOT PHYSICAL TEST**

## 16 short cases — write a prediction and evidence discriminator, not a guessed safe-state verdict
For each: identify which proposition fails (normal command / safety monitor / final element / access / reset), cite the relevant OEM manual section, list a specific missing as-built fact, and give a safer low-friction remedy.

1. A PNOZ s30 uses four one-hot setup/auto select inputs. Technician enables All 16 to add an extra mode and retains the previous PL claim.
2. In All 16 mode, SEL4 wire breaks while P7 was selected; HMI still says setup.
3. A selected parameter set contains the special function No 2 encoder diagnostics.
4. A fault is acknowledged by changing to a special parameter set; a queued CNC cycle remains armed.
5. Rel.1 is unavailable; technician wires semiconductor Out1 into the existing personnel-safety relay chain.
6. Overspeed switch-off delay is added to prevent nuisance trips, but safety distance is unchanged.
7. Selector input filter is lengthened to mask contact bounce during high-speed-to-setup transition.
8. Standstill is indicated at a nonzero frequency threshold while a suspended hydraulic load creeps.
9. Two incremental encoders are mounted on one common shear-prone coupling.
10. Two separate encoders share one vulnerable supply/0V connector and cable route.
11. SICK example dual ordinary encoder diagram is replaced with one safety encoder without revising MOC mapping.
12. Ordinary drive ramps to zero, but measured deceleration violates the selected safety-monitor ramp.
13. A cross-check shows both sensors agree while a disconnected output shaft still rotates a hazardous load.
14. Guard clears and monitor's output automatically reenables; operator previously pressed Start.
15. A technician copies SICK example service speed/standstill window directly to a press-brake backgauge without risk assessment.
16. All electrical output bits show safe state after E-stop, but ram falls under gravity with hydraulics deenergized.

## Blank selected-machine evidence intake (not a permission to energize)
| Evidence ID | Qualified as-built item / observed fact | Evidence custodian / revision / date | Status UNKNOWN / N/A with proof / VERIFIED |
|---|---|---|---|
| MON-01 | Selected motion axis, hazard zone, operating modes, people exposure | | UNKNOWN |
| MON-02 | Exact monitor, hardware/firmware/manual/config checksum and approved change history | | UNKNOWN |
| MON-03 | Full selector truth table: wiring, P sets, diagnostic bypass, fault ack and reset | | UNKNOWN |
| MON-04 | Terminal-by-terminal safety output and final-element chain; diagnostic vs safety | | UNKNOWN |
| MON-05 | Sensor-to-actual-load independent mechanical and electrical paths, CCF | | UNKNOWN |
| MON-06 | Stop/transition response design basis and qualified protected measured witness | | UNKNOWN |
| MON-07 | Y1/Y2 gravity load, valve/brake/hold and stored-energy proof, independently of speed | | UNKNOWN |
| MON-08 | Guards, inside escape, occupancy, mode changes and reset/fresh start | | UNKNOWN |
| MON-09 | Maintainer feedback: nuisance trips, bypass incentives, guard replacement usability | | UNKNOWN |
| MON-10 | Independent qualified evaluation, residual risk and commissioning approval | | UNKNOWN |

**Safety gate:** G0/G1 HOLD; G2 paper review only; G3/G4 physical tests NOT AUTHORIZED. Never create a hazardous fault to fill this sheet without approved selected-machine plan and isolated/excluded people. If basic stop/hold/guard/restart threshold cannot be met, do not operate with personnel exposed. Preserve private machine drawings outside this public repository.
