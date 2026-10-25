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


## 2026-10-24 4400 hydraulic follow-on (source-reading, not graduation)

The 2500 safety sequence remains the foundational course and its 2520–25F0 external/fresh gates remain OPEN. The active 4000 hardware/safety follow-on now includes [4400-HY-01](safety-course/4400_HY_01_HYDRAULIC_PRESS_BRAKE_SAFETY_ARCHITECTURE_TRANSFER_MODULE_2026-10-24.md), comparing Bosch IH04/IH04E, HAWE ePRAX and HAWE SAKB/NSV product-specific valve/port/energy/monitoring evidence. This is a **source-reading module only**, not an independent safety certification, machine-specific circuit, fresh competency score or permission for exposed operation. Actual Y1/Y2 hardware intake and independent physical `PHY/VAL/PT` remain UNKNOWN/NOT RUN. Ordinary LinuxCNC/FPGA control remains separate from personnel-safety authority.

## 2026-10-24 4400 cable-pull source continuation (not graduation)

New manufacturer-grounded optional 4400 lesson: [Lifeline 5/Lifeline 4/ZQ 900 cable-pull source audit](research/4400_CABLE_PULL_ESTOP_TENSION_MARGIN_GUARDLINK_STANDARD_TAG_SOURCE_AUDIT_2026-10-24.md), [12-case technician card](safety-course/4400_CABLE_PULL_TENSION_WARNING_RESET_SIGHTLINE_TECHNICIAN_CARD_2026-10-24.md), and [blank mechanical route/safety/physical witness worksheet](safety-course/4400_CABLE_PULL_ESTOP_INSTALLATION_CHANGE_AND_RESTART_WITNESS_WORKSHEET_2026-10-24.md). The February 2026 Lifeline 5 OEM documents **tension-warning with OSSDs still ON** and non-safety-rated 432ES device tags, reinforcing the separation of physical cable reach, qualified safety decision, final-element stop/hold, reset and fresh start. This is generic cross-machine safety teaching, **not** proof of an installed OpenPressBrake rope switch, PL/SIL, physical test, fresh competency score or permission for exposed operation. Selected `IN-04n` conditional/UNKNOWN.

## 2026-10-24 4400 tactile edge source continuation (not graduation)

Published [Schmersal/Mayser/ASO and ISO 13856-2 public-scope audit](research/4400_TACTILE_SAFETY_EDGE_SENSOR_PRINCIPLE_AUTORESET_AND_OVERRUN_SOURCE_AUDIT_2026-10-24.md) plus [ten-case technician exercise](safety-course/4400_TACTILE_EDGE_CONTACT_OVERRUN_AND_AUTORESET_TECHNICIAN_CARD_2026-10-24.md). Optical versus monitored resistor/NC-chain sensor families are not plug-compatible; some safety-edge monitors permit auto-reset; **contact has already occurred** before a tactile safeguard can demand stopping, so actual compression/overtravel/force must be qualified. Product `up to PL d` and monitor response do not establish selected machine safe state. **No physical proof, fresh external evaluation or installed OpenPressBrake edge asserted**; conditional `IN-04o` UNKNOWN.


## 2026-10-24 4400 MAT-01 floor occupancy safety continuation (not graduation)

Added [OEM Rockwell/Schmersal/ISO public-scope audit](research/4400_PRESSURE_MAT_OCCUPANCY_DEAD_ZONE_RESET_AND_OEM_SCOPE_AUDIT_2026-10-24.md), [integrated source-reading module](safety-course/4400_MAT_01_FLOOR_OCCUPANCY_SAFETY_FUNCTION_MODULE_2026-10-24.md), [14-case technician card](safety-course/4400_PRESSURE_MAT_OCCUPANCY_SEAM_RESET_TECHNICIAN_CARD_2026-10-24.md) and [blank physical witness](safety-course/4400_PRESSURE_MAT_FLOOR_COVERAGE_AND_RESET_BLANK_WITNESS_2026-10-24.md). Exact OEM scope matters: 35 kg Rockwell adult detection is not an ISO-general 20 kg promise, joints/raised bypass paths undermine whole-area occupancy, auto-reset requires separate machine rearm, and mat t1 is not complete stopping/holding. Selected `IN-04p` conditional/UNKNOWN; no OpenPressBrake mat asserted; `VAL/PT` NOT RUN, independent evaluation OPEN, exposed operation NOT AUTHORIZED.


