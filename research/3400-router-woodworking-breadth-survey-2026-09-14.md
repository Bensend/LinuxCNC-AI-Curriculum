# 3400 Routers and Woodworking Machines — breadth survey

Date: 2026-09-14

Status: **BREADTH / TRACK-MAP PASS**

Pinned LinuxCNC source revision for source-level claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

## Purpose

Map the 3400 specialization before deep-diving one router implementation. The track must cover both the large hobby/small-shop gantry-router population and industrial woodworking machines whose control problem is much richer than ordinary XYZ routing.

The 3400 scope from `CURRICULUM.md` includes:

- gantry routers;
- vacuum tables and workholding;
- automatic tool changers;
- spindle/VFD interfaces;
- dust collection;
- probing and tool-length handling;
- auxiliary pneumatics;
- multi-spindle/router configurations;
- approachable setup patterns for hobby and small-shop users.

The breadth pass shows that these topics naturally separate into two related but materially different machine classes:

1. **General gantry routers** — usually XYZ/XYYZ motion, one spindle, manual or rack ATC, fixed tool setter/touch plate, dust shoe and straightforward vacuum workholding.
2. **Industrial woodworking machining centers** — multiple spindles or heads, vertical/horizontal drill banks, aggregate saws, large distributed I/O, pneumatic tool deployment, vacuum pods/zones and feature-oriented production workflows.

The second class is the distinctive 3400 specialization and should not be reduced to generic milling concepts.

---

# A. High-level result

## A1. LinuxCNC already has a strong router foundation

No dedicated upstream `router.comp` equivalent to QtPlasmaC is needed for the common router architecture. LinuxCNC already supplies the main primitives:

- joints/axes and synchronized gantry homing;
- step/dir or servo motion;
- spindle command and multiple-spindle support;
- VFD interfaces including analog/PWM and multiple Modbus drivers;
- tool table and random/nonrandom toolchanger models;
- M6/tool-prepare/tool-change handshake;
- remap and G-code subroutines for machine-specific ATC logic;
- G38 probing and tool-length measurement;
- general HAL I/O for vacuum, dust, pneumatics, pressure sensors and auxiliary mechanisms.

The specialization therefore lies primarily in **composition, production workflow and auxiliary state ownership**, not in a unique motion kernel.

## A2. Gantry squaring is a first-class router concern

Large routers commonly use two joints for one Cartesian axis. Current LinuxCNC homing semantics support paired joints using the same absolute `HOME_SEQUENCE`, with negative values synchronizing the final home move and preventing unsafe independent joint jogging before homing.

This supports the common XYYZ pattern where each side of the gantry has its own home switch and is squared during homing.

Authoritative documentation:

- `docs/src/config/ini-homing.adoc`
- `docs/src/config/ini-config.adoc`
- LinuxCNC Homing Configuration: https://linuxcnc.org/docs/stable/html/config/ini-homing.html

Important future questions:

- real machine squaring repeatability;
- what happens when one home switch is stuck or missed;
- recovery after a drive fault on only one side;
- machines with one shared home input versus independent left/right switches;
- distinction between open-loop step/dir motors and true dual-servo feedback.

## A3. Tool handling is the central process specialization for many routers

Routers frequently spend more integration effort on tool handling than on the XYZ trajectory itself.

LinuxCNC distinguishes:

- manual/fixed-location/nonrandom toolchangers;
- random toolchangers;
- tool-preparation versus actual tool-change completion;
- spindle pocket state versus tool-table source pocket;
- tool length offsets independently from the M6 change itself.

Official source/docs establish that M6 does not by itself apply the new tool length offset; G43/tool-offset state remains a separate interpreter concern.

Authoritative sources:

- `docs/src/code/code-notes.adoc` / Tool Table and Toolchanger
- `docs/src/gcode/tool-compensation.adoc`
- `docs/src/config/ini-config.adoc`
- LinuxCNC Tool Compensation: https://linuxcnc.org/docs/html/gcode/tool-compensation.html

This separation is important for router commissioning because a mechanically successful ATC can still cut at the wrong Z if TLO state is stale or measured incorrectly.

