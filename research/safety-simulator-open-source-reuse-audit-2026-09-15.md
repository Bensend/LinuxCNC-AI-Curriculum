# Safety Simulator — Open-Source Reuse Research Project

Date: 2026-09-15
Status: ACTIVE RESEARCH — DIGITALJS SYNCHRONOUS PROTOTYPE PATH FROZEN

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

### Custom-state reevaluation audit — resolved for V1

SOURCE-CONFIRMED findings from `src/cells/base.mjs`, `src/cells/dff.mjs`, `src/circuit.mjs`, `src/engines/synch.mjs`, `src/engines/worker.mjs`, and `src/engines/worker-worker.mjs`:

1. **State may live on a custom Gate object.** Stateful built-ins already retain non-signal state; for example `Dff` retains `last_clk` as an object member while its `operation()` can also read prior `outputSignals`. A custom relay can therefore retain mechanical state separately from coil input and contact outputs.
2. **Serializable fault/configuration properties are natural.** `getGateParams()` serializes every field named in a cell's `_gateParams`. A relay cell can add fields such as `fault_power_welded_closed`, `fault_coil_open`, `fault_aux_stuck`, contact role metadata and initial mechanical state without a DigitalJS core serialization patch.
3. **Synchronous engine has no generic `change:<custom-param> -> enqueue` listener.** `SynchEngine` explicitly enqueues on input changes plus the built-in `manualMemChange` and `constantCache` events. Merely calling `relay.set('fault_power_welded_closed', true)` will serialize the new value but does not, by itself, schedule `operation()`.
4. **A custom cell can request reevaluation without a core patch by using the existing graph event seam.** The synchronous engine listens for graph-level `manualMemChange` and enqueues the gate argument. For the bounded V1, a relay method may set its fault property and then trigger a dedicated cell-level event that is bridged to the existing enqueue seam, or the Safety Sandbox may expose a tiny custom SynchEngine subclass that listens to `change:fault_*`/`change:mechanical_override` and calls the inherited `_enqueue(gate)`. This is an extension, not a modification of DigitalJS source.
5. **Preferred V1 is a small custom synchronous engine subclass.** It makes fault reevaluation explicit and avoids abusing a memory-specific event name. The subclass should listen only to the Safety Sandbox's declared physical/fault properties, enqueue the changed gate once, and otherwise retain DigitalJS scheduling unchanged. This meets the no-core-patch criterion.
6. **WorkerEngine is not the V1 target.** Although the UI-side WorkerEngine forwards supported `_gateParams` changes as `changeParam`, the worker-side `changeParam()` only sets the parameter; it does not enqueue the gate. More importantly, the worker reconstructs operations from `cells[gateParams.type].prototype`, i.e. its built-in imported namespace, so arbitrary `cellsNamespace` custom classes are not automatically available in the worker. Supporting custom safety cells there would require a worker extension/bundle path. The first Safety Sandbox does not need that complexity.
7. **Synchronous `HeadlessCircuit` remains browser-capable.** The Safety Sandbox workload is small relay/state graphs, not a huge high-frequency digital design. Keeping the first prototype synchronous makes custom classes, deterministic single-step fault campaigns, monitors and alarms available with no worker changes.

### DigitalJS relay representation decision
Working choice: **one multiport electromechanical device cell per physical relay/contactor**, not independent unlinked contact cells for V1.

Reasoning (INFERENCE from source + safety model):
- one object gives a single durable home for coil command, mechanical state, fault state and linked-contact identity;
- multiple NO/NC outputs can be declared as ports and serialized normally;
- a welded power pole can override only that pole while NC auxiliary feedback continues to represent the chosen physical model;
- the UI can still draw contact symbols spatially later, but V1 correctness should not depend on reconstructing mechanical linkage between independent graphical objects.

A later editor may offer linked remote contact symbols backed by one relay device ID if schematic readability demands it. Do not duplicate physical state across free-standing contacts.

Assessment: **DigitalJS synchronous engine is suitable for the first bounded prototype without modifying DigitalJS core source.** The remaining implementation uncertainty is ordinary integration work, not a representability blocker.

