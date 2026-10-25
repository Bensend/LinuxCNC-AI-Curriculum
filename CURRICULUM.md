# LinuxCNC Developer Curriculum

This curriculum is dependency-driven rather than a fixed reading list. Modules may spawn prerequisites when source reading exposes missing knowledge.

## Curriculum level roadmap

- **1000 level — LinuxCNC foundations:** architecture, realtime, HAL, motion, HostMot2, hm2_eth, I/O paths, failure engineering, Task/NML/UI, and a generic machine-control capstone.
- **2000 level — advanced control and diagnostics:** coupled-axis authority, feedback integrity, communication/watchdog recovery, recorder integrity, synchronized diagnostics, compound faults, advanced HMI behavior, QtVismach/live 3D visualization, and deeper control topics promoted by evidence.
- **3000 level — machine-specific specialization:** deep, evidence-based tracks for the major machine classes LinuxCNC users build and retrofit. Each track mines real forum build diaries, configs, source, custom components, HMIs, failure reports, and open-source projects, then turns the findings into an AI-readable machine build playbook.
- **4000 level — hardware and AI-assisted implementation:** custom HostMot2/FPGA work when justified, reusable board blocks, Ethernet/control-board architecture, safety-oriented hardware blocks, simulation and fault testing, and AI-readable hardware design contracts/playbooks. Advanced EDA automation and AI-assisted schematic/PCB implementation may be promoted here when evidence justifies it.

The levels are cumulative. Higher level does not merely mean harder; a topic is promoted when it requires specialized knowledge, infrastructure, hardware, or machine-domain reasoning beyond the previous level.

## Critical Path

The first branch is deliberately chosen to support future Ethernet FPGA machine-control development while still establishing LinuxCNC fundamentals:

`Architecture -> Realtime Model -> HAL Execution Model -> Motion/Servo Cycle -> HostMot2 Core -> hm2_eth -> HostMot2 Watchdog -> Encoder Path -> Output/PWM Path`

No later module may paper over an ungraduated prerequisite.

## Laboratory Compute Budget

The autonomous curriculum may continue hourly, but paid/limited laboratory compute must be treated as a separate resource budget.

- First-draft laboratory compute budget: **maximum 120 hours total**, using the available monthly Codespaces allowance as a project budget rather than spreading it artificially across a 30-day month.
- Working laboratory pace: **up to approximately 8 hours per calendar day** while the first draft is expected to complete in roughly 14–15 days. This is a ceiling, not a requirement to consume unused lab time.
- Research, source reading, documentation, reasoning, exams, corrections, and handoff work should continue outside the lab budget whenever they do not require the laboratory environment.
- A laboratory experiment may span multiple hourly curriculum lessons. Launch it once, record its run/job identifier and checkpoint, and let later lessons inspect and continue the same experiment rather than starting duplicates.
- An hourly lesson arriving while a lab is still running must not by itself trigger another copy of that lab.
- Individual workflow/job execution limits are independent of the daily compute budget. If the execution platform terminates an individual job at approximately 60 minutes, checkpoint or split the experiment into bounded stages and continue it in a later lesson/run.
- Once approximately 8 hours of laboratory compute have been consumed for the day, subsequent lessons should preferentially perform non-lab work unless remaining project budget and schedule clearly justify additional lab use.
- Lab time and lesson-agent wall-clock time are distinct. A background lab may legitimately overlap later lessons; duplicate lab execution should be avoided.
- Where practical, record laboratory start/end/runtime data so daily and cumulative first-draft usage can be audited and the pace adjusted before approaching the 120-hour ceiling.

## Phase 0 — Laboratory and Research Method

- L00 — Codespaces LinuxCNC laboratory
- L01 — source/version pinning and reproducibility
- L02 — LinuxCNC repository map and build/test system
- L03 — evidence/claims workflow

## Phase 1 — Architecture

- A01 — process/component architecture
- A02 — startup and configuration lifecycle
- A03 — task, motion, interpreter, GUI, HAL and NML boundaries
- A04 — machine state and enable/disable lifecycle
- A05 — one complete command-to-feedback conceptual trace

## Phase 2 — Realtime

- R01 — LinuxCNC realtime model and supported realtime environments
- R02 — realtime threads, functions, scheduling and periods
- R03 — servo thread versus other thread roles
- R04 — latency, deadline behavior and what LinuxCNC does/does not guarantee
- R05 — realtime/userspace communication boundaries

## Phase 3 — HAL

- H01 — HAL architecture and object model
- H02 — pins, signals, parameters and types
- H03 — components and exported functions
- H04 — thread/function execution ordering
- H05 — halcmd, halshow, halmeter and halscope internals/usage
- H06 — custom components and halcompile
- H07 — HAL failure/debugging patterns

## Phase 4 — Motion and Servo Control

- M01 — joints versus axes
- M02 — motion command/feedback data path
- M03 — one servo-period source-level trace
- M04 — PID component and closed-loop topology
- M05 — following error
- M06 — limits and homing
- M07 — enable, fault and recovery paths
- M08 — coordinated motion/trajectory boundary

## Phase 5 — HostMot2

- HM01 — HostMot2 architecture and registration lifecycle
- HM02 — module descriptor/IDROM model
- HM03 — register access model
- HM04 — GPIO
- HM05 — encoder module
- HM06 — PWM/PDM generators
- HM07 — stepgen
- HM08 — watchdog
- HM09 — read/write cycle ordering
- HM10 — error propagation into HAL/LinuxCNC

## Phase 6 — hm2_eth

- E01 — driver architecture and board discovery
- E02 — socket/network initialization
- E03 — read request/response path
- E04 — write path
- E05 — servo-period interaction and timing
- E06 — packet loss, timeout and error behavior
- E07 — recovery behavior
- E08 — interaction with HostMot2 watchdog
- E09 — complete LinuxCNC-to-Ethernet-register call flow

## Phase 7 — Feedback and Output Hardware Paths

- IO01 — quadrature encoder register-to-HAL path
- IO02 — encoder scaling/index/latch behavior
- IO03 — synthetic/faulted encoder experiments
- IO04 — PWM/PDM command path
- IO05 — analog-servo interface patterns
- IO06 — GPIO input/output path
- IO07 — hardware enable and fault patterns

## Phase 8 — Safety Boundary and Failure Engineering

- S01 — LinuxCNC machine control versus functional safety
- S02 — watchdog design patterns
- S03 — communication-loss behavior
- S04 — stale/frozen feedback
- S05 — disagreement/redundancy monitoring patterns
- S06 — fault injection framework
- S07 — restart/recovery/state integrity

