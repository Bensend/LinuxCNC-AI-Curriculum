# Cross-machine professional safety reference — safe motion and robot cell

Date: 2026-09-16
Session start UTC: 2026-09-16T18:38:46Z

## Purpose
Extend the press-brake safety-wiring study with professional servo/safe-motion and automated-cell examples. Preserve the distinction between a safety demand, the safety logic, the final control element, and the physical hazardous-energy boundary.

## Reference A — Pilz safe motion / servo machinery

Manufacturer sources:
- Pilz PNOZ s30 safe speed monitoring: https://www.pilz.com/en-US/products/applications/safe-motion-monitoring/safe-speed-monitor-pnoz-s30
- Pilz Safe Motion overview: https://www.pilz.com/en-INT/products/applications/safe-motion-monitoring
- Pilz safety compendium, safe motion chapter: https://www.pilz.com/download/open/TechBo_Pilz_safety_compendium_1004669-EN-02.pdf

### DOC-CONFIRMED
- PNOZ s30 is a safety speed monitor for standstill, speed, position, direction and speed-range monitoring; Pilz states applicability up to PL e / SIL CL 3 for the described device/function set.
- Safe motion can deliberately permit access while motion remains, provided a safety-rated function such as SLS/SDI/SOS establishes the required safe state. Therefore `guard open` is not universally synonymous with `all actuator power removed`.
- Pilz describes SS1 as a controlled stop followed by STO. Its compendium distinguishes implementations where a safe time delay is followed by safe removal of motor power from implementations with standstill detection.
- Pilz describes safe restart interlock as separate from reset: reset alone need not be permitted to release STO.

### Engineering consequence
For servo machine tools, a complete safety trace must distinguish at least:
1. normal CNC command inhibition;
2. safety-rated motion monitoring;
3. controlled braking authority during SS1;
4. STO / torque-producing energy authority;
5. mains isolation for maintenance;
6. mechanical brake or gravity-load retention where applicable.

A LinuxCNC `machine-off`, amplifier-enable bit, HAL interlock or FPGA watchdog can be useful normal-control/fault-containment behavior but is not evidence that any of the safety-rated functions above has been implemented.

## Reference B — SICK Flexi Soft automated welding/robot cell

Manufacturer source:
- SICK Flexi Soft Application Guide: https://www.sick.com/media/docs/2/52/652/special_information_application_guide_flexi_soft_en_im0035652.pdf

### DOC-CONFIRMED
SICK's application example uses multiple complementary protective devices around a robot/turntable cell: emergency-stop pushbuttons at accesses/service doors, an interlocked service door, multiple-light-beam devices at material exchange points, and non-contact safety switches that establish robot/turntable safe position. The protective response is context-dependent: an interrupted material-entry protective device only needs to stop the robot when the robot is in that area. The devices are evaluated by the Flexi Soft safety controller. After complete stop, a reset action is required before restart.

### Engineering consequence
Professional cell safety is not necessarily a single series E-stop string. Safe controllers can combine safe position and protective-device state to determine which hazardous motion must be stopped. That does not mean an ordinary PLC/LinuxCNC state machine may duplicate this behavior and inherit personnel-safety authority. The safety-rated logic and its validated sensing/output path are the authority.

## Cross-machine comparison

| Question | Hydraulic press brake | Servo machine tool | Robot / automation cell |
|---|---|---|---|
| Primary hazard energy | hydraulic + gravity + electrical | electrical drive torque + inertia; gravity on vertical axes | multiple electrical/pneumatic/hydraulic axes + process hazards |
| Safety demand examples | E-stop, light curtain, guard, ram safety condition | E-stop, guard, setup-mode safe speed | E-stop, gates, light beams/scanners, safe-position conditions |
| Safety logic | press-brake safety controller / safety PLC | safety relay/controller + drive-integrated safety | safety PLC/controller |
| Final elements | monitored hydraulic safety/holding valves; electrical contactors as design requires | STO/SS1/safe-motion drive interface, contactors where required, brakes where required | drive STO/safe-motion, safety contactors, pneumatic/hydraulic dump/block elements as required |
| Important retained energy | pressure and gravity may remain even if pump/command is removed | DC bus/mains may remain with STO; inertia/gravity remain physical hazards | energy can remain in unaffected zones/axes and process equipment |
| Reset is restart? | No assumption permitted | No; safe restart interlock can keep STO active after reset | No; reset acknowledges safe state, normal restart remains separately controlled |
| Maintenance isolation | separate physical energy-control problem | mains isolation + stored-energy handling; STO alone is not maintenance isolation | zone/machine-specific electrical/fluid/stored-energy isolation |

## Human-factors rule
The architecture should make routine safe behavior easier than bypass. Setup/jog access is a strong example: where risk assessment permits, engineered safe-motion modes such as safely limited speed can make legitimate setup work practical without encouraging operators to defeat a guard simply to see or adjust the process. This is not permission to invent safe speeds; limits and required safety performance are machine-specific and must be validated.

## Failure-path questions that every implementation must answer
1. What happens if one channel of an E-stop/guard circuit opens or shorts?
2. What detects a welded final contactor or a valve that fails to reach its monitored state?
3. Can reset itself create motion or release the final safety function?
4. What remains energized after STO or hydraulic safety demand?
5. What stops a gravity axis if torque/pressure is removed?
6. What happens when safe-position/speed feedback is missing, implausible or stale?
7. Can ordinary control software override the safety decision? It should not be assumed capable of doing so.
8. How is deliberate maintenance/bypass mode made conspicuous, bounded and difficult to leave active accidentally?

## Evidence boundary / UNKNOWN
- This study does not assign a PL/SIL to any proposed OpenPressBrake architecture.
- It does not establish a safe press-brake speed, stopping distance, hydraulic pressure threshold or valve truth table.
- It does not prove which OEM press-brake contactor disconnects which load; that remains dependent on obtaining a complete machine electrical + hydraulic drawing pair.
- It does not treat STO as galvanic/mains isolation or as protection against gravity motion.

## Next evidence target
Find a complete OEM machine-tool electrical diagram showing guard/E-stop -> safety logic -> drive STO/contactor/brake, and a complete automated-cell schematic showing safety PLC -> zone final elements and EDM. Then compare their physical energy boundaries against the press-brake trace rather than comparing only safety-controller input logic.