## 2026-10-24 4400 S3000 optical and maintenance safety continuation (not graduation)

[Original SICK 8009942/ZE09/2026-09-09 optical/service source audit](research/4400_SICK_S3000_OPTICAL_SHADOW_FRONT_SCREEN_REPLACEMENT_CALIBRATION_AUDIT_2026-10-24.md) and [12-case technician card](safety-course/4400_S3000_OPTICAL_SHADOW_SCREEN_SERVICE_TECHNICIAN_CARD_2026-10-24.md) show that correct EFI/OSSD signal logic cannot repair physical scan shadows, reflective stock, improvised transparent shields or incorrect optical front-screen calibration. Same-plug scanner exchange, front-screen replacement, system-plug exchange and I/O variant replacement have **different** OEM service requirements. Conditional `IN-04q UNKNOWN`, selected scanner not asserted, no physical validation, external evaluation open, G3/G4 NOT AUTHORIZED.

## 2026-10-24 4400 shared-bus and brake-resistor source continuation (not graduation)
[ABB/Rockwell OEM shared DC-bus, alternate DC feeder, PM generation and isolation audit](research/4400_COMMON_DC_BUS_REGENERATION_REENERGIZATION_AND_ISOLATION_OEM_AUDIT_2026-10-24.md) with [DCB-01 module](safety-course/4400_DCB_01_COMMON_BUS_ENERGY_AND_MOTION_AUTHORITY_MODULE_2026-10-24.md), [14-case paper card](safety-course/4400_COMMON_DC_BUS_BACKFEED_AND_ISOLATION_TECHNICIAN_CARD_2026-10-24.md) and [blank selected physical witness](safety-course/4400_COMMON_DC_BUS_ENERGY_BOUNDARY_BLANK_FIELD_WITNESS_2026-10-24.md) deepen the existing STO/DC-bus study. [Rockwell 2026 original brake-resistor installation instructions and ABB/Rockwell indexed OEM thermal fault audit](research/4400_DYNAMIC_BRAKE_RESISTOR_STUCK_CHOPPER_FIRE_AND_STOP_BOUNDARY_OEM_AUDIT_2026-10-24.md) plus [12-case paper card](safety-course/4400_BRAKE_RESISTOR_FIRE_FAULT_AND_SAFE_STOP_TECHNICIAN_CARD_2026-10-24.md) distinguish regenerative energy dissipation, fire/thermal protection, controlled stop, gravity hold and service isolation. [Novel independent handoff](evaluation/4400_DCB_01_FRESH_TOPOLOGY_TRANSFER_HANDOFF_2026-10-24.md) prepared, not run/scored. `IN-04r/s` conditional/UNKNOWN, no installed OpenPressBrake shared bus or brake resistor asserted, physical `VAL/PT NOT RUN`, G3/G4 NOT AUTHORIZED.

## 2026-10-24 4400-ESPE-02 optical blanking / effective resolution / OSHA press-brake scope continuation (not graduation)

