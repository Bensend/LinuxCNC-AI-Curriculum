# 25D0 — Low-cost VFD/STO and fluid-power architecture comparison

Session start: 2026-09-23T18:35:14Z

## Purpose

Continue 25D0 by comparing low-cost architectures by the physical proposition bought and the dangerous failure path closed, not by component count. This is generic curriculum material; it does not assert a machine-specific PL/SIL, stopping time, hydraulic truth table, pressure, or diagnostic coverage.

## Evidence labels

- **DOC-CONFIRMED** — authoritative manufacturer documentation.
- **INFERENCE** — engineering conclusion derived from the cited propositions; requires application validation.
- **UNKNOWN** — application-specific fact not established here.

## VFD comparison

### Architecture D1 — ordinary VFD without integrated STO

Representative pattern: safety-related control removes motion-producing energy through appropriately engineered external switching/final elements; ordinary LinuxCNC/VFD run commands remain normal control only.

Physical proposition sought: a safety demand causes the independently engineered external power/energy path to reach its intended de-energized state.

What the added hardware can buy:

- an energy-removal path that does not depend on an ordinary software stop command;
- with redundant appropriately selected final elements and valid feedback, tolerance/detection of some single final-element failures;
- a clear boundary between normal LinuxCNC command authority and personnel-safety authority.

What it does **not** prove by itself:

- motor standstill or stopping time;
- discharged VFD DC bus or electrical isolation suitable for electrical work;
- control of gravity/back-driven loads;
- absence of stored mechanical energy;
- application PL/SIL.

A contactor auxiliary/mirror witness can support a switching-state proposition, but it is not direct proof of zero hazardous voltage, zero speed, or zero stored energy.

### Architecture D2 — VFD with integrated STO

**DOC-CONFIRMED:** ABB ACS880 documentation states that STO disables control voltage to the output power semiconductors so the drive cannot generate the torque required to rotate the motor; a running motor coasts to a stop. ABB also states that STO does not disconnect main/auxiliary circuit voltage and electrical maintenance requires isolation from mains. The ACS880 STO architecture is redundant when both channels are used as specified.

**DOC-CONFIRMED:** Rockwell PowerFlex 755T documentation similarly describes STO as removing power from gate-firing circuits so the output devices cannot generate AC motor power. It explicitly says the integrated safety function does not provide electrical safety; power must be removed and discharge verified before drive/motor electrical work. It also warns that external mechanical force can rotate the motor with STO active.

Physical proposition sought: a validated STO demand prevents the drive from generating torque through its power stage according to the manufacturer's safety-function assumptions.

Incremental value versus D1 can include:

- avoiding routine safety-demand switching of the main motor power path where the drive's certified STO function is suitable;
- a manufacturer-defined safety function with specified architecture, diagnostics, response assumptions and integrity data;
- potentially simpler personnel-safety wiring and reduced wear on external power contactors.

But STO is not a universal replacement for external isolation or other final elements. Maintenance isolation remains a separately justified function. Gravity, stored mechanical energy, brake requirements and coast-down remain application questions.

### Required freezes

- **STO ACTIVE != MOTOR STANDSTILL PROVED.**
- **STO ACTIVE != ELECTRICAL ISOLATION.**
- **STO ACTIVE != STORED ENERGY DISCHARGED.**
- **CONTACTOR OPEN != DC BUS DISCHARGED PROVED.**
- **DRIVE TORQUE DISABLED != GRAVITY/BACKDRIVE MOTION PREVENTED.**
- **RESET/REARM COMPLETE != MOTION START AUTHORIZED.**
- **LINUXCNC/VFD RUN COMMAND OFF != PERSONNEL-SAFETY FUNCTION.**

### Cost reasoning without fabricated prices

Dollar prices are deliberately not frozen: like-for-like current transaction pricing was not established. Compare cost by what is purchased:

| Increment | Named proposition/failure path bought | Residual uncertainty |
|---|---|---|
| ordinary VFD + engineered external switching | safety demand can remove the selected external energy path independently of ordinary run command | final-element failure, coast, stored bus energy, gravity/backdrive, isolation proof |
| redundant external switching + valid feedback | some single final-element failures can be tolerated/detected before re-enable, subject to architecture assumptions | witness feedback is not physical safe-state proof; CCF remains |
| integrated STO | drive power stage is prevented from generating torque under the manufacturer's STO assumptions | coast, external forces, brake/load holding, electrical isolation, stored energy |
| lockable isolation + verification procedure | maintenance electrical-energy isolation proposition when correctly selected/applied/verified | other energy domains and residual/stored energy still require their own controls |

