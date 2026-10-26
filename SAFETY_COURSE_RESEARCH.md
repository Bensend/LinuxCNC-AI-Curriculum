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

**MON-03 human-factors/desk review continuation (2026-10-25):** [15-gate no-energy change-control audit](safety-course/4400_MON_01_SAFE_SPEED_CHANGE_CONTROL_DESK_AUDIT_2026-10-25.md) makes selected mode truth, output class, encoder independence, delay, retained commands and physical hold inspectable without unauthorized energization. [Rockwell MSR57P official manufacturer-indexed 2022 page-80 SLS reset lead](research/4400_ROCKWELL_MSR57P_SLS_RESET_DURING_DELAY_INDEXED_SOURCE_LIMIT_2026-10-25.md) documents possible reset during monitoring delay and automatic normal-speed reenable; full PDF reader-size blocked, indexed-only evidence explicitly limited. No selected hardware claim or new runtime.

**MON-04 version-scope check:** [Direct pinned LinuxCNC 2.9 head `a33293f` vs development `062dc7c` source comparison](research/4400_LINUXCNC_2_9_VS_062DC7C_SPINDLE_AT_SPEED_VERSION_STABILITY_2026-10-25.md) confirms unwired `spindle.N.at-speed` default true, command-ramp proxy in shipped example and `spindle_monitor` latch in both snapshots. Source-only, not runtime or selected physical proof.

### 2026-10-25 — 4400-DUST-01 new process-safety branch after trapped-key/clamp documentary stop
[Original OSHA/CSB/NFPA publisher + pinned LinuxCNC flood-request source audit](research/4400_OSHA_NFPA660_CSB_WOOD_DUST_LEV_FIRE_VS_CNC_COOLANT_PIN_SOURCE_AUDIT_2026-10-25.md), [DUST-01 module](safety-course/4400_DUST_01_WOOD_ROUTER_LEV_CAPTURE_FIRE_AND_CNC_COMMAND_BOUNDARY_MODULE_2026-10-25.md), [12 PAPER cases / blank witness](safety-course/4400_DUST_01_TECHNICIAN_SCENARIOS_AND_BLANK_WITNESS_2026-10-25.md). Wood dust adds two distinct physical propositions beyond 3400 ordinary dust-foot/collector control: **effective capture at source** and **collector fire/deflagration prevention/mitigation**. OSHA eTool/HIB are guidance and historical 1997 NFPA 664 exceptions are NOT a current NFPA 660 compliance finding. NFPA 660 (2025) publisher scope confirmed, full normative text not inspected. Pinned LinuxCNC Task flood output is requested control only, with OFF calls in ESTOP/ON/OFF/ESTOP_RESET; no selected downstream response inferred. Independent shared-collector and fire response remain installation-specific. No OpenPressBrake collector claim, no machine tests, no blind score or hosted/local compute. Cumulative §§11DP–DQ; conditional IN-04ao UNKNOWN.

**DUST-02/03 evidence-gain continuation:** [Pinned LinuxCNC 2.9/development flood-request/abort routing](research/4400_LINUXCNC_2_9_VS_DEVELOPMENT_COOLANT_REQUEST_AND_ESTOP_VERSION_BOUNDARY_2026-10-25.md) avoids falsely inferring 2.9 retains flood on ESTOP just because direct Task call absent: separate iocontrol abort clears it. [Original Donaldson CPC Rev6/HSE LEV commissioning audit](research/4400_DONALDSON_POWERCORE_FILTER_DELTA_P_VENT_AND_SPRINKLER_OEM_AUDIT_2026-10-25.md) documents distinct filter/hood/vent/sprinkler physical propositions. [14-gate desk verification](safety-course/4400_DUST_01_NO_ENERGY_COLLECTOR_CAPTURE_AND_FIRE_DESK_VERIFICATION_PLAN_2026-10-25.md) and 16 paper cases. No selected installed device, no physical proof, no compute.

**DUST-04 normal G-code timing source:** [Pinned M8/M9 interpreter queue/remap source](research/4400_LINUXCNC_M8_M9_INTERP_QUEUE_REMAP_VS_PHYSICAL_LEV_READINESS_SOURCE_TRACE_2026-10-25.md) shows canonical flood request may queue and remap can change path; `settings->flood` is not LEV physical readiness. 18 PAPER cases total, §11DT; no runtime/physical proof.


### 2026-10-25 — 4400-CHUCK-01 rotating-workholding ejection/entanglement safety
[Original RÖHM KFD 12/03 manual, Haas hydraulic and programmable-pressure service guidance, HSE emery-cloth warning, OSHA 2015 alleged guard-bypass citation, pinned LinuxCNC M62–M65 source](research/4400_ROEHM_HAAS_CHUCK_CENTRIFUGAL_GRIP_PRESSURE_AND_LINUXCNC_DIO_SOURCE_AUDIT_2026-10-25.md). [Module](safety-course/4400_CHUCK_01_ROTATING_WORKHOLDING_DYNAMIC_GRIP_GUARD_AND_RELEASE_MODULE_2026-10-25.md), [18 PAPER cases](safety-course/4400_CHUCK_01_TECHNICIAN_SCENARIOS_AND_BLANK_WITNESS_2026-10-25.md), [14-gate desk audit](safety-course/4400_CHUCK_01_NO_ENERGY_RETENTION_GUARD_AND_CHANGE_REVIEW_2026-10-25.md), [fresh evaluator](evaluation/4400_CHUCK_01_FRESH_DYNAMIC_GRIP_EJECTION_TRANSFER_HANDOFF_2026-10-25.md). Static clamp force, jaw stroke, pressure command and speed setpoint do not prove actual rotating retention or guard containment. LinuxCNC normal digital outputs do not own personnel safety. Conditional selected IN-04ap UNKNOWN, §§11DU–DV. Physical proof and external evaluator OPEN; no compute. This is 4400 safety deepening, not reopening closed 3200.


**BAR-01 same-session new safety branch:** [Original Haas 2013 Servo Bar 300 and online newer software-specific bar-feeder source audit](research/4400_HAAS_BAR_FEEDER_LINER_WHIP_DOOR_MODE_VERSION_OEM_AUDIT_2026-10-25.md), [module](safety-course/4400_BAR_01_BAR_WHIP_LINER_AND_FEEDER_DOOR_SCOPE_MODULE_2026-10-25.md), [12 PAPER cases](safety-course/4400_BAR_01_DOOR_LINER_WHIP_TECHNICIAN_CARD_2026-10-25.md). Liner != collet grip; lid open != whole lathe/feed-cell stop; some axes may complete in-process motion under documented 100.23.000.1200+ Haas firmware. No inference that LinuxCNC has same implementation. Conditional IN-04aq UNKNOWN, §§11DW–DX, no selected machine test/evaluator/compute.


**BAR-02 physical service restraint:** [Haas AD0021 M19-not-a-block original OEM note](research/4400_HAAS_AD0021_M19_ORIENTATION_VS_SPINDLE_PHYSICAL_BLOCK_SERVICE_AUDIT_2026-10-25.md). Exact manufacturer task rejects spindle orientation as physical blocking; a selected brake/restraint requires separate mechanical and isolation evidence. §11DY, BAR-01 now 13 PAPER cases, no test or selected machine inference.


### 2026-10-25 — 4400-RESCUE-01 press-brake standard-scope and conditional entrapment release
[Original ANSI/ISO/EN publisher scope and TRUMPF B35 2023 OEM state audit](research/4400_PRESS_BRAKE_TYPE_C_SCOPE_AND_TRUBEND_ESTOP_RESCUE_CONFLICT_AUDIT_2026-10-25.md), [integrated non-graduated module](safety-course/4400_RESCUE_01_ENTRAPMENT_RELEASE_STOP_AUTHORITY_AND_FRESH_REARM_MODULE_2026-10-25.md), [16 PAPER cases and blank selected witness](safety-course/4400_RESCUE_01_NO_ENERGY_TECHNICIAN_DECISION_AND_WITNESS_CARD_2026-10-25.md), [12-gate no-energy review](safety-course/4400_RESCUE_01_12_GATE_NO_ENERGY_DESK_REVIEW_2026-10-25.md) and [fresh evaluator handoff](evaluation/4400_RESCUE_01_FRESH_SCOPE_AND_ENTRAPMENT_TRANSFER_HANDOFF_2026-10-25.md). **DOC-CONFIRMED:** ANSI B11.3-2022 applies to press brakes while B11.2 excludes them; ISO 16092-1 excludes press brakes, so ISO 16092-3 cannot be silently used as a press-brake Type-C acceptance standard. TRUMPF B35 normal beam-UP is disabled by E-stop or opened side/rear guards, while residual-risk instruction mentions UP for entrapment: requires state-dependent OEM rescue clarification, not an improvised bypass. **INFERENCE:** separately qualified rescue authority with/without power, load holding and fresh-start. **UNKNOWN:** selected OpenPressBrake actual rescue, stopping, gravity hold, pressure zones and guards; no physical test, external score or compute. §11DZ / conditional IN-04ar UNKNOWN.


**RESCUE-02 same-session OEM continuation:** [Haas HPB Rev A 08/2026 original source audit](research/4400_HAAS_HPB_2026_POWER_LOSS_HOME_POSITION_RESET_AND_PEDAL_ROLE_AUDIT_2026-10-25.md) documents raised-ram power-down leading to possible bad feedback/erratic next-start motion, a dual-role UP/Reset foot pedal and startup homing. **DOC-CONFIRMED OEM only**, not selected machine or safety-rated reset. [RESCUE-01 module](safety-course/4400_RESCUE_01_ENTRAPMENT_RELEASE_STOP_AUTHORITY_AND_FRESH_REARM_MODULE_2026-10-25.md) and [card](safety-course/4400_RESCUE_01_NO_ENERGY_TECHNICIAN_DECISION_AND_WITNESS_CARD_2026-10-25.md) expanded to 20 PAPER cases, §11EA; no physical test, external score or compute.


### 2026-10-25 — GUARD-01 1997 OSHA job-shop exception and low-friction physical safeguards
[Original full five-page CPL 02-01-025 and older guidance supersession audit](research/4400_OSHA_CPL_1997_PRESS_BRAKE_SAFE_DISTANCE_SUPERSESSION_AND_JOB_SHOP_SCOPE_AUDIT_2026-10-25.md) resolves 1986 “six-inch” historical-letter versus 1997 conditional “four-inch” trap. Neither supplies modern selected press-brake guard positioning. [Integrated 4400 module](safety-course/4400_GUARD_01_PRESS_BRAKE_JOB_SHOP_SAFEGUARD_FEASIBILITY_AND_ANTI_BYPASS_MODULE_2026-10-25.md), [16 PAPER cases](safety-course/4400_GUARD_01_TECHNICIAN_DECISION_AND_BLANK_SELECTED_WITNESS_2026-10-25.md), [12-gate desk review](safety-course/4400_GUARD_01_LOW_FRICTION_SAFEGUARD_DESK_REVIEW_2026-10-25.md), [fresh external handoff](evaluation/4400_GUARD_01_FRESH_JOB_SHOP_GUARD_TRANSFER_HANDOFF_2026-10-25.md), [one-page restricted G0 evidence request](safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md). Selected OpenPressBrake independent stop/hold, front/rear safeguarding, energy isolation, deliberate restart and actual usability UNKNOWN; no lab/physical/evaluator execution. Do not reopen graduated 3000.


