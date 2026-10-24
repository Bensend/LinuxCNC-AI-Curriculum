# 4400-HYD-01 — Blank qualified selected-machine hydraulic stop/hold witness
**2026-10-24 | UNFILLED | NOT A TEST REPORT | NOT AUTHORIZATION TO OPERATE**

**Restriction:** Only a qualified machine-safety/hydraulic/electrical team may design and execute any physical verification after a written risk assessment, protected/remote setup and controlled isolation. Do not induce failures with people exposed, defeat guards, disconnect live hydraulic lines, or assume that a zero reading at one port eliminates stored energy. No sample values or acceptable thresholds are supplied here.

| Field | Required selected-machine entry (leave UNKNOWN until evidenced) |
|---|---|
| Machine ID / revision / date / qualified witnesses | UNKNOWN |
| Hazard boundary, operating mode and exposed persons | UNKNOWN |
| Exact hydraulic schematic ID and revision, Y1/Y2 cylinder type | UNKNOWN |
| Independent safety controller/firmware/config identity | UNKNOWN |
| Exact Y1/Y2 valve and switch part codes, OEM revision, pin map | UNKNOWN |
| Normal drive/FPGA/CNC output ownership and drive-active semantics | UNKNOWN |
| Safety output to final-element electrical wiring, common 24 V/0 V/fuse | UNKNOWN |
| Gravity/accumulator/piston/rod/optional branch stored-energy map | UNKNOWN |
| Physical guarding, test access and reset/occupancy provisions | UNKNOWN |
| Safe-state requirement and engineering acceptance criteria | UNKNOWN |
| Approved nonhazardous test method and instrument calibration | NOT PLANNED |
| Independent physical Y1 position/speed and hold evidence | NOT RUN |
| Independent physical Y2 position/speed and hold evidence | NOT RUN |
| Actual safety-output terminal and valve-position witness | NOT RUN |
| Independent hydraulic pressure/energy state per relevant compartment | NOT RUN |
| Drive-active loss / unexpected command / supply-fault review | NOT RUN |
| Guard, reset, power return, held pedal and fresh-start verification | NOT RUN |
| Mechanical service support, individual LOTO and pressure relief | NOT RUN |
| Raw synchronized traces / photographs / instrument reports | NONE |
| Fault discrepancies, residual risk, corrective actions, retest | UNKNOWN |
| Engineering review / signature / G0–G5 release decision | HOLD |

## Evidence hygiene
Record raw physical observations separately from normal CNC/FPGA logs and safety PLC status. State sensor calibration, clock synchronization, configuration revision, known uncertainties and observer vantage. A simulated valve, paper scenario, original OEM example or successful safety-controller checksum is not a machine-level validation. Proprietary as-built documents must remain in restricted storage; publish only generic lessons and non-sensitive gate status.

**Current release:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed operation.
