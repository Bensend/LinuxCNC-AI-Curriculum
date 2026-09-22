# Practical Machine Safety Engineering — Course and Research Plan

## Mission

Build an open, practical machine-safety curriculum that makes meaningful risk reduction understandable and affordable for LinuxCNC builders, retrofitters, small shops, farms, schools, and engineers.

The goal is **not** to promise certification, zero risk, or legal immunity. The goal is to teach people how safety systems actually work, how failures happen, how to spend limited money where it reduces the most risk, and how to verify that a safeguard really does what the designer expects.

A central human-factors rule is:

> The safer path should also be the easier path. A guard or safeguard that is painful to use, reinstall, troubleshoot, or maintain is more likely to be bypassed or discarded.

The course therefore treats usability, maintainability, visibility, diagnostics, and cost as part of the safety design itself.

## Placement in the curriculum

This course should sit **after the LinuxCNC foundations and basic failure-engineering material, but before the machine-specific 3000-level tracks**. The existing Phase 8 safety-boundary modules remain the LinuxCNC-specific prerequisite. The new course expands from “where LinuxCNC stops” into “how the rest of the machine safety system is engineered.”

The 4000-level `4400 — Safety-oriented hardware boundaries` track remains the implementation/deep-hardware follow-on. Machine-specific tracks such as 3600 Press Brakes should consume the methods learned here rather than reinventing them.

Working number: **2500 — Practical Machine Safety Engineering**.

## Guiding principles

1. **Risk reduction, not zero-risk theater.** Every machine activity has residual risk. Teach how to identify, reduce, and state it honestly.
2. **Biggest risk reduction per dollar first.** Reinforce the weak links before overbuilding already-strong parts of the system.
3. **Do not assume perfect operators.** People rush, improvise, normalize near misses, bypass inconvenient devices, forget procedures, and overestimate their ability to stay clear.
4. **Make safeguards convenient.** Hinged guards, captive fasteners, easy reset, good visibility, good diagnostics, and sensible maintenance access matter.
5. **Fail safe where practical.** Loss of power, broken wires, communication failure, detected disagreement, or watchdog failure should tend toward removal of hazardous energy or inhibition of hazardous motion.
6. **Separate ordinary control from final safety authority.** LinuxCNC may request a stop and should know the safety state, but a normal LinuxCNC software path should not be the only mechanism preventing hazardous motion.
7. **Use proven patterns before inventing new ones.** Safety relays, force-guided contacts, redundant contactors, monitored valves, STO, guard interlocks, and two-channel devices are useful because their failure behavior is understood.
8. **Teach the reason behind every added component.** A student should be able to explain which fault a component addresses and what happens if it is omitted.
9. **Do not confuse “not certified” with “no value.”** A carefully engineered, openly documented low-cost safeguard can still reduce risk dramatically. It must be described honestly and not represented as a certified safety device.
10. **When a machine cannot meet a reasonable minimum for attended operation, keep people out of the hazard zone.** Experimental operation should be isolated/remote where practical, with the remaining risk stated plainly.

## Standards policy

For learning and engineering study, established machine-safety standards from roughly the last **20 years** are acceptable source material. The research project should prefer accessible editions, manufacturer application guides, public previews, and explanatory material over spending disproportionate effort chasing the newest revision.

When formal compliance, certification, commercial sale, or a current regulatory requirement becomes the actual task, perform a separate current-edition verification pass.

Primary standards families to study:

- ISO 12100 — machinery risk assessment and risk reduction
- ISO 13849-1/-2 — safety-related parts of control systems, PL, Categories, validation
- IEC 62061 — functional safety of machinery control systems, SIL concepts
- IEC 60204-1 — electrical equipment of machines
- ISO 13850 — emergency stop design principles
- ISO 14119 — guard interlocking and defeat resistance
- ISO 13855 — safeguard positioning and stopping-distance concepts
- ISO 13857 — reach and safety distances
- ISO 13851 — two-hand controls
- machine-specific Type-C standards where useful, especially press, robot, saw, lathe, mill, plasma/laser, and automated-cell standards
- ANSI B11 and OSHA material as useful US context, while keeping the engineering source hierarchy distinct from enforcement guidance

## 2500 course sequence

### 2510 — Safety as an engineering problem

Purpose: replace slogans with a practical mental model.

Topics:
- hazard versus risk
- severity, exposure, probability/possibility of avoidance
- inherently safer design versus safeguarding versus procedures/information
- residual risk
- why safety devices fail in real shops
- human overconfidence, normalization of deviance, maintenance shortcuts, and safeguard defeat
- “make the guard easier to reinstall than to throw away” as a design test
- productivity and safety as a joint optimization problem

Lab/output:
- inspect a simple machine scenario and produce a one-page hazard map
- rank the first five risk-reduction actions by cost versus expected risk reduction

### 2520 — From hazards to safety functions

Purpose: teach the repeatable machine-safety design workflow from hazard identification through release and change control. The canonical learner entry point is `safety-course/2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`; use that map instead of treating the dated supporting artifacts as an unordered reading pile.

Core workflow:

