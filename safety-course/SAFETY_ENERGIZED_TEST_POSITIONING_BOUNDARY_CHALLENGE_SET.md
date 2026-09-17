# Energized Test / Positioning Boundary Challenge Set

Status: curriculum engineering artifact — 4000 safety course

## Purpose

Teach the narrow transition between a genuinely necessary energized test/positioning step and ordinary servicing that should remain under hazardous-energy control.

This is not a machine-specific procedure. Installed energy-isolation points, hydraulic/gravity behavior, safe distances, pressure thresholds, stopping times, permitted operating modes and protective-device performance remain `UNKNOWN` until supported by machine evidence.

## Provenance

- `SOURCE-CONFIRMED` — OSHA 29 CFR 1910.147(f)(1) permits temporary removal of lockout/tagout devices only when necessary to energize equipment for testing or positioning, using a defined sequence: clear tools/materials, remove employees, remove LOTO devices, energize/test or position, then deenergize all systems and reapply energy-control measures before servicing continues.
- `SOURCE-CONFIRMED` — OSHA 1910.147(d) separately requires preparation, orderly shutdown, physical isolation of required energy-isolating devices, control of stored/reaccumulating energy and verification of isolation before covered work begins.
- `SOURCE-CONFIRMED` — OSHA's 2024-10-21 interpretation says the 1910.147(f)(1) transition is limited to the time actually required for testing/repositioning and does not permit disregarding hazardous-energy control during other portions of servicing. Where personnel cannot be removed from the danger area during the necessary energized step, effective employee protection is still required.
- `SOURCE-CONFIRMED` — OSHA's testing-machine guidance emphasizes that transition periods carry significant exposure risk and that the sequence protects continuity of employee protection.
- `INFERENCE` — For a home-shop/non-employment teaching context, the same transition discipline is a useful engineering pattern even where the cited workplace rule is not legally applicable. Do not mislabel a tag or an HMI state as physical energy isolation.

## Boundary model

Keep these states distinct:

`SAFEGUARDED NORMAL OPERATION`

`!=`

`SERVICING UNDER VERIFIED ENERGY CONTROL`

`!=`

`BOUNDED ENERGIZED TEST/POSITIONING TRANSITION`

`!=`

`RETURN TO VERIFIED ENERGY CONTROL`

`!=`

`RETURN-TO-SERVICE RELEASE`

A test/positioning transition is not a convenient service mode. It exists because a specific observation or position cannot reasonably be obtained while deenergized.

## Entry gate — prove why energy is necessary

Before entering an energized test/positioning state, record:

1. Exact question the energized state answers.
2. Which energy source(s) must be restored and why.
3. Which energy sources do **not** need restoration and therefore remain isolated.
4. Required machine motion/pressure/voltage/feedback observation, without inventing acceptance values.
5. Who could be exposed and how they are kept out of the hazardous area.
6. Protective measures required during the energized interval.
7. Exact condition that ends the energized interval.
8. How stale commands and retained ordinary-control state are neutralized before energization.
9. How the machine returns to physical isolation and how isolation is reverified before hands-on work resumes.

If the only reason is convenience, speed, avoiding repeated isolation, or maintaining production, the challenge answer is **BOUNDARY REJECTED** unless a separately applicable, evidence-backed safeguarding method governs the task.

## Required transition sequence

For curriculum exercises, the learner must preserve this ordering unless a more stringent machine-specific procedure is source-confirmed:

1. Stop hands-on servicing.
2. Account for personnel and exposure status.
3. Clear loose tools/materials and restore components needed for the bounded test.
4. Establish the protective arrangement for the energized interval.
5. Confirm ordinary commands are neutral/stale commands cannot create unintended motion.
6. Remove only the energy-control devices required by the authorized transition procedure.
7. Restore only the energy needed for the test/positioning objective where the machine architecture permits selective restoration.
8. Perform the minimum bounded test/positioning action.
9. End the energized interval.
10. Deenergize the applicable systems.
11. Reapply physical energy-control measures.
12. Relieve/restrain stored energy and address reaccumulation.
13. Reverify isolation independently of LinuxCNC/HAL/FPGA/HMI indications.
14. Only then resume exposed servicing.

