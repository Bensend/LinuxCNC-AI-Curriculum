# Press cycle interrupt, recovery, and fresh-reinitiation trace

Date: 2026-09-18
Active level: 4000 safety course

## Question

Can a professional press implementation expose the full distinction between cycle initiation, interrupted hazardous motion, recovery motion, release of the initiating device, and authority for the next production cycle?

## Professional implementation evidence

### Rockwell Automation SAFETY-AT198A-EN-P — pneumatic press control

**DOC-CONFIRMED.** Rockwell's September 2022 `Pneumatic Press Control via a Guardmaster 440C-CR30 Software-configurable Safety Relay` application technique defines explicit cycle exceptions and recovery behavior.

A safety-device actuation during any portion of the cycle resets cycle-state latches and interrupts moves. Separately, releasing the two-hand control before the cylinder reaches fully extended interrupts cylinder motion. Both conditions feed defined cycle-reset/recovery logic rather than silently resuming the production sequence.

Rockwell documents the recovery sequence after an interrupted cycle: the operator must press and release Reset, then use the two-hand control to retract the cylinder; after the cylinder is retracted, the operator must release the two-hand control before initiating the next cycle.

This is unusually useful evidence because one implementation exposes all of these distinct propositions in one machine sequence: production-cycle state, safety interruption, initiating-device interruption, reset action, deliberate recovery motion, physical retracted state, release of the two-hand control, and next-cycle initiation.

Source: Rockwell Automation Publication SAFETY-AT198A-EN-P, September 2022, `Pneumatic Press Control via a Guardmaster 440C-CR30 Software-configurable Safety Relay`, especially Cycle Exceptions / Recovery.

### Rockwell SAFETY-AT071 — two-hand safety validation

**DOC-CONFIRMED.** Rockwell's two-hand safety-function validation procedure independently challenges abnormal initiation and reset cases. Pressing only one palm button leaves both contactors de-energized; pressing the second one about one second later also leaves them de-energized. A Reset command while stopped leaves the contactors de-energized. The validation also injects channel opens/shorts and verifies de-energization, and verifies that loss of contactor feedback prevents restart/reset after a stop.

This independently supports the narrower propositions that reset is not run authority, invalid/asynchronous two-hand state is not valid initiation, and final-element feedback can block renewed authority.

Source: Rockwell Automation `Safety Function: Two Hand Control`, SAFETY-AT071.

### Rockwell Machinery Safebook 5 — anti-tie-down principle

**DOC-CONFIRMED.** Rockwell's Machinery Safebook describes two-hand controls as concurrent controls that must be operated continuously during the hazardous condition. If either is released, machine operation ceases; after one is released, the other must also be released before restart. Rockwell describes this as anti-tie-down.

Source: Rockwell Automation, Machinery Safebook 5, `Two-Hand Controls`.

## What this closes from the previous checkpoint

The previous single-stroke study had strong mechanical-power-press evidence but deliberately left hydraulic/servo/pneumatic transfer as inference. SAFETY-AT198 now provides a professional fluid-power press implementation with an explicit interrupted-cycle recovery sequence.

It supports this authority chain:

`VALID FRESH TWO-HAND INITIATION -> PRODUCTION CYCLE IN PROGRESS -> INTERRUPT -> PRODUCTION MOTION REMOVED -> RESET PRESS/RELEASE -> DELIBERATE RECOVERY TWO-HAND COMMAND -> PHYSICAL RETRACTED STATE -> TWO-HAND RELEASE -> ELIGIBLE FOR A NEW FRESH INITIATION`.

## Frozen rules

**RESET ACCEPTED != PRODUCTION CYCLE AUTHORITY.**

**RECOVERY MOTION AUTHORIZED != PRODUCTION CYCLE RESUMED.**

**CYLINDER RETRACTED != NEXT CYCLE INITIATED.**

**TWO-HAND CONTROL STILL HELD AFTER RECOVERY != FRESH NEXT-CYCLE INITIATION.**