**GUARD-02 original OEM continuation (2026-10-25):** [Schmersal 28-page original ISO 14119:2024 interpretation, task/mode defeat-incentive matrix](research/4400_SCHMERSAL_ISO14119_2024_DEFEAT_INCENTIVE_TASK_MATRIX_OEM_AUDIT_2026-10-25.md) independently corroborated with OSHA machine-guarding eTool. [Unpowered blank task/guard reinstall worksheet](safety-course/4400_GUARD_02_UNPOWERED_DEFEAT_INCENTIVE_AND_GUARD_REINSTALL_WORKSHEET_2026-10-25.md). Distinguish manufacturer interpretation from unseen normative clauses; mock-up usability is not personnel safety validation. No runtime, no physical/evaluator result.


### 2026-10-25 — PEDAL-01 and ENABLE-01: release/unlock impulses versus three-position grip permissives
New original [Schmersal UEDR / steute IK / Fiessler/PBS source audit](research/4400_FOOT_PEDAL_LATCH_UNLOCK_PULSE_IK_RELEASE_VARIANT_OEM_AUDIT_2026-10-25.md) and [Rockwell 440J enabling-grip source audit](research/4400_ROCKWELL_440J_THREE_POSITION_ENABLING_VS_PEDAL_AND_MULTI_PERSON_SOURCE_AUDIT_2026-10-25.md). Schmersal's mechanical unlock can cause a switch-on impulse requiring receiving-control suppression; exact steute IK article documents no release impulse; 440J grip requires separate start, reduced-performance mode and special multi-person entry treatment. **Do not assume any two "three-position" devices are interchangeable or that normal LinuxCNC/HAL is the safety controller.** [Module](safety-course/4400_PEDAL_01_THREE_POSITION_OVERTRAVEL_UNLOCK_AND_FRESH_START_MODULE_2026-10-25.md), [18 PEDAL cases](safety-course/4400_PEDAL_01_TECHNICIAN_TRANSITIONS_AND_BLANK_WITNESS_2026-10-25.md), [12 ENABLE cases](safety-course/4400_ENABLE_01_GRIP_MODE_OCCUPANCY_AND_PEDAL_NON_EQUIVALENCE_FIELD_CARD_2026-10-25.md), [fresh evaluator PREPARED/NOT RUN](evaluation/4400_PEDAL_01_FRESH_RELEASE_PULSE_VARIANT_TRANSFER_HANDOFF_2026-10-25.md). Selected physical proof and independent score remain open. No simulation justified for already explicit OEM transitions; G0/G1 HOLD, G3/G4 NOT AUTHORIZED.

**PEDAL-02 pinned LinuxCNC correction:** [Original `halui.cc` 2.9 `a33293f` and development `062dc7c` source trace](research/4400_LINUXCNC_PINNED_HALUI_PROGRAM_RUN_EDGE_VS_SAFETY_REARM_SOURCE_TRACE_2026-10-25.md) confirms `check_bit_changed` only dispatches `halui.program.run` on 0→1; a held-high input does not continuously rerun through that source path. New unlock pulse may issue ordinary NML run, but Task acceptance/physical motion and selected machine wiring remain UNKNOWN. Never claim a held HALUI input automatically restarts after E-stop; do not use ordinary HALUI edge detection as safety authority.


### 2026-10-25 — LASER-01/02: optical enclosure, service bypass and normal output semantics
[Boss LS 855-901 Rev 006 / official WI-855-407 Rev 002, Trotec and OSHA source audit](research/4400_LASER_CLASS_EMBEDDED_SOURCE_INTERLOCK_SERVICE_BYPASS_AND_FIRE_OEM_AUDIT_2026-10-25.md) shows a high-value practical hazard: original OEM troubleshooting can introduce temporary laser-interlock bypasses, requiring strict qualified restoration, not a generic maker procedure. Accessible product class, optical containment, beam isolation, smoke/fire, high-voltage energy and CNC axes are distinct. [4400-LASER-01](safety-course/4400_LASER_01_EMBEDDED_CLASS_INTERLOCK_SERVICE_RESTORATION_AND_FIRE_MODULE_2026-10-25.md), [16 unscored PAPER cases](safety-course/4400_LASER_01_OPTICAL_ENERGY_SERVICE_RESTORATION_TECHNICIAN_CARD_2026-10-25.md), [13-gate no-energy restoration](safety-course/4400_LASER_01_NO_ENERGY_GUARD_RESTORATION_AND_FRESH_START_REVIEW_2026-10-25.md) and [independent handoff](evaluation/4400_LASER_01_FRESH_EMBEDDED_CLASS_AND_SERVICE_RESTORATION_HANDOFF_2026-10-25.md) PREPARED/NOT RUN. [Pinned 2.9/development LinuxCNC M62–M65 source](research/4400_LINUXCNC_PINNED_M62_M65_DIO_MOTION_QUEUE_VS_LASER_SAFETY_INHIBIT_SOURCE_TRACE_2026-10-25.md) confirms normal DIO command path; no laser physical witness or runtime. No selected laser on OpenPressBrake asserted. No hosted/local compute, physical tests or evaluator score.


**SAW-01 distinct same-session source branch:** [SawStop PCS coast-down monitoring conditional on cartridge power, Bypass Mode OFF braking; Felder PCS key deactivation; OSHA separate kickback/under-table hazards](research/4400_SAWSTOP_FELDER_COASTDOWN_BRAKE_BYPASS_AND_KICKBACK_OEM_AUDIT_2026-10-25.md). [Module](safety-course/4400_SAW_01_BLADE_COASTDOWN_CONTACT_BRAKE_BYPASS_AND_KICKBACK_MODULE_2026-10-25.md) and [12 PAPER scenarios](safety-course/4400_SAW_01_COASTDOWN_BYPASS_BLADE_CHANGE_TECHNICIAN_CARD_2026-10-25.md). Motor OFF is not physical standstill, and contact protection is not kickback protection. OEM FAQ inspected; 24.7MB original SawStop manual not fetched, limitation preserved. No selected machine, physical test, independent evaluator or compute. §11EK.


### 2026-10-25 — 4400-WJ-01 high-pressure waterjet safety transfer
Original [Hypertherm/Flow OEM edition audit](research/4400_HYPERTHERM_WATERJET_BLEED_DOWN_AUTO_START_AND_PRESSURE_ZONE_OEM_AUDIT_2026-10-25.md) and [learner module](safety-course/4400_WJ_01_WATERJET_PRESSURE_ISOLATION_BLEED_DOWN_AND_AUTO_START_MODULE_2026-10-25.md) distinguish CNC process ready, pressure-setpoint transition, PLC startup and commanded bleed from actual UHP pressure/jet safety. High-pressure injection is a surgical emergency; no low-pressure filter gauge or pump-off timer authorizes service. [Practice](safety-course/4400_WJ_01_TECHNICIAN_DECISION_CARD_AND_BLANK_WITNESS_2026-10-25.md) and [unexecuted desk gates](safety-course/4400_WJ_01_12_GATE_NO_ENERGY_CHANGE_REVIEW_2026-10-25.md) preserve physical UNKNOWN. This is a cross-machine safety extension, not reopening graduated 3300.


**4400-CHIP-01 same-session safety rotation:** [Original Haas/OSHA/HSE source audit](research/4400_HAAS_CHIP_CONVEYOR_PERIODIC_RESTART_REVERSAL_AND_CLEANOUT_OEM_AUDIT_2026-10-25.md), [module](safety-course/4400_CHIP_01_AUXILIARY_CONVEYOR_RESTART_REVERSAL_AND_SAFE_CLEANOUT_MODULE_2026-10-25.md), [14 PAPER cases](safety-course/4400_CHIP_01_TECHNICIAN_DECISION_CARD_AND_BLANK_WITNESS_2026-10-25.md). Scheduled restart and jam reversal invalidate 'currently stopped means safe to clean'; auxiliary drive lockout and external chute guarding require separate witness. Haas M-code semantics not transplanted to LinuxCNC. §11EM, physical UNKNOWN.

### 2026-10-25 — 4400-PANEL-01/BOND-01 electrical installation safety branch
Original [UL/OSHA multi-source SCCR, arc-flash and isolation audit](research/4400_UL_OSHA_MACHINE_PANEL_MULTIFEED_SCCR_ARC_FLASH_AND_LOTO_SOURCE_AUDIT_2026-10-25.md) and [OSHA/Schneider protective-bonding variant audit](research/4400_OSHA_SCHNEIDER_PROTECTIVE_BONDING_DOOR_HINGE_VARIANT_AND_EMC_BOUNDARY_AUDIT_2026-10-25.md) add a machine-wide gap to 4400. Distinguish **available fault current vs panel SCCR vs interrupting rating vs arc-flash exposure vs electrical isolation vs physical gravity hold**, and **protective earth vs functional EMC vs exact tested switchgear hinge**. [Module](safety-course/4400_PANEL_01_MULTIFEED_SCCR_ARC_FLASH_ISOLATION_AND_RAM_HOLD_MODULE_2026-10-25.md), 30 PAPER cases across two cards and 12 unexecuted desk gates. Selected OpenPressBrake power feeds, panel ratings, protective bonds, physical holding and independent evaluator UNKNOWN; G0/G1 HOLD. No compute justified. Do not allow this branch to displace qualified selected-machine evidence or external evaluation.

### 2026-10-25 — HOLD-01 cylinder-side load-hold and emergency-override source extension
[Direct Rexroth RE 18309-03/-04 / Parker E2 audit](research/4400_REXROTH_AVBC90_EMERGENCY_SCREW_RELIEF_AND_PARKER_E2_LOAD_HOLD_SOURCE_AUDIT_2026-10-25.md) addresses a distinct gap from the earlier HYDAC flow-triggered hose fuse and Parker HAS override: one Rexroth check/metering assembly has ordinary pilot opening, pressure-shock relief that pilots the main spool, and a sealed manual emergency lowering screw requiring restoration and locking. Original manufacturer scope is excavator/ISO 8643 system design, **not** press-brake qualification. [HOLD-01 module](safety-course/4400_HOLD_01_CYLINDER_SIDE_LOAD_HOLD_RELIEF_OVERRIDE_AND_RESTART_MODULE_2026-10-25.md), [18 PAPER cases](safety-course/4400_HOLD_01_18_TECHNICIAN_CASES_AND_BLANK_WITNESS_2026-10-25.md), [12 NOT RUN desk gates](safety-course/4400_HOLD_01_12_GATE_NO_ENERGY_REVIEW_2026-10-25.md), [independent evaluator PREPARED/NOT RUN](evaluation/4400_HOLD_01_FRESH_VALVE_OVERRIDE_TRANSFER_HANDOFF_2026-10-25.md). Selected Y1/Y2 physical hold, override and relief paths UNKNOWN; no test, score, hosted/local compute or exposed-person operation.