---

# B. General gantry-router architecture

## B1. Public production-style configuration: Funkenjaeger `fj-lcnc-cfg`

Repository:

- https://github.com/Funkenjaeger/fj-lcnc-cfg

This is an unusually valuable current public router configuration because it combines several 3400 topics in one inspectable machine:

- XYYZ gantry with independent left/right Y homing;
- Mesa Ethernet HostMot2 interface;
- step/direction ClearPath integrated servos;
- hardware E-stop interfacing;
- ATC spindle;
- actuated linear tool rack;
- automatic and manual M6 modes;
- fixed tool setter;
- separate work touch plate and 3D probe;
- Hitachi WJ200 VFD over Modbus;
- compressed-air pressure sensing;
- actuated dust shoe;
- custom QtDragon operator controls.

The documented homing strategy is particularly useful: Z homes first for clearance, Y-left/Y-right home independently to remove racking, then X is coordinated with the Y homing sequence.

The tool-length model is also worth a deep pass. The machine performs measurement at a fixed setter with a dedicated work-offset strategy so the resulting TLO can be treated as a machine-coordinate-related value independent of the active job coordinate system.

This configuration should be one of the principal 3400 real-machine source traces.

## B2. Public small-shop configuration: FENJA / `myfenjalinuxcnc`

Repository:

- https://github.com/GuiHue/myfenjalinuxcnc

This machine provides a second architecture with useful contrast:

- Mesa 7i76E;
- touchscreen GMOCCAPY;
- Hitachi WJ200 VFD over Modbus;
- ISO20 ATC-capable spindle;
- manual tool handling plus pneumatic clamp/unclamp controls;
- logic that prevents ATC actuation while the spindle is running;
- hardware PILZ safety relay observed by LinuxCNC;
- fixed tool-length sensor plus wireless work probe;
- air-pressure monitoring;
- multiple pneumatic valves and relay-controlled auxiliaries.

The design is useful because it demonstrates a staged maturity path: an ATC-capable spindle does not require a fully automatic magazine on day one. A small-shop machine can begin with guarded/manual tool exchange, fixed tool measurement and robust interlocks, then add automatic rack/carousel logic later.

## B3. Public custom router: JetForMe `router-table`

Repository:

- https://github.com/JetForMe/router-table

The public configuration describes:

- a 4x8-class gantry router;
- HSD ATC spindle;
- rack-style toolchanger;
- fixed toolsetter;
- Mesa 7i76E;
- servo axes;
- dust-collector shoe integration;
- Fusion post/CAM-related files.

LinuxCNC forum history also documents debugging of a remapped M6 unload sequence and using the machine/dust shoe to vacuum the table. This is useful evidence that ATC and dust collection are not independent bolt-ons: they share machine clearance/state and can interact with program flow.

Forum example:

- https://forum.linuxcnc.org/40-subroutines-and-ngcgui/40772-sometimes-my-tool-unload-code-just-stops

## B4. Hobby/small-shop baseline contract

A defensible first 3400 router baseline should include:

1. XYZ or XYYZ motion with repeatable homing/squaring.
2. Spindle run, direction where applicable, commanded speed and VFD fault/ready status.
3. Tool setter and/or touch plate with clearly defined coordinate ownership.
4. Manual or automatic M6 workflow with spindle stopped before release.
5. Tool-present/clamp state where hardware provides it.
6. Air-pressure qualification when pneumatics operate the drawbar/rack/dust shoe.
7. Vacuum/dust outputs with explicit manual/automatic authority.
8. Independent safety chain; LinuxCNC observes safety state but does not replace safety-rated hardware.

---

# C. Spindle and VFD control

## C1. LinuxCNC spindle support is broad enough for router use

Current LinuxCNC supports multiple spindles and common router command methods including:

- 0-10 V analog speed;
- PWM-derived speed control;
- direction and run outputs;
- `spindle.N.at-speed` qualification;
- vendor-specific userspace VFD components;
- generic Modbus through `mb2hal`;
- realtime Mesa PktUART Modbus where deterministic polling is justified.

