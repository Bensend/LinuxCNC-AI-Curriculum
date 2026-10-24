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