Published [original SICK C4000 Advanced 8009861/YT64/2016-02-25 source audit](research/4400_SICK_C4000_BLANKING_OBJECT_MONITORING_EFFECTIVE_RESOLUTION_AUDIT_2026-10-24.md), [OSHA 1910.217(a)(5) exclusion and 1910.212/2004 late-detecting laser source audit](research/4400_OSHA_PRESS_BRAKE_VS_MECHANICAL_PRESS_LIGHT_CURTAIN_SCOPE_AND_LATE_DETECTION_AUDIT_2026-10-24.md), [non-graduated ESPE-02 module](safety-course/4400_ESPE_02_BLANKING_RESOLUTION_AND_PRESS_BRAKE_LATE_DETECTION_MODULE_2026-10-24.md), [16-case paper card](safety-course/4400_BLANKING_RESOLUTION_LATE_DETECTION_TECHNICIAN_CARD_2026-10-24.md), [blank optical field physical witness](safety-course/4400_OPTICAL_BLANKING_FIELD_AND_RESTART_BLANK_WITNESS_2026-10-24.md) and [prepared but unscored independent transfer handoff](evaluation/4400_ESPE_02_FRESH_BLANKING_TRANSFER_HANDOFF_2026-10-24.md). **DOC-CONFIRMED** exact OEM fixed versus floating complete/partial monitoring, reduced/effective resolution, test-rod requirement; OSHA regulation press-brake exclusion. OSHA 2004 letter indexed official text, direct page 403. **INFERENCE** reach holes/late detection and human-factor bypass pathways. **UNKNOWN** selected device, configuration, actual physical stop/hold and fresh-start. `IN-04u UNKNOWN`, `VAL/PT NOT RUN`, no local/hosted lab compute, no personnel-exposed operation. If source branch reaches documentary stop, selected-machine as-built intake and independent external evaluation remain primary; a different-OEM exact-manual comparison is an optional next research branch, not a justification to run synthetic labs.

**Same-session cross-OEM transfer (2026-10-24):** [Rockwell 450L-E 2024/2022 manufacturer-indexed comparison](research/4400_ROCKWELL_450L_BLANKING_OBJECT_MONITORING_CROSS_OEM_TRANSFER_GATE_2026-10-24.md) corroborates monitored fixed object removal versus configurable floating no-object-monitoring behavior but does **not** prove universal numerical tolerances or physical machine safety. Original large PDF opening failed size limits; only manufacturer-indexed excerpts were inspected. Independent evaluation handoff excludes the now learner-readable SICK/Rockwell examples. Design §11BY, IN-04u conditional, external and physical gates unchanged.


### 2026-10-24 — 4400 SET-01 original OEM/OSHA setup-mode deepening
Published [SET-01](safety-course/4400_SET_01_SETUP_MODE_ENABLING_SLS_AND_LOTO_BOUNDARY_MODULE_2026-10-24.md) and original [OEM state-transition](research/4400_SETUP_ENABLING_SWITCH_SLS_MODE_TRANSITION_OEM_AUDIT_2026-10-24.md), [OSHA minor-servicing applicability](research/4400_OSHA_SETUP_MINOR_SERVICING_LOTO_ALTERNATIVE_PROTECTION_SCOPE_2026-10-24.md), and [LinuxCNC feed-inhibit/jog documentation drift](research/4400_LINUXCNC_FEED_INHIBIT_JOG_DOCUMENTATION_VERSION_DRIFT_2026-10-24.md) audits. This is **product/task-specific source reading, not selected-machine validation**. Rockwell 2013 manual and Siemens 2021 original PDFs inspected; OSHA original pages 403, official indexed text only. No new compute, machine testing or external score; maintain G3/G4 NOT AUTHORIZED. Next: actual restricted Y1/Y2 mode/stop/hold/guard/restart evidence, qualified activity-by-activity LOTO review, external evaluator, or genuinely new 4400 safety source.