Authoritative documentation:

- https://linuxcnc.org/docs/master/html/en/examples/spindle.html
- https://linuxcnc.org/docs/html/hal/components.html
- https://linuxcnc.org/docs/stable/html/drivers/mesa_modbus.html

Important 3400 distinction: router spindle communication is normally **machine-control telemetry and command**, not a replacement for independent stop/safety functions.

## C2. Future spindle deep-pass questions

- analog versus Modbus command ownership;
- at-speed qualification before plunge/cut;
- VFD fault reset and restart behavior;
- spindle fan/chiller/coolant dependencies;
- spindle warmup and bearing requirements;
- ATC spindle clamp/unclamp state;
- high-speed toolholder/tool-balance limits;
- multiple physical spindles sharing one VFD through contactors versus one VFD per spindle.

The last item becomes important on older industrial woodworking machines.

---

# D. Tool length, work Z and probing

## D1. Routers commonly need two distinct Z references

Public configurations repeatedly separate:

- **tool-length measurement** at a fixed machine-mounted setter;
- **workpiece/spoilboard Z establishment** with a movable touch plate or 3D probe.

Current LinuxCNC documentation includes a tool-length-probe example using G38 probing and QtDragon documents both movable touchplate and fixed tool-setter workflows.

Authoritative example:

- https://linuxcnc.org/docs/stable/html/examples/gcode.html

The curriculum should explicitly teach the coordinate stack:

`machine Z -> fixed setter geometry -> tool length -> active G5x work offset -> programmed work Z`

rather than teaching probing as a magic macro.

## D2. Common failure classes

- probing with a stale G43/TLO already active;
- confusing setter height with tool length;
- using work coordinates during a machine-coordinate tool measurement without accounting for the offset;
- probe already active before G38 motion;
- sensor never triggers;
- retract direction/clearance wrong;
- tool changed but new TLO not applied;
- variable-length collet tool treated like a repeatable fixed-holder tool.

These failures warrant source/macro tracing before any lab work.

---

# E. Automatic tool changers and pneumatics

## E1. Real AXYZ 4008 retrofit provides an industrial ATC sequence

LinuxCNC forum thread:

- https://forum.linuxcnc.org/30-cnc-machines/27654-axyz-4008-atc-cnc-router-control-retrofit

The documented machine includes:

- 10 HP HSD spindle;
- pneumatic drawbar;
- stepper-driven carousel;
- pneumatic ATC door and dust foot;
- low-air-pressure sensor;
- fixed tool touch-off plate;
- movable spoilboard/work touch-off plate;
- Mesa control retrofit.

The preserved OEM sequence is valuable because it exposes the actual state machine rather than a generic M6 abstraction. It checks air pressure and spindle-zero-speed, opens the ATC/dust mechanism, retracts Z, homes/positions the carousel, moves to pickup/dropoff geometry, actuates the drawbar/purge and returns to the interrupted position.

This should become a 3400 deep-dive because it combines mechanical position, pneumatic state, tool identity and recovery.

## E2. ATC state must be explicit

A production router ATC should distinguish at minimum:

- requested tool;
- current spindle tool;
- target pocket;
- magazine/rack home state;
- spindle stopped / zero speed;
- drawbar clamp/unclamp command;
- clamp/unclamp confirmation if available;
- tool present if available;
- rack/carousel extended/retracted or door state;
- air pressure valid;
- safe Z / clearance position;
- tool setter result;
- recovery state after interrupted M6.

The breadth pass does **not** establish one universal ATC sequence. Rack, carousel and fixed-fork systems require different motion and fault recovery.

---

# F. Vacuum workholding, dust collection and auxiliary pneumatics

## F1. These are production-state systems, not just spare outputs

LinuxCNC can easily drive vacuum pumps, zone valves and dust collectors using HAL/M-codes, but 3400 should teach more than output toggling.

Real router/woodworking operation introduces questions such as:

