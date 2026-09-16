# Cross-Machine Safety Change-Invalidation Worksheet

Status: 4000 safety-course working artifact

## Purpose

Use this worksheet after maintenance, replacement, configuration edits, wiring repair, safeguard relocation, firmware/software changes, or temporary bypass work. It prevents two opposite errors: assuming an unchanged configuration proves the physical safety function is still valid, and indiscriminately repeating unrelated validation that the change could not affect.

Evidence labels: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

## Universal change-impact questions

For every changed item, fill all fields before production return:

1. **Hazard / safety claim affected** — What hazardous energy or access condition is the safety function intended to control?
2. **Prior evidence invalidated** — Which prior test, measurement, configuration verification, installation inspection, or fault challenge can no longer be relied on because this change could alter its claim?
3. **Independent physical witness** — What evidence observes the real final element, motion, energy state, protected field, guard state, or other physical condition rather than merely a command/controller bit?
4. **Diagnostic / fault challenge** — Which credible fault in the changed path must be challenged to show detection or safe response? Do not claim diagnostic coverage numerically without evidence.
5. **Reset / restart check** — After a safety demand clears, verify deliberate reset/rearm semantics and that hazardous operation does not resume solely because the safeguard returned healthy.
6. **Bypass / restoration check** — Identify every jumper, force, override, spare actuator/magnet, muted field, maintenance key, software force, or temporary wiring change; prove removal/restoration functionally where it affected the safeguard.
7. **Machine-specific UNKNOWNs** — Record every stopping time/distance, pressure/energy threshold, PL/SIL/category, hydraulic truth table, protective distance, diagnostic coverage, proof-test interval, or other design-specific fact not established by authoritative evidence.

A controller configuration signature, checksum, HAL state, HMI indication, ordinary FPGA status, or command echo may support configuration/diagnostic evidence. It is not automatically a physical witness.

## Machine-family worksheet

| Machine family | Example change | Hazard / safety claim to re-examine | Prior evidence potentially invalidated | Independent physical witness required | Diagnostic / fault challenge | Reset / restart check | Bypass / restoration check | Preserve as UNKNOWN unless established |
|---|---|---|---|---|---|---|---|---|
| Press brake | guard/light curtain, valve/final element, hydraulic wiring, ram-position safety device | access to closing/tooling hazard; hazardous ram motion/energy control | affected protective-device installation test; affected final-element response test; affected wiring/fault evidence | actual protective-field/guard behavior plus evidence at the physical motion/energy interruption appropriate to the design | changed channel/final-element feedback or wiring fault appropriate to the architecture | clearing beam/closing guard must not itself command a stroke; deliberate reset/rearm and separate normal command | remove maintenance jumpers/forces and challenge the restored safeguard | stopping distance/time, hydraulic safe-state truth table, pressure thresholds, PL/SIL/category, valve diagnostic coverage |
| Mill / VMC | door interlock, spindle contactor/STO path, spindle encoder/speed witness, drive replacement | access to rotating spindle/tool and hazardous axis motion | affected guard-interlock test; spindle/axis energy-removal evidence; affected drive configuration evidence | real guard state and physical drive/spindle/axis response; controller `spindle-on` is not standstill proof | interlock channel, final-element feedback, or drive safety fault relevant to changed path | guard closure alone must not restart spindle/axes; verify reset then separate start | prove temporary interlock defeat/drive commissioning overrides removed | coast-down time, safe-speed threshold, drive safety rating/configuration, protective distance |
| Lathe | chuck-door interlock, spindle drive/STO, brake, speed sensing | entanglement/ejection hazard from spindle/chuck; axis motion | affected door test; spindle stop/standstill evidence; brake/drive evidence | physical spindle/chuck response or qualified independent standstill/speed witness as designed | changed sensing/final-element/interlock fault | door closure or restored power must not automatically resume hazardous spindle motion | remove chuck/door bypasses and commissioning forces; challenge restored interlock | stopping time, chuck retention assumptions, safe speed, brake performance, PL/SIL/category |
| Plasma table | perimeter/access device, torch-enable contactor, plasma power interface, exhaust/interlock wiring | arc/high voltage, fire/fume, gantry motion and access hazards | affected torch-energy interruption evidence; access/gantry safeguard test | actual torch-energy enable path and actual motion/access response; LinuxCNC torch-command state alone is insufficient | stuck output/contactor feedback/access-device fault appropriate to design | field restoration must not itself refire torch or resume motion | prove test-jumpers, dry-run forces, sensor bypasses removed | plasma-source residual energy, arc extinguish time, fume thresholds, protective distances, safety performance level |
| Robot | gate switch/lock, scanner, safety controller/drive, enabling device | unexpected robot motion and access to robot/cell hazards | affected safeguarding geometry/configuration; safe-drive function evidence; gate/lock validation | physical safeguarded-space/access state and actual robot/drive response appropriate to validated function | changed channel, scanner field, gate/lock, drive safety fault | closing gate/clearing scanner must not itself restart automatic motion; reset and normal cycle start remain separate | remove teach/setup overrides and validate production-mode restoration | stopping distance/time, safe-speed limits, PL/SIL/category, scanner distances, payload-dependent stopping behavior |
| Automated cell | cell gate, trapped-person system, safety PLC/I/O, conveyor/robot interface, zone reset station | multiple interacting hazards and whole-body access/restart prevention | affected zone validation; personnel-accounting evidence; inter-zone stop/restart evidence | actual zone access/occupancy-clearing mechanism plus physical final-element response for affected hazards | changed zone I/O/final element plus credible cross-zone interface fault | `guard_closed`, `space_clear`, reset, safety permission, ordinary rearm, and start remain distinct | prove maintenance bypasses removed across every affected subsystem, not just the initiating machine | zone-specific stopping behavior, stored energy, personnel detection coverage, safety performance levels, timing assumptions |

