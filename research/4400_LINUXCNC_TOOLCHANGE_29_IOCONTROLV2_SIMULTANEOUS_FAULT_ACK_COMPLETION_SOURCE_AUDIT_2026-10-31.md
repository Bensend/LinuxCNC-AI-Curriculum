# 4000-LC-TOOLCHANGE-29 — v2.9.10 iocontrolv2: simultaneous toolchanger fault and completion acknowledgment

**Audit date:** 2026-10-31. **Status:** SOURCE-CONFIRMED conditional same-poll control flow; TEST-CONFIRMED none, installed-machine effect UNKNOWN. NON-GRADUATED. This is a **new conflict-ordering question** beyond the existing [ATC-02](4400_LINUXCNC_PINNED_M6_IOCONTROL_TOOL_CHANGED_ACK_VS_PHYSICAL_RETENTION_SOURCE_TRACE_2026-10-25.md) and [TOOL-RET-02](4400_TOOL_RET_02_PINNED_LINUXCNC_M6_IOCONTROL_TOOL_CHANGED_VS_PHYSICAL_RETENTION_SOURCE_TRACE_2026-10-26.md), which already established that a stale HIGH `tool-changed` can satisfy an ordinary handshake and is not physical-retention proof.

## New question

What does the **v2 toolchanger fault path** do when `toolchanger_faulted` and `tool-changed` are both TRUE in the *same* I/O poll while `tool-change` is TRUE? Does fault preempt tool-state commitment, or can the same poll both request an abort and publish successful completion?

## Pinned provenance