## Phase 9 — Interpreter, Task, NML and UI

- T01 — G-code interpreter architecture
- T02 — task layer
- T03 — NML architecture and messages
- T04 — GUI integration boundaries
- T05 — custom operator interface patterns

## Phase 10 — Machine-Control Capstone

- C01 — simulated dual-actuator machine
- C02 — independent feedback loops
- C03 — synchronization/cross-coupling experiment
- C04 — asymmetric actuator response
- C05 — frozen/jumping feedback
- C06 — communication/watchdog faults
- C07 — state-machine sequencing
- C08 — diagnostics and trace capture
- C09 — fresh-AI architecture handoff

## 3000-Level Machine-Specific Specialization

The 3000 level applies the LinuxCNC and advanced-control methods to real machine classes. Each track should study multiple existing implementations rather than treating one configuration as canonical. Hardware implementation may be studied where necessary to understand a machine, but reusable board/FPGA design belongs primarily in the 4000 level.

### 3100 — Mills and VMCs
Study manual-mill conversions, knee mills, benchtop mills, VMC retrofits and machining centers. Include spindle/VFD control, rigid tapping, spindle orient, ATC/toolchanger sequencing, probing, tool tables, coolant/lube, homing/limits, pallet/auxiliary mechanisms, and production HMI workflows.

### 3200 — Lathes and Turning Centers
Cover X/Z conventions, diameter/radius mode, spindle encoder/index handling, CSS, threading synchronization and G76, tool tables and turret logic, spindle orientation, rigid tapping where applicable, C-axis/live tooling, probing, chuck/tailstock/steady-rest integration, and lathe-specific operator interfaces.

### 3300 — Plasma, Laser and Waterjet Gantries
Study QtPlasmaC/PlasmaC and other community implementations, THC and arc-voltage handling, probing and pierce sequencing, process interlocks, gantry squaring, height control, consumables/process state, process-enable paths, material libraries, and production nesting/HMI workflows.

### 3400 — Routers and Woodworking Machines
Cover gantry routers, vacuum tables, automatic tool changers, spindle/VFD interfaces, dust collection, probing, tool length handling, workholding, auxiliary pneumatics, multi-spindle/router configurations, and approachable setup patterns suitable for hobby and small-shop users.

### 3500 — Robots and Custom Kinematics
Study SCARA, six-axis arms, delta/parallel mechanisms, non-Cartesian machines, custom kinematics, singularities, joint/Cartesian limits, homing/reference strategies, path-planning boundaries, visualization, and diagnostics for unusual kinematic systems.

### 3600 — Press Brakes
This should be one of the first deep 3000 tracks because it exercises LinuxCNC in ways conventional mills do not. Mine LinuxCNC forum build diaries and open-source projects from the earliest design discussion through later changes and failures, not just final configs.

Topics should include Y1/Y2 independent feedback and beam-level control, hydraulic/proportional-valve command architecture, rapid approach/change-point/bend/decompression/return sequencing, pressure and tonnage concepts, backgauge X/R/Z-style control, manual typed-position and jog modes, bend-program sequencing, tooling geometry, bend allowance/deduction, springback and crowning/deflection compensation, calibration/reference procedures, press-specific fault/recovery behavior, physical guarding and safety-oriented control integration, and custom HMI/3D visualization.

The track should compare multiple LinuxCNC press-brake architectures, including realtime state-machine components, remap/G-code approaches, machine-specific hydraulic decoders and QtVCP/Vismach interfaces. It should record how each project evolved, what failed, why changes were made, and which lessons generalize.

DXF-assisted work should begin by documenting how commercial systems and open-source tools represent bend lines/layers, build bend lists, choose gauging surfaces, position backgauges, and check sequencing/collision constraints. Open-source projects outside LinuxCNC—including sheet-metal CAD, bend-manufacturability datasets/tools and standalone backgauge controllers—should be actively researched for reusable ideas. Full automatic DXF-to-bend sequencing is not required at 3000; a staged path from manual positioning to imported geometry plus human-confirmed sequencing is acceptable.

### 3700 — Grinding, EDM and Specialty Process Machines
Study surface/cylindrical grinding, sinker/wire EDM and other process machines where the process loop matters as much as geometric motion. Cover process feedback, spark/contact sensing, dressing, feed adaptation, auxiliary state machines, flushing/coolant, and failure/recovery behavior.

### 3800 — Saws, Feeders, Indexing and Automation Cells
Cover cutoff saws, positioning stops, stock feeders, rotary/indexing machines, transfer mechanisms and mixed motion/PLC-style automation. Emphasize sequencing, interlocks, part-presence sensors, recovery from partial cycles and operator-friendly manual modes.

### 3900 — Emerging and Unusual Machines
Use this track for gear hobbing, tube/pipe machinery, foam cutters, wire machines, additive/hybrid systems and other machines whose user community or control problem justifies a dedicated specialization. Topics can later be promoted into their own numbered track if evidence shows enough depth or adoption.

## 3000-Level Research Method

Every machine specialization should:

1. Locate and read several real LinuxCNC forum build threads from beginning to end where practical, preserving the evolution of the design rather than only its final state.
2. Inspect public configs, HAL, custom components, GUI code and source modifications associated with those machines.
3. Compare multiple architectures and record why builders chose them, what failed, and what they changed.
4. Search for relevant non-LinuxCNC open-source projects and commercial workflow concepts to avoid reinventing solved domain problems.
5. Separate generic reusable LinuxCNC lessons from machine-specific requirements.
6. Produce an AI-readable machine playbook describing requirements, architecture, interfaces, reusable blocks, configuration patterns, commissioning steps, diagnostics, failure modes, test plans and known limits.
7. Include practical safeguarding and physical-guard guidance where appropriate while making clear that the builder must evaluate the actual machine, hazards, operating environment and applicable requirements.
8. End with reproducible demonstrations or simulations, adversarial review, corrections and a fresh-AI handoff just like lower-level modules.

## 4000-Level Hardware and AI-Assisted Implementation

The 4000 level builds on LinuxCNC foundations, advanced control knowledge, and machine-specific understanding to design reusable control hardware and implementation infrastructure. A learner should not need custom hardware to complete the 3000 machine tracks; the 4000 series exists for cases where the controller, interface electronics, FPGA logic, or design workflow itself becomes the engineering subject.

Candidate 4000-level tracks include:

