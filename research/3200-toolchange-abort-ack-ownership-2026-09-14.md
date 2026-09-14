# 3200 Lathe / Turning Center — tool-change abort and acknowledgement ownership

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Track: 3200 — Lathes / Turning Centers
Status: **SOURCE + UPSTREAM-TEST CONFIRMED, bounded interface conclusions**

## Question

What happens to LinuxCNC's ordinary `iocontrol.0` tool-preparation/tool-change handshake during abort/restart, and what does that imply for lathe turret logic that supplies `tool-prepared` / `tool-changed`?

This pass specifically avoids treating the generic handshake as proof that a lathe turret is physically clamped, locked or safe. Those are machine-specific completion witnesses.

## Source boundary

Pinned source:

- `src/emc/task/taskclass.cc`
- `src/emc/task/emctask.cc`
- `src/emc/task/emctaskmain.cc`
- upstream regression: `tests/toolchanger/abort-during-change/test-ui.py`

Canonical upstream URLs:

- https://github.com/LinuxCNC/linuxcnc/blob/f666f1a51ae7c4d991cc61233e785dcc53fbe98d/src/emc/task/taskclass.cc
- https://github.com/LinuxCNC/linuxcnc/blob/f666f1a51ae7c4d991cc61233e785dcc53fbe98d/tests/toolchanger/abort-during-change/test-ui.py

## Generic handshake traced

`Task::iocontrol_hal_init()` exports:

- `iocontrol.0.tool-prepare` — HAL OUT
- `iocontrol.0.tool-prepared` — HAL IN
- `iocontrol.0.tool-change` — HAL OUT
- `iocontrol.0.tool-changed` — HAL IN

`Task::emcToolPrepare()` resolves the requested tool/pocket/index, publishes the prep metadata, then raises `tool-prepare`. Unless a loopback completion was already observed in the same cycle, IO status becomes `RCS_EXEC`.

`Task::read_tool_inputs()` recognizes preparation completion with a **level condition**:

```text
tool-prepare == 1 && tool-prepared == 1
```

It records the prepared pocket/index, lowers `tool-prepare`, sets IO status `RCS_DONE`, and returns the internal completion marker `10`.

`Task::emcToolLoad()` raises `tool-change` for a valid prepared pocket. Unless a loopback completion was already observed, IO status becomes `RCS_EXEC`.

`Task::read_tool_inputs()` recognizes change completion with another **level condition**:

```text
tool-change == 1 && tool-changed == 1
```

Only then does it update the spindle tool state, call `load_tool()`, clear preparation metadata, lower `tool-change`, and return IO to `RCS_DONE`.

### Important ownership consequence

The ordinary v1-style handshake shown by this source has no per-request generation/episode identifier in these four pins. Therefore the external toolchanger logic owns an important part of correctness: an acknowledgement must represent completion of the **current** request, not merely remain high from an earlier request.

If an external implementation leaves `tool-prepared` or `tool-changed` high after the corresponding request has been reset, the next raised request can satisfy the level test immediately. That is a stale-acknowledgement hazard at the machine-integration boundary.

This is a source-level interface conclusion; it does not claim every existing toolchanger has the bug. A well-designed HAL/component/ladder state machine normally makes acknowledgement request-scoped by dropping/resetting it after request release and requiring the new physical sequence to complete before raising it again.

## Abort path

Pinned `Task::emcIoAbort()` does all of the following relevant work:

1. drops coolant outputs;
2. forces `iocontrol.0.tool-change = 0`;
3. forces `iocontrol.0.tool-prepare = 0`;
4. explicitly sets `emcioStatus.status = RCS_DONE`.

The source comment explains why the final step matters: once an abort drops the request output, `read_tool_inputs()` can no longer observe a normal request+ack completion handshake, so the IO wait must be explicitly released.

Search of the pinned Task sources shows `emcIoAbort()` is used by ordinary Task abort paths and state/error transitions, including Task abort and interpreter-error handling. This is not merely GUI cleanup.

## Upstream regression test

