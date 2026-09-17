# Professional Press-Brake Safety Maintenance Evidence Trace — TRUMPF TruBend Series 2000 (B35)

## Purpose

This is a source-tracing exercise, not a design endorsement or a claim that OpenPressBrake has equivalent safety performance. It follows one current public OEM press-brake manual far enough to connect routine safeguarding checks, safety-function effects, hazardous-energy boundaries, maintenance isolation, hydraulic/gravity hazards, and return-to-service implications.

Frozen rule:

> **Periodic safety maintenance must challenge the credited protective chain and its physical hazard result. A healthy controller indication, LinuxCNC/HAL bit, FPGA register, or successful production cycle is not a substitute for the OEM-required physical/functional check.**

Evidence labels are limited to `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`.

## Source identity

Primary OEM source:

- `DOC-CONFIRMED` — TRUMPF, *Operator's manual TruBend Series 2000 (B35)*, document B1161en, dated 2023-05-01, public PDF hosted by TRUMPF.
- This trace uses the public manual only. It does **not** claim access to the machine's complete electrical schematics, hydraulic schematic, safety-controller project, BendGuard parameter set, maintenance manual, or installed-machine configuration.

Supporting source:

- `SOURCE-CONFIRMED` — OSHA 29 CFR 1910.147 for servicing hazardous-energy control and periodic inspection of the energy-control procedure. This source is used only for the regulatory boundary it actually covers; it is not treated as a press-brake functional-safety design standard.

## 1. OEM protective architecture visible in the manual

`DOC-CONFIRMED` — The public TruBend manual identifies side safety doors, rear safety door, EMERGENCY STOP, PRESS BEAM DOWN foot switch with stop function, BendGuard optoelectronic safeguarding, machine main switch, backgauge drives, and the hydraulic unit as safety-relevant elements.

`DOC-CONFIRMED` — Opening both side safety doors during operation triggers EMERGENCY STOP and deactivates PRESS BEAM UP. Opening one side door stops axis movement. Opening the monitored rear safety door during machining triggers EMERGENCY STOP.

`DOC-CONFIRMED` — An interrupted BendGuard light field or obstacle-induced displacement causes the press beam to stop during the portion of travel in which the device is active. Below the mute point the manual describes reduced-speed motion and the optoelectronic protective device as inactive.

`DOC-CONFIRMED` — The manual states that EMERGENCY STOP stops control, press-beam motion and backgauge-axis motion, deactivates PRESS BEAM UP, leaves backgauge drives supplied while unable to generate power through STO, and switches off the hydraulic unit.

### Architecture consequence

`INFERENCE` — This is not one undifferentiated `SAFE` bit. The public evidence exposes several distinct layers:

1. protective demand — door, E-stop, foot-switch stop, BendGuard;
2. safety/control response — stop or inhibit commands;
3. final-element/energy response — backgauge STO and hydraulic-unit switch-off are explicitly described for some demands;
4. physical hazardous effect — press-beam/backgauge motion stops;
5. residual/stored energy — not proven absent merely because the hydraulic unit is switched off.

For an OpenPressBrake curriculum architecture, LinuxCNC/HAL/FPGA belongs outside the sole personnel-safety authority for these credited functions. Ordinary-control diagnostics may mirror state but do not replace the independent protective chain.

## 2. What the OEM requires the user to challenge periodically

`DOC-CONFIRMED` — The manual requires the following guards to be checked for integrity and functionality **once per shift and after a collision**:

- side safety doors — operation of the safety switch;
- rear safety door — operation of the safety switch;
- EMERGENCY STOP / PRESS BEAM DOWN foot switch with stop function — correct EMERGENCY STOP function.

`DOC-CONFIRMED` — The operator must also check the machine for externally visible defects/damage at least once per shift.

`DOC-CONFIRMED` — The user is told to ensure maintenance occurs at prescribed intervals and to conduct regular visual inspections of components whose damage could jeopardize operational safety, with hydraulic hoses and pressure containers given as examples.

### Latent failures these checks can expose

The following are bounded engineering interpretations of the OEM checks, not claims about the internal safety circuit:

| Periodic challenge | Physical/functional observation demanded by the public manual | Latent failure class it can reveal | Evidence class |
|---|---|---|---|
| Side-door safety switch | Door challenge produces the documented safety response | failed/misaligned/bypassed door sensing or response path | `INFERENCE` from `DOC-CONFIRMED` test requirement |
| Rear-door safety switch | Door challenge produces the documented safety response | failed/misaligned/bypassed rear access interlock or response path | `INFERENCE` |
| E-stop / foot-switch stop | Stop function operates correctly | dormant stop input/path/final-response defect | `INFERENCE` |
| External defect/damage inspection | damage visible to operator is identified before continued use | collision, loosened/damaged guard, cable/hose/structure defect visible externally | `INFERENCE` |
| Hydraulic hose/pressure-container visual inspection | damage/aging condition is found before failure | degradation not necessarily visible to software diagnostics | `INFERENCE` |

A production shift with no protective demand does not exercise these dormant paths. That is why normal successful bending is not equivalent to the specified functional check.

## 3. What remains energized or hazardous after a stop

`DOC-CONFIRMED` — Under EMERGENCY STOP, the backgauge drives remain supplied but are described as unable to generate power through STO.

`DOC-CONFIRMED` — EMERGENCY STOP switches off the hydraulic unit, but the manual separately identifies hydraulic pressure, hot oil, hose failure, suspended/moving assemblies, and the press beam as hazards in maintenance/disassembly contexts.

