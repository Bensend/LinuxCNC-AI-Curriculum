# 3700 Grinder comparison — servo/direct-scale versus hydraulic/directional-valve

Date: 2026-09-14
Status: COMMUNITY / ARCHITECTURE EVIDENCE

## Purpose

Follow `3700-G1` after the wire-EDM process branch reached a clean public-source stop. This pass compares two materially different LinuxCNC surface-grinder retrofit architectures without pretending either forum thread is a finished canonical production implementation.

## A. Servo/ballscrew grinder — Parker Majestic 6x18

Primary source:

- LinuxCNC forum, **Parker Majestic CNC surface grinder**, started 2019-08-10: https://forum.linuxcnc.org/30-cnc-machines/37144-parker-majestic-cnc-surface-grinder

Observed architecture/evolution:

- Existing machine used AC servo axes, ballscrews on X/Y and a leadscrew/worm reduction on Z.
- Builder specifically wanted a linear encoder moved to Z and closed-loop position feedback in LinuxCNC because the worm train had play.
- Existing resolver motors/servo drives were difficult to reuse because resolver feedback terminated inside the drives and the drives did not provide simulated quadrature to LinuxCNC.
- The builder ultimately chose new Yaskawa Sigma-class motors/drives rather than preserve the original resolver chain.
- Community guidance proposed Mesa analog-servo hardware (`7i77` class) for LinuxCNC command authority.

### Transferable authority model

A servo grinder can look superficially like a mill, but direct linear feedback changes what the loop is observing:

`trajectory command -> LinuxCNC servo loop -> analog/drive command -> motor/transmission -> slide -> linear scale -> LinuxCNC`

versus motor-only feedback:

`trajectory command -> drive/servo -> motor encoder -> drive`, with LinuxCNC potentially seeing only a derived/simulated position.

The direct scale closes position around the worm/ballscrew/transmission, but it does **not** eliminate backlash, compliance, stiction or limit-cycle risk. A loose worm train can appear as oscillation/following-error behavior when the outer position loop tries to correct motion that the drivetrain cannot reproduce smoothly.

This thread is useful architecture evidence, but the inspected public chronology does not establish final tuning, dressing logic, wheel-ready interlocks or interrupted grinding-cycle recovery.

## B. Hydraulic/directional-valve grinder — 50-year-old horizontal surface grinder

Primary source:

- LinuxCNC forum, **Hydraulic + Linear Scale Surface Grinding Machine Retrofit**, started 2023-11-15: https://www.forum.linuxcnc.org/38-general-linuxcnc-questions/50690-hydraulic-linear-scale-surface-grinding-machine-retrofit

Observed architecture/problem statement:

- Table X is hydraulic reciprocation; builder initially described X/Y/Z as hydraulic but later inspection suggested Y/Z used screw mechanisms while X remained the central hydraulic question.
- Proposed feedback was linear scales into Mesa/LinuxCNC.
- Proposed actuator authority was simple directional-valve drive rather than servo/ballscrew replacement.
- Forum discussion distinguishes several hydraulic actuator classes that must not be conflated: simple on/off directional valves, on/off valves plus flow restriction/ramping, proportional `+-10 V` valves, and servo/EtherCAT valves.
- A community respondent explicitly warned that the table directional valve is poor for point positioning and that surface-grinder X may be better treated as reciprocation with end limits/stops rather than conventional contouring.

### Transferable authority model

For a simple hydraulic table, the relevant machine state may be:

`reciprocation request -> direction valve LEFT/RIGHT -> hydraulic table motion -> end/position witness -> reverse decision`

rather than pretending the axis is a continuously controllable servo:

`position error -> PID -> analog velocity command`.

If only binary directional authority exists, LinuxCNC following-error/trajectory semantics cannot magically create proportional positioning performance. Position scales remain useful for observation, reversal windows, cross-feed/down-feed coordination, diagnostics and possibly bounded slow approach if the hydraulics expose a separate slow/flow state.

If a proportional/servo valve is installed, then a genuine closed position/velocity loop becomes a different architecture and must be tuned as such.

## C. The key comparison

| Question | Servo/ballscrew + scale | Hydraulic directional table |
|---|---|---|
| Primary actuator authority | continuous servo command | discrete LEFT/RIGHT, unless proportional valve exists |
| Natural LinuxCNC abstraction | coordinated servo axis | often reciprocation/state machine first |
| Useful position feedback | motor encoder and/or direct scale | direct scale/end witnesses |
| Main loop hazard | backlash/compliance + nested loops | treating binary hydraulics like proportional positioning |
| Grinding-specific work | infeed, traverse pattern, dwell/spark-out, dress | reversal windows, cross/down-feed, dwell/spark-out, dress |
| Abort concern | stop axes + wheel/coolant/workholding reconciliation | neutralize/reconcile valve state + hydraulic motion + wheel/coolant/workholding |

## D. Grinder process authority that remains separate from axis motion

Neither architecture justifies reducing grinding to XYZ motion. A production playbook needs distinct ownership for:

- grinding-wheel spindle command, at-speed/ready and fault;
- wheel dressing request, dresser motion/contact allowance and post-dress wheel-size compensation;
- workholding (magnetic chuck/vacuum/fixture) command and proof;
- coolant command/readiness where required;
- reciprocation/traverse state;
- downfeed/infeed increment and accumulated stock removal;
- spark-out dwell/pass count;
- wheel wear/diameter state if used for compensation;
- cycle pause/abort/restart reconciliation.

The inspected threads do **not** publicly expose all of these. They establish actuator/feedback architecture, not a complete production grinding state machine.

## E. Failure/recovery reasoning

### Servo/direct-scale

On interruption, do not assume `position feedback valid` means the grinding cycle can resume. Recovery needs at least wheel state, workholding, coolant, current pass/infeed state and whether the wheel is clear of the work. Direct scale helps recover slide position but does not reconstruct process chronology.

### Hydraulic directional table

A custom abort contract must explicitly command a safe hydraulic valve state and account for continuing/coasting hydraulic motion. Generic motion abort semantics are not enough if the physical valve is controlled by custom HAL outputs or a machine-specific state machine. End-of-stroke/reversal state must be reconciled before resuming the cycle.

## F. Adversarial review

1. Does a linear scale make a hydraulic on/off table a servo axis? **No.**
2. Does direct scale eliminate drivetrain backlash/compliance? **No.**
3. Can a binary directional valve be treated as `+-10 V` velocity authority? **No.**
4. Does replacing old servos solve grinding process sequencing? **No.**
5. Is X table positioning always the main accuracy requirement on a surface grinder? **No.** Surface-grinding X can be primarily reciprocation while cross/down feed controls stock removal.
6. Does generic LinuxCNC abort necessarily reconcile custom hydraulic valve outputs? **No.**
7. Are these two forum projects evidence of completed production grinding HMIs/process recovery? **No.**

Result: **7/7 boundaries preserved.**

## G. Promotion / next evidence

3700-G1 has enough evidence for a first architecture distinction but not enough for a full grinder playbook. Highest-value reopening evidence:

- a mature LinuxCNC grinder config/remap/custom component that exposes dress, infeed, spark-out and recovery;
- a real hydraulic table implementation showing exact reversal/slowdown/neutral behavior;
- a grinder with direct scales and documented outer-loop tuning;
- an inspectable cylindrical/nonround grinder implementation with wheel/workpiece spindle synchronization.

Without one of those, another generic `surface grinder retrofit` search has diminishing return. Rotation to an underdeveloped 3000 branch is preferable.