`tests/toolchanger/abort-during-change/test-ui.py` independently exercises the boundary.

The test documents the historical failure: aborting while tool preparation or tool change was pending could leave IO status at `RCS_EXEC` forever because the request output was dropped and a normal handshake could no longer finish. Task then blocked later commands in `WAITING_FOR_IO`.

The current regression checks:

### Abort during PREPARE

- start a `T10 M6`;
- wait for `tool-prepare` high;
- issue `abort()`;
- require `tool-prepare` to go low;
- require LinuxCNC status to return to `RCS_DONE`;
- verify the previously loaded tool is still reported in spindle;
- verify a later MDI move executes.

### Abort during CHANGE

- finish the prepare handshake;
- wait for `tool-change` high;
- issue `abort()`;
- require `tool-change` to go low;
- require `RCS_DONE`;
- verify LinuxCNC did **not** pretend the uncompleted change happened;
- verify later MDI still executes.

The test then performs a complete `T10 M6` after the two aborts and confirms the normal handshake still works.

## Lathe turret implications

For an automatic lathe turret, `iocontrol.0.tool-changed` should be viewed as the final machine-specific completion predicate exported to LinuxCNC, not as a simple echo of pocket-number equality.

Depending on turret mechanics, a valid predicate may require some combination of:

- target pocket/orientation reached;
- lift/retract phase completed;
- shot pin / detent engaged;
- reverse-lock phase completed;
- turret-down or clamp pressure/limit witness valid;
- no toolchanger timeout/fault;
- request belongs to the current transaction.

Which witnesses are required is machine-specific. The generic LinuxCNC handshake does not create them.

### Abort/restart rule for a turret component or ladder

When `tool-change` or `tool-prepare` drops because of abort, external logic should leave the physical mechanism in a defined recoverable state and ensure its acknowledgement is no longer capable of completing a future request accidentally. A later request should begin a fresh machine-specific transaction; it must not inherit completion authority solely because an old `tool-changed` level remained asserted.

This does **not** imply a universal automatic physical recovery sequence. A partially lifted, unclamped or rotated turret may require machine-specific reconciliation before accepting a new request.

## Evidence classification

| Claim | Classification | Evidence |
|---|---|---|
| Tool prepare/change completion is tested as request AND acknowledgement levels | SOURCE-CONFIRMED | `taskclass.cc::read_tool_inputs()` |
| Abort drops prepare/change request outputs | SOURCE-CONFIRMED | `Task::emcIoAbort()` |
| Abort explicitly returns IO status to DONE so Task does not remain stuck waiting | SOURCE + UPSTREAM-TEST CONFIRMED | `Task::emcIoAbort()` + `abort-during-change/test-ui.py` |
| Abort during change does not update the spindle tool as if the change completed | UPSTREAM-TEST CONFIRMED | `abort-during-change/test-ui.py` |
| A later complete tool change can succeed after abort | UPSTREAM-TEST CONFIRMED | same regression |
| A stale externally held acknowledgement can satisfy a later request immediately | SOURCE-DERIVED INTERFACE HAZARD | level-based `read_tool_inputs()` condition, no request generation in basic four-pin handshake |
| Pocket match alone universally proves a lathe turret is safe/locked | REJECTED | machine-specific physical witnesses are outside generic handshake |

## Lab decision

**No new lab launched in this pass.**

The abort behavior is already covered by a purpose-built upstream regression test, and the stale-ack property follows directly from the inspected level handshake. A synthetic duplicate would add little information. A future lab is justified only if a real machine/component integration leaves an unresolved request-scoping behavior that source/config inspection cannot settle.

## 3200 teaching rule

Teach lathe tool-change completion as an **ownership and physical-witness problem**:

`LinuxCNC request -> machine-specific turret transaction -> verified mechanical completion -> request-scoped acknowledgement`

Never replace that with:

`requested pocket == reported pocket -> tool-changed`

unless the inspected mechanism itself proves that pocket feedback already incorporates every required lock/clamp completion condition.