## 2026-10-24 4400-MUT-01 conveyor muting and recovery authority (not graduation)
Original [SICK deTec4 HG 2026 OEM manual trace](research/4400_SICK_DETEC4_HG_MUTING_BELT_STOP_OVERRIDE_TIMER_SOURCE_AUDIT_2026-10-24.md) confirms SP2 24-hour default total/concurrence timers, belt-stop pause with continued sensor/field change detection, override OSSD ON under defined conditions, and power-reset override count. Official [Rockwell GuardLogix FSBM documentation trace](research/4400_ROCKWELL_FSBM_ZERO_TIMER_OVERRIDE_AND_RESTART_SOURCE_AUDIT_2026-10-24.md) separately documents zero-disabled timers and override output behavior despite input-status/fault state; do not transplant vendor semantics. [IEC 62046:2026 official edition scope](research/4400_IEC_62046_2026_MUTING_WHOLE_BODY_STANDARD_EDITION_SCOPE_AUDIT_2026-10-24.md) updates muting and whole-body topics; paid clauses NOT inspected. [MUT-01 module](safety-course/4400_MUT_01_MUTING_SEQUENCE_OVERRIDE_BELT_STOP_AND_RESTART_MODULE_2026-10-24.md), 18 PAPER scenarios, blank selected-machine witness and fresh independent handoff PREPARED/NOT SCORED. Conditional IN-04w UNKNOWN, no selected OpenPressBrake muting device asserted. No simulation, hosted/local compute, physical test, external score or personnel-exposed operation. Prior 1000/2000/F02/3000 closure unaffected.

**Same-session second source path (2026-10-24):** [Original SICK deTec4 HG SBD/OPR audit](research/4400_SICK_SMART_BOX_OBJECT_PATTERN_RECOGNITION_OVERRIDE_AND_COVERAGE_AUDIT_2026-10-24.md) and [12-case paper card](safety-course/4400_SMART_BOX_VS_MUTING_AND_PATTERN_RECOGNITION_TECHNICIAN_CARD_2026-10-24.md) identify an alternate material-passage architecture that avoids general muting for exact qualified shapes, but still requires independent access geometry, person+object rejection and physical stopping. **SBD Override explicitly disables field monitoring**, so it is not inherently safer during recovery. Product-specific prerequisites and IEC/ISO version adoption UNKNOWN; conditional IN-04x and physical/external gates OPEN.

**Same-session 4400 cross-OEM physical architecture transfer:** [Leuze OEM-published SPG and multi-lane scanner case audit](research/4400_LEUZE_SPG_MULTILANE_DYNAMIC_FIELD_REAL_INSTALLATION_TRANSFER_AUDIT_2026-10-24.md) documents real manufacturer-reported WITRON/Südzucker implementations, PLC+ESPE gating distinction, and a five-lane geometry where global muting would permit adjacent-lane entry. The OEM reports two RSL 400 scanners plus separate safety controls. **Not independently tested**; exact field transition, stopping/holding, and applicability to OpenPressBrake UNKNOWN. §11CH; no simulation or personnel-exposed operation.

## 2026-10-24 4400-CFG-01 — Configuration identity, diagnostic image and physical safety authority
[Original SICK/Rockwell manufacturer investigation](research/4400_SAFETY_CONFIGURATION_SIGNATURE_SCOPE_AND_PHYSICAL_OUTPUT_TRUTH_AUDIT_2026-10-24.md) establishes that a verified safety-controller checksum or safety signature is necessary **configuration evidence**, not evidence that a contactor opens, a hydraulic ram is held or a guard covers the hazard. Directly inspected SICK 2023 gateway manual says logic output image does not guarantee terminal level under faults; absent-module and reserved status bits can be high. Rockwell official 5580 documentation requires signature comparison after every download. Older SICK Designer checksum scope includes an EFI/firmware caveat from indexed manufacturer text; original full manual was too large for direct inspection, so preserve provenance. [CFG-01 module](safety-course/4400_CFG_01_SAFETY_CONFIGURATION_IDENTITY_VS_PHYSICAL_PROOF_MODULE_2026-10-24.md), 18 paper cases, blank witness, fresh evaluator PREPARED/NOT RUN; IN-04y UNKNOWN, G3/G4 NOT AUTHORIZED. No machine facts, numeric safety targets or physical results invented. **Learning-method gain:** every green status needs an explicit measured-variable and scope label before it can be used as evidence.

