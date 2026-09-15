# Safety Simulator — Open-Source Reuse Research Project

Date: 2026-09-15
Status: ACTIVE RESEARCH

## Question
Can the Practical Machine Safety Engineering course build its proposed browser Safety Sandbox by adapting or embedding proven open-source circuit/PLC simulators instead of writing a general simulator from scratch?

The target is deliberately narrower than SPICE or machine physics: learners wire relay/contactor/safety blocks into machine-family examples, operate the machine, deliberately inject faults, and observe commanded state, actual device state, hazardous-energy state, diagnostics, reset/restart behavior and residual risk.

## Required capability
The reusable core must permit or be adaptable to:
- browser-visible wiring/schematic interaction;
- reusable components/subcircuits;
- deterministic state propagation;
- separate commanded versus actual contact/device state;
- mechanically linked contacts and contactor auxiliary feedback;
- fault overrides such as welded contact, open coil/wire, stuck contact/device, selected shorts, held reset, guard defeat and stale/frozen ordinary control;
- machine-level outputs that are not merely Boolean lamps: hazardous-energy authority, stored-energy state, safe-state witness and diagnostics;
- automated replay of the same fault campaign against alternative low-cost and commercial-style architectures;
- data-driven lesson/scenario definitions so mill, lathe, router, plasma, press-brake, robot and cell examples do not require separate engines.

The teaching engine MUST NOT infer PL, SIL or Category from a toy simulation. It demonstrates failure paths and verification reasoning; formal performance claims require the actual device data, architecture, calculations and validation evidence.

## Candidate A — DigitalJS / digitaljs_online

SOURCE-CONFIRMED from the public project README on 2026-09-15:
- DigitalJS is a JavaScript digital-circuit simulator explicitly intended as a teaching tool.
- It can be installed as an NPM package or consumed as a browser bundle and instantiated/displayed from another application.
- Circuit input is JSON with top-level `devices`, `connectors` and `subcircuits` objects.
- It includes stateful primitives including D flip-flops and finite-state machines, plus buttons/lamps and hierarchical subcircuits.
- Main project license is BSD-2-Clause.
- `digitaljs_online` is a separate BSD-2-Clause web application; its published demonstration uses a Node backend, so the online frontend is not evidence that our eventual training app needs a server.

Assessment: **highest-priority browser-engine candidate.** Its embeddable JS API, inspectable teaching orientation, JSON graph and subcircuits closely match the desired scenario/component model. The key unknown is how cleanly custom electromechanical components with fault-overridden actual state can be added without fighting assumptions that every connection is a conventional directed digital signal.

Source: https://github.com/tilk/digitaljs
Source: https://github.com/tilk/digitaljs_online

## Candidate B — PLC_Simulator (ironhero1544)

SOURCE-CONFIRMED from the public README on 2026-09-15:
- GPL-3.0 C++20 desktop simulator.
- Interactive wiring canvas with drag/drop placement, automatic routing and connection management.
- Component library includes PLC I/O, switches, sensors, relays and pneumatic elements.
- Includes OpenPLC-compatible ladder conversion/execution and a custom electrical/pneumatic/mechanical simulation engine with Box2D integration.
- Project packages carry wiring, ladder and RTL data.

Assessment: **high-value architecture/component-behavior reference, lower-priority direct web foundation.** It already attacks much of the wiring/PLC/machine-domain problem but its C++/OpenGL/ImGui desktop architecture and GPL license make direct reuse a larger commitment for a lightweight static web course. Audit its component model, connection representation, project serialization and simulation update loop before independently reinventing those concepts.

Source: https://github.com/ironhero1544/PLC_Simulator

## Candidate C — CircuitJS1

SOURCE-CONFIRMED from the public project README on 2026-09-15:
- browser electronic circuit simulator adapted from Paul Falstad's simulator using GWT;
- supports embedding and circuit import/export/startup parameters;
- GPL-2.0-or-later;
- mature public project with a large user/fork base.

Assessment: **reference/fallback, not preferred starting point.** It solves analog/electrical equations far beyond the Safety Sandbox requirement and brings a mature GWT/GPL codebase. It may be useful if later lessons need contact/coil/electrical transient realism, but using analog simulation for every safety lesson would increase complexity without improving the main learning objective.

Source: https://github.com/sharpie7/circuitjs1

