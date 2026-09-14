# 3800 Supervisory Freshness + Locking Indexer Reconciliation

Date: 2026-09-14
Status: **SOURCE/FIELD PASS COMPLETE — COMPLETION-FEEDBACK SAW PATH BOUNDED; A2/I2 ADVANCED**
Pinned LinuxCNC revision for source claims: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

## Purpose

Continue the active 3800 checkpoint without repeating the already-bounded Marvel/open-loop feeder evidence. The target questions were:

1. does a stronger public saw/bar-feeder/transfer implementation expose explicit physical completion, stale-request prevention and partial-cycle recovery;
2. what freshness/generation primitives LinuxCNC itself exposes to a PLC/Python supervisor;
3. whether a real non-tool locking indexer supports the curriculum's existing `position != lock proof` rule.

## 1. Completion-feedback saw / feeder search

### Result

**BOUNDED PUBLIC-SOURCE STOP.**

A fresh targeted search of LinuxCNC forum and public GitHub material found the already-preserved Marvel V10A case and generic/custom feeder references, but did not expose an inspectable production saw/bar-feeder implementation containing all of:

- request generation identity or generation count;
- explicit physical completion acknowledgement;
- stale-ack rejection across repeated cycles;
- feeder stable/stopped witness distinct from encoder-in-window;
- clamp proof/pressure proof;
- timeout/jam path;
- interrupted-cycle reconciliation.

This absence is a research gap, not proof that such implementations do not exist.

### Preserve

Do **not** keep repeating generic saw/bar-feeder searches. Reopen 3800-S2/F2 only when a named public config/repository/build diary exposes stronger completion/recovery internals.

Evidence classification: `UNKNOWN / SOURCE-UNAVAILABLE` for a mature public full transaction implementation.

## 2. Production PLC/Python/LinuxCNC cell chronology

The hhscott industrial automation project provides a long-running production example with the following public chronology:

- raw material rides circulating pallets through a heat-press/lamination section and a four-axis LinuxCNC cutting station;
- PLC/HMI owns product code and broader machine flow;
- Python bridges PLC and LinuxCNC;
- Python reads the product code over ModbusTCP and loads the matching G-code through the LinuxCNC Python/NML interface;
- when the pallet reaches the cutter, the PLC sets a bit read by Python;
- Python starts LinuxCNC;
- after LinuxCNC reports cut-cycle completion, Python sets a PLC bit allowing transfer to the next station;
- the machine automatically homes on startup and re-homes after E-stop events;
- the author reported in February 2026 that the system had run daily for more than four years producing thousands of parts.

This is strong `COMMUNITY-REPORTED` field evidence for **completion-before-transfer** and for the responsibility split:

`PLC material/cell state -> Python supervisory bridge -> LinuxCNC coordinated CNC cycle -> completion -> PLC transfer authorization`.

It does **not** publish the bridge source or exact request/ack register map, so generation numbers, edge handling, stale-bit rejection, heartbeat timeout and duplicate-cycle prevention remain UNKNOWN.

## 3. LinuxCNC Python/NML freshness primitives at the pinned revision

Pinned official Python-interface documentation exposes several primitives that matter directly to a robust supervisory bridge.

### Command serial / echo

Every command sent by a UI carries a serial number. `linuxcnc.stat().echo_serial_number` reports the serial number of the last completed command.

Therefore a supervisor can distinguish:

`command object returned`

from:

`that specific LinuxCNC command has been executed/acknowledged by Task`.

This is not, by itself, proof that an entire G-code program has finished or that a physical part is safe to transfer.

### Task and motion heartbeat

Pinned docs expose:

- `taskbeat`: Task main-loop heartbeat, incrementing each Task cycle according to `[TASK]CYCLE_TIME`;
- `heartbeat`: Motion-controller heartbeat, incrementing every servo cycle.

These are useful liveness witnesses. They do not establish application-level request freshness unless the external bridge actually samples and time-qualifies them.

### Execution/interpreter state

Pinned docs expose independent status surfaces:

- `exec_state`, including `EXEC_DONE`, waiting states and `EXEC_ERROR`;
- `interp_state`, including `INTERP_IDLE`, `INTERP_READING`, `INTERP_PAUSED`, `INTERP_WAITING`;
- `inpos` for trajectory in-position;
- error-channel polling for error messages.

Upstream LinuxCNC tests commonly qualify idle completion with multiple state checks instead of treating one flag as a universal completion witness.

### Durable interpretation

A production supervisor should keep four questions separate:

1. **Was my command accepted/executed?** — command serial vs `echo_serial_number`.
2. **Is LinuxCNC still alive/fresh?** — Task/Motion heartbeat or equivalent timed liveness.
3. **Has the requested CNC cycle actually finished normally?** — appropriate execution/interpreter/motion/error state combination for the application.
4. **Is the physical workpiece safe to transfer?** — local machine/cell physical witnesses and process-specific completion criteria.

Preserve:

**command acknowledgement != program completion != physical transfer permission.**

