# 3200 Lathe / Turning Center — spindle-sync pause, index acquisition and failure boundary

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Track: 3200 — Lathes / Turning Centers
Status: **SOURCE CONFIRMED; upstream synchronized-motion program inventory inspected**

## Purpose

Close the open 3200 checkpoint around position-synchronized threading behavior by tracing:

- what ordinary pause does during a synchronized move;
- how the first spindle index is acquired;
- what happens when index never arrives;
- how spindle-at-speed differs from phase/index acquisition;
- how abort differs from pause;
- what upstream regression/program material does and does not independently verify.

This pass is intentionally bounded. It does not claim that every post-index spindle-feedback failure is detected by the trajectory planner itself; that requires the relevant feedback/following-error path for the deployed spindle implementation.

## Source boundary

Pinned source inspected:

- `src/emc/tp/tp.c`
- `src/emc/motion/control.c`

Relevant upstream program/test inventory:

- `tests/trajectory-planner/circular-arcs/nc_files/spindle/g33_simple.ngc`
- `tests/trajectory-planner/circular-arcs/nc_files/spindle/g33_blend.ngc`
- `tests/trajectory-planner/circular-arcs/nc_files/spindle/spindle-wait.ngc`
- `tests/trajectory-planner/circular-arcs/run_all_tests.py`

The circular-arcs auto-test tree includes the `spindle` program directory. The harness loads selected `.ngc` files and requires the programs to complete successfully, so these are real upstream regression inputs for spindle-related TP behavior. They are **not**, by inspection alone, dedicated fault-injection tests for a missing index or a pause injected at a selected servo cycle.

## 1. Pause and position-synchronized motion

At the pinned revision:

```text
tpPause()  -> tp->pausing = 1
tpResume() -> tp->pausing = 0
```

The important behavior is in the trajectory planner feed-scale decision. The planner only converts a pause into zero feed scale when the current segment is unsynchronized or velocity-synchronized. For a **position-synchronized** segment (`TC_SYNC_POSITION`), the ordinary pause path does not force the current segment's scale to zero; the synchronized segment continues with the phase relationship intact.

The practical lathe consequence is deliberate:

> An ordinary feed-hold/pause is not implemented as an arbitrary mid-thread deceleration that destroys spindle-to-axis phase.

The pause request remains meaningful, but its effect is deferred to an appropriate segment boundary rather than corrupting the active position-synchronized move.

This is materially different from an abort, which is an ownership-terminating/fault path and is allowed to stop/clear execution state rather than preserve the ordinary resumable synchronization contract.

## 2. Position-sync index acquisition

When a `TC_SYNC_POSITION` segment first needs synchronization and spindle sync is not already established, `tp.c` enters an explicit index-acquisition state:

```text
waiting_for_index = current_tc_id
spindle_index_enable = 1
reset spindle offset / sync setup
```

The planner then checks the wait state before beginning ordinary synchronized progress.

If `spindle_index_enable` remains asserted, the planner returns the waiting condition and does **not** silently start the position-synchronized move.

When the encoder/motion side has seen the spindle index and clears the index-enable handshake, TP:

- marks spindle synchronization established;
- clears `waiting_for_index`;
- initializes synchronized acceleration/state;
- allows the position-synchronized segment to proceed.

### Missing-index result

If the index handshake never clears, this inspected TP path continues waiting. No TP-local automatic “assume phase anyway” fallback was found, and no generic timeout was found in this wait path.

Therefore the bounded rule is:

**No index witness -> no silent position-sync start.**

A production machine may add separate timeout/fault logic around the index acquisition, but that is a machine/configuration policy rather than a generic TP behavior inferred here.

## 3. Motion-side index handshake

`src/emc/motion/control.c` supplies the other side of the handshake.

Motion detects the spindle index-enable request, forwards the enable to the configured encoder/index source, and tracks the request edge. After the encoder/index source clears the request on a real index event, Motion clears its own synchronization-request state and, in the source comment's words, clears the spindle index-enable condition because TP is waiting for that signal before proceeding.

This matters diagnostically: index acquisition is represented by an explicit shared control handshake, not by timestamp proximity between unrelated GUI/status observations.

For troubleshooting a thread that never starts, inspect at least:

```text
TP waiting-for-index state
        -> motion spindle index-enable request
        -> encoder/index-enable path
        -> physical/index-source event
        -> request clear back to TP
```

Do not jump directly from “spindle is rotating” to “threading phase has been acquired.”

