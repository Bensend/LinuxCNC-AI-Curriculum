# 4400 — Common DC bus, regeneration, re-energization and maintenance isolation: OEM source audit
**2026-10-24 | Original research | SOURCE-READING / NOT GRADUATED / NO PHYSICAL TEST**

## Question and relation to existing work
The 2026-09-17 `STO_CONTACTOR_DC_BUS_STORED_ENERGY_BOUNDARY_STUDY` already established that STO, contactor-open and an extinguished drive indicator do not prove electrical isolation or discharged capacitors. This audit asks a **different topology question**: *can an apparently isolated inverter remain connected to an energized common DC bus, receive energy from a different axis, or become re-energized by a driven permanent-magnet motor?* Answer using original manufacturer documents before proposing any lab. This is generic multi-axis safety engineering; **no shared bus, particular VFD or PM motor is asserted to exist on OpenPressBrake**.

## Original OEM source register (inspected original PDF text)
- **ABB ACS880 multidrives cabinets and modules — Safety instructions**, `3AUA0000102301 Rev C`, effective **2023-06-19**, original instructions, pp. **15–19**: https://library.e.abb.com/public/d2ac9aa023064c27bd33317eb50dde2a/EN_ACS880_multidrives_SI_C_A4.pdf . Electrical precautions, pp. 15–16; permanent-magnet additional precautions pp. 18–19.
- **Rockwell Automation, Drives in Common Bus Configurations with Kinetix 5700 Bus Supplies**, `MOTION-AT007B-EN-P`, **September 2022**, original application technique, pp. **9–13**, **27**, **74–75**: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/motion-at007_-en-p.pdf . Common-bus types, interconnection, additional capacitance, precharge and protection.
- **Rockwell Automation, Drives in Common Bus Configurations with PowerFlex 755TM Bus**, `DRIVES-AT005E-EN-P`, **July 2023**, p. **22** (Regeneration OK) and p. **43** (Precharge Complete): https://literature.rockwellautomation.com/idc/groups/literature/documents/at/drives-at005_-en-p.pdf . These ready signals are explicitly **not** DC-bus-voltage-present indications.
- **ABB ACS880-107LC inverter units hardware manual**, manufacturer overview of common DC bus, supply unit, inverter DC fuses (optionally DC switch-disconnector), brake unit and motors: https://library.e.abb.com/public/5b85b87faffa474cb7893a6dd76519fc/EN_ACS880-107LC_HW_man_A_A4.pdf . Different product family; architectural comparison only.
- **Existing curriculum prerequisite:** `safety-course/STO_CONTACTOR_DC_BUS_STORED_ENERGY_BOUNDARY_STUDY_2026-09-17.md` and `safety-course/ENERGY_ISOLATION_VERIFICATION_WITNESS_DESIGN.md`. This audit does not replace them.

## OEM-confirmed propositions, precisely scoped
| ID | Claim | Evidence class | Exact support / limit |
|---|---|---|---|
| DCB-01 | A common bus can connect **multiple inverter drives directly to one DC link**; non-regenerative, regenerative and shunt configurations differ in power flow. | DOC-CONFIRMED | Rockwell MOTION-AT007B p.9; does not identify any selected-machine topology. |
| DCB-02 | External capacitor modules **store energy** and can extend a common DC bus to another inverter cluster; bus capacitors of different drives may be directly in parallel. | DOC-CONFIRMED | Rockwell MOTION-AT007B pp.11–12, 27, 74–75; neither an HMI status nor opening one AC branch proves absence of bus energy. |
| DCB-03 | The manufacturer requires identifying **all possible voltage sources**, including charging switch, transformer AC input bus, auxiliary supplies, optional DC feeder/DC-DC converter and **external energy storage**, before service. | DOC-CONFIRMED | ABB 3AUA0000102301C p.15. The cabinet's main disconnect may leave upstream AC input busbars live. |
| DCB-04 | After disconnection ABB specifies a **five-minute wait and direct verification** with a checked tester at input, output and DC terminals/busbars; the five minutes alone are **not** a substitute for measuring absence of voltage. | DOC-CONFIRMED | ABB pp.15–16. This is **that manual's** waiting period, not a universal value or a complete procedure for another drive. |
| DCB-05 | ABB warns that the **brake chopper/resistor**, motor terminals, DC bus and externally wired relay outputs can carry dangerous voltage, and that STO does not remove main/auxiliary voltage. | DOC-CONFIRMED | ABB p.16. |
| DCB-06 | A **rotating permanent-magnet motor can energize the drive**, including its input/output terminals. ABB calls for preventing rotation, appropriate motor separation and, for specified inverter units, DC-side isolation/fuse handling by qualified personnel. | DOC-CONFIRMED | ABB pp.18–19. Not a universal approved field procedure for other drives. |
| DCB-07 | Rockwell's **Regeneration OK** and **Precharge Complete** signals indicate bus-supply readiness for enabling connected drives, **not proof that bus voltage is present**. | DOC-CONFIRMED | Rockwell DRIVES-AT005E pp.22, 43. A low signal likewise cannot be promoted into proof of zero voltage. |
| DCB-08 | Rockwell's common-bus application technique warns that some AC-input drives **lack internal common-bus precharge** and must not be connected to an energized bus. | DOC-CONFIRMED | Rockwell MOTION-AT007B p.17, specific PowerFlex 750 frames 5/6; product-specific, not universal hot-plug guidance. |