## 4. Fresh request/ack transaction model

The field chronology plus pinned LinuxCNC primitives supports a stronger 3800 supervisory contract without pretending the original machine publicly implements every field:

`request_generation + recipe/part identity`

`-> receiver accepts only a new generation while ready`

`-> LinuxCNC command serial is captured`

`-> echo_serial_number proves the intended command reached Task`

`-> cycle-active state becomes observable`

`-> cycle reaches normal completed state with no unresolved error`

`-> local physical/process completion is established`

`-> completion_generation echoes the accepted request_generation`

`-> sender authorizes transfer only on matching fresh completion`

This generation-tagged contract is an **engineering synthesis**, not a claim about hhscott's unpublished bridge. Classification: `INFERENCE / PLAYBOOK DESIGN`, grounded by source-confirmed LinuxCNC serial/liveness/state surfaces and field-confirmed completion-before-transfer architecture.

### Restart rule

After either side restarts, retained boolean `done=1` must not be accepted as completion for a new request merely because the level is high. At minimum, a production design needs either:

- generation/sequence identity;
- explicit clear-before-new-request protocol with proven state reconciliation;
- or another freshness mechanism that cannot confuse the previous cycle with the next one.

If workpiece/pallet state is uncertain after restart, software generation counters cannot reconstruct physical identity; recovery must reconcile the physical cell.

## 5. Second field architecture: LinuxCNC supervising multiple PLCs

A separate 2026 LinuxCNC forum report describes the opposite authority direction: LinuxCNC supervises six PLCs over MQTT in a larger interdependent plant.

Important reported boundaries:

- an independent safety system sits above the ordinary controls;
- a discrete signal communicates that the safety system has already disabled the plant;
- LinuxCNC normally initiates controlled shutdowns for ordinary abnormalities;
- the automatic startup sequence cannot complete if a locked-out machine fails to start;
- service mode gives maintenance personnel individual start/stop authority during downtime.

This is useful `COMMUNITY-REPORTED` evidence that:

- transport mastership and logical supervisory authority are separate design decisions;
- independent safety authority must not be conflated with software messaging;
- automatic startup should prove subordinate equipment readiness rather than merely issue start commands;
- service/manual authority is a separate mode from automatic sequence authority.

Exact MQTT freshness/heartbeat/generation implementation remains UNKNOWN.

## 6. Real non-tool locking indexer evidence

A LinuxCNC field case describes a rotary B-axis table with:

- hydraulic unlock/lock;
- table physically rising when unlocked;
- table lowering when locked;
- mechanical tooth engagement at one-degree station spacing;
- existing G0 operation using LinuxCNC locking-indexer support.

The recommended control concept explicitly uses separate proximity feedback for **up/unlocked** and **down/locked** state, with motion/jog permission conditioned on those witnesses.

This is important because it independently confirms the existing 3800 rule derived from `carousel.comp`:

`rotary position != mechanical lock state`.

The field mechanism naturally decomposes as:

`request unlock -> hydraulic output -> unlocked/up prox -> permit rotary motion -> reach target -> request lock -> locked/down prox -> permit process`.

The forum discussion also warns that continuously jogging a locking indexer can create awkward repeated unlock/lock behavior, reinforcing that manual/jog authority needs deliberate sequencing rather than assuming the normal G0 indexing transaction maps cleanly onto MPG motion.

Evidence classification: `COMMUNITY-REPORTED` field mechanism and control recommendation.

## 7. Native LinuxCNC locking-indexer surface and exact TP transaction

Pinned LinuxCNC source exposes per-joint HAL pins for configured lockable joints:

- `joint.N.unlock` — Motion output requesting unlock;
- `joint.N.is-unlocked` — Motion input reporting unlock state.

`unlock_joints_mask` determines which joints receive those pins, and the homing path can mark a locking indexer with `HOME_UNLOCK_FIRST`.

The pinned trajectory planner source closes the ordinary indexing-move transaction more precisely. An index move carries `indexer_jnum` on its trajectory segment. Before starting that segment, TP:

1. asserts the rotary unlock request with `tpSetRotaryUnlock(indexer_jnum, 1)`;
2. samples the physical unlock witness through `tpGetRotaryIsUnlocked(indexer_jnum)`;
3. returns `TP_ERR_WAITING` and does not start the move until that witness becomes true.

When the indexing segment finishes, TP does **not** immediately remove the finished segment. It first:

1. deasserts the unlock request with `tpSetRotaryUnlock(indexer_jnum, 0)`;
2. checks the same `is-unlocked` witness;
3. while the witness still says unlocked, returns without completing/removing the segment;
4. only falls through to normal segment completion after the witness becomes false.

Therefore native locking-indexer motion is explicitly bracketed by the configured physical unlock witness:

`unlock request -> wait is-unlocked=1 -> index motion -> lock request -> wait is-unlocked=0 -> complete segment`.

### Important failure boundary