- **4100 — HostMot2 and FPGA implementation:** HostMot2-facing FPGA architecture, register maps, timing, firmware modules, watchdog behavior, encoder/PWM/step-generation logic, and compatibility with LinuxCNC drivers.
- **4200 — Ethernet and control-board architecture:** Ethernet-connected motion/control hardware, deterministic data paths, board-level partitioning, power domains, isolation and fault containment.
- **4300 — Reusable machine-I/O and motion-interface blocks:** encoder inputs, digital I/O, analog/proportional outputs, step/dir, PWM/PDM, servo interfaces, current/voltage sensing and configurable machine-interface blocks.
- **4400 — Safety-oriented hardware boundaries:** hardware enable chains, contactor/drive interfaces, fault latching, external safety-system boundaries, diagnostics and designs that clearly separate ordinary control from safety-rated functions.
  - Current source-reading follow-on: [4400-HY-01 Hydraulic press-brake safety architecture transfer](safety-course/4400_HY_01_HYDRAULIC_PRESS_BRAKE_SAFETY_ARCHITECTURE_TRANSFER_MODULE_2026-10-24.md). This is **NOT GRADUATED**: manufacturer-specific source comparison, paper exercises and open fresh/physical validation gates; it does not authorize operation or relocate safety authority into ordinary LinuxCNC/FPGA.
  - Current parallel source-reading follow-on: [4400-ESPE-01 scanner EFI signal semantics and rear-access restart](safety-course/4400_ESPE_01_SAFETY_SCANNER_EFI_SIGNAL_SEMANTICS_AND_RESTART_MODULE_2026-10-24.md). **NOT GRADUATED**: SICK S300/S3000 conditional signal routing and reset authority, paper exercises, selected physical and independent evaluation gates open.
  - Current additional source-reading follow-on: [4400-RET-01 brownfield CNC safety cutover and final-element continuity](safety-course/4400_RET_01_BROWNFIELD_CNC_SAFETY_CUTOVER_AND_FINAL_ELEMENT_MODULE_2026-10-24.md). **NOT GRADUATED**: LinuxCNC/OSHA/Pilz/Rockwell source evidence, 30 paper cases, blank before/after cutover worksheet, selected physical proof and fresh independent evaluation OPEN; ordinary FPGA does not own personnel safety.
- **4500 — Hardware simulation, fault injection and verification:** circuit/logic simulation, tolerance and abnormal-condition testing, interface-contract verification, hardware-in-the-loop planning and reproducible validation.
- **4600 — AI-readable hardware design and EDA automation:** parameterized design contracts, reusable block specifications, schematic-generation prompts, machine-readable design rules, KiCad/EDA automation, and AI-assisted PCB workflows.

4000-level work should remain evidence-driven. Where practical, freeze interface requirements before implementation, simulate or test failure cases, retain design provenance, and distinguish a reusable generic block from a machine-specific adaptation learned in the 3000 series.

## Graduation Rule

Every module uses `MODULE_TEMPLATE.md`. A module does not graduate from prose alone. It requires source evidence, reproducible experiments where practical, an adversarial exam, corrections, and a fresh-AI handoff test.

## Public/Private Boundary

Machine-specific proprietary design information belongs outside this public curriculum. Capstone simulations and 3000-level examples should remain generic or use public community examples so they teach LinuxCNC behavior without publishing private machine drawings or private hardware design details.

### 2026-10-24 4400 safety: PWR-01 electrical common-cause and diagnostics

The [non-graduated 4400-PWR-01 module](safety-course/4400_PWR_01_SAFETY_IO_SUPPLY_RETURN_AND_DIAGNOSTIC_CONFIG_MODULE_2026-10-24.md) traces original SICK lost-0 V, reverse-current false-high, and XTIO output test-pulse configuration hazards. It extends 25A0/25B0 and brownfield 4400-RET-01. Selected-machine physical witnesses, independent fresh-AI transfer and all safety release gates remain open.

Additional 4400 safety source branch: [CIP Safety connection reaction time versus FSoE watchdog/ack and unsupported SIL UI](research/4400_CIP_SAFETY_CRTL_VS_FSOE_WATCHDOG_ACK_AND_SIL_UI_TRAP_SOURCE_AUDIT_2026-10-24.md), with [10-case paper technician card](safety-course/4400_SAFETY_FIELDBUS_TIMEOUT_ACK_AND_FALSE_SIL_TECHNICIAN_CARD_2026-10-24.md). Documentary, not selected machine proof or external evaluation.

### 2026-10-24 4400 safety: cable-pull and tactile contact protection

Source-reading branches, **NOT GRADUATED**: [OEM cable-pull E-stop tension warning, GuardLink standard-data and full-span reset audit](research/4400_CABLE_PULL_ESTOP_TENSION_MARGIN_GUARDLINK_STANDARD_TAG_SOURCE_AUDIT_2026-10-24.md) and [ISO/Schmersal/Mayser/ASO tactile-edge sensor physics, contact overtravel and auto-reset audit](research/4400_TACTILE_SAFETY_EDGE_SENSOR_PRINCIPLE_AUTORESET_AND_OVERRUN_SOURCE_AUDIT_2026-10-24.md). These extend the 2530/2590/25C0/4400 independent-safety boundary to conveyors, feeders, CNC gantries and automated cells. Conditional selected-machine intake `IN-04n/o` remains UNKNOWN, no installed-device assertion or physical proof. [Fresh independent cross-device handoff](evaluation/4400_CABLE_PULL_TACTILE_EDGE_FRESH_SOURCE_TRANSFER_HANDOFF_2026-10-24.md) PREPARED/NOT SCORED. Normal LinuxCNC/FPGA remains outside personnel-safety authority.


### 2026-10-24 4400 safety: MAT-01 floor presence sensing and reset

[4400-MAT-01 source-reading module](safety-course/4400_MAT_01_FLOOR_OCCUPANCY_SAFETY_FUNCTION_MODULE_2026-10-24.md) traces Rockwell MatGuard and Schmersal SMS4/5 exact sensor/trim/controller variants, detection-population limits, effective floor/joint coverage, auto/manual reset and final-element/physical stop distinctions. **NOT GRADUATED**: 14 paper cases and blank selected-machine worksheet are not physical proof or fresh external evaluation. Conditional `IN-04p UNKNOWN`; 2520–25F0 external gates OPEN. Normal LinuxCNC/FPGA never receives personnel-safety authority.


### 2026-10-24 4400 safety: S3000 optical/service calibration branch