`DOC-CONFIRMED` — During disassembly, TRUMPF explicitly requires lowering moving assemblies/suspended loads where possible, securing/supporting defective or suspended assemblies, relieving pressure in pressurized components, and notes that the press beam can fall if hydraulic components are removed first.

### Maintenance consequence

`INFERENCE` — `hydraulic unit OFF` is therefore a narrower claim than `hydraulic/gravity hazard controlled`. Likewise `STO active` is narrower than `all electrical energy isolated`. The servicing task must identify the hazardous energy actually relevant to exposure and control/verify it independently.

`SOURCE-CONFIRMED` — OSHA 1910.147 separately requires covered servicing to isolate hazardous energy, control stored/residual energy, and verify isolation. Control-circuit stop commands are not themselves energy-isolating devices under that rule.

## 4. Normal safeguarding versus servicing isolation

`DOC-CONFIRMED` — TRUMPF warns that, unless expressly described otherwise, maintenance work is to be performed with the machine correctly switched off, MAIN SWITCH off, and secured with a padlock.

`DOC-CONFIRMED` — The main switch is described as interrupting machine voltage supply in position 0 and as capable of being padlocked against switch-on.

`DOC-CONFIRMED` — The manual also exposes a special energized-electrical-cabinet service boundary: a rear key switch can defeat automatic cabinet-door voltage interruption for maintenance by trained personnel, and the key must be removed and kept safely.

### Curriculum consequence

`INFERENCE` — This is a useful professional example of three separate states that must not be collapsed:

- machine safeguarded for normal production;
- machine stopped by a protective function;
- machine physically isolated/controlled for a servicing exposure.

The existence of an authorized energized-service mode does not convert ordinary maintenance into energized work, and possession of a service key is not proof that the task's hazards are controlled.

## 5. Return-to-service and change/repair invalidation

The public manual does not expose a complete post-repair safety-validation matrix. Therefore the exact TRUMPF revalidation sequence after replacement of a safety switch, safety controller, hydraulic valve, BendGuard component, drive, or wiring remains `UNKNOWN` in this trace.

However:

- `DOC-CONFIRMED` — the OEM requires the named guards/stop functions to be functionally checked once per shift and after a collision;
- `DOC-CONFIRMED` — damaged safety-relevant components and hydraulic hoses require attention under maintenance instructions;
- `SOURCE-CONFIRMED` — OSHA's servicing return-to-service boundary requires inspection for operational integrity and safe personnel positioning before energy is restored for covered LOTO work.

`INFERENCE` — A repair that touches a credited safety path invalidates at least the evidence for the affected path until applicable documentation/configuration review and a physical functional challenge re-establish it. The scope may need to expand if the change can propagate through shared power, wiring, configuration, final elements, hydraulic plumbing, guard geometry, or common diagnostics.

Do **not** infer that the once-per-shift OEM operational check is a complete post-repair validation of every safety claim.

## 6. Evidence gaps deliberately left open

The following remain `UNKNOWN` from the public evidence used here:

- safety-controller make/model, program, CRC/signature and exact logic;
- safety category / PL / SIL of each function;
- exact redundancy, diagnostic coverage, discrepancy timing or test-pulse architecture;
- exact hydraulic safety-valve topology and spool truth table;
- whether hydraulic pressure is dumped, trapped, blocked or otherwise controlled in each stop state beyond the manual's stated hydraulic-unit switch-off;
- accumulator presence, capacity, precharge, discharge method or safe pressure threshold;
- actual stopping time/distance for the press beam or backgauge;
- BendGuard safety distance, mute-point setup and installed validation values;
- EDM/final-element feedback topology;
- exact main-switch isolation boundary and any separately supplied circuits on a specific installed machine;
- maintenance-manual intervals not reproduced in the public operator/install manual;
- post-component-replacement proof-test sequence;
- installed-machine deviations/options.

These are not to be filled with generic press-brake assumptions.

## 7. OpenPressBrake transfer worksheet

Before crediting an analogous OpenPressBrake safety function, require machine-specific evidence for each row.

| Claim | Independent protective demand | Independent safety authority | Final element | Physical hazardous-energy result | Periodic challenge | Repair/change revalidation | Status |
|---|---|---|---|---|---|---|---|
| Front point-of-operation protection | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN — NOT CLEARED` |
| Side/rear access protection | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN — NOT CLEARED` |
| E-stop | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN — NOT CLEARED` |
| Backgauge hazardous motion removal | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN — NOT CLEARED` |
| Ram/hydraulic hazardous-motion control | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN` | `UNKNOWN — NOT CLEARED` |
| Servicing electrical isolation | task-specific | not LinuxCNC | installed isolating device `UNKNOWN` | task-specific absence/control of hazardous electrical energy | procedure-specific | change-specific | `UNKNOWN — NOT CLEARED` |
| Servicing hydraulic/gravity control | task-specific | not LinuxCNC | installed isolation/restraint `UNKNOWN` | task-specific pressure/load control | procedure-specific | change-specific | `UNKNOWN — NOT CLEARED` |

## 8. Practical lesson

The strongest reusable lesson from this OEM trace is not a numeric threshold. It is the maintenance architecture:

1. identify the protective device and the physical hazard it protects against;
2. periodically challenge dormant safety paths rather than infer health from production;
3. observe the actual documented machine response, not only software state;
4. distinguish a protective stop from hazardous-energy isolation;
5. account for stored hydraulic/gravity/electrical energy before exposed maintenance;
6. treat collision, repair, replacement and configuration change as evidence-invalidating events within their real change radius;
7. keep machine-specific performance and acceptance values `UNKNOWN` until authoritative installed evidence establishes them.

No simulation or executable verification is justified for this source-tracing task.