Sources: https://github.com/tilk/digitaljs and https://github.com/tilk/digitaljs_online
Source traces at pinned commit: `src/circuit.mjs`, `src/cells/base.mjs`, `src/cells/dff.mjs`, `src/engines/synch.mjs`, `src/engines/worker.mjs`, `src/engines/worker-worker.mjs`.

## Candidate B — PLC_Simulator (ironhero1544)

SOURCE-CONFIRMED at repository commit `66489904882f6d05c275a6762cebb00010eb2838`:
- GPL-3.0 C++20 desktop simulator with separate source areas for components, wiring, physics, programming and application layers.
- `src/components/emergency_stop_def.cpp` defines an E-stop as a registered component with four electrical ports labelled `NC_1`, `NC_2`, `NO_1`, `NO_2`, its own render function and default internal state. This is a useful precedent for a component owning multiple physical contacts rather than treating the E-stop as a single Boolean.
- `component_behavior.cpp` separates user interaction from component definition/state: a double-click emits `ToggleEmergencyStop`, and the command application layer changes the component's internal E-stop state. That command/state separation is worth copying conceptually for fault injection: UI action should request a fault/state change, while the simulator owns resulting contact behavior.
- `physics_electrical.cpp` rebuilds dynamic electrical connectivity from component-owned physical state. For `EMERGENCY_STOP`, released state unites the two NC ports while pressed state instead unites the two NO ports. This is a strong source-confirmed precedent for modeling a physical contact as topology/continuity, not merely as a displayed Boolean label.
- The electrical solver separates fixed wiring topology from state-dependent component connectivity and then derives net voltage. That architecture is more physical than DigitalJS's directional signal graph, but port/net machinery is much larger than V1 needs.
- No source-confirmed relay/contact fault model was found in this pass. Do not infer welded-contact/EDM capability merely from the README's component list.

Assessment: **high-value architecture/component-behavior reference, lower-priority direct web foundation.** GPL plus C++/ImGui makes direct reuse a larger commitment; use its component/state/wiring separation as design evidence, not as copied implementation unless GPL distribution is intentionally accepted.

Source: https://github.com/ironhero1544/PLC_Simulator

## Reuse decision matrix

| Criterion | DigitalJS synchronous | DigitalJS WorkerEngine | PLC_Simulator | Tiny purpose-built engine |
|---|---|---|---|---|
| License fit | Strong, BSD-2-Clause | Strong, BSD-2-Clause | GPL-3.0 obligations | Project-owned |
| Browser fit | Strong | Strong | Weak/direct port large | Strong if written for web |
| Custom multiport physical block | SOURCE-CONFIRMED | Worker custom namespace gap | SOURCE-CONFIRMED component pattern | Must build |
| Independent retained physical/fault state | SOURCE-CONFIRMED pattern + small subclass seam | Param transport exists but custom operation loading is awkward | SOURCE-CONFIRMED component-owned state pattern | Must build |
| Fault-state reevaluation | Small custom engine subclass, no core patch | Worker changes required for clean custom-cell path | Would require project-specific extension | Must build |
| Serialization | SOURCE-CONFIRMED `_gateParams` + connectors | Same UI-side model | Existing project-specific state | Must build |
| Wiring/editor foundation | Existing | Existing | Mature desktop wiring, not web | Must build |
| Deterministic fault campaign | Strong synchronous tick/monitor/alarm path | Strong but unnecessary complexity | Possible, larger integration | Must build |
| Machine-physics extensibility | Separate state abstraction recommended | Same | Existing electrical/pneumatic/physics ideas | Fully controllable |
| V1 maintenance burden | Lowest | Medium/high | High | Medium/high |

**Decision:** prototype on **DigitalJS `HeadlessCircuit` + a Safety Sandbox custom synchronous engine subclass + custom relay/contactor cells**. Keep PLC_Simulator as a source/proven-pattern reference. Do not fork DigitalJS core for V1. Do not build a new general wiring engine unless the bounded prototype exposes a concrete limitation.

## Frozen V1 relay/contactor contract

