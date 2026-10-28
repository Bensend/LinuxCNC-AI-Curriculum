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


### 2026-10-26 — HOSE-ROUTE-01 preventive hydraulic routing and maintenance ergonomics
[Direct Gates 2025 original manufacturer source audit](research/4400_HOSE_ROUTE_01_GATES_2025_HOSE_ASSEMBLY_ROUTING_CLAMP_TWIST_SERVICE_PROVENANCE_AUDIT_2026-10-26.md) and [12-case / eight-gate field card](safety-course/4400_HOSE_ROUTE_01_TWELVE_TECHNICIAN_CASES_EIGHT_DOCUMENTARY_GATES_AND_SERVICE_DESIGN_CARD_2026-10-26.md) address abrasion, clamp sizing, twist, minimum bend radius, pressure-driven hose length, compatibility of hose/coupling/crimp and maintenance access as **preventable initiators**. This extends prior pinhole/flow-fuse/load-holding work rather than rediscovering it. Gates' stationary-equipment three-month suggestion is generic; machine-specific interval and OSHA 1910.147 hazardous stored-energy verification remain separate. **DOC-CONFIRMED OEM/regulation; INFERENCE ergonomic change controls; UNKNOWN selected OpenPressBrake and physical proof; 12 PAPER cases UNSCORED, eight gates NOT RUN, no compute or physical test; G0/G1 HOLD.**


### 2026-10-26 — FLUID-FIRE-01 oil-mist ignition and material compatibility
[HSE RR1210 original 2024 report / Quaker exact fluid OEM audit](research/4400_FLUID_FIRE_01_HSE_MISTS2_FIRE_RESISTANT_HYDRAULIC_FLUID_AND_SEAL_COMPATIBILITY_AUDIT_2026-10-26.md) and [eight unscored paper cases / eight not-run gates](safety-course/4400_FLUID_FIRE_01_EIGHT_UNSCORED_AEROSOL_IGNITION_FLUID_CHANGE_CASES_AND_GATES_2026-10-26.md). **DOC-CONFIRMED:** fine diesel mist ignition in HSE experimental conditions and exact Quaker ester versus water-glycol seal/mixing distinctions; no numerical HSE diesel ignition distance or fire-resistant product property transfers to OpenPressBrake. **INFERENCE:** fluid conversion can stale stop/hold/seal/pressure and fire controls; **UNKNOWN** installed machine and physical evidence. No tests/compute; G0/G1 HOLD.

### 2026-10-26 — OT-SEC-01 cybersecurity-to-functional-safety bridge
[Original NIST SP 800-82 Rev.3 (2023) PDF, IEC TS 63074:2023 official scope and pinned LinuxCNC estop-latch source audit](research/4400_OT_SEC_01_NIST_800_82R3_IEC_TS_63074_REMOTE_HMI_SAFETY_AUTHORITY_AUDIT_2026-10-26.md) -> [practical field module](safety-course/4400_OT_SEC_01_REMOTE_SUPPORT_COMMAND_AUTHORITY_AND_PHYSICAL_SAFETY_FIELD_MODULE_2026-10-26.md) -> [unexecuted information-separated handoff](evaluation/4400_OT_SEC_01_INDEPENDENT_UNSEEN_REMOTE_SAFETY_TRANSFER_HANDOFF_2026-10-26.md). The course now explicitly traces remote-service/engineering-port/ordinary HMI security into independent physical safe-state integrity, not just accidental reset or stale diagnostics. NIST §6.2.10 says remote access should not negate safety; §4.2.2 warns combined control/safety architecture can expose both to compromise; §5.3.1 allows physical separation when needed. IEC technical clauses **not inspected**, only official abstract. **DOC-CONFIRMED guidance**, **INFERENCE** design patterns, **UNKNOWN** installed machine/remote access. Eight PAPER cases UNSCORED, ten desk gates NOT RUN, evaluator NOT RUN, G0/G1 HOLD, no tests/compute.

**OT-SEC-01 same-session pinned source:** [`halui.cc` Task echo vs physical authority trace](research/4400_OT_SEC_01_PINNED_LINUXCNC_HALUI_NML_COMMAND_ECHO_VS_PHYSICAL_AUTHORITY_SOURCE_TRACE_2026-10-26.md) is **SOURCE-CONFIRMED** at LinuxCNC `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7`: rising-edge machine-on, estop-reset and MDI HAL pins can send NML Task requests; `emcCommandSend` success waits for Task serial echo only. **INFERENCE** remotely connected pin could submit requests if such access exists; selected machine remains UNKNOWN, no live tests.

### 2026-10-26 — PEDAL-01/02 anti-trip human factors and safety-overtravel contact identity
[OEM/OSHA anti-trip and press-brake regulatory-scope audit](research/4400_PEDAL_01_LINEMASTER_ANTI_TRIP_SIGHTGUARD_OSHA_PRESS_BRAKE_SCOPE_AUDIT_2026-10-26.md), [public field module](safety-course/4400_PEDAL_01_ANTI_TRIP_FOOTWEAR_RELOCATION_AND_FRESH_START_FIELD_MODULE_2026-10-26.md), [external handoff](evaluation/4400_PEDAL_01_INDEPENDENT_UNSEEN_FOOT_CONTROL_HUMAN_FACTORS_HANDOFF_2026-10-26.md), [Schmersal 2006/2026 exact-model pressure-point vs safety-foot-switch source audit](research/4400_PEDAL_02_SCHMERSAL_PRESSURE_POINT_HD_VS_SAFETY_UDR_POSITIVE_OPENING_OEM_AUDIT_2026-10-26.md) and [eight-case second card](safety-course/4400_PEDAL_02_PRESSURE_POINT_PANIC_OVERTRAVEL_VARIANT_TRAP_FIELD_CARD_2026-10-26.md). **DOC-CONFIRMED:** Linemaster mechanical anti-trip latch and variant-dependent shield/footwear access; OSHA 1910.217 press-brake exclusion; Schmersal ordinary `hd` pressure-point `00→10→11` retains first NO, whereas distinct `üdr` safety variant opens/locks positive-break NC on overtravel; `f` is bistable. **INFERENCE:** ergonomics/footwear/debris/relocation change initiation risk, independent guarding and rearm still essential. **UNKNOWN:** installed pedal, contacts, controller, physical stop/hold/pressure isolation, external evaluation. 20 PAPER cases UNSCORED, 20 desk gates NOT RUN, evaluator PREPARED/NOT RUN, no machine or compute. G0/G1 HOLD.

### 2026-10-26 — RF-PEDAL-03 cableless pedal loss, receiver timeout and restart authority
[Source audit with IEC 62745 official scope, Linemaster product conflict and FCC-filed 2008 PRELIMINARY RF Industrial Rev 005](research/4400_RF_PEDAL_03_IEC62745_WIRELESS_FOOT_COMMAND_RECONNECTION_AND_OEM_GAPS_2026-10-26.md) → [eight public PAPER cases / eight documentary gates](safety-course/4400_RF_PEDAL_03_EIGHT_UNSCORED_RECONNECT_AND_STATION_HANDOVER_CASES_2026-10-26.md). **DOC-CONFIRMED historical OEM:** receiver outputs turn OFF after **1,050 ms** without signal, then resume normal functioning after restoration; typical **50 ms** command latency is separate. **UNKNOWN:** neutral/release-before-repress after reconnection, current receiver/firmware, actual machine, physical stop/hold and compliance. The 2008 manual predates IEC 62745:2017; do not freeze either value as acceptable safety performance or infer conformance. No test/compute; G0/G1 HOLD. This extends foot-pedal anti-trip into *cableless station authority*, distinct from prior OT-SEC remote HMI and detachable E-stop pendant lessons.

**RF conditional machine-intake:** [ten-question restricted Stage B card](safety-course/4400_OPENPRESSBRAKE_G0_STAGE_B_RF_CONTROL_ONLY_RESTRICTED_EVIDENCE_CARD_2026-10-26.md), all UNKNOWN, applicable only after qualified Stage A proves a cableless station. No private drawings or identifiers in public repo. Combined session eight original files, 28 public PAPER cases UNSCORED, 28 documentary gates NOT RUN; no evaluation/physical test.


### 2026-10-26 — ROPE-PULL-01 long-span emergency stop: reachable cable versus sensor green
[Rockwell Lifeline 5 Feb 2026 / Schneider XY2CE 2017 original OEM audit](research/4400_ROPE_PULL_01_ROCKWELL_SCHNEIDER_CABLE_TENSION_RESET_COVERAGE_OEM_AUDIT_2026-10-26.md) → [field module with 12 unscored cases/10 not-run gates](safety-course/4400_ROPE_PULL_01_WHOLE_SPAN_ACCESS_TENSION_WARNING_AND_RESTART_FIELD_MODULE_2026-10-26.md) → [external handoff](evaluation/4400_ROPE_PULL_01_INDEPENDENT_UNSEEN_CABLE_COVERAGE_HANDOFF_2026-10-26.md). **DOC-CONFIRMED:** Lifeline 5 exact green+amber low/high tension warning with OSSD ON versus cut/slack/pull with OSSD OFF; product-specific spring/eyebolt/pulley/thermal and all-directions pull requirements. Schneider XY2CE exact different end spring, guide spacing, NC safety vs NO indication, local reset not automatic machine start. Narrow OSHA conveyor rules are not universal press-brake obligations. **INFERENCE** easy cable restoration/inspection and safe rearm; **UNKNOWN** actual OpenPressBrake equipment and physical Y1/Y2 stop/hold, PL/SIL, score. G0/G1 HOLD; zero compute/tests.


### 2026-10-26 — ENV-01 cabinet condensation, corrosion and safety relay environment
[Original nVent HOFFMAN/Rittal/Rockwell manufacturer audit](research/4400_ENV_01_NVENT_RITTAL_ROCKWELL_CONDENSATION_ENCLOSURE_SAFETY_BOUNDARY_AUDIT_2026-10-26.md) → [eight public paper cases/eight documentary gates](safety-course/4400_ENV_01_CONDENSATION_COOLANT_INGRESS_AND_SAFE_RETURN_FIELD_CARD_2026-10-26.md). **DOC-CONFIRMED:** high-IP enclosures can draw water through gaskets during rapid cooling, condensation can corrode/defect internal components, dew-point control is a separate environmental function, and the Rockwell exact MSR126.1T relay has IP40 housing/IP20 terminals with minimum IP54 mounting enclosure. **INFERENCE:** common-cause contamination, ergonomic sealed maintenance; **UNKNOWN:** selected machine enclosure/fault polarity/PL/SIL/physical stop. Eight cases UNSCORED, eight gates NOT RUN, no tests/compute, G0/G1 HOLD.


### 2026-10-26 — RIG-01 whole press-brake delivery, unusual CG and precommissioning
[TRUMPF TruBend 2100 original quick-start and scoped OSHA audit](research/4400_RIG_01_TRUMPF_PRESS_BRAKE_DELIVERY_LIFT_FOUNDATION_OSHA_SCOPE_AUDIT_2026-10-26.md) → [eight unscored public paper cases/eight not-run desk gates](safety-course/4400_RIG_01_PRESS_BRAKE_TRANSPORT_FOUNDATION_AND_PRECOMMISSIONING_FIELD_MODULE_2026-10-26.md). **DOC-CONFIRMED product-specific:** TRUMPF unusual CG, frame lifting eyelets, armored rollers, full installation manual prerequisite, specific 16,534-lb machine mass and 8-in direct slab specification. **Not** a generic press-brake/selected OpenPressBrake mass, slab or lift point. **INFERENCE** transport/foundation/precommissioning stage gates; **UNKNOWN** actual selected-machine data/physical stop/hold. No lift, calculation, lab or hosted/local compute; G0/G1 HOLD.


