# 4400-MECH-01 — A suspended load has more than one way to fall

**4000 safety implementation module | 2026-10-26 | PAPER ONLY / NON-GRADUATED.** Prerequisites: 2520 hazards/SRS, 2540 final-element meaning, 2580 energy isolation, 25F0 machine transfer, and mechanical load-path reasoning.

## Learning objective
Given a raised machine cover, spring-supported guard, suspended tool or counterbalanced fixture, a fresh technician/AI must identify **the precise broken link** addressed by each arrest, auxiliary suspension and mechanical lock; separate normal control from physical retention; and design a convenient maintenance process without pretending any selected press brake is validated.

Read the two original-source audits: [ENDO spring balancer](../research/4400_ENDO_EWF_ELF_FALL_ARREST_TOP_SUSPENSION_ROPE_AND_DRUM_LOCK_SCOPE_AUDIT_2026-10-26.md) and [gas-spring/locking-shroud](../research/4400_GAS_SPRING_FAILURE_INDEPENDENT_LOCKING_SHROUD_AND_MAINTENANCE_AUDIT_2026-10-26.md).

## Three different mechanical "safety" functions
| Function | Example device | Broken link it addresses | Broken link it does NOT automatically address |
|---|---|---|---|
| **Internal spring-rupture arrest** | ENDO EWF/ELF internal pin locking drum | Loss of balancer spring torque while rope and drum remain coupled | Broken rope, bottom hook, attachment or upper suspension |
| **Secondary upper suspension** | ENDO auxiliary chain/rope to separate hanger | Failed upper hook or primary overhead hanger | Broken lower tool cable, termination or hook |
| **Positive supported-load lock** | Engineered gas-spring shroud/cover stay or appropriately designed fixture | Loss of gas spring support *if lock engages and load path survives* | Failed common pivot, broken cover hinge or under-rated bracket |

A similarly named **Yale YBA** spring balancer additionally describes rope-break/dislodged-weight arrest. Do not transfer its feature to ENDO or assume a component rating establishes assembled-machine safety.

## Four-layer authority map
1. **Ordinary LinuxCNC / FPGA control:** requests cover actuator, balancer positioning or normal axis motion; cannot guarantee personnel safety.
2. **Diagnostics:** records guard position, rope inspection status, service interlock and lock engagement **where instrumented**; a diagnostic is not itself the restraint.
3. **Independent safety-related control:** prevents hazardous actuation/access as required by the selected safety-function specification. It does not create mechanical support merely by switching outputs.
4. **Physical load restraint and energy isolation:** rated, independently anchored lock/support, stored-spring/gas-energy handling, no unsupported personnel exposure. A machine-specific qualified reviewer must validate the complete load path.

## Worked adversarial example
A service cover is held up by a gas strut. An operator opens the cover, the HMI displays GUARD OPEN and motor torque is disabled. A mechanic plans to reach beneath the cover. **Insufficient:** guard state and torque disable say nothing about the strut's retained force, bracket integrity or cover gravity. **Safer design:** a qualified independent support engages *before* reach-in, is easy to see, does not require entering the danger zone to install, and has a checked structural load path; the machine remains isolated under the relevant maintenance procedure. Do not improvise a support or claim a specific force rating without engineering evidence.

## Failure-path questions to ask before designing
- What could fall: balancer body, suspended tool, raised cover, press-brake tooling or ram? Distinguish them.
- Which part can break: spring, gas seal, rope, hook, upper anchor, hinge, support pin, or operator engagement?
- Does the proposed secondary support share a failing fastener, bracket or structure?
- Does a reset, release, removal of the load, or power restoration **reintroduce stored mechanical energy**?
- Is the lock **captive, visible, accessible and quick** enough to be used every time?
- What physical observation (not an HMI bit) would a qualified independent reviewer accept?
- Are the manufacturer's numerical instructions for the **exact installed model**, not copied from an unrelated device?

## Cross-machine transfer
Press brake: suspended tooling/guard covers, possible counterbalance only if installed; **not** proof of Y1/Y2 ram holding. Mill/lathe: tool balancer, counterweighted doors and vertical covers; distinguish spindle/axis stopping. Robot/cell: suspended end effector, tool service, elevated gates. Saw/router/plasma: heavy hinged covers and overhead accessories. Each requires a fresh hazard map and exact product identification.

## Practical human-factors design
Use captive hinges, separate approved support anchor, obvious positive engagement, accessible safe service position, short readable fault label, replacement parts and a no-bypass workflow. Never make an operator choose between holding a heavy cover and engaging its support; that predictable defeat pressure is a design failure. If minimum independent support/guarding is unavailable, do not operate with people exposed. Any separately authorized experimental operation must be isolated/remote with everyone outside the hazard zone and residual risk stated.

## Evidence, advancement and promotion
**DOC-CONFIRMED:** ENDO BMU-0002, CMCO YBA, Ameritool, Industrial Gas Springs, Newtone, OSHA 1910.147. **INFERENCE:** coverage matrix and design. **SOURCE-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED:** none. **UNKNOWN:** exact selected machine mechanisms, physical witness, structural ratings, safety performance, evaluator.

[12 public unscored paper cases](4400_MECH_01_TWELVE_UNSCORED_MECHANICAL_SUPPORT_CASES_2026-10-26.md) and [blank selected-machine witness](4400_MECH_01_BLANK_MECHANICAL_ENERGY_AND_ACCESS_WITNESS_2026-10-26.md) are **not executed**. Independent transfer evaluation remains outstanding; do not self-score. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.

**Uncertainty queue:** ENDO contradictory caution text (UNKNOWN, MEDIUM; seek OEM clarification before claiming full tool fall protection); selected OpenPressBrake counterbalance/strut presence (UNKNOWN, HIGH; restricted as-built evidence); exact support load path and physical proof (UNKNOWN, CRITICAL; blocks selected machine release); independent unseen evaluation (OPEN, HIGH). None can be guessed from an OEM brochure.
