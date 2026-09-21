# Pilz PMCprotego — brake proof and safe-motion composition boundary

Date: 2026-09-21
Track: 25E0 / 4000 safety

## Question

Does a professional implementation expose a reusable architecture that combines brake/retaining evidence with independent motion evidence continuously or at every hazardous transition, rather than relying only on a periodic proof test?

## Authoritative evidence

### DOC-CONFIRMED — common safe-drive platform

Pilz documents PMCprotego S/DS as a drive-integrated safety platform providing safe motion-monitoring functions together with Safe Brake Control (SBC) and Safe Brake Test (SBT). The platform uses motor feedback for safe motion monitoring and supports vertical-axis / suspended-load applications.

Source: Pilz, *Safe motion with safety card PMCprotego S* (current public product documentation, inspected 2026-09-21): https://www.pilz.com/en-INT/products/drive-technology/servo-amplifiers/pmcprotego-safe-motion

### DOC-CONFIRMED — SBT is an active brake proof, not merely a command/status witness

Pilz states that SBT checks brake function and can detect faults in brake control and brake mechanics. Pilz further states that the brake test may be performed every production cycle or at a longer interval depending on application and risk analysis.

Source: same Pilz PMCprotego documentation; also Pilz Safety Compendium, Chapter 7 Safe Motion.

### DOC-CONFIRMED — motion monitoring is a distinct safety-function family

Pilz separately documents safe motion monitoring (direction, speed and related motion conditions) using drive feedback. Its functional-safety guidance distinguishes safe monitoring functions from the reaction/shutdown path; a monitoring limit violation does not by itself define every required machine reaction.

Sources:
- https://www.pilz.com/en-INT/products/drive-technology/servo-amplifiers/pmcprotego-safe-motion
- https://www.pilz.com/en-US/support/lexicon/articles/200448

## What this proves

This is a useful professional architecture because one safety platform can contain:

`safe brake control + active brake proof + independent motion feedback/monitoring + safe stop/torque functions`

For a vertical/gravity axis, that is materially stronger than treating a brake auxiliary contact as proof of retaining capability.

## What the public evidence does NOT prove

The inspected Pilz public material does **not** establish that SBC state and encoder-derived motion state are conjunctively evaluated on every hazardous transition as one universal two-witness permissive. It also does not expose one universal post-SBT-failure state machine defining reset edge, retest requirement, held ordinary Start behavior and production re-entry.

Therefore do not upgrade the evidence into either of these claims:

- `brake commanded + zero speed => retaining capability continuously proved`; or
- `SBT failure cleared => production restart semantics known`.

Those remain UNKNOWN without product/application-specific documentation.

## Engineering freezes

- **COMMON SAFETY PLATFORM != COMMON DECISION SEMANTICS.** Co-location of SBC, SBT and safe motion functions does not prove that all are ANDed on every transition.
- **SAFE MOTION FEEDBACK != BRAKE HOLDING CAPABILITY.** Encoder evidence and brake proof have different physical authority.
- **SBT PASS != CONTINUOUS BRAKE PROOF.** A proof test establishes capability at the tested condition/time; it is not a continuous torque witness between tests.
- **ZERO/Safe SPEED != LOAD RETAINED.** A vertical load may be stationary while torque is still required to prevent later motion.
- **BRAKE APPLIED != BRAKE CAPABILITY PROVED.** Safe control of the brake and active proof of its mechanics are separate claims.
- **PER-CYCLE SBT != EVERY HAZARDOUS TRANSITION.** A production-cycle test frequency cannot be silently generalized to every safeguard opening, mode transition, E-stop recovery or jog transition.

## OpenPressBrake teaching consequence

Teach the architecture as typed evidence, not as a single `axis_safe` bit:

1. ordinary motion demand;
2. independent safety permission/mode;
3. drive safe-motion witness;
4. retaining-element command/state;
5. retaining-element proof-test status and age/context;
6. physical process state (motion/position and, where applicable, hydraulic pressure/stored energy);
7. reset/rearm state;
8. fresh ordinary start/jog demand.

A future OpenPressBrake implementation must define which of these are required for each transition from its own hazard analysis and validated machine architecture. Do not copy Pilz PL/SIL claims, intervals, limits or fault reactions.

## Information-gain stop

The narrow search for a public, vendor-authoritative **universal** algorithm that continuously ANDs brake state/capability and independent motion evidence at every hazardous transition remains source-limited. The Pilz platform demonstrates that these evidence classes can coexist professionally, but the public material inspected does not justify inventing the missing conjunction/restart semantics.

Next useful branch: move from product-function catalogs to a machine/application example or safety function block/manual that exposes the actual transition logic, especially a vertical/gravity axis where retaining state and motion are both explicit inputs to restart/rearm. If unavailable, rotate to commissioning/validation methodology for proving the witness chain physically.