**FILT-01 same-session distinct source rotation:** [Original Parker/HYDAC filtration/indicator audit](research/4400_PARKER_HYDAC_FILTER_BYPASS_COLD_START_INDICATOR_RESET_AND_VALVE_CONTAMINATION_OEM_AUDIT_2026-10-25.md), [14 PAPER technician cases](safety-course/4400_FILT_01_FILTER_BYPASS_INDICATOR_MEMORY_AND_COLD_START_TECHNICIAN_CARD_2026-10-25.md). Bypass-to-downstream vs bypass-to-tank vs no-bypass, filter-element collapse risk, independent ΔP indicator vs actual bypass position, electric auto-reset vs manual retained visual alarm, optional cold-temperature lockout and NO/NC wiring are different evidence propositions. Do not mistake a green HMI filter indication for clean oil or an independent physical ram-hold witness. DOC-CONFIRMED exact OEM; contamination common-cause INFERENCE; selected machine UNKNOWN. §11EV, IN-04az UNKNOWN; no physical/evaluator/compute.

**VALVE-01 same-session source rotation:** [Parker DFplus 2024 and D1VW 2024 original valve audit](research/4400_PARKER_DFPLUS_POWER_DOWN_ZERO_LAP_D1VW_MONITORED_SPOOL_AND_PRESS_SCOPE_OEM_AUDIT_2026-10-25.md) and [12 PAPER cases](safety-course/4400_VALVE_01_ENABLE_OFF_POWER_DOWN_MONITORED_SPOOL_TECHNICIAN_CARD_2026-10-25.md). OEM explicitly says DFplus enable is **not safety**; for zero-lap spools, power-down may have approximately 10% opening rather than neutral, unlike overlap. D1VW inductive start/end monitoring has exact variant-dependent meanings; hydraulic-press EN ISO 16092-3 note does not qualify a press brake. **DOC-CONFIRMED** exact OEM, no selected-machine physical state or independent PL/SIL. §11EW, IN-04ba UNKNOWN, no tests/compute/evaluator.

**External competency status:** [Coupled HOLD/FILT/VALVE independent unseen evaluation](evaluation/4400_HOLD_FILT_VALVE_COUPLED_UNSEEN_TRANSFER_HANDOFF_2026-10-25.md) is PREPARED/NOT RUN; evaluator must supply novel OEM case, privately commit reference before learner sees it, score after learner's independent answer, then perform correction/delayed retention. No synthetic feedback score or machine certification.


### 2026-10-25 — EDM-01 reset-edge, contactor monitoring and replacement default source extension
[Original Pilz/OMRON/SICK audit](research/4400_PILZ_OMRON_SICK_EDM_RESET_EDGE_DEFAULT_CONFIG_AND_CONTACTOR_PROOF_AUDIT_2026-10-25.md) and [EDM-01 module](safety-course/4400_EDM_01_CONTACTOR_FEEDBACK_RESET_EDGE_AND_FRESH_MOTION_MODULE_2026-10-25.md) isolate a distinct hazard from ordinary LinuxCNC cycle restart: **safety receiver output re-enabling can precede machine-level fresh start**, and an EDM contactor NC witness does not measure hydraulic stop/hold. PNOZ s4 2015 original warns of automatic start on restored safeguard if simple manual start is bridged; G9SE manual input requires OFF→ON→OFF and timed auto mode can re-enable after off-delay; SICK C4000 2016 original lists EDM factory default OFF, separate internal/external restart and exact receiver replacement configuration caveat. [20 PAPER cases](safety-course/4400_EDM_01_TWENTY_TECHNICIAN_CASES_AND_BLANK_WITNESS_2026-10-25.md), [12 documentary gates NOT RUN](safety-course/4400_EDM_01_TWELVE_GATE_NO_ENERGY_REVIEW_2026-10-25.md), [unseen external evaluation PREPARED/NOT RUN](evaluation/4400_EDM_01_INDEPENDENT_UNSEEN_RESET_EDM_TRANSFER_HANDOFF_2026-10-25.md). Selected G0 relay/EDM wiring/physical Y1/Y2 and blind score UNKNOWN. No local/hosted compute, physical tests or safety release.


**MIRROR-01 distinct second-source rotation:** [Schneider exact contactor/mirror NC audit](research/4400_SCHNEIDER_SIEMENS_MIRROR_NC_VS_GUIDED_AUX_EDM_VARIANT_SOURCE_AUDIT_2026-10-25.md) and [12 PAPER replacement cases](safety-course/4400_MIRROR_01_TWELVE_REPLACEMENT_AND_EDM_FAULT_CASES_2026-10-25.md) address a subtle but consequential EDM substitution: mirror NC to main power pole under IEC 60947-4-1 is **not equivalent** to mechanically linked auxiliary NO/NC under IEC 60947-5-1. Schneider's official exact TeSys K 0601/0610 difference and LC1D base/optional accessory distinctions show why a generic NC/“safety contactor” label is not evidence. Rendered optional-block table alignment ambiguous; exact suffix remains UNKNOWN. Siemens original PDF indexed but direct 403, explicitly lower provenance. No selected contactor or independent Y1/Y2 stop/hold proof; 12 cases NOT SCORED, no compute.


### 2026-10-25 — 4400-BLOCK-01: mechanical support and OSHA scope counterexample
[Original OSHA/Cincinnati audit](research/4400_CINCINNATI_OSHA_RAM_BLOCK_STATIC_VS_POWERED_STROKE_AND_PRESS_BRAKE_SCOPE_AUDIT_2026-10-25.md) documents a high-consequence transfer trap: a vendor markets mechanical-press OSHA 1910.217(d)(9)(iv) as a universal press-brake requirement, although 1910.217(a)(5) explicitly excludes press brakes. The 2007 OSHA slide-lock directive distinguishes **static gravity support from powered stroke**; the Cincinnati BASEFORM 90–175 Section 9 manual's **10% of machine capacity** support instruction is product-specific, not a transferable universal factor. The [learner module](safety-course/4400_BLOCK_01_RAM_SUPPORT_STATIC_LOAD_POWERED_STROKE_AND_SERVICE_ACCESS_MODULE_2026-10-25.md) and [12 PAPER cases/blank witness](safety-course/4400_BLOCK_01_TWELVE_RAM_SUPPORT_DECISIONS_AND_BLANK_PHYSICAL_WITNESS_2026-10-25.md) separate six physical propositions including asymmetric Y1/Y2 support, powered isolation, hydraulic pressure and anti-bypass usability. Original manufacturer PDF text indexed but 31 MB PDF could not be visually opened; exact installed machine remains UNKNOWN. No physical/independent test or compute. Selected G0 HOLD; no people-exposed operation.

### 2026-10-25 — Input cross-fault diagnostics versus output backfeed: 4400-PULSE-01 / OUT-01
[Rockwell 5034-IB8S/XT and Pilz original SI/TO audit](research/4400_ROCKWELL_PILZ_TEST_PULSE_SHARED_SOURCE_CROSS_SHORT_AND_SAFETY_INPUT_VARIANT_AUDIT_2026-10-25.md) demonstrates that two SI supplied by the same pulsed test source can have an **undetectable** cross-short in the exact Rockwell mode; Pilz PNOZ m0p forbids test outputs as actuator supplies. [Rockwell 5034-OB8S/XT output audit](research/4400_ROCKWELL_POINTMAX_SAFETY_OUTPUT_SA_BACKFEED_DETECTED_NOT_SAFE_OEM_AUDIT_2026-10-25.md) establishes the complementary high-consequence failure: **a detected SA+ to SO_n fault may prevent the load from shutting down**. [PULSE module](safety-course/4400_PULSE_01_DUAL_CHANNEL_TEST_SOURCE_IDENTITY_AND_CROSS_FAULT_MODULE_2026-10-25.md) and [OUT module](safety-course/4400_OUT_01_FAULT_DETECTED_LOAD_STILL_ENERGIZED_SAFETY_OUTPUT_MODULE_2026-10-25.md) teach diagnosis, independent physical final elements, exact wiring/configuration and anti-bypass human factors. Five artifacts, 26 unscored PAPER cases, no external evaluator or physical/compute evidence. Selected OpenPressBrake G0/G1 HOLD. Cumulative package §§11EY–11EZ.

**2026-10-25 OSSD-01 distinct original-source follow-on:** [SICK TGS 2009 OSSD internal test and unmonitored signal source audit](research/4400_SICK_TGS_OSSD_TEST_PULSE_NONMONITORED_SIGNAL_AND_RECEIVER_SCOPE_AUDIT_2026-10-25.md) and [eight PAPER cases](safety-course/4400_OSSD_01_SELF_TEST_PULSE_RECEIVER_AND_UNMONITORED_SIGNAL_TECHNICIAN_CARD_2026-10-25.md) distinguish sensor-originated brief LOW self-test, unmonitored auxiliary signal, receiver compatibility and monitored final switching device from Rockwell/Pilz receiver-sourced contact test pulses and Rockwell output-side SA+ backfeed. Exact 2009 OEM is **DOC-CONFIRMED**; no general current sensor compatibility, selected machine evidence, external score or physical test. §11FA, G0/G1 HOLD.

**2026-10-25 IO-01 integrated failure-path audit:** [four-state, 12-gate G0 worksheet](safety-course/4400_IO_01_FOUR_FAULT_STATE_SAFETY_CASE_AND_12_GATE_NO_ENERGY_REVIEW_2026-10-25.md) distinguishes **fault not detected**, **fault detected but load remains energized**, **test-source fault clears and output resumes commanded state**, and **normal sensor self-test pulse**. These have different evidence owners and failure consequences; none establishes selected-machine Y1/Y2 stop/hold or independent fresh rearm. No physical/evaluator/compute; §11FB.


### 2026-10-25 — 4400-CONFIG-01 / REPLACE-01 configuration signature and replacement integrity
[Rockwell/Siemens original-source audit](research/4400_ROCKWELL_SIEMENS_SAFETY_SIGNATURE_SCOPE_ONLINE_OFFLINE_REDOWNLOAD_AUDIT_2026-10-25.md) and [Rockwell replacement audit](research/4400_ROCKWELL_SAFETY_IO_AUTO_REPLACEMENT_SNN_AND_FUNCTIONAL_RETEST_AUDIT_2026-10-25.md) expose an important blind spot: a matching controller safety signature is **not** a signature of standard motion logic, controller network identity, wiring or physical stop/hold. Rockwell Logix Designer v36+ can change certain IP/slot settings without signature change; Siemens V20 requires identifying the correct F-CPU and checking accepted collective F-signature. OEM SNN/keying/automatic replacement still requires functional retest and alternative safety while affected device is serviced. [CONFIG learner module](safety-course/4400_CONFIG_01_SIGNATURE_SCOPE_CHANGE_CONTROL_AND_FRESH_REARM_MODULE_2026-10-25.md), [16 PAPER cases](safety-course/4400_CONFIG_01_SIXTEEN_SIGNATURE_REPLACEMENT_TECHNICIAN_CASES_2026-10-25.md), [12-gate NOT RUN review](safety-course/4400_CONFIG_01_TWELVE_GATE_NO_ENERGY_CHANGE_RELEASE_REVIEW_2026-10-25.md). **DOC-CONFIRMED** exact OEM only; **UNKNOWN** selected OpenPressBrake, independent evaluator, physical safety. No compute/test; G0/G1 HOLD.


