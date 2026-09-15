# Safety Sandbox — open-source simulator reuse research

Date: 2026-09-15
Status: RESEARCH

## Purpose

Investigate whether the Practical Machine Safety course can reuse or adapt existing open-source circuit/PLC simulation infrastructure instead of building a general electrical simulator from scratch. The educational target is narrow: let a learner wire relay/contactor/safety blocks into a machine safety circuit, operate the circuit, inject explicit faults, and observe whether hazardous authority is actually removed and whether the fault is detected before restart.

This is an educational fault-analysis tool. It must not claim that passing a simulated fault campaign establishes a PL/SIL/Category or validates a real machine.

## Candidate projects

### DigitalJS / DigitalJS Online

Working classification: SOURCE-CONFIRMED from public repository/source inspection performed during curriculum research.

Why it is promising:
- browser-oriented JavaScript circuit engine;
- JSON-style device/connector/subcircuit representation;
- embeddable/headless use is available;
- custom cell/device namespaces provide a plausible extension seam for safety-specific components;
- permissive BSD-family licensing is attractive for an open curriculum tool.

Required source audit before adoption:
1. custom component lifecycle and state reevaluation semantics;
2. arbitrary multiport device behavior;
3. deterministic propagation/event scheduling;
4. serialization of custom physical/fault state;
5. monitor/alarm hooks usable by a fault campaign runner;
6. whether electromechanical state can be represented independently from coil-command logic without fighting the digital engine.

### PLC_Simulator

Working classification: SOURCE-CONFIRMED from public repository/source inspection performed during curriculum research.

Why it is useful:
- existing interactive wiring/component model;
- relay/E-stop/PLC/pneumatic concepts are closer to industrial-machine teaching than a pure gate simulator;
- physical components can own multiple contacts/state rather than representing every contact as an unrelated Boolean gate;
- GPL licensing and desktop/C++ architecture make direct embedding less attractive, but its component/state architecture is worth studying.

Required source audit:
1. relay and E-stop ownership of NC/NO contacts;
2. distinction between user command, coil state, mechanical state and contact state;
3. update-loop ordering and propagation;
4. fault extensibility;
5. reusable UI/wiring ideas versus code that should remain only an architectural reference.

## V1 physical relay/contactor contract

Do not model a relay as only `coil -> Boolean contacts`. One physical device owns its poles and feedback contacts.

Minimum state dimensions:
- `coil_command` — electrical command reaching the coil;
- `mechanical_state` — armature expected/released/operated/stuck;
- per-contact `conducting_state` — actual electrical continuity;
- per-contact role — main pole, ordinary auxiliary, documented mirror/force-guided feedback where applicable;
- injected fault state;
- optional transition delay/discrepancy state where a lesson requires it.

V1 fault set:
- coil open;
- individual NO/NC contact welded/stuck;
- mechanical armature stuck;
- broken conductor;
- selected conductor short/cross-connection where the modeled architecture makes this meaningful;
- loss/restoration of control power;
- reset held/stuck;
- failed or misleading feedback path.

Critical teaching rule: a welded main power pole can remain electrically conducting after the coil command is removed and the modeled armature releases. EDM may only prove what the modeled feedback architecture actually witnesses. An arbitrary auxiliary contact must not be presented as proof that every main power pole opened. Mirror/force-guided behavior must be an explicit documented device assumption.

## SIM-REUSE-01 — first bounded experiment

Do not implement until source inspection answers whether DigitalJS can cleanly hold the required independent physical state.

Circuit:
- low-voltage control source;
- NC E-stop input;
- reset/rearm input;
- two independent relay/contactor objects K1/K2;
- simulated hazardous-load authority requiring the intended interruption path;
- feedback/EDM loop;
- visible command, mechanical, contact and EDM states.

Required scenarios:
1. normal start/stop;
2. E-stop with no fault;
3. K1 main pole welded closed;
4. K1 feedback behavior appropriate to the exact modeled contact assumptions;
5. attempted reset while a detectable fault remains;
6. power loss and restoration without automatic hazardous restart.

Pass criteria are behavioral and educational, not certification claims:
- the simulator preserves command versus physical state;
- a welded contact remains welded when command changes;
- redundant interruption can remove modeled hazardous authority when one path is welded;
- EDM blocks rearm only when its actual witness can detect the modeled fault;
- the UI explains an undetected latent fault rather than falsely claiming `safe`;
- power restoration does not silently grant hazardous authority.

## Machine-family expansion

Only after the V1 engine proves useful, reuse the same component/fault model for guided machine scenarios: mill/router, lathe, plasma/laser, press brake, robot/custom kinematics, saw/feed cell and automated cell. Each machine definition must preserve its own hazard/energy model. Electrical command removal must never be equated automatically with removal of hydraulic pressure, gravity energy, stored mechanical energy, spindle coast, plasma/laser process energy, or other machine-specific hazards.

## Build-versus-reuse decision gate

Choose among:
- embed/extend DigitalJS;
- adapt selected open-source components under compatible licensing;
- use PLC_Simulator only as an inspectable architecture reference;
- write a small purpose-built state/graph engine after learning from both.

Prefer the smallest engine that accurately teaches the failure paths. Do not inherit analog/SPICE complexity merely because it exists.

## Next research checkpoint

1. Inspect DigitalJS custom cell state reevaluation and scheduling source closely enough to decide whether independent `mechanical_state` + per-contact fault state is natural or awkward.
2. Inspect PLC_Simulator relay/E-stop/update code for physical-component ownership patterns worth reproducing.
3. Write a one-page reuse decision matrix: license, browser fit, custom physical state, serialization, wiring UI, fault injection, machine-physics extensibility, maintenance burden.
4. Freeze SIM-REUSE-01 only if those source questions leave a real implementation uncertainty worth testing. No compute is justified merely to demonstrate ordinary Boolean relay behavior.
