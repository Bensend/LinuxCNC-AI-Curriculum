# 4400-WJ-01 — Hypertherm waterjet pressure/bleed-down and PLC startup source audit
**2026-10-25 | Primary OEM documentation, revision-bounded | NON-GRADUATED | no machine test**

## Concrete question
Does a CNC pump-ready bit, a commanded bleed-down, or a normal E-stop/PLC sequence prove that the jet, high-pressure line, attenuator, hydraulic supply and downstream cutting head are safe for a person to access? **No such inference is supported.** This study compares original OEM editions, not a selected installation.

## Original documents inspected
1. Hypertherm, *HyPrecision 15/30/50 Waterjet Pump Operator Manual*, 808240 Rev 1, July 2015, printed pp. 38–40 (pressure circuit and normally-open air-actuated bleed valve), pp. 47–49 (local/remote), pp. 58–59 (E-stop), pp. 85–86 and 129–137 (maintenance), pp. 159–160 (leaks). https://xnet.hypertherm.com/Xnet/library/download/?file=HYP219762
2. Hypertherm, *PLC update for bleed-down valve operation*, 809790 Rev 0, January 2017, printed pp. 3–5. https://xnet.hypertherm.com/Xnet/library/download/?file=HYP178130
3. Hypertherm, *PLC update 10304*, field service bulletin 810040 Rev 0, April 2018, printed pp. 3–7, 8–10, 14–20. https://xnet.hypertherm.com/Xnet/library/download/?file=HYP235740
4. Hypertherm, *Waterjet Safety and Compliance Manual*, 80943C Rev 0, February 2016, English pp. SC-5–SC-7. https://xnet.hypertherm.com/Xnet/library/library.jsp?file=HYP172721
5. Flow, *MotoJet intensifier pump*, current OEM product description accessed 2026-10-25; **model-specific marketing claim** of automatic bleed-down to zero within one second of pump shutdown. https://www.flowwaterjet.com/waterjet-products/motojet
6. LinuxCNC, official M-code reference, M66 input wait (ordinary G-code wait; not realtime monitored or safety rated), accessed 2026-10-25. https://linuxcnc.org/docs/stable/html/gcode/m-code.html (language-path redirect possible; see https://linuxcnc.org/docs/html/nb/gcode/m-code.html).
7. OSHA 29 CFR 1910.147 hazardous energy control (legal scope must be checked for selected workplace). https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

## Documentary findings with strict scope
| ID | Finding | Evidence class | Limit |
|---|---|---|---|
| WJ-A | The 808240 manual describes a **normally open, air-actuated** high-pressure bleed-down valve; it opens on pump-off or high-to-low pressure change. Its E-stop description says control circuit/pump/intensifier turn off and bleed valve opens. | DOC-CONFIRMED 808240 printed pp. 39, 59, 67 | Describes intended behavior for exact family, not proof that a stuck/blocked valve actually discharged the entire installed pressure network. |
| WJ-B | The same manual locates water-pressure gauges **before/after the supply filters** and calls out a low-pressure inlet switch. | DOC-CONFIRMED 808240 printed p. 38 | A zero on these low-pressure gauges is **not** proof of zero pressure in high-pressure tubing, attenuator or cutting head. This distinction is particularly easy to miss when reading isolated maintenance steps. |
| WJ-C | 809790 adds a **user-adjustable bleed-open duration** for a **cut-to-pierce pressure transition**. OEM notes inadequate duration may leave cutting-head pressure higher than requested; excessive duration requires rapid intensifier recovery. | DOC-CONFIRMED 809790 printed pp. 4–5 | The 1.3 s OEM default applies to that transition only; it is **not** an E-stop safety reaction time, certified depressurization time or general service-zero guarantee. |
| WJ-D | 810040 changes an exact S/D-family PLC startup into stages. Bleed valve initially open, intensifier subsequently strokes with valve open, valve closes, pressure ramps. User-programmable timers affect stages. | DOC-CONFIRMED 810040 printed pp. 4–7 | PLC state and timing differ by version/configuration. No assertion that this sequence is an independent safety controller. |
| WJ-E | During 810040 startup, some insufficient-pressure cases produce a **Power Up Warning**, flashing yellow stack light, **while the startup sequence continues**. Later the **PUMP READY** output turns on at the selected pressure-mode stage. | DOC-CONFIRMED 810040 printed pp. 5–7 | Do **not** assume every warning remains latched until READY or that every warning is a hard inhibit. Exact machine logic and warning persistence remain UNKNOWN. |
| WJ-F | 810040 warns a PLC reboot can erase adjustments/setpoints; requires recording model, timers and settings for restoration. | DOC-CONFIRMED 810040 printed pp. 8–10, 14–20 | Configuration restoration must trigger an engineering change/revalidation review. No assumption about which parameters were actually lost on a selected unit. |
| WJ-G | 808240 permits a CNC remote source to control the pump when selected LOCAL/REMOTE switch is in REMOTE; it states remote start is inhibited after certain fault/E-stop conditions. | DOC-CONFIRMED 808240 printed pp. 47–49, 58–59 | A pump's remote-start interlock is not an independent guarded-zone occupancy or cutter-motion safety function. Do not generalize to other models. |
| WJ-H | OEM safety manual calls high-pressure injection a **surgical emergency**, even where skin damage looks minor; directs immediate emergency medical care and an emergency information card. | DOC-CONFIRMED 80943C SC-6 | Do not diagnose injury severity from visible wound or postpone care. |
| WJ-I | Flow MotoJet product page advertises 0-pressure automatic bleed within one second after shutdown. | DOC-CONFIRMED product claim only | Model-specific claimed capability, not verified physical performance, not a universal criterion, and not an authorized service-entry timer. |
| WJ-J | LinuxCNC M66 can wait for an ordinary input or timeout, and documentation explicitly says inputs are not realtime monitored for timing-critical use. | DOC-CONFIRMED LinuxCNC M-code reference | A G-code M66 wait or a HAL ready bit cannot provide personnel-safety authority. Existing repository M66 runtime evidence addresses ordinary stale-wait behavior, not pressure safety. |

