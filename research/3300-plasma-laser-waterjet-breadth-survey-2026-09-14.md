# 3300 Plasma / Laser / Waterjet — breadth survey

Date: 2026-09-14

Status: **BREADTH / TRACK-MAP PASS**

Pinned LinuxCNC source revision for source-level claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

## Purpose

Before deep-diving one cutting process, map the entire 3300 specialization so later work does not overfit plasma simply because QtPlasmaC has the richest public implementation.

The 3300 track has three related but materially different process classes:

- plasma;
- laser;
- waterjet.

All three share gantry motion, process enable, height/standoff, CAM/postprocessing, material/process recipes, cut recovery and operator workflow concerns. Their process physics and therefore their control loops are not interchangeable.

## High-level result

The public LinuxCNC evidence is strongly asymmetric:

1. **Plasma is mature and first-class.** QtPlasmaC + `plasmac.comp` provide an integrated process controller, HMI, material handling, torch-height control, probing, cut recovery and power-source communication.
2. **Laser has strong native realtime building blocks but a thinner integrated workflow.** The pinned tree contains `laserpower.comp`, `raster.comp`, a runnable laser simulation and synchronized analog/digital motion outputs. These form a credible control foundation, but there is no QtPlasmaC-equivalent laser process manager in the inspected tree.
3. **Waterjet is clearly used with LinuxCNC in real retrofits, but no dedicated waterjet controller comparable to QtPlasmaC was found in this bounded survey.** The likely architecture is general LinuxCNC motion + machine-specific I/O/state logic + CAM/postprocessing, with significantly more integration work left to the machine builder.

This asymmetry should determine research order, not imply that plasma concepts can simply be copied to laser or waterjet.

---

# A. Common 3300 architecture

A useful generic decomposition is:

1. **Motion / geometry**
   - gantry X/Y;
   - tandem-joint homing and squaring where used;
   - process Z or standoff axis;
   - optional rotary/bevel/head axes;
   - path blending and synchronized outputs.
2. **Process command**
   - process enable/on/off;
   - requested process power/current/pressure;
   - assist-gas / abrasive / auxiliary commands;
   - material/recipe selection.
3. **Process readiness and feedback**
   - plasma Arc OK / arc voltage;
   - laser source-ready / shutter / chiller / gas / focus feedback;
   - waterjet pump-pressure / valve / abrasive / head readiness;
   - breakaway and contact/probe signals.
4. **Height / standoff / focus control**
   - plasma IHS + THC;
   - laser fixed focus, Z/focus axis or capacitive height control depending machine class;
   - waterjet standoff and collision/head-height logic.
5. **CAM / postprocessor / process recipe**
   - kerf compensation;
   - lead-in/out;
   - pierce strategy;
   - feed and process-power changes;
   - holes/small-feature handling;
   - nesting.
6. **Recovery / operator workflow**
   - pause/abort/run-from-line;
   - cut recovery;
   - re-pierce/restart decisions;
   - consumables/process-state reconciliation;
   - diagnostic HMI.
7. **Independent safeguarding**
   - LinuxCNC process logic is ordinary machine control, not a replacement for hazard-appropriate safeguarding and energy isolation.

The cross-track teaching rule is to keep **motion ownership**, **process authority**, **readiness feedback**, **height/focus control**, **CAM intent** and **safety boundary** separate even when a product GUI presents them together.

---

# B. Plasma breadth map

## B1. QtPlasmaC / PlasmaC should be the anchor implementation

Current LinuxCNC documentation describes QtPlasmaC as a QtVCP plasma GUI using the `plasmac` component. The development documentation supports up to five axes and three principal operating modes:

- mode 0: arc voltage is used for both calculated Arc OK and THC;
- mode 1: arc voltage is used for THC and a separate digital Arc OK is used for transfer confirmation;
- mode 2: external Arc OK plus external up/down THC signals.

Primary source/documentation:

- `docs/src/plasma/qtplasmac.adoc`
- `src/hal/components/plasmac.comp`
- `share/qtvcp/screens/qtplasmac/qtplasmac_handler.py`
- https://linuxcnc.org/docs/devel/html/en/plasma/qtplasmac.html

## B2. Plasma process state is much richer than torch on/off

The breadth pass identifies these distinct process concepts for later source tracing:

- initial height sensing / material probing;
- float switch and/or ohmic probing;
- breakaway sensing;
- probe height / pierce height / cut height;
- pierce delay;
- optional puddle-jump height and delay;
- Torch On request;
- Arc OK / transfer confirmation;
- arc-start retry/failure timeout;
- arc-lost detection;
- THC enable delay;
- commanded versus sampled/auto arc voltage;
- corner-lock / void-lock style THC inhibition;
- cut end / torch off / retract;
- paused-motion cut recovery;
- consumable-change positioning;
- scribing and spotting as distinct process tools.

