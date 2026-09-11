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
- **4500 — Hardware simulation, fault injection and verification:** circuit/logic simulation, tolerance and abnormal-condition testing, interface-contract verification, hardware-in-the-loop planning and reproducible validation.
- **4600 — AI-readable hardware design and EDA automation:** parameterized design contracts, reusable block specifications, schematic-generation prompts, machine-readable design rules, KiCad/EDA automation, and AI-assisted PCB workflows.

4000-level work should remain evidence-driven. Where practical, freeze interface requirements before implementation, simulate or test failure cases, retain design provenance, and distinguish a reusable generic block from a machine-specific adaptation learned in the 3000 series.

## Graduation Rule

Every module uses `MODULE_TEMPLATE.md`. A module does not graduate from prose alone. It requires source evidence, reproducible experiments where practical, an adversarial exam, corrections, and a fresh-AI handoff test.

## Public/Private Boundary

Machine-specific proprietary design information belongs outside this public curriculum. Capstone simulations and 3000-level examples should remain generic or use public community examples so they teach LinuxCNC behavior without publishing private machine drawings or private hardware design details.