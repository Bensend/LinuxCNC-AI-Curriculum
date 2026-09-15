# Safety Simulator — Open-Source Reuse Research Project

Date: 2026-09-15
Status: ACTIVE RESEARCH

## Question
Can the Practical Machine Safety Engineering course build its proposed browser Safety Sandbox by adapting or embedding proven open-source circuit/PLC simulators instead of writing a general simulator from scratch?

The target is deliberately narrower than SPICE or machine physics: learners wire relay/contactor/safety blocks into machine-family examples, operate the machine, deliberately inject faults, and observe commanded state, actual device state, hazardous-energy state, diagnostics, reset/restart behavior and residual risk.

## Required capability
The reusable core must permit or be adaptable to browser-visible wiring/schematic interaction, reusable components/subcircuits, deterministic state propagation, commanded-versus-actual device state, linked contacts/feedback, deliberate fault overrides, machine-level hazardous-energy outputs, automated fault campaigns, and data-driven machine-family scenarios.

The teaching engine MUST NOT infer PL, SIL or Category from a toy simulation. It demonstrates failure paths and verification reasoning; formal performance claims require actual device data, architecture, calculations and validation evidence.

## Candidate A — DigitalJS / digitaljs_online

SOURCE-CONFIRMED from public README/source on 2026-09-15:
- JavaScript digital-circuit simulator explicitly intended as a teaching tool.
- Installable by NPM or browser bundle and instantiable/displayable from another application.
- Circuit input is JSON with `devices`, `connectors` and `subcircuits`.
- Includes stateful primitives including D flip-flops/FSMs plus buttons/lamps and hierarchical subcircuits.
- BSD-2-Clause.
- `digitaljs_online` is a separate BSD-2-Clause web application; its demonstration has a Node backend, which does not imply our simulator needs one.
- **Source-level finding:** `HeadlessCircuit` accepts a `cellsNamespace` option and merges it with the built-in cell namespace. `_makeGraph()` resolves a device type from that namespace before falling back to built-ins/subcircuits, instantiates that class, and wires graph events for input/output signal changes. This is direct evidence that custom device classes can be injected without forking the core merely to add a new named component.
- The same constructor permits selecting a simulation engine and engine options, and the graph tracks `inputSignals`/`outputSignals` changes. This materially lowers the risk of representing a custom relay/contactor device with internal fault state.

Assessment: **highest-priority browser-engine candidate.** The previous largest uncertainty—whether custom safety/electromechanical components require invasive core modification—is partially resolved in DigitalJS's favor. Remaining source questions are how a custom cell declares multiple ports, how sequential/internal state is scheduled, and whether one custom relay cell or a relay-plus-linked-contact group best preserves realistic wire topology.

Source: https://github.com/tilk/digitaljs
Source: https://github.com/tilk/digitaljs_online
Source trace: `src/circuit.mjs` at commit `a77a6b3a916996e215e6c33c75ffe05dc6f55e3d`.

## Candidate B — PLC_Simulator (ironhero1544)

SOURCE-CONFIRMED from public README on 2026-09-15:
- GPL-3.0 C++20 desktop simulator.
- Interactive wiring canvas with drag/drop placement, automatic routing and connection management.
- Component library includes PLC I/O, switches, sensors, relays and pneumatic elements.
- OpenPLC-compatible ladder conversion/execution plus custom electrical/pneumatic/mechanical simulation and Box2D integration.
- Project packages carry wiring, ladder and RTL data.

Assessment: **high-value architecture/component-behavior reference, lower-priority direct web foundation.** Its desktop C++/OpenGL/ImGui architecture and GPL license make direct reuse a larger commitment for a lightweight static web course. Audit its component model, connection representation, project serialization and simulation update loop before independently reinventing those concepts.

Source: https://github.com/ironhero1544/PLC_Simulator

## Candidate C — CircuitJS1

SOURCE-CONFIRMED public README: browser electronic circuit simulator, GWT adaptation of Falstad's simulator, embedding/import/export support, GPL-2.0-or-later.

Assessment: **reference/fallback, not preferred starting point.** It solves analog/electrical equations beyond the Safety Sandbox requirement. Use only if logic-level candidates cannot answer a concrete lesson need.

Source: https://github.com/sharpie7/circuitjs1

## Additional discovery candidates
- **KronEditor:** browser-native PLC IDE with React/ReactFlow frontend and local Go agent; useful editor/UX reference, not yet evidence of the needed electromechanical fault model. Source: https://github.com/Krontek/KronEditor
- **NiRuLogic:** browser-served IEC 61131-3 ladder editor/simulator for inexpensive Arduino/education workflows; useful live-power-flow teaching reference. Source: https://github.com/NiRuLabs/NiRuLogic
- **SemaPLC:** open-source agentic PLC IDE using OpenPLC/matiec-family tooling and an MIT web layer; possible future AI exercise reference, while ordinary PLC execution remains outside personnel-safety authority. Source: https://github.com/midea-ai/SemaPLC

## Architecture decision gate
Do not choose a fork yet.
1. Continue **DigitalJS** source audit: custom cell base/ports, state/update propagation, rendering hooks, serialization/layout and relay fault override.
2. Audit **PLC_Simulator** relay/E-stop/contact/wire abstractions, simulation update flow, serialization and physical-domain coupling. Study architecture carefully across the GPL boundary.
3. Inspect **CircuitJS1** only if DigitalJS cannot cleanly express the required behavior.
4. Compare with a purpose-built minimum state graph: `ordinary request -> safety input -> safety authorization -> energy-removal device actual state -> hazardous-energy state -> diagnostic witness`.

## Minimum reuse experiment — SIM-REUSE-01
After source audit, answer one question: can the candidate represent a coil-commanded relay/contactor with NO power contact + NC auxiliary feedback, inject `POWER_CONTACT_WELDED_CLOSED`, and correctly show coil command OFF while hazardous-energy path remains ON and EDM inhibits rearm?

Required distinct states: coil command; actual mechanical/device state; power-contact actual state; auxiliary-feedback actual state; safety authorization; hazardous-energy path; reset request; EDM healthy; latched fault/rearm inhibit.

Required fault toggles: power contact welded closed; coil/open-wire failure; auxiliary feedback stuck/misreporting; reset held; ordinary-control/LinuxCNC output frozen asserted.

Pass criterion: represent these as distinct physical/diagnostic states without fragile per-lesson special-case code. No analog coil simulation is required.

## Machine-family reuse target
Reuse the same component/fault model across mill/router spindle energy, lathe examples, plasma motion versus process-energy authority, robot/cell gate and STO examples, and press-brake hydraulic/gravity examples where electrical de-energization explicitly does **not** prove removal of physical hazard. Machine physics may initially be state abstractions.

## Licensing / provenance rule
Before copying source rather than studying architecture, record exact license consequences. Prefer permissive reusable foundations where capability is comparable. GPL projects remain valuable references and may be usable if the project intentionally accepts their distribution obligations. Never copy LunchBox Sessions implementation/content; use only the general teaching pattern independently.

## Current recommendation
**Continue DigitalJS first, PLC_Simulator second.** DigitalJS now has source-confirmed custom-cell injection through `cellsNamespace`, strengthening it as the likely foundation for a small browser prototype. The likely outcome remains either DigitalJS with custom safety cells or a very small independent state engine informed by both projects rather than a full desktop/analog simulator port.

No compute is justified yet. Any later automated experiment must use only `[self-hosted, openpressbrake]` if repository compute is required.