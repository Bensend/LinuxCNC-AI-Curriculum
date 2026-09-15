# Safety Simulator — Open-Source Reuse Research Project

Date: 2026-09-15
Status: ACTIVE RESEARCH

## Question
Can the Practical Machine Safety Engineering course build its proposed browser Safety Sandbox by adapting or embedding proven open-source circuit/PLC simulators instead of writing a general simulator from scratch?

The target is deliberately narrower than SPICE or machine physics: learners wire relay/contactor/safety blocks into machine-family examples, operate the machine, deliberately inject faults, and observe commanded state, actual device state, hazardous-energy state, diagnostics, reset/restart behavior and residual risk.

The teaching engine MUST NOT infer PL, SIL or Category from a toy simulation. It demonstrates failure paths and verification reasoning; formal performance claims require actual device data, architecture, calculations and validation evidence.

## Required capability
The reusable core must permit or be adaptable to browser-visible wiring/schematic interaction, reusable components/subcircuits, deterministic state propagation, commanded-versus-actual device state, linked contacts/feedback, deliberate fault overrides, machine-level hazardous-energy outputs, automated fault campaigns, and data-driven machine-family scenarios.

## Candidate A — DigitalJS / digitaljs_online

SOURCE-CONFIRMED at DigitalJS commit `a77a6b3a916996e215e6c33c75ffe05dc6f55e3d`:
- JavaScript digital-circuit simulator intended as a teaching tool; circuit input is JSON with devices/connectors/subcircuits; BSD-2-Clause.
- `HeadlessCircuit` accepts `cellsNamespace`, merges custom classes with built-ins, resolves `dev.type` from that namespace and instantiates the custom class. Custom safety/electromechanical components therefore do not require a core fork merely for registration.
- The base `Gate` owns explicit `inputSignals` and `outputSignals`, preprocesses arbitrary declared ports, resets each port to an unknown `Vector3vl`, and propagates output changes through graph-connected `Wire` objects. Ports carry IDs, bit widths and directions; therefore a custom multiport device can expose coil/control inputs and multiple contact outputs without changing the wire model.
- Gate serialization is parameter-driven through `_gateParams`/`getGateParams()`, while wires serialize source/target device IDs and ports. A custom relay can preserve fault/configuration fields by adding them to its gate parameters rather than hiding lesson state outside the circuit model.
- The synchronous engine listens for `inputSignals` changes and enqueues the affected gate at `tick + propagation`; at execution it calls `gate.operation(args)` and replaces `outputSignals`. It also provides monitors and tick alarms. This is enough for deterministic contact propagation and bounded discrepancy/rearm timing without analog coil simulation.
- The default `Gate` is combinational. A relay model that needs retained physical/fault state must explicitly own model properties/state and trigger reevaluation when those properties change; merely encoding a welded contact as a Boolean input would blur commanded versus actual state. The source already demonstrates model-property-triggered enqueueing for stateful built-ins (`manualMemChange`, `constantCache`), so a custom fault-state event or engine hook is a plausible clean extension.

### DigitalJS relay representation decision
Working choice: **one multiport electromechanical device cell per physical relay/contactor**, not independent unlinked contact cells for V1.

Reasoning (INFERENCE from source + safety model):
- one object gives a single durable home for coil command, mechanical state, fault state and linked-contact identity;
- multiple NO/NC outputs can be declared as ports and serialized normally;
- a welded power pole can override only that pole while NC auxiliary feedback continues to represent the chosen physical model;
- the UI can still draw contact symbols spatially later, but V1 correctness should not depend on reconstructing mechanical linkage between independent graphical objects.

A later editor may offer linked remote contact symbols backed by one relay device ID if schematic readability demands it. Do not duplicate physical state across free-standing contacts.

Assessment: **highest-priority browser-engine candidate.** Remaining uncertainty is primarily UI/editor ergonomics and the cleanest custom-state reevaluation hook, not basic representability.

Sources: https://github.com/tilk/digitaljs and https://github.com/tilk/digitaljs_online
Source traces: `src/circuit.mjs`, `src/cells/base.mjs`, `src/engines/synch.mjs` at the pinned commit above.

## Candidate B — PLC_Simulator (ironhero1544)