### 2026-10-26 — 4400 TANDEM-01 real press-brake coupled-mode safety topology
Manufacturer evidence: [TRUMPF TruBend 8000 Feb 2017 announcement](https://www.trumpf.com/de_INT/newsroom/pressemitteilungen-lokal/pressemitteilung-detailseite-lokal/release/aus-zwei-mach-eins-trumpf-bietet-tandemversion-der-trubend-serie-8000/) explicitly separates stand-alone machines with a protective door, withdraws it in tandem, and links BendGuard across the bending length; [Accurpress HT options](https://www.accurpress.com/accurpress-ht-options) documents controller exchange and a selector for synchronized forming, **not** a certified safety mode controller. [Audit](research/4400_TANDEM_01_TRUMPF_ACCURPRESS_MODE_DEPENDENT_GUARD_AND_DUAL_RAM_STOP_AUDIT_2026-10-26.md), [field module](safety-course/4400_TANDEM_01_DUAL_PRESS_MODE_GUARD_STOP_AND_FRESH_START_FIELD_MODULE_2026-10-26.md), [external evaluator handoff](evaluation/4400_TANDEM_01_INDEPENDENT_MODE_SWITCH_AND_SHARED_WORKPIECE_HANDOFF_2026-10-26.md). Twelve public cases UNSCORED, twelve desk gates NOT RUN; exact machine safety circuit, stop/hold and validation UNKNOWN; G0/G1 HOLD, zero compute.


**4400 BLACKOUT-01 (2026-10-26):** [original OSHA 1910.37/EUCHNER exact escape release/Pilz source audit](research/4400_BLACKOUT_01_OSHA_EUCHNER_EGRESS_LIGHTING_ESCAPE_POWER_LOSS_AUDIT_2026-10-26.md) and [eight UNSCORED paper cases/eight NOT-RUN documentary gates](safety-course/4400_BLACKOUT_01_VISIBLE_EGRESS_POWER_LOSS_AND_FRESH_RESTART_FIELD_MODULE_2026-10-26.md). Egress visibility and physical release are distinct from safety output and gravity-load safe state; exact selected machine unknown, G0/G1 HOLD, zero compute.


### 2026-10-26T18:34Z — TOOL-RET-01/02 tool-drop versus stopped ram, OEM clamping variants and LinuxCNC M6
[Original WILA/Wilson/OSHA audit](research/4400_TOOL_RET_01_WILA_FORCE_LOCKED_SELF_LOCKING_SAFETY_CLICK_E2M_AND_LOTO_SOURCE_AUDIT_2026-10-26.md) → [12 UNSCORED technician cases and 12 NOT-RUN documentary gates](safety-course/4400_TOOL_RET_01_TOOL_RETENTION_PRESSURE_LOSS_ROLLOUT_AND_FRESH_RESTART_FIELD_MODULE_2026-10-26.md) → [conditional private Stage B evidence request](safety-course/4400_OPENPRESSBRAKE_G0_STAGE_B_TOOL_RETENTION_ONLY_RESTRICTED_EVIDENCE_CARD_2026-10-26.md) and [independent evaluator handoff PREPARED/NOT RUN](evaluation/4400_TOOL_RET_01_INDEPENDENT_UNSEEN_TOOL_DROP_AND_CHANGEOVER_HANDOFF_2026-10-26.md). **DOC-CONFIRMED OEM:** WILA hydraulic force-locked clamping requires active hydraulic system; WILA pneumatic Self-Locking is form-locked; Safety-Click is specified for top tools up to 12.5 kg; E2M guard prevents lateral roll-out in catalog. These are **not** generic power-loss/PL/SIL assertions. OSHA 1910.147 minor-servicing exception has strict conditions (official indexed source; direct access 403). [Pinned LinuxCNC `M6`/IOCONTROL handshake source](research/4400_TOOL_RET_02_PINNED_LINUXCNC_M6_IOCONTROL_TOOL_CHANGED_VS_PHYSICAL_RETENTION_SOURCE_TRACE_2026-10-26.md) shows `tool-changed` sets Task DONE and official `core_sim.hal` loops request to feedback without hardware (**SOURCE-CONFIRMED**, no runtime test). **INFERENCE:** physical tool retention, ram Y1/Y2 stop/hold, service isolation and deliberate restart need separate witnesses. **UNKNOWN:** installed machine, actual clamp fail state, independent physical proof and external competency. Zero hosted/local compute; G0/G1 HOLD; 1000–3000 closed.


**Same-session TOOL-LOAD-03 separate force-capacity branch:** [WILA exact uniform-load and variant/height audit](research/4400_TOOL_LOAD_03_WILA_LOCAL_TOOL_LOAD_DISTRIBUTION_AND_VERTICAL_HANDLING_SOURCE_AUDIT_2026-10-26.md) and [six unscored public paper cases/eight not-run documentary gates](safety-course/4400_TOOL_LOAD_03_SIX_UNSCORED_LOCAL_TONNAGE_AND_TOOL_CHANGE_TRANSFER_CASES_2026-10-26.md). **DOC-CONFIRMED:** WILA example 100-mm at 1,000 kN/m = 100 kN evenly distributed; BIU-022 80 ton/m versus BIU-025 130 ton/m; holder/press may limit. A BIU-031 Safety-Click-equipped example still calls for horizontal removal; do not assume vertical change. **INFERENCE** local contact distribution and tool/holder/adapter capacity require qualified application assessment, not CNC software ready or machine nameplate. **UNKNOWN** selected machine/tool/force and physical proof. Combined seven originals, 18 PAPER UNSCORED, 20 desk gates NOT RUN, no tests/compute, G0/G1 HOLD.


**Same-session FORM-HAZ-04 source rotation:** [TRUMPF indexed original bending-tool manual/OSHA press-brake eTool/WILA/Wilson audit](research/4400_FORM_HAZ_04_TRUMPF_OSHA_TOOL_FRACTURE_WORKPIECE_SWEEP_AND_SPRING_ELEMENT_SOURCE_AUDIT_2026-10-26.md) and [eight unscored paper cases/eight not-run documentary gates](safety-course/4400_FORM_HAZ_04_EIGHT_UNSCORED_WORKPIECE_SWEEP_FRACTURE_AND_RESET_CASES_2026-10-26.md). **DOC-CONFIRMED indexed TRUMPF 2024 M616en excerpt** warns tool/workpiece breakage, spring-loaded tools, material, pre-bent parts, tool/clamp capacity; 44 MB original not directly inspected. **DOC-CONFIRMED indexed OSHA** large sheet rises/falls and may pinch against slide. **INFERENCE** separate swept workpiece and stored mechanical energy boundary; **UNKNOWN** actual machine. Combined nine originals, 26 paper UNSCORED, 28 gates NOT RUN, no tests/compute, G0/G1 HOLD.


### 2026-10-26 4400 ENABLE-01 — three-position grip setup mode and no-surprise regrip
[Original EUCHNER ZSA/ZSR 2092781-09-07/26 / IDEC HE3B source audit](research/4400_ENABLE_01_EUCHNER_IDEC_THREE_POSITION_TEACH_ENABLE_RELEASE_REGRIP_SOURCE_AUDIT_2026-10-26.md) and [ten public PAPER scenarios, twelve desk gates](safety-course/4400_ENABLE_01_THREE_POSITION_GRIP_PANIC_RELEASE_REGRIP_AND_MODE_FIELD_MODULE_2026-10-26.md). **DOC-CONFIRMED** exact 3-position OFF/ON/OFF, no enable on 3→1, distinct two-stage ZSA1 warning, equivalent/antivalent dual-channel receiver and full-release fault recovery; 3 s is an OEM example, not a selected setting. **INFERENCE** fresh jog edge/mode/physical final-element separation; **UNKNOWN** selected equipment and physical Y1/Y2 hold. [External evaluator](evaluation/4400_ENABLE_01_INDEPENDENT_UNSEEN_SETUP_PANIC_REGRIP_HANDOFF_2026-10-26.md) PREPARED/NOT RUN; all cases UNSCORED/gates NOT RUN, G0/G1 HOLD, no compute.

### 2026-10-26 4400 DC-LINK-02 — residual electrical energy despite STO/dark display
[Rockwell PowerFlex 400 original direct OEM / 520, ABB, Siemens indexed / OSHA 1910.147 audit](research/4400_DC_LINK_02_STO_DARK_DISPLAY_VS_CAPACITOR_ISOLATION_AND_LOTO_OEM_AUDIT_2026-10-26.md) and [eight paper cases / eight documentary gates](safety-course/4400_DC_LINK_02_DARK_HMI_STO_CAPACITOR_LOTO_FIELD_CARD_2026-10-26.md). **DOC-CONFIRMED exact Rockwell 400:** five-minute wait AND verified zero bus; dark LCD not proof. PowerFlex 520 indexed three-minute example explicitly different, no transferable generic time; OSHA LED-only not adequate for covered energy-isolation verification. **INFERENCE** all-source isolation and maintainable labeling; **UNKNOWN** installed drives, energy zones and physical witnesses. No live tests, compute or scores; G0/G1 HOLD.


**2026-10-26 ENABLE-01 Stage B addendum:** [conditional enabling-device Stage B card](safety-course/4400_OPENPRESSBRAKE_G0_STAGE_B_ENABLE_SWITCH_ONLY_RESTRICTED_EVIDENCE_CARD_2026-10-26.md) prepared as an **existing-document-only** ten-field restricted intake. All ten fields UNKNOWN; open only after qualified Stage A establishes relevant equipment, N/A only with dated proof. No machine evidence, physical test, evaluator score or compute. G0/G1 HOLD.


### 2026-10-26 — 4400 LASER-ENC-01 optical accessible-emission vs embedded-source and service/rearm
[Direct eCFR 21 CFR 1040.10 (current 2026-10-22) / TRUMPF / FDA original source audit](research/4400_LASER_ENC_01_FDA_TRUMPF_EMBEDDED_CLASS_IV_VIEWPORT_INTERLOCK_AND_RESET_SOURCE_AUDIT_2026-10-26.md) and [12 PAPER cases / 12 documentary gates](safety-course/4400_LASER_ENC_01_ENCLOSURE_SERVICE_INTERLOCK_BEAM_SHUTTER_AND_RESTART_FIELD_MODULE_2026-10-26.md). **DOC-CONFIRMED** Class I assembled-product accessible emission vs Class IV-capable internal source, reflected access path, independent protective housing/viewport/beam attenuator, interlock defeat indication, scanned-beam safeguard, scoped post-1986 Class IV manual reset; TRUMPF manufacturer identifies false glass, gaps, bridge, fiber delivery, post-service reinspection. **INFERENCE** LinuxCNC beam-command state cannot prove safe optical access. **UNKNOWN** selected laser, actual wavelengths/optical attenuation, physical test and PL/SIL. Independent evaluator [PREPARED/NOT RUN](evaluation/4400_LASER_ENC_01_INDEPENDENT_UNSEEN_ENCLOSURE_CHANGE_TRANSFER_HANDOFF_2026-10-26.md). G0/G1 HOLD, no compute.

### 2026-10-26 — 4400 LASER-AIR-02 airborne contaminants independent of optical beam containment
[NIOSH 1990 field abstract / CDC 2024 peer-reviewed abstract / TRUMPF OEM / HSE UK welding-scoped audit](research/4400_LASER_AIR_02_NIOSH_TRUMPF_CAPTURE_VS_FILTER_AND_RADIATION_INDEPENDENCE_SOURCE_AUDIT_2026-10-26.md), [8 PAPER cases / 8 desk gates](safety-course/4400_LASER_AIR_02_CAPTURE_FILTER_SERVICE_AND_MATERIAL_CHANGE_FIELD_MODULE_2026-10-26.md). **DOC-CONFIRMED** actual historical industrial airborne hazard with optical radiation below allowable, material/ventilation-dependent emissions and exact TRUMPF filter element efficiency not proving system capture, bypass-free filtration, gas adsorption or occupational exposure. **INFERENCE** separately engineer capture, fire, maintenance and human factors. **UNKNOWN** installed machine/contaminants/flow/physical proof; no live cutting or compute, G0/G1 HOLD.


### 2026-10-26 — ACC-GAS-01 / ACC-SEQ-02: accumulator vessel energy and architecture-dependent stop/bleed sequence
[HYDAC 2011 and Parker 2026 gas-side audit](research/4400_ACC_GAS_01_HYDAC_PARKER_GAS_SIDE_RESIDUAL_ENERGY_AND_BLANK_PRECHARGE_SOURCE_AUDIT_2026-10-26.md) + [10 public paper cases/10 not-run gates](safety-course/4400_ACC_GAS_01_NITROGEN_BLANK_LABEL_ZERO_GAUGE_SERVICE_FIELD_MODULE_2026-10-26.md); [reserve-vs-bleed OEM architecture audit](research/4400_ACC_SEQ_02_PARKER_HYDAC_RESERVE_ENERGY_VS_AUTOMATIC_BLEED_SAFE_STOP_SOURCE_AUDIT_2026-10-26.md) + [10 public paper cases/10 not-run gates](safety-course/4400_ACC_SEQ_02_ESTOP_DUMP_RESERVE_STOP_HOLD_AND_REARM_FIELD_MODULE_2026-10-26.md). **DOC-CONFIRMED:** blank Parker BA precharge label may coexist with 29 psig holding charge; HYDAC fluid gauge sudden zero is not nitrogen discharge; Parker describes stored reserve for emergency safe completion, HYDAC SAF M/E distinct manual/solenoid bleed features. **INFERENCE:** selected hydraulic safety stop and service energy-release sequencing may compete; no generic dump-on-E-stop circuit. [Independent unseen evaluator](evaluation/4400_ACC_GAS_SEQ_INDEPENDENT_UNSEEN_STORED_ENERGY_STOP_ORDER_HANDOFF_2026-10-26.md) PREPARED/NOT RUN. All selected-machine presence, stop/hold, pressure, valve truth, performance and physical validation UNKNOWN. G0/G1 HOLD, no tests/compute.


### 2026-10-26T22:35Z — 4400 safety output coil suppression, leakage and unintended current paths
Direct manufacturer evidence: [Rockwell Safebook 5 / OMRON COIL-SUP-01](research/4400_COIL_SUP_01_ROCKWELL_OMRON_DC_COIL_SUPPRESSION_DROPOUT_STOP_TIME_SOURCE_AUDIT_2026-10-26.md) establishes that inductive DC coil suppression can delay contactor/solenoid release, so safety logic output OFF does not fix the end-to-end stop-time. [OMRON SNEAK-CUR-02](research/4400_SNEAK_CUR_02_OMRON_SAFETY_RELAY_LEAKAGE_SNEAK_CURRENT_AND_SUPPRESSOR_LOCATION_SOURCE_AUDIT_2026-10-26.md) separately documents leakage and sneak-current paths through coils and contact-bypass suppression. These are two distinct fault mechanisms, not interchangeable explanations. Practical [COIL-SUP](safety-course/4400_COIL_SUP_01_SAFETY_OUTPUT_COIL_SUPPRESSION_AND_STOP_TIME_FIELD_MODULE_2026-10-26.md) and [SNEAK-CUR](safety-course/4400_SNEAK_CUR_02_LEAKAGE_BACKFEED_AND_FRESH_RESTART_FIELD_MODULE_2026-10-26.md) modules carry 20 UNSCORED paper scenarios and 20 NOT RUN documentary gates. [Independent unseen evaluator](evaluation/4400_COIL_SUP_SNEAK_CUR_INDEPENDENT_UNSEEN_OUTPUT_ENERGY_HANDOFF_2026-10-26.md) PREPARED/NOT RUN. No selected machine, physical timing, hydraulic valve truth, coil current, PL/SIL or stopping distance is inferred. No Actions/local compute. G0/G1 HOLD.


### 2026-10-26T22:35Z — PNEU-EXH-03 restricted exhaust and trapped pressure zone
[Direct Parker 2019 P33 / SMC 2024 DXT1215 / ROSS RSe audit](research/4400_PNEU_EXH_03_PARKER_SMC_ROSS_CLOGGED_EXHAUST_TRAPPED_ZONE_AND_RESET_SOURCE_AUDIT_2026-10-26.md) establishes **DOC-CONFIRMED** silencer clog/backpressure can impair pneumatic exhaust; a non-safety solenoid valve is not upgraded by an HMI label; Parker P33 is explicitly energy-isolation, not E-stop, per its manual; ROSS RSe cannot exhaust downstream of check/closed-center valves. [Ten paper scenarios/ten desk gates](safety-course/4400_PNEU_EXH_03_SILENCER_BACKPRESSURE_TRAPPED_ZONE_FIELD_MODULE_2026-10-26.md) and [independent evaluator handoff](evaluation/4400_PNEU_EXH_03_INDEPENDENT_UNSEEN_PRESSURE_ZONE_AND_EXHAUST_HANDOFF_2026-10-26.md) remain UNSCORED/NOT RUN. Do not infer installed OpenPressBrake pneumatic devices, PL/SIL, exact valve truth, physical discharge, load support or timing. No compute, G0/G1 HOLD.

**Source-overlap qualification:** [predecessor→increment crosswalk and canonical-index novelty method](research/4400_SAFETY_SOURCE_OVERLAP_RECONCILIATION_AND_NOVELTY_CHECK_METHOD_2026-10-26.md) confirms earlier Rockwell/OMRON suppression, IntelliVAC leakage and Festo/ROSS pneumatic work. This session adds **exact OEM source corroboration, standards-edition scope and unscored transfer**, not first discovery of these generic mechanisms. Zero code-search hits were misleading; future novelty scans must inspect full canonical index.

### 2026-10-26T23:33:56Z — ALARM-NOISE-01 perceptibility versus hearing exposure and protective authority
[Original official OSHA/NIOSH + exact WERMA OEM audit](research/4400_ALARM_NOISE_01_OSHA_NIOSH_WERMA_PERCEPTIBILITY_AND_AUTHORITY_AUDIT_2026-10-26.md), [field module: eight PUBLIC PAPER cases UNSCORED / ten desk gates NOT RUN](safety-course/4400_ALARM_NOISE_01_AUDIBLE_WARNING_NOT_SAFETY_INTERLOCK_FIELD_MODULE_2026-10-26.md), [four-purpose authority matrix](safety-course/4400_ALARM_NOISE_01_WARNING_PURPOSE_PHYSICAL_AUTHORITY_AND_CHANGE_MATRIX_2026-10-26.md), [independent unseen evaluator PREPARED/NOT RUN](evaluation/4400_ALARM_NOISE_01_INDEPENDENT_UNSEEN_PERCEPTION_AND_AUTHORITY_HANDOFF_2026-10-26.md). Direct 953-line index novelty scan found no auditory/noise/hearing branch; existing stop/rearm/guard work not rediscovered. **DOC-CONFIRMED indexed OSHA only:** 1910.165 covered emergency-action alarms must be perceptible/recognizable; 1910.95 85 dBA action vs 90 dBA PEL, direct OSHA regulation pages HTTP 403. **DOC-CONFIRMED direct:** NIOSH 85 dBA REL/3 dB exchange and exact WERMA RST56 686.371.35 82/90 dBA at 1 m selector/5000 h acoustic life. Product rating cannot establish installed reception or worker exposure; a machine pre-cycle chime is not automatically OSHA 1910.165 emergency alarm. **INFERENCE** independent physical guarding/stop/hold and accessible multi-modal warning. **UNKNOWN** selected OpenPressBrake warning, acoustics, Y1/Y2 stop/hold, energy isolation, external evaluator. No live/no-energy test, no score, 0 hosted/local compute; G0/G1 HOLD.

**Same-session HYD-AIR-01 new fluid-fault mechanism:** [Direct Bosch/Parker OEM source audit and Danfoss indexed corroboration](research/4400_HYD_AIR_01_BOSCH_PARKER_CAVITATION_AERATION_AND_ERRATIC_ACTUATOR_OEM_AUDIT_2026-10-26.md), [six public paper cases/eight desk gates](safety-course/4400_HYD_AIR_01_CAVITATION_VS_AERATION_SAFE_SERVICE_FIELD_CARD_2026-10-26.md). **DOC-CONFIRMED direct OEM:** vapor cavitation differs from external aeration; Parker T20 rotary actuator service guide lists air causing erratic/unresponsive motion and failure to maintain selected position. **INDEXED-only** Danfoss J Frame corroboration; PDF direct timeout. **INFERENCE** changing hydraulic fluid behavior could affect normal control and selected physical stop/hold; no press-brake truth table, pressure or numeric threshold transferred. **UNKNOWN** OpenPressBrake installed fluid/pump/actuator and independent Y1/Y2 stop/hold. Six cases UNSCORED, eight gates NOT RUN, no physical/evaluator/compute, G0/G1 HOLD.

**Cross-branch acoustic CCF hypothesis:** [ALARM-NOISE × HYD-AIR adversarial review](safety-course/4400_ALARM_NOISE_HYD_AIR_CROSSCUT_NOISE_DIAGNOSTIC_VS_WARNING_PROOF_REVIEW_2026-10-26.md) distinguishes nonunique hydraulic noise diagnostic from physical warning reception and independent safe state. Combined masking pathway **INFERENCE**, no installed-machine data or extra score/gate. Final eight original artifacts, 14 unscored paper cases, 18 unrun gates, 0 compute, G0/G1 HOLD.


### 2026-10-27 — 4400 HYD-INT-01 / HYD-CUSH-02 trapped return and invisible internal cushion pressure
Direct manufacturer research: [ROSS/Aggressive Hydraulics differential-area pressure audit](research/4400_HYD_INT_01_ROSS_AGGRESSIVE_HYDRAULICS_TRAPPED_ROD_SIDE_PRESSURE_INTENSIFICATION_AUDIT_2026-10-27.md) and [Aggressive Hydraulics internal cushion-pocket pressure/port-gauge limitation](research/4400_HYD_CUSH_02_AGGRESSIVE_HYDRAULICS_INTERNAL_CUSHION_PRESSURE_VS_PORT_GAUGE_AUDIT_2026-10-27.md). Full 963-line index novelty check found no `intensif`, `annulus`, `meter-out` or internal-cushion pressure module; related counterbalance, hose, accumulator and die-cushion evidence remains intact. **DOC-CONFIRMED** exact manufacturer scope; static force ratio is an illustrative **INFERENCE**, not transient physical pressure or selected safety performance. [HYD-INT 8-case/8-gate paper module](safety-course/4400_HYD_INT_01_TRAPPED_RETURN_PRESSURE_AND_SAFE_STOP_FIELD_MODULE_2026-10-27.md) and [HYD-CUSH 6-case/8-gate paper module](safety-course/4400_HYD_CUSH_02_END_STROKE_LOCAL_PRESSURE_GAUGE_BLIND_SPOT_FIELD_MODULE_2026-10-27.md) UNSCORED/NOT RUN. [Architecture/CHG review](safety-course/4400_HYD_INT_CUSH_01_02_STOP_HOLD_LOCAL_PRESSURE_CHANGE_REVIEW_2026-10-27.md), [conditional 12-field restricted machine card](safety-course/4400_OPENPRESSBRAKE_G0_STAGE_B_HYD_INT_CUSH_RESTRICTED_EVIDENCE_CARD_2026-10-27.md) all UNKNOWN, [independent unseen evaluator](evaluation/4400_HYD_INT_CUSH_INDEPENDENT_UNSEEN_LOCAL_PRESSURE_STOP_HOLD_HANDOFF_2026-10-27.md) PREPARED/NOT RUN. No hosted/local compute or physical pressure tests. G0/G1 HOLD.


### 2026-10-27 continuation — CYL-STRUCT-03 rod buckling/mount side-load structural safe state
[Direct Aggressive Hydraulics FAQ, misalignment and design-safety-factor + Enerpac original source audit](research/4400_CYL_STRUCT_03_AGGRESSIVE_ENERPAC_BUCKLING_SIDELOAD_AND_DUAL_AXIS_STRUCTURAL_AUDIT_2026-10-27.md) → [eight UNSCORED paper cases/eight NOT RUN documentary gates](safety-course/4400_CYL_STRUCT_03_ROD_BUCKLING_MISALIGNMENT_AND_ASYMMETRIC_LOAD_FIELD_MODULE_2026-10-27.md) → [independent unseen evaluator PREPARED/NOT RUN](evaluation/4400_CYL_STRUCT_03_INDEPENDENT_UNSEEN_STRUCTURAL_LOAD_HANDOFF_2026-10-27.md). Full 963-line learner index lacked `buckl`, `misalign`, `column strength` and `piston rod`; distinct structural failure mechanism, not another hydraulic pressure or valve lesson. **DOC-CONFIRMED** OEM buckling at stress below yield, length/mount/side-load dependencies, and separate burst/tension/column design modes. **INFERENCE** Y1/Y2 asymmetry could create off-axis loads. **UNKNOWN** selected machine, no physical tests, zero hosted/local compute, G0/G1 HOLD.


### 2026-10-27 — 4400 MACH-ACCESS-01 / MACH-LOW-02 maintenance fall and low-height machinery destination
[Direct US eCFR 1910.23/1910.22 + HSE maintenance + ISO 14122 publisher metadata source audit](research/4400_MACH_ACCESS_01_ISO14122_OSHA_INTEGRAL_LADDER_HSE_MAINTENANCE_ACCESS_SCOPE_AUDIT_2026-10-27.md), [field card](safety-course/4400_MACH_ACCESS_01_INTEGRAL_LADDER_PLATFORM_AND_MAINTENANCE_OPENING_FIELD_MODULE_2026-10-27.md), [temporary-grating custody and physical handback](safety-course/4400_MACH_ACCESS_01_REMOVABLE_GRATING_ACCESS_AND_PHYSICAL_HANDBACK_CROSSCUT_2026-10-27.md). Distinct [direct eCFR 1910.28 low-height dangerous-equipment/holes/falling-objects audit](research/4400_MACH_LOW_02_ECFR_1910_28_HOLES_DANGEROUS_EQUIPMENT_FALLING_OBJECT_SCOPE_AUDIT_2026-10-27.md) → [six-case field card](safety-course/4400_MACH_LOW_02_BELOW_FOUR_FEET_DANGEROUS_EQUIPMENT_HOLES_AND_DROPPED_TOOLS_FIELD_CARD_2026-10-27.md). **DOC-CONFIRMED** exact legal text in its scope, HSE real removed-grating incident, ISO catalogue editions/scopes 14122-1/-2/-3/-4 only; **COMMUNITY-REPORTED** IMCA 2023-10-16 unbarricaded removed-grating near miss (distinct from HSE injury); **INFERENCE** physical architecture transfer; **UNKNOWN** machine/jurisdiction/structural ratings, independent stop/hold and access. No physical tests, score or compute; **14 paper cases UNSCORED, 16 desk gates NOT RUN, G0/G1 HOLD**.


### 2026-10-27 — DUST-05 combustible particulate, collector-vessel and connected-duct safety
[OSHA/CSB/HSE/Fike/NFPA-660 source audit](research/4400_DUST_05_OSHA_CSB_FIKE_NFPA660_COLLECTOR_PROPAGATION_SOURCE_DELTA_2026-10-27.md) → [ten PUBLIC PAPER cases UNSCORED / twelve desk gates NOT RUN](safety-course/4400_DUST_05_PRIMARY_SECONDARY_COLLECTOR_TRANSFER_FIELD_CARD_2026-10-27.md) → [physical isolation/CCF/change-impact matrix](safety-course/4400_DUST_05_COLLECTOR_ISOLATION_CCF_CHANGE_TRANSFER_REVIEW_2026-10-27.md). **CORRECTED:** exact-keyword scan missed the existing 2026-10-25 DUST-01–04 source/module/18 scenarios/14-gate review; DUST-05 is an incident/OEM source extension, not a new generic safety mechanism. [DUST-05 predecessor correction](research/4400_DUST_05_PREDECESSOR_OVERLAP_RECONCILIATION_AND_SOURCE_DELTA_2026-10-27.md). **DOC-CONFIRMED direct:** HSE extraction fires, CSB primary→secondary incident findings, Fike vessel vent/suppress versus connected duct isolation. **DOC-CONFIRMED indexed-only:** OSHA 2023 NEP/dust pentagon, NFPA 660:2025 active edition/consolidation; normative NFPA text NOT inspected. **INFERENCE:** normal fan/spindle stop and airflow telemetry are not personnel-safety authority. **UNKNOWN:** selected machine/dust/protection/vent, qualified physical proof and evaluator; no assumption OpenPressBrake generates combustible dust. No physical test, score or compute; G0/G1 HOLD.


**Same-session distinct ABRASIVE-01 branch:** [direct HSE/Norton and indexed OSHA wheel-burst source audit](research/4400_ABRASIVE_01_HSE_NORTON_OSHA_WHEEL_BURST_OVERSPEED_GUARD_COMPATIBILITY_AUDIT_2026-10-27.md) → [eight public PAPER cases UNSCORED / ten desk gates NOT RUN](safety-course/4400_ABRASIVE_01_WHEEL_BURST_SPEED_GUARD_EIGHT_CASE_FIELD_CARD_2026-10-27.md). Direct index scan found no wheel burst/guard/overspeed lesson. **DOC-CONFIRMED direct eCFR (2026-10-23):** §1910.215 offhand rest, tongue scope, organic-bond ring-test caveat and ANSI B7.1-1970 incorporation; no universal CNC dimensions. **DOC-CONFIRMED direct:** correct wheel speed/mounting, fragment containment and guard attachment are distinct; HSE HSG17 2000 is UK guidance, Norton 2023 exact OEM. **DOC-CONFIRMED direct eCFR:** Direct eCFR §1910.215 wheel/machine-type scope. **INFERENCE:** ordinary CNC speed command/stop is not physical fragment protection. **UNKNOWN:** selected wheel, actual speed, guard, physical witness, evaluator. Combined DUST+ABRASIVE **five originals, 18 unscored public cases, 22 unrun desk gates, zero compute**, G0/G1 HOLD.


**DUST-05 governance correction:** The 2026-10-25 DUST-01–04 module/source/18-case/14-gate predecessor was missed by exact keywords. [Direct reconciliation audit](research/4400_DUST_05_PREDECESSOR_OVERLAP_RECONCILIATION_AND_SOURCE_DELTA_2026-10-27.md) classifies this session's DUST-05 as new incident/OEM evidence and overlapping unscored transfer, not a new mechanism; updated work-selection policy.

**Same-session MAGCHUCK-01 rotation:** [Direct HSE/Walker original manual/Walmag OEM audit](research/4400_MAGCHUCK_01_HSE_WALKER_WALMAG_POWER_LOSS_CONTACT_AND_EJECTION_SOURCE_AUDIT_2026-10-27.md) → [six public PAPER cases UNSCORED/eight documentary gates NOT RUN](safety-course/4400_MAGCHUCK_01_POWER_LOSS_POLE_COVERAGE_AND_EJECTION_SIX_CASE_CARD_2026-10-27.md). Distinct from VAC-01 and MAG-01 guard sensors: permanent/electro-permanent hold can survive power loss, yet contact/pole coverage/material/air gap determine actual workpiece retention; residual attraction can crush fingers. **DOC-CONFIRMED direct** for exact HSE/Walker/Walmag; Walmag marketing '100% safe' not machine certification. **INFERENCE** independent ejection/maintenance witnesses; **UNKNOWN** selected machine/part, physical proof and evaluator. Session **eight original artifacts, 24 public unscored cases, 30 unrun desk gates, zero compute**, G0/G1 HOLD.


**Same-session COMPOSE-01:** [integrated wheel/magnetic chuck/collector power-loss and fresh-start failure-path analysis](safety-course/4400_COMPOSE_01_WHEEL_MAGCHUCK_DUST_COLLECTOR_POWER_LOSS_AND_RESTART_CROSSCUT_2026-10-27.md) is **INFERENCE** across original HSE/Norton/Walker/Walmag/Fike and existing DUST-01–04 source; no selected hardware truth table, PL/SIL, physical test or external score. Session **nine originals including correction**, 24 public unscored cases and 30 desk gates NOT RUN; no compute, G0/G1 HOLD.


## 2026-10-27 — 4400-MWF-MIST-01 and MWF-QUALITY-02: health/exposure control after machine stop
Full-index and research-plan novelty review: no prior MWF-specific aerosol, microbial growth or dermatitis/rotating-glove module; LASER-AIR, DUST and FLUID-FIRE are related but distinct. [Original direct HSE MW1/MW2/MW5, NIOSH and indexed-only OSHA audit](research/4400_MWF_01_02_NIOSH_HSE_OSHA_MIST_SKIN_MICROBIAL_EXPOSURE_SOURCE_AUDIT_2026-10-27.md), [mist/LEV/door clearance field module](safety-course/4400_MWF_MIST_01_SPINDLE_STOP_VS_BREATHING_ZONE_CLEARANCE_FIELD_MODULE_2026-10-27.md), [microbiology/skin/glove entanglement field module](safety-course/4400_MWF_QUALITY_02_MICROBIAL_SKIN_GLOVES_AND_SERVICE_FIELD_MODULE_2026-10-27.md) and [independent physical/exposure authority matrix](safety-course/4400_MWF_01_02_MIST_CLEARANCE_GUARD_ACCESS_AND_FLUID_HEALTH_CROSSCUT_2026-10-27.md). **DOC-CONFIRMED** HSE MW1 residual mist despite motion stop and need for actual clearance/LEV assessment, MW5 water-mix microbial trend and supplier biocide discipline, MW2 dermatitis/glove entanglement; NIOSH 0.4/0.5 mg/m³ TWA REL recommendation, **not** universal OSHA PEL. UK COSHH/LEV 14-month rule not US universal. **INFERENCE** separate motion, aerosol, fluid and service witnesses; **UNKNOWN** selected machine, MWF presence, exposure and physical stop/hold. 14 PUBLIC PAPER cases UNSCORED / 18 desk gates NOT RUN, no external score or compute, G0/G1 HOLD. Do not repeat this as a newly discovered mechanism in future sessions.

**Source-level follow-through:** [Pinned LinuxCNC M7/M8/M9 interpreter→canonical→Task→HAL trace](research/4400_MWF_LINUXCNC_PINNED_M7_M8_M9_COOLANT_HAL_OUTPUT_VS_EXPOSURE_SOURCE_TRACE_2026-10-27.md) **SOURCE-CONFIRMED** ordinary `iocontrol.0.coolant-mist/flood` HAL_OUT bits at `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7`; no pump/LEV/air-quality feedback in inspected output methods. M-code remap and actual HAL wiring unknown. No physical TEST-CONFIRMED claim or local/hosted compute.

**MWF source crosscut:** pinned Task abort/E-stop [source extension](research/4400_MWF_LINUXCNC_PINNED_M7_M8_M9_COOLANT_HAL_OUTPUT_VS_EXPOSURE_SOURCE_TRACE_2026-10-27.md) **SOURCE-CONFIRMED** normal coolant outputs cleared, making a potential **INFERENCE** residual-mist hazard if M8 drives LEV. Actual fan/energy policy is machine-specific, no live proof.


### 2026-10-27 — OPB-CUTOVER-02 retained Pilz input trust and physical gate delta (transfer/integration)
[Actual Rev 1 cross-repository source/config trace](research/4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_CROSS_REPOSITORY_SOURCE_AUDIT_2026-10-27.md) identifies six normal CNC→Pilz inputs (notably MUTE wire 44, CNC OK wire 45), seven Pilz status outputs, wire 75 hardware proportional inhibit, Pilz wire 63 direct X drive, three Pilz-owned hydraulic valves, switched 11K2 L7/L07 and unresolved X2/duplicated wire 111. **Prior art:** [brownfield retrofit source audit](research/4400_BROWNFIELD_CNC_RETROFIT_SAFETY_PLC_CUTOVER_AND_LOCKABLE_ISOLATION_AUDIT_2026-10-24.md), [FS-IF contract](hardware/SAFETY_BLOCK_INTERFACE_CONTRACTS.md), [G0 intake](safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md). This is a **new exact project endpoint evidence application**, not a new generic mechanism. [12 unsolved public cases/12 NOT RUN desk gates](safety-course/4400_OPB_CUTOVER_02_PILZ_MUTE_GATE_POWER_DOMAIN_FIELD_REVIEW_2026-10-27.md); [eight UNKNOWN restricted evidence deltas](safety-course/4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md). Published design statements SOURCE-CONFIRMED; installed Pilz program, mute qualification, physical hardware gate, stop/hold/pressure/restart UNKNOWN. No physical, runtime or blind evaluation; G0/G1 HOLD.


**OPB-CUTOVER-02 source precedence extension:** [direct current board integration audit](research/4400_OPB_CUTOVER_02_MAX22216_FOUR_INPUT_GATE_FANOUT_AND_STALE_AUTHORITY_RECONCILIATION_2026-10-27.md) establishes schema v3 four-input ordinary hardware permit, two MAX22216 ENABLE sinks, separate wire-75 diagnostic fanout, superseded circular `ENABLE_PATH_HEALTHY` fifth term, quarantined old netlist and safety-interface BEHAVIORAL ONLY status. This is **new exact implementation-source evidence**, not a new generic hazard or TEST-CONFIRMED gate. Field conditioning and installed physical response UNKNOWN; eight negative source-review cases NOT RUN.


### 2026-10-27 — AIR-CLEAN-01 OSHA cleaning air/nozzle dead-end and worker-exposure distinction
[Direct OSHA/EXAIR provenance audit](research/4400_AIR_CLEAN_01_OSHA_DEADEND_CHIP_GUARD_MWF_NOISE_SOURCE_AUDIT_2026-10-27.md), [12-case technician card](safety-course/4400_AIR_CLEAN_01_DEADEND_PRESSURE_CHIP_SHIELD_MIST_AND_RESTART_FIELD_MODULE_2026-10-27.md), [normal-control/physical-exposure crosscut](safety-course/4400_AIR_CLEAN_01_CLEANING_MODE_AUTHORITY_EXPOSURE_AND_REARM_CROSSCUT_2026-10-27.md). Complete canonical-index and plan scans found no predecessor on **cleaning-nozzle blocked-outlet pressure**; PNEU-EXH, HOSE_ROUTE, MWF, noise and LOTO remain separate existing lessons. DOC-CONFIRMED US cleaning rule and directive; vendor noise/OSHA approval claims are not machine proof. Twelve public cases UNSCORED, 12 gates NOT RUN, no actual OpenPressBrake air-cleaning configuration asserted; G0/G1 HOLD, no tests/compute.


**AIR-CLEAN-01 source continuation:** [Direct original pinned LinuxCNC M62/M63 queued OFF transfer](research/4400_AIR_CLEAN_01_LINUXCNC_PINNED_M62_M63_QUEUED_AIR_OUTPUT_SOURCE_TRACE_2026-10-27.md) and [OSHA 1994/2011/2015 field/source delta](research/4400_AIR_CLEAN_01_OSHA_FIELD_ENFORCEMENT_AND_BODY_CLEANING_DELTA_2026-10-27.md). Novelty: new application of pre-existing M-code source behavior to cleaning-air end-of-motion sequencing; no re-teaching as a new M-code discovery. No selected-machine test or compute.


### 2026-10-27 — SOLVENT-CLEAN-01 cleaning vapor/ignition source delta
Full canonical index and research-plan synonym scan found no dedicated solvent/degreasing/flammable cleaning vapor mechanism. [Original OSHA 1910.106/HSE/Massachusetts audit](research/4400_SOLVENT_CLEAN_01_OSHA_HSE_AQUEOUS_IGNITION_VAPOR_SOURCE_AUDIT_2026-10-27.md) → [8-case public technician module](safety-course/4400_SOLVENT_CLEAN_01_CHEMICAL_VAPOR_IGNITION_AND_RESTART_FIELD_MODULE_2026-10-27.md). Scope-limited official documentation, no universal ventilation/LEL/flashpoint or fan-stop sequence. All public cases UNSCORED, 10 desk gates NOT RUN, actual machine UNKNOWN; G0/G1 HOLD, no compute.


**CLEAN-COMPOSE-01:** [Crosscut of AIR-CLEAN, SOLVENT-CLEAN, MWF and pinned M62/M63](safety-course/4400_CLEAN_COMPOSE_01_AIR_SOLVENT_MIST_IGNITION_QUEUED_OUTPUT_AND_REARM_CROSSCUT_2026-10-27.md), with OSHA shipyard fine-mist and HSE vapor-degreasing sources kept in exact jurisdiction/equipment scope. No universal flammable threshold, fan policy or physical proof. No new formal cases/gates, G0/G1 HOLD.


### 2026-10-27 — AKAS-M-01 source/variant delta: LC-II M external safety PLC and actual muting authority
[Exact Fiessler 2011/2014 LC-II M, Pilz conveyor-mut­ing non-equivalence, and OpenPressBrake wire-44/wire-402 source audit](research/4400_AKAS_LCII_M_PILZ_MUTING_SLOW_SPEED_OVERTRAVEL_AUTHORITY_AUDIT_2026-10-27.md); [one-pass existing OPB-D02 restricted review](safety-course/4400_AKAS_M_01_RESTRICTED_PILZ_MUTING_OVERRUN_EVIDENCE_DELTA_2026-10-27.md). Existing muting/AKAS/OPB-CUTOVER predecessors already teach the generic boundary; **incremental** is the actual LC-II M FUS/FUO/SGS/SGO/SP/OSSD1/2 safety-PLC allocation, short-circuit monitoring, qualified fast-to-slow transition and manufacturer-specific overrun responsibility. Distinguish M 30-h example from F-family 24-h example, and do not transfer any 10-mm/<10-mm/s manual example to the unverified installed machine. No new paper cases, documentary gates or physical proof; external evaluator NOT RUN, G0/G1 HOLD.


### 2026-10-27 — AKAS-SENSE-02 F-only AMS3 original manual and selected-machine speed-source non-equivalence
[Direct Fiessler 2019 original AMS3/F document 1338 pp.1,4–6,11 and exact OpenPressBrake ATEK-to-FPGA source reconciliation](research/4400_AKAS_AMS3_F_ONLY_VS_M_SAFETY_Y1_Y2_ENCODER_AUTHORITY_SOURCE_DELTA_2026-10-27.md) plus [source-identity field card](safety-course/4400_AKAS_SENSE_02_FAMILY_MATCH_AND_INDEPENDENT_SPEED_WITNESS_REVIEW_CARD_2026-10-27.md). Prior AKAS-M-01/MON-01/OPB-CUTOVER already establish generic independent safety authority; new **exact variant/configuration evidence** is AMS3 **F-family** only, two magnetic-tape sensor paths, optional/required `SP_IN`, overrun-check on/off with mandatory alternate safe owner, and F-vs-M 24h/30h edition traps. Ordinary ATEK dual-axis position/velocity on FPGA is **not automatically safety-rated**. No AMS3/M compatibility, installed sensor or safety PLC program asserted. Restricted Stage A/OPB-D02 existing packet reused; no new public paper cases, gates, tests or score. G0/G1 HOLD; no compute.

**AKAS-SENSE-02 source-depth addendum:** original Fiessler 2019 AMS3/F p.7 labels 24-V magnetic-sensor supply, whereas the public Rev 1 ordinary ATEK connector map labels protected 5-V supply. Similar quadrature names do not establish compatible sensor power or independent safety integrity. Source-design crosscheck only; actual installed sensor/connector UNKNOWN.


### 2026-10-27T08:32:56Z — 4400-M66-01 and PAUSE-01 normal control sequencing cannot authorize access
[Development/stable M66 source audit](research/4400_LINUXCNC_M66_WAIT_TIMEOUT_AND_NONSAFETY_INPUT_AUTHORITY_AUDIT_2026-10-27.md) + [technician review](safety-course/4400_M66_01_PROGRAM_WAIT_TIMEOUT_AND_PHYSICAL_INTERLOCK_REVIEW_CARD_2026-10-27.md): SOURCE-CONFIRMED M66 interpreter/canonical/Task/HAL status chain, L1 edge vs L3 level, #5399=-1 on timeout without automatic program abort, current status sample after Task wait. DOC-CONFIRMED LinuxCNC non-realtime warning. [M0/M1 default pause source audit](research/4400_LINUXCNC_M0_M1_PAUSE_RESUME_VS_SAFE_ACCESS_SOURCE_AUDIT_2026-10-27.md) + [operator card](safety-course/4400_PAUSE_01_NORMAL_PAUSE_VS_SAFE_ACCESS_OPERATOR_REVIEW_CARD_2026-10-27.md): M0/M1 normal trajectory pause, M1 optional, normal resume; no explicit spindle/coolant OFF in M0/M1 interpreter branch; M2/M30 contrast. Predecessor index already covers E-stop, M62/M63, M6, HAL and safe access; **incremental exact M66/M0 source mechanisms**, not a new independent safety architecture. Four original artifacts, no additional unscored bank, no new gates, TEST-CONFIRMED none, physical selected-machine UNKNOWN. 1000–3000 closed; 2520–25F0 evaluator OPEN; G0/G1 HOLD. No Actions/hosted/local compute.


**Same-session FEED-JOG-01:** [Pinned development/stable normal-motion source audit](research/4400_LINUXCNC_FEED_HOLD_INHIBIT_JOG_STOP_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-27.md) and [four-input review](safety-course/4400_FEED_JOG_01_NORMAL_MOTION_HOLD_VS_INDEPENDENT_STOP_REVIEW_CARD_2026-10-27.md). **SOURCE/DOC-CONFIRMED:** M53 gates `motion.feed-hold`; the manual says feed-hold/feed-inhibit are G-code-only **but pinned joint wheel-jog source checks `net_feed_scale`** (already found in SET-01); spindle-synchronized move may complete before feed-inhibit takes effect; jog-inhibit rejects new jogs but separate jog-stop handles active jog, immediate variant risks following errors. No independent safety function, no new graded or unscored bank, no physical/evaluator evidence, no compute. G0/G1 HOLD.


**FEED-JOG predecessor audit correction:** [Existing SET-01 source trace](research/4400_LINUXCNC_FEED_INHIBIT_JOG_DOCUMENTATION_VERSION_DRIFT_2026-10-24.md) already contains the wheel-jog `net_feed_scale` exception and version drift; [2026-10-27 correction](research/4400_FEED_JOG_01_PREDECESSOR_AND_WHEEL_JOG_SOURCE_CORRECTION_2026-10-27.md) records the overlap. New delta M53/homing/stable source only. No tests or machine safety credit.


**COMPOSE-02 and TP source delta:** [M66 + M0/M1 + feed/jog integrated false-safe-access review](safety-course/4400_NORMAL_SEQUENCE_WAIT_PAUSE_JOG_FALSE_SAFE_ACCESS_COMPOSITION_REVIEW_2026-10-27.md) is a documentary adversarial **INFERENCE**, not selected-machine failure. [FEED-JOG exact TP source addendum](research/4400_LINUXCNC_FEED_HOLD_INHIBIT_JOG_STOP_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-27.md) traces `tpGetFeedScale` TC_SYNC_POSITION exception to normal feed-inhibit, upgrading OEM/doc statement to SOURCE-CONFIRMED implementation at pinned development SHA. [M66 sample addendum](research/4400_LINUXCNC_M66_WAIT_TIMEOUT_AND_NONSAFETY_INPUT_AUTHORITY_AUDIT_2026-10-27.md) documents timeout-only upstream simulation checks and hypothetical post-wait value change. No test, score, extra paper bank, physical proof or compute; G0/G1 HOLD.


### 2026-10-27 — OPB-ISO-03 exact isolator supply-loss and fault-label source delta
[Direct STISO621 DS13394 Rev5 / STISO620 DS14110 Rev3 / IPS1025H DS13780 Rev7 and OpenPressBrake source audit](research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md) plus [practical reviewer card](safety-course/4400_OPB_ISO_03_SWITCHED_FIELD_POWER_AND_DIAGNOSTIC_VALIDITY_REVIEW_CARD_2026-10-27.md). Predecessor SNEAK-CUR-02 and OUT-01 already cover leakage/backfeed; OPB-CUTOVER-02 already covers 11K2/L7/L07. **New exact evidence:** a powered STISO620 FPGA receiver can drive LOW after its field transmitter loses supply, so fault LOW may mean invalid data; STISO621 process receiver is UNKNOWN while unpowered; IPS1025H VCC/GND disconnect differ; Rev1 FLT1/FLT2 labels conflict with manufacturer and newer manifest. Physical witness added: qualified revision-matched process-power-valid/diagnostic-polarity and source-to-sink netlist reconciliation under existing restricted OPB-D06/D08, **not** a new generic safety function. No test, evaluator, score, hosted/local compute or selected-machine release; G0/G1 HOLD.

**OPB-ISO-03 direct ST reference schematic crosscheck:** [Original March 2025 X-NUCLEO-ISO1A1 schematic](https://www.st.com/resource/en/schematic_pack/x-nucleo-iso1a1-schematic.pdf) confirms STISO621 carries logic→field command **and** field→logic FLT1. When field side loses power but logic remains powered, **both** FLT1/STISO621 and FLT2/STISO620 can become LOW after separate watchdog timeouts; a LOW is not automatically healthy. Field-side command RX is unpowered/UNKNOWN. [Source audit addendum](research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md). No physical validation.

**OPB-ISO-03 further original manufacturer evidence:** TI ISO1212 Rev G Table 7-2 (https://www.ti.com/lit/ds/symlink/iso1212.pdf) shows an open field input gives ordinary LOW; TI TIDA-01509 (https://www.ti.com/tool/TIDA-01509) adds hardware for broken-wire detection. Published OpenPressBrake optional `INPUT_VALID` and lack of explicitly named rail-valid DI do not prove any installed wire-break witness. Conditional held ordinary command can also propagate after switched L7 return; independent restart proof still required. [Exact source audit](research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md). No physical validation.

**OPB-ISO-03 source-depth single-pole failure matrix:** [Original audit](research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md) distinguishes L7-positive welded/return-open from L07-return welded/positive-open in the public two-pole 11K2 source, using exact ST IPS1025H ground/VCC-disconnection behavior. Contact/EDM and actual hydraulic load-hold remain UNKNOWN; existing restricted D06 updated, no simulation or physical fault injection.

**OPB-ISO-03 original manufacturer transfer check:** TI TIDA-01509 Rev A https://www.ti.com/lit/ug/tidudi9/tidudi9.pdf uses an added opto-emulator to intentionally open ISO121x field ground for wire-break pulses; this cannot be copied into shared L07/Pilz without qualified safety design. ST IPS1025H FLT clamp vs STISO621 input max creates an **unresolved worst-case pin-rating question**, not a measured defect. Three-valued ordinary status model in [review card](safety-course/4400_OPB_ISO_03_SWITCHED_FIELD_POWER_AND_DIAGNOSTIC_VALIDITY_REVIEW_CARD_2026-10-27.md). [Exact source audit](research/4400_OPB_L7_L07_ISOLATOR_POWER_LOSS_FAULT_DIAGNOSTIC_POLARITY_SOURCE_AUDIT_2026-10-27.md). G0/G1 HOLD.


### 2026-10-27 — SAFE-PROGRAM-04 active program, real safety-controller example and feedback provenance
[Source/precedessor audit](research/4400_SAFETY_PROGRAM_IDENTITY_FPSC_EXAMPLE_PILZ_CRC_VALVE_FEEDBACK_AND_BACKFEED_SOURCE_REVIEW_2026-10-27.md) and [review card](safety-course/4400_SAFE_PROGRAM_04_ACTIVE_PROJECT_AND_FINAL_ELEMENT_EVIDENCE_REVIEW_CARD_2026-10-27.md). Full canonical index, plan, historical PROGRESS and closest 2530/2540/AKAS/OPB/pedal predecessors compared: **new exact real-implementation transfer**, not new generic safety function. 2006 Fiessler FPSC bending-press example was available only as a third-party manual transcription (COMMUNITY-REPORTED): program readback/shutdown table, valve-rest feedback, CNC/AKAS interface and possible receiver-off FUO/FUS backfeed. Direct original Pilz PNOZ m B0 `1002660-EN-13` supports project CRC/name/date, device identity, external feedback and mandatory function check after program/chip-card changes (DOC-CONFIRMED **B0 only**). Public OpenPressBrake Rev1 wire-44 MUTE/wire-45 CNC OK (SOURCE-CONFIRMED design) cannot establish actual Pilz logic. **Incremental physical witness:** revision-matched *active installed* safety-program identity plus qualified final-element feedback/physical stop-hold/guard/rearm evidence, already requested by restricted D01/D02/D03/D06/D08. No new questionnaire, scored/unscored bank, test, evaluator or compute. G0/G1 HOLD.


### 2026-10-27 — SAFE-PROGRAM-05 Pilz version/privilege evidence-collection hazard
[Exact Pilz original FAQ/version and OpenPressBrake public-source review](research/4400_PNOZMULTI_CLASSIC_V10_VS_PNOZMULTI2_V11_READ_ONLY_EVIDENCE_ACQUISITION_AUDIT_2026-10-27.md) with [one-pass field card](safety-course/4400_SAFE_PROGRAM_05_PILZ_TOOLCHAIN_READ_ONLY_ACQUISITION_FIELD_CARD_2026-10-27.md). The **increment** over SAFE-PROGRAM-04 is compatibility and authority: **v10.14 LTS Classic/Mini**, **v11 PNOZmulti 2**, **Level 2 view-only**, and the difference between passive documentary review and potentially changing a live safety application. Classic/Mini discontinuation end-2024 is manufacturer documented. Existing D01 owns any private active-program readback; no new intake, unscored cases, physical test, evaluator or compute. G0/G1 HOLD.


### 2026-10-27 — WELD-GAS-01 gas-shielded welding: physical gas/atmosphere after normal arc stop
[Original HSE/eCFR/NIOSH source and exact-scope audit](research/4400_WELD_GAS_01_SHIELDING_GAS_OXYGEN_DEFICIENCY_SCREEN_VENTILATION_AND_RESCUE_SOURCE_AUDIT_2026-10-27.md) → [one-pass reviewer card](safety-course/4400_WELD_GAS_01_SHIELD_PURGE_GAS_OXYGEN_DEFICIENCY_AND_SAFE_ACCESS_FIELD_CARD_2026-10-27.md). Index/plan/progress predecessor comparison found no gas-displacement entry module; MWF/LASER-AIR/DUST/SOLVENT are adjacent but distinct. **DOC-CONFIRMED direct** HSE shield/purge gas into weldment, pit and adjacent space, NIOSH FACE 88-20 fatal argon investigation, eCFR §1910.252 ventilation/arc screens/fire watch. **DOC-CONFIRMED indexed-only** OSHA §1910.146 permit-space oxygen definition and Miller manufacturer precautions (PDF 404 on direct open). **INFERENCE** independent gas supply isolation, atmosphere/entry, ventilation/fire, motion/arc guard, rescue and fresh-start architecture; no universal fan stop or clearance time. Selected gas/cell absent from evidence; no new public paper banks, no tests, no evaluator, no compute; OpenPressBrake G0/G1 HOLD.


**Same-session WELD-RETURN-02 source-depth rotation:** [eCFR §1910.254 + Miller exact work-lead/grounding audit](research/4400_WELD_RETURN_02_OSHA_MILLER_WORK_LEAD_PROTECTIVE_GROUND_CRANE_RETURN_AND_ELECTRICAL_ISOLATION_AUDIT_2026-10-27.md) → [one-pass technician card](safety-course/4400_WELD_RETURN_02_WORK_CLAMP_PROTECTIVE_EARTH_CRANE_AND_POWER_ISOLATION_REVIEW_CARD_2026-10-27.md). Distinct welding high-current return hazard: OSHA explicitly forbids crane/hoist/chain/wire-rope current paths, requires bonding/current collection for deliberately used fixtures, and separately requires machine grounding. **DOC-CONFIRMED direct** eCFR and Miller; **INFERENCE** loose-clamp alternate path, actual machine UNKNOWN. Also strengthened WELD-GAS-01 with HSE remote full-volume atmosphere sampling/head-only-entry and NIOSH FACE 91-14 residual argon retrieval fatality. No new scored cases, tests, compute or selected-machine release.


### 2026-10-27 — OXYFUEL-01 backflow, flashback and CNC gas-control boundary
[Original exact source and scope audit](research/4400_OXYFUEL_01_BACKFLOW_FLASHBACK_ARRESTOR_CNC_GAS_ISOLATION_SCOPE_SOURCE_AUDIT_2026-10-27.md) → [field reviewer](safety-course/4400_OXYFUEL_01_BACKFLOW_FLASHBACK_AND_GAS_ISOLATION_REVIEW_CARD_2026-10-27.md). Complete index/plan/progress synonym scan found no existing oxy-fuel/flashback mechanism; predecessor WELD-GAS/RETURN compared. **DOC-CONFIRMED direct** eCFR §1910.253 backflow/flashback/backpressure distinctions for piping and explicit machine exclusion at (e)(4)(viii), HSE both-gas arrestor/maintenance guidance, ESAB/Victor check vs flame arrestor, and actual ESAB Combirex PRO process-proportional gas control / MT204 check-valve products. **COMMUNITY-REPORTED** C-69/C-70 external valve-block transcription, not original OEM PDF. **INFERENCE:** ordinary torch OFF may conceal stuck/leaking valve or trapped gas; no selected incident, physical test or rated safety function established. Incremental selected-machine witnesses OF-1..5: topology, two-gas protection, actual isolation, authority and qualified physical evidence; all UNKNOWN/NOT RUN. No unscored case bank, evaluator, hosted/local compute or G0 release. OpenPressBrake oxy-fuel applicability UNKNOWN.


### 2026-10-27 — OXY-COMPAT-02 oxygen ignition/contamination beyond flashback
[Direct NASA/OSHA/HSE original-source audit](research/4400_OXY_COMPAT_02_OXYGEN_SERVICE_MATERIAL_IGNITION_CONTAMINATION_AND_CNC_GAS_VALVE_SOURCE_AUDIT_2026-10-27.md) → [one-pass field review](safety-course/4400_OXY_COMPAT_02_OXYGEN_WETTED_VALVE_REPLACEMENT_AND_CONTAMINATION_FIELD_CARD_2026-10-27.md). Full canonical index/plan/progress predecessor search found no oxygen cleanliness/adiabatic/grease/oxygen-service module before this branch; OXYFUEL-01 mentions no-oil caution but not ignition/kindling/materials qualification. **DOC-CONFIRMED direct** NASA WSTF 2016 worst-case oxygen compatibility, material flammability/ignition/kindling; NASA 1996 TM **abstract only**, eCFR §1910.253(d)(3) oxygen-piping cleaning/oil-free, HSE no grease/oil on oxygen fittings. **INFERENCE** generic process-valve substitution can introduce oxygen-wetted ignition risk despite normal CNC signals. OX-1..4 selected physical/maintenance witnesses UNKNOWN/NOT RUN; no new case bank, evaluator, physical test, hosted/local compute or G0 release.


### 2026-10-27 — OPB-INTERFACE-04: new coil-resource contract vs contact and safety authority
[Original exact source and OEM audit](research/4400_OPB_RELAY_COIL_VS_DRY_CONTACT_VS_PILZ_FINAL_ELEMENT_CROSS_REPO_AUTHORITY_AUDIT_2026-10-27.md) → [one-pass technician discriminator](safety-course/4400_OPB_INTERFACE_04_COIL_DRIVER_DRY_CONTACT_SAFETY_AUTHORITY_FIELD_CARD_2026-10-27.md). Direct full index/plan/progress predecessor comparison: OPB-CUTOVER-02 already teaches six normal Pilz commands, OPB-ISO-03 power-invalid diagnostics, MIRROR-01 feedback and SAFE-PROGRAM-04 installed program. **Incremental source-specific interface allocation**, not new safety function: OpenPressBrake **2026-09-24** commit `92cf5424be90f45f664ba2652dc725b38e1895f9` added a `relay_contactor_driver` 3-GPIO/2-field-terminal **external coil** resource, no safety credit, unresolved field and logic current budgets. Its source-mapped Rev1 machine allocation remains six Pilz operational DO + two X-direction DO using isolated `digital_output_24v`, seven Pilz DI + X index; no relay-driver instance allocated in inspected map. `dry_contact_relay_output` ordinary Omron G5Q SPDT is NOT READY and not a safety relay; direct original G5Q OEM PDF distinguishes NO/NC ratings and initial 5-ms release from physical safety stopping, while its local diode differs from IPS1025H active demagnetization. Pilz general feedback loop does not prove installed contactor or ram holding.  **Same-session exact diagnostic-source addendum:** non-isolated relay-driver production netlist and TI LM393LV Rev D show active-HIGH open-drain comparator fault outputs pulled up to the same LOGIC_3V3 rail; comparator POR is high-Z, and missing field/logic power cannot be interpreted as a healthy contactor from FAULT=0. Static nominal 0.206-V reference / ~0.647-V FLT sense crossing is INFERENCE, not a validated trip threshold. No new lab or safety credit. No new questionnaire, public case bank, test, evaluator or compute; private Stage A C/D/F/G and OPB-D01/D06/D08 remain the only selected-machine intake; G0/G1 HOLD.

### 2026-10-27 — WATERJET-01 / WATERJET-TANK-02: pressure/medical versus wet reactive-metal hydrogen
[Waterjet original source audit](research/4400_WATERJET_01_HIGH_PRESSURE_BLEED_INTERLOCK_AND_INJECTION_SOURCE_AUDIT_2026-10-27.md) and [reviewer](safety-course/4400_WATERJET_01_JET_STOP_VS_PRESSURE_ZERO_FIELD_REVIEW_2026-10-27.md) establish a **new exact OEM/physical witness** distinct from general hydraulic injection: ProtoMAX lid interlock and VFD fault handling do not establish UHP zero pressure, ProtoMAX maintenance requires manufacturer-specific pressure release, and Flow HyperJet's advertised one-second bleed is product-specific. WJTA's original injury alert treats tiny external wounds as potentially severe. [Distinct catcher-tank hydrogen audit](research/4400_WATERJET_TANK_02_ALUMINUM_HYDROGEN_SLUDGE_SPARK_IGNITION_SOURCE_AUDIT_2026-10-27.md) and [field card](safety-course/4400_WATERJET_TANK_02_ALUMINUM_HYDROGEN_MATERIAL_CHANGE_FIELD_CARD_2026-10-27.md) document original ProtoMAX aluminum-water hydrogen/sludge/possible titanium-spark ignition warnings; OSHA wet-collector incidents are explicitly **not waterjet incidents**. DUST-01..05 and HOSE-ROUTE/PANEL/M66 predecessor mechanisms preserved. No selected waterjet, machine pressure proof, gas measurement, evaluator, case bank or compute. 4400 cross-machine safety only; 3300 stays CLOSED. OpenPressBrake G0/G1 HOLD.

**WATERJET-01 source-depth continuation:** Direct WJTA 2022 high-pressure coupling alert distinguishes accidentally disconnectable non-threaded push-to-connect from screw/face-seal options; its cited §13.5 belongs to the **2021 second edition**, not the uninspected 2026 third edition. Separate WJTA manual-lancing nozzle-change puncture is a **COMMUNITY-REPORTED different-machine incident**; only geometry/change-management transfers. Exact installed coupling, pressure rating and retention UNKNOWN. See [updated original audit](research/4400_WATERJET_01_HIGH_PRESSURE_BLEED_INTERLOCK_AND_INJECTION_SOURCE_AUDIT_2026-10-27.md).


### 2026-10-27T16:38Z — AUTODOOR-01 powered CNC guard pinch and safeguard-substitution change control
[Original manufacturer-source audit](research/4400_AUTODOOR_01_HAAS_CNC_POWERED_DOOR_EDGE_CURRENT_FENCE_REMOVAL_SOURCE_AUDIT_2026-10-27.md) → [practical review](safety-course/4400_AUTODOOR_01_MOVING_GUARD_EDGE_AND_FENCE_REMOVAL_REVIEW_CARD_2026-10-27.md). Canonical guard/robot/laser/restart/M66 predecessors address guard access and normal-control boundaries but do not address the exact **moving door edge** or Haas **fenced-robot removal** edge-sensor dependency. **DOC-CONFIRMED direct OEM:** Haas AD0583 Rev C (06/2026) edge input 128 and configuration patch; HRP-3 VMC installation states certain HE Autodoor robot/APL machines lack edge sensor while fence is present and require one for operation without fenced automation; Setting 131 closes door at Cycle Start. TG0044 Rev E (09/2026) CAN current/reversal and 250-ms internal overcurrent condition directly inspected in original manufacturer-hosted legacy English combined service manual (modern single-article URL redirected); same manual TG0019 8M uses friction wheel/close-switch/timer and P1405 motor hold rather than CAN current-reversal sequence; 250 ms is NOT a certified door response. **DOC-CONFIRMED** OSHA 1910.212 guarding scope indexed and OSHA eTool; LinuxCNC M62–M65 ordinary output semantics. **INFERENCE:** door-close pinch SF, enclosure interlock SF, robot-cell occupancy and fresh restart are distinct. **UNKNOWN/NOT RUN:** exact installed machine/door/edge safety category, faults, stop force/distance, personnel-safe state, external evaluator. No OpenPressBrake Autodoor asserted; G0/G1 HOLD, no compute.

**AUTODOOR-01 independent manufacturer architecture depth:** Original Schmersal SE-400 C 101153920 catalogue specifies monitored safety-edge chain, diagnostic functions, feedback and reset, but module 32-ms reaction and up-to-PL-e are product claims, not machine safe stop. SE-100 C 101153919 is up-to-PL-c/Category 1 despite common SE40/70 edge family; SE-P40 manufacturer profile warns approximately 60 mm end zones with no guaranteed finger protection. This adds exact evaluator-substitution and mechanical blind-zone counterexamples; no compatibility with Haas/OPB inferred. See updated original AUTODOOR-01 audit.

### 2026-10-27 — 4400-WINDOW-01 ageing of passive CNC viewing-window projectile barrier
[Original manufacturer/publisher scope audit](research/4400_WINDOW_01_POLYCARBONATE_GUARD_WINDOW_AGEING_RETENTION_AND_REPLACEMENT_OEM_AUDIT_2026-10-27.md) → [one-pass technician reviewer](safety-course/4400_WINDOW_01_AGED_VIEWING_WINDOW_PROJECTILE_CONTAINMENT_REVIEW_CARD_2026-10-27.md). Full index/plan/progress semantic predecessor review (ABRASIVE wheel burst, GUARD access, AUTODOOR pinch, LASER optical viewing) found no prior **coolant/cleaner-driven invisible polycarbonate embrittlement, laminate edge-seal ingress, service-life and frame retention** witness. STUDER/UNITED GRINDING direct OEM source supports model-family two-year replacement and earlier replacement after damage/ingress; SICURTEC original product guidance distinguishes protected glass/polycarbonate laminates and immediate replacement for bulge/leak/coolant between layers. ISO 16089:2025 and ISO 23125:2015 publisher edition/scope directly checked; normative clauses not inspected; Haas 2012 original PDF only manufacturer-indexed excerpt due size. **INFERENCE** healthy interlock or optical clarity cannot certify projectile containment; physical pane/frame/process/chemical/age/CHG WIN-1..6 remain UNKNOWN/NOT RUN. No public unscored bank, evaluator, physical test, hosted/local compute; G0/G1 HOLD.

**Primary independent DGUV depth:** IFA 5169 2022-status project says manufacturer/construction/coolant-dependent window replacement intervals 2–12 years and reports one-year serious retention loss under investigation (causation unresolved); BIA 6054 1997 100-g impact test distinguishes PMMA/acrylic from ductile polycarbonate but its test numbers cannot be selected-machine ratings. ISO 16090-1:2022 machining-centre publisher scope added. Source provenance in updated WINDOW-01 audit.


### 2026-10-27 — 4400-METAL-01 magnesium-specific coolant/fire compatibility (NON-GRADUATED)
[Original Luxfer/DGUV/OSHA/CSB/NFPA primary source audit](research/4400_METAL_01_MAGNESIUM_CNC_COOLANT_HYDROGEN_CLASS_D_AND_CHIP_HANDLING_SOURCE_AUDIT_2026-10-27.md) → [technician material-change card](safety-course/4400_METAL_01_MAGNESIUM_MATERIAL_CHANGE_COOLANT_FIRE_AND_SCRAP_FIELD_CARD_2026-10-27.md). Predecessor DUST-01..05 already teaches dust/collector propagation, WATERJET-TANK-02 aluminum-water hydrogen, MWF mist. **Increment:** qualified magnesium dry or engineered wet/inhibited coolant selection, whole-circuit hydrogen management, swarf size/storage and metal-specific fire agent. Direct Luxfer/DGUV original guidance; OSHA §1910.157(d)(6)/Appendix A indexed-only; CSB Hayes Lemmerz original incident is aluminum, not magnesium; NFPA 660 publisher scope only. No blanket water-coolant ban and no permission to spray burning magnesium. MET-1..7 selected-machine witnesses UNKNOWN, no physical tests, evaluator, case bank or compute; G0/G1 HOLD. [Next checkpoint](checkpoints/2026-10-27T183406Z-4400-magnesium-material-change-physical-evaluator-next.md).

**METAL-01 FB HM-051 addendum:** Original DGUV 08/2014 dry-magnesium-grinding sheet adds dust-covered clothing and secondary tool spark, approved cleaning/extraction, and vented wet-sludge storage; **MET-8** conditional witness, no universal machining inference. See METAL-01 original audit.


### 2026-10-27T19:39Z — EMC-01 selected safety wiring/drive installation is a physical safety dependency
[Original Pilz/SICK/VACON/IEC audit](research/4400_EMC_01_PILZ_SICK_VACON_SAFETY_WIRING_COUPLING_AND_INSTALLATION_SOURCE_AUDIT_2026-10-27.md) and [unscored field card](safety-course/4400_EMC_01_SAFETY_SIGNAL_CABLE_ROUTING_AND_EMC_CHANGE_FIELD_CARD_2026-10-27.md) compare PWR-01, BOND-01, dependency/CCF and BD63 predecessors. **Increment:** direct manufacturer routing/test-pulse multicore prohibition, OSSD independence and connector/0 V conditions, drive-specific cable spacing and safe commissioning/change witness; no generic new grounding claim. Pilz 1002265-EN-02 §5.1 prohibits unprotected test-pulse/actuator multicore; SICK deTec4 8021645/1SWC/2026-02-04 §§4.4/6 warns about M12 misconnection and selected 0 V/load topology; VACON 100 DPD01666B 2015 §5.3 gives different 0.3/1.0 m shielded-motor spacing. IEC 61000-6-7/61326-3-1 publisher scope only. No machine-specific cable/drive/controller identified, no tests/evaluator/compute, G0/G1 HOLD. [Next checkpoint](checkpoints/2026-10-27T193935Z-4400-emc-cable-separation-physical-evaluator-next.md).

### 2026-10-27T20:39Z — FIRE-SUP-01 autonomous CNC fire-system discharge versus machine stop, impairment and re-entry
[Original Firetrace/OSHA/HSE audit](research/4400_FIRE_SUP_01_CNC_AUTOMATIC_SUPPRESSION_PRESSURE_SWITCH_BYPASS_AGENT_REENTRY_SCOPE_AUDIT_2026-10-27.md) → [field review](safety-course/4400_FIRE_SUP_01_CNC_SUPPRESSION_DISCHARGED_IMPAIRED_RESTART_FIELD_CARD_2026-10-27.md). Predecessors WELD-GAS, METAL-01, DUST, MWF and ALARM-NOISE cover adjacent gas, fire, extraction and warning hazards, but **not** the distinct discharged/IMPAIRED suppressor state and optional pressure-switch restart bypass. Firetrace direct OEM describes power-independent pneumatic detection/release and optional CNC/oil-pump/mist-collector stop; two manufacturer-published customer stories report opposite pressure-switch bypass decisions (**COMMUNITY-REPORTED**, not independent validation). OSHA 1910.160(a)(2) has a restricted scope for optional employee-exposing fixed systems; 1910.162 total-flooding clauses do not automatically transfer to local machine systems. HSE CO2 hazards are CO2-specific. New conditional FS-1..6 witnesses: exact agent/fire/exposure, physical detector/discharge coverage, shutdown authority, impairment/bypass prevention, selected commissioning, atmosphere/re-entry/fresh restart. All UNKNOWN/NOT RUN. No selected OpenPressBrake suppression asserted; G0/G1 HOLD; no physical tests, unscored case bank, evaluator or compute.
**FIRE-SUP-01 OEM depth:** Firetrace original DIOM 800095-A Rev A **2022-07-22**, newly inspected 2026-10-27, directly documents keyed and non-keyed pressure-switch variants, 16 keyed contact behaviors (including bypass activation/force service) and distributor consultation after discharge. A manufacturer-provided service bypass is not automatically a defect; operating production without qualified protection still requires separate authority and evidence. The conditional FS-3/4 witness now includes exact module/configuration, key-control and separate service/IMPAIRED path. Older 2020 TB041 wiring is a different variant. [Source addendum](research/4400_FIRE_SUP_01_CNC_AUTOMATIC_SUPPRESSION_PRESSURE_SWITCH_BYPASS_AGENT_REENTRY_SCOPE_AUDIT_2026-10-27.md).

**FIRE-SUP-01 original system-manual depth:** Firetrace 800022-010 (2016-07-27) expressly describes a **total-flooding** HFC-227ea system for normally unoccupied CNC-capable enclosures, requires opening closure/ventilation shutdown for that family, excludes Mg/Ti/Zr reactive-metal fires and separates cylinder from tube pressure gauges. It is wrong to call every machine-object system non-total-flooding; exact installed agent/space and OSHA exposure scope must be established. [Research addendum](research/4400_FIRE_SUP_01_CNC_AUTOMATIC_SUPPRESSION_PRESSURE_SWITCH_BYPASS_AGENT_REENTRY_SCOPE_AUDIT_2026-10-27.md).

### 2026-10-27 — CHIP-03 exact firmware/door-open conveyor restart fault, not duplicate CHIP-01
[Haas original service-manual source delta](research/4400_CHIP_03_HAAS_CONVEYOR_DOOR_OPEN_AUTO_START_SOFTWARE_REVISION_OEM_SOURCE_DELTA_2026-10-27.md) reconciles existing CHIP-01/02 periodic restart/overload/M-code work with an **unexamined OEM software-version failure path**. Haas troubleshooting explicitly associates 100.17.000.1016 with auger/conveyor starting without operator action **even with doors open**, recommends 100.17.000.2030+, and distinguishes Classic Haas manual door-open restart from NGC updated after 2018-10-10. A separate pre-fix M31 re-triggered timer defect is distinct from normal Settings 114/115 periodic cycling. **DOC-CONFIRMED OEM** only, not observed machine defect; exact product, firmware, final element and physical no-restart proof **UNKNOWN**. No new unscored case bank, no test/evaluator/hosted/local compute, G0/G1 HOLD.

### 2026-10-27T22:33Z — TSC/TAB-01 cross-media coolant/air fault and service-pressure boundary
[Original TG0145 Rev C (2025-10) and AD0086 (updated 2020-10) source audit](research/4400_TSC_TAB_01_HAAS_COOLANT_AIR_CHECK_VALVE_BACKFLOW_PRESSURE_WITNESS_SOURCE_AUDIT_2026-10-27.md) → [field card](safety-course/4400_TSC_TAB_01_COOLANT_AIR_BACKFLOW_AND_PRESSURE_SERVICE_FIELD_CARD_2026-10-27.md). Predecessors HYD-INJ, ATC, WJ, AIR-CLEAN, CHIP already teach generic injection, tool retention, trapped pressure, normal M-code and restart; **increment** is OEM-specific **two-way** TAB/TSC check-valve cross-contamination, spring/ball versus shuttle/ball, sensor pressure tap and firmware/build applicability. Pressure green or pump OFF cannot prove check direction, tool-tip flow or every service zone depressurized. No machine identified, TSC-1..6 UNKNOWN, physical/evaluator NOT RUN, no hosted/local compute, G0/G1 HOLD. [Next checkpoint](checkpoints/2026-10-27T223347Z-4400-tsc-tab-cross-media-physical-evaluator-next.md).

**Exact LinuxCNC M-code collision and M6 source correction (2026-10-27):** LinuxCNC's [stable M-code manual](https://www.linuxcnc.org/docs/stable/html/nb/gcode/m-code.html) explicitly defines **M73 as save-and-autorestore modal state**, while Haas TG0145 uses **M73 to start TAB** and **M74 to stop TAB**. Thus M73 is **not absent** in LinuxCNC; it is a dangerous *same-number, different-meaning* portability trap. The LinuxCNC M6 section additionally states that coolant **continues to flow unless M9 turns it off**; never import a Haas toolchange purge/stop expectation into a LinuxCNC M6 without an implemented, verified sequence. Haas M88/M89 are OEM TSC commands, not standard LinuxCNC coolant commands. These are DOC-CONFIRMED **documentation semantics**, not a runtime test or proof of physical safe state.

### 2026-10-27T22:33Z — APC-01 early pallet switch / hydraulic reversal / service E-stop option state
[Haas TG0108 (updated 2025-10-14) and 2026-10-02 Revision E direct OEM audit](research/4400_APC_01_HAAS_PALLET_CHANGER_EARLY_CLAMP_SENSOR_HYDRAULIC_REVERSE_AND_SERVICE_JUMPER_OEM_AUDIT_2026-10-27.md) → [technician card](safety-course/4400_APC_01_PALLET_CLAMP_SENSOR_ESTOP_OPTION_CHANGE_TECHNICIAN_CARD_2026-10-27.md). Exact new mechanisms: EC-400 rack switch may trip before actual pallet position; hose/sensor reversal can invert clamp meaning; receiver seal can leak oil into air blast; no-pallet state changes interpretation of I/O; OEM service jumper is only documented for an option-absent/service configuration, **not** an installed protective path. Conditional APC-1..7 UNKNOWN/NOT RUN, no selected machine or runtime, no hosted/local compute, G0/G1 HOLD. [Newest continuation](checkpoints/2026-10-27T223347Z-4400-tsc-tab-apc-dual-source-physical-evaluator-next.md).


### 2026-10-27T23:39Z — OPB-DRV-05 MAX22216 fault-specific output and evidence-retention source depth
[Direct original Analog Devices Rev. 2 pp. 11–14, 22, 43–47 and pinned OpenPressBrake design audit](research/4400_OPB_MAX22216_FAULT_AUTORECOVERY_CRC_STALE_COMMAND_AND_ENABLE_EVIDENCE_AUDIT_2026-10-27.md) → [one-pass review](safety-course/4400_OPB_DRV_05_MAX22216_FAULT_RECOVERY_AND_INDEPENDENT_SAFETY_REVIEW_CARD_2026-10-27.md). Reconciles existing OPB-CUTOVER-02/ISO-03/OUT-01 without rebranding generic output-fault lessons. **DOC-CONFIRMED:** OVT auto-resumes after cooling, HHF does not tri-state, OCP tri-states selected channel, UVLO can preserve register state until digital POR, ENABLE LOW clears device fault registers, CRC mismatch rejects the new SPI write (not the old state), COMER/readback are pipelined, and FAULT pin can be masked. **SOURCE-CONFIRMED:** proposed Rev1 four-input permit to both MAX22216 ENABLE sinks and ordinary CRC_EN HIGH/readback/fresh-command policy; board implementation OPEN. **INFERENCE:** a safety-permit withdrawal can erase ordinary diagnostic history, and stale commands require explicit normal-control fault handling, without delaying independent inhibit. Actual selected-machine physical/evaluator evidence UNKNOWN/NOT RUN, no tests or hosted/local compute; G0/G1 HOLD. Existing OPB-D04/D08 restricted card amended, no extra owner packet.


### 2026-10-27T23:39Z — 4400-STD-6909-01 new 2026 press-brake standard publisher scope and legacy gate
[Original ISO/EVS/EU edition-scope audit](research/4400_PRESS_BRAKE_ISO6909_2026_TYPE_C_PUBLICATION_SCOPE_AND_LEGACY_RETROFIT_GATE_2026-10-27.md) identifies a genuine **standards currentness omission** in the 2026-10-25 RESCUE-01 audit: ISO 6909:2026 was published **2026-05-29** and EN ISO 6909:2026 is adopted/listed in 2026. Unlike ISO 16092-1/-3 hydraulic-press standards, ISO 6909 specifically addresses press brakes, but its abstract excludes machines manufactured before publication and automatic workpiece loading/unloading safety. **DOC-CONFIRMED official publisher scope, not normative clauses**; EN 12622 legacy records and ANSI B11.3-2022 remain relevant by jurisdiction/date. Existing Stage A F and RESCUE-01 amended; no new case bank, machine release, physical proof or compute. G0/G1 HOLD.


### 2026-10-28T00:36Z — STD-6909-02 EU Machinery Directive→Regulation and safety-software provenance
[Original EU Commission / ISO / Regulation source-depth](research/4400_STD_6909_02_EU2027_SUBSTANTIAL_MODIFICATION_SAFETY_SOFTWARE_PROVENANCE_SOURCE_AUDIT_2026-10-28.md) and [practical reviewer](safety-course/4400_STD_6909_02_EU_REGIME_CHANGE_AND_SAFETY_SOFTWARE_REVIEW_CARD_2026-10-28.md) deepen STD-6909-01 rather than create another generic standards lesson. **New exact official source:** Commission says `20.01.2027` in Directive-era harmonised-standard summaries may be the **Directive's repeal**, not a technical standard withdrawal; a separate Machinery Regulation citation list must be checked for post-transition claims. Regulation (EU) 2023/1230 Article 3(16) defines a cumulative substantial-modification test for physical/digital changes; Article 18 has affected-machine manufacturer-obligation scope and a limited non-professional own-use exception; Annex III 1.1.9/1.2.1(f) differentiates safety-software identity/intervention/version records from physical safe-state proof. **Direct Commission page; official EUR-Lex legal text search-indexed only due fetch challenge.** No selected OpenPressBrake date/jurisdiction, machine legal classification, active Pilz identity, Y1/Y2 hydraulic stop/hold or 2520–25F0 evaluator; all UNKNOWN/NOT RUN. No paid clauses, new owner questionnaire, paper case bank, physical tests or hosted/local compute. G0/G1 HOLD; §11JW. [Continuation checkpoint](checkpoints/2026-10-28T003657Z-4400-eu-transition-software-provenance-physical-evaluator-next.md).


### 2026-10-28 — GUARD-FAST-01 fixed-guard retained fixing and false-closed panel source-depth
[Original EU Annex III / OSHA / Clarendon-MW audit](research/4400_GUARD_FAST_01_EU_ANNEXIII_CAPTIVE_FIXINGS_FALSE_CLOSED_AND_MAINTENANCE_BYPASS_SOURCE_AUDIT_2026-10-28.md) and [practical reviewer](safety-course/4400_GUARD_FAST_01_CAPTIVE_FASTENER_AND_ACCESS_ANTI_BYPASS_FIELD_CARD_2026-10-28.md). Predecessor GUARD-01 already taught generic bypass incentives; **increment** is exact retained-fixing / cannot-appear-installed-unfastened physical witness and fixed vs interlocked movable access tradeoff. EU Regulation Annex III 1.4.2.1/2.2 **official indexed** (direct fetch blocked), OSHA eTool and captive-fastener OEM pages **directly inspected**. A retained captive screw is not proof of tightening, guard impact retention, access exclusion or safety stop. Frequent access should motivate engineered hinged/interlocked access, not routine removal. Existing Stage A E/G refined; no owner packet, public case bank, physical tests, compute or external evaluator. Selected OpenPressBrake guard UNKNOWN, G0/G1 HOLD; §11JX. [Next checkpoint](checkpoints/2026-10-28T003657Z-4400-eu-transition-software-provenance-physical-evaluator-next.md).


### 2026-10-28T01:34Z — STRUCT-01 three independent machine structural load envelopes
[Original Cincinnati EM-519 2019 pp. 4-7/4-8 source audit](research/4400_STRUCT_01_CINCINNATI_PRESS_BRAKE_ECCENTRIC_OFFCENTER_STRIPPING_LOAD_SOURCE_AUDIT_2026-10-28.md) and [technician field card](safety-course/4400_STRUCT_01_THREE_DIRECTION_MACHINE_LOAD_AND_REVERSE_STRIPPING_TECHNICIAN_CARD_2026-10-28.md) add **new physical structural witness** beyond TOOL-LOAD-03's local tool kN/m: front-back **eccentric moment**, left-right **location-dependent machine tonnage**, and **reverse UP-stroke stripping load**, with bolt-on ram-nose exclusion and OEM warning of shattering attachment bolts/loosening bed. Model-specific OEM 400 PF figures must **not** become universal OpenPressBrake limits; original PDF and figure inspected, other Cincinnati editions indexed-only. Selected press, nose, structure, load direction, load-center and physical guarding UNKNOWN; existing Stage A/Stage B intake reused, no unscored case bank, evaluator NOT RUN, G0/G1 HOLD, 0 hosted/local compute. [Checkpoint](checkpoints/2026-10-28T013400Z-4400-structural-load-physical-evaluator-next.md).


**TANDEM-02 exact OEM master/slave mode correction (2026-10-28):** [Original Cincinnati EM-519 2019 printed pp. 8-6–8-10 audit](research/4400_TANDEM_02_CINCINNATI_MASTER_ONLY_LIGHT_GUARD_SLAVE_FOOTSWITCH_AND_TONNAGE_DISPLAY_SOURCE_DELTA_2026-10-28.md) provides a direct safety discriminator absent from prior TRUMPF/Accurpress product-level TANDEM-01: **slave-connected light guard inactive in tandem**, master-connected full-span guard required, slave pedal/palm inactive but E-stop active, programmed/diagnostic tonnage proxy for short bends, and possible out-of-level rams under too-short tandem workpieces. OEM-specific, not OpenPressBrake as-built; TAN-P03 refined without new bank, selected physical proof/evaluator UNKNOWN, no compute, G0/G1 HOLD; §11JZ.


**FORM-HAZ-04 actual fatality source-depth (2026-10-28):** [Direct original NIOSH/OKFACE FACE 05-OK-005-01](research/4400_FORM_HAZ_04_NIOSH_FACE_05OK005_PRESS_BRAKE_WORKPIECE_EJECTION_INCIDENT_ADDENDUM_2026-10-28.md) documents 920-lb lug **slipping from rear lower V-die during near-edge bend** and ejecting into operator/forklift support zone, causing fatal injury. This is **not** evidence of Cincinnati eccentric overload, broken tooling, or OpenPressBrake installation. Distinct new physical discriminator: actual **workpiece-to-die engagement and ejection path** beyond machine tonnage/Y1/Y2 tracking/guard input. Existing FORM-HAZ-04 case bank unchanged in count and UNSCORED, no physical/evaluator/compute, G0/G1 HOLD; §11KA.


### 4400-CROWN-01 — Haas/WILA crowning drive, exceptional hard-stop recovery and guard-delivery delta (2026-10-28; NON-GRADUATED)
[Direct original Haas HPB July/August 2026, WILA exact product and eCFR source audit](research/4400_CROWN_01_HAAS_WILA_CROWNING_LIMIT_RECOVERY_GUARD_DELIVERY_SOURCE_AUDIT_2026-10-28.md) → [technician review](safety-course/4400_CROWN_01_CROWNING_AXIS_RECOVERY_AND_GUARD_DELIVERY_TECHNICIAN_CARD_2026-10-28.md). **Predecessor:** Cincinnati 2014 hydraulic Auto Crown was already audited in OPT-01; TOOL-LOAD-03 covers local tool load. **Increment:** Haas separate V motorized wedge axis, S5/S7 ordinary and S4/S6 additional travel switches, feedback/phase mismatch and high-risk qualified service recovery from lost position; exact WILA Pro motorized wedge with hydraulic clamping is catalogued **without delivered guards, mounting hardware or power pack**, while exact Premium variant lists guards supplied. Haas general safety warns against bypass and restricts cabinet access; its exceptional recovery text is **not** copied as an operator procedure or evidence of a certified safety circuit. Conditional Stage A A–G witness CROWN-1..6 UNKNOWN/NOT RUN, independent evaluator NOT RUN, OpenPressBrake crown existence UNKNOWN, G0/G1 HOLD, zero hosted/local compute, no physical tests.


### 2026-10-28T03:31Z — HYD-DYN-01 flow-fuse abrupt deceleration and hydraulic reopening source-depth
[Direct original Bucher RS issue 12.2024 datasheet and distinct CFS 10.2022 article audit](research/4400_HYD_DYN_01_BUCHER_RS_ABRUPT_ARREST_AUTOREOPEN_AND_CFS_DIFFERENTIATION_SOURCE_AUDIT_2026-10-28.md) → [practical field review](safety-course/4400_HYD_DYN_01_BURST_VALVE_FAST_STOP_AND_AUTOREOPEN_TECHNICIAN_CARD_2026-10-28.md). **Predecessor reconciliation:** 2026-10-24 HYDAC/HIDROS/Winner hose-fuse and HAWE LB already establish trigger margins, partial leaks, protected segments, orifice and nuisance surge; 2026-10-28 STRUCT-01 and FORM-HAZ-04 establish distinct structural and part-ejection mechanisms. **New exact source/witness delta:** RS manufacturer warns of *very large deceleration* on rapid closure, specifies **automatic P>Z reopening** and ≥40% above normal operating flow for its setting, and describes **nearly** leak-free closure in its actual 2024 datasheet. CFS controlled-lowering excavator evidence and DERV pilot holding are different families. A valid rupture trip is not enough to validate peak dynamic load, tool/part retention, long-term hold, rearm or service isolation. All selected OpenPressBrake physical/evaluator evidence UNKNOWN; G0/G1 HOLD, no tests or compute. No new unscored exam bank.

**HYD-DYN-01 second OEM source-depth (08.2020 BBV housing/cartridge):** [Same original audit](research/4400_HYD_DYN_01_BUCHER_RS_ABRUPT_ARREST_AUTOREOPEN_AND_CFS_DIFFERENTIATION_SOURCE_AUDIT_2026-10-28.md) now directly inspects both nine-page BBV 6 manuals. The optional **housing** secondary relief opens B→A by raising pilot X; the **cartridge** does not include that integrated relief. Neutral holding requires the specified A/X depressurized state. This refines the **existing Sun/Parker CP pilot/thermal-relief witness** with an exact Bucher internal flow path and housing/cartridge option distinction, not a claim of observed descent or a universal valve-selection recommendation. No new unscored bank, lab or compute; selected machine UNKNOWN, G0/G1 HOLD.


### 2026-10-28 — 4400-HYD-SURGE-01: pressure peak witness versus analog gauge and pressure-test fixture (NON-GRADUATED)
[Original Parker 4400-B.1 §2.2 / HSE GS4 source-depth](research/4400_HYD_SURGE_01_PARKER_GS4_PEAK_PRESSURE_GAUGE_BLIND_SPOT_AND_TEST_RIG_SAFETY_SOURCE_AUDIT_2026-10-28.md) → [one-pass technician card](safety-course/4400_HYD_SURGE_01_PRESSURE_SPIKE_VS_GAUGE_AND_SAFE_TEST_ZONE_TECHNICIAN_CARD_2026-10-28.md). **New narrow discriminator:** a mechanical gauge can read an appropriate static value yet miss short **surge peaks in the same line**; this is distinct from HYD-CUSH-02's wrong/unobservable *internal pocket*. A hose assembly is limited by the lowest constituent **working** pressure, never by a catalog burst-test figure. HSE GS4 independently establishes that a proof test can launch fittings, whip hoses and inject fluid; test connectors need condition/identity control and personnel segregation. Existing INJ-01/HOSE-ROUTE-01/HYD-CUSH-02/HYD-DYN-01 mechanisms preserved, not rediscovered. **DOC-CONFIRMED** exact Parker/HSE; selected OpenPressBrake peak, hose, instrument, physical stop/hold, guard/restart and independent evaluator **UNKNOWN**. No new paper bank, physical test, hosted/local compute or release. **G0/G1 HOLD**; cumulative §11KE.

### 2026-10-28T05:38Z — HYD-TEMP-01 OEM thermal envelope and auxiliary heater energy
[Direct original Cincinnati 60 PROFORM EM-507 (2003), Parker VA130 original PDF source audit](research/4400_HYD_TEMP_01_CINCINNATI_PARKER_COLD_OIL_THERMAL_TRIP_HEATER_AND_STOP_PROOF_AUDIT_2026-10-28.md) and [technician review](safety-course/4400_HYD_TEMP_01_COLD_OIL_HOT_TRIP_HEATER_AND_RAM_HOLD_TECHNICIAN_CARD_2026-10-28.md). **FILT-01 and HYD-AIR-01 already cover cold viscosity/filters/inlet; this adds a distinct machine OEM startup-vs-running fluid envelope, hot warning vs main-drive shutdown, optional heater operable independently of drive, and a different valve OEM's explicit temperature-dependent leakage/response warning.** Fiessler AKAS-5M periodic overrun evidence already exists; a periodic pass is not automatically continuous temperature-envelope validation. Distinguish **normal thermal status**, **independent stop**, **gravity holding**, **maintenance isolation**, and **heater energy**; do not transplant Cincinnati/Parker numbers, infer heater wiring or claim a particular ram stop-time trend. No new Stage A form or unscored bank; G0/G1 HOLD, external evaluator NOT RUN, no physical test or compute. §11KF.

**HYD-TEMP-01 Chromalox source-depth (same session):** [Original PD457-2 2010 manufacturer manual](research/4400_HYD_TEMP_01_CINCINNATI_PARKER_COLD_OIL_THERMAL_TRIP_HEATER_AND_STOP_PROOF_AUDIT_2026-10-28.md) says integral heater thermostat is **not fail-safe** and low immersion can cause fire. Combined with Cincinnati's low-level main-drive trip and heater operable independently of drive, it raises a **conditional independent heater cutoff/backup protection** question, not a claim of installed failure. Stage A A/D/G existing fields suffice; no dry-fire experiment, new exam bank, selected-machine proof or compute. G0/G1 HOLD.

**HYD-TEMP-01 option-page correction:** [Original Cincinnati EM-507 p. 8-2 and p. 9-6 reinspection](research/4400_HYD_TEMP_01_CINCINNATI_PARKER_COLD_OIL_THERMAL_TRIP_HEATER_AND_STOP_PROOF_AUDIT_2026-10-28.md) distinguishes a heater intended to *maintain* startup temperature (not warm an already-cold reservoir) from a cooler fan operable only while motor/pump runs. Do not infer a safe-run threshold from the ~60°F option thermostat or a guaranteed cooling response after a high-temperature trip. No physical/evaluator proof; G0/G1 HOLD.

### 2026-10-28T06:33Z — MIRROR-01 service addendum original manufacturer variant/mounting source-depth
[Direct Schneider TeSys FAQ (2012, updated 2025), Schneider mirror/linked FAQ, original Rockwell/Suva E 7297.e certificate (2022) and Omron source audit](research/4400_MIRROR_01_ROCKWELL_SUVA_AND_SCHNEIDER_ACCESSORY_SOURCE_DEPTH_ADDENDUM_2026-10-28.md) → [technician field review](safety-course/4400_MIRROR_01_ACCESSORY_MOUNTING_TERMINAL_AND_EDM_SERVICE_ADDENDUM_2026-10-28.md). **Predecessor correction:** 2026-10-25 MIRROR-01 already taught exact Schneider TeSys mirror/non-mirror variants and mirror versus linked; RST-01/2540 already teach EDM. **Actual increment:** original Suva certificate factory-retained front versus conditional side-mounted assembly, exact Schneider LADN11/LADN11P terminal markings, LADC22 auxiliary overlap and coil/mount restrictions; CHG/STALE repair witness. Siemens 2023 PDF remained indexed-only (direct 403), so no Siemens numerical diagnostic coverage claim. Selected OpenPressBrake K1/K2/auxiliary/wiring/physical stop-hold/evaluator UNKNOWN/NOT RUN; G0/G1 HOLD; no hosted/local compute, no new exam bank.

### 2026-10-28 — COORD-01 exact manufacturer Type I/II post-short-circuit requalification
[Direct Schneider FA105974/FA99443/FA238342 source audit](research/4400_COORD_01_TYPE1_TYPE2_SHORT_CIRCUIT_COORDINATION_CONTACT_WELD_POST_FAULT_REARM_SOURCE_AUDIT_2026-10-28.md) and [technician field card](safety-course/4400_COORD_01_AFTER_SHORT_CIRCUIT_TYPE2_DOES_NOT_MEAN_RESET_AND_RUN_FIELD_CARD_2026-10-28.md). **Predecessor:** PANEL-01 owns SCCR/multiple feeds/LOTO; 2540/MIRROR-01 own welded contacts/EDM. **New:** Type II's permitted limited contact weld and **tested SCPD+contactor+overload combination**, not any interchangeable breaker, create a distinct **post-fault repair/rearm witness**. Separate coordination, panel SCCR, safety function, physical stop/hold. Siemens corroboration indexed-only; **Rockwell original 2018 140M-TD002G PDF directly opened, printed p. 31 visually inspected**: named 400 V Type II row and 100-C16 Type I-only footnote prove exact-combination dependency. No numerical kA imported to selected machine. G0/G1 HOLD, external evaluator NOT RUN, zero compute, no new public case bank. §11KH.


### 2026-10-28 — 4400 VAL-STD-01 Part 2 published-versus-draft and calculation/software/physical validation crosswalk
[official ISO/IFA edition and tool-scope audit](research/4400_VAL_STD_01_ISO13849_PART2_2012_DIS2026_SISTEMA_SOFTEMA_VALIDATION_BOUNDARY_AUDIT_2026-10-28.md) → [technician review](safety-course/4400_VAL_STD_01_PL_CALCULATION_SOFTWARE_AND_PHYSICAL_VALIDATION_REVIEW_CARD_2026-10-28.md). Exact ISO publisher status and IFA institutional SISTEMA/SOFTEMA revision mapping. This is a **source-depth addition** to Stage A and 2520–25F0, not a new physical-stop principle. ISO Part 2:2012 remains current; Part 2 DIS 2026 stage 40.99. No selected machine, external evaluator, PL computation or compute. G0/G1 HOLD.


**VAL-STD-01 original IFA source-depth:** [Original SISTEMA 3.0 migration guide](https://www.dguv.de/medien/ifa/en/pra/softwa/sistema/innovations_sistema_3-0.pdf) and [2025-11-02 IFA 3.0.4 build 5 release notice](https://dguv.de/ifa/;/praxishilfen/practical-solutions-machine-safety/software-sistema/newsletter/2025/quartal_4/index.jsp) confirm **one-way 2.x→3.x model conversion**, revised CCF/DC/EMI/fault-exclusion checks, and a documented **yellow→green** note override that is not proof of physical safety (red cannot be downgraded this way). Release 3.0.4 fixed an earlier documentation edit sometimes not saved. Retain old and converted reports, exact build and all warning dispositions; qualified review plus independent physical stop/hold remain required. No tool run, numerical PL, selected machine or compute; G0/G1 HOLD.


### 2026-10-28 — IFA-VALVE-01 component type test does not cover installed valve diagnostics or ram hold
[Original 10/2024 IFA GS-IFA-M12/M13 testing-body source audit](research/4400_IFA_VALVE_01_GS_IFA_M12_M13_COMPONENT_TEST_VS_DIAGNOSTICS_AND_MACHINE_HOLD_AUDIT_2026-10-28.md) → [one-page reviewer](safety-course/4400_IFA_VALVE_01_CERTIFIED_VALVE_NOT_CERTIFIED_RAM_STOP_REVIEW_CARD_2026-10-28.md). Both original printed p.10 footnotes exclude fault-detection measures from component testing; M12 specifically assumes contact-based transducer interruption or equivalent. Product test, diagnostics, safety architecture, physical gravity hold and service isolation require distinct evidence. No selected machine, live test or compute; G0/G1 HOLD.


### 2026-10-28 — HYD-FIT-01 original DGUV metric/inch thread false-fit and repair ejection hazard
[Original FB HM-025 09/2017 source audit](research/4400_HYD_FIT_01_DGUV_FBHM025_METRIC_INCH_THREAD_FALSE_FIT_PRESSURE_EJECTION_SOURCE_AUDIT_2026-10-28.md) → [field review](safety-course/4400_HYD_FIT_01_HAND_TIGHT_DOES_NOT_MEAN_PRESSURE_SAFE_TECHNICIAN_CARD_2026-10-28.md). G 1/2 into M22×1.5 can thread without stripping yet fail pressure retention. Distinct from existing hose routing, pressure surge and injection. Standardized marked parts, controlled replacement and independent safe hydraulic proof; no actual machine or pressure test. G0/G1 HOLD.


### 2026-10-28 — SET-FLUID-01 DGUV/IFA 2019 hydraulic reduced-speed physical architecture source-depth
[Original English FBHM-058 audit](research/4400_SET_FLUID_01_DGUV_FBH058_FIXED_ORIFICE_MONITORED_HYDRAULIC_REDUCED_SPEED_SOURCE_ADDENDUM_2026-10-28.md) → [technician review](safety-course/4400_SET_FLUID_01_HYDRAULIC_SLOW_JOG_IS_NOT_SAFETY_LIMITED_SPEED_TECHNICIAN_CARD_2026-10-28.md). Predecessor SET-01 already covers mode/enabling/LOTO; new source explicitly distinguishes fixed restriction plus monitored high-speed bypass/higher-level stop from ordinary proportional low-flow commands. Historical example PL/speed not transferable. No selected physical data or compute, G0/G1 HOLD.


### 2026-10-28T08:31:37.518Z — HYD-REGEN-01 / HYD-DRAIN-01 original OEM hydraulic source-depth
[HAWE/Parker differential regeneration and LHDV symbol restriction audit](research/4400_HYD_REGEN_01_HAWE_PARKER_DIFFERENTIAL_REGEN_LOAD_HOLD_COMPATIBILITY_SOURCE_AUDIT_2026-10-28.md) → [field card](safety-course/4400_HYD_REGEN_01_FAST_APPROACH_NOT_SAFE_SPEED_OR_HOLD_TECHNICIAN_CARD_2026-10-28.md); [Parker shared tank/pilot-drain surge, detent and loss-of-power audit](research/4400_HYD_DRAIN_01_PARKER_D111VW_SHARED_DRAIN_SURGE_DETENT_POWER_LOSS_SOURCE_AUDIT_2026-10-28.md) → [field card](safety-course/4400_HYD_DRAIN_01_UNCOMMANDED_SPOOL_SHIFT_AND_POWER_LOSS_TECHNICIAN_CARD_2026-10-28.md). **Predecessor comparison:** HYD-INT blocked rod pressure, HYD-SURGE fast pressure, CP pilot/thermal holding and SET-FLUID physical reduced-speed are already taught. **New exact witnesses:** HAWE LHDV D7770 08/2024 p.17 -21/-25 and -11/-15 compatibility exclusions, Parker 2009 regenerative P-return pressure/pulling-load limitations and MSG14-2500/US A259 switchable speed/force path; same Parker catalog A257 warns shared drain surge can move a spool without new command, and detent/pilot loss need variant-specific review. Original PDFs and page images directly inspected. Selected OpenPressBrake valve/return topology and physical validation **UNKNOWN**, external evaluator **NOT RUN**; no numerical PL/speed/pressure, live testing, simulation or hosted/local compute. G0/G1 HOLD, §11KM–11KN. No new public exam bank.


### 2026-10-28 — G0-HF-02 conditional source annotation creep, not a new hazard
[Exact repository-content and provenance audit](research/4400_G0_STAGE_A_FIRST_CONTACT_APPENDIX_CREEP_AND_PROVENANCE_REFACTOR_AUDIT_2026-10-28.md) documents why a 14,994-character nominal one-page owner packet contradicted the prior progressive-disclosure G0-HF-01 design. The [short A–G handoff](safety-course/4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) is now 5,306 characters (64.6% smaller); all nine dated optional source headings are preserved in the [reviewer archive](safety-course/4400_G0_STAGE_A_DATED_SOURCE_DELTA_ARCHIVE_2026-10-28.md). Source-only information architecture change, not installed-machine evidence or scored human-factor outcome. Preserve G0/G1 HOLD and independent evaluator OPEN.


### 2026-10-28 — GUARD-REACH-01 ISO 13857 protective reach versus ISO 14120 guard design and ISO 13855 stop-distance
[Direct ISO/national-publisher scope and edition audit](research/4400_GUARD_REACH_01_ISO13857_2019_ISO14120_2015_VS_ISO13855_2024_SCOPE_AND_ACCESS_PATH_AUDIT_2026-10-28.md) → [short qualified reviewer](safety-course/4400_GUARD_REACH_01_REACH_VS_STOP_VS_EJECTION_FIELD_REVIEW_2026-10-28.md). Existing 13855/guard-fast/ejection material already covers dynamic stopping, retained fixings and projectiles; new specific scope is **protective-structure reach through/under/around/over**, including 13857 adult/child-upper-limb limits and climbing-over exclusion. This is a qualified Stage A B/E/F/G review extension, **not** a new owner packet or numeric guard design. No selected geometry, licensed table, physical test or compute; G0/G1 HOLD.