[2026 SICK S3000 original optical shadow/front-screen replacement audit](research/4400_SICK_S3000_OPTICAL_SHADOW_FRONT_SCREEN_REPLACEMENT_CALIBRATION_AUDIT_2026-10-24.md) and [12-case technician practice](safety-course/4400_S3000_OPTICAL_SHADOW_SCREEN_SERVICE_TECHNICIAN_CARD_2026-10-24.md) deepen 4400-ESPE-01 with shadow/reflective surface/transparent-cover detection limits and mandatory new-screen optical calibration despite saved system-plug configuration. **SOURCE-READING / NOT GRADUATED**, conditional selected `IN-04q UNKNOWN`; no selected scanner or physical stop/hold proof. This is separate from the existing EFI field semantics and does not shift safety authority into LinuxCNC/FPGA.

### 2026-10-24 4400-DCB-01 — shared-bus isolation and thermal brake-resistor safety
[4400-DCB-01 source-reading module](safety-course/4400_DCB_01_COMMON_BUS_ENERGY_AND_MOTION_AUTHORITY_MODULE_2026-10-24.md) adds a **new conditional 4000 safety branch** without reopening graduated 1000–3000: ABB/Rockwell original manufacturer shared DC-bus, capacitor-extension, PM backdrive, external DC feeder and readiness-bit semantics, plus Rockwell/ABB brake chopper/resistor thermal-fire failure paths. [Original common-bus audit](research/4400_COMMON_DC_BUS_REGENERATION_REENERGIZATION_AND_ISOLATION_OEM_AUDIT_2026-10-24.md) and [thermal audit](research/4400_DYNAMIC_BRAKE_RESISTOR_STUCK_CHOPPER_FIRE_AND_STOP_BOUNDARY_OEM_AUDIT_2026-10-24.md); **26 non-blind paper scenarios**, blank selected-machine witness and [fresh independent handoff](evaluation/4400_DCB_01_FRESH_TOPOLOGY_TRANSFER_HANDOFF_2026-10-24.md) **PREPARED / NOT RUN**. Source-reading only, NOT GRADUATED. Actual OpenPressBrake drive topology and physical electrical/hydraulic safety evidence UNKNOWN; ordinary FPGA does not acquire safety authority.

### 2026-10-24 4400-ELEC-01 — Electrical point-of-work and AVT/test-point authority
[Non-graduated source-reading module](safety-course/4400_ELEC_01_POINT_OF_WORK_ELECTRICAL_ENERGY_VERIFICATION_MODULE_2026-10-24.md) reconciles OSHA 1910.333/.147/.303/.335, original Panduit VS2 B21110 Rev4 and **unresolved NFPA 2025 committee proposed-response vs earlier industry test-point interpretation**. A presence lamp, safety stop or green AVT at a different point is not all-source electrical service isolation. Four original artifacts, 14 paper cases; selected IN-04t UNKNOWN, qualified machine proof and independent evaluator open; no energized tests or personnel-exposed operation authorized.

### 2026-10-24 4400-ESPE-02 — Optical blanking, effective resolution and late-detecting press-brake lasers
[Non-graduated ESPE-02 module](safety-course/4400_ESPE_02_BLANKING_RESOLUTION_AND_PRESS_BRAKE_LATE_DETECTION_MODULE_2026-10-24.md) adds original SICK C4000 Advanced 2016 fixed/floating complete-versus-partial object monitoring, blanked reach holes, tolerance/effective-resolution/test-rod behavior and OSHA 1910.217(a)(5) press-brake exclusion versus 1910.212 guarding and 2004 under-blade late-detection interpretation. [16 paper scenarios](safety-course/4400_BLANKING_RESOLUTION_LATE_DETECTION_TECHNICIAN_CARD_2026-10-24.md), [blank selected physical witness](safety-course/4400_OPTICAL_BLANKING_FIELD_AND_RESTART_BLANK_WITNESS_2026-10-24.md), [fresh independent evaluation handoff](evaluation/4400_ESPE_02_FRESH_BLANKING_TRANSFER_HANDOFF_2026-10-24.md) PREPARED/NOT RUN. `IN-04u UNKNOWN`, actual machine stop/hold/coverage and external score open, no machine operation authorized. Ordinary LinuxCNC/FPGA remains non-safety control.

**ESPE-02 cross-OEM provenance note (2026-10-24):** [Rockwell 450L indexed manufacturer comparison](research/4400_ROCKWELL_450L_BLANKING_OBJECT_MONITORING_CROSS_OEM_TRANSFER_GATE_2026-10-24.md) supports a conditional object-monitoring pattern without treating two OEMs as universal or a connection tag as physical safety proof. Large original PDF direct opening failed; do not upgrade indexed excerpts to full-original inspection. Fresh evaluator must avoid these now learner-readable examples.

**ESPE-02 original Rockwell interface note:** [450L-QS001A 2021 original six-page quick-start source](research/4400_ROCKWELL_450L_BLANKING_OBJECT_MONITORING_CROSS_OEM_TRANSFER_GATE_2026-10-24.md) confirms receiver plug-in/start-mode and `OSSD` versus `Auxiliary output (OSSD emulation)` terminal-role distinctions. This is not selected safety wiring; §11BZ/IN-04u and physical validation remain open.


### 2026-10-24 4400-SET-01 — Guard-open setup, enabling, safe speed and LOTO
[Non-graduated SET-01 module](safety-course/4400_SET_01_SETUP_MODE_ENABLING_SLS_AND_LOTO_BOUNDARY_MODULE_2026-10-24.md) adds a distinct original-OEM failure-path and OSHA task-applicability transfer investigation to the existing 2570/2580 safety foundations. Rockwell Kinetix 2013 ESM monitoring changes with door state; Siemens 2021 encoderless SLS loses direct motor-speed monitoring when motor off; Pilz OFF–ON–OFF enabling requires a qualified safety chain; OSHA minor servicing is not a blanket setup exemption. A [versioned LinuxCNC feed-inhibit documentation conflict](research/4400_LINUXCNC_FEED_INHIBIT_JOG_DOCUMENTATION_VERSION_DRIFT_2026-10-24.md) is preserved as DOC-CONFIRMED and source/physical UNKNOWN, not treated as a safety function. Eighteen paper cases and a blank selected-machine witness published; independent fresh evaluator prepared but not run. IN-04v UNKNOWN, G3/G4 NOT AUTHORIZED; closed 1000/2000/F02/3000 unaffected.

