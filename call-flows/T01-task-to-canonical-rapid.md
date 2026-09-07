# T01 call flow — AUTO G0 block from Task to queued trajectory command

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Representative input

A normal AUTO program block such as `G0 X1.0` with no remap and otherwise valid modal/configuration state.

## End-to-end source path

1. **Task program-running state machine** (`src/emc/task/emctaskmain.cc`)
   - decides that another program block may be read;
   - calls `emcTaskPlanRead()`;
   - later calls `emcTaskPlanExecute(NULL)` for AUTO execution.

2. **Task adapter** (`src/emc/task/emctask.cc`)
   - `emcTaskPlanRead()` -> `interp.read()`;
   - `emcTaskPlanExecute(NULL)` -> `interp.execute(NULL)` through the interpreter interface;
   - error-class returns are surfaced through task interpreter diagnostics.

3. **Interpreter read/parse** (`src/emc/rs274ngc/rs274ngc_pre.cc`)
   - `Interp::read()` -> `Interp::_read()`;
   - input line is acquired/normalized and parsed into an interpreter block;
   - parsed words and modal interpretation live in `_setup`/block state.

4. **Interpreter execution** (`rs274ngc_pre.cc`, `interp_execute.cc`)
   - `Interp::_execute()` executes the previously parsed AUTO block;
   - `Interp::execute_block()` processes block items in LinuxCNC's defined execution order;
   - when `motion_to_be` is present at the motion step, it calls `convert_motion(...)`.

5. **G0 semantic conversion** (`src/emc/rs274ngc/interp_convert.cc`)
   - `convert_motion()` selects the rapid/traverse conversion path;
   - target coordinates are resolved from parsed words plus modal state;
   - the conversion path invokes canonical `STRAIGHT_TRAVERSE(line, target...)`.

6. **Canonical controller adapter** (`src/emc/task/emccanon.cc`)
   - canonical positions are converted through program/internal/controller units and active coordinate/tool transforms;
   - an `EMC_TRAJ_LINEAR_MOVE`-family trajectory message is populated for rapid motion;
   - `tag_and_send()` attaches the interpreter `StateTag` and appends the message to `interp_list` when the motion is nondegenerate.

7. **Queue / read-ahead boundary** (`interp_list`)
   - the canonical operation has become queued controller work;
   - Task later consumes queued commands and dispatches them toward motion execution;
   - therefore interpreter completion of this block is not equivalent to physical completion of its move.

## Read-ahead consequence

Task can continue asking the interpreter to read and execute later blocks while earlier canonical commands remain queued. Interpreter modal/predicted-position state can therefore be ahead of actual trajectory execution. Any remap or side-effect logic that assumes those states are synchronized is incorrect unless an explicit synchronization condition forces Task execution to catch up.

## Synchronization / queue-buster branch

When interpreter execution returns `INTERP_EXECUTE_FINISH`, Task must stop normal read-ahead progression, execute/drain the required queued work, synchronize interpreter/controller state, and only then continue interpretation. Remap/tool/input/probe operations can create these boundaries.

## Representative failure path

Malformed or semantically invalid input:

`Task -> emcTaskPlanRead()/Execute -> Interp::_read() or execute_block()/convert_* -> interpreter error code -> emcTaskPlanExecute/Task error handling -> print_interp_error() -> task.interpreter_errcode + operator-visible error`

No corresponding valid motion command should be inferred merely because some earlier blocks were already queued. Whether already-queued commands are drained, aborted, or otherwise handled depends on the surrounding Task state/error path and is a distinct behavior to verify experimentally.

## Evidence boundaries

- SOURCE-CONFIRMED: Task wrappers, read/execute split, conversion to canonical call, canonical append to `interp_list`, error-code propagation.
- DOC-CONFIRMED: Task/interpreter queueing and read-ahead architecture; queue-buster synchronization concept.
- COMMUNITY-REPORTED: practical remap surprises from side effects running during read-ahead.
- UNKNOWN / experiment target: exact externally visible ordering for a chosen valid block followed by a deliberately invalid block in the standalone/task laboratory fixture.
