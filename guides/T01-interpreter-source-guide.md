# T01 — G-code interpreter architecture: source guide

Status: SOURCE

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

This 1000-level guide establishes the architectural boundary between Task, the RS274/NGC interpreter, canonical machining functions, and the task/motion command queue. It deliberately does not attempt exhaustive language semantics or remap internals.

## Documentation baseline

Current LinuxCNC documentation describes Task as the coordinator that asks the interpreter to parse/execute G-code, while canonical operations produced by the interpreter are queued and later executed by Task. This creates read-ahead: interpretation may be well ahead of physical execution. Remap documentation also states that execution follows modal-group/order rules and that `INTERP_EXECUTE_FINISH`/queue-buster behavior is used when read-ahead must stop and execution must catch up.

Useful current docs:
- https://linuxcnc.org/docs/html/en/remap/remap.html (Task/interpreter interaction, queuing/read-ahead, remap execution)
- https://www.linuxcnc.org/docs/master/html/en/man/man1/rs274.1.html (standalone interpreter entry point)

## Community leads

LinuxCNC forum reports repeatedly warn that Python/remap code may run during interpreter read-ahead before corresponding machine movement. Experienced users recommend explicit queue-buster / `INTERP_EXECUTE_FINISH` synchronization where program semantics require execution to catch up. These reports are investigation leads, not source authority, but they align with the documented architecture.

Representative discussions:
- https://forum.linuxcnc.org/40-subroutines-and-ngcgui/52204-remap-and-code-execution-order
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/54342-ignore-hard-and-or-softlimits-for-toolchange

## Source inventory

| Path | Symbol / structure | Role | Evidence |
|---|---|---|---|
| `src/emc/task/emctask.cc` | `pinterp`, `emcTaskPlanRead()`, `emcTaskPlanExecute()` | Task-side interpreter adapter; propagates interpreter errors | SOURCE-CONFIRMED |
| `src/emc/task/emctaskmain.cc` | task main state machine | Calls plan read/execute while running programs and reacts to interpreter return codes | SOURCE-CONFIRMED (inventory; deeper trace pending) |
| `src/emc/rs274ngc/rs274ngc_pre.cc` | `Interp::read()`, `Interp::_read()`, `Interp::_execute()` | External interpreter interface; input acquisition/parsing and execution wrapper | SOURCE-CONFIRMED |
| `src/emc/rs274ngc/interp_execute.cc` | `Interp::execute_block()` | Executes a parsed block in defined semantic order and delegates conversion | SOURCE-CONFIRMED |
| `src/emc/rs274ngc/interp_convert.cc` | `Interp::convert_motion()` and conversion helpers | Converts parsed G-code semantics into canonical machining calls | SOURCE-CONFIRMED |
| `src/emc/rs274ngc/interp_internal.hh` | `_setup` and parsed block state | Interpreter modal/execution world model | SOURCE-CONFIRMED (inventory) |
| `src/emc/nml_intf/canon.hh` | canonical API such as `STRAIGHT_TRAVERSE()` | Abstract machining-operation interface between interpreter semantics and controller implementation | SOURCE-CONFIRMED |
| `src/emc/task/emccanon.cc` | `STRAIGHT_TRAVERSE()`, `tag_and_send()` | LinuxCNC task implementation of canonical operations; transforms units/offsets and appends trajectory messages to `interp_list` | SOURCE-CONFIRMED |
| `src/emc/nml_intf/interpl.hh` | `interp_list` | Queue carrying interpreter-generated EMC commands toward Task execution | SOURCE-CONFIRMED (inventory) |

## Significant symbols

### `emcTaskPlanRead()` — `src/emc/task/emctask.cc`

**Purpose:** Task-side wrapper around `interp.read()`.

**Control flow:**
1. call `interp.read()`;
2. if `INTERP_FILE_NOT_OPEN`, attempt to reopen the file recorded in task status and resume;
3. return interpreter status to the task state machine.

**Boundary:** userspace Task -> pluggable interpreter object.

**Failure behavior:** interpreter return codes are preserved for task-level handling. This is not a realtime servo-thread path.

### `emcTaskPlanExecute()` — `src/emc/task/emctask.cc`

**Purpose:** Task-side wrapper around interpreter execution. AUTO execution uses a previously read block; MDI can pass a command string.

**Important behavior:** the overload with line number calls `interp.execute(command, line_number)` and, for error-class return codes, calls `print_interp_error()`. `print_interp_error()` stores `interpreter_errcode`, obtains interpreter error text and call-stack names, emits an operator error, and optionally prints the interpreter stack under debug.

