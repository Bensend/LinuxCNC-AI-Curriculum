# 4400-WJ-01 — 12-gate no-energy waterjet pressure/PLC change review
**2026-10-25 | DESIGN REVIEW ONLY | ALL GATES NOT RUN**

No energized equipment, pressure manipulation, bypass, forced sensor state, or CNC/PLC lab is authorized by this review. Review only documentary as-built and OEM sources in a restricted machine workspace. A missing gate is a **HOLD**, not a presumed pass.

| Gate | Documentary question | Required witness | State |
|---|---|---|---|
| G01 | Exact pump/PLC/cutting-head models, edition, installed configuration? | as-built BOM, nameplate and software/config export | NOT RUN |
| G02 | Every hazardous energy and pressure zone identified? | signed energy/pressure zone map | NOT RUN |
| G03 | Which gauge measures which zone? | instrument ports, ranges and calibration | NOT RUN |
| G04 | Is pressure dump a safety function or ordinary process function? | qualified SRS, final-element/diagnostic evidence | NOT RUN |
| G05 | What happens if dump path is blocked or valve fails? | fault analysis and independent pressure-witness method | NOT RUN |
| G06 | Which remote/local/CNC commands can generate jet pressure? | verified interface and mode ownership diagram | NOT RUN |
| G07 | Are yellow warnings/READY and startup stages correctly interpreted? | exact firmware OEM sequence and selected configuration | NOT RUN |
| G08 | Are 809790-like bleed-time and 810040-like startup changes version controlled? | approved change record, backup, diff and revalidation scope | NOT RUN |
| G09 | Do guards protect jet, ejecta, gantry and helpers through all modes? | access/visibility/containment review | NOT RUN |
| G10 | Is maintenance isolation complete beyond pump-off and low-pressure gauges? | qualified LOTO and OEM point-of-work verification plan | NOT RUN |
| G11 | Is injection-injury emergency response immediately usable? | posted emergency card, training and response route | NOT RUN |
| G12 | Can return to service occur only after guard/energy proof and fresh deliberate start? | independent reviewer, no stale command, new validation plan | NOT RUN |

## Fault and dependency review
Preserve distinct witnesses for pump motor/drive, hydraulic supply, compressed-air pilot, UHP bleed path, attenuator/line, cutting head, gantry and guard. One common power supply, software state, pressure transducer, or operator action may defeat multiple assumptions. Do not calculate PL/SIL, bleed time, stopping distance or medical threshold from this worksheet.

## Release ladder
**Document review complete** is not physical proof. **Qualified isolated validation planned** is not completed validation. **Completed independent physical witness** is not automatically authorization for routine personnel exposure without full risk/guard/commissioning review. Any unknown = HOLD for that proposition.

**Lab decision:** OEM documentary evidence already resolves the present source question; no justified compute experiment. If a future concrete nonhazardous software question emerges, use only self-hosted runner `[self-hosted, openpressbrake]` when assigned. Do not dispatch hosted Actions.
