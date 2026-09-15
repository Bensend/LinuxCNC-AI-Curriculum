# Safety Curriculum Next Work — 2026-09-15c

## Current state
Primary priority remains Practical Machine Safety Engineering / 4000 safety-oriented boundaries. 1000/2000/3000 remain closed.

Updated durable research: `research/safety-simulator-open-source-reuse-audit-2026-09-15.md`.

## Safety Sandbox reuse finding
DigitalJS remains the leading browser candidate. Source now confirms arbitrary multiport custom Gate cells, explicit input/output signal maps, wire propagation, parameter-based serialization, deterministic propagation scheduling, monitors and tick alarms. Working V1 representation is one multiport physical relay/contactor cell owning coil command, mechanical/fault state and linked contact outputs; remote graphical contacts can come later.

PLC_Simulator source confirms a useful parallel pattern: its E-stop is one component with four physical electrical ports (two NC/two NO), while UI interaction emits commands that update component-owned state. Its very large separate desktop wiring layer strengthens the decision not to port the whole C++/ImGui application for V1.

## Exact next work
1. Source-confirm the clean DigitalJS custom-property/state reevaluation mechanism; inspect stateful built-ins and serialization paths sufficiently to decide whether SIM-REUSE-01 needs zero core patches.
2. If zero-core-patch criterion holds, freeze the custom relay cell contract and a bounded self-hosted prototype plan. Do not execute merely to consume compute.
3. Continue safety-course evidence in parallel: tie the simulator's EDM lesson to documented force-guided/mirror-contact assumptions so it never teaches that an arbitrary auxiliary contact proves every main pole opened.
4. Preserve SIM-SAFE-01 and machine-family examples; simulator work serves the course rather than displacing standards/manufacturer safety research.
5. If DigitalJS requires invasive core state changes, compare it against a tiny purpose-built state engine before accepting a fork.

## SIM-REUSE-01 frozen causal lesson
Healthy start/stop, then welded power contact: coil command OFF and mechanical release must remain distinct from power-contact conduction. EDM can inhibit subsequent rearm when the selected feedback architecture actually detects the failure; it must not magically infer a weld that the modeled feedback contact cannot reveal. Then inject failed/stuck auxiliary feedback to demonstrate the diagnostic boundary.

## Safety boundary
The simulator is a teaching/fault-reasoning tool. It must not assign PL/SIL/Category. Ordinary LinuxCNC/PLC/FPGA logic remains normal control/diagnostics, not personnel-safety authority merely because it appears in a simulation. No lab compute consumed in this pass; any later execution is restricted to `[self-hosted, openpressbrake]`.