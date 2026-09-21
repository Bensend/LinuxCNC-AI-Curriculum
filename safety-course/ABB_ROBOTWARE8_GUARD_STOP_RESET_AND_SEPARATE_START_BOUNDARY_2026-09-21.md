# ABB RobotWare 8 guard-stop reset and separate-start boundary

Session start UTC: 2026-09-21T19:38:33Z
Date: 2026-09-21

## Question

For a professional robot implementation, what actually happens after a safety violation, safety-related stop, operating-mode switch, or controller restart? Does restoration/reset itself restart the robot program, and what does the evidence say about an ordinary Start request that was already asserted?

## Authoritative evidence

### ABB RobotWare 8 Functional Safety and SafeMove

**DOC-CONFIRMED.** ABB's current *Application manual - Functional safety and SafeMove RW 8*, document 3HAC098577-001 Revision B (2026), describes a start/restart interlock that prevents automatic program start. The manual states that Reset is used to reset that interlock and must be performed to allow program start.

ABB requires Reset after safety violations, after safety-related stops, when the operating mode switches, and when the controller is switched on or restarted. The controller is then in a guard-stop state. Reset differs by operating mode: in Manual, the three-position enabling device is used; in Automatic, the TPU thumb button or a safe input is used. A successful Reset changes the state to motors on.

Source: ABB, *Application manual - Functional safety and SafeMove RW 8*, 3HAC098577-001 Revision B, 2026, section describing Reset functionality: https://library.e.abb.com/public/853f4d70848649a7b4b441258aea8def/3HAC098577%20AM%20Functional%20safety%20and%20SafeMove%20RW%208-en.pdf

### ABB reset/start design guidance

**DOC-CONFIRMED.** ABB's machine-safety guidance on reset and start quotes EN ISO 13849-1 manual-reset requirements and explains that manual reset must not itself initiate motion or a hazardous situation; it enables the control system to accept a separate start command. ABB recommends reset acceptance on release of the reset actuator and discusses monitoring the reset signal against glitch/stuck conditions.

Source: ABB Safety Products, *Using an HMI for reset and start*: https://new.abb.com/low-voltage/products/safety-products/using-an-hmi-for-reset-and-start

## Evidence-qualified state chain

The ABB implementation supports this explicit separation:

`guard stop / safety violation / mode transition`

`-> safety conditions restored`

`-> deliberate Reset of start/restart interlock`

`-> motors-on eligibility/state`

`-> separate ordinary program Start`

This is stronger evidence than merely saying that a reset "should not start": RobotWare 8 documents a concrete start/restart interlock and requires Reset after mode switches and safety stops.

## Durable freezes

- **GUARD/SAFETY CONDITION RESTORED != START/RESTART INTERLOCK RESET.**
- **RESET ACCEPTED != PROGRAM START.**
- **MOTORS ON != PROGRAM START.**
- **OPERATING MODE SWITCHED != PRODUCTION START.**
- **SAFETY VIOLATION CLEARED != ORDINARY DEMAND REGENERATED.**
- **THREE-POSITION ENABLING DEVICE USED FOR MANUAL RESET != ORDINARY MANUAL MOTION COMMAND.**

## Held-demand boundary

The inspected ABB material does **not** establish the electrical/software semantics of every ordinary Start input that remains asserted across a guard stop, mode switch, Reset, or motors-on transition. It does not justify claiming that every such input is edge-triggered, cancelled, queued, tracked, latched, or regenerated.

Therefore:

- ABB's start/restart interlock and separate Reset/Start architecture are **DOC-CONFIRMED**.
- A universal held-Start implementation rule is **UNKNOWN**.
- Requiring a machine design review to classify ordinary demand freshness explicitly is a curriculum **INFERENCE**, not an ABB product claim.

A conservative LinuxCNC/OpenPressBrake ordinary-control implementation may invalidate a pre-transition demand and require release/reassert or another explicit fresh post-eligibility event. That extra gate does not make LinuxCNC or the normal FPGA personnel-safety authority.

## Human-factors implication

A return-to-automatic sequence should not compress "guard restored", "safety reset", "motors enabled", and "production start" into one ambiguous operator action. ABB's implementation is useful because it exposes these as distinct states/actions. For teaching, this makes stale demand and accidental restart visible review questions instead of treating `safety_ok=true` as a start authorization.

## Information-gain stop

A bounded search across ABB, KUKA and FANUC public material did not produce authoritative evidence that universally classifies a held ordinary Start/Jog/Cycle request across service/setup-to-automatic transition. This question is machine/controller-interface-specific. Do not continue broad product searching merely to force a universal answer.

The next higher-value branch is safe reduced-speed commissioning and safeguard-defeat human factors: how professional systems constrain motion when normal guarding is intentionally unavailable, how enabling devices and deliberate motion commands interact, and how designs avoid making bypass/defeat the easiest operating path.

## Compute decision

No simulation/build/test compute is justified. The unresolved question is controller/application semantics and human-machine safety architecture; a synthetic simulation would not create authoritative physical or product evidence. No GitHub-hosted runner is to be used.