- pump ready/fault and vacuum level;
- automatic versus manual zone selection;
- table-wide spoilboard vacuum versus movable pods/cups;
- part-present or vacuum-loss behavior;
- zone state across pause/abort/restart;
- dust-shoe clearance during ATC;
- dust collector start/stop lead/lag;
- pneumatic pressure qualification for toolchanger, drill heads and dust mechanisms.

Forum evidence shows hobby users commonly map spindle, vacuum and extraction to ordinary outputs/M-codes, while industrial machines rely on much larger machine-specific I/O systems.

Example:

- https://forum.linuxcnc.org/38-general-linuxcnc-questions/32844-mesa-5i25-and-mx4660-installation-and-configuration

## F2. Safety boundary

Vacuum hold-down and dust collection can materially affect cutting safety and fire/dust exposure, but ordinary LinuxCNC HAL logic should not be described as safety-rated merely because it monitors these states.

The curriculum should teach hazard-aware sequencing and diagnostics while keeping independent safeguarding/energy-isolation requirements explicit.

---

# G. Industrial woodworking centers — the distinctive 3400 branch

## G1. WEEKE BP05 shows why generic router coverage is insufficient

LinuxCNC forum thread:

- https://forum.linuxcnc.org/27-driver-boards/29041-retrofitting-weeke-bp05

The machine combines:

- analog servo axes;
- electrospindle;
- an 11-drill aggregate;
- saw aggregate;
- pneumatic deployment of spindle/saw/drills.

The LinuxCNC problem is therefore not only XYZ interpolation. It must select/deploy the correct machining unit, apply its geometric offset, control shared motors/feeds and reconcile pneumatic/tool state.

## G2. Biesse Rover family provides strong real-world evidence

Useful threads include:

- https://forum.linuxcnc.org/38-general-linuxcnc-questions/32002-biesse-rover-346-retrofit
- https://forum.linuxcnc.org/30-cnc-machines/44093-another-biesse-rover-322
- https://forum.linuxcnc.org/10-advanced-configuration/58464-rover-336-retrofit-horizontal-drills-and-tool-offsets-in-linuxcnc

Observed machine features across these examples include:

- multiple routing spindles;
- 7-tool ATC in a current Rover 336 project;
- roughly 25 vertical drills plus horizontal X/Y drill heads;
- 31/32-drill banks on older machines;
- aggregate saws;
- vacuum pods;
- shared VFD selection across several spindles on some older machines;
- large distributed 24 V I/O;
- pneumatic deployment per drill/spindle;
- analog servo systems retained during retrofit.

A particularly important community pattern is using the LinuxCNC tool table not merely for Z length but for full XYZ/other-axis offsets representing physically displaced drill bits or heads. Tool selection/M6 remap then activates the required spindle/drill/aggregate and corresponding geometry.

This architecture needs a source/config-based validation pass before it is promoted as canonical, but it is clearly a major 3400 direction.

## G3. Drill bank control is a separate machine-control problem

An industrial woodworking drill bank may have one common motor turning many drill spindles while each drill is pneumatically deployed independently. Consequences:

- each drill can behave like a logical tool with its own geometric offset;
- multiple drills may be deployed as a group for hole patterns;
- left-hand/right-hand drill rotation may be mechanically fixed by gearing;
- motor-running state and pneumatic deployment state are separate;
- the controller needs to know which heads are physically down before motion.

This is fundamentally different from a normal milling-machine ATC and deserves a dedicated subtrack.

## G4. Horizontal drilling and aggregate heads challenge simple XYZ assumptions

The current Rover 336 discussion explicitly asks how to model horizontal drills and tool offsets. Future research should determine when these can be represented by:

- tool-table XYZ offsets plus machine-specific remap;
- alternate spindle/head selection;
- switchable kinematics;
- rotary/aggregate axes;
- CAM/postprocessor transformation.

Do not freeze one representation before inspecting production configs.

---

# H. Multiple spindles / multiple Z heads

LinuxCNC supports multiple spindle channels, but woodworking machines may also have multiple physical heads that are offset from each other and may move/deploy independently.

Community examples show several architectures:

1. one active Z/head at a time with tool-selection logic routing spindle/VFD or step/dir signals;
2. multiple spindle channels with independent commands;
3. custom/switchable kinematics so G-code can retain XYZ semantics while changing active physical head;
4. tool-table offsets for fixed displaced heads/drills.