## 2026-10-24 4400-GUARD-01 — Non-safety fieldbus guard-release requests and escape/rearm
[Directly inspected original Pilz PSENmlock mini 1005801-EN-05](research/4400_PILZ_PSENMLOCK_AUXILIARY_RELEASE_SDD_NONSAFETY_GUARD_AUTHORITY_AUDIT_2026-10-24.md) identifies a high-consequence retrofit mistake: SDD unlock commands are **non-safety** and require independent safety inputs S31/S41. Auxiliary release is access-side and **not a safety function**; manufacturer requires standstill and qualified recommissioning. Automatically locked guard and high OSSDs do not prove empty hazard zone or safe restart. Rockwell 442G manufacturer product information distinguishes power-to-release/power-to-lock and optional inside escape; full large user manual not directly inspected. [GUARD-01 module](safety-course/4400_GUARD_01_ACCESS_RELEASE_ESCAPE_AND_REARM_BOUNDARY_MODULE_2026-10-24.md), 14 paper cases, §11CJ, IN-04z UNKNOWN. No installed device, physical test or evaluator claimed. Make the correctly installed/reinstalled guard easier than bypass.


## 2026-10-24 — 4400-RST-01 power-return reset, EDM and independent fresh start (not graduation)
Original directly inspected [Pilz PNOZ X3P and Rockwell Guardmaster CI/DI OEM source audit](research/4400_RESET_POWER_RETURN_EDM_WELDED_CONTACTOR_OEM_SOURCE_AUDIT_2026-10-24.md) distinguishes automatic vs monitored start, power-up rearm, reset edge, feedback eligibility and contact/wiring diagnostics. Separate [SICK Flexi Soft EDM manufacturer-indexed warning](research/4400_SICK_EDM_ERROR_RESET_UNEXPECTED_SWITCH_ON_MANUFACTURER_INDEXED_AUDIT_2026-10-24.md) documents a product-specific Error reset condition capable of re-enabling outputs; full original CDN PDF not directly opened, preserve limitation. [Pinned LinuxCNC `062dc7c` source trace](research/4400_LINUXCNC_INTERNAL_ESTOP_RESET_HALUI_NML_IOCONTROL_SOURCE_TRACE_2026-10-24.md) confirms internal HALUI reset is NML/Task normal control and drives `iocontrol.0.user-enable-out`, not a qualified personnel-safety function. [RST-01 module](safety-course/4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md), 18 learner-visible PAPER scenarios, blank physical witness and independent fresh-AI evaluation handoff PREPARED/NOT SCORED. Selected IN-04ab UNKNOWN, G3/G4 NOT AUTHORIZED, no physical test or hosted/local compute. Do not transplant OEM timing, infer PL/SIL, or claim that internal LinuxCNC reset proves physical stop/hold.

### 2026-10-24 — Accumulator vessel service and bleed-variant source follow-on
Published [direct Parker PVSI-01 original service audit](research/4400_PARKER_PVSI_GAS_FLUID_RESIDUAL_ENERGY_DISASSEMBLY_OEM_AUDIT_2026-10-24.md) and [HYDAC SAF direct 2003 / indexed 2024 Y/Z audit](research/4400_HYDAC_SAF_Y_Z_BLEED_VARIANT_AND_PHYSICAL_WITNESS_AUDIT_2026-10-24.md) with [ACC-02 module](safety-course/4400_ACC_02_GAS_FLUID_DISCHARGE_VARIANT_AND_SERVICE_AUTHORITY_MODULE_2026-10-24.md). Distinct engineering gain beyond prior accumulator dual-role notes: qualified gas-vessel servicing remains separate from fluid-side drain, and a valve part/edition substitution (Y/Z, E/M, E-to-M blanking plug, older 2SV5 vs newer WSM) can invalidate automatic discharge expectations. No selected machine, no numeric pressure or performance claims; no physical test or external evaluator score. Next highest information gain remains actual restricted Y1/Y2 stop/hold and selected hydraulic parts, otherwise an uncovered 4400 safety branch.