### 2026-10-24 4400-MUT-01 — Conveyor muting, override and belt-stop time semantics
[Non-graduated MUT-01](safety-course/4400_MUT_01_MUTING_SEQUENCE_OVERRIDE_BELT_STOP_AND_RESTART_MODULE_2026-10-24.md) integrates original SICK deTec4 HG 8023856/1SWC/2026-02-05 OEM muting/belt-stop/override source, official Rockwell GuardLogix FSBM instruction documentation, and IEC 62046:2026 publisher edition scope. SICK SP2 24 h total/concurrence default, belt-stop timer pause with active sensor-change monitoring, and override-OSSD ON require exact configuration; Rockwell FSBM zero disables several timers and override can energize O1 despite input-status faults. **Different products; no universal timer transplant.** [18 PAPER cases](safety-course/4400_MUTING_TIMEOUT_OVERRIDE_HUMAN_ENTRY_TECHNICIAN_CARD_2026-10-24.md), [blank selected-machine witness](safety-course/4400_MUTING_AS_BUILT_STOP_HOLD_RESTART_BLANK_WITNESS_2026-10-24.md), [fresh independent handoff](evaluation/4400_MUT_01_FRESH_MUTING_TRANSFER_HANDOFF_2026-10-24.md) PREPARED/NOT RUN. Conditional IN-04w UNKNOWN, selected machine safety and external graduation OPEN, no compute or physical test. IEC 62046:2026 publisher confirms revised muting and whole-body topics but **paid normative clauses not inspected**. Normal LinuxCNC/FPGA remains non-safety.

**Same-session 4400-MUT-01 second original source branch:** [SICK deTec4 HG Smart Box Detection/object pattern recognition audit](research/4400_SICK_SMART_BOX_OBJECT_PATTERN_RECOGNITION_OVERRIDE_AND_COVERAGE_AUDIT_2026-10-24.md) compares qualified material recognition with muting. SBD normally keeps protective field monitored for invalid objects, but its **Override disables field monitoring** and can energize OSSD; OPR must rule out person+box or person riding with material. OEM device/function compatibility and physical geometry are essential. [12 paper cases](safety-course/4400_SMART_BOX_VS_MUTING_AND_PATTERN_RECOGNITION_TECHNICIAN_CARD_2026-10-24.md), conditional IN-04x UNKNOWN; not selected-machine proof or graduation. Total same-session original docs **9**, paper scenarios **30**.

**Same-session 4400 cross-machine real implementation transfer:** [Leuze SPG and five-lane dynamic safety-field OEM case audit](research/4400_LEUZE_SPG_MULTILANE_DYNAMIC_FIELD_REAL_INSTALLATION_TRANSFER_AUDIT_2026-10-24.md) traces published Leuze WITRON and Südzucker industrial solutions. SPG uses process-PLC signal **plus safety field**; the multi-lane example uses two vertical RSL 400 scanners and separate safety controls, not a global mute. OEM-REPORTED design, not independent test or permission for LinuxCNC/FPGA safety logic. Cumulative §11CH; **10 original docs / 30 PAPER scenarios** this session, no physical or independent evaluator.

### 2026-10-24 4400-CFG-01 — Safety configuration identity versus physical output truth
[Non-graduated CFG-01](safety-course/4400_CFG_01_SAFETY_CONFIGURATION_IDENTITY_VS_PHYSICAL_PROOF_MODULE_2026-10-24.md) and [original SICK/Rockwell OEM audit](research/4400_SAFETY_CONFIGURATION_SIGNATURE_SCOPE_AND_PHYSICAL_OUTPUT_TRUTH_AUDIT_2026-10-24.md) distinguish project/safety-signature or checksum **scope** from physical output terminals, final-element state and independent machine stopping/holding. SICK 2023 original gateway manual directly inspected: network output-image bit is logic information, not guaranteed terminal voltage; verified checksum is configuration-only. Older SICK Designer checksum excludes EFI/firmware per manufacturer-indexed excerpts only (full PDF reader limit). Rockwell GuardLogix 5580 official online manual requires checking signature after every download. [18 PAPER scenarios](safety-course/4400_SAFETY_CONFIGURATION_CHECKSUM_PHYSICAL_OUTPUT_TECHNICIAN_CARD_2026-10-24.md), [blank selected witness](safety-course/4400_SAFETY_CONFIG_AS_BUILT_READBACK_FINAL_ELEMENT_BLANK_WITNESS_2026-10-24.md), [fresh independent evaluator handoff](evaluation/4400_CFG_01_FRESH_CONFIGURATION_SCOPE_TRANSFER_HANDOFF_2026-10-24.md) **PREPARED/NOT RUN**. Cumulative §11CI, selected IN-04y UNKNOWN, physical Y1/Y2 stop/hold/guard/rearm unverified. Closed 1000/2000/F02/3000 unaffected; no simulation/hosted/local compute.

### 2026-10-24 4400-GUARD-01 — Guard release, inside escape and restart authority
[Original Pilz PSENmlock mini and Rockwell 442G OEM audit](research/4400_PILZ_PSENMLOCK_AUXILIARY_RELEASE_SDD_NONSAFETY_GUARD_AUTHORITY_AUDIT_2026-10-24.md) plus [non-graduated GUARD-01 module](safety-course/4400_GUARD_01_ACCESS_RELEASE_ESCAPE_AND_REARM_BOUNDARY_MODULE_2026-10-24.md) distinguish standard SDD fieldbus access request from independent S31/S41 safety authority; Pilz Y32 diagnostic from 12/22 safety outputs; access-side auxiliary release (not safety-rated escape) from inside escape; and automatic guard relock from deliberate new motion start. [14 PAPER scenarios](safety-course/4400_GUARD_LOCK_RELEASE_INSIDE_ESCAPE_REARM_TECHNICIAN_CARD_2026-10-24.md), cumulative §11CJ, conditional selected IN-04z UNKNOWN. No selected guard-lock device asserted; physical Y1/Y2 stop/hold/rearm and external competency remain OPEN. No hosted/local compute.

