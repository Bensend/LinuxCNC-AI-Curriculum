# 3600 Press Brake specialization — evidence-gap map after PB-PREP-002

Date: 2026-09-11
Status: dependency-safe specialization preparation; F02 remains blocked by fresh-AI prerequisite handoffs.

## Purpose

Stop treating every press-brake question as a simulation target. This map separates topics already supported well enough to teach as generic architecture from topics that genuinely require additional machine-specific, source, or physical evidence.

## Evidence already strong enough for generic architecture teaching

### 1. Ownership and layering — STRONG

Evidence accumulated from pinned LinuxCNC motion/HAL source, Accurpress architecture evolution, Ursviken field history, the 2018 hydraulic project, `carousel.comp`, `plasmac.comp`, and PB-PREP-002 supports these generic rules:

- semantic press-cycle state is not the same thing as joint/trajectory ownership;
- requested actuator/process mode is not final authorization;
- command publication is not physical completion evidence;
- Y1/Y2 synchronization needs independent physical side truth rather than only Cartesian/master position;
- active process states should remain nonblocking and continuously reevaluate ordinary authorization/fault witnesses;
- timeout detection is incomplete unless an explicit response transition exists;
- reset after an interrupted process should enter reconciliation rather than blindly resuming the interrupted state;
- exact realtime function ordering matters when a newly calculated command must reach hardware in the same servo invocation;
- ordinary LinuxCNC/HAL control logic is not thereby functional safety.

PB-PREP-002 run 079 independently verifies the abstract software ownership subset without inventing hydraulic physics.

### 2. Tandem Y1/Y2 field feasibility — MODERATE/STRONG, topology details missing

The Ursviken/Pullmax builder reported a successful physical bend using independent Y1 and Y2 position PIDs plus a differential synchronization PID. This is useful field evidence that the broad control decomposition can work.

Still unavailable: the promised final downloadable configuration. Therefore exact correction insertion, final-side saturation, realtime ordering, following-error ownership, disable behavior and tuned gains remain unproven. PB-PREP-001 remains INCONCLUSIVE and must not be used to select a preferred insertion topology.

### 3. Intermediate actuator observability — STRONG FIELD LESSON

The 2018 hydraulic project reported a pressure-relief event mechanically disturbing a stepper-driven spool actuator enough to lose step position. This demonstrates why outer ram feedback does not prove intermediate actuator state and why command history cannot automatically substitute for physical actuator feedback.

This is a general observability lesson, not a universal requirement that every proportional valve needs a particular feedback sensor.

### 4. Process-state semantics and timeout ownership — STRONG

Pinned LinuxCNC process components provide executable analogues: `carousel.comp` continuously reevaluates active-state conditions, while its timeout demonstrates that a timer indication alone need not abort an operation; `plasmac.comp` provides sensor-driven completion plus explicit bounded timeout/retry behavior. Official QtPlasmaC documentation and field reports independently corroborate operator-visible timeout/retry semantics.

PB-PREP-002 run 079 passed frozen Gates A-J and proves the generic ownership contract can be implemented without a physical plant model.

## Evidence gaps that should NOT be filled by invented generic simulation

### A. Machine-specific hydraulic decoder — MACHINE SPECIFIC

Needed from the actual machine: valve topology, polarity, overlap/deadband where relevant, pump/unloading arrangement, pressure/decompression plumbing, electrical interface, legal command combinations and physical completion witnesses. There is no defensible universal press-brake valve truth table.

### B. Numeric pressure/tonnage/decompression limits — MACHINE SPECIFIC / PHYSICAL

Do not derive production values from community examples. These depend on machine structure, tooling, hydraulic design, sensors and manufacturer/engineering constraints.

### C. Functional-safety architecture — MACHINE/RISK SPECIFIC

Guarding, light curtains, pedal safety functions, monitored valves, stopping performance, safety PLC/relay behavior and required performance levels cannot be inferred from ordinary HAL or state-machine logic. LinuxCNC diagnostics may observe safety-chain state but do not become the safety function by doing so.

### D. Final Y1/Y2 correction topology — OPEN

The broad decomposition is supported; the exact best correction insertion/limiting topology is not. PB-PREP-001's frozen discriminator failed to exercise the required B/P6 condition, so the experiment is correctly closed INCONCLUSIVE. Reopen only for a new evidence-backed question with a separately frozen design.

## Highest-information next 3600 lessons

1. **Backgauge control and operator modes:** source/community study of manual typed position, jog, homing/reference, X/R/Z-style axes, and how commercial/open implementations separate setup from automatic bend sequencing.
2. **Bend-program/DXF workflow:** document bend-line representation, bend list generation, gauging-surface selection and human-confirmed sequencing using open-source CAD/manufacturing projects plus commercial workflow concepts. Avoid attempting full automatic bend planning prematurely.
3. **Press-specific commissioning/recovery:** generic checklist for scale plausibility, Y1/Y2 disagreement, actuator-following witnesses, pressure/process witnesses, interrupted-cycle reconciliation and retained diagnostics, while leaving numeric limits machine-specific.
4. **HMI/visualization:** how LinuxCNC interfaces expose press state, bend program, backgauge targets and diagnostic ownership without hiding stale/faulted state.

Given the current evidence, **backgauge control/operator modes has the highest immediate information gain** because the hydraulic/state-ownership question has reached diminishing returns while backgauge behavior is a major explicit 3600 objective with much less accumulated durable coverage.

## Promotion / stop rules

- Do not perform additional generic hydraulic simulation merely because physical details are unknown.
- Do not repeatedly search the Ursviken thread for the missing final config unless a new attachment/repository appears.
- If a mature public tandem config or executable decompression decoder appears, inspect it against the existing ownership matrix before copying any values.
- Treat real-machine numeric commissioning and functional-safety design as separate engineering work requiring machine-specific evidence.

## Next checkpoint

Begin the bounded 3600 backgauge/operator-mode pass: establish terminology and workflows from official LinuxCNC docs, then inspect at least two public press-brake/backgauge implementations and one non-LinuxCNC/open-source backgauge or bend-workflow project. Trace typed-position/jog/homing command ownership and interruption/recovery behavior. Preserve manual positioning as the first-stage capability; do not jump directly to automatic DXF sequencing.