In the inspected TP path there is **no local elapsed-time timeout** around either wait. The planner simply revisits the condition on later cycles. A failed/stuck unlock witness can therefore hold the indexing transaction waiting unless another supervisory/fault mechanism intervenes.

This is a crucial production boundary: an integrator should not mistake native physical acknowledgement for a complete fault policy. Timeout/fault annunciation, contradictory up/down sensors, hydraulic pressure qualification, manual recovery and safety behavior still belong to the machine design.

### Witness semantics boundary

The completion-side TP test waits for `is-unlocked` to become false. That means LinuxCNC's native generic contract proves only **not reporting unlocked**. On a machine such as the reported hydraulic rise/drop table that has distinct up/unlocked and down/locked proximity switches, production process authorization may still require the independent down/locked proof rather than treating `!is-unlocked` as equivalent to mechanically locked.

This is materially different from `carousel.ready`:

- `carousel.ready` reports indexed-position completion for the carousel mechanism;
- locking-indexer Motion has an explicit **physical unlock acknowledgement input** separate from commanded rotary position;
- neither generic surface proves fixture clamp pressure, workpiece retention, tooth engagement quality or a safety-rated condition beyond what the integrator's actual sensors establish.

## 8. Cross-process 3800 transaction model after this pass

The combined evidence now supports three nested acknowledgement layers:

### Software command layer

`fresh request -> command serial accepted/executed -> cycle state`

### Mechanism layer

`command -> actuator -> physical witness -> stable/complete mechanism state`

Examples:

- feeder: target -> carriage stable -> stock/clamp proof;
- indexer: unlock request -> unlock proof -> rotate -> lock request -> lock proof;
- CNC cycle: program start -> interpreter/execution completion -> machine/process completion.

### Cell/workpiece layer

`mechanism complete -> correct part/pallet physically in expected state -> fresh completion ack -> transfer authorized`.

A defect at one layer must not be papered over by a success indicator from another.

## 9. Adversarial verification

1. **PLC request bit remains high from the previous part. Can Python treat it as a new cycle?** No. A level alone has no freshness identity.
2. **`echo_serial_number` reaches the command serial. Is the pallet safe to transfer?** No. It proves the specific command reached Task, not program/process/physical completion.
3. **`exec_state == EXEC_DONE` alone proves successful end-of-cycle?** Not universally. Interpreter, error, motion/process and application state remain separate.
4. **Task heartbeat increments, so the PLC's cycle request is fresh?** No. LinuxCNC liveness and request freshness are different properties.
5. **Rotary encoder is exactly at 90 degrees. Is machining authorized?** Not if the mechanism requires a separate mechanical lock and lock proof.
6. **`joint.N.is-unlocked` is false. Does that prove the table is locked?** Not automatically; false only means the configured unlock witness is not asserted. A separate locked/down proof may still be required by the mechanism.
7. **`carousel.ready` can substitute for lock proof?** No. It reports position completion, not a universal mechanical lock state.
8. **After bridge restart, a retained `done=1` may be consumed for the next request?** No, not without a freshness/generation/reconciliation rule.
9. **Independent safety trip arrives over the same supervisory protocol, so ordinary software messaging is safety-rated?** No. Field evidence explicitly keeps safety authority separate.
10. **A generation-tagged handshake reconstructs an unknown pallet after power loss?** No. Software freshness cannot recover lost physical workpiece identity.
11. **Native locking-indexer TP waits for `is-unlocked=1`; therefore it has a built-in hydraulic timeout?** No. No local timeout was found in the inspected wait path.
12. **After the move, `is-unlocked=0` necessarily proves a separate lock switch is made?** No. It proves only the generic unlock witness is no longer asserted unless the machine wiring/logic deliberately makes that implication valid.

Result: **12/12 boundary checks passed.**

## 10. Lab decision

No lab is justified yet.

The LinuxCNC command-serial, heartbeat, state and locking-indexer wait distinctions are directly source/documentation-backed. A future lab would add evidence only if a concrete proposed supervisor or mechanism implementation needs validation of a specific stale-ack/restart or timeout design.

## Promotion / next work

3800-S2/F2 is at a bounded public-source stop. 3800-I2's generic native transaction is source-closed enough for the breadth pass; remaining lock-pressure/contradictory-sensor/recovery behavior is machine-specific and needs a stronger named implementation before more generic searching.

One final useful 3800 path remains: inspect another real automation cell/transfer implementation only if it publishes request identity, heartbeat or restart behavior. Otherwise rotate rather than repeat generic material-handling searches.

Per `CURRICULUM.md` and `WORK_SELECTION_POLICY.md`, the best next breadth rotation is **3100 — Mills/VMCs**: it is genuinely underdeveloped, has the broadest LinuxCNC community/config/source base, and its spindle-orient/rigid-tap/ATC/probing/tool-table/lube/pallet topics transfer strongly to several other tracks. 3900 remains available afterward for emerging/unusual machines.

Reopen the saw/feeder completion branch only when a named implementation exposes a materially stronger physical-ack/recovery contract.
