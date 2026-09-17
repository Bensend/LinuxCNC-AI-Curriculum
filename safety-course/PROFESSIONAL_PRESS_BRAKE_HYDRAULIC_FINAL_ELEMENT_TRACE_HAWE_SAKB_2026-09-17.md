# Professional press-brake hydraulic final-element trace — HAWE SAKB

Date: 2026-09-17
Lane: independent safety curriculum Lane B

## Question

What can a current manufacturer press-brake hydraulic package prove about the physical layer between ordinary motion commands and a gravity-loaded press ram, without inventing an OpenPressBrake hydraulic truth table?

## Evidence source and provenance

Primary source: HAWE Hydraulik SE, `Control system for CNC press brakes type SAKB`, product documentation D 6335, edition 08-2025 / 1.1 en, generated 2025-08-26. Manufacturer-hosted PDF: https://downloads.hawe.com/6/3/D6335-en.pdf

Evidence labels used here:

- `DOC-CONFIRMED` — explicitly stated/shown by the manufacturer document.
- `SOURCE-CONFIRMED` — source identity/document provenance established.
- `INFERENCE` — engineering conclusion bounded by the cited facts.
- `UNKNOWN` — not established by this evidence package.
- `TEST-CONFIRMED` — reserved for physical test evidence; none is claimed here.
- `COMMUNITY-REPORTED` — none used here.

## Physical architecture exposed by D 6335

`SOURCE-CONFIRMED / DOC-CONFIRMED`: HAWE identifies SAKB as a hydraulic control system intended for CNC press brakes and states that the system has been verified for intended use under DIN EN 12622 certification. The current document identifies DGUV test certificate HM HM 240120.

`DOC-CONFIRMED`: The SAKB central manifold contains:

- two proportional directional valves, `0-QN10` and `0-QN20`, for cylinder direction/position control;
- two pilot-controlled 2/2 directional seated valves, `0-QM11` and `0-QM21`;
- two counterbalance/pressure-limiting valves, `0-RV11` and `0-RV21`;
- a 4/2 directional spool valve, `0-QM1`;
- proportional pressure control;
- control of two separate anti-cavitation valves.

`DOC-CONFIRMED`: HAWE says the seated valves are used for **holding the cylinders up**. The two anti-cavitation valves are mounted separately, directly on the cylinder bases, and are used to fill and empty the cylinders during rapid movement. HAWE explicitly restricts this SAKB system to its specified NSV anti-cavitation valves; other anti-cavitation valves are not permitted.

This is valuable because it makes the load-holding layer visible as physical hydraulic elements rather than collapsing the ram state into `pump on/off` or an HMI status bit.

## Monitoring layer

`DOC-CONFIRMED`: In SAKB version `S` with valve monitoring, HAWE states that the two proportional directional valves, the two holding valves, and the 4/2 directional valve are equipped with position monitoring.

Therefore the architecture exposes at least three distinct evidence layers:

1. electrical command/coil state;
2. monitored valve position for specified valves;
3. actual cylinder/ram physical result.

`INFERENCE`: A valve-position signal is stronger evidence than command state alone, but it does not by itself prove cylinder load is safely supported, hydraulic pressure is absent, leakage is acceptable, or the ram is mechanically restrained. Those remain separate physical claims.

## Sequence evidence

`DOC-CONFIRMED`: D 6335 includes a manufacturer sequence diagram covering rapid downward traverse, mute point, operation, holding time, decompression and rapid return, and separately shows command/position-indicator rows for the proportional directional valves, 4/2 spool valve and seated holding valves.

`INFERENCE`: This demonstrates that safe analysis of a press hydraulic system must preserve phase/state dependence. A valve combination valid for normal downward travel cannot be promoted into a universal safe state without the machine-specific safety logic, certified application conditions, load behavior and physical validation.

## Demand-to-final-element matrix

