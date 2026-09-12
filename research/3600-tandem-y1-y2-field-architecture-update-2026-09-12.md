# 3600 — Tandem Y1/Y2 field architecture update

Date: 2026-09-12

## Why this reopens the source-gated branch

The prior checkpoint allowed the tandem branch to reopen only for genuinely new evidence. Continuing through the later pages of the Ursviken/Pullmax retrofit thread produced a materially stronger field result than the earlier generic statement that Y1/Y2 synchronized: the builder disclosed the control topology used in the machine after an actual bend test.

## Field chronology

### February 2026 — first closed-loop test

The builder reported a closed-loop test with:

- left ram servo valve driven from `j3.vel_pid.output`;
- right ram servo valve driven from `j4.vel_pid.output`;
- separate position-command and velocity-command signals;
- a cascaded position-PID → velocity-PID concept on each side;
- both sides synchronizing, but with objectionable hydraulic groaning and acknowledged tuning/nonlinearity uncertainty.

This is **COMMUNITY-REPORTED** prototype behavior, not final source-confirmed architecture.

### July 2026 — electronic flow-divider model

The builder later described the physical hydraulic structure as left and right servo valves tee'd from the pump, with the original flow-divider function emulated electronically in LinuxCNC HAL.

On 22 July 2026, after reporting that the machine successfully bent a 1.5 × 10 × 3/16-inch steel test piece to 90 degrees, the builder disclosed the resulting high-level synchronization topology:

- two position PIDs, one per side;
- one synchronization PID for left/right tilt correction;
- synchronization PID command = 0;
- synchronization feedback = Y1 − Y2 position difference;
- correction acts by **slowing the side that is ahead**.

Classification: **COMMUNITY-REPORTED FIELD SUCCESS**. This is stronger than a design proposal because it follows a reported physical bend, but it remains below SOURCE-CONFIRMED/TEST-CONFIRMED because the final configuration was promised for later and is not present on the inspected thread page.

## Architectural significance

This field topology supplies an important bounded answer to a previously open 3600 question: at least one working LinuxCNC press-brake retrofit has used **independent per-side position control plus a differential synchronization loop**, rather than treating the ram as one actuator.

The sign/ownership concept is also useful: the synchronization controller is not described as adding arbitrary equal-and-opposite authority to both sides. Its reported action is to reduce the command of the side that is leading. That may preserve a useful 'do not make the lagging side chase faster' property, but the exact algebra, limits, clipping and timing are not yet inspectable and therefore must not be invented.

## Candidate call/data flow — evidence-bounded

Field-reported conceptual flow only:

`common Y target`
→ `left position PID` and `right position PID`
→ `left/right servo-valve commands`

plus

`Y1 feedback - Y2 feedback`
→ `sync PID(command=0)`
→ `slow whichever side is ahead`

→ hydraulic cylinders / beam motion
→ independent Y1/Y2 position feedback

The exact insertion point of the sync correction relative to any velocity loop, dither, saturation, valve mapping, and spool-valve state machine remains **UNKNOWN**.

## Adversarial verification

1. **Does the successful bend prove the topology is generally safe?** No. It establishes reported physical functionality, not safety integrity or broad operating-envelope validation.
2. **Can we infer exact correction algebra from 'slowing the one that is ahead'?** No. Sign, gain, limiter, selection, and saturation details are absent.
3. **Does 'two position PIDs + one sync PID' prove there were no velocity loops in the final July config?** No. The February post explicitly discussed velocity PIDs; the July summary names position and sync PIDs but does not state whether velocity loops were removed.
4. **Can the sync PID saturation witness stand in for per-side valve/actuator saturation?** No. Controller saturation and downstream hydraulic authority remain separate witnesses.
5. **Does one 90-degree bend establish behavior during fast approach, pressure transition, dwell, decompression, return, faults, or sensor disagreement?** No.
6. **Does this resolve PB-PREP-001?** No. It is valuable field evidence but still lacks inspectable final realtime ordering, correction insertion, limit ownership, fault handling, and recovery semantics required for an architecture recommendation.

Result: **6/6 boundary checks passed.**

## Updated evidence boundary

Promote the tandem branch from merely 'field synchronization reported' to:

**COMMUNITY-REPORTED FIELD SUCCESS WITH DISCLOSED HIGH-LEVEL TOPOLOGY:** independent Y1/Y2 position PIDs + differential sync PID (`command=0`, feedback `Y1-Y2`) whose reported correction slows the leading side.

Do **not** promote it to source-confirmed final implementation.

## Next evidence needed

Highest-value next evidence is the promised final configuration or equivalent inspectable component/HAL source showing:

- exact Y1/Y2 PID wiring and thread order;
- exact sync-correction insertion and sign logic;
- correction/output limits and interaction with per-side saturation;
- spool-valve/process-state gating;
- feedback freshness and sensor disagreement handling;
- fault ownership and recovery;
- behavior across approach, bend, dwell/decompression and return.

Until that appears, PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**. Do not synthesize a final controller from this prose alone.