### 2026-10-24 4400-BLK-01 — Physical ram restraint, powered-stroke force and task-specific energy isolation
[Non-graduated BLK-01 module](safety-course/4400_BLK_01_GRAVITY_RESTRAINT_DYNAMIC_FORCE_AND_LOTO_MODULE_2026-10-24.md) and [direct original OSHA 2007 directive investigation](research/4400_OSHA_SLIDE_LOCK_GRAVITY_VS_POWERED_STROKE_AND_PRESS_BRAKE_TRANSFER_AUDIT_2026-10-24.md) add a structural/maintenance evidence gate to 2580 and 4400-SET-01: static gravity support is not powered-stroke protection; sensor indication is not physical engagement or structural load-path proof; 1910.147(f)(1) temporary positioning requires a people-clear and re-isolation cycle; individual LOTO control remains essential. [16 PAPER cases](safety-course/4400_GRAVITY_SUPPORT_DYNAMIC_LOAD_AND_TEST_POSITION_TECHNICIAN_CARD_2026-10-24.md), [blank selected witness](safety-course/4400_RAM_SUPPORT_AND_PERSONAL_LOTO_BLANK_WITNESS_2026-10-24.md), `IN-04aa UNKNOWN`, cumulative §11CK. OSHA 1910.217 mechanical-power-press clause does **not** automatically apply to press brakes; the OSHA directive appendix 2.0 factor is not a generic selected-machine rating. Physical and external evaluation OPEN; no compute, no personnel-exposed operation.

**BLK-01 same-session service-transition extension:** [Original OSHA testing/positioning, group-lockout and shift-handoff source audit](research/4400_SERVICE_TEST_POSITION_GROUP_LOCKOUT_REENTRY_TRANSITION_AUDIT_2026-10-24.md) plus [12 additional PAPER scenarios](safety-course/4400_SERVICE_REENERGIZATION_GROUP_HANDOFF_TECHNICIAN_CARD_2026-10-24.md) make the transition between isolated hands-in work and temporarily energized positioning explicit, including re-isolation, renewed gravity-support witness, contractor coordination and individual lock control. Cumulative §11CL, selected `IN-04aa UNKNOWN`. Total new same-session original docs **6** and paper cases **28**; no external score, physical test or compute.


### 2026-10-24 4400-RST-01 — Reset, power return, EDM and fresh-start safety boundary
[Non-graduated RST-01](safety-course/4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md) adds directly inspected original Pilz PNOZ X3P and Rockwell CI/DI reset/feedback source, manufacturer-indexed SICK EDM error-reset unexpected-output warning (original CDN PDF reader unavailable), and pinned `062dc7c` **SOURCE-CONFIRMED** LinuxCNC HALUI→NML→Task→normal IOControl reset chain. The important distinction is **restored safeguard ≠ fault acknowledge ≠ EDM feedback ≠ safety-output rearm ≠ physical safe state ≠ deliberate new cycle start**. [18 paper cases](safety-course/4400_POWER_RETURN_EDM_RESET_TECHNICIAN_CARD_2026-10-24.md), [blank physical witness](safety-course/4400_POWER_RETURN_EDM_AS_BUILT_BLANK_WITNESS_2026-10-24.md), [fresh evaluator contract](evaluation/4400_RST_01_FRESH_POWER_RETURN_EDM_TRANSFER_HANDOFF_2026-10-24.md) PREPARED/NOT RUN. Cumulative §11CM, conditional IN-04ab UNKNOWN, no physical validation, no compute, G3/G4 NOT AUTHORIZED; closed 1000/2000/F02/3000 unaffected.

### 2026-10-24 — 4400-HYD-01 hydraulic drive-loss and monitored-valve safety authority
[Direct original HAWE B 6340 04-2026 ePRAX audit](research/4400_HAWE_EPRAX_FASTDOWN_DRIVE_ACTIVE_VALVE_HOLD_ORIFICE_SOURCE_AUDIT_2026-10-24.md), [D 6354/1 06-2026 SVNE switch-range audit](research/4400_HAWE_SVNE_VALVE_POSITION_SWITCH_OVERLAP_AND_MAINTENANCE_SOURCE_AUDIT_2026-10-24.md), [non-graduated module](safety-course/4400_HYD_01_FASTDOWN_DRIVE_LOSS_VALVE_FEEDBACK_AND_PHYSICAL_HOLD_MODULE_2026-10-24.md) and [16 PAPER cases](safety-course/4400_HYDRAULIC_FASTDOWN_AND_VALVE_FEEDBACK_TECHNICIAN_CARD_2026-10-24.md). OEM describes a gravity-assisted FAST DOWN speed-control-loss hazard and separately controlled/monitored safety valves; monitored PNP position switches do not prove physical seat sealing or both-ram load holding. Preserve exact product variant and 2026 revision scope; no selected hydraulic truth table or thresholds invented. [Blank qualified witness](safety-course/4400_HYDRAULIC_STOP_HOLD_AND_ENERGY_BLANK_WITNESS_2026-10-24.md) and [fresh evaluator handoff](evaluation/4400_HYD_01_FRESH_VALVE_FEEDBACK_TRANSFER_HANDOFF_2026-10-24.md) NOT EXECUTED. Cumulative §§11CN–11CO, IN-04ac UNKNOWN; selected machine physical and external competency gates OPEN; no compute.

**HYD-01 source extension — line rupture flow threshold:** [Original HAWE D 6990 LB audit](research/4400_HAWE_LB_LINE_RUPTURE_FLOW_THRESHOLD_ORIFICE_SURGE_SOURCE_AUDIT_2026-10-24.md) and [12 PAPER cases](safety-course/4400_LINE_RUPTURE_THRESHOLD_LEAK_AND_NUISANCE_TRIP_TECHNICIAN_CARD_2026-10-24.md) distinguish high-flow rupture mitigation from slow leak, valve bypass-orifice flow, gravity holding, stop and maintenance isolation. Exact product/variant only; conditional IN-04ad UNKNOWN, physical/evaluator NOT RUN. No numerical threshold transferred.

### 2026-10-24 — 4400-ACC-02 accumulator fluid/gas service and bleed-variant change
[Original directly inspected Parker PVSI-01 service audit](research/4400_PARKER_PVSI_GAS_FLUID_RESIDUAL_ENERGY_DISASSEMBLY_OEM_AUDIT_2026-10-24.md), [HYDAC direct older OEM + newer indexed variant audit](research/4400_HYDAC_SAF_Y_Z_BLEED_VARIANT_AND_PHYSICAL_WITNESS_AUDIT_2026-10-24.md), [ACC-02 module](safety-course/4400_ACC_02_GAS_FLUID_DISCHARGE_VARIANT_AND_SERVICE_AUTHORITY_MODULE_2026-10-24.md), [18 PAPER cases](safety-course/4400_ACCUMULATOR_GAS_FLUID_SAF_VARIANT_TECHNICIAN_CARD_2026-10-24.md), [blank witness](safety-course/4400_ACCUMULATOR_GAS_FLUID_ZONE_AND_REARM_BLANK_WITNESS_2026-10-24.md). Fluid gauge zero is not gas-vessel disassembly permission; Y/Z and M/E variants plus E-to-M conversion can invalidate assumed power-loss discharge. 2003 HYDAC 2SV5E2 vs 2024 indexed WSM06020 are not interchangeable by inference. §11CQ, IN-04ae UNKNOWN, no selected-machine validation, no compute, closed prerequisite levels unaffected.