## Causal architecture and fault-path trace
```
AC line / transformer -> supply / rectifier / regenerative AFE -> shared DC+/- bus
   |                                    |              |
   |                              optional energy      +-- inverter A -> motor A
   |                              storage / feeder     +-- inverter B -> motor B
   |                                                   +-- brake chopper / resistor
   +-- auxiliary / control power
PM motor backdriven by load -> motor leads -> associated inverter power stage / electrical path
```
This is a **generic topology diagram, not a wiring schematic**. Whether a motor can recharge a particular bus under a particular switch/fuse/semiconductor state is **UNKNOWN** without its exact hardware and connectivity. **INFERENCE:** if a supposedly isolated branch is still electrically connected to a common energized bus, it may remain hazardous despite loss of that branch's local AC feed. **INFERENCE:** a failed/open bleed path or another connected bus source can invalidate a time-only discharge assumption. ABB's documented PM backfeed warning is the manufacturer-confirmed failure mechanism; the actual re-energization path is machine-specific.

### Four authority boundaries
1. **Normal motion control:** LinuxCNC/HAL/ordinary FPGA commands deceleration, servo enable, ordinary run and displays bus status; it may not authorize personnel electrical access.
2. **Safety-related motion control:** independently engineered safety functions may inhibit torque, coordinate stops and protect access under a validated SRS. STO is **not** electrical isolation.
3. **Electrical energy isolation:** selected lockable physical isolators must cover **all** sources, DC feeders, shared links, external storage, auxiliary feeds, motor regeneration and accessible live parts relevant to the task; identify exact devices and wiring from as-built evidence.
4. **Physical service verification:** qualified personnel apply the selected OEM and site electrical safety procedure, verify tester function before/after, verify each relevant circuit, control reaccumulation and prevent unexpected re-energization. **Do not attempt energized cabinet testing as a student lab.**

## Adversarial failure paths
| Condition | Plausible mistaken conclusion | Evidence needed before personnel access |
|---|---|---|
| Local drive AC disconnect open, DC common bus still connected | “Drive A is dead” | As-built DC topology, other supply states, appropriate isolation and qualified absence-of-voltage proof |
| DC-bus status/Regeneration OK false | “Bus has zero voltage” | Physical voltage verification; readiness bit has different semantics |
| DC-bus precharge status true | “Ready means safe” | Treat as operational permission, not safe-state proof |
| STO asserted for both axes | “Bus discharged and no gravity motion” | Independent electrical isolation **and** physical load-holding evidence |
| PM axis backdriven by gravity, feeder off | “No AC supply means no voltage” | Motor/generator and mechanical restraint boundary, manufacturer procedure |
| Brake resistor/chopper wired beyond local branch | “Only the inverter has dangerous voltage” | Brake-circuit topology and isolation/thermal hazard coverage |
| Bus voltage observed zero once, external energy store not isolated | “One reading ends verification” | Reaccumulation risk, source lockout, task-specific continuing verification |
| Shared-bus fuses present | “Fuses are lockable isolators” | Product-specific disconnecting means; fuse/protection is not by itself isolation proof |
| New drive connected to live bus | “Precharge is automatic” | Product-specific precharge architecture; some OEM configurations prohibit connection to energized bus |
| Reset after maintenance with ordinary CNC start retained | “Bus supply ready is motion-safe” | Independent rearm, fresh deliberate start, physical stop/hold and personnel clearance |

## Human-factors design recommendation (INFERENCE)
Make **one obvious, lockable, labelled machine-energy boundary** plus a visible per-axis bus/feeder/auxiliary map and OEM-approved accessible test locations; avoid hidden cross-cabinet DC links. Design isolation points so technicians do not have to defeat a guard or improvise a dangerous live measurement. A lamp or controller bit can help locate a fault, never replace qualified absence-of-voltage verification. Accessible, repeatable verification is cheaper than predictable bypass.

## Machine transfer
- **Press brake:** conditional shared Y1/Y2 servo bus, brake circuit and gravity backdrive; hydraulic and mechanical holding remain separate.
- **Mill/VMC:** common spindle/axis drive bus and vertical Z restraint; coast/standstill and DC bus discharge separate.
- **Lathe:** regenerative spindle/chuck motion and multi-axis bus; guarding still needed for rotating mass.
- **Robot/cell:** multiple supplies/cabinets and backdriven vertical axes; isolate every source at the actual cell boundary.
- **Plasma/cutting:** DC bus of motion drives is distinct from plasma-source stored high-voltage energy; do not conflate.
- **Feeder/gantry:** shared servo bus and externally driven axes, accessible maintenance boundary.

## Verification status and freeze
No selected-machine drive model, common-bus presence, DC feeder, PM motor, DC switch, fuses, capacitor energy, wait time, voltage threshold, PL/SIL, stop time, restart or physical safe state established. **TEST-CONFIRMED: none.** No bench work or workflow justified by this documentary question. Do not invent numeric values. **No personnel-exposed hazardous operation or electrical servicing authorized by this lesson.** Minimum safe-to-operate threshold remains unproven; any experimental operation must be isolated/remote with people outside the danger zone and residual risk explicitly controlled.

**New frozen distinction:** `ONE DRIVE DISCONNECTED != COMMON DC BUS DE-ENERGIZED`; `READY / PRECHARGE / BUS CAPACITOR OK != SAFE TO TOUCH`; `SOURCE OFF != PM GENERATOR BACKFEED PREVENTED`.

**Information-gain stop:** selected OpenPressBrake as-built drive/DC-bus/energy-source map and qualified physical evidence required for machine claims. Rotate to another 4400 safety topic if unavailable.