The QtPlasmaC handler itself tracks a large operator/process state surface including homing, consumable change, framing, interpolation running/paused, offsets, ohmic tests, probe tests, torch enable/pulse and manual-cut state. This is evidence that the HMI is not merely a thin shell around ordinary XY motion.

## B3. Plasma height control is a central LinuxCNC specialization

LinuxCNC's plasma primer explicitly identifies **external offsets** as the mechanism that enabled integrated realtime torch-height correction without rewriting the nominal path.

QtPlasmaC THC activates only under qualified process conditions, including cut velocity and delay requirements, rather than continuously treating arc voltage as a generic Z position command.

Important future deep-pass questions:

- exact `plasmac.comp` state transitions;
- where external Z offset is inserted and limited;
- THC inhibit ownership at corners/voids/small holes;
- arc-voltage filtering/sample validity;
- pause/abort/recovery interaction with active external offsets;
- fault paths for probe, arc start, arc loss and breakaway.

## B4. Material/process recipe handling is first-class

QtPlasmaC material files can hold process values such as:

- kerf width;
- THC enabled state;
- pierce height/delay;
- puddle-jump height/delay;
- cut height;
- cut speed;
- cut amps;
- cut volts;
- pause-at-end;
- gas pressure;
- cut mode.

QtPlasmaC includes conversion paths for manually entered recipes and selected CAM/tool libraries. This makes **recipe provenance and active recipe identity** a real control/HMI topic, not only a CAM topic.

## B5. Power-source communications are separate from realtime motion

LinuxCNC includes `pmx485`, a **non-realtime** userspace HAL component for Hypertherm Powermax Modbus ASCII over RS485. The documentation warns that computer loading/latency can cause communication loss.

Research consequence:

- process-source setpoints/telemetry over RS485 must not be confused with realtime trajectory execution;
- communication health should be explicit in HMI/recovery logic;
- external E-stop/safety functions remain outside this userspace communication path.

## B6. Plasma CAM/postprocessing is part of the specialization

The LinuxCNC plasma primer calls out CAM/postprocessors as the CAD-to-machine bridge and discusses SheetCam, Fusion and simpler vector workflows.

Current 2026 forum discussion reinforces an important boundary: QtPlasmaC controls plasma process behavior and includes convenience conversational features, but it is **not itself a general plasma CAM package**. Nesting, lead-in/out generation, hole strategy and similar geometry/process planning may live upstream.

Later work should inspect at least:

- a QtPlasmaC postprocessor;
- material-number handoff;
- synchronized THC disable/enable around holes;
- velocity reduction around small features;
- overcut / torch-off synchronization;
- run-from-line and recovery implications of generated process codes.

## B7. Plasma multi-axis branches

QtPlasmaC can support configurations with more than XYZ, and LinuxCNC itself can support custom kinematics. Public forum evidence exists for 5-axis/bevel plasma concepts and tangential/bevel heads, but the postprocessor/process-quality problem is significant.

Treat these as later subtracks:

- pipe/rotary plasma;
- bevel heads;
- true coordinated multi-axis plasma;
- plasma + auxiliary milling/scribing.

Do not infer that five LinuxCNC axes automatically provide production bevel quality; torch physics, consumables, kinematics and CAM/postprocessing remain separate requirements.

---

# C. Laser breadth map

## C1. LinuxCNC has native realtime laser-power logic

Pinned source contains `src/hal/components/laserpower.comp`.

Its core design principle is important:

- commanded laser power is scaled by **actual velocity / requested velocity** so power is reduced when the machine slows around corners;
- this addresses corner overburn/uneven energy density;
- vector and raster modes are separate.

Pins include requested/current velocity, min/max power, vector/raster power, distance-to-go and power output.

This is substantially more specialized than treating a laser as a spindle with a static PWM value.

## C2. LinuxCNC also contains a realtime raster pipeline

Pinned source contains:

- `src/hal/components/raster.comp`;
- `configs/sim/axis/laser/laser.hal`.

`raster.comp` consumes a programmed raster line through a HAL port, relates pixel data to axis position and produces a realtime power value. The sample laser HAL combines:

- motion type;
- synchronized analog outputs;
- requested/current velocity;
- distance-to-go;
- `laserpower`;
- `raster`.