**Same-session REINT-01 follow-on:** [Siemens V20/V21 direct source audit](research/4400_SIEMENS_V20_FIO_SHORT_POWER_LOSS_AUTO_REINTEGRATION_VS_COMM_FAULT_ACK_AUDIT_2026-10-25.md) and [12 unscored PAPER cases](safety-course/4400_REINT_01_TWELVE_POWER_DIP_COMM_FAULT_AND_FRESH_START_PAPER_CASES_2026-10-25.md) document Siemens S012: short F-I/O supply failure can auto-reintegrate despite manual ACK_NEC; detected communication faults have different passivation/acknowledgment. This is a real source-grounded counterexample to assuming that safety I/O READY implies a fresh human start. No machine-specific timing, PL/SIL, stop/hold or tests; G0/G1 HOLD.


### 2026-10-25 — 4400-SD-01/SD-02 original-OEM safety-function distinction (NON-GRADUATED)
[Schmersal 2023 serial diagnostic gateway footnote / Pilz inside escape audit](research/4400_SCHMERSAL_SD_NONSAFE_LOCK_COMMAND_WARNING_DELAY_AND_PILZ_ESCAPE_SOURCE_AUDIT_2026-10-25.md) and [exact AZM40 part 103037334 distinct interlocking-vs-locking rating audit](research/4400_SCHMERSAL_AZM40_INTERLOCK_VS_GUARD_LOCK_RATING_AND_FAULT_WARNING_VARIANT_AUDIT_2026-10-25.md). **DOC-CONFIRMED** non-safe SD unlock is process-only in specified brochure architecture; safe OSSD path distinct; some fault warnings do not mean immediate output shutdown; AZM40 product interlocking and guard locking have different published PL/category fields. **INDEXED-ONLY** AZM40 30-min warning operating paragraph; manual direct-open still required. [SD-01 module](safety-course/4400_SD_01_SERIAL_DIAGNOSTICS_LOCK_AUTHORITY_WARNING_DELAY_AND_ESCAPE_MODULE_2026-10-25.md), 26 public PAPER cases and 12 blank documentary gates; external evaluation and physical OpenPressBrake proof NOT RUN. Priority remains selected machine G0/qualified external evaluator, then other distinct 4400 safety evidence; no hosted compute.


### 2026-10-25 — ACCESS-01: three original-OEM false-safe-state traps
[Rockwell Kinetix 2013 direct-original manual audit](research/4400_ROCKWELL_KINETIX_SAFE_STOP_UNCHECKED_UNLOCK_STATUS_ONLY_AND_POWER_TO_LOCK_SOURCE_AUDIT_2026-10-25.md), [module](safety-course/4400_ACCESS_01_TIMED_UNLOCK_MONITOR_ONLY_AND_FAULT_POLARITY_MODULE_2026-10-25.md), [16 public PAPER cases](safety-course/4400_ACCESS_01_SIXTEEN_FALSE_SAFE_STATE_PAPER_CASES_2026-10-25.md), [12 blank no-energy gates](safety-course/4400_ACCESS_01_TWELVE_GATE_NO_ENERGY_GUARD_SPEED_REACTION_WITNESS_2026-10-25.md). **DOC-CONFIRMED** Rockwell 2094-RM001C-EN-P May 2013 pp.60/65/84: timed door unlock **regardless of speed** in STO without standstill checking; SLS Status Only does not initiate an overspeed stop; Power to Lock output OFF can be unlocked in fault. Product-specific vertical-axis SS1 warning; Pilz official monitored-only -M explanation. **INFERENCE** demand independent reaction/final element and physical hold/guard/escape; **UNKNOWN** installed OpenPressBrake hardware, stop/hold, pressure, PL/SIL and evaluator. No compute/physical test. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED.

**Same-session ENC-01 source extension:** [original Rockwell printed pp.18–19 single/dual encoder, mechanical coupling fault exclusion and motion-dependent diagnostic audit](research/4400_KINETIX_SINGLE_ENCODER_SIL_CLAIM_COUPLING_EXCLUSION_AND_MOTION_DEPENDENT_DIAGNOSTICS_AUDIT_2026-10-25.md), [10 PAPER cases](safety-course/4400_ENC_01_TEN_COUPLING_DIAGNOSTIC_AND_SAFETY_RATING_PAPER_CASES_2026-10-25.md). OEM conditional single-encoder up-to-PL-e claim depends on exact motor/encoder/coupling, not transferable to OpenPressBrake; motion-required diagnostics OEM **six-month** condition not a universal proof-test interval or permission to energize. **26 total public PAPER cases UNSCORED; 12 G0 gates NOT RUN; seven artifacts including external evaluator handoff PREPARED/NOT RUN**. No physical test/compute; G0 HOLD.

**Same-session COMM-01:** [direct Rockwell 2013 Disabled mode source audit](research/4400_ROCKWELL_KINETIX_DISABLED_MODE_SAFE_OUTPUTS_MOTION_POWER_ENABLED_SOURCE_AUDIT_2026-10-25.md) and [10 open commissioning return cases](safety-course/4400_COMM_01_TEN_DISABLED_MODE_AND_COMMISSIONING_RETURN_PAPER_CASES_2026-10-25.md). **DOC-CONFIRMED** safety functions/diagnostics disabled and safety outputs in safe state while commissioning motion power is enabled (printed p.22). Distinct from timer-only unlock, status-only monitor and encoder coupling. Require independent physical isolation and restoration/revalidation; no selected-machine proof. Session nine originals, 36 PAPER cases UNSCORED, 12 G0 gates NOT RUN, no compute; G0 HOLD.


### 2026-10-25 — TEACH-01: post-teach-in OSSD auto-ON and changed optical reaction time
[Direct original SICK deTec4 HG 2026 / Rockwell Micro 400 2024 audit](research/4400_SICK_DETEC4_2026_TEACH_IN_AUTO_OSSD_AND_ROCKWELL_MICRO400_RESPONSE_TIME_AUDIT_2026-10-25.md) -> [learner module](safety-course/4400_TEACH_01_PROTECTIVE_OUTPUT_TEACH_IN_AND_RESPONSE_TIME_CHANGE_MODULE_2026-10-25.md), [18 PAPER cases](safety-course/4400_TEACH_01_EIGHTEEN_CHANGE_CONTROL_TECHNICIAN_CASES_2026-10-25.md), [12 NOT RUN G0 gates](safety-course/4400_TEACH_01_TWELVE_GATE_NO_ENERGY_CONFIGURATION_WITNESS_2026-10-25.md), [fresh evaluator PREPARED/NOT RUN](evaluation/4400_TEACH_01_FRESH_CONFIGURATION_REARM_TRANSFER_HANDOFF_2026-10-25.md). **DOC-CONFIRMED exact variants:** SICK 2026 successful teach-in can re-enable OSSDs automatically absent restart interlock; Rockwell 2024 blanking changes response time and resolution, invalidating prior safety-distance/label assumptions. Optical coverage, safety rearm, fresh LinuxCNC motion command, final-element reaction and Y1/Y2 physical hold remain distinct. Selected machine G0/G1 HOLD; no physical test or compute.


**Same-session distinct OVERRIDE-01 recovery branch:** [SICK 2026 original-OEM muting/Smart Box override source audit](research/4400_SICK_2026_MUTING_OVERRIDE_RESET_SHARED_CONTROL_AND_COUNTER_RESET_AUDIT_2026-10-25.md), [module](safety-course/4400_OVERRIDE_01_MUTING_RECOVERY_OUTPUT_REARM_AND_OPERATOR_HUMAN_FACTORS_MODULE_2026-10-25.md), [12 PAPER scenarios](safety-course/4400_OVERRIDE_01_TWELVE_REARM_AND_BYPASS_INCENTIVE_PAPER_CASES_2026-10-25.md). **DOC-CONFIRMED:** manual pp.49–50/68–70 documents OSSD ON during override, possible shared reset/override, no additional reset under specified exit conditions, consecutive override count reset on startup/clean cycle and unmonitored protective field during Smart Box override. This does not establish automatic machine motion or selected OpenPressBrake hardware. G0/G1 HOLD, no compute or physical test.


### 2026-10-25 — SCAN-01/02/03 original 2025 SICK S300 integration and access-geometry research
[EFI field-status versus OSSD restart authority source audit](research/4400_SICK_S300_2025_EFI_FIELD_STATUS_BYPASSES_INTERNAL_RESTART_INTERLOCK_AUDIT_2026-10-25.md), [blind-area/contour/monitoring-case timing audit](research/4400_SICK_S300_2025_UNSECURED_NEAR_FIELD_CONTOUR_AND_MONITOR_CASE_TIMING_AUDIT_2026-10-25.md), [park/standby common-versus-separate OSSD audit](research/4400_SICK_S300_2025_PARK_STANDBY_COMMON_VS_SEPARATE_OSSD_REACTIVATION_AUDIT_2026-10-25.md). Three distinct source discriminators from SICK 8010948/ZD76/2025-08-19: field-clear EFI status does not carry internal restart interlock into Flexi Soft; scanner near-range/occlusion and delayed monitoring-case switching can leave people unprotected; common/separate OSSD topology changes standby reaction and 'not error' does not mean active scanning. [SCAN-01 learner](safety-course/4400_SCAN_01_EFI_FIELD_STATUS_VS_OSSD_RESTART_AUTHORITY_MODULE_2026-10-25.md), [SCAN-02 learner](safety-course/4400_SCAN_02_UNSECURED_GEOMETRY_CASE_SWITCH_AND_CONTOUR_REFERENCE_MODULE_2026-10-25.md), [24+8 public cases](safety-course/4400_SCAN_01_SCAN_02_TWENTY_FOUR_PUBLIC_TECHNICIAN_CASES_2026-10-25.md), [12 blank gates](safety-course/4400_SCAN_01_TWELVE_GATE_NO_ENERGY_RESTART_SIGNAL_PATH_REVIEW_2026-10-25.md), [fresh evaluator handoff](evaluation/4400_SCAN_01_FRESH_EFI_RESTART_AND_GEOMETRY_TRANSFER_HANDOFF_2026-10-25.md). No installed OpenPressBrake S300 claim, physical proof, blind score, PL/SIL or stop-distance calculation. G0/G1 HOLD; no compute.

### 2026-10-25 — 4400 LOTO-TEAM-01 and SETUP-01 maintenance boundary
New [OSHA group/shift lockout audit](research/4400_OSHA_GROUP_LOTO_SHIFT_CHANGE_REACCUMULATION_AND_TEST_POSITION_AUDIT_2026-10-25.md) separates each exposed worker's personal protection, primary coordination, shift-specific verification, stored-energy reaccumulation and the limited powered-test exception. A distinct [OSHA die-setting/inch-mode audit](research/4400_OSHA_DIE_SETTING_MINOR_SERVICING_INCH_MODE_VS_LOTO_SOURCE_AUDIT_2026-10-25.md) explains why two-hand INCH/PLC control does not replace hands-on die-space isolation and why the minor-servicing exception cannot be assumed for setup. Official OSHA text indexed; direct open 403 limitation. These are teaching artifacts, not press-brake-specific regulatory determinations or physical validation. 22 PAPER cases UNSCORED, external evaluator NOT RUN; G0/G1 HOLD, no compute. Next: actual selected-machine physical evidence and independent evaluation; if unavailable, distinct authoritative 4400 safety question, not another paraphrase of OSHA exception.