## Additional discovery candidates

### KronEditor
SOURCE-CONFIRMED public README: open-source browser-native PLC IDE with React/ReactFlow frontend and local Go agent; includes local PLC simulation and MIT-licensed project claims. It is primarily a PLC programming/deployment environment, not an electromechanical safety fault simulator. ReactFlow/editor patterns may be useful to study for browser wiring UX.

Source: https://github.com/Krontek/KronEditor

### NiRuLogic
SOURCE-CONFIRMED public README: browser-served IEC 61131-3 ladder editor/simulator aimed at inexpensive Arduino/education workflows. Useful for studying approachable ladder/live-power-flow teaching UX; not yet evidence of the relay physical-fault model we need.

Source: https://github.com/NiRuLabs/NiRuLogic

### SemaPLC
SOURCE-CONFIRMED public README: open-source agentic PLC IDE using OpenPLC/matiec-family tooling and an MIT web layer. Useful later if AI-generated PLC exercises become desirable, but ordinary PLC execution must remain separate from personnel-safety authority.

Source: https://github.com/midea-ai/SemaPLC

## Architecture decision gate
Do not choose a fork yet. Perform source-level audits in this order:

1. **DigitalJS:** find component base classes, state/update propagation, custom-device extension points, rendering hooks, serialization/layout handling and whether a relay can own multiple linked contacts whose *actual* state is overridden by an injected fault.
2. **PLC_Simulator:** inspect relay/E-stop/contact/wire/component abstractions, simulation tick/update flow, project serialization and pneumatic/mechanical coupling. Extract concepts that are license-compatible with the intended project strategy; do not copy code casually across license boundaries.
3. **CircuitJS1:** only inspect relay/switch fault-relevant primitives and embedding architecture if DigitalJS cannot express the needed behavior cleanly.
4. Compare those findings with a purpose-built engine whose minimum state graph is `ordinary request -> safety input -> safety authorization -> energy-removal device actual state -> hazardous-energy state -> diagnostic witness`.

## Minimum reuse experiment — SIM-REUSE-01
After source audit, implement only enough to answer one question:

> Can the candidate represent a coil-commanded relay/contactor with NO power contact + NC auxiliary feedback, inject `POWER_CONTACT_WELDED_CLOSED`, and correctly show that coil command can be OFF while the hazardous-energy path remains ON and EDM inhibits rearm?

Required states:
- coil command;
- actual mechanical/device state;
- power-contact actual state;
- auxiliary-feedback actual state;
- safety authorization;
- hazardous-energy path;
- reset request;
- EDM healthy;
- latched fault/rearm inhibit.

Required fault toggles:
- power contact welded closed;
- coil/open-wire failure;
- auxiliary feedback stuck/misreporting;
- reset held;
- ordinary-control/LinuxCNC output frozen asserted.

Pass criterion: the engine can represent these as distinct physical/diagnostic states without fragile per-lesson special-case code. No analog coil simulation is required.

## Machine-family reuse target
If SIM-REUSE-01 passes, the same component/fault model should be reused across:
- mill/router spindle energy;
- lathe spindle/chuck-related examples;
- plasma motion versus process-energy authority;
- robot/cell gate and STO examples;
- press-brake hydraulic/gravity examples where electrical de-energization explicitly does **not** prove removal of physical hazard.

Machine physics may initially be state abstractions. Add richer physics only when a lesson has a concrete unresolved teaching question that logic/state modeling cannot answer.

## Licensing / provenance rule
Before copying source rather than merely studying architecture, record the exact repository license and the consequence for the Safety Sandbox distribution model. Prefer permissively licensed reusable foundations where capability is comparable. GPL software remains valuable to study and may be usable if the project intentionally accepts the corresponding distribution obligations. Never copy LunchBox Sessions implementation/content; use only the general teaching pattern independently.

## Current recommendation
**Audit DigitalJS first, PLC_Simulator second.** DigitalJS currently appears closest to a small browser-native reusable engine; PLC_Simulator appears closest to the desired industrial wiring/component experience. The likely best outcome may be DigitalJS or a very small independent state engine informed by both projects rather than porting a full desktop/analog simulator.

No compute is justified yet. This is source/interface research; any later automated experiment must use only `[self-hosted, openpressbrake]` if repository compute is required.