This makes raster engraving a legitimate 3300 LinuxCNC topic rather than an external-software-only topic.

## C3. Synchronized outputs are a major laser contract

LinuxCNC M-codes provide:

- M62/M63: synchronized digital output changes at the next motion boundary;
- M64/M65: immediate digital outputs that can break blending;
- M67: synchronized analog output change at the next motion boundary;
- M68: immediate analog output change.

Forum guidance for lasers specifically emphasizes using realtime HAL scaling and M67-style synchronized power changes rather than userspace/Python timing for motion-critical power control.

Important subtlety: a queued synchronized output requires a following motion command to take effect. End-of-program laser-off/power-zero semantics therefore need an explicit design, not an assumption that the last queued value will somehow apply after motion ends.

## C4. Laser process specialization needs to split by machine type

Do not create one generic 'laser' architecture. At minimum the curriculum should distinguish:

- CO2 gantry lasers;
- fiber sheet-metal lasers;
- engraving/raster use;
- cutting/vector use;
- galvo systems as a possible later/non-gantry branch.

Likely machine-specific surfaces include:

- laser source enable/ready/fault;
- shutter or gate;
- coolant/chiller and flow proof;
- assist gas and pressure;
- exhaust;
- focus or capacitive height loop;
- pierce timing;
- PWM/analog/modulation interface;
- corner/feature energy management;
- lens/nozzle/head collision state;
- door/enclosure safeguarding.

These must be evidenced from real builds/source rather than invented from plasma analogies.

## C5. Adjacent open-source laser software is worth mining

MeerK40t is an open-source laser control project supporting several K40/GRBL/fiber/Ruida-class devices. Its public design includes vector/raster workflows and pulse-modulation concepts.

Reference:

- https://github.com/meerk40t/meerk40t

Use adjacent projects for **workflow and domain concepts**, not as proof of LinuxCNC timing or HAL behavior.

---

# D. Waterjet breadth map

## D1. Public LinuxCNC waterjet usage exists, but the integration is less standardized

Forum evidence includes:

- long-running converted FLOW waterjet installations;
- 5-axis CMS retrofit discussions;
- dual-head waterjet gantries;
- panel control of multiple nozzles and abrasive senders;
- new/DIY waterjet users generating toolpaths for LinuxCNC.

Examples:

- https://forum.linuxcnc.org/27-driver-boards/48127-water-jet-5axis-using-parker-servo-drive-what-mesa-board-setup
- https://forum.linuxcnc.org/24-hal-components/47189-linuxcnc-error-message-on-converted-flow-waterjet
- https://forum.linuxcnc.org/10-advanced-configuration/27856-waterjet-panel-buttons
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/56099-linuxcnc-dual-head-gantry-setup-assistance-request

A bounded repository search did **not** find a dedicated upstream waterjet process component analogous to `plasmac.comp`. Record this as a research gap, not proof that no such community implementation exists.

## D2. Waterjet process ownership should be researched as its own state machine

Likely evidence targets for real implementations:

- pump/intensifier ready;
- high-pressure permissive;
- cutting-water valve;
- abrasive feeder command and confirmation where available;
- water-only versus abrasive cutting;
- pierce delay / low-pressure pierce / special brittle-material pierce strategies;
- lead-in after confirmed pierce;
- abrasive lead/lag relative to water;
- cut-end flush/tail sequence;
- standoff/head-height control;
- nozzle/head collision or breakaway;
- pressure fault / abrasive fault recovery.

These are **candidate questions**, not yet claimed LinuxCNC-standard behavior.

## D3. High pressure makes the safeguarding boundary especially important

Community retrofit discussion explicitly notes that a waterjet at roughly 2000–4000 bar makes E-stop and independent energy isolation extremely important.

Curriculum treatment must separate:

- LinuxCNC normal command logic;
- pump/valve machine control;
- independent hazard-energy isolation and safety-rated measures appropriate to the real machine.

## D4. Waterjet 5-axis/taper compensation deserves a later deep subtrack

Waterjet machines commonly benefit from angular head motion for taper control. Public LinuxCNC discussion includes 5-axis waterjet retrofits using existing industrial drives.

This branch crosses into:

- custom/head kinematics;
- rotary-axis limits/unwind;
- tool-center-point geometry;
- postprocessing;
- process model/taper compensation.

It should follow a 3-axis process-control baseline rather than become the first waterjet lesson.

---

# E. Cross-process CAM / nesting / recipe boundary

The 3300 specialization needs explicit coverage of what belongs in CAM versus controller.

## CAM typically owns or strongly influences