**Same-session 4400-VAC-01 cross-machine branch:** [Schmalz FMP/VOL/VAGG direct OEM audit](research/4400_SCHMALZ_VACUUM_LOAD_DROP_RESERVOIR_AND_CLAMP_ENABLE_OEM_AUDIT_2026-10-24.md), [VAC-01 module](safety-course/4400_VAC_01_VACUUM_GRIP_HOLD_STOP_AND_MACHINE_ENABLE_BOUNDARY_MODULE_2026-10-24.md), [16 PAPER cases](safety-course/4400_VACUUM_GRIP_AND_CLAMP_STOP_TECHNICIAN_CARD_2026-10-24.md), [blank witness](safety-course/4400_VACUUM_WORKPIECE_RETENTION_AND_RESTART_BLANK_WITNESS_2026-10-24.md). Source-confirmed OEM load-drop hazard from compressed-air/E-stop loss, reservoir/check-valve limitations, and ordinary machine-enable versus safety output ambiguity. §11CR; conditional IN-04af UNKNOWN; no physical/independent evaluation or compute.


### 2026-10-24 — 4400-RAD-01 wireless radio safety STOP, receiver modes and operator takeover
[Original Tele Radio R15/T19 OEM source audit](research/4400_TELE_RADIO_R15_T19_WIRELESS_STOP_CONFIGURATION_AND_RESTART_OEM_AUDIT_2026-10-24.md), [Scanreco independent-OEM architecture cross-check](research/4400_SCANRECO_G5_CAN_STOP_OUTPUT_VS_ORDINARY_CAN_CROSSCHECK_2026-10-24.md), [non-graduated RAD-01 module](safety-course/4400_RAD_01_WIRELESS_PENDANT_STOP_LINK_LOSS_AND_RESTART_MODULE_2026-10-24.md), [16 PAPER scenarios](safety-course/4400_RADIO_PENDANT_LINK_LOSS_OWNERSHIP_AND_REARM_TECHNICIAN_CARD_2026-10-24.md), [blank selected witness](safety-course/4400_RADIO_PENDANT_SELECTED_MACHINE_BLANK_WITNESS_2026-10-24.md) and [fresh external handoff](evaluation/4400_RAD_01_FRESH_RADIO_STOP_TRANSFER_HANDOFF_2026-10-24.md) PREPARED/NOT RUN. OEM's PLd Cat3 claim is limited to exact radio STOP subsystem and configuration; R15 mode 5 cancels documented PLd, Require start OFF permits radio stop-relay reactivation on power return, and 500 ms OEM response is not machine stopping time. Separate normal LinuxCNC command/diagnostic, independent STOP, physical gravity hold, isolator and deliberate machine start. §11CS; conditional IN-04ag UNKNOWN; no selected radio installation, physical test, independent score or hosted/local compute. Closed 1000/2000/F02/3000 unaffected.


**4400-RAD-02 same-session extension:** [IEC 62745 publisher-scope / FME mobile-HMI source audit](research/4400_IEC62745_FME_MOBILE_DEVICE_CABLELESS_SAFETY_AUTHORITY_SCOPE_2026-10-24.md) and [10 additional PAPER cases](safety-course/4400_MOBILE_HMI_VS_CERTIFIED_RADIO_STOP_TECHNICIAN_CARD_2026-10-24.md) distinguish certified radio STOP from consumer tablet/browser control. Full normative IEC 62745 clauses NOT inspected; FME March 2023-status industry guidance is not a universal 0.5 s stop limit or safety certification. Independent fixed safety control, physical load holding and deliberate restart remain necessary. §11CT, IN-04ag UNKNOWN, external/physical evaluation OPEN, no compute.


**4400-RAD-03 same-session original-manual edition comparison:** [R15 v09/v11 manufacturer audit](research/4400_TELE_RADIO_R15_V09_V11_VERSION_SCOPE_AND_POWER_CYCLE_AUDIT_2026-10-24.md) and [8 PAPER transfer cases](safety-course/4400_RADIO_MANUAL_VERSION_AND_PAIRING_CHANGE_TECHNICIAN_CARD_2026-10-24.md). v11 safety-function list adds T29-12 versus v09 T19-02; both SW0014-14v24+ and both cancel PLd STOP in discontinuous mode 5; v11 power-cycle after PLd->non-PLd change. Exact pair, certification, selected wiring and physical STOP still UNKNOWN. §11CU, IN-04ag UNKNOWN, no compute or external score.


**RAD-01 engineering verification extension:** [Staged qualified radio safety commissioning/fault review plan](safety-course/4400_RADIO_PENDANT_STAGED_COMMISSIONING_AND_FAULT_REVIEW_PLAN_2026-10-24.md) with 14 fault conditions and separate OEM readback, deenergized chain inspection, nonhazardous terminal proof, protected actual stop/hold, change control and fresh-start gates. Paper only; no physical test, selected radio system, external score or compute. §11CV, IN-04ag UNKNOWN.

### 2026-10-24 — 4400-NET-01 independent safety network versus ordinary EtherCAT watchdog
[NET-01 module](safety-course/4400_NET_01_SAFETY_NETWORK_WATCHDOG_DUAL_LINK_REACTION_AND_PHYSICAL_BOUNDARY_MODULE_2026-10-24.md) and [original Beckhoff/PI source audit](research/4400_BECKHOFF_FSOE_VS_ORDINARY_ETHERCAT_WATCHDOG_REACTION_TIME_SOURCE_AUDIT_2026-10-24.md) distinguish ordinary EtherCAT SM/PDI watchdog (including documented zero-disables condition), certified FSoE connection watchdog, two-link worst-case reaction, independent safe output, physical final-element and deliberate restart. [12 PAPER cases and blank witness](safety-course/4400_SAFETY_NETWORK_TWO_WATCHDOG_TECHNICIAN_AND_SELECTED_WITNESS_2026-10-24.md) NOT EXECUTED/NOT SCORED. Cumulative §11CW; conditional selected IN-04ah UNKNOWN; no claim OpenPressBrake uses Beckhoff/FSoE/PROFIsafe, no simulation or physical test, no GitHub-hosted/local compute. Closed 1000/2000/F02/3000 preserved.

