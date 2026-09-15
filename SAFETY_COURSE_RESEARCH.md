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

Topics:
- defining the hazardous event
- defining the safety function in plain language
- safe state versus controlled stop versus energy removal
- reset behavior and restart prevention
- response time and stopping time
- mode-dependent safety requirements
- maintenance/setup/manual mode considerations
- defining assumptions and boundaries

Lab/output:
- convert a hazard list into a small Safety Requirements Specification (SRS)

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
- monitored valves
- redundant valves where justified
- trapped pressure and accumulators
- valve spool sticking
- hose and cylinder failures
- mechanical restraint and blocking during maintenance
- press-brake-specific energy and synchronization concerns

Labs:
- fault-tree a hydraulic press axis
- identify which hazards can be solved electrically and which require hydraulic/mechanical measures

### 2590 — Guards, interlocks, presence sensing, and two-hand controls

Topics:
- fixed and movable guards
- interlock switches
- guard locking
- coded/non-contact sensors
- foreseeable defeat and bypass
- light curtains and scanners
- minimum distance / stopping-time concepts
- two-hand controls and anti-tie-down concepts
- enabling devices and hold-to-run controls
- visibility and ergonomics
- guard usability as a safety requirement

Labs:
- redesign an intentionally annoying guard so it is faster to use correctly than to bypass
- calculate a sample safeguard position from measured stopping time using the applicable methodology

### 25A0 — Safety PLCs and programmable safety

Topics:
- what makes a safety PLC different from an ordinary PLC
- redundant/diverse processing concepts
- self-tests and watchdogs
- safe I/O architectures
- test pulses and short-circuit detection
- discrepancy timing
- black-channel communication concepts
- why software configuration is only one part of the safety case
- open-source and inspectable functional-safety projects

Research lab:
- study at least one open safety hardware/software project with published hazard analysis, tests, and known limitations

### 25B0 — Failure analysis and fault injection

Topics:
- FMEA/FMEDA concepts
- fault trees
- single-fault thinking
- latent faults
- common-cause faults
- diagnostic coverage in practical terms
- power-supply failure
- broken wires and shorts
- welded contacts
- stuck valves
- sensor disagreement
- frozen software
- network loss
- corrupted configuration

Labs:
- bench/simulated fault injection matrix
- verify that expected safe-state transitions actually occur
- record surprises and redesign accordingly

### 25C0 — Designing for humans who will defeat safeguards

Topics:
- bypass incentives
- nuisance trips
- poor diagnostics
- maintenance access
- guard removal/reinstallation effort
- reset placement
- visibility
- setup and recovery modes
- why “procedure only” controls are fragile
- designing safer defaults without making the machine unusable

Lab/output:
- human-factors review checklist for every machine-specific playbook

### 25D0 — Low-cost safety architectures

Purpose: directly pursue the curriculum mission of large risk reduction at low cost.

Develop reference architectures at several cost/complexity levels. Each architecture must state:
- hazards addressed
- hazards not addressed
- assumed loads and environment
- single faults detected
- single faults not detected
- reset behavior
- power-loss behavior
- restart behavior
- expected failure modes
- approximate parts cost
- what additional money buys at the next level

Candidate examples:
- simple NC E-stop dropping a contactor coil
- dual-channel E-stop with two independent switching paths and monitored restart
- force-guided relay architecture with EDM
- drive STO plus contactor architecture
- hydraulic dump/enable architecture
- guard interlock architecture

These are educational/reference risk-reduction designs, not automatically safety-rated products.

### 25E0 — Validation, commissioning, and proof testing

Topics:
- validation versus “it seems to work”
- test plans derived from safety requirements
- restart tests
- fault injection
- stopping-time measurement
- periodic proof tests
- inspection intervals
- configuration/version control
- changes that invalidate previous assumptions

Capstone output:
- complete safety requirements, architecture, schematic, failure analysis, test plan, results, limitations, and maintenance/proof-test instructions for a generic machine

### 25F0 — Machine safety capstones

Apply the same method to several machine classes:
- mill/VMC
- lathe
- plasma/laser table
- router
- robot/custom kinematics
- press brake
- saw/feed/indexing cell

The press-brake case should be especially deep and should eventually compare the OpenPressBrake architecture with proven commercial safety patterns while keeping proprietary machine information out of the public curriculum.

## Dedicated safety research project

The research project runs in parallel with the course build. Its job is to gather evidence before the curriculum invents anything.

### Research stream R-SAFE-01 — LinuxCNC safety practice

Mine LinuxCNC manuals, forum threads, configs, and community examples for external E-stop circuits, hardware safety relays, redundant contactors, STO integration, watchdog behavior, LinuxCNC `estop_latch`, software-requested stop versus hardware authority, reset/restart behavior, and real failure reports.

Deliverable: `linuxcnc-safety-patterns.md`

### R-SAFE-02 — Commercial safety relay teardown by datasheet

Study representative families from Pilz, Siemens, Phoenix Contact, Omron, Schneider, ABB/Jokab, and others where useful. Extract supply/input/reset/cross-short/EDM/output behavior, force-guided assumptions, load limits, response time, Category/PL/SIL claims, reliability data and environmental/test assumptions.

Deliverable: `safety-relay-comparison.md`

### R-SAFE-03 — What actually creates each rating

Trace commercial claims back to ISO 13849 and IEC 62061 concepts: Category architecture, fault detection timing, MTTFd, DCavg, CCF, internal architecture, component reliability, manufacturing controls and validation. Separate reproducible engineering benefits from formal certification claims.

Deliverable: `rating-mechanics.md`

### R-SAFE-04 — Open-source functional safety projects