**Distinct same-session vacuum safety branch:** [Original Schmalz FMP/VOL/VAGG manual audit](research/4400_SCHMALZ_VACUUM_LOAD_DROP_RESERVOIR_AND_CLAMP_ENABLE_OEM_AUDIT_2026-10-24.md) and [VAC-01 module](safety-course/4400_VAC_01_VACUUM_GRIP_HOLD_STOP_AND_MACHINE_ENABLE_BOUNDARY_MODULE_2026-10-24.md). An E-stop air dump can cause suspended-load release; a reservoir/check valve is not indefinite hold proof; low-vacuum machine-enable output must not be credited as independent personnel safety without actual product/integration evidence. Cross-machine robot/gantry versus router/mill workpiece slip/ejection. §11CR and conditional IN-04af UNKNOWN, no selected-machine test.


## 2026-10-24 — Wireless pendant certified STOP is configuration- and end-to-end integration-dependent
[Direct original Tele Radio R15/T19 54+36-page manual audit](research/4400_TELE_RADIO_R15_T19_WIRELESS_STOP_CONFIGURATION_AND_RESTART_OEM_AUDIT_2026-10-24.md) finds a new cross-machine safety trap: radio STOP PLd Cat3 is not inherited by normal CNC commands or the whole machine, and the exact R15 v09 manual **explicitly cancels PLd STOP in discontinuous mode 5**. Receiver power-return Require start, unique transmitter identity, login/logout, link-loss all-relays-off and <=500 ms radio timeout are exact OEM configuration requirements, not universal physical stopping criteria. [Scanreco manufacturer cross-OEM comparison](research/4400_SCANRECO_G5_CAN_STOP_OUTPUT_VS_ORDINARY_CAN_CROSSCHECK_2026-10-24.md) distinguishes safety-classified receiver stop outputs from ordinary CAN/MOSFET/PWM, with original full installation manual not inspected. [RAD-01 module](safety-course/4400_RAD_01_WIRELESS_PENDANT_STOP_LINK_LOSS_AND_RESTART_MODULE_2026-10-24.md), 16 PAPER cases, conditional blank witness and external evaluation prepared. §11CS, IN-04ag UNKNOWN, no machine radio installation asserted, no tests or compute. Selected Y1/Y2 physical safety evidence and independent external competency remain the higher-priority blocked gates.


**RAD-02 continuation:** [Official IEC 62745:2017 scope and FME March-2023-status mobile/tablet guideline audit](research/4400_IEC62745_FME_MOBILE_DEVICE_CABLELESS_SAFETY_AUTHORITY_SCOPE_2026-10-24.md) adds a distinct phone/browser HMI authority failure path: an onscreen stop and Wi-Fi heartbeat are normal software functions, not a certified STOP interface. FME recommends fixed local controls and no auto-motion after reconnect, but is an **industry guideline**; its 0.5 s statement is not a universal machine safety stopping-time rule. [10 PAPER scenarios](safety-course/4400_MOBILE_HMI_VS_CERTIFIED_RADIO_STOP_TECHNICIAN_CARD_2026-10-24.md); §11CT, conditional selected IN-04ag UNKNOWN. No licensed IEC normative clause proof, no machine test, no external score.


**RAD-03 source-edition continuation:** [Direct original R15 v09/v11 comparison](research/4400_TELE_RADIO_R15_V09_V11_VERSION_SCOPE_AND_POWER_CYCLE_AUDIT_2026-10-24.md) found v11 lists an additional T29-12 transmitter in safety-function applicability and explicitly instructs receiver power-cycle on PLd->non-PLd configuration changes. Both require receiver SW0014-14v24+ and cancel PLd STOP in discontinuous mode 5. These are edition-specific OEM facts, not certified pair interchangeability or machine safety. [8 PAPER cases](safety-course/4400_RADIO_MANUAL_VERSION_AND_PAIRING_CHANGE_TECHNICIAN_CARD_2026-10-24.md), cumulative §11CU, conditional IN-04ag UNKNOWN. No tests or compute.