## Ordinary-controller boundary

LinuxCNC, HAL, normal FPGA logic, an HMI, EtherCAT/Etherbone state, drive command words and proportional-command values may support diagnostics and normal-control inhibition. They are not by themselves proof that hazardous energy is physically isolated.

For every challenge ask separately:

- What did normal control command?
- What did the independent safety system permit?
- What did the final contactor/valve/brake actually do?
- What hazardous energy physically remained?
- What independent observation proves the physical state?

## Challenge 1 — press-brake pressure transducer diagnosis

A technician has a press brake isolated for hydraulic service. A pressure reading is implausible only when the pump runs. They propose leaving the pump running while loosening a hydraulic fitting and probing wiring.

Expected classification: **REJECT**.

Reasoning target: energized observation may be necessary, but exposed hydraulic service is not thereby authorized. Split the task: restore only what is necessary for a bounded observation with personnel protected from the hazard, capture evidence, then deenergize/re-isolate/verify before manipulating fittings or exposed hazardous components. Ram/gravity restraint and exact hydraulic isolation remain `UNKNOWN` until machine evidence exists.

Failure-path probes:

- Pump off does not prove stored pressure absent.
- Proportional command = 0 does not prove hydraulic isolation.
- Safety output OFF does not prove gravity hazard controlled.
- A pressure sensor reading cannot automatically serve as the sole proof of isolation unless the machine procedure establishes that measurement chain for that purpose.

## Challenge 2 — servo axis encoder alignment

A servo axis must move a small amount to establish an encoder/index relationship. The technician wants to keep a guard open and repeatedly jog from LinuxCNC while standing in the motion envelope.

Expected classification: **REJECT AS STATED**.

Reasoning target: first prove that powered positioning is genuinely required. Then use a bounded machine-appropriate protected setup/test arrangement, remove people from the hazard where practicable, perform only the required motion, and return to verified energy control before exposed mechanical work resumes. Do not infer that a LinuxCNC jog limit, low commanded velocity or software soft limit is a personnel-safety function.

## Challenge 3 — plasma torch no-motion electrical test

A technician needs to determine whether a torch-enable output reaches an interface board. Axis motion is not needed.

Expected classification: **SELECTIVE-ENERGY OPPORTUNITY**.

Reasoning target: challenge the assumption that the whole machine must be energized. Keep motion and other unnecessary hazardous-energy domains isolated if architecture permits. If torch/process energy itself creates a hazard, control that separately. Use electrical test methods appropriate to the circuit and return to the documented isolated state before exposed wiring changes.

## Challenge 4 — mill contactor/EDM troubleshooting

A contactor drops out correctly but the safety controller reports EDM disagreement. A technician proposes jumpering the EDM input while cycling the machine to see whether production motion returns.

Expected classification: **REJECT**.

Reasoning target: the diagnostic question is whether the feedback path or final element is inconsistent, not whether bypassing the diagnostic permits operation. Preserve the fault evidence. If energized measurement is necessary, bound the test and independently observe contactor state. A jumper that makes the safety controller 'happy' destroys evidence and can mask a welded/stuck final element.

## Challenge 5 — robot/cell observation requiring line of sight

A fault occurs only during a powered sequence. The best viewing position is inside the safeguarded space.

Expected classification: **DO NOT ENTER MERELY FOR VISIBILITY**.

Reasoning target: first seek remote observation such as cameras, external indicators, traces or measurement points. If a person must remain in an area where ordinary safeguarding is altered, only a machine-specific evidence-backed protected mode/procedure can justify it. 'I need to see it' is not an energy-control method.

## Challenge 6 — hydraulic block removal after a test

A vertical machine member was mechanically blocked during servicing. Energy was temporarily restored for a test. After the test the control reports zero pressure, and the technician starts removing the block before reapplying the isolation procedure.

Expected classification: **REJECT**.

Reasoning target: the energized test interval must close before exposed servicing resumes. Reestablish energy control, address stored/reaccumulating energy, verify isolation, and prove the physical function that will safely take over the load before changing a restraint state. Do not invent the machine's gravity-retention architecture.