SOURCE-CONFIRMED at repository tree commit `66489904882f6d05c275a6762cebb00010eb2838`:
- GPL-3.0 C++20 desktop simulator with separate source areas for components, wiring, physics, programming and application layers.
- `src/components/emergency_stop_def.cpp` defines an E-stop as a registered component with four electrical ports labelled `NC_1`, `NC_2`, `NO_1`, `NO_2`, its own render function and default internal state. This is a useful precedent for a component owning multiple physical contacts rather than treating the E-stop as a single Boolean.
- `component_behavior.cpp` separates user interaction from component definition/state: a double-click emits `ToggleEmergencyStop`, and the command application layer changes the component's internal E-stop state. That command/state separation is worth copying conceptually for fault injection: UI action should request a fault/state change, while the simulator owns resulting contact behavior.
- The wiring subsystem is substantial and separate (`src/wiring/application_wiring.cpp` ~175 kB), reinforcing that directly porting this desktop UI would be a large project. The component model is a better architectural study target than wholesale reuse for a static browser course.
- No source-confirmed relay/contact fault model was found in this pass. Do not infer welded-contact/EDM capability merely from the README's component list.

Assessment: **high-value architecture/component-behavior reference, lower-priority direct web foundation.** GPL plus C++/ImGui makes direct reuse a larger commitment; use its component/state/wiring separation as design evidence, not as copied implementation unless GPL distribution is intentionally accepted.

Source: https://github.com/ironhero1544/PLC_Simulator

## Candidate C — CircuitJS1
SOURCE-CONFIRMED public README: browser electronic circuit simulator, GWT adaptation of Falstad's simulator, embedding/import/export support, GPL-2.0-or-later.

Assessment: reference/fallback, not preferred starting point. It solves analog/electrical equations beyond the Safety Sandbox requirement.

## Architecture freeze for SIM-REUSE-01
The first model is deliberately a **state/fault reasoning experiment**, not a general safety simulator.

Physical relay/contactor object:
- `coil_command`
- `mechanical_state`
- `power_contact_actual`
- `aux_nc_actual`
- `fault_power_welded_closed`
- `fault_coil_open`
- `fault_aux_stuck`

System/monitor object:
- `safety_authorization`
- `hazardous_energy_path`
- `reset_request`
- `edm_healthy`
- `rearm_inhibit_latched`

Required causal separation:
1. coil command is an instruction, not proof of physical state;
2. coil-open can prevent pickup despite command ON;
3. welded power contact can remain conducting despite coil/mechanical release;
4. auxiliary feedback is an observation path and can itself fail;
5. EDM may inhibit the next rearm but is not retroactive proof that hazardous energy was removed;
6. LinuxCNC/ordinary-control frozen asserted is an external request fault, not safety authority.

### Minimal scenario sequence
A. healthy start -> relay picks up -> power contact conducts -> auxiliary NC opens.
B. stop request -> coil command OFF -> relay releases -> power contact opens -> auxiliary NC closes -> EDM healthy.
C. inject `POWER_CONTACT_WELDED_CLOSED`; repeat stop -> coil/mechanical state releases but hazardous-energy path remains conducting.
D. EDM/rearm logic must inhibit the next authorization when feedback/model indicates the output device did not return to the required state. If the chosen auxiliary contact cannot reveal the welded power pole, the simulator must show that diagnostic limitation rather than magically detect the weld.
E. inject auxiliary-feedback stuck/misreporting and demonstrate why diagnostic evidence is not equivalent to direct proof of every power pole.

This last distinction is important: the simulator must not teach that an auxiliary contact universally proves a main contact physically opened. Real force-guided/mirror-contact assumptions belong to the selected device's documented behavior.

## Pass/fail gate before prototype
DigitalJS is considered suitable for the first prototype if a custom cell can, without patching core source:
- declare coil/control input plus at least two contact/status outputs;
- retain explicit fault/mechanical state across ticks;
- reevaluate when a fault toggle changes;
- serialize those custom properties;
- run the A-E sequence deterministically.

If the only blocker is graphical remote-contact placement, proceed with a compact relay block first. If core state semantics require invasive modification, compare against a tiny independent state engine before committing to a fork.

## Machine-family reuse target
Reuse the same component/fault model across mill/router spindle energy, lathe examples, plasma motion versus process-energy authority, robot/cell gate and STO examples, and press-brake hydraulic/gravity examples where electrical de-energization explicitly does not prove removal of physical hazard. Machine physics may initially be state abstractions.

## Licensing / provenance rule
Before copying source rather than studying architecture, record exact license consequences. Prefer permissive reusable foundations where capability is comparable. GPL projects remain valuable references and may be usable if the project intentionally accepts their distribution obligations. Never copy LunchBox Sessions implementation/content; use only the general teaching pattern independently.

## Current recommendation
**Proceed toward a tiny DigitalJS custom-cell prototype, but first source-confirm the custom property/state reevaluation hook.** PLC_Simulator has already contributed a useful architectural lesson: multi-contact physical components and UI-command/state separation are proven simulator patterns, while its large desktop wiring layer argues against direct porting for our V1.

No compute was used or justified in this source-audit pass. Any later executable experiment must use only `[self-hosted, openpressbrake]` if repository compute is required.