### 2026-10-24 — 4400-BG-01/02 backgauge step and asymmetric stop/return
[Direct original TRUMPF B35 2023 + AMADA OEM audit](research/4400_PRESS_BRAKE_BACKGAUGE_STEP_CHANGE_REAR_ACCESS_AND_INDEPENDENT_STOP_OEM_AUDIT_2026-10-24.md) and [BG-01 module](safety-course/4400_BG_01_BACKGAUGE_STEP_CHANGE_REAR_ACCESS_AND_STOP_AUTHORITY_MODULE_2026-10-24.md) cover backgauge X/R/Z/L high-speed unexpected movement, delayed next-index triggers, rear helper access, added fingers and independent gauge/ram stopping. [OSHA 2003 cabinet-press real cancel-to-return source audit](research/4400_OSHA_CABINET_PRESS_STOP_CANCEL_AUTORETURN_ASYMMETRIC_GUARDING_TRANSFER_AUDIT_2026-10-24.md) is a **different machine** and an advisory indexed agency case, not a selected press-brake claim. Twelve PAPER cases and a blank witness; §11CY–CZ, IN-04ai UNKNOWN, no test/evaluator/compute. The decisive next evidence is selected machine physical stop/hold and external information-separated evaluation.


### 2026-10-25 — 4400-CELL-01 manufacturer-specific robot cell safeguard/restart integration
Directly inspected UR10e/g-Series PolyScope X **SW10_15** safety I/O and UR 2020 CB/e-Series article: [OEM source audit](research/4400_UR_SW10_15_SAFEGUARD_AUTO_RESET_MODE_AND_SYSTEM_STOP_HANDOFF_OEM_AUDIT_2026-10-25.md). **DOC-CONFIRMED:** ordinary safeguard stop all modes vs automatic-mode-only safeguard stop, automatic reset hazard after whole-body pass-through, I/O/fieldbus start from current position, and upstream E-stop release restoring a System Stop output without downstream new-start authority. Cross-checked [ABB manufacturer reset interpretation and ISO 10218-2:2025 official publisher scope](research/4400_ABB_RESET_VISIBILITY_ISO10218_2025_CELL_INTEGRATION_SCOPE_AUDIT_2026-10-25.md); historical OSHA 1987 directive indexed but direct 403. Existing trapped-person design card remains foundational; new module supplies exact OEM mode and interface fault paths. [CELL-01 integrated module](safety-course/4400_CELL_01_WHOLE_BODY_ENTRY_MODE_RESET_AND_CROSS_MACHINE_START_MODULE_2026-10-25.md), [16 paper scenarios/blank witness](safety-course/4400_CELL_WALKTHROUGH_RESET_MODE_AND_RESTART_TECHNICIAN_CARD_2026-10-25.md), [fresh external evaluation](evaluation/4400_CELL_01_FRESH_OCCUPANCY_RESET_TRANSFER_HANDOFF_2026-10-25.md) NOT RUN. Design §§11DB–11DC, conditional selected IN-04aj UNKNOWN. No selected robot installation, Y1/Y2 physical proof, external score, test or compute.


**Same-session 4400-ATC-01 rotation (2026-10-25):** After completing UR/ABB cell occupancy interface source trace, selected a genuinely distinct **mill/robot toolchanger retention and pneumatic release** failure family (index had no toolchanger/drawbar coverage). Direct original Haas 2025 40T drawbar TG0132 and SMTC double-arm TG0128 manufacturer HTML established Belleville spring wear, low clamp force, TRP precharge-solenoid delay and unexpected release, false arm-home sensor/cable, pocket/arm retainer failure. Published [Haas OEM audit](research/4400_HAAS_TOOL_RELEASE_DRAWBAR_PRECHARGE_SENSOR_AND_TOOL_DROP_OEM_AUDIT_2026-10-25.md), [ATC-01 non-graduated module](safety-course/4400_ATC_01_TOOL_RETENTION_DRAWBAR_PNEUMATIC_RELEASE_AND_SERVICE_MODULE_2026-10-25.md) and [14 PAPER cases](safety-course/4400_ATC_TOOL_RELEASE_AND_CAPTURE_TECHNICIAN_CARD_2026-10-25.md). OSHA 2002 LOTO tool-change exception letter indexed only, direct 403. §11DD, conditional IN-04ak UNKNOWN. No selected machine installation, no physical test or external score, no compute.


