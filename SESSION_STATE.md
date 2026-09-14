# Active Curriculum Session State

Session start UTC: `2026-09-14T22:36:15Z`
Session end UTC: `2026-09-14T22:49:23Z`
Actual elapsed: **13.1 minutes**
Status: **CLOSED — 3700 local source stops preserved; active work rotated to 3800 and saw/feed/sequence/extra-joint/indexer/cell authority advanced.**

## Prerequisite state

The 1000 and 2000 series remain **GRADUATED / CLOSED**. F02 remains graduated under the preserved valid information-separated evaluation. No closed prerequisite work was reopened or rescored.

## Branch selection

Repository-authoritative state at session start made **3700 Grinding / EDM / Specialty Finishing** active. The wire-EDM process-authority path and first grinder architecture comparison were advanced until each reached a clean public/source boundary, then work rotated under `WORK_SELECTION_POLICY.md` to the already-mapped **3800 Saws / Feeders / Indexing / Automation Cells** branch instead of repeating low-yield searches.

Latest active checkpoint: `checkpoints/3800-next-2026-09-14.md`.

## Durable 3700 work completed

Created:

- `research/3700-wire-edm-real-authority-openedm-reconciliation-2026-09-14.md`
- `research/3700-grinder-servo-vs-hydraulic-authority-comparison-2026-09-14.md`

### Wire EDM result

Real Sodick A320s chronology now separates successful LinuxCNC XY/UV motion and existing wire transport from the much harder spark/process problem. The retrofit eventually produced cuts with a custom MOSFET generator but did not publicly mature into a production-quality process controller.

Adjacent OpenEDM source reinforces distinct process authorities: the arc generator has its own realtime power-stage/timing/current-limit state machine, while the wire tensioner has a separate load-cell/PID loop and low-tension stop rule. These are adjacent architecture evidence, not proof of LinuxCNC production behavior.

Preserve the minimum wire-EDM decomposition:

`program/XYUV geometry + adaptive path direction`

in parallel with:

`spark generator recipe/fault`, `wire run/tension/break`, and `dielectric/flushing readiness`.

Exact production gap-law filtering/hysteresis, mature spark handshake/fault behavior and complete wire-break/restart recovery remain public-source gaps. 3700-E2 is therefore paused until materially stronger implementation evidence appears.

### Grinding result

The first architecture comparison distinguishes:

- servo/ballscrew/direct-scale grinders, where direct scale closes around drivetrain error but does not eliminate backlash/compliance/stiction;
- hydraulic directional-table grinders, where binary LEFT/RIGHT reciprocation can be the correct state-machine abstraction and should not be disguised as a proportional servo axis.

Wheel readiness, dressing, workholding, coolant, infeed, spark-out and interrupted-cycle recovery remain separate grinding process authorities. A mature public process implementation is still needed before freezing a full grinder playbook.

## Durable 3800 work completed

Created:

- `research/3800-saws-feeders-automation-breadth-survey-2026-09-14.md`
- `research/3800-classicladder-realtime-sequence-recovery-source-trace-2026-09-14.md`
- `research/3800-pick-place-feeder-supervisory-vs-realtime-authority-2026-09-14.md`
- `research/3800-extra-joint-feeder-posthome-limit3-source-trace-2026-09-14.md`
- `research/3800-indexer-carousel-position-vs-lock-source-boundary-2026-09-14.md`
- `research/3800-industrial-cell-plc-python-linuxcnc-handshake-chronology-2026-09-14.md`

Updated:

- `checkpoints/3800-next-2026-09-14.md`
- `PROGRESS.md`

### Saw / feeder field result

The Marvel V10A commissioning chronology gives a concrete material-position failure: a linear-encoder-controlled hydraulic shuttle could reach the requested window yet continue creeping due to hydraulic leakage. Therefore:

**encoder position in tolerance != stock/mechanism stable**.

A separate LinuxCNC pick-and-place feeder implementation gives the complementary software boundary. Its M161 script pulses a ClassicLadder request input and exits without waiting for physical feeder completion. Therefore:

**command returned != actuator completed** and **request pulse issued != proven realtime event consumption**.

First reusable transaction model:

`fresh request -> deterministic sequence -> physical completion/stability -> fresh acknowledgement -> next cycle`.

### ClassicLadder source result

At pinned LinuxCNC revision `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`:

- `classicladder.0.refresh` is a realtime HAL function but ladder scans run no faster than 1 ms;
- scan order is HAL input copy -> ordered ladder/sequential sections -> HAL output copy;
- Grafcet transitions can cascade across multiple logical steps in one scan if downstream conditions are already true;
- ordinary STOP/RUN does not invoke `PrepareSequential()`;
- while STOPPED, the realtime task skips logic and output copying rather than generically forcing outputs false.

Preserve:

**ClassicLadder STOP != safe output state != cycle reset.**

### Extra-joint feeder result

Pinned docs/source establish that a homed extra joint leaves kinematics and takes its command from `joint.N.posthome-cmd`; Motion maps `posthome-cmd + motor_offset` directly to `motor-pos-cmd`, and the post-home command path does not use ordinary motor feedback as the position planner.

The shipped example uses `limit3`. Pinned `limit3` source shows that disabling it does **not** hold position; it makes the target zero and returns output toward zero under velocity/acceleration constraints.

Preserve:

**extra-joint planner enable semantics must be engineered deliberately; shipped `homed -> limit3.enable` wiring is not a complete feeder permissive.**

### Indexer result

Pinned `carousel.comp` is useful for encoded/index/count position acquisition, approach, alignment and in-position completion, but its `ready` output means **carousel in-position**. It is not a universal mechanical-lock/clamp proof.

A production indexed station with separate locking therefore needs an outer contract such as:

`unlock proof -> index move -> in-position -> lock command -> lock proof -> process authorization`.

### Industrial cell result

A long-running field example separates responsibilities cleanly:

- PLC: broader conveyors/pallets/heat-press/material flow;
- Python: Modbus + LinuxCNC supervisory bridge, product-code/G-code mapping and run/completion orchestration;
- LinuxCNC: CNC homing and cutting cycle.

The reported bridge waits for LinuxCNC completion before setting the PLC transfer bit, giving real evidence for completion-before-material-transfer. Exact heartbeat, generation and stale-bit handling are not public and remain UNKNOWN.

## Next work

Continue from `checkpoints/3800-next-2026-09-14.md`.

Priority order:

1. find a real saw/feeder/transfer implementation with explicit physical completion acknowledgement, stale-request handling and partial-cycle recovery;
2. if that bounded public search stops cleanly, deepen the PLC/supervisor handshake branch rather than repeating generic feeder searches;
3. find a real non-tool indexer with independent position and lock proof and compare it against the `carousel` source boundary.

Run a lab only if a concrete implementation exposes a nonduplicate uncertainty such as stale acknowledgement acceptance, extra-joint re-enable/retained-target behavior or exact abort cleanup.

## Laboratory state

No lab was run. `LAB_COMPUTE_LOG.md` remains unchanged at the preserved exactly recorded total of **338.56 minutes (5.64 h)**; historical gaps mean that is not a trustworthy full-project total.

## Overlap

**No overlap.** Previous canonical session ended `2026-09-14T21:50:44Z`; this session began `2026-09-14T22:36:15Z`, **45m31s later**.