- LinuxCNC stable [v2.9.10 `src/emc/iotask/ioControl_v2.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/iotask/ioControl_v2.cc), blob `9f09844a7b1af4c5e0674470037e75910820e4a0`, `read_inputs` ~605–737, especially fault/ack branches ~688–735; main loop ~910–957, `EMC_TOOL_LOAD_TYPE` ~1080–1108; `TC_FAULT` macro ~135–138.
- Stable [v2.9.10 `src/emc/iotask/ioControl.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/iotask/ioControl.cc), blob `09cbd6ff4e5e119df04e61ffb8916b283a2f2014`, `read_tool_inputs` ~628–662 and tool-load dispatch ~937–965. The simpler v1 implementation lacks the inspected v2 fault/abort handshake.
- [Stable v2.9.10 Task `src/emc/task/emctaskmain.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc), blob `7292a172023a5b42b023447c2458cb766c93fc9b`, `WAITING_FOR_IO` ~2669–2677 checks `io.status` (ERROR before DONE), and main loop ~3440–3475 only applies special fault policy when `io.status == RCS_ERROR`; `reason > 0` is a soft fault that Task can explicitly convert to DONE, while `reason <= 0` with ERROR takes the abort path. These are distinct from a same-poll DONE plus fault flag.
- [Official iocontrol documentation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/iov2.adoc) and [io man page](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/man/man1/io.1.adoc) describe ordinary request/ack pins. Documentation is not a substitute for same-cycle source ordering.
- Development revision `24e84c4506b41634240f7087f0295e361a954886` did **not** expose these same `src/emc/iotask/ioControl*.cc` paths through the pinned file fetch; the architecture has evolved toward Task-managed I/O (as previously audited). **No claim of identical development behavior.**

## Exact v2 source order

In `read_inputs()`, when `tool_change` is TRUE:

1. If v2 protocol is active (`proto > V1`) and `toolchanger_faulted` is TRUE, it records the fault reason, asserts `emc_abort`, sets `TI_TC_ABORT`, clears `tool_change`, and sets `ST_WAIT_FOR_ABORT_ACK`.
2. The next `if (*iocontrol_data->tool_changed)` is **not** an `else if` and does **not** re-test the now-cleared `tool_change`. Because execution already entered the enclosing `if (tool_change)`, a simultaneous HIGH completion input can still enter the commit branch in the same call.
3. That commit branch calls `load_tool(pocketPrepped)`, updates `toolInSpindle` and `tool_number`, resets prepared-tool fields, sets `ST_IDLE`, and ORs `TI_CHANGE_COMPLETE` into the return mask. Thus the same poll can return **both `TI_TC_ABORT` and `TI_CHANGE_COMPLETE`** while the tool table/status has already been changed. The later `ST_IDLE` also overwrites the earlier `ST_WAIT_FOR_ABORT_ACK` state pin.
4. The main loop treats `TI_CHANGE_COMPLETE` as a reason to call `update_status(RCS_DONE, serial)` (~953–956). The earlier `TI_START_CHANGE | TI_CHANGING` error/EXEC branch does not run for this poll if `tool_changed` was TRUE, because `TI_CHANGING` is only set in the `else` branch. Fault state/reason are still copied into `emcioStatus.fault/reason`; a DONE status with a fault flag is not a clean, contradiction-free physical witness.

This is a **source-confirmed conditional ordering issue**, not proof that an actual changer drives both inputs HIGH together or that a particular controller resumes motion after it. In the inspected stable Task path, `WAITING_FOR_IO` distinguishes `RCS_ERROR` versus `RCS_DONE` rather than vetoing DONE merely because `io.fault` is true; the main loop's fault handling is also gated on `io.status == RCS_ERROR`. Thus a same-poll DONE plus fault flag is **not automatically converted to an error by those inspected Task checks**. Other task state, asynchronous commands and external drive/PLC logic remain unverified. No personnel-safety inference.

## Minimal truth table (source-derived, NOT EXECUTED)

Assume `tool-change=1` at entry, a valid prepared pocket, v2 protocol active, and no other branch short-circuits the poll.

| `toolchanger_faulted` | `tool-changed` | Source outcome |
|---:|---:|---|
| 0 | 0 | `TI_CHANGING`; request remains pending. |
| 0 | 1 | `TI_CHANGE_COMPLETE`; software commits prepared tool and clears request. |
| 1 | 0 | `TI_TC_ABORT`; abort requested; request cleared; wait for abort acknowledgment. |
| **1** | **1** | **Both `TI_TC_ABORT` and `TI_CHANGE_COMPLETE`**; software tool commit and `ST_IDLE` overwrite the abort-wait state. |

The stale-high completion issue was already recorded in ATC-02; the **new** information is the simultaneous-fault/ack ordering and its status-mask contradiction. A v1 configuration cannot be assumed to use v2 fault semantics; a modern development configuration cannot be assumed to retain this file.

## Reproducible next experiment (PENDING)

On a disconnected software-only v2.9.10 simulation explicitly configured to use iocontrolv2 and a synthetic prepared tool, freeze the tool table, status, and HAL pin values. In four separate resets, present the four input combinations above **before the same I/O poll** while a real `EMC_TOOL_LOAD` is pending. Capture the input mask, `iocontrol.0.state`, `emc-abort`, `tool-change`, `tool-number`, NML `RCS_DONE/RCS_ERROR`, fault/reason, and tool-table before/after. The main discriminator is **fault=1 and changed=1**: does the tool number update and DONE get published despite an abort request? Do not call this a runtime bug without reproducing it and checking downstream Task behavior. Task's status-only WAITING_FOR_IO and RCS_ERROR-gated fault path have now been inspected at the exact stable tag. If no isolated runner is available, rotate to trajectory planning rather than repeat the same audit.

## Engineering boundary

A robust external toolchanger must not present a completion acknowledgment without a fresh, transaction-specific, physically verified completion state. LinuxCNC's ordinary HAL/NML status is not an independent personnel-safety function. Preserve separate drive inhibition, mechanical retention and guarded-access authority; this research neither selects nor authorizes an installed machine architecture.

**Claims ledger:** same-poll two-branch execution and tool-table side effects **SOURCE-CONFIRMED v2.9.10**; v1 simpler handshake **SOURCE-CONFIRMED**; installed protocol selection, other Task/asynchronous effects, actual simultaneous signal occurrence and physical motion **UNKNOWN**; **TEST-CONFIRMED none**. No workflow, compute, machine operation, evaluator, graduation or upstream submission.