Search beyond LinuxCNC. Evaluate inspectable projects on schematics/source, hazard analysis, failure assumptions, independence/redundancy, diagnostics, tests, cost and reuse value.

Deliverable: `open-safety-projects.md`

### R-SAFE-05 — Force-guided relay and contactor physics

Research contact welding, AC/DC interruption, inductive kick, inrush, contact material/rating categories, suppression, B10d data, feedback contacts and the boundary between logic relays and hazardous-energy contactors.

Deliverable: `relay-contactor-physics.md`

### R-SAFE-06 — Low-cost open reference safety blocks

After the preceding research, design educational reference blocks: dual-channel E-stop input, manual reset/restart inhibit, dual force-guided relay output, contactor EDM, STO interface, guard interlock, two-hand-control study and watchdog/heartbeat interface. Each must include interface contract, schematic, BOM/substitutions, fault table, assumptions, tests, limitations and formal-rating gap.

Deliverable: `reference-safety-blocks/`

### R-SAFE-07 — Human-factors and safeguard usability

Collect real defeat incentives: inconvenient guards/resets, poor maintenance access, nuisance trips, visibility loss and excessive disassembly. Turn findings into concrete design rules.

Deliverable: `human-factors-safeguards.md`

### R-SAFE-08 — Machine-specific safety patterns

Build concise safety-pattern summaries for each machine class, focused on hazards, energy sources, failure modes, guarding patterns and practical architectures.

Deliverable: one section consumed by each machine-specific playbook.

### R-SAFE-09 — Safety Sandbox simulator reuse

Investigate open-source circuit/PLC simulation engines before writing a new simulator. Initial candidates are DigitalJS/DigitalJS Online and PLC_Simulator. The target is not general SPICE: it is a browser-friendly educational engine in which a learner can wire relay/contactor/safety blocks, operate a machine model, inject faults, and see both hazard authority and diagnostic/rearm consequences.

Required capabilities:
- one physical relay/contactor object may own multiple main/auxiliary contacts;
- coil command, mechanical state and actual per-contact continuity remain separate;
- welded/stuck/open/short/broken-wire/reset/power-loss faults can persist independently of command state;
- feedback/EDM proves only what the modeled device/contact architecture actually witnesses;
- machine hazard/energy models remain separate from electrical command state;
- user circuits/scenarios serialize to an inspectable data format;
- automated fault campaigns explain detected, latent and hazardous outcomes without claiming PL/SIL certification.

Research artifact: `research/safety-sandbox-reuse-research-2026-09-15.md`.

First bounded experiment, `SIM-REUSE-01`, is a dual relay/contactor + EDM circuit with a welded-main-contact fault. Do not implement it until source inspection shows whether the candidate engine naturally supports independent physical/fault state. Use standard reasoning before compute.

## Source hierarchy

Prefer, in order:
1. ISO/IEC official descriptions, previews, and legally accessible standards text
2. manufacturer safety manuals, application guides, datasheets, and reliability data
3. LinuxCNC official documentation and source
4. detailed LinuxCNC forum build threads with schematics/configs and follow-up failure experience
5. credible open-source safety projects with published design evidence
6. academic/industry papers and textbooks
7. general web commentary only as discovery leads

Do not treat marketing labels such as “SIL 3 capable” or “safety relay” as sufficient evidence without reading the conditions and assumptions.

## Research rules

- Search broadly before designing from scratch.
- Preserve older but still useful material instead of discarding it solely because a newer revision exists.
- Record exact product/standard revision when a numerical value is used.
- Distinguish **certified/rated**, **designed according to principles**, and **educational risk-reduction reference**.
- Avoid simulation for simulation’s sake. Use ordinary engineering calculations and datasheet reasoning first; simulate or bench-test where uncertainty or failure interaction justifies it.
- Prefer fault injection and practical bench evidence over decorative models.
- Reuse labs across multiple lessons to conserve compute time.
- Keep public examples generic and avoid publishing private machine drawings or proprietary data.

## First research targets already identified

- LinuxCNC `watchdog` component and HostMot2 watchdog behavior
- LinuxCNC `estop_latch`
- LinuxCNC forum examples using external hardware E-stop chains, safety relays, redundant contactors, and safety feedback into LinuxCNC
- ISO 12100 risk-reduction framework
- ISO 13849-1:2006 as a useful within-20-years baseline for PL/Category concepts, cross-checked against later explanatory sources where useful
- ISO 13850:2015 emergency-stop principles
- IEC 60204-1:2016 electrical machine safety
- IEC 62061:2005 and later editions for machinery SIL concepts
- ISO 14119:2013 guard-interlock principles and defeat resistance
- ISO 13855:2010 safeguard-positioning methodology
- Open Source Safety Consortium Protective Stop as an example of publishing hardware/software together with safety evidence and known gaps
- OpenVVVF as an example of open hardware with independent safety paths, HARA, and explicit fault-injection planning
- DigitalJS/DigitalJS Online and PLC_Simulator as inspectable simulator reuse candidates for R-SAFE-09

## Definition of done for the first draft

The safety course is not considered drafted merely because the lesson titles exist. First-draft completion requires:

- evidence-backed lesson notes for all 2500 modules
- commercial safety-relay comparison matrix
- standards concept map
- LinuxCNC safety-pattern survey
- at least two credible open-source safety projects deeply reviewed
- a relay/contactor physics note grounded in manufacturer data
- at least three low-cost reference architectures with fault tables and bench/simulation test plans
- one human-factors safeguard-design guide
- one complete generic-machine capstone safety package
- press-brake safety case study outline ready for integration into the machine-specific curriculum
- adversarial review identifying where the course accidentally overclaims safety or where a cheaper practical safeguard was overlooked
- Safety Sandbox reuse decision recorded before any large simulator implementation effort