## Challenge 7 — repeated 'just one more jog'

During troubleshooting, a team cycles between hands-on adjustment and powered jog twenty times. After several cycles they stop reapplying all isolation steps because it is slow.

Expected classification: **PROCESS DESIGN FAILURE / STOP AND REDESIGN**.

Reasoning target: repeated bypass pressure is engineering evidence. Redesign the diagnostic method, access, test points, fixture, setup mode or observation method so the safe transition is practical. Repetition does not convert a narrow test/positioning transition into ordinary energized servicing.

## Challenge 8 — stale command after test

LinuxCNC had a held jog command when energy was removed. The safety chain is later reset for a bounded test. Network and FPGA state have also recovered.

Expected classification: **NO MOTION AUTHORITY UNTIL FRESH REARM/COMMAND CONDITIONS ARE PROVED**.

Reasoning target: safety reset, LinuxCNC recovery, FPGA watchdog recovery and machine START are distinct. The test plan must challenge stale/held commands and require a deliberate fresh motion condition before actuator authority. Exact implementation is machine-specific.

## Challenge 9 — electrical cabinet measurement

A measurement requires an energized conductor while unrelated hydraulic and motion systems are not required.

Expected classification: **DO NOT GENERALIZE THE LOTO TEST/POSITIONING EXCEPTION**.

Reasoning target: energized electrical work has its own applicable electrical-safety requirements and is not automatically justified by 1910.147(f)(1). Keep unrelated hazardous-energy domains isolated. The curriculum must not use one safety rule outside its scope.

## Challenge 10 — home-shop unattended incomplete machine

A builder stops midway through troubleshooting after temporarily defeating a guard switch. Power is removed at the wall switch and they plan to continue tomorrow.

Expected classification: **NOT SAFE TO LEAVE AS AN ORDINARY OPERABLE MACHINE**.

Reasoning target: restore the safeguard if practical; otherwise remove/control relevant hazards and leave an unmistakable `OUT OF SERVICE / DO NOT OPERATE` condition. A tag communicates status; it does not substitute for physical control of hazardous energy. Make restoration easier than continued defeat.

## Evaluator scoring gates

A passing answer must:

- identify whether energization is genuinely necessary;
- separate energized observation from exposed servicing;
- minimize restored energy to what the objective needs where architecture permits;
- account for personnel before energization;
- preserve independent safeguarding during the energized interval;
- explicitly close the energized interval before hands-on servicing resumes;
- reapply and reverify physical energy control;
- address stored/reaccumulating energy;
- distinguish LinuxCNC/FPGA/HMI state from physical isolation;
- address stale commands/rearm/start separation;
- avoid invented machine-specific physical facts;
- treat repeated bypass pressure as a design/process defect rather than normalizing the bypass.

Critical fail conditions:

- recommending hands-on work in an exposed hazardous state merely because motion is 'slow' or command is zero;
- treating E-stop, HAL enable, FPGA watchdog or drive command-off as an energy-isolating device without machine-specific evidence;
- allowing exposed servicing to resume before re-isolation and verification;
- using a bypass/jumper to suppress the very diagnostic evidence under investigation;
- assuming a home-shop tag physically removes a hazard.

## Transfer across machines

- Press brake: hydraulic pressure, gravity/elevated ram, pump, valves, drives and electrical domains may require separate treatment.
- Plasma: motion, torch/process energy, high voltage/high frequency and gas/process sources are not one energy domain.
- Mill/lathe: spindle, axis drives, gravity axes, stored DC-bus energy, pneumatics/hydraulics and tooling hazards differ.
- Robot/cell: zone access, multiple machines, stored motion/loads and restart visibility can dominate the transition.

The learner must trace the actual machine. The challenge set teaches the method, not a universal isolation diagram.

## Information-gain stop

No simulation is justified by this module. The unresolved questions are installed-machine procedural and physical facts, not software behavior. Future OpenPressBrake application work should wait for actual machine safety wiring/hydraulic/mechanical evidence before filling those fields.