**SAFETY DEVICE RESTORED != INTERRUPTED CYCLE AUTOMATICALLY RESUMES.**

**ORDINARY CYCLE STATE BEFORE A SAFETY INTERRUPT != AUTHORITY TO CONTINUE THAT STATE AFTER SAFETY RECOVERY.**

## Failure-path / adversarial review

Commissioning should challenge, where applicable:

1. Interrupt a cycle with a safety device. Restoring the device alone must not resume production motion.
2. Release the two-hand control before full extension. The production move must interrupt rather than coast logically through a stale cycle state.
3. Hold both initiating buttons through the interrupt/reset sequence. Reset must not turn the held level into a new production initiation.
4. Perform the required recovery retraction, but keep the two-hand control asserted at the retracted state. The next production cycle must wait for the required release/new initiation.
5. Press Reset while no valid two-hand initiation exists. Reset must not energize the production final elements merely because the safety circuit is otherwise healthy.
6. Create invalid two-hand timing/asymmetry. Do not accept a sequential/stale pair as valid concurrent initiation where the validated function requires concurrence.
7. Lose monitored final-element feedback. Restoring operator controls must not bypass the feedback/restart inhibition.
8. Power-cycle ordinary LinuxCNC/HAL/FPGA control while a physical initiating device remains active. A stale ordinary request must not be promoted into fresh production intent when safety authority returns.
9. Preserve a stale software `cycle_started`, `down`, `jog`, or valve request through safety recovery. Independent safety authority and the ordinary sequencer must require a defined fresh/recovery transition rather than blindly replaying it.

## Transfer boundary to hydraulic press brakes / OpenPressBrake

The cited Rockwell machine is a **pneumatic press**, not a hydraulic press brake. The exact valves, cylinder states, safe exhaust behavior, pressure decay, force, timing, safeguarding performance and required recovery sequence are machine-specific and **must not be copied as an OpenPressBrake hydraulic truth table**.

The transferable architecture lesson is **INFERENCE**: recovery from an interrupted hazardous cycle can and should be represented as a different authority state from production-cycle continuation, with deliberate reset/recovery action and a fresh initiation boundary before another production cycle.

LinuxCNC/HAL and an ordinary FPGA may own normal sequencing and diagnostics, but personnel-safety authority cannot be assigned to them merely because they can implement edge detection or a recovery state machine.

## Evidence classification

- Rockwell SAFETY-AT198 professional pneumatic-press sequence: **DOC-CONFIRMED**.
- Rockwell SAFETY-AT071 validation behavior: **DOC-CONFIRMED**.
- Rockwell Machinery Safebook anti-tie-down description: **DOC-CONFIRMED**.
- Executable/runtime evidence added this session: **TEST-CONFIRMED: none**.
- Community evidence used: **COMMUNITY-REPORTED: none**.
- Transfer of authority-state separation to future OpenPressBrake design: **INFERENCE**.
- OpenPressBrake-specific hydraulic recovery truth table, valve arrangement, pressure/force thresholds, stopping distance, cycle definition, PL/SIL/category/DC and legal applicability: **UNKNOWN**.

## Minimum-safe-to-operate consequence

If restoring a protective device, pressing safety reset, completing recovery motion, or restoring control power can cause a new hazardous production stroke without the validated fresh initiation required by the machine's operating mode, treat the machine as not commissioned for exposed operation. Experimental work must remain isolated/remote with personnel outside the danger zone until the recovery/reinitiation chain is corrected and validated.

## Compute decision

This question was resolved from authoritative professional documentation. No simulation/build/synthesis/test suite was justified. No GitHub-hosted or self-hosted compute was consumed.

## Next evidence target

Find an actual **hydraulic press or press-brake** implementation exposing the same authority chain and, preferably, its hydraulic final elements: `fresh initiation -> downstroke -> protective interruption -> hydraulic safe reaction / physical motion witness -> deliberate recovery -> known physical position -> release/reinitiation -> next cycle`. Preserve UNKNOWN rather than importing SAFETY-AT198's pneumatic valve/cylinder behavior into a hydraulic machine.