**Failure path:** interpreter error -> task error state/operator-visible diagnostic; no claim is made that this constitutes a safety-rated stop mechanism.

### `Interp::read()` / `Interp::_read()` — `src/emc/rs274ngc/rs274ngc_pre.cc`

**Purpose:** acquire one command/file line, parse it, and populate the current parsed block/world-model state.

`Interp::read(const char *)` wraps `_read()` and unwinds interpreter call state on error. `read()` with no argument delegates to `read(NULL)` for file/AUTO operation.

**Key architectural point:** read/parse is distinct from block execution. A successfully parsed block is not yet proof that the machine performed the requested operation.

### `Interp::_execute()` / `Interp::execute_block()`

`_execute()` is the external execution wrapper. For MDI text it first invokes `read(command)`. For a nonblank parsed block it ultimately executes semantic operations, including remap handling. `execute_block()` in `interp_execute.cc` is the central parsed-block dispatcher and invokes conversion functions in LinuxCNC's defined execution order.

**Special return:** `INTERP_EXECUTE_FINISH` is not ordinary completion; it tells the caller that execution/read-ahead must synchronize before proceeding.

### `Interp::convert_motion()` — `src/emc/rs274ngc/interp_convert.cc`

**Purpose:** dispatch a block's selected motion mode into the appropriate conversion path. `execute_block()` calls it when `block->motion_to_be != -1` at the motion execution step.

For a representative rapid move, the conversion path determines target coordinates from parsed/modal state and reaches the canonical `STRAIGHT_TRAVERSE(...)` interface.

### `STRAIGHT_TRAVERSE()` / `tag_and_send()` — `src/emc/task/emccanon.cc`

**Purpose:** controller-side implementation of the canonical rapid move.

**Important state transformations:** canonical code tracks program units, G5x/G92/tool offsets, coordinate rotation and the predicted canonical endpoint. It builds a trajectory command in controller/external units.

**Queue boundary:** `tag_and_send()` attaches a `StateTag` to an `EMC_TRAJ_CMD_MSG` and appends it to `interp_list`. Thus a canonical call generated during interpreter execution normally creates queued controller work; it does not directly perform realtime motion.

**Representative edge behavior:** several canonical motion paths append only when computed velocity/acceleration are nonzero, while still updating the predicted endpoint. This deserves deeper 2000-level treatment because zero-length/degenerate segment handling can affect debugging, but it does not invalidate the 1000-level architectural boundary.

## Modal / execution state

The interpreter's `_setup` world model carries modal state and interpreter execution state across blocks. Read-ahead means this predicted/interpreter state can be ahead of controller/machine execution state. Code that observes or changes external state during remap therefore must not casually assume 'current interpreter line' equals 'currently executing machine motion'.

## Claims ledger

| Claim | Classification | Confidence |
|---|---|---|
| Task invokes the interpreter through `InterpBase` wrappers rather than implementing RS274 semantics itself | SOURCE-CONFIRMED | high |
| Parsing and execution are separate interpreter phases | SOURCE-CONFIRMED | high |
| Parsed/executed interpreter operations can be queued ahead of physical execution | SOURCE-CONFIRMED + DOC-CONFIRMED | high |
| Canonical machining functions form the semantic-output boundary from interpreter conversion to Task/controller messages | SOURCE-CONFIRMED | high |
| `INTERP_EXECUTE_FINISH` is a synchronization/read-ahead boundary, not ordinary success | SOURCE-CONFIRMED + DOC-CONFIRMED | high |
| Python/remap side effects may occur during read-ahead unless synchronization is deliberately introduced | DOC-CONFIRMED + COMMUNITY-REPORTED; source trace incomplete | medium-high |

## Safety boundary

Interpreter correctness and synchronization are ordinary machine-control correctness issues. Neither the interpreter, read-ahead queue, remap mechanism, nor Task error handling is treated here as an independently safety-rated function.

## Higher-level promotion queue

1. Exact zero-length / zero-velocity canonical segment suppression semantics and state-tag consequences — 2000 / MEDIUM. Non-blocking: architectural queue boundary is already source-confirmed.
2. Deep remap generator/prolog/epilog call-state machine and Python exception propagation — 2000 / HIGH. Non-blocking for T01 1000 because T01 only requires the architectural remap/read-ahead boundary.
3. Version comparison of parser internals and pluggable interpreters — 2000 / MEDIUM.