`machine/lifecycle boundary -> hazardous event -> risk-reduction hierarchy -> physical safe-state proposition -> safety-function/SRS derivation -> composition/allocation -> fault analysis/diagnostic design -> architecture/dependency/CCF allocation -> integrity-method selection/target allocation -> verification/validation/physical proof -> commissioning/release -> maintenance/change control/revalidation`

Topics:
- defining machine/lifecycle boundaries and hazardous events
- defining physical safe-state propositions rather than substituting software status
- deriving safety functions and SRS requirements in plain language
- safe state versus controlled stop versus energy removal
- composition/conflict analysis when several safety functions share resources or final elements
- credible single, latent and common-cause faults
- diagnostic claims and the physical propositions they do or do not prove
- architecture, dependency, common-cause and final-element allocation
- integrity-method selection and target allocation without inferring PL/SIL from topology
- reset, restart, reintegration and recovery authority
- response/stopping requirements while preserving machine-specific unknowns until measured/derived
- verification versus validation versus physical-process proof
- commissioning baseline, temporary measures, release and maintenance/change revalidation
- mode-dependent safety requirements and maintenance/setup/manual-mode considerations
- independent personnel-safety authority versus ordinary LinuxCNC/FPGA control and diagnostics

Lab/output:
- convert a hazard list into a small SRS and carry selected functions through fault analysis, architecture/integrity allocation, validation planning and commissioning/change-control reasoning
- complete a cross-machine transfer exercise while explicitly preserving unsupported physical/integrity values as `UNKNOWN`

Competency gate:
- learner-readable adversarial material is not sufficient for transfer graduation;
- use `evaluation/2520_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` with `evaluation/BLIND_FEEDBACK_PROTOCOL.md` for a genuinely information-separated fresh-machine challenge;
- do not commit the hidden solution into learner-readable curriculum state before the learner precommitment.

### 2530 — E-stop systems from first principles

Topics:
- what an emergency stop is and is not
- normally closed channels and why they are common
- dual-channel E-stop devices
- manual reset and anti-restart behavior
- reset location and visibility
- safety relay architecture
- redundant contactors
- external device monitoring (EDM)
- force-guided / mechanically linked contacts
- contact welding and why monitoring matters
- contact load, inrush, inductive loads, arc suppression, and where heavy-duty switching is actually needed
- LinuxCNC interaction: safety status into LinuxCNC; LinuxCNC stop request into the safety chain without granting LinuxCNC authority to self-clear the chain

Labs:
- draw a single-channel circuit, enumerate faults, then improve it incrementally
- low-voltage bench model of dual-channel input, reset, redundant outputs, and EDM
- inject broken-wire, welded-contact-simulation, stuck-input, and reset faults

### 2540 — Relays, contactors, and the real meaning of a “safety relay”

Topics:
- ordinary relay versus force-guided relay versus safety relay module
- redundant channels
- monitoring logic
- discrepancy detection
- feedback contacts
- diagnostic coverage
- common-cause failures
- relay/contact B10d concepts
- PFHd/PFD concepts at an intuitive level
- why a commercial module can claim PL/SIL and a homebuilt circuit generally cannot claim the same rating without the associated evidence

Research lab:
- compare at least five commercial safety relay families by claimed Category, PL, SIL, PFHd, response time, contact ratings, reset modes, cross-fault behavior, EDM behavior, mission life, and assumptions
- reverse-map each claimed feature to the type of failure it is intended to address

### 2550 — ISO 13849 without the mystique

Topics:
- Performance Level required (PLr)
- PL a–e
- Categories B, 1, 2, 3, 4
- MTTFd
- diagnostic coverage
- common-cause failure considerations
- subsystem decomposition
- B10d and switching-cycle estimates
- what calculations can and cannot prove

Lab/output:
- work several example architectures from inexpensive single-channel control through redundant monitored control
- identify the cheapest change that produces the largest increase in fault tolerance

### 2560 — IEC 62061 / SIL concepts for machine builders

Topics:
- SIL as a risk-reduction / probability framework
- PFHd and high-demand machinery operation
- subsystems, architecture, diagnostics, systematic capability concepts
- relationship and differences between machinery SIL and PL methods
- when the math is useful and when a qualitative fault analysis is already enough to make an obvious improvement

Lab/output:
- compare one example using both PL-style and SIL-style reasoning without pretending the results are formal certification

### 2570 — Drives, STO, braking, and hazardous motion

Topics:
- drive enable versus STO
- removing torque versus stopping motion
- coast stop versus controlled stop
- brake control and gravity axes
- spindle hazards
- contactor removal versus STO
- feedback proving of stopped state where justified
- stored mechanical energy

Labs:
- map a servo/VFD drive manual’s safety functions into a machine-level safety architecture
- design a low-cost ordinary-drive fallback architecture where certified STO is unavailable, clearly identifying its limitations

### 2580 — Hydraulic and pneumatic safety

Topics:
- stored pressure
- gravity loads
- blocked-center versus dump-to-tank concepts

<!-- Remaining research-plan sections intentionally retained in Git history; this edit promotes the mature 2520 path into the canonical sequence and does not claim completion of later modules. -->