**SOURCE-CONFIRMED:** no new LinuxCNC source code was traced in this study. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied upon. **INFERENCE:** pressure-zone/witness design below. **UNKNOWN:** exact selected machine hardware, pressure readings, physical bleed performance, PL/SIL, response time, safety architecture, operator access and firmware revision.

## Physical energy and control authority decomposition (design inference)
- **Ordinary control:** CNC requests pierce/cut, remote pump on/off, waits on PUMP READY and presents HMI. LinuxCNC/M66/normal FPGA live here.
- **Safety-related control:** independently assessed guard access, E-stop/protective stop, pump/jet energy inhibit, selected final-element monitoring and restart permission. Product-specific design and validation required.
- **Physical mechanisms:** high-pressure water generation; attenuator and piping; cut head/nozzle; pneumatic pilot for bleed valve; hydraulic drive; residual compressed air; water supply; mechanical jet catcher/containment. Isolating one source does not prove all zones safe.
- **Maintenance isolation:** qualified lockout of all relevant sources, secured downstream jet/nozzle, approved pressure release and independent **point-of-work** verification, not simply waiting a timer or looking at a supply-filter gauge.

## Adversarial failure paths
1. **Bleed valve stuck closed or drain obstructed:** PLC commands dump, icon reports open, pressure persists downstream. Require a physically relevant independent witness; HMI indication is insufficient.
2. **Cut-to-pierce setting changed:** operator sees low setpoint while actual head pressure may exceed it; not a maintenance-safe mode.
3. **Startup warning not hard inhibit:** technician assumes yellow light means pump cannot pressurize; 810040 documents some continuing stages. Keep exclusion until independently verified.
4. **Reboot/restored defaults:** stage timer and model options change silently; a previous witness/approval may be stale.
5. **Pump E-stop but CNC axes moving:** nozzle can traverse near personnel or unexpected stream; stop ownership must include both machine subsystems.
6. **CNC idle but remote pump active:** hydraulic/high-pressure system may still be pressurized independently of CNC program state.
7. **One zero inlet gauge:** does not characterize high-pressure zone; do not loosen connections.
8. **Service bypass or temporary test connection retained:** make restoration and peer review mandatory; do not publish operational bypass instructions.

## Evidence gap / information-gain decision
The manufacturer sources answer **what the exact products document**, including the non-obvious user-adjustable bleed interval and startup-warning continuation. They cannot establish safe pressure, timing or performance on an unidentified machine. **No simulation** is justified to invent hydraulic truth. The next useful evidence would be a qualified as-built zone diagram, OEM-approved measurement points, firmware/configuration export, pressure sensor calibration, independent physical discharge witness and qualified safe isolation/guard/return-to-service review. Until then: **no personnel-exposed hazardous operation authorized**. No Hypertherm or Flow pump is claimed installed on OpenPressBrake.

## Cross-machine transfer
Press brake: a command to dump/disable a hydraulic valve is not proof of independent Y1/Y2 hold or no gravity descent. Plasma: CNC arc-off is not electrical energy isolation. Robot: tool valve off is not proof a suspended payload remains retained. Waterjet adds a high-pressure **fluid injection** hazard with distinct medical response. The control/witness reasoning transfers; exact hardware and safe-state propositions do not.