| Layer | What this source establishes | Evidence state |
|---|---|---|
| Protective device / E-stop demand | Not exposed in D 6335 | `UNKNOWN` |
| Safety logic/controller | Not exposed as a complete machine safety circuit | `UNKNOWN` |
| Ordinary CNC/hydraulic command | Proportional and directional valve command architecture is exposed | `DOC-CONFIRMED` |
| Hydraulic final elements | Directional valves, seated holding valves, counterbalance valves and cylinder-mounted anti-cavitation valves are exposed | `DOC-CONFIRMED` |
| Final-element feedback | Position monitoring is available on two proportional valves, two holding valves and the 4/2 valve in monitored version S | `DOC-CONFIRMED` |
| Cylinder holding function | HAWE explicitly identifies seated valves as holding the cylinders up | `DOC-CONFIRMED` |
| Pressure absent / system depressurized | Not proven merely by holding-valve state | `UNKNOWN` |
| Ram physically restrained for exposed maintenance | Not established by this hydraulic product document | `UNKNOWN` |
| Complete machine stopping distance/time | Not established | `UNKNOWN` |
| OpenPressBrake valve truth table | Not established | `UNKNOWN` |
| OpenPressBrake pressure thresholds/settings | Not established | `UNKNOWN` |

## Frozen architecture lessons

### 1. `PUMP OFF != RAM RESTRAINED`

A gravity-loaded press axis has a load-holding problem independent of pump command. The professional reference explicitly contains cylinder-holding valves and cylinder-mounted anti-cavitation elements. OpenPressBrake must not treat pump-motor removal alone as proof that the ram cannot descend.

### 2. `VALVE COMMANDED CLOSED != VALVE POSITION CONFIRMED != LOAD HELD`

These are separate claims. Where final-element feedback is credited, the actual monitored valve and failure mode must be named. Physical ram/load behavior still requires machine validation.

### 3. `PRESSURE REMOVED != FLOW BLOCKED != LOAD HELD != MECHANICALLY RESTRAINED`

These states must remain separate in curriculum diagrams, commissioning records and maintenance procedures. A pressure gauge or dump path cannot automatically prove a gravity load is restrained; conversely a holding valve does not prove all stored pressure is discharged.

### 4. Safety authority stays outside ordinary LinuxCNC/HAL/FPGA

The SAKB source exposes the hydraulic final-element layer but not the complete protective-device-to-safety-logic chain. Therefore it is invalid to infer that ordinary LinuxCNC/HAL/FPGA outputs may be sole personnel-safety authority. A future OpenPressBrake design must trace the independent safety demand all the way to the hydraulic final elements required by its risk assessment and validate the physical result.

### 5. Certified component/application evidence is bounded

HAWE's DIN EN 12622 certification statement and DGUV certificate identity apply to the documented SAKB configuration/application envelope. They are not an OpenPressBrake certification, do not establish an OpenPressBrake PL/SIL, and do not transfer unspecified valve settings or timing values.

## Failure-path questions promoted into the curriculum

1. If a proportional command disappears but a holding valve fails to reach its required state, what independent safety action prevents hazardous descent?
2. Can one wiring/common-power/configuration failure falsely report multiple monitored valves in the expected state?
3. What physical witness proves the ram actually stops/holds after the safety demand?
4. What controls residual pressure after motion is blocked?
5. What prevents reaccumulation or gravity-driven movement during servicing?
6. What physical restraint/blocking is required when personnel enter a zone where hydraulic holding alone is not sufficient for the task?
7. After reset/rearm, can a stale LinuxCNC/HAL/FPGA command immediately reopen a motion path?
8. Which installed valve positions are safety-relevant, and how are their feedback channels challenged during commissioning and periodic validation?

## OpenPressBrake UNKNOWN register

Do not fill these from analogy to SAKB:

- exact hydraulic topology;
- normal/safety valve truth table;
- valve make/model or monitored contacts;
- required redundancy/category/PL/SIL;
- pressure settings or acceptable residual pressure;
- ram mass/gravity force;
- stopping distance/time;
- leakage/holding acceptance values;
- mechanical restraint method;
- protective-device demand mapping;
- reset/restart sequence.

These require installed-machine evidence, design decisions, manufacturer data and/or physical validation.

## Compute decision

No simulation or executable verification was justified. Manufacturer documentation answered the source-tracing question. No GitHub-hosted runner and no self-hosted runner compute was consumed.

## Next independent evidence branch

Trace a professional hydraulic press/vertical-axis implementation that exposes **the missing upstream safety chain**: protective device or E-stop -> safety logic -> monitored hydraulic blocking/dump/holding final elements -> physical load result -> reset/restart. Prefer a complete OEM wiring/hydraulic drawing or certified application manual. If public evidence again stops at a hydraulic component package, rotate to an independent safety-validation branch rather than inventing the missing machine logic.