Relevant forum discussion:

- https://forum.linuxcnc.org/10-advanced-configuration/42476-independant-multiple-z-axes
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/54492-configuring-dual-independent-z-axis

This is a high-value deep pass because the best architecture depends strongly on whether the heads can operate simultaneously, share a Z carriage, share a VFD, have separate tool length, or require CAM awareness.

---

# I. CAM, nesting and woodworking production workflow

## I1. Commercial woodworking software demonstrates a different operator mental model

Current commercial woodworking systems emphasize **workpiece features and machining operations**, not raw G-code as the primary programming surface.

HOMAG woodWOP currently exposes:

- 3D workpiece representation;
- boring, routing/pocketing and saw operations;
- clamping/vacuum-cup representation;
- tool management;
- optional CAM and collision simulation;
- nesting extensions.

Biesse B_SOLID/B_NEST similarly combines 3D CAD/CAM machining with nesting, while SCM Maestro emphasizes workpiece-oriented drilling/machining and simulation.

References:

- https://www.homag.com/en/software-detail/software/work-preparation/cnc-programming-software-woodwop
- https://biesse.com/ww/en/software/
- https://www.scmgroup.com/en/scmwood/products/maestro-digital-systems/software.c102273

3400 should therefore study the boundary between:

- **job/CAM intent:** panel geometry, hole features, grooves, pockets, saw cuts, nesting, clamp/pod placement, tool selection;
- **LinuxCNC controller authority:** actual trajectory, active head/tool state, machine offsets, spindle/aggregate actuation, vacuum/pneumatic state, faults and recovery.

## I2. Open-source adjacent projects

Open-source nesting projects such as Deepnest are useful for understanding generic 2D part placement and DXF/SVG nesting concepts:

- https://github.com/deepnest-next/deepnest

They are **not** evidence for full industrial woodworking workflow. Drill banks, vacuum pods, aggregate heads, grain direction, machining-side constraints and machine-specific clamping require additional logic.

Future research should also inspect open CAD/CAM ecosystems for reusable feature/operation concepts without confusing them with LinuxCNC machine-control behavior.

---

# J. Failure classes to carry through 3400

1. Gantry sides home to inconsistent squareness.
2. One gantry drive faults or loses position while the other remains enabled.
3. Spindle command exists but VFD is not ready/at speed.
4. VFD communication fails while command state remains stale.
5. M6 completes mechanically but LinuxCNC tool identity/TLO is wrong.
6. Tool releases before zero-speed or safe position is proven.
7. Air pressure falls during an ATC or drill-head deployment.
8. Rack/carousel position is lost after a chip/burr mechanically pushes it.
9. Tool setter is already active or never triggers.
10. A stale G43/TLO corrupts automatic tool measurement.
11. Vacuum zone/pod state does not match the loaded job or fixture.
12. Vacuum is lost while cutting but normal motion continues without an operator-visible fault policy.
13. Dust shoe or ATC rack remains in the motion envelope.
14. Dust collector/vacuum auxiliary state is not reconciled after pause/abort.
15. Wrong drill or aggregate deploys because logical tool identity and physical output mapping disagree.
16. Shared VFD is switched to the wrong spindle or switched while energized.
17. Horizontal/offset head geometry is applied twice or not at all between CAM and LinuxCNC.
18. Manual and automatic auxiliary controls fight each other because authority is undefined.
19. A recovered/run-from-line program restores motion without reconstructing required spindle, vacuum, head and dust state.
20. Ordinary LinuxCNC I/O is incorrectly treated as the sole safeguarding layer.

---

# K. Recommended 3400 study order after breadth pass

## 3400-R1 — approachable gantry-router baseline

Deep-source/config trace the Funkenjaeger router and one contrasting small-shop config.

Focus:

- XYYZ gantry homing/squaring;
- spindle/VFD ready/fault path;
- manual versus automatic tool change;
- fixed tool setter versus work touch plate;
- dust shoe and compressed-air dependencies;
- operator HMI/manual recovery.

