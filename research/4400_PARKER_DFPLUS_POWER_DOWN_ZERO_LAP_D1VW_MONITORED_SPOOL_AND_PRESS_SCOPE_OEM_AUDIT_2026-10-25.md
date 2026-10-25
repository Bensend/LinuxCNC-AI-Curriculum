# 4400-VALVE-01 — Parker original: enable OFF, power-down spool position, inductive monitoring and hydraulic-press scope
**2026-10-25 | Original OEM documentation investigation | NON-GRADUATED | NO SELECTED MACHINE CLAIM**

## Question
Can a CNC or safety-controller designer infer **hydraulic no-flow / ram held** from a proportional valve enable going low, the coil supply disappearing, or a monitored spool position? **Not without exact valve variant, hydraulic symbol, load path and independent physical safety validation.** This audit separates **ordinary valve enable**, **power-down hydraulic port geometry**, **spool-position indication**, and **safety-related final-element qualification**.

## Direct original sources
1. **Parker Hannifin**, [DFplus pilot-operated proportional directional valve operation manual, D_1FP_5715-666UK, 22.10.24](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Controls-Europe/Manuals-UK/D_1FP-5715-666-UK.pdf), original 20-page PDF, p. 5 *Characteristics*, pp. 10–13 *Electrical Interfacing* and *Preferred Hydraulic Initial State*. This source describes series D*1FP/D*1FE, not a selected OpenPressBrake valve.
2. **Parker Hannifin**, [Series D1VW Inductive Position Control, MSG11-3500/UK, 25.03.2024](https://www.parker.com/content/dam/Parker-com/Literature/Industrial-Systems-Division-Europe/Catalogues/Industrial-Valves-UK/02/D1VW-IPC-UK.pdf), original nine-page PDF, pp. 1–6, especially *Characteristics*, *Ordering Code* and *Position Control*. This is a different valve family.
3. **ISO publisher** [ISO 8643:2024](https://www.iso.org/standard/87986.html) and **B11 Standards publisher** [ANSI B11.3-2022](https://www.b11standards.org/storeitems/b113-2022) confirm machine-class scope; no purchased normative text inspected. Parker D1VW explicitly refers to **DIN EN ISO 16092-3 hydraulic presses** for a particular ordered combination; this does not establish applicability to a **power press brake**.
4. **Parker Hannifin**, [Series 6 MMV-IPC service bulletin 2403-M1/USA, effective 1997-01-06](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Valve-Division/hydraulicvalve/Service-Installation/Mobile/Bul-2403-M1-6-Mobile-Mtn-Cntrl-Vlv.pdf), original PDF printed p. 10: continued flow after coils de-energized with main spool sticking/contaminants. Different valve family, included as independent fault example.

## OEM claims, exact version and limitations
| OEM statement | Evidence class | What it does **not** establish |
|---|---|---|
| DFplus has a closed-loop spool-position control and a diagnostic output for spool stroke | DOC-CONFIRMED, DFplus manual p. 5 | That a diagnostic bit is an independent safety channel, or that a ram is physically held |
| DFplus enable input permits actuator operation; manual explicitly states it is **not a safety arrangement against unwanted valve operation** | DOC-CONFIRMED, DFplus manual *Electrical Interfacing* | That LinuxCNC/HAL/FPGA or the normal enable may perform the personnel-safety function |
| DFplus **zero-lap** spools can have a power-down position **approximately 10% open**, distinct from hydraulic neutral at zero command; **overlap** spools have neutral/power-down coincidence in that manual | DOC-CONFIRMED, DFplus *Preferred Hydraulic Initial State*, printed p. 12 | Any universal 10% opening for other valve families, any particular OpenPressBrake spool or actual cylinder flow |
| D1VW inductive position-control variants monitor **start** or **end** spool position, with a factory-set sealed adjustment and manufacturer-only repair/replacement | DOC-CONFIRMED, D1VW PDF pp. 1, 6 | That position feedback senses load, pressure, seal leakage, hose rupture, relief path, or mechanical restraint |
| D1VW start-position switch is defined at spool departure from offset position; end-position switch at near end of stroke, each with different semantics | DOC-CONFIRMED, D1VW PDF p. 6 | Interchangeability of start/end feedback or automatic safety performance qualification |
| D1VW specific ordering note for hydraulic presses per DIN EN ISO 16092-3 calls for solenoid option **T without manual override** and **I4N/I5N** (single-solenoid) or **I6N** (double-solenoid) start-position monitoring | DOC-CONFIRMED, D1VW PDF pp. 2–4 | That these options are mandated or sufficient for a **press brake** under ANSI B11.3-2022; do not transfer standards or infer a PL/SIL |
| Parker Series 6 MMV-IPC manual describes continued flow after coils OFF due to sticking main spool | DOC-CONFIRMED, 1997 bulletin printed p. 10 | That every spool will stick or that this exact valve is installed |

## Concrete failure-path comparison
**Normal path:** LinuxCNC position loop commands a proportional valve; a zero input or enable OFF can produce a variant-specific power-down spool/port state. A green enable-off icon is evidence only of the ordinary command path.

**Monitoring path:** an inductive switch on a specific D1VW variant may report spool start/end position, but **not** physical ram standstill, trapped pressure, gravity restraint, hose integrity or a separate safety valve. A safety-related control design may use qualified monitored components as **part** of a validated safety function; no claim is made here that the ordinary diagnostic channel is safety-rated.

**Physical path:** hydraulic port connection in the power-down position, upstream/downstream relief, check/counterbalance, pilot pressure, seal leakage, hose/accumulator, actual Y1/Y2 load and mechanical support determine whether hazardous movement can occur.

**Adversarial:** someone swaps a valve from an overlap to a zero-lap spool because both have 24 V enable and closed-loop position feedback. A power-down command may change hydraulic port state. This is a **reasoned risk scenario**, not an observed retrofit or predicted OpenPressBrake displacement.

## Human factors and safety architecture
Specify **exact model and hydraulic symbol**, not “servo valve, 24 V, enable”. Provide service labeling that distinguishes *normal enable disabled*, *monitored spool offset*, *independent safety stop*, *hydraulic load actually held*, and *mechanical restraint engaged*. A well-designed independent safety architecture should not depend on operators memorizing which HMI indicator can be trusted. Make the qualified physical restraint/energy-isolation workflow easy to use and hard to omit.

## Limits, unknowns and release
**DOC-CONFIRMED** the precise OEM statements above. **SOURCE-CONFIRMED:** no new LinuxCNC source inspected. **TEST-CONFIRMED none; COMMUNITY-REPORTED none; INFERENCE** SRS/failure propagation; **UNKNOWN** selected OpenPressBrake valve, spool/ordering code, actual port state, hydraulic truth table, safety final elements, independent Y1/Y2 stop/hold, PL/SIL, evaluator score. No numeric travel/stopping distance or machine-specific pressure derived. No physical tests, energized valve changes, manual override, personnel-exposed operation or hosted compute authorized. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. Cross-reference [HOLD-01](../safety-course/4400_HOLD_01_CYLINDER_SIDE_LOAD_HOLD_RELIEF_OVERRIDE_AND_RESTART_MODULE_2026-10-25.md) and [FILT-01](../safety-course/4400_FILT_01_FILTER_BYPASS_INDICATOR_MEMORY_AND_COLD_START_TECHNICIAN_CARD_2026-10-25.md).