- nesting;
- part ordering;
- lead-ins/lead-outs;
- kerf side and geometry compensation;
- hole/small-feature strategy;
- process-specific entry strategy;
- optional bevel/taper toolpath;
- process change commands encoded in the post.

## LinuxCNC/controller typically owns or can own

- actual coordinated trajectory;
- synchronized digital/analog outputs;
- machine process state;
- realtime feedback/height loops;
- process readiness and fault response;
- machine-specific recovery;
- operator HMI and diagnostics.

The exact boundary is configurable and must be preserved in each inspected implementation.

---

# F. Failure classes to carry through the whole 3300 track

1. Process command asserted but source never becomes ready.
2. Source ready/Arc OK appears then disappears during the cut.
3. Probe/contact already active before a probing cycle.
4. Probe/contact never occurs.
5. Height/focus feedback freezes or becomes implausible.
6. Motion slows but energy/power does not scale appropriately.
7. Synchronized process-output command has no following move and therefore never applies.
8. Immediate output breaks blending when the programmer expected synchronized behavior.
9. Stale process recipe remains selected after material/tool/process change.
10. Abort leaves process hardware, external offset or auxiliary state unreconciled.
11. Run-from-line restarts motion without rebuilding required process state.
12. Communications fail while non-realtime process-source control is active.
13. Multi-head or multi-tool state is visually correct in the GUI but physically unreconciled.
14. Noise/EMI causes false probe/Arc OK/breakaway events.
15. Safety-chain state is incorrectly inferred from ordinary software state.

---

# G. Recommended 3300 study order after breadth pass

## 3300-P1 — QtPlasmaC process architecture

Deep-source trace `plasmac.comp`, QtPlasmaC HAL/UI wiring and external-offset ownership.

Focus:

- IHS/probe -> pierce -> Arc OK -> cut -> THC -> end/retract;
- state/fault transitions;
- external offsets;
- pause/abort/recovery.

## 3300-P2 — Plasma process feedback and power-source integration

- arc voltage;
- Arc OK;
- THCAD scaling;
- ohmic/float/breakaway;
- Powermax RS485;
- communications-loss and invalid-sensor behavior.

## 3300-P3 — Plasma CAM/material/HMI production workflow

- material files;
- CAM/post processor;
- hole handling / velocity reduction / THC inhibit;
- cut recovery/run-from-line;
- consumables;
- production diagnostics.

## 3300-L1 — Native LinuxCNC laser realtime path

Source trace:

- `laserpower.comp`;
- `raster.comp`;
- `configs/sim/axis/laser`;
- M62/M63/M67/M68 semantics.

Then inspect real laser configs before claiming a production architecture.

## 3300-L2 — Laser machine/process variants

At least one real CO2 implementation and one metal/fiber-oriented implementation if inspectable evidence exists.

Focus on source-ready/fault, gas, focus/height, modulation, pierce and interlocks.

## 3300-W1 — Waterjet implementation hunt and 3-axis process contract

Mine multiple retrofit/build threads/configs from start to finish where possible.

Freeze only behavior evidenced by real machines. Identify pump/water/abrasive/pierce/height/recovery ownership.

## 3300-W2 — Waterjet dual-head and 5-axis/taper branch

Only after the 3-axis process contract is evidence-backed.

## 3300-X — Cross-process playbook

Unify reusable gantry patterns while explicitly preserving process-specific differences.

---

# H. Lab decision after breadth lookup

**No lab should be launched from this survey alone.**

There is already substantial executable upstream plasma and laser source. The next information gain comes from source/config/build-diary tracing.

A lab becomes justified only after a specific behavioral claim remains unresolved, for example:

- plasma external-offset cleanup after abort;
- stale Arc OK/probe sequence interaction;
- queued M67/M62 process command at end-of-path;
- velocity-scaled laser power through a controlled corner/deceleration;
- raster position/pixel boundary behavior;
- water/abrasive lead-lag recovery after pause/abort once a real implementation contract is known.

---

# I. Breadth-pass conclusion

The 3300 track should **not** be organized as 'three gantries that happen to use different cutters.'

The correct organizing principle is:

`trajectory + process command + process readiness + process feedback/height loop + CAM recipe + recovery + safeguarding boundary`

with a separate evidence-backed implementation for plasma, laser and waterjet.

QtPlasmaC makes plasma the best first deep branch because LinuxCNC already exposes most of the architecture in inspectable source. Laser should follow because upstream LinuxCNC already contains specific realtime power/raster components. Waterjet should then receive a deliberately implementation-hunting pass because the ecosystem appears less standardized and therefore carries the highest risk of accidental invention.