## Change-scope decision rule

Retest scope follows the **claims the change can invalidate**, not the convenience of the technician and not a blanket whole-machine ritual.

- If a replacement changes only an ordinary HMI display and cannot influence a safety-related path, do not falsely claim the entire safety function was invalidated. Still verify that the HMI did not acquire new authority through configuration changes.
- If wiring, a safety input, final element, safety controller configuration, protective-device geometry, drive safety parameters, or bypass state changed, the affected physical safety claim needs evidence extending to the changed physical path.
- If the impact boundary cannot be established confidently, classify the boundary `UNKNOWN` and widen validation until the uncertainty no longer permits an unsafe assumption.

## Human-factors adversarial review

Before closing the worksheet, ask:

- Does the restored safeguard make the legitimate task so difficult that operators are likely to defeat it again?
- Is any bypass easier to install than the intended maintenance mode is to use?
- Can a spare actuator, magnet, jumper, password, software force, or retained command silently defeat the safeguard?
- Is bypass-active indication visible where the affected people actually work, rather than only on a remote HMI?
- Does power loss/reboot/controller replacement fail closed with respect to unresolved bypass/restoration state?
- Can a technician complete the restoration checklist without observing the real hazard boundary?

If the safe workflow is predictably impractical, treat that as an engineering defect to correct rather than relying on warnings.

## Minimum-safe-operation boundary

If validation cannot establish a basic safe-to-operate condition for the affected hazard, do not operate the machine with people exposed to that hazard. Any necessary experimental operation must be isolated/remote with people outside the danger zone, with residual risk explicitly recorded.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the ordinary controller FPGA may inhibit normal commands, discard stale commands, expose diagnostics, record state, and require ordinary rearm. They do not gain personnel-safety authority merely because they can observe or control the same machine. Independent safety-related control and physical energy-removal mechanisms remain separate architectural layers unless a specific safety-rated implementation and validation establishes otherwise.

## Evaluator prompt

A learner passes this worksheet only if it can explain **why** each requested retest follows from the changed claim, identify what evidence is merely controller/configuration evidence versus a physical witness, preserve design-specific unknowns, and reject both under-testing and unjustified blanket testing.
