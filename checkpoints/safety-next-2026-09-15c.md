# Safety Curriculum Next Work — 2026-09-15d

## Current state
Primary priority remains Practical Machine Safety Engineering / 4000 safety-oriented boundaries. 1000/2000/3000 remain closed.

Updated durable research: `research/safety-simulator-open-source-reuse-audit-2026-09-15.md`.

## Safety Sandbox reuse decision
The DigitalJS source gate is now passed for a **bounded synchronous prototype without modifying DigitalJS core source**.

Source-confirmed:
- custom classes can be supplied through `HeadlessCircuit(..., {cellsNamespace})`;
- arbitrary multiport Gate cells and parameter-based serialization already exist;
- stateful built-ins retain non-signal state;
- `SynchEngine` gives deterministic queued reevaluation, monitors and alarms;
- custom property changes are not automatically enqueued by `SynchEngine`, but a tiny Safety Sandbox `SynchEngine` subclass can listen to declared fault/physical property changes and call inherited `_enqueue(gate)` without patching core;
- WorkerEngine is deliberately excluded from V1 because its worker reconstructs operations from its built-in imported cells namespace and `changeParam()` does not enqueue the changed gate. Supporting arbitrary safety cells there would add worker/bundle complexity with no current educational benefit.

PLC_Simulator remains a useful architecture reference: its electrical solver makes E-stop NC/NO continuity state-dependent by joining physical ports according to component-owned state. Do not port its large C++/ImGui wiring system for V1.

## Frozen V1 implementation contract
One multiport physical relay/contactor object owns coil command, retained mechanical state, actual main-contact facts, auxiliary feedback facts and persistent per-contact faults. Fault setters change physical-device properties and request reevaluation; they never directly force downstream outputs.

The lesson reports separately:
1. whether modeled hazardous authority is actually removed;
2. whether the diagnostic/EDM witness detected enough to permit or inhibit rearm.

An ordinary auxiliary contact never magically proves every main pole opened. Mirror/force-guided relationships require explicit documented device assumptions.

## Exact next work
1. Write the bounded `SIM-REUSE-01` prototype fixture/spec from the frozen contract: two interruption devices, EDM witness variants, explicit rearm latch, power-loss/recovery case and fault-report schema.
2. Before execution, inspect repository workflow support for `[self-hosted, openpressbrake]`. If no safe dispatch path exists, do not use hosted runners; continue source/manufacturer safety work and record the blocker.
3. If a bounded self-hosted run is available, execute only the predeclared custom-cell integration prediction; record actual runtime from authoritative job metadata. Do not broaden into a general simulator.
4. In parallel, deepen manufacturer evidence for mechanically linked/mirror contacts and EDM assumptions so simulator feedback models are documentation-grounded rather than invented.
5. Begin mapping the same causal lesson into machine-family examples only after SIM-REUSE-01 proves useful; preserve electrical command versus physical hazard distinctions for spindle coast, plasma process energy, hydraulic/gravity energy and robot/cell motion.

## Predeclared SIM-REUSE-01 prediction
A custom synchronous engine that enqueues a relay on fault-property mutation will let DigitalJS deterministically propagate changed actual-contact outputs without a core patch. A welded main-contact property will survive command OFF and serialization; the second independent interruption device will still remove the modeled hazardous authority, while EDM behavior will depend on what the selected feedback model actually witnesses.

## Safety boundary
The simulator is a teaching/fault-reasoning tool. It must not assign PL/SIL/Category. Ordinary LinuxCNC/PLC/FPGA logic remains normal control/diagnostics, not personnel-safety authority merely because it appears in a simulation.