## 4. `at-speed` is a different gate

TP also has a separate `waiting_for_atspeed` condition. When a move requires the spindle to be at speed, TP waits until the required spindle `at-speed` state is valid.

That gate is not the same as index/phase acquisition:

- **at-speed** asks whether the spindle is ready at the commanded operating speed under the configured readiness contract;
- **index acquisition** establishes the angular phase reference required for position-synchronized motion.

A spindle can be turning and at speed yet still be waiting for the index event. Conversely, an index pulse existing historically does not prove the spindle is presently at commanded speed.

The upstream `spindle-wait.ngc` program is explicitly labelled as an at-speed test and includes a commanded spindle start followed by subsequent motion. It is useful upstream coverage of spindle readiness behavior, but it must not be misreported as a dedicated index-failure test.

## 5. Upstream synchronized-motion program coverage

The upstream trajectory-planner program set contains concrete synchronized inputs:

### `g33_simple.ngc`

Starts the spindle and executes a simple `G33 Z-2 K0.025` threading move.

### `g33_blend.ngc`

Exercises a sequence of position-synchronized `G33` moves, including tangent/arc blending while in position-sync mode and explicit transitions between normal-feed and synchronized motion.

This is particularly useful evidence that the TP regression surface intentionally includes synchronization-mode transitions and multiple synchronized segments, not only a one-line parser test.

### `spindle-wait.ngc`

Exercises the at-speed readiness surface separately.

### Harness boundary

`run_all_tests.py` discovers `.ngc` files in the selected auto-test folders, runs each program through LinuxCNC in AUTO, and fails if a selected program does not complete.

This supports the statement that synchronized spindle programs are part of the upstream TP regression inventory. It does **not** independently establish a servo-cycle-specific pause injection or a deliberately withheld index pulse because the inspected harness does not inject those faults.

## 6. Failure-mode table

| Scenario | Bounded result from inspected source | What must not be inferred |
|---|---|---|
| Spindle not at speed | TP remains at the separate at-speed readiness gate when required | Does not prove index/phase is bad |
| Required first index never arrives | TP remains waiting for index; synchronized move does not silently begin | No generic timeout should be invented from this source |
| Ordinary pause requested during `TC_SYNC_POSITION` | Active position-synchronized segment is not feed-scaled to zero mid-segment; phase-preserving behavior is retained | Pause is not equivalent to abort/E-stop |
| Resume after ordinary pause | clears the planner pause request | Does not recreate state lost by an abort |
| Abort | abort path can stop/clear execution and synchronization wait state | Must not be treated as resumable feed-hold semantics |
| Post-index encoder freezes/jumps | **not resolved by this pass as a TP-local detection guarantee** | Do not claim index acquisition authenticates all later spindle feedback |

## 7. Diagnostic decomposition for a lathe

For threading/G33/G76 troubleshooting, separate these surfaces:

1. spindle command issued;
2. spindle physical/feedback speed;
3. configured `at-speed` readiness;
4. index-enable request active;
5. index event actually observed / request cleared;
6. TP synchronized-state established;
7. synchronized segment executing;
8. ongoing spindle-position feedback remains valid;
9. ordinary pause requested;
10. abort/fault path asserted.

A GUI showing “spindle on” collapses too many of these layers and is not sufficient evidence for synchronized-cut readiness.

## 8. Lab decision

**No new synthetic lab was launched in this pass.**

The current open questions about pause, initial index wait, and at-speed separation are answered directly by pinned source, and upstream TP regression inputs demonstrate that G33 synchronized programs and at-speed behavior are represented in the test corpus.

A future lab would add real information if it targets a still-open boundary such as:

- deliberately withholding/losing the index-enable clear and measuring the exact external status behavior/operator recovery;
- freezing or corrupting spindle-position feedback **after** initial index acquisition and tracing which configured LinuxCNC fault path detects it;
- comparing pause, feed-inhibit and abort in one retained synchronized-motion trace.

Those experiments should be frozen only if later source/config inspection does not already answer the needed machine-specific question.

## 3200 teaching rules

- Treat **spindle speed readiness** and **angular phase acquisition** as different authorities.
- Treat the index-enable handshake as a real synchronization witness, not a cosmetic pin.
- Do not implement ordinary pause by destroying phase in the middle of a position-synchronized thread.
- Treat abort as a different ownership/recovery class from ordinary feed hold.
- Initial index acquisition does not by itself prove all future spindle feedback remains physically correct.