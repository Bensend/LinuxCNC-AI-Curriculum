# 2530 — E-stop Systems from First Principles: Source Preparation

Status: research/source preparation while the 2520 information-separated competency gate remains externally blocked. This does not close or bypass that gate.

## Scope

2530 must teach emergency stop as a machine-level safety function, not as a red mushroom button wired by habit. The design question is:

> What emergency action is required for the hazardous situation, what physical proposition must the machine reach, which independent safety-related path produces it, and what evidence prevents reset/restart from silently recreating the hazard?

## Evidence-backed starting points

### E-stop is complementary protection, not the primary risk-reduction method

**DOC-CONFIRMED:** Pilz's ISO 13850 FAQ states that emergency stopping is a complementary protective measure rather than the primary means of risk reduction. It also states that reset is intentional human action at the device that initiated the command, and that resetting the operated device must not itself restart the machine; it only prepares the machine for a separately commanded restart.

Source: Pilz, “Emergency stop is operated on a machine,” ISO 13850 FAQ, accessed 2026-09-22: https://www.pilz.com/en-GB/support/faq/standards/articles/180045

### Emergency stop is not synonymous with removing all machine energy

**DOC-CONFIRMED:** Pilz's ISO 13850 overview distinguishes emergency stop from emergency switching-off and explicitly notes that an emergency stop need not de-energize the complete machine. That distinction matters for hazards where controlled stopping, retained braking/control power, gravity loads, stored pressure or other machine physics make indiscriminate power removal inadequate or dangerous.

Source family: Pilz, EN ISO 13850 emergency-stop overview, accessed 2026-09-22.

### Stop category describes a stopping sequence, not a universal safety architecture

**DOC-CONFIRMED:** Rockwell's published safety-relay technical data, citing EN 60204 stop-function terminology, describes Category 0 as immediate actuator-power removal, Category 1 as controlled stopping followed by power removal, and Category 2 as controlled stopping with power remaining available. The same document states that emergency-stop reset shall not initiate restart.

Source: Rockwell Automation, `700-2.14: Safety Relays`, publication 700-TD556, emergency-stop application section: https://literature.rockwellautomation.com/idc/groups/literature/documents/td/700-td556_-en-p.pdf

**DOC-CONFIRMED:** Rockwell drive documentation likewise describes Category 0/1/2 stopping sequences and shows that braking coordination may be part of the implementation. This is useful evidence against teaching “E-stop = cut every wire/power source” as a universal rule.

Source: Rockwell Automation, Studio 5000 stopping/braking attributes, stopping sequences, accessed 2026-09-22.

### Reset design and unexpected restart are separate obligations

**DOC-CONFIRMED:** Rockwell's current Logix safety ESTOP instruction documentation distinguishes manual circuit reset from automatic reset and warns that automatic reset requires other measures to prevent unexpected/unintended startup. This is product-specific evidence of a general design distinction: input/device restoration, safety-function reset/rearm, and ordinary production start are not the same authority transition.

Source: Rockwell Automation, Studio 5000 Logix Designer v38.01, `Emergency Stop (ESTOP)`, accessed 2026-09-22: https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/emergency-stop--estop-.html

## First-principles teaching model

For each E-stop design, require the learner to derive:

`emergency situation / HZ -> required physical reaction PROP -> stop strategy -> input/device behavior -> safety-related logic -> final element(s) -> physical evidence -> reset/rearm -> fresh start demand -> validation`

Do not start from “single channel or dual channel?” or from a favorite relay. Channel architecture belongs downstream of the required safety function, fault analysis and integrity target.

## Fault questions to teach before the bench lab

1. What if one E-stop contact/wire opens during normal operation?
2. What if one channel shorts to a supply or another channel?
3. What if one input channel remains stuck in the permissive state?
4. What if an output relay/contactor contact welds?
5. What does EDM actually witness, and what physical hazard proposition does it *not* prove?
6. What if the reset input is stuck or held?
7. What if the operator releases the E-stop while the original hazard remains?
8. What if ordinary Cycle Start was held before/during the E-stop?
9. What if power returns asynchronously to safety logic, field I/O, drives and ordinary control?
10. What if the chosen Category 0 reaction removes a brake/valve/control function needed to prevent another hazard?

## Human-factors requirements

- The emergency device must be easy to identify, reach and actuate under stress.
- Reset/restart design must not reward bypassing or awkward workarounds.
- If the affected hazard zone cannot be adequately checked from the reset/start location, the risk assessment must address that visibility/occupancy problem rather than pretending the button press proves the zone clear.
- E-stop availability must not become an excuse for poor guarding, interlocking, safe setup modes or energy isolation.

## LinuxCNC boundary

LinuxCNC may receive E-stop/safety state for machine coordination and diagnostics, and ordinary control may request a stop. Do not teach normal LinuxCNC/HAL/FPGA software as the sole personnel-safety authority merely for convenience. The independent safety-related path owns the required emergency reaction unless evidence for a different safety-rated architecture is explicitly established.

## Explicit UNKNOWNs / next source work

- exact current-edition ISO 13850 and IEC 60204-1 normative wording beyond accessible manufacturer summaries;
- conditions governing emergency-stop span/segmentation across linked machines and cells;
- machine-specific selection between uncontrolled and controlled stop, including gravity/fluid-power cases;
- exact diagnostic assumptions for representative modern safety relays and their EDM/reset modes;
- performance-level/SIL target for any example machine;
- stopping time/distance for any physical machine.

These must not be invented. Next 2530 work should compare at least three current manufacturer E-stop/safety-relay application architectures, reverse-map their diagnostics/final elements to fault hypotheses, and build the incremental single-channel -> monitored/redundant teaching exercise without implying that topology alone establishes PL/SIL.

## Initial freezes

- **E-STOP PRESENT != PRIMARY RISK REDUCTION COMPLETE.**
- **E-STOP != UNIVERSAL COMPLETE ENERGY REMOVAL.**
- **STOP CATEGORY != SAFETY INTEGRITY CLAIM.**
- **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED.**
- **EDM HEALTHY != MACHINE PHYSICAL SAFE STATE PROVED.**
- **ORDINARY LINUXCNC STOP/ESTOP STATE != INDEPENDENT PERSONNEL-SAFETY AUTHORITY.**