**4400-NET-02 same-session safety-sensor transfer:** [TwinSAFE SC source-scope audit](research/4400_BECKHOFF_TWINSAFE_SC_STANDARD_ANALOG_SENSOR_VOTING_BOUNDARY_AUDIT_2026-10-24.md) distinguishes checked safety telegram from actual sensor truth and independent voting. Direct Beckhoff configuration readback supports SC CRC/address/enable requirements; EL33xx/application-guide multi-channel voting is manufacturer-indexed, full original guide unavailable. [Six additional PAPER cases](safety-course/4400_SAFETY_NETWORK_TWO_WATCHDOG_TECHNICIAN_AND_SELECTED_WITNESS_2026-10-24.md) yield 18 NET-01/02 cases; no physical/evaluator/compute, §11CX, conditional IN-04ah UNKNOWN.

### 2026-10-24 — 4400-BG-01/02: independent backgauge safety and reverse/return hazard
[Original TRUMPF B35 2023 / AMADA manufacturer source audit](research/4400_PRESS_BRAKE_BACKGAUGE_STEP_CHANGE_REAR_ACCESS_AND_INDEPENDENT_STOP_OEM_AUDIT_2026-10-24.md), [non-graduated BG-01 module](safety-course/4400_BG_01_BACKGAUGE_STEP_CHANGE_REAR_ACCESS_AND_STOP_AUTHORITY_MODULE_2026-10-24.md) and [12 PAPER cases / blank selected witness](safety-course/4400_BACKGAUGE_PHASE_AND_REAR_ACCESS_TECHNICIAN_WITNESS_2026-10-24.md) separate programmed next-position timing, X/R/Z/L backgauge/rear exposure, independently safe drive/final elements, ram Y1/Y2 hold and deliberate restart. [Original OSHA cabinet-press return-motion accident transfer audit](research/4400_OSHA_CABINET_PRESS_STOP_CANCEL_AUTORETURN_ASYMMETRIC_GUARDING_TRANSFER_AUDIT_2026-10-24.md) warns that STOP/CANCEL of a cycle can leave an unguarded **return** hazard on a *different machine class*; no OpenPressBrake return behavior asserted. **DOC-CONFIRMED** OEM/official indexed source within edition limits; **UNKNOWN** selected gauge/guard/stop/hold; **NOT GRADUATED**. Cumulative §§11CY–11CZ, conditional IN-04ai UNKNOWN, independent evaluator OPEN; no physical test or compute. Closed 1000/2000/F02/3000 unchanged.

**4400-GUARD-01 OEM source extension (2026-10-24):** [Direct EUCHNER CTP-I1/L1/L2 original-manual reconciliation](research/4400_EUCHNER_CTP_I1_L1_L2_LOCK_MONITORING_POWER_LOSS_AND_TEACHIN_OEM_RECONCILIATION_2026-10-24.md) deepens the existing CTP replacement card: FO1A/FO1B protect **different propositions** across I1 and L1; external L1 unlock control is a separate safety function; power-loss and teach-in/actuator coding change service/egress hazards. §11DA, selected IN-04z UNKNOWN; no new scored evaluation or machine proof.


### 2026-10-25 — 4400-CELL-01: robot-cell whole-body access and safety interface transfer
[Non-graduated CELL-01 module](safety-course/4400_CELL_01_WHOLE_BODY_ENTRY_MODE_RESET_AND_CROSS_MACHINE_START_MODULE_2026-10-25.md) traces original UR SW10_15 **all-mode vs automatic-mode-only** safeguard input semantics, default-reset-disabled auto-clear risk, remote I/O program start, and shared System Stop output return on upstream E-stop release. [OEM audit](research/4400_UR_SW10_15_SAFEGUARD_AUTO_RESET_MODE_AND_SYSTEM_STOP_HANDOFF_OEM_AUDIT_2026-10-25.md), [ABB/ISO scope audit](research/4400_ABB_RESET_VISIBILITY_ISO10218_2025_CELL_INTEGRATION_SCOPE_AUDIT_2026-10-25.md), [16 PAPER cases / blank witness](safety-course/4400_CELL_WALKTHROUGH_RESET_MODE_AND_RESTART_TECHNICIAN_CARD_2026-10-25.md), and [fresh evaluator assignment](evaluation/4400_CELL_01_FRESH_OCCUPANCY_RESET_TRANSFER_HANDOFF_2026-10-25.md). Extends existing trapped-person card and 4400-SET/RST/GUARD; does not reopen graduated 3000 or assert installed robot hardware. Conditional IN-04aj UNKNOWN; no physical stop/hold/restart evidence, no independent score or compute. **NOT GRADUATED; no personnel-exposed operation.**


**4400-ATC-01 same-session cross-machine safety transfer:** [Direct original Haas 2025 toolchanger/drawbar audit](research/4400_HAAS_TOOL_RELEASE_DRAWBAR_PRECHARGE_SENSOR_AND_TOOL_DROP_OEM_AUDIT_2026-10-25.md), [non-graduated module](safety-course/4400_ATC_01_TOOL_RETENTION_DRAWBAR_PNEUMATIC_RELEASE_AND_SERVICE_MODULE_2026-10-25.md) and [14 PAPER technician scenarios](safety-course/4400_ATC_TOOL_RELEASE_AND_CAPTURE_TECHNICIAN_CARD_2026-10-25.md) separate clamp sensor, mechanical force, toolchanger capture, pneumatic precharge, spindle/Z/arm stopping and LOTO. OEM 40T and SMTC versions are model-specific; no generic force or pressure numbers. Conditional IN-04ak UNKNOWN, §11DD, no test/evaluator/compute, no OpenPressBrake toolchanger assertion. Existing 1000/2000/F02/3000 graduation preserved.


**4400-ATC-02 source verification:** [Pinned LinuxCNC `062dc7c` M6/iocontrol Task acknowledgment trace](research/4400_LINUXCNC_PINNED_M6_IOCONTROL_TOOL_CHANGED_ACK_VS_PHYSICAL_RETENTION_SOURCE_TRACE_2026-10-25.md) establishes `tool-change && tool-changed` -> ordinary `RCS_STATUS::DONE` and `tool_number` update; shipped `core_sim.hal` loops request to acknowledgment without physical tool. SOURCE-CONFIRMED ordinary control boundary; not proof of clamp force, tool support or safety; no runtime. Complements ATC-01 Haas OEM mechanical evidence, §11DE.