**Same-session RETURN-01:** [OSHA absent worker personal lock exception](research/4400_OSHA_ABSENT_EMPLOYEE_PERSONAL_LOCK_REMOVAL_AND_RETURN_TO_WORK_AUDIT_2026-10-25.md) + [8 unscored paper cases](safety-course/4400_RETURN_01_EIGHT_ABSENT_WORKER_LOCK_REMOVAL_PAPER_CASES_2026-10-25.md). Separate absent-person employer-directed removal and notification from normal shift turnover and temporary testing. No physical proof.

### 2026-10-25 — ACC-SAF-01 exact SAF bleed polarity and dual pressure domains; ACC-FIRE-01 fire-actuated gas vent
[Original HYDAC SAF 4.21/Parker HY10-2300-M1 audit](research/4400_HYDAC_SAF_2021_VARIANT_DEENERGIZED_BLEED_AND_PARKER_DUAL_ENERGY_AUDIT_2026-10-25.md), [ACC-SAF module](safety-course/4400_ACC_SAF_01_EXACT_BLEED_POLARITY_FLUID_GAS_AND_RAM_HOLD_MODULE_2026-10-25.md), [14 PAPER cases](safety-course/4400_ACC_SAF_01_FOURTEEN_VARIANT_ENERGY_AND_RESTART_TECHNICIAN_CASES_2026-10-25.md), [12 unexecuted documentary gates](safety-course/4400_ACC_SAF_01_TWELVE_GATE_NO_ENERGY_VARIANT_AND_PRESSURE_ZONE_REVIEW_2026-10-25.md), [external handoff NOT RUN](evaluation/4400_ACC_SAF_01_FRESH_VARIANT_ENERGY_BOUNDARY_TRANSFER_HANDOFF_2026-10-25.md). **DOC-CONFIRMED** M vs E, Y normally-open vs Z normally-closed, optional gauge and L lock, fluid pressure distinct from gas precharge. [Distinct HYDAC H2/H3 thermal fuse cap/GMP6 original audit](research/4400_HYDAC_THERMAL_FUSE_GAS_VENT_FIRE_VS_PROTECTIVE_LOAD_AUDIT_2026-10-25.md) and [8 PAPER cases](safety-course/4400_ACC_FIRE_01_EIGHT_FIRE_GAS_VENT_AND_HOLD_PAPER_CASES_2026-10-25.md) expose *conditional* protective-energy loss during fire. No selected accumulator or fire device asserted; no physical ram safe-state, pressure-zone witness, PL/SIL, independent evaluation or compute. **G0/G1 HOLD**, no personnel-exposed operation. Historical DSV10 negative-overlap evidence retained separately and not transferred to SAF.

**Same-session ACC-NORM-01 source-scope correction:** [ISO 4413:2010 §5.4.3.2 indexed preview, Parker BA and PED audit](research/4400_ISO4413_2010_ACCUMULATOR_VENT_OR_ISOLATE_EXCEPTION_PED_SCOPE_AUDIT_2026-10-25.md) and [10 public PAPER cases](safety-course/4400_ACC_NORM_01_TEN_SHUTDOWN_ISOLATION_EXCEPTION_PAPER_CASES_2026-10-25.md). The indexed preview distinguishes venting **or** positive isolation and retained-pressure exceptions; direct iTeh open 502 and full licensed clauses unavailable. Publisher ISO scope/status and Parker BA manual direct, EU-OSHA PED scope official; no general legal/selected-machine conclusion. **Final nine originals, 32 PAPER cases UNSCORED, 12 desk gates NOT RUN, evaluator NOT RUN, no compute or physical proof.**

**ACC-01 eight-state architecture synthesis:** [paper-only lifecycle authority and physical-witness matrix](safety-course/4400_ACC_01_EIGHT_LIFECYCLE_ENERGY_AUTHORITY_AND_SAFE_STATE_MATRIX_2026-10-25.md) composes stop/shutdown/fire/maintenance/rescue/restart without inventing valve truth tables or conflating ISO indexed preview with licensed normative text. **Final 10 original artifacts, 32 PAPER cases UNSCORED, no physical/compute/evaluator evidence.**


**2026-10-26 4400-FDI-01 / SS1E-01 original-source continuation:** [Siemens S210 07/2021 F-DI discrepancy and fault→STO transition audit](research/4400_SIEMENS_S210_FDI_ASYMMETRIC_DISCREPANCY_FAULT_TO_STO_SOURCE_AUDIT_2026-10-26.md) documents asymmetric initial LOW/HIGH behavior: F01611 internal event can coexist with a motor-capable window before p9658, so diagnostic red != STO physically effective. [Learner module](safety-course/4400_FDI_01_DISCREPANCY_ERROR_VS_PHYSICAL_STOP_AND_REARM_MODULE_2026-10-26.md), [12 unscored PAPER cases](safety-course/4400_FDI_01_TWELVE_ASYMMETRIC_INPUT_AND_STOP_PAPER_CASES_2026-10-26.md), [12 no-energy documentary gates NOT RUN](safety-course/4400_FDI_01_TWELVE_GATE_INPUT_TO_PHYSICAL_STOP_DOCUMENTARY_REVIEW_2026-10-26.md). Distinct [Siemens S210 SS1E no OFF3/monitoring and timer audit](research/4400_SIEMENS_S210_SS1_EXTERNAL_STOP_NO_RAMP_MONITORING_AND_TIMER_SOURCE_AUDIT_2026-10-26.md) and [8 unscored PAPER cases](safety-course/4400_SS1E_01_EIGHT_BRAKING_AUTHORITY_AND_TIMER_PAPER_CASES_2026-10-26.md) distinguish normal setpoint braking, safety timer and physical standstill. Six original artifacts, 20 PAPER cases UNSCORED, no lab/physical/evaluator execution. G0/G1 HOLD, no personnel-exposed operation; no evidence any Siemens device is installed.

**Same-session SS2E-01 (2026-10-26):** [Direct original Siemens S210 SS2E delayed SOS and retained-torque audit](research/4400_SIEMENS_S210_SS2E_EXTERNAL_DECELERATION_SOS_TORQUE_RETENTION_SOURCE_AUDIT_2026-10-26.md) plus [8 public PAPER cases](safety-course/4400_SS2E_01_EIGHT_SOS_EXTERNAL_STOP_AND_MAINTENANCE_PAPER_CASES_2026-10-26.md). External SS2 follows higher-level setpoint, not drive-autonomous OFF3; no SBR/SAM/standstill monitoring during p9553; subsequent SOS retains torque and does not substitute for LOTO. **Final eight original artifacts, 28 public PAPER cases UNSCORED, 12 documentary gates NOT RUN, external evaluator NOT RUN, no compute, G0/G1 HOLD.**

**STOP-AUTHORITY-01 synthesis:** [Source-scoped Siemens stop/torque/monitoring/physical-witness matrix](safety-course/4400_STOP_AUTHORITY_01_TORQUE_DECELERATION_DIAGNOSTIC_AND_LOAD_WITNESS_MATRIX_2026-10-26.md) distinguishes ordinary LinuxCNC halt, SS1-t/SS1E/SS2-r/SS2E, SOS, STO, SBC, SBT and service LOTO without treating any status bit as proof of hydraulic Y1/Y2 safe state. Nine original artifacts total; 28 PAPER cases UNSCORED; no lab/physical/evaluator execution; G0/G1 HOLD.


### 2026-10-26 — 4400 HAL mutation, stopped callbacks and optional remote service: pinned source safety boundary
[Stable v2.9.10/development source audit](research/4400_LINUXCNC_HAL_UNLINK_STALE_TRUE_AND_SETS_WRITER_BOUNDARY_SOURCE_TRACE_2026-10-26.md), [learner module](safety-course/4400_HAL_MUTATION_01_STALE_INPUT_AND_INDEPENDENT_SAFETY_MODULE_2026-10-26.md), [12 PAPER cases](safety-course/4400_HAL_MUTATION_01_TWELVE_CONFIG_DRIFT_PAPER_CASES_2026-10-26.md), [12 blank no-energy gates](safety-course/4400_HAL_MUTATION_01_TWELVE_GATE_NO_ENERGY_CONFIG_REVIEW_2026-10-26.md), [independent evaluator PREPARED/NOT RUN](evaluation/4400_HAL_MUTATION_01_INDEPENDENT_UNSEEN_TOPOLOGY_TRANSFER_HANDOFF_2026-10-26.md). **SOURCE-CONFIRMED** unlinked scalar HAL input retains last signal value; writerless signal `sets` and connected-pin `setp` restrictions. Distinct [HAL realtime stop source audit](research/4400_LINUXCNC_HAL_STOP_THREADS_NO_FINAL_ELEMENT_SAFE_STATE_TWO_REVISION_SOURCE_AUDIT_2026-10-26.md) and [8 PAPER cases](safety-course/4400_HAL_THREAD_01_EIGHT_SCHEDULER_VS_PHYSICAL_STOP_PAPER_CASES_2026-10-26.md) show stopping callbacks is not physical final-element stop; development ULAPI idle wait differs from stable. Distinct [optional halrmt source audit](research/4400_LINUXCNC_HALRMT_REMOTE_TOPOLOGY_CHANGE_AUTHORITY_AND_PHYSICAL_SAFETY_BOUNDARY_2026-10-26.md) and [8 PAPER cases](safety-course/4400_HALRMT_01_EIGHT_REMOTE_SERVICE_CHANGE_CONTROL_PAPER_CASES_2026-10-26.md) show HELLO/ENABLE-tier normal HAL edits, not safety authority. **Nine original artifacts / 28 public PAPER cases UNSCORED / 12 documentary gates NOT RUN / independent evaluator NOT RUN; no Actions dispatch, physical tests or lab compute.** Selected OpenPressBrake normal HAL graph, optional service, independent Y1/Y2 stop/hold, hydraulics, guards, PL/SIL and fresh restart UNKNOWN. G0/G1 HOLD. No hosted fallback; 1000/2000/F02/3000 closed.


**Same-session HAL-SNAPSHOT-01 source extension (2026-10-26):** [Two-revision `save all` vs `allu` source trace](research/4400_LINUXCNC_HAL_SAVE_ALL_VS_ALLU_UNCONNECTED_INPUT_RESTORATION_AUDIT_2026-10-26.md) and [8 public PAPER cases](safety-course/4400_HAL_SNAPSHOT_01_EIGHT_RESTORE_FIDELITY_PAPER_CASES_2026-10-26.md). **SOURCE-CONFIRMED** `all` omits unconnected input dummy `setp` serialization, `allu` includes it; neither establishes sensor health, physical safe state or restart authorization. **Final 11 original artifacts / 36 public PAPER cases UNSCORED / 12 G0 desk gates NOT RUN / independent evaluator NOT RUN**, no hosted/local compute, G0/G1 HOLD.


