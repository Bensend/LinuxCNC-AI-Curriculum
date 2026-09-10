# Press-brake community architecture survey — 2026-09-10

## Scope

Dependency-safe 2000-series preparation while F02 is blocked on information-separated S02/E20/X01/X02 handoffs. This survey is deliberately generic/public and contains no private OpenPressBrake machine details.

## Why this work is useful now

The current 2000-level technical closures already establish coupled-control authority (D01), watchdog/recovery boundaries (S02/E20), recorder integrity (X01), and cross-surface diagnostic freshness (X02). A press-brake community survey can test whether those abstractions correspond to real retrofit failure surfaces without self-certifying the blocked handoffs.

## Community evidence

### Modern documented retrofit: Ursviken Pullmax Optima 130

LinuxCNC forum thread (NWE, created 2025-12-02):
https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage

Reported architecture:

- Y1/Y2 are left/right ram axes; Y2 is described as slave of Y1.
- Two servo valves independently command Y1/Y2 speed/direction.
- Six 24-V spool-valve coils select hydraulic modes such as up/down, fast/slow, dwell and decompression.
- Tonnage is open-loop through a proportional relief valve.
- Backgauge includes X/R and independently movable Z1/Z2 fingers, creating a collision-avoidance requirement separate from ram synchronization.
- Mesa 7i80HDT + 7i36 + 7i54 plus EtherCAT I/O are reported.

Classification: COMMUNITY-REPORTED. This is strong architecture evidence from an active retrofit, but not source-level proof of LinuxCNC semantics or a safety certification.

### Earlier proportional-valve retrofit discussion

LinuxCNC forum thread, 2023-03-29:
https://forum.linuxcnc.org/10-advanced-configuration/48633-linuxcnc-press-brake-retrofit-with-servo-proportional-valves

Important lesson: a press-brake hydraulic manifold cannot safely be reduced to "one proportional output" from superficial inspection. Community replies explicitly raise separate flow-management and machine-protection valve functions and recommend obtaining the hydraulic circuit/documentation. A Bosch assembly in that discussion was reported to accept analog command through its existing electronics.

Classification: COMMUNITY-REPORTED. Treat manifold-function guesses as investigation leads only.

### Repeated Y1/Y2 topology

A 2023 Durma retrofit question reports Y1/Y2 cylinders with a linear encoder on each side plus X/R backgauge:
https://forum.linuxcnc.org/38-general-linuxcnc-questions/49717-press-brake-controls

A 2021 press-brake thread likewise reports dual Y feedback and proportional-valve control:
https://forum.linuxcnc.org/38-general-linuxcnc-questions/41811-press-brake

Classification: COMMUNITY-REPORTED. The recurrence supports prioritizing dual-feedback/coupled-control study, not a claim that all brakes share one topology.

## Cross-check against current curriculum knowledge

1. **D01 is directly relevant.** Real retrofit reports contain two ram feedback/control surfaces. The curriculum must preserve the distinction between a common commanded surface and independent actuator authority. A simple "slave" label is not enough to establish the actual cross-coupling law, saturation behavior, or fault authority.
2. **S02/E20 are directly relevant.** Real systems distribute authority across LinuxCNC, Mesa/field I/O, valve electronics, and hydraulic hardware. Communication recovery is therefore not equivalent to restored machine authorization, and a software watchdog is not automatically a safety function.
3. **X01/X02 are directly relevant to commissioning.** A press brake can have fast realtime control plus slower UI/logging. Missing observer records or repeated UI state must not be misdiagnosed as missed realtime execution or fresh machine state.
4. **Hydraulic sequencing deserves a specialized study surface.** Direction/flow modes, decompression, pressure command, and ram synchronization interact. The community evidence is sufficient to justify a future press-brake-focused module, but not sufficient to prescribe a generic valve sequence.
5. **Backgauge is a different control problem.** X/R positioning and Z-finger collision avoidance should not be conflated with Y1/Y2 hydraulic synchronization.

## Candidate higher-level questions

These are preparation items, not claims of resolved behavior:

- What LinuxCNC architecture best represents Y1/Y2 when each side requires independent feedback correction but the operator/program sees one bend-depth coordinate?
- Where should differential-position correction live relative to per-side position/velocity loops, and how should saturation/authority be bounded?
- How should a hydraulic mode state machine interlock fast approach, working stroke, dwell, decompression and return without falsely treating ordinary HAL logic as safety-rated?
- Which faults require immediate withdrawal of valve authority versus controlled stop/hold, and what hardware-independent simulations can establish those boundaries?
- How should diagnostics expose commanded common motion, differential correction, each encoder, each valve command, state-machine mode, watchdog freshness, and observer-generation witnesses without creating misleading cross-clock conclusions?
- What aspects of bend sequencing belong in a purpose-built UI/state machine versus G-code/interpreter semantics?

## Promotion recommendation

Do **not** activate these as substitutes for F02 or bypass the fresh-AI gate. Preserve them as a press-brake specialization queue. After the four pending handoffs unblock F02, use F02 integration results to decide whether the material belongs in late 2000-level integration or a justified 3000-level specialized press-brake/control module.

## Safety boundary

Community retrofit success does not establish functional-safety adequacy. LinuxCNC, HAL, network I/O, FPGA/Mesa logic, custom UI/state machines, and diagnostic watchdogs must not be described as safety-rated without independent evidence. Hydraulic circuit functions must be established from actual hydraulic documentation and component data before machine-specific control decisions.