## 3400-R2 — router ATC state machines

Compare at least three mechanisms:

- fixed linear/rack tool forks;
- carousel (AXYZ 4008);
- manually exchanged ATC-capable spindle as a staged architecture.

Trace M6/remap, tool-prep, tool-change completion, TLO update, air pressure, spindle zero speed and interrupted-change recovery.

## 3400-R3 — vacuum/dust/workholding production workflow

Collect real configs for:

- spoilboard vacuum pump + zones;
- vacuum pressure sensing;
- pod/cup workholding;
- automatic dust collection/dust shoe;
- manual/automatic auxiliary authority;
- pause/abort/restart reconciliation.

## 3400-I1 — industrial woodworking drill banks and aggregate heads

Deep-read Biesse/WEEKE/SCM retrofit threads and any downloadable configs.

Trace:

- logical tool identity;
- full XYZ offsets;
- pneumatic head deployment;
- common drill-bank motor;
- horizontal drill mapping;
- saw aggregate;
- multi-spindle/shared-VFD logic;
- distributed I/O.

This is probably the highest-value uniquely-3400 branch.

## 3400-I2 — industrial workholding and CAM/post boundary

Study:

- vacuum pod/zone representation;
- panel stops and clamps;
- part orientation and datum;
- drilling/groove/saw feature handoff;
- nesting and grain/material constraints;
- how a LinuxCNC post should encode head/tool/fixture intent without duplicating machine geometry.

Use commercial woodworking workflows for domain concepts but freeze LinuxCNC behavior only from inspectable implementations/source.

## 3400-I3 — multiple heads / alternate kinematics

After real machine evidence is collected, compare:

- tool-table-offset model;
- switchable kinematics;
- multiple spindle channels;
- routed/shared spindle command;
- simultaneous versus mutually exclusive head use.

## 3400-H1 — router/woodworking HMI and recovery playbook

Define an operator diagnostic surface showing at least:

- homed/squared gantry state;
- active logical tool/head/spindle;
- actual tool-in-spindle identity;
- spindle ready/at-speed/fault;
- active TLO and work coordinate;
- toolchanger phase/pocket;
- air pressure;
- vacuum state/zone and pressure where available;
- dust collection/dust shoe state;
- deployed drill/aggregate heads;
- auxiliary manual/auto authority;
- safety-chain observation without claiming safety authority.

---

# L. Candidate labs only if source leaves a real gap

Do not launch labs merely because 3400 has started. Source/config/build-diary evidence is currently higher information gain.

Potential later experiments:

- paired-gantry homing with one switch stuck/late;
- interrupted M6 and tool-identity/TLO reconciliation;
- queued/aborted tool-length probe with stale TLO;
- vacuum-loss state-machine response in a simulated job;
- shared-VFD head-selection sequencing and impossible-state rejection;
- drill-bank logical-tool-to-physical-output mapping test;
- multi-head switchkins/tool-offset comparison if real configs leave the architecture ambiguous.

---

# M. Promotion boundary

The breadth survey is sufficient to begin deep 3400 work but not to build a final playbook yet.

Before 3400 can be considered mature, preserve at least:

1. one complete modern small-shop router config with gantry, ATC, tool setter, spindle/VFD and dust/pneumatic integration;
2. one complete industrial woodworking retrofit showing drill bank or multiple head control;
3. one real vacuum/pod/zone implementation with fault/recovery behavior;
4. one defensible model for horizontal/offset heads backed by actual configuration evidence;
5. ATC recovery evidence for at least rack and carousel mechanisms;
6. a CAM/controller boundary that accounts for woodworking feature operations and clamping/workholding rather than treating every machine as a generic mill.

## Breadth conclusion

3400 appears to have **high community and transfer value**. The conventional router half is approachable and well supported by LinuxCNC's existing primitives, making it a good practical teaching track. The industrial woodworking half adds substantial unique depth through drill banks, multiple heads, vacuum pods, distributed pneumatics and feature-oriented CAM workflows. That industrial branch is likely where most of the new 3000-level learning will come from.
