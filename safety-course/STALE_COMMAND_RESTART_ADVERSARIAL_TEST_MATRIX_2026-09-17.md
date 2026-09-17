# Stale-Command / Restart Adversarial Test Matrix — 2026-09-17

## Question

After a protective stop, power disturbance, controller reboot, communications recovery, guard closure, or safety reset, can an **old ordinary-control command** become effective without a new deliberate machine-start/motion action?

This is a cross-machine commissioning question. It does not assign a safety rating to LinuxCNC, HAL, the FPGA, or a network protocol.

## Evidence basis

- **DOC-CONFIRMED:** SICK safety-device documentation distinguishes reset from subsequent machine start and states that reset itself must not create dangerous movement.
- **DOC-CONFIRMED:** Rockwell safety instructions distinguish MANUAL from AUTOMATIC restart and warn that automatic restart is only appropriate where it cannot create an unsafe condition.
- **INFERENCE:** Therefore, ordinary-control command persistence must be included in restart validation; otherwise a correctly functioning safety reset can expose a separate stale-command restart defect.

## Required test classes

For each applicable command source, deliberately establish the command, create the safety/control interruption, then restore prerequisites one at a time. Record whether the command remains logically asserted, whether normal-control authority rearms, whether a new deliberate action is required, and whether any physical actuator responds.

| Command source | Interruption to test | Required commissioning question |
|---|---|---|
| Foot pedal / treadle | protective-device demand; E-stop; safety reset | Does a pedal held throughout the stop become motion when safety returns, or is release/new actuation required by the machine safety concept? |
| Cycle Start | guard/light-curtain demand; reset | Can a held or latched cycle-start state resume a queued cycle solely because guarding becomes ready? |
| Jog button / pendant | safety demand; mode change | Can a continuously held jog command regain motion after reset/mode restoration without the deliberate action required by the safety concept? |
| MDI / queued program motion | safety stop; LinuxCNC recovery | Is previously queued motion automatically resumed when normal control returns? If resume is intended, what independent restart conditions make it safe? |
| HAL/PLC latched bit | safety demand; CNC reboot | Does retained/restored state recreate actuator command without operator intent? |
| Network command | Ethernet loss/recovery | Does reconnect replay, retain, or reconstruct a previous command? Does command freshness expire independently? |
| FPGA command register | host loss/watchdog/recovery | Can old register state regain output authority after watchdog/rearm, or is fresh command generation required? |
| Analog/PWM/current command | safety demand; driver rearm | Does stale nonzero demand survive rearm or integrator/state restoration? |
| Spindle/torch/laser enable | guard demand; process recovery | Can process energy restart independently of a new deliberate command? |
| Robot/cell automatic cycle | access event; zone reset | Can cell reset/rearm cause automatic sequence continuation while occupancy/restart conditions are unresolved? |

## Expected architecture pattern

A robust ordinary-control integration generally separates:

`command value` -> `command freshness` -> `normal-control rearm` -> `safety ready` -> `deliberate start/motion condition` -> `actuator authority`

The exact implementation is machine-specific. The important commissioning rule is that restoring one prerequisite must not silently manufacture the others.

## LinuxCNC / FPGA design implication

Normal controller logic should make stale-command behavior deterministic and visible even though it is not the personnel-safety layer. Useful defensive patterns include:

- expire network/host commands on freshness timeout;
- clear or invalidate actuator command generations on watchdog trip;
- require a fresh generation/sequence after rearm;
- avoid retaining loop-integrator state that can recreate a nonzero actuator request after a fault unless deliberately designed and validated;
- expose `safety-ready`, `normal-rearm-required`, `command-fresh`, and `start-required` as distinct diagnostics rather than one composite `ready` bit.

These measures improve fault containment and diagnostics but do **not** convert LinuxCNC/FPGA into the safety-rated restart authority.

## Pass/fail discipline

For each machine/operating mode, classify every applicable row:

- `CLOSED FROM EVIDENCE` — behavior and acceptance criterion are established and validated;
- `NOT APPLICABLE` — command source/path does not exist in the defined operating state;
- `UNKNOWN` — behavior or acceptance requirement is not yet established.

A safety-critical `UNKNOWN` keeps the affected exposed operating state **NOT CLEARED**. Do not invent a universal rule such as “every held control must always be released”; some machinery safety concepts intentionally use hold-to-run/enabling behavior. Instead establish the actual requirement and prove that restoration cannot create unexpected hazardous motion.

## Cross-machine examples

- **Press brake:** treadle, ram command and proportional-current state must be tested across optical-device demand, E-stop, setup-mode transition and safety reset. Hydraulic final-element state remains separately verified.
- **Mill/lathe:** spindle, jog and queued program state must be tested across door opening, safety stop and reset; commanded spindle zero is not physical standstill proof.
- **Plasma/laser:** torch/laser enable and motion commands must not reappear merely because interlocks or communications recover.
- **Robot/cell:** zone reset, guard closure and controller recovery must not substitute for occupancy clearance and deliberate cycle start.

## Evidence boundary

No machine-specific stopping distance, reset timing, safe speed, hydraulic response, PL/SIL or diagnostic coverage is inferred here. Physical energized testing requires the machine-specific hazard controls and validation plan; where exposed operation is not yet cleared, use isolated/remote testing with people outside the danger zone.