**ATC-02 pinned source continuation (2026-10-25):** [LinuxCNC Task M6 tool-changed handshake trace](research/4400_LINUXCNC_PINNED_M6_IOCONTROL_TOOL_CHANGED_ACK_VS_PHYSICAL_RETENTION_SOURCE_TRACE_2026-10-25.md) at exact `062dc7c097693bb68e76192516cd92878dd5ecdf`: `emctaskmain.cc` EMC_TOOL_LOAD dispatch, `taskclass.cc` HAL pin export, `emcToolLoad()` request, `read_tool_inputs()` Boolean completion and `RCS_STATUS::DONE`; `core_sim.hal` request/ack loopback. **SOURCE-CONFIRMED** ordinary status can be acknowledged without inspecting physical retention. **TEST NOT RUN**, no local runner dispatch, no physical tool force, no safety-rating inference. ATC-01 source module cross-linked, §11DE.

### 2026-10-25 — 4400-MON-01 independent speed-monitor selection and encoder-CCF source extension
Original Pilz PNOZ s30 **1001715-EN-24** and SICK Safe Stationary Machine **8020304/2017-07-26** inspected. [Pilz mode/output source](research/4400_PILZ_PNOZS30_PARAMETER_SET_SELECTION_DIAGNOSTIC_BYPASS_AND_OUTPUT_SCOPE_AUDIT_2026-10-25.md), [SICK dual encoder/stop ramp source](research/4400_SICK_STATIONARY_MACHINE_TWO_ENCODER_CCF_SPEED_RAMP_AND_RESTART_OEM_AUDIT_2026-10-25.md), [MON-01 learner module](safety-course/4400_MON_01_SAFE_SPEED_MODE_SELECTION_ENCODER_CCF_AND_PHYSICAL_STOP_MODULE_2026-10-25.md), [16 paper cases/blank witness](safety-course/4400_SAFE_SPEED_SELECTOR_SENSOR_INDEPENDENCE_TECHNICIAN_CARD_2026-10-25.md), [fresh evaluator assignment](evaluation/4400_MON_01_FRESH_MODE_SENSOR_CCF_TRANSFER_HANDOFF_2026-10-25.md). New evidence over prior PNOZ studies: 1-of-4 vs All 16 integrity selection, open-circuit mode remap, diagnostic suppression, safe relay versus standard output, off-delay timing, SICK mechanical independence and monitored ramp. **DOC-CONFIRMED OEM examples**, not installed OpenPressBrake evidence. IN-04al UNKNOWN, physical VAL/PT NOT RUN, G3/G4 NOT AUTHORIZED, G5 OPEN; no compute question or runtime.

**MON-02 pinned LinuxCNC source continuation (2026-10-25):** [`062dc7c` spindle-at-speed trace](research/4400_LINUXCNC_PINNED_SPINDLE_AT_SPEED_DEFAULT_TRUE_RAMPED_COMMAND_VS_SAFETY_MONITOR_SOURCE_TRACE_2026-10-25.md) follows `motion.c` unwired at-speed default true, `tp.c` feed wait, ordinary `near` on command/ramped command in shipped example, alternate encoder estimate in `lathe.hal`, and `spindle_monitor.comp` at-speed/underspeed latch. Added four paper cases to MON-01, total 20; no physical/lab execution. Ordinary sequencing cannot prove safety-rated speed, physical stop/hold or fresh start.
