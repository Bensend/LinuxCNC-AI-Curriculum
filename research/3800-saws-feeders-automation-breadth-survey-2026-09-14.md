# 3800 — Saws, Feeders, Indexing and Automation Cells — breadth survey

Date: 2026-09-14
Status: RESEARCH / SOURCE-BOUNDARY

## Why 3800 was selected

3700 reached clean breadth-level local stops for wire EDM process authority and the first grinder architecture comparison. Per `WORK_SELECTION_POLICY.md`, rotation to a genuinely underdeveloped 3000 branch has higher information gain than repeating generic EDM/grinder searches.

## 1. Automatic saw field chronology — Marvel V10A

Primary community source:

- LinuxCNC forum, **Automatic band saw marvel v10a**, started 2025-07-20: https://forum.linuxcnc.org/30-cnc-machines/56677-automatic-band-saw-marvel-v10a

This is a particularly useful automation-cell build diary because the dominant control problem is not contouring. It is repeated clamp/feed/cut sequencing with imperfect hydraulics.

### Original / proposed machine functions

The builder describes:

- two hydraulic clamps/vices;
- a shuttle/feed mechanism;
- hydraulic actuation for feed and blade motion;
- saw blade motor and hydraulic pump/motor starters;
- possible miter-axis automation;
- intent to upload cut lists and operate from a purpose-built HMI.

The original shuttle used a hydraulic mechanism with a ballscrew/limit arrangement to constrain feed length. During retrofit the builder added a linear encoder and attempted closed positioning of the hydraulic shuttle.

### Commissioning failure that matters

By 2025-10-16, the field behavior exposed exactly why the actuator model matters:

- hydraulic leakage slowly drove the shuttle forward while nominally idle;
- commanded moves oscillated/jumped around the requested encoder position;
- after reaching the apparent target the shuttle continued creeping because the hydraulics leaked through.

A community response noted that PWM of ordinary 24 V bang-bang hydraulic valves can sometimes hit a position target with feedback, but significant spool overlap/deadband must be handled and the result is not equivalent to a servo valve.

### Durable 3800 lesson

For stock feeding, **position reached** is not enough. A production cut authorization needs at least:

`requested feed length`
→ `feeder motion authority`
→ `position reached`
→ `feeder physically stopped/stable`
→ `clamp transfer completed`
→ `stock retained by the cutting-side clamp`
→ `cut permitted`.

A leaking hydraulic shuttle demonstrates a stale-state hazard: encoder position can transiently be correct while the physical stock continues to creep. Therefore a feeder contract should distinguish:

- `position_in_window`;
- `velocity/stability witness`;
- `clamp command`;
- `clamp proof`;
- `feed-side clamp versus cut-side clamp`;
- `cycle generation/step identity`.

## 2. Existing working auxiliary-feeder pattern

Primary source:

- LinuxCNC forum, **[solved] Set up auxiliary axis to not affect the tool display (bar feeder)**, 2020-04-19: https://forum.linuxcnc.org/10-advanced-configuration/38873-set-up-auxillary-axis-to-not-affect-the-tool-display-bar-feeder

This implementation used a mill plus a bar feeder assigned to U. The operating pattern was explicitly:

`clamp bar -> machine pocket -> unclamp -> increment feeder U -> clamp -> machine -> ...`

The important architectural distinction is that the feeder is a **material-positioning auxiliary axis**, not part of the cutting kinematics during the machining operation. Its motion can therefore be modeled as a separate cycle phase even if LinuxCNC exposes it as a normal commanded axis.

This gives 3800 a useful separation:

- toolpath/cutting axes own geometry while material is clamped;
- feeder/indexer owns stock repositioning while cutting is inhibited;
- clamping state transfers authority between those phases.

## 3. High-cycle automation timing evidence

A separate 2025 custom-machine discussion describes a production sequence with approximately 1.8 s historical cycle time and a target below 2.5 s:

- verify material clamped;
- execute coordinated profile cut;
- move clear;
- command unclamp;
- wait for unclamp confirmation;
- servo-feed stock forward;
- clamp and wait for confirmation;
- execute cutoff move;
- rapid back and repeat;
- handle end-of-material as a separate scrap/drop routine.

