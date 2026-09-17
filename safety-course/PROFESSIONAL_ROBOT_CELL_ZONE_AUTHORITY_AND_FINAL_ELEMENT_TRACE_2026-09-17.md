# Professional robot/cell trace — zone authority, final elements, and restart

Date: 2026-09-17
Session start UTC: 2026-09-17T15:36:00Z

## Purpose

Extend the existing cross-machine safe-motion overview into an end-to-end robot/cell lesson that asks two different questions:

1. **Which zone is permitted to remain productive when a protective device is challenged?**
2. **What physical final element actually removes or constrains hazardous motion in the affected zone?**

The lesson deliberately refuses to collapse a safety-controller output bit, robot-controller state, or ordinary PLC state into proof of the physical hazardous-energy result.

## Reference A — SICK Flexi Soft double-cell welding robot

Manufacturer source:
- SICK Flexi Soft Application Guide, application `double cell welding robot`: https://cdn.sick.com/media/docs/2/52/652/special_information_application_guide_flexi_soft_en_im0035652.pdf

### DOC-CONFIRMED architecture

The SICK example is a welding robot serving **two independent turntables/loading zones**. The application exposes enough of the safety decision to show genuine zone/context dependence:

- fences bound the sides of the cell;
- a service door is monitored by an `i12S` safety switch;
- each material-exchange entry is monitored by an `M4000` multiple-light-beam safety device;
- `IN4000` non-contact safety switches determine robot-center position and safe turntable position;
- emergency-stop pushbuttons are provided at accesses/service-door locations;
- all of those safety components are connected to a `Flexi Soft` safety controller;
- interruption of a particular material-entry protective device stops the robot **when the robot arm is in that area**;
- if the robot and the relevant turntable are in their safe positions, the worker may enter that loading area while the other cell can remain the productive side;
- opening the service door stops the robot and turntables;
- after complete stop, reset is required before the machine can start again.

This is not a simple global series interlock. Safe position is an input to the safety decision about which access may be open.

### Zone-authority trace

For one loading side, the documented logic can be represented without inventing implementation details:

`M4000 access demand + IN4000 robot-position evidence + IN4000 turntable-position evidence`

`-> Flexi Soft safety evaluation`

`-> affected hazardous action stopped / access condition enforced`

`-> complete stop`

`-> reset required before restart`

The other loading zone can remain available when the safe-position conditions make that separation valid. The safety controller, not the ordinary robot program, owns the credited zone decision in this example.

### Critical final-element evidence gap

The application guide says the switch-off signal is sent directly from Flexi Soft and describes the resulting robot/turntable stop, but the application summary does **not** expose enough electrical/drive detail to prove whether the final element is drive STO, SS1, a safety contactor, another robot-controller safety input, or a combination.

Therefore:

- `DOC-CONFIRMED`: protective devices + safe-position sensing -> Flexi Soft -> documented hazardous-action stop behavior.
- `UNKNOWN`: exact drive power-stage / STO / contactor implementation for this particular SICK example.
- `UNKNOWN`: whether any pneumatic/welding-process energy is isolated by the same demand.
- `UNKNOWN`: what remains electrically energized after the zone stop.

This evidence gap is itself a curriculum lesson: **zone logic can be source-confirmed while the physical final-element boundary remains unproven.** Do not fill the missing part with a generic robot assumption.

## Reference B — Rockwell Safety Accelerator robot-cell example

Manufacturer source:
- Rockwell Automation Safety Accelerator Toolkit Quick Start, Appendix A robot-cell example, publication IASIMP-QS005H-EN-P: https://literature.rockwellautomation.com/idc/groups/literature/documents/qs/iasimp-qs005_-en-p.pdf

### DOC-CONFIRMED architecture

Rockwell's robot-cell example makes the final electrical output class more visible than the SICK application guide:

- the safety zone includes four emergency-stop buttons;
- two locking switch/solenoid guard devices and a light curtain are safety inputs;
- Guard I/O communicates over EtherNet/IP;
- the zone uses **two safety contactors as outputs for powering the robot control**.

This example is useful precisely because it exposes a physical output class that the SICK zone example leaves unspecified.

### What this does and does not prove

It supports the general end-to-end pattern:

`protective demand -> safety controller / safety I/O -> redundant safety contactor outputs -> robot-control power path`

But it does **not** prove that the SICK double-cell application uses contactors, nor does it prove the exact power poles, robot-drive DC-bus state, stored energy, braking behavior, or process-energy isolation of any OpenPressBrake/robot implementation.

## Cross-reference — SICK Safe Robotics Area Protection

Manufacturer source:
- SICK SRAP / safe robotics area protection: https://www.sick.com/us/en/collaboration-without-incident-using-sicks-safe-robotics-area-protection/w/press-safe-robotics-area-protection

### DOC-CONFIRMED

SICK documents a safety laser scanner + Flexi Soft architecture in which different field sets can cause robot motion to reduce or stop depending on worker position. Sequence monitoring can permit reduced-speed restart and later return to normal speed once the relevant warning/protective fields are clear, where the application/risk assessment supports that behavior.

This reinforces a key distinction:

> `person detected` does not always mean `remove all machine energy`; the credited safety function may instead be a validated safe-motion state appropriate to that zone and operating condition.

That flexibility increases the obligation to prove safe feedback, safe logic, final-element behavior, restart behavior, and the physical result. It does not authorize ordinary PLC/LinuxCNC logic to improvise the safety function.

## Four-layer cell model

### Layer 1 — ordinary production control

Robot program, ordinary PLC sequencing, LinuxCNC/HAL where present, HMI commands, part-present logic, production turntable sequence.

