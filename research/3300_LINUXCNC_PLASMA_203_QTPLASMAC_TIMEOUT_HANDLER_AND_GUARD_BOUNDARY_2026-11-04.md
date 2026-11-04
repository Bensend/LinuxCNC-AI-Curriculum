# PLASMA-203 — QtPlasmaC timeout callback versus interpreter abort (3300, NON-GRADUATED)

Date: 2026-11-04 UTC. **SOURCE-CONFIRMED narrowly; NOT RUN.** This follows the PLASMA-202 correction: M66 L3 waits for HIGH, not rising edge. Do not revive the PLASMA-201 misstatement.

## Immutable source and inspected symbols
- LinuxCNC development commit `cdf957bd00bbcc4c569f01e7eed5b154422b816c`, [QtPlasmaC handler](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/share/qtvcp/screens/qtplasmac/qtplasmac_handler.py), blob `072e74a18c9bb1e3345444cbc1f744fb840eca64`: `material_changed`, `material_change_pin_changed`, `material_change_number_pin_changed`, `material_change_timeout_pin_changed`. Read directly, not inferred from screenshots.
- Same development revision: [M190](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/nc_files/plasmac/m_files/M190) and [conversational line.py](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/lib/python/plasmac/line.py). The upstream conversational producer emits M190, M66 P3 L3 Q1, feed and torch start without a local #5399 check (PLASMA-202).
- LinuxCNC stable 2.9.10 peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`: [O-code conditionals](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/o-code.adoc), blob `fe6cc3bf59b9752dd068aa572a687958b169b71a`, and interpreter/Task source in PLASMA-202 for #5399 and timeout semantics. Cross-revision parity is **not** proven.

## Actual handler behavior
1. `material_change_pin_changed(0)` sets `motion.digital-in-03=0`; state 3 sets it HIGH and clears the material-change pin. Thus the ACK is a HAL level; M66 L3 may accept a preexisting HIGH, not necessarily a new material transaction.
2. `material_change_number_pin_changed` returns without selection when `material_exists` is false; it also returns early when the requested material already equals the displayed material. If state is 1, it sets `autoChange=True` before testing existence, then clears it on nonexistent material.
3. `material_changed`, when `autoChange`, explicitly drives digital-in-03 LOW, invokes `change_material(matNum)` and sets material-change state 2 (subject to pre-file/pre-single-cut branches), then drives digital-in-03 HIGH. These are **userspace HAL writes**, not a proof of independently applied torch parameters.
4. `material_change_timeout_pin_changed` emits `STATUS.emit('error', linuxcnc.OPERATOR_ERROR,...)`, resets the requested number to the currently selected one, clears the timeout pin and drives digital-in-03 LOW. Its own source comment asks whether the program should stop or pause. **There is no `ACTION.ABORT()` or `ACTION.PAUSE()` in this callback.** The handler has `ACTION.ABORT()` elsewhere in its operator abort-button path; that is a separate mechanism.
5. The inspected handler therefore does **not itself issue an explicit Task program abort on material-change timeout**. This does *not* prove all possible error listeners, plasma realtime interlocks, or machine configurations allow cutting. `OPERATOR_ERROR` is an error-display event, not established as a guaranteed interpreter abort by this source trace.

## Failure cases and transaction limitation
- Unknown material: selector callback returns; M190 can time out and report via handler. A subsequent M66 can time out with `#5399=-1`; no local guard was found in the inspected conversational producer. The exact interleaving of userspace M190, Qt event loop, and M66 is untested.
- Preexisting HIGH from an earlier acknowledgment: because L3 is level-sensitive, M66 success alone is not transaction-bound. An explicit post-wait `#5399` check catches a LOW/timeout, **but not a stale HIGH**. A robust postprocessor contract additionally needs a fresh-request/acknowledgment invariant or independently verified selected-material identity; neither is established by the inspected G-code.
- M190's own timeout is 0.5 s; M66 Q1 is a separate 1 s wait. Do not merge these deadlines.

## Review-only guard candidate — NOT verified executable
The stable O-code reference confirms separate `o<number> if [condition]` and `endif` lines. A **conceptual** post-wait check is:

```ngc
M190 P1
M66 P3 L3 Q1
o203 if [#5399 LT 0]
  (MSG,Material acknowledgment timed out)
  M2
 o203 endif
```

This is **not a validated safe postprocessor patch**. `M2` program termination, O-code block parsing, message handling, and queued interpreter behavior must be tested in a disconnected LinuxCNC simulation before adoption; the `M2` placement also does not prove a transactional material identity. The leading space on the closing O-word should be normalized when prototyping. Never treat G-code as independent personnel safety.

## Disconnected verification matrix (predictions, not results)
A. Valid changed material, LOW→HIGH: record selected material, material-change state, `motion.digital-in-03`, M66 result, feed and program line.
B. Missing material: verify callback return, M190 timeout, error event, `#5399=-1`, whether next line executes; do not assume abort.
C. Input already HIGH before new request: test whether L3 returns 1 while requested material is not actually selected; discriminate stale ACK from successful change.
D. UI callback delayed >0.5 s: capture M190 timeout versus later Qt handler action and M66 state.
E. Handler `OPERATOR_ERROR` event: inspect Task mode/program state separately from UI message; do not equate error display with Task abort.
F. With a review-only guard in a disconnected configuration, verify that timeout prevents subsequent M3, then verify that stale HIGH is *not* solved by this guard alone.

Before any runtime: check historical M66-140 test evidence and prove isolation on **[self-hosted, openpressbrake]**; never use GitHub-hosted runners. No runtime, build, physical torch, or workflow executed in this lesson.

## Evidence status and next question
**SOURCE-CONFIRMED:** precise callback logic and absence of explicit abort in this callback; stable O-code conditional syntax; PLASMA-202 L3/#5399 source chain. **INFERRED/UNVERIFIED:** downstream progression after an actual timeout, event-listener effects, and guard behavior. **TEST-CONFIRMED:** none newly. Next: trace the realtime plasmac component's M3/torch enable interlocks and source-level behavior when material change fails; alternatively find a pinned independent postprocessor with a real material-ACK guard. Keep 3300 plasma separate from 3600 OpenPressBrake bend/backgauge control, preserve safety and blind gates.