This is useful evidence that 3800 cannot treat userspace/HMI state alone as the fast sequence authority where accumulated I/O latency matters. The machine designer was explicitly evaluating whether 50–100 ms I/O delays would accumulate enough to hurt cycle time.

### Transferable boundary

For short-cycle automation:

- fast physical interlocks and sequencing should live in realtime HAL/components, a PLC-class layer, or deterministic field I/O as justified;
- HMI/cut-list logic can remain userspace supervisory authority;
- safety-rated functions remain outside ordinary software control as required by the physical machine.

## 4. First reusable saw/feed state model

A generic automatic cutoff-saw cycle should be represented as explicit physical states, not merely a G-code list:

1. `IDLE / SAFE`
2. `LOAD_OR_STOCK_PRESENT`
3. `CUT_SIDE_CLAMPED`
4. `FEED_SIDE_CLAMP_RELEASED`
5. `FEED_MOVE`
6. `FEED_STABLE_AT_LENGTH`
7. `FEED_SIDE_CLAMPED`
8. `CUT_SIDE_TRANSFER / PROOF`
9. `SAW_READY`
10. `CUTTING`
11. `SAW_RETRACTED`
12. `PART_CLEAR / COUNT_UPDATE`
13. `NEXT_CYCLE or END_OF_STOCK`

The exact order of clamp transfer differs by machine. This list is a playbook scaffold, not a universal sequence.

## 5. Required authority/witness pairs

A 3800 implementation should avoid command-only logic. Candidate pairs include:

- saw motor command / blade-running or at-speed witness;
- saw-head advance command / head-position or down-limit witness;
- saw-head retract command / clear/up witness;
- clamp command / clamp proof or pressure witness;
- unclamp command / open witness;
- feeder position command / position + stopped/stable witness;
- miter command / angle-position and lock witness;
- stock-present observation / end-of-stock state;
- coolant/lube command / readiness where process requires it;
- chip conveyor or discharge command / jam/full fault where implemented.

Where a machine lacks physical feedback, the playbook must identify the resulting assumption rather than silently promote a timer to proof.

## 6. Partial-cycle recovery is the core 3800 problem

Unlike a mill where restart may often begin from a known geometric location, an automation cell can stop with material ownership split across clamps or a partially severed part.

Examples that must be explicit:

- abort during feed with both clamps open;
- abort after feeder reached position but before cut-side clamp proof;
- clamp sensor stuck while pressure is absent;
- saw head partially down;
- blade stopped inside material;
- stock end detected after a feed request;
- jammed/offcut still present during the next feed;
- miter axis unlocked or between angles.

The correct response is not automatically `resume from line`. Recovery needs a physical-state reconciliation screen/mode that exposes actuator commands, witnesses and the intended current cycle step.

## 7. Adversarial review

1. Does feeder encoder target reached prove stock is stationary? **No.** Marvel hydraulic creep is direct counter-evidence.
2. Can a bar feeder always be treated as part of cutting kinematics? **No.** The working U-axis implementation treats it as auxiliary material positioning.
3. Does clamp command prove stock is retained? **No.** A proof/pressure witness is separate where available.
4. Can a timer substitute universally for hydraulic motion completion? **No.** Leakage, pressure and load vary.
5. Is a custom Python HMI an appropriate sole fast-sequence authority? **Not established.** Userspace is suitable supervisory/UI authority, but deterministic fast I/O requirements must be evaluated separately.
6. Does LinuxCNC program pause identify which physical clamp owns the stock? **No.** That state belongs to machine sequencing.
7. Is automatic restart safe after any partial cycle if axis positions are known? **No.** Material/clamp/blade state can be inconsistent despite known positions.

Result: **7/7 boundaries preserved.**

## 8. Next evidence priorities

3800 now has enough evidence for a first saw/feed contract. Highest-value next work:

1. inspect LinuxCNC `ClassicLadder` / HAL state-machine patterns relevant to partial-cycle automation and manual recovery;
2. find a public completed saw/feeder configuration or custom component with explicit clamp/feed/saw sequencing;
3. inspect miter-head locking and cut-list HMI authority if a strong implementation appears;
4. compare a saw with a non-saw automation cell (magazine/part transfer/indexing) to separate reusable automation patterns from blade-specific logic;
5. source-trace program pause/abort versus custom actuator-output ownership only where a specific implementation depends on it.

No lab is justified yet; field chronology already exposes the main first-pass failure mode.