One physical `SafetyRelayContactDevice` owns:
- input port `coil_cmd`;
- output/status ports sufficient for the bounded lesson: `main_a_actual`, `main_b_actual`, `aux_nc_actual`, `mechanical_operated`;
- serialized properties `initial_mechanical_state`, `fault_coil_open`, `fault_main_a_welded_closed`, `fault_main_b_welded_closed`, `fault_aux_nc_stuck_closed`, and explicit feedback/contact-role metadata;
- retained runtime mechanical state separate from input command;
- `operation()` computes actual contact continuity from coil command + mechanical state + persistent per-contact fault overrides.

For V1, output ports represent **actual continuity/status facts** consumed by the lesson graph; they are not yet a general bidirectional electrical-net solver. The hazardous-energy model consumes the two interruption-path facts explicitly. A later version may add remote contact symbols or net-continuity semantics if teaching value justifies them.

Fault mutation API requirement:
- `setFault(name, value)` changes only a declared fault property;
- the custom synchronous engine observes those property changes and enqueues that physical device;
- no fault setter may directly force downstream outputs, because that would bypass the physical-device model being taught.

## SIM-REUSE-01 — frozen bounded prototype plan

The first model is deliberately a **state/fault reasoning experiment**, not a general safety simulator.

System/monitor state:
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

Minimal scenario sequence:
A. healthy start -> relay picks up -> power contact conducts -> auxiliary NC opens.
B. stop request -> coil command OFF -> relay releases -> power contact opens -> auxiliary NC closes -> EDM healthy.
C. inject `fault_main_a_welded_closed`; repeat stop -> coil/mechanical state releases but that pole remains conducting.
D. two independent interruption devices in series must still remove the modeled hazardous authority when only one pole is welded, while the fault remains latent or detectable according to the selected feedback model.
E. attempted rearm is inhibited only when the modeled EDM witness actually detects the failed return state.
F. inject auxiliary feedback stuck/misreporting and demonstrate why diagnostic evidence is not equivalent to direct proof of every power pole.
G. loss/restoration of control power must not silently regrant hazardous authority; explicit rearm remains required.

### Predeclared prototype prediction
If the custom synchronous engine enqueues a relay on fault-property mutation, DigitalJS should deterministically propagate the changed actual-contact outputs through the bounded graph without any DigitalJS core modification. A welded main-contact property should survive command OFF and serialization, while the unaffected second interruption path still removes the modeled hazardous authority. EDM behavior will differ depending on whether the selected feedback model is explicitly linked to the failed main contact.

Falsifier: if a custom cell cannot retain/serialize its fault state while being reevaluated by the subclassed synchronous engine, or if the directional signal model cannot express the bounded actual-continuity facts without bypassing the physical model, reassess against a tiny purpose-built engine before further implementation.

## EDM / feedback teaching boundary

The simulator must distinguish at least three educational feedback cases:
1. **ordinary auxiliary contact** — reports its own modeled state only; do not infer main-pole position;
2. **documented mechanically linked / mirror-contact model** — may support a defined relationship only when the lesson explicitly states the device assumption and source;
3. **failed feedback path** — the diagnostic witness itself can stick/open/misreport and must be fault-injectable.

Therefore the fault campaign reports two independent questions: **was hazardous authority actually removed?** and **did the diagnostic architecture know enough to permit or inhibit rearm?** Never collapse these into one `safe=true` flag.

## Machine-family reuse target
Reuse the same component/fault model across mill/router spindle energy, lathe examples, plasma motion versus process-energy authority, robot/cell gate and STO examples, and press-brake hydraulic/gravity examples where electrical de-energization explicitly does not prove removal of physical hazard. Machine physics may initially be state abstractions.

## Licensing / provenance rule
Before copying source rather than studying architecture, record exact license consequences. Prefer permissive reusable foundations where capability is comparable. GPL projects remain valuable references and may be usable if the project intentionally accepts their distribution obligations. Never copy LunchBox Sessions implementation/content; use only the general teaching pattern independently.

## Current recommendation
**The source gate is passed for a bounded DigitalJS synchronous prototype.** The prototype is now justified only to verify the custom-cell integration seam and causal lesson, not to prove ordinary Boolean logic. Any executable workflow must target only `[self-hosted, openpressbrake]`; do not dispatch hosted compute. If runner access is unavailable, continue manufacturer/standards EDM evidence and prototype specification work instead.