**HAL-SERVICE-01 final same-session synthesis:** [Four-state service-change and fresh-rearm matrix](safety-course/4400_HAL_SERVICE_01_FOUR_STATE_CHANGE_CONTROL_AND_REARM_MATRIX_2026-10-26.md) integrates source-confirmed HAL unlink, scheduler stop, optional remote edit and snapshot omissions with an independent physical-safety authority and practical low-friction service recovery. **Final 12 original artifacts, 36 public PAPER cases UNSCORED, 12 documentary gates NOT RUN, independent evaluator NOT RUN, 0 hosted/local compute, G0/G1 HOLD.** No selected-machine physical claim.


### 2026-10-26 — 4400-MECH-01 mechanical stored-energy source deepening
[ENDO/CMCO spring balancer scope audit](research/4400_ENDO_EWF_ELF_FALL_ARREST_TOP_SUSPENSION_ROPE_AND_DRUM_LOCK_SCOPE_AUDIT_2026-10-26.md) + [gas spring / independent locking support audit](research/4400_GAS_SPRING_FAILURE_INDEPENDENT_LOCKING_SHROUD_AND_MAINTENANCE_AUDIT_2026-10-26.md) -> [MECH-01 module](safety-course/4400_MECH_01_SPRING_BALANCER_GAS_STRUT_THREE_FAILURE_PATHS_MODULE_2026-10-26.md) -> [12 public PAPER cases UNSCORED](safety-course/4400_MECH_01_TWELVE_UNSCORED_MECHANICAL_SUPPORT_CASES_2026-10-26.md) -> [blank G0 physical witness](safety-course/4400_MECH_01_BLANK_MECHANICAL_ENERGY_AND_ACCESS_WITNESS_2026-10-26.md). **Distinct original OEM fault paths:** internal spring-rupture arrest, upper balancer body suspension, lower tool rope/hook, drum lock, pressurized gas strut and independent cover restraint. CMCO/Yale rope-break protection explicitly addresses rope whipping; not proof a detached tool stays suspended. ENDO conflicting fall-arrest caution left unresolved rather than silently reconciled. No selected OpenPressBrake mechanism, PL/SIL, physical load/guard/pressure evidence or independent evaluator; G0/G1 HOLD, no physical tests or hosted/local compute. Do not use ENDO-specific 10x auxiliary-rope or 100mm slack as universal design criteria.


**MECH-REARM-01 original-source continuation:** [Six-state arrest/lock/release review](safety-course/4400_MECH_REARM_01_SPRING_ARREST_DRUM_LOCK_RELEASE_AND_TOOL_EXCHANGE_STATE_REVIEW_2026-10-26.md) follows ENDO §6-3/§7-2 from faulted drum to wrong-mass tool exchange and possible rapid retraction, with independent personnel/physical support; no physical test. **G0-HF-01 course-method correction:** [canonical intake overload audit](research/4400_G0_SELECTED_MACHINE_INTAKE_PROGRESSIVE_DISCLOSURE_HUMAN_FACTORS_AUDIT_2026-10-26.md) measured 98,726 characters/91 distinct IN identifiers in the full selected-machine technical intake. Use existing A–G one-page handoff for first contact and qualified conditional expansion only when installed component presence is evidenced; no lowering of G0/G1 HOLD. **Seven originals / 12 unscored paper cases / no evaluator, machine test or compute.**


**CW-01 distinct information-gain rotation:** [Autoquip exact switch vs official California DIR counterweight guard scope](research/4400_AUTOQUIP_COUNTERWEIGHT_SWITCH_MOTOR_TRIP_VS_PHYSICAL_GUARD_CALDIR_SCOPE_AUDIT_2026-10-26.md) establishes a source-backed distinction between **motor overtravel stop**, **physical falling-mass containment**, **guarded travel zone**, **service isolation** and **fresh restart**. No evidence counterweight exists on OpenPressBrake; conditional N/A requires qualified as-built proof. Final eight originals, 12 unscored public cases, no machine/compute/evaluator evidence; G0/G1 HOLD.


**SLACK-01 distinct original-source branch:** [Autoquip FLM/FLMC Rev.1 temporary commissioning jumper and FL4M v3.4 mechanical arrest audit](research/4400_AUTOQUIP_SLACK_CHAIN_TEMPORARY_BYPASS_AND_FL4M_MECHANICAL_CAM_SOURCE_AUDIT_2026-10-26.md) plus [practical eight-prompt unscored module](safety-course/4400_SLACK_01_TEMPORARY_SERVICE_BYPASS_PHYSICAL_ARREST_AND_REARM_MODULE_2026-10-26.md). Manufacturer-sanctioned recovery exception is not authorization to leave a bypass; manufacturer specifies removal, and distinct FL4M has physical wedging cams with structural/wear requirements separate from motor switches. **DOC-CONFIRMED OEM, INFERENCE retained-bypass fault; no tests, PL/SIL, selected machine, evaluator or compute.** Final 10 original artifacts / 12 standalone + 8 embedded PAPER prompts UNSCORED; G0/G1 HOLD.


**SLACK-01 documentary gate:** [eight-gate temporary-exception return-to-normal worksheet](safety-course/4400_SLACK_01_EIGHT_GATE_TEMPORARY_EXCEPTION_RETURN_TO_NORMAL_DESK_REVIEW_2026-10-26.md) BLANK/NOT RUN, not a bypass/test procedure. Final 11 originals / 12 standalone + 8 embedded PAPER prompts UNSCORED / eight desk gates NOT RUN / external evaluator NOT RUN / G0/G1 HOLD / 0 hosted/local compute.


### 2026-10-26 — 4400-HYD-HOLD-01 original hydraulic load-hold and STOM scope
[Parker HAS exact no-holding N / manual override, PO-check ratcheting, counterbalance and trapped-pressure source audit](research/4400_PARKER_HAS_LOAD_HOLD_CODE_N_MANUAL_RELEASE_PO_CHECK_AND_TRAPPED_PRESSURE_OEM_AUDIT_2026-10-26.md) plus [Bosch Rexroth STOM hydraulic partial STO/SDE/SLS manufacturer scope](research/4400_BOSCH_REXROTH_STOM_HYDRAULIC_STO_SDE_SLS_VS_RAM_HOLD_OEM_SCOPE_AUDIT_2026-10-26.md) -> [learner module](safety-course/4400_HYD_HOLD_01_COUNTERBALANCE_PO_CHECK_STO_AND_GRAVITY_REARM_MODULE_2026-10-26.md) -> [12 unscored paper cases](safety-course/4400_HYD_HOLD_01_TWELVE_UNSCORED_VALVE_AND_RAM_CASES_2026-10-26.md), [12 unexecuted documentary gates](safety-course/4400_HYD_HOLD_01_TWELVE_GATE_NO_ENERGY_SELECTED_MACHINE_REVIEW_2026-10-26.md), [six-state matrix](safety-course/4400_HYD_HOLD_01_SIX_STATE_STOP_HOLD_SERVICE_REARM_AUTHORITY_MATRIX_2026-10-26.md), [external handoff PREPARED](evaluation/4400_HYD_HOLD_01_INDEPENDENT_UNSEEN_HYDRAULIC_FAULT_TRANSFER_HANDOFF_2026-10-26.md). [HYD-SWAP-01 manufacturer T-11A fit/opposite adjustment source](research/4400_PARKER_E2_SUN_T11A_PHYSICAL_INTERCHANGE_OPPOSITE_ADJUSTMENT_DIRECTION_AUDIT_2026-10-26.md) and [8 unscored paper cases](safety-course/4400_HYD_SWAP_01_EIGHT_UNSCORED_REPLACEMENT_ERROR_PAPER_CASES_2026-10-26.md). **DOC-CONFIRMED exact OEM**, selected machine **UNKNOWN**, no live testing or PL/SIL claims. 9 originals, 20 PAPER cases UNSCORED, 12 desk gates NOT RUN, evaluator NOT RUN, G0/G1 HOLD; 0 hosted/local compute. Do not confuse Parker/Bosch product-specific ratings with selected machine validation.


**HYD-LOX-01 same-session distinct original OEM branch:** [ROSS manual L-O-X T1/T2 pressure-zone audit](research/4400_ROSS_HYDRAULIC_LOX_T1_T2_BLEED_VS_CYLINDER_HOLD_ISOLATION_SOURCE_AUDIT_2026-10-26.md) -> [8 public unscored paper cases](safety-course/4400_HYD_LOX_01_EIGHT_NO_ENERGY_BLEED_VS_HOLD_PAPER_CASES_2026-10-26.md) -> [hold-versus-bleed decision matrix](safety-course/4400_HYD_LOX_01_DUAL_OBJECTIVE_HOLD_AND_DEPRESSURIZE_DECISION_MATRIX_2026-10-26.md). **DOC-CONFIRMED:** ROSS manual valve OFF-only lock, downstream T1 bleed, distinct T2 pump bypass, optional Port A pressure verification and not an automatic safety shutoff. **INFERENCE:** closed holding device may retain pressure beyond upstream gauge; bleeding a load-supporting chamber before mechanical support is hazardous. [Source novelty correction](research/4400_HYD_HOLD_PRIOR_EVIDENCE_DUPLICATION_RECONCILIATION_AND_SELECTION_RULE_2026-10-26.md): Parker HAS N/R/manual override already documented 2026-10-23; 2026-10-26 source recheck not a novel finding. No machine test, external score, PL/SIL or compute. G0/G1 HOLD.


**HYD-BB-BS-01 additional original ROSS OEM source:** [HBB block-and-bleed vs HBH block-and-stop exact comparison](research/4400_ROSS_HBB_BLOCK_BLEED_VS_HBH_BLOCK_STOP_MONITORING_AND_LOTO_SCOPE_AUDIT_2026-10-26.md), [10 unscored public paper cases](safety-course/4400_HYD_BB_BS_01_TEN_UNSCORED_BLEED_VS_STOP_PAPER_CASES_2026-10-26.md), [four-function matrix](safety-course/4400_HYD_BB_BS_01_STOP_HOLD_BLEED_MAINTENANCE_FOUR_FUNCTION_COMPARISON_2026-10-26.md), [qualified Stage B hydraulic evidence card](safety-course/4400_OPENPRESSBRAKE_G0_STAGE_B_HYDRAULIC_ONLY_RESTRICTED_EVIDENCE_CARD_2026-10-26.md). **DOC-CONFIRMED** HBB production-integral scope and full LOTO for maintenance, downstream check may obstruct bleed, HBH block-and-stop described for vertical load with external monitoring; no installed machine proof or automatic certification transfer. **Final 17 new files / 38 PAPER cases UNSCORED / 12 desk gates NOT RUN / evaluator NOT RUN / G0/G1 HOLD / 0 compute.**