## Tier E — low-cost fluid-power architecture is materially required

25D0 would be incomplete if 'cheap safety' were taught only through electrical examples. Hydraulic/pneumatic machines can remain hazardous with electrical command power removed. Tier E therefore deserves its own comparison, but it must remain function-based rather than prescribing a generic valve circuit.

### E1 — supply isolation only

Physical proposition: new pressure/flow from the selected source path is blocked.

Does not prove: trapped downstream pressure exhausted, accumulator discharged, vertical load held, hose/cylinder integrity, or safe maintenance state.

### E2 — supply isolation + dump/decompression

Physical proposition: source is blocked and a designed downstream volume has a path toward the intended reduced-pressure state.

Does not prove: every trapped volume is connected to that dump path, pressure actually reached a safe threshold, or a gravity load cannot move as pressure decays.

### E3 — supply isolation + decompression + independent load holding/restraint where required

Physical proposition: source addition is prevented, selected trapped energy is relieved, and a credible gravity/overrunning-load path has a separately engineered holding/restraint measure.

**DOC-CONFIRMED:** Parker describes counterbalance/load-control valves as providing load holding, overrunning-load control and hose-failure protection; its E2 series states that the valve can prevent uncontrolled load motion after hose/line failure. Parker press-control literature separately lists shutoff, decompression, load-holding and counterbalance functions, supporting the curriculum distinction that these are different physical functions rather than synonyms.

Residual questions remain application-specific: valve architecture, monitored position, leakage, pressure thresholds, response time, load cases, accumulator topology, mechanical restraint and required integrity target are **UNKNOWN** until engineered for the machine.

### Tier-E freezes

- **PUMP/COMPRESSOR OFF != FLUID ENERGY GONE.**
- **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED.**
- **DUMP COMMANDED != PRESSURE SAFE PROVED.**
- **DIRECTIONAL VALVE NEUTRAL != GRAVITY LOAD HELD.**
- **LOAD-HOLDING VALVE PRESENT != MAINTENANCE RESTRAINT PROVED.**
- **ELECTRICAL SAFE STATE != FLUID/MECHANICAL SAFE STATE.**

## Human-factors requirement

The cheaper architecture is unacceptable if normal recovery, setup or maintenance predictably rewards bypassing it. Reset and rearm should be deliberate and diagnosable; ordinary cycle-start remains separate. Guards/interlocks and safety devices should be straightforward to restore after maintenance. A nuisance-trip problem is a design/diagnostic problem to fix, not permission to bridge the safeguard.

## LinuxCNC boundary

LinuxCNC and the ordinary FPGA/controller may request normal stops, display safety status and provide diagnostics. They do not become personnel-safety authority merely because they can observe or command the same machine. Safety-related sensing/logic/final elements and physical energy control remain independently justified.

## Sources

1. ABB, ACS880 hardware manual, Safe torque off chapter: STO prevents drive-generated torque, running motor coasts, main/auxiliary voltage remains present, electrical maintenance requires mains isolation. https://library.e.abb.com/public/426332acfaff4cb98425edeecedd0831/EN_ACS880-11_HW_H.pdf
2. Rockwell Automation, PowerFlex 755T Safe Stop Functional Safety: gate-firing removal, no electrical-safety claim, external-force rotation warning, discharge verification before electrical work. https://www.rockwellautomation.com/en-gb/docs/technical/powerflex/powerflex-755t/_online/powerflex-755t-drives-information-ditamap/safe-stop-functional-safety.html
3. Parker, E2 Series Counterbalance Valve: load holding, overrunning-load control and hose-failure protection. https://discover.parker.com/e2-series-counterbalance-valve
4. Parker, Press Control PPCC brochure: distinct shutoff, decompression, load-holding/counterbalance functions. https://www.parker.com/content/dam/Parker-com/Literature/Industrial-Systems-Division-Europe/Brochures/MSG11-3359-Press-Control-PPCC-UK.pdf

## Coverage decision

Tier E is retained because it closes a real competency gap: a learner otherwise could incorrectly transfer an electrical 'remove command/power' pattern to stored-pressure and gravity-load systems. No machine-specific valve truth table or pressure is frozen.

## Next

Audit 25D0 line-by-line against its syllabus/competency requirements. If no material gap remains, create the canonical learner route and information-separated no-solution evaluator handoff and mark 25D0 READY FOR EXTERNAL/FRESH EVALUATION rather than self-graduating it. If a genuine gap remains, fill only that gap first.