These may request motion or report state. They are not personnel-safety authority merely because they know the robot's intended position.

### Layer 2 — safety sensing and safety logic

E-stops, guard switches, light curtains/scanners, safely evaluated position/speed where required, safety controller and safety communication.

This layer determines the credited protective response.

### Layer 3 — safety final elements

Depending on the actual machine: drive-integrated STO/SS1/safe motion, redundant safety contactors, monitored valves, brakes, or other safety-related final elements.

The exact installed final element must come from machine evidence. A generic list is not a machine claim.

### Layer 4 — physical hazard result

Robot torque/motion, turntable motion, gravity/external load, pneumatic/hydraulic motion, welding/process energy, stored energy, and any unaffected-zone hazards.

Validation must reach this layer rather than stopping at a controller indication.

## Zone-specific failure-path worksheet

For each zone, answer all of the following from installed evidence:

| Question | Required evidence |
|---|---|
| What protective device demands the stop/restriction? | device identity + safety input path |
| What safely establishes robot/turntable/axis position? | safety-rated position/speed path where credited |
| Which zone(s) are affected? | validated safety logic / application design |
| Which zone(s) intentionally remain productive? | validated separation and hazard analysis |
| What final element acts? | STO/SS1/contactors/valves/brakes as actually installed |
| What feedback proves final-element state? | EDM, safe drive status, valve/brake monitoring as applicable |
| What physical hazard actually ceases or is constrained? | direct physical validation appropriate to the hazard |
| What energy remains? | electrical, DC bus, gravity, pneumatic, hydraulic, thermal/process |
| Can a single common failure invalidate multiple zones? | shared supply, return, network, connector, sensor, config, output path |
| What is required after demand clears? | reset/restart/rearm sequence; stale-command handling |

## Common-cause and adversarial review

1. **Shared safe-position evidence:** if one position sensor or common reference participates in both zone decisions, determine whether one fault can falsely make both accesses appear safe.
2. **Shared safety-controller/configuration fault:** a logically separated zone design can still have a common configuration or I/O-mapping dependency.
3. **Shared output power/return:** independent output bits do not prove independent physical final elements.
4. **Robot controller as a common final element:** if both zone decisions ultimately rely on the same robot safety interface, verify the behavior of that interface under single faults and communication loss rather than treating two upstream zones as two independent shutdown paths.
5. **Uncredited process hazards:** welding energy, pneumatic clamps, turntable stored energy, gravity loads, and adjacent automation may survive a robot stop.
6. **Restart visibility:** clearing a light beam or leaving a scanner field must not silently convert stale ordinary-control commands into hazardous motion unless the validated safety architecture explicitly permits and proves the restart sequence.
7. **Service door vs material opening:** do not assume a zone-local material-opening rule also applies to a service-door demand. The SICK example documents broader stopping behavior for the service door.

## LinuxCNC / OpenPressBrake transfer

`INFERENCE`: a future LinuxCNC automation cell may receive safe-zone status for diagnostics, permissive sequencing, or HMI display, but ordinary LinuxCNC/HAL/FPGA logic must not become the sole authority for the personnel-safety zone decision without a separately justified safety architecture.

A useful interface is one-directionally conservative:

- safety system may remove or withhold actuator authority regardless of LinuxCNC state;
- LinuxCNC may choose not to move even when safety is ready;
- safety-ready does not itself mean START;
- LinuxCNC reboot/network recovery/FPGA watchdog recovery does not itself reset the safety system;
- a safety demand should invalidate or require deliberate requalification of stale ordinary motion commands before actuator authority returns.

## Minimum-safe-to-operate gate for zoned cells

Do not expose personnel to a zone claimed safe while an adjacent zone remains productive unless installed evidence establishes:

1. protective-device coverage;
2. safely evaluated zone/position condition where credited;
3. safety-logic mapping;
4. exact final-element path;
5. feedback/diagnostic path required by the architecture;
6. physical hazard result in the entered zone;
7. retained-energy hazards;
8. common-cause dependencies between entered and productive zones;
9. reset/restart behavior;
10. validation under representative single-fault conditions required by the design.

A safety-critical `UNKNOWN` in that chain means the exposed state is **NOT CLEARED**. Experimental operation must keep people outside the danger zone and use an independently removable/controlled energy state appropriate to the test.

## Evidence classifications

- `DOC-CONFIRMED`: SICK double-cell application uses Flexi Soft, M4000 access protection, IN4000 safe-position sensing, service-door safety switch, E-stops, context-dependent access response, and reset after complete stop.
- `DOC-CONFIRMED`: Rockwell robot-cell example exposes two safety contactors as zone outputs powering robot control.
- `DOC-CONFIRMED`: SICK SRAP combines scanner fields and Flexi Soft to request reduced or stopped robot motion based on worker position and can use monitored restart sequencing where permitted by the application.
- `INFERENCE`: the four-layer model and transfer rules above are conservative engineering abstractions from those manufacturer examples.
- `UNKNOWN`: exact final-element implementation and retained-energy state in the SICK double-cell example.
- `UNKNOWN`: any machine-specific PL/SIL/DC, stopping time/distance, safe speed, brake torque, fluid pressure, or OpenPressBrake zone architecture not explicitly established by installed evidence.

## Next evidence target

The next useful branch is **pneumatic/hydraulic zone final-element proof**: find a manufacturer/OEM application that exposes protective demand -> safety logic -> redundant/monitored dump or blocking valve -> pressure/motion result -> reset/restart. This complements the robot electrical final-element examples and tests whether the same four-layer model survives fluid-power hazards without pretending that `valve command OFF` proves pressure removal.
