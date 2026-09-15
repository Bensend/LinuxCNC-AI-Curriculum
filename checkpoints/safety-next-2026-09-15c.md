# Safety Curriculum Next Work — 2026-09-15c

## Current state
Primary priority remains Practical Machine Safety Engineering / 4000 safety-oriented boundaries. 1000/2000/3000 remain closed.

New durable research: `research/safety-simulator-open-source-reuse-audit-2026-09-15.md`.

## Safety Sandbox reuse finding
The owner-requested open-source simulator research is now an explicit curriculum research branch. DigitalJS is the leading browser candidate. Source confirms `HeadlessCircuit` accepts a custom `cellsNamespace`, resolves device types from it, and exposes selectable simulation engines plus graph signal-change handling. Adding a custom safety relay/contactor component therefore does not appear to require forking the core merely to register a component.

PLC_Simulator remains the strongest industrial wiring/PLC/physical-domain architecture reference but is C++ desktop/GPL-3.0. CircuitJS1 remains an analog-capable fallback rather than the default.

## Exact next work
1. Continue DigitalJS source audit: custom cell base/ports, sequential/internal state scheduling, rendering and serialization. Decide one multiport relay cell versus mechanically-linked device/contact group.
2. Source-audit PLC_Simulator relay, E-stop, wire and simulation-update abstractions while preserving license provenance.
3. Freeze SIM-REUSE-01: coil command + NO power contact + NC feedback, welded power contact, EDM/rearm inhibition. Prototype only after the model is stable.
4. Preserve SIM-SAFE-01 and machine-family human examples; simulator reuse serves the course rather than displacing safety research.
5. No lab justified yet. If execution later becomes useful, use only `[self-hosted, openpressbrake]`.

## Safety boundary
The simulator is a teaching/fault-reasoning tool. It must not assign PL/SIL/Category, and ordinary LinuxCNC/PLC/FPGA logic must not become personnel-safety authority merely because it is simulated.