### 2026-10-26T04:32Z — MAT-01 distinct original-source safety branch
After the 03:32Z hydraulic evidence path reached a source-only information-gain stop, the full learner safety index was checked for pressure-mat work (no 'safety mat' or 'pressure-sensitive' matches at selection). New [Rockwell MatGuard paired DIP channel-disable and off-indicator audit](research/4400_ROCKWELL_MATGUARD_DUAL_DIP_DISABLED_ZONE_AND_STATUS_PROOF_AUDIT_2026-10-26.md), [Rockwell adult 35 kg/occupancy/auto-reset/bypass audit](research/4400_ROCKWELL_MATGUARD_35KG_OCCUPANCY_RESET_AND_PHYSICAL_BYPASS_AUDIT_2026-10-26.md), [Banner SC22 four-wire fault vs reverse-motion-start audit](research/4400_BANNER_SC22_SAFETY_MAT_REVERSE_LOGIC_AND_4WIRE_FAULT_AUDIT_2026-10-26.md), [MAT-01 module](safety-course/4400_MAT_01_FLOOR_COVERAGE_DISABLED_CHANNEL_AND_RESTART_MODULE_2026-10-26.md), [12 public PAPER scenarios UNSCORED](safety-course/4400_MAT_01_TWELVE_UNSCORED_PAPER_SCENARIOS_2026-10-26.md), [12 desk gates NOT RUN](safety-course/4400_MAT_01_TWELVE_GATE_NO_ENERGY_DESK_REVIEW_2026-10-26.md), [five-layer matrix](safety-course/4400_MAT_01_FIVE_LAYER_PRESENCE_AND_REARM_AUTHORITY_MATRIX_2026-10-26.md), [external evaluator handoff PREPARED/NOT RUN](evaluation/4400_MAT_01_UNSEEN_PRESENCE_AND_CHANNEL_CHANGE_EVALUATOR_HANDOFF_2026-10-26.md). Manufacturer evidence DOC-CONFIRMED, cross-machine inference explicitly separated, selected physical proof UNKNOWN. No new LinuxCNC source claim, TEST-CONFIRMED result or compute. **G0/G1 HOLD; no personnel-exposed operation.**



**Same-session EDGE-01 continuation:** [Schmersal original STW-SL force–travel/run-on/no finger protection audit](research/4400_SCHMERSAL_STW_SL_RUNON_FORCE_TRAVEL_AND_PROFILE_RATE_OEM_AUDIT_2026-10-26.md), [Mayser SB bumper test-speed-dependent actuation and overtravel audit](research/4400_MAYSER_BUMPER_APPROACH_SPEED_RESPONSE_AND_OVERTRAVEL_OEM_AUDIT_2026-10-26.md), [module](safety-course/4400_EDGE_01_TACTILE_RUNON_CONTACT_FORCE_AND_STOP_MODULE_2026-10-26.md), [8 public PAPER cases UNSCORED](safety-course/4400_EDGE_01_EIGHT_UNSCORED_CONTACT_RUNON_PAPER_CASES_2026-10-26.md), [8 desk gates NOT RUN](safety-course/4400_EDGE_01_EIGHT_GATE_CONTACT_STOP_DESK_REVIEW_2026-10-26.md), [unseen evaluator handoff PREPARED/NOT RUN](evaluation/4400_EDGE_01_UNSEEN_FORCE_TRAVEL_TRANSFER_HANDOFF_2026-10-26.md). Distinct from floor mats: a tactile edge begins detecting only after physical contact and must retain sufficient force-limited run-on to stop. Schmersal OEM forbids STW-SL for finger protection and warns series fault coverage; Mayser same bumper's response varies with approach speed. **DOC-CONFIRMED exact OEM, INFERENCE machine architecture, UNKNOWN selected machine.** Manufacturer ISO-number and worked-example velocity-unit inconsistencies recorded without invented correction. **Combined session 14 original files, 20 PAPER cases, 20 desk gates, no external score, 0 compute, G0/G1 HOLD.**



**Same-session KEY-01 third distinct branch:** [Fortress mechanical trapped/personnel key original OEM audit](research/4400_FORTRESS_MGARD_PERSONNEL_KEY_SEQUENCE_AND_ENERGY_BOUNDARY_AUDIT_2026-10-26.md), [Pilz digital RFID safe-list/LOTO scope audit](research/4400_PILZ_KEY_IN_POCKET_DIGITAL_RESTART_VS_LOTO_SCOPE_AUDIT_2026-10-26.md), [module](safety-course/4400_KEY_01_PERSONNEL_KEY_RESTART_VS_PHYSICAL_ISOLATION_MODULE_2026-10-26.md), [8 paper cases](safety-course/4400_KEY_01_EIGHT_UNSCORED_PERSONNEL_ISOLATION_CASES_2026-10-26.md), [8 desk gates](safety-course/4400_KEY_01_EIGHT_GATE_PERSONNEL_ENERGY_DESK_REVIEW_2026-10-26.md), [external evaluator handoff](evaluation/4400_KEY_01_UNSEEN_GROUP_ACCESS_ISOLATION_HANDOFF_2026-10-26.md). Mechanical sequence, digital restart inhibit, and personal physical isolation are three separate propositions. Manufacturer marketing about electronic alternatives to LOTO is not a universal legal/safety conclusion. **DOC-CONFIRMED vendor descriptions, INFERENCE architecture, UNKNOWN selected machine; Fortress brochure direct fetch limited.** **Final 20 originals, 28 PAPER cases UNSCORED, 28 desk gates NOT RUN, three external handoffs NOT RUN, 0 compute, G0/G1 HOLD.**


### 2026-10-26T05:36Z — 4400-CYCLE-01 proof-cycle diagnostic evidence (distinct from existing RST/EDM)
[Original Pilz PNOZ s3 21395-EN-19 and SICK Safe Entry Exit exact-edition source audit](research/4400_PILZ_PNOZS3_ON_CYCLE_DIAGNOSTIC_START_FEEDBACK_NOTICE_AND_SICK_RESET_BOUNDARY_AUDIT_2026-10-26.md) -> [learner module](safety-course/4400_CYCLE_01_ON_STATE_DIAGNOSTIC_GAPS_AND_SAFE_PROOF_WORKFLOW_MODULE_2026-10-26.md), [10 public unscored cases](safety-course/4400_CYCLE_01_TEN_UNSCORED_ON_STATE_AND_DIAGNOSTIC_PAPER_CASES_2026-10-26.md), [8 unexecuted desk gates](safety-course/4400_CYCLE_01_EIGHT_GATE_NO_ENERGY_DIAGNOSTIC_CADENCE_DESK_REVIEW_2026-10-26.md), [independent evaluator handoff NOT RUN](evaluation/4400_CYCLE_01_INDEPENDENT_UNSEEN_DIAGNOSTIC_DUTY_TRANSFER_HANDOFF_2026-10-26.md). **DOC-CONFIRMED:** relay output contact diagnostics require appropriate opening cycle, manufacturer intervals conditional on exact product/application, start/feedback short-detection caveat, reset must not move machine. **UNKNOWN:** contradictory-looking PNOZ p.9/p.10 short wording, installed device, physical stop/hold. **No TEST-CONFIRMED, PL/SIL or machine release.** G0/G1 HOLD, 0 compute.


**Same-session process deliverable:** [one-screen G0 status and owner-role board](safety-course/4400_G0_BOARD_01_ONE_SCREEN_RESTRICTED_EVIDENCE_STATUS_TEMPLATE_2026-10-26.md) implements the prior staged-intake human-factors recommendation. This is a reusable **public empty template**, not an OpenPressBrake inspection or G0 release. A–G UNKNOWN, G0/G1 HOLD.


### 2026-10-26T05:36Z — PULSE-01 original OEM input-interface fault boundary
[PSEN opII4H OSSD self-test versus PNOZ m0p input-test-source source audit](research/4400_PILZ_PSEN_OSSD_300US_VS_PNOZ_TEST_OUTPUT_5MS_SCOPE_AUDIT_2026-10-26.md), [learner module](safety-course/4400_PULSE_01_OSSD_RECEIVER_VS_TEST_SOURCE_MODULE_2026-10-26.md), [8 public PAPER cases UNSCORED](safety-course/4400_PULSE_01_EIGHT_UNSCORED_INTERFACE_PAPER_CASES_2026-10-26.md), [8 documentary gates NOT RUN](safety-course/4400_PULSE_01_EIGHT_GATE_DOCUMENTARY_INTERFACE_COMPATIBILITY_REVIEW_2026-10-26.md), [independent evaluator PREPARED/NOT RUN](evaluation/4400_PULSE_01_INDEPENDENT_UNSEEN_INTERFACE_TRANSFER_HANDOFF_2026-10-26.md). **DOC-CONFIRMED** 300 µs OSSD output pulse compatibility versus 5 ms controller test-source output OFF interval for exact Pilz products, not transferable timing settings; test source not a load driver; coding changes response time. **INFERENCE** qualified safety input needed rather than normal LinuxCNC debounce; **UNKNOWN** installed machine, no physical validation or compute. G0/G1 HOLD.


### 2026-10-26 4400-LEAK-01 — OFF-state current, dry-contact minimum load and transient status (NON-GRADUATED)
[Rockwell original IntelliVAC OEM audit](research/4400_ROCKWELL_INTELLIVAC_OFF_STATE_LEAKAGE_SNUBBER_POWER_UP_AND_DELAY_OEM_AUDIT_2026-10-26.md) and [Schmersal exact catalog minimum-load audit](research/4400_SCHMERSAL_MINIMUM_RELAY_LOAD_AND_CONTACT_SUPPRESSION_SCOPE_AUDIT_2026-10-26.md) establish product-specific **DOC-CONFIRMED** input OFF leakage/residual voltage, 200 ms command-related contactor-status window, configurable power-up behavior, TDUV and minimum relay contact switching load. [LEAK-01 module](safety-course/4400_LEAK_01_OFF_COMMAND_LEAKAGE_MINIMUM_LOAD_AND_FRESH_REARM_MODULE_2026-10-26.md), [12 PAPER cases UNSCORED](safety-course/4400_LEAK_01_TWELVE_UNSCORED_OFF_STATE_INTERFACE_CASES_2026-10-26.md), [8 documentary gates NOT RUN](safety-course/4400_LEAK_01_EIGHT_GATE_NO_ENERGY_COMPATIBILITY_REVIEW_2026-10-26.md), [independent evaluator PREPARED/NOT RUN](evaluation/4400_LEAK_01_INDEPENDENT_UNSEEN_INTERFACE_TRANSFER_HANDOFF_2026-10-26.md). **INFERENCE:** output/suppressor/input compatibility and independent safety stop/hold/rearm must be separately proved. **UNKNOWN** actual OpenPressBrake interface; no physical validation, blind score or compute. G0/G1 HOLD.


