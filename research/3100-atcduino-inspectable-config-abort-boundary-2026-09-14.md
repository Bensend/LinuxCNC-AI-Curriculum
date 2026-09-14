# 3100 ATCduino inspectable config — physical acknowledgement and abort boundary

Date: 2026-09-14
Status: **SOURCE PASS COMPLETE — USEFUL TIMEOUTS PRESENT; CLAMP/ABORT RECOVERY NOT PROVEN**

Public implementation inspected: `mardini1974/ATCduino` default branch (`master`). This is a LinuxCNC 8-station Geneva-wheel ATC using an Arduino serial controller plus a remapped M6 G-code sequence.

## Why this source matters

This is the first fully inspectable ATC implementation in the 3100 pass containing:

- remapped M6 orchestration;
- explicit carousel position acknowledgement;
- a piston/home-enable acknowledgement;
- bounded M66 timeouts;
- coordinated tool put/get movements;
- an `ON_ABORT_COMMAND` path.

It is therefore much stronger than a prose-only field description, even though its physical sensing is incomplete for a production VMC playbook.

## Main transaction in `rack_change.ngc`

For the old tool, when one is loaded, the routine:

1. sends the requested station through an immediate analog output;
2. waits for `INPOSITION` using `M66 ... L3 Q<turning_time_out>`;
3. returns failure if `#5399 == -1` (timeout);
4. performs the tool-put movement;
5. extends the piston;
6. waits a fixed dwell;
7. commands spindle/toolholder unlock;
8. performs a clearance move;
9. retracts the piston.

Before selecting the new tool it then waits for the ATC `ENABLE` input with a separate piston timeout. It again commands the desired station and waits for `INPOSITION` with the carousel timeout. It then extends the piston, performs the tool-get movement, dwells, commands the spindle/toolholder lock, dwells again, retracts and clears.

This provides real evidence for two useful acknowledgement classes:

- **carousel position acknowledgement** (`INPOSITION`) with timeout;
- **piston return/enable acknowledgement** (`ENABLE`) with timeout.

## Critical boundary: some transfer actions are still timer-based

The same routine does **not** expose an independent drawbar/tool-clamped or drawbar-released physical witness in the inspected G-code. Spindle/toolholder lock/unlock is followed by dwell time, not a proved clamp/release input.

Likewise piston extension before the transfer is followed by dwell rather than a separately sampled extended-position proof in this routine.

Therefore preserve:

**some physical acknowledgements + some timeouts != complete physical transfer proof.**

The design is more robust than a timer-only ATC, but its source does not establish that the tool is actually secure merely because the dwell completed.

## Abort path audit

The repository's `on_abort.ngc` says it is intended to disable pins if a toolchange is aborted, but the direct pin-clearing lines in the file are commented out. Instead it calls `o<reset_state> call`.

A repository code search for `reset_state` found the call in `on_abort.ngc` but did not find an inspectable definition on the default branch.

Therefore the preserved source does **not** establish what the abort path actually does to:

- spindle/toolholder lock command;
- piston command;
- carousel station command;
- logical tool identity;
- physical tool location.

This is a real recovery gap, not a reason to assume the machine is unsafe or broken in the field: the repository may be incomplete relative to a deployed installation. Evidence classification is `SOURCE-UNAVAILABLE / NOT PROVEN IN REPOSITORY` for complete abort reconciliation.

## Logical-tool boundary

The M6 remap framework can return success/failure to LinuxCNC, but this routine's success return occurs after the final movement/commands rather than after an explicitly sampled drawbar-clamped or tool-present proof.

That reinforces the 3100 rule:

`ATC subroutine returned success -> logical tool update`

must only be trusted as strongly as the physical witnesses included in the subroutine.

A more defensive production implementation would delay the logical `tool-changed` acknowledgement until the machine-specific secure-tool condition is proven.

## Failure matrix

| Failure | Detected by inspected routine? | Source behavior |
|---|---|---|
| Carousel never reaches requested station | Yes | M66 timeout -> return failure |
| Piston fails to return / enable does not assert | Yes | M66 timeout -> return failure |
| Toolholder fails to release after unlock command | Not proven | fixed dwell only |
| Toolholder fails to clamp after lock command | Not proven | fixed dwell only |
| Tool physically absent from expected holder | Not proven | no tool-present proof observed in inspected routine |
| Abort while lock/piston output is active | Cleanup not proven | explicit M65 cleanup lines commented; unresolved `reset_state` call |
| Restart with uncertain physical tool location | Not proven | no source-visible reconciliation transaction found in this bounded pass |

## Adversarial review

1. **Because INPOSITION has a timeout, the ATC proves the tool is clamped.** No; carousel position and spindle/tool clamp are different physical states.
2. **Piston ENABLE timeout proves piston extension as well as return.** Not from the inspected routine; extension uses dwell.
3. **A dwell after spindle-lock command is equivalent to clamp feedback.** No.
4. **`ON_ABORT_COMMAND` exists, therefore abort cleanup is proven.** No; the visible direct cleanup is commented and `reset_state` definition was not found.
5. **Returning +1 from the subroutine proves physical tool identity.** Only to the extent the sequence's physical witnesses justify that conclusion.
6. **The implementation has no useful fault handling.** False; position and piston-return waits are explicitly bounded and return failure.
7. **The source should be discarded because recovery is incomplete.** No; it is valuable evidence of mixed acknowledged and timer-based sequencing.
8. **A better VMC playbook should preserve this mixture invisibly behind one `ATC ready` signal.** No; each witness and unsupported assumption should remain visible for diagnostics/recovery.

Result: **8/8 boundary checks passed.**

## Promotion

This source satisfies the next checkpoint's requirement for one complete inspectable ATC path well enough to expose a real design boundary. It does **not** close 3100 ATC research because a stronger production VMC example with independent drawbar/tool-present proof and complete abort/restart reconciliation is still desirable.

However, the next session should not spend its entire time hunting ATCs. Follow the checkpoint: do one bounded search for the stronger VMC example, then advance to probing/tool-setting authority and production lube/coolant/spindle readiness.