**Same-session distinct SUPPRESS-01:** [Original Omron safety-relay + Schneider LC1D38BL OEM audit](research/4400_OMRON_SAFETY_RELAY_DIODE_SUPPRESSION_RELEASE_DELAY_AND_SNEAK_CURRENT_OEM_AUDIT_2026-10-26.md), [module](safety-course/4400_SUPPRESS_01_INDUCTIVE_COIL_RELEASE_DELAY_AND_STOP_BUDGET_MODULE_2026-10-26.md), [8 PAPER cases UNSCORED](safety-course/4400_SUPPRESS_01_EIGHT_UNSCORED_RELEASE_AND_FEEDBACK_CASES_2026-10-26.md), [8 desk gates NOT RUN](safety-course/4400_SUPPRESS_01_EIGHT_GATE_DOCUMENTARY_STOP_RELEASE_REVIEW_2026-10-26.md). **DOC-CONFIRMED:** surge suppression can increase relay/solenoid release time; Omron distinguishes diode, diode+Zener and CR effects; coil LED not contact state; Schneider exact catalog 20–30 ms opening and built-in bidirectional suppressor are not machine data. **INFERENCE:** independent stop-time/hold/energy validation required after suppression change. **UNKNOWN** installed machine, no physical test/compute. Combined LEAK/SUPPRESS session: 10 original artifacts, 20 public PAPER cases UNSCORED, 16 desk gates NOT RUN, LEAK evaluator PREPARED/NOT RUN.


### 2026-10-26T09:34Z — ESTOP-MECH-01 and PENDANT-01 OEM-source safety continuation
[Siemens/Rockwell contact-block mounting original audit](research/4400_SIEMENS_ROCKWELL_ESTOP_CONTACT_BLOCK_DETACHMENT_SELF_MONITOR_SOURCE_AUDIT_2026-10-26.md) and [module](safety-course/4400_ESTOP_MECH_01_ACTUATOR_BLOCK_DETACHMENT_AND_REARM_MODULE_2026-10-26.md) separate physical actuator-to-contact coupling, independent NC/mounting monitor, safety receiver and actual machine stopping. **DOC-CONFIRMED** exact OEM mounting-monitor options; **INFERENCE** shared holder defeats nominal electrical redundancy. Siemens 2016 manual indexed text only; full direct PDF 21 MB failed. [Siemens Mobile Panel 170 / Rockwell MobileView tethered pendant audit](research/4400_SIEMENS_ROCKWELL_DETACHABLE_PENDANT_ESTOP_BRIDGE_AND_FALSE_AVAILABILITY_OEM_AUDIT_2026-10-26.md) and [module](safety-course/4400_PENDANT_01_DISCONNECTED_RED_BUTTON_AND_BRIDGE_SAFE_STATION_MODULE_2026-10-26.md) establish **DOC-CONFIRMED** Basic vs Plus disconnect stop-loop behavior, Rockwell OEM bridge requiring alternative E-stop and storage of inactive pendant away from operators. **INFERENCE** false E-stop availability and unintended rearm opportunity. 22 public cases UNSCORED, 16 documentary gates NOT RUN, two evaluator handoffs PREPARED/NOT RUN. No selected-machine circuit, PL/SIL, stop/hold, physical tests, compute or external score; G0/G1 HOLD. Reopen only with qualified exact product/as-built evidence and independent physical witness.


### 2026-10-26 — PNEU-MUFFLER-01 maintenance drift, existing blocked-exhaust finding strengthened
[ROSS SS055/SS307 and SMC AMC manufacturer corroboration](research/4400_PNEUMATIC_EXHAUST_SILENCER_CLOG_MAINTENANCE_DRIFT_OEM_RECONCILIATION_2026-10-26.md) and [practical no-energy field card](safety-course/4400_PNEU_MUFFLER_01_SERVICE_ACCESSORY_CHANGE_AND_EXHAUST_PROOF_FIELD_CARD_2026-10-26.md). **Not a new mechanism:** prior 2026-10-24 Festo/ROSS audit PA-03 already identified blocked/replaced mufflers. Incremental **DOC-CONFIRMED** manufacturer SS055 webpage and indexed SS307/SMC AMC PDF excerpts establish progressive clogging, increased backpressure and altered valve timing; full PDFs not directly inspected. **INFERENCE** service accessory degradation can invalidate a prior safe-exhaust claim while safety-valve coil/status appears correct. Five public PAPER cases UNSCORED; eight desk gates NOT RUN; machine/physical performance UNKNOWN; no lab or evaluator. G0/G1 HOLD.


**Same-session PNEU-COLD-01 environment/source-conflict branch:** [ROSS 18 Series official webpage and Festo VTSA indexed original documentation audit](research/4400_ROSS_18_QUICK_EXHAUST_FREEZE_AND_CONFLICTING_TEMPERATURE_OEM_SCOPE_AUDIT_2026-10-26.md), [six unscored public cases/seven NOT-RUN desk gates](safety-course/4400_PNEU_COLD_01_FREEZE_EXHAUST_AND_OEM_RATING_CONFLICT_FIELD_CARD_2026-10-26.md). ROSS page contradicts itself: -40 °F prose versus 40 °F table (with -40 °C), and warns wet air freezes at exhaust/poppet. **DOC-CONFIRMED** conflict and OEM warning, not actual machine behavior. True selected rating and environment UNKNOWN pending exact part/OEM clarification; no invented dew point/stop time, no hosted/local compute. G0/G1 HOLD.


### 2026-10-26T11:36Z — 4400 RCD-01 residual-current waveform / drive-specific shock protection
[Original manufacturer/regulatory audit](research/4400_RCD_01_ROCKWELL_PF527_ABB_SCHNEIDER_WAVEFORM_AND_LEAKAGE_OEM_AUDIT_2026-10-26.md) and [public learner module](safety-course/4400_RCD_01_DC_LEAKAGE_RCD_TYPE_AND_PE_NO_SHORTCUT_FIELD_MODULE_2026-10-26.md) close a **distinct documentary teaching gap** after existing PANEL-01, BOND-01 and DCB-01. **DOC-CONFIRMED:** ABB 2022 original PDF directly inspected; Type B includes smooth-DC residual-current detection, unlike Type A high-immunity; internal test button simulates a fault and does not independently validate installed PE. Schneider ATV12 FAQ recommends Type A SI for its context while Schneider three-phase guidance favors Type B; Rockwell PowerFlex 527/520-series Sept 2025 manual indexed OEM excerpt explicitly requires Type B upstream where an RCD/RCM is used for contact protection for that product. **No blanket manufacturer contradiction**: exact product, topology, waveform and protection use case differ. **INFERENCE:** nuisance-trip pressure can induce dangerous PE/filter defeat; loss of supply may introduce gravity-load risk. **UNKNOWN** OpenPressBrake hardware and protection; six PAPER cases UNSCORED, eight documentary gates NOT RUN, no external evaluator, no compute or physical test. G0/G1 HOLD.


**Same-session RCD-02 voltage-dependent neutral-loss branch:** [Original ABB/Schneider + IET scope audit](research/4400_RCD_02_VOLTAGE_DEPENDENT_TRIP_NEUTRAL_LOSS_FUNCTIONAL_EARTH_OEM_AUDIT_2026-10-26.md), [four public PAPER cases and six documentary gates](safety-course/4400_RCD_02_NEUTRAL_LOSS_TRIP_POWER_AND_RESTART_FIELD_CARD_2026-10-26.md). **DOC-CONFIRMED:** trip power may depend on supply/neutral; Schneider category 1 and 2 differ on loss/restoration; FE redundancy is **functional earth, not PE**; IET E-marking is UK single-dwelling islanded guidance, not a U.S. machine code. **INFERENCE** normal RCD test-button pass does not prove broken-neutral protection; power return cannot authorize machine motion. All physical/evaluator UNKNOWN/NOT RUN; no compute, G0/G1 HOLD.


**Same-session IMD-01 separate source rotation:** [Original Bender/OSHA ungrounded control fault audit](research/4400_IMD_01_UNGROUNDED_CONTROL_FIRST_FAULT_SECOND_FAULT_AND_VFD_VARIANT_OEM_AUDIT_2026-10-26.md) and [five PAPER cases/seven gates](safety-course/4400_IMD_01_FIRST_FAULT_REPAIR_AND_SECOND_FAULT_NO_ENERGY_FIELD_CARD_2026-10-26.md). **DOC-CONFIRMED direct OEM:** symmetrical high-resistance insulation faults can falsely SET some sensitive control inputs without an RCD residual imbalance; some displacement-only ground monitors cannot detect these; iso415R main-circuit application without VFD vs iso685 inverter-compatible variant. Bender's DIN EN 60204-1 text is manufacturer summary, **not directly inspected standard**. **INFERENCE:** first fault ignored/second fault and unsafe fault alarm normalization. **UNKNOWN** selected machine wiring and physical response; no live test, no score. Total six originals, 15 PAPER cases, 21 gates, G0/G1 HOLD.


### 2026-10-26 — ESPE-OPT-01 optical bypass and selected-device formula transfer
Direct original Banner SLC4 Rev E 2022, SICK C4000 Select 2016, and SICK senSe2 2022 manuals examined for **reflective optical short circuits, adjacent-emitter crosstalk, inverted sender/receiver voids and mirror-leg coverage**. [Source audit](research/4400_ESPE_OPTICAL_FALSE_CLEAR_REFLECTION_CROSSTALK_VARIANT_OEM_AUDIT_2026-10-26.md); [field module](safety-course/4400_ESPE_OPT_01_REFLECTIVE_STOCK_OPTICAL_FALSE_CLEAR_AND_REARM_FIELD_MODULE_2026-10-26.md); [unseen evaluator handoff](evaluation/4400_ESPE_OPT_01_INDEPENDENT_UNSEEN_OPTICAL_COVERAGE_HANDOFF_2026-10-26.md). **DOC-CONFIRMED** SICK Select and senSe2 publish different minimum reflective clearances at D≤3 m (131 vs 262 mm), so never transplant formulas by brand. This optical detection gap is distinct from prior laser-scanner shadow, intentional blanking and late-detection findings. **INFERENCE:** reflective die/stock, paint, racks, mirrors and nearby optical systems are foreseeable change triggers; green HMI/OSSD alone does not prove coverage. Twelve PAPER cases UNSCORED, twelve no-energy gates NOT RUN, external evaluator PREPARED/NOT RUN; no selected machine, no physical validation, G0/G1 HOLD, no compute. Next selected-machine private Stage A + independent evaluator, otherwise another distinct safety branch.


### 2026-10-26 — MAG-01 magnetic guard sensing on steel (distinct 4400 branch)
[Original Pilz PSEN ma1.4p-50 and Schmersal BNS 33 OEM mounting audit](research/4400_MAG_01_PILZ_SCHMERSAL_FERROMAGNETIC_GUARD_SENSOR_MOUNTING_DISTANCE_OEM_AUDIT_2026-10-26.md) and [practical field card](safety-course/4400_MAG_01_STEEL_GUARD_SWARF_ACTUATOR_SWAP_AND_ASSURED_RELEASE_FIELD_CARD_2026-10-26.md) add exact ferromagnetic mounting, actuator variant, assured operating/release distance, iron-swarf, LED-polarity and series-fault-detection evidence beyond generic 25D0 interlocks. **DOC-CONFIRMED** direct manufacturer manuals; Schmersal BNS 33 2022 original documents approximate 40%/80% switching-distance reductions under its own mounting conditions and LED ON for guard OPEN. **INFERENCE** unreliable mounted gaps and nuisance defeat pressure; no installed geometry or PL/SIL. Eight PUBLIC PAPER cases UNSCORED, eight documentary gates NOT RUN, no evaluator, physical tests or compute; G0/G1 HOLD.
