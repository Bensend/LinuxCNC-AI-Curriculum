# 2026-11-01 02:41Z — M51 spindle-override mask coupling and selector-loss checkpoint

**Active:** LinuxCNC-first 4000 implementation, NON-GRADUATED. Predecessor [HOMING-90/91 and TP-92](20261101T013600Z-4000-linuxcnc-homing-bounded-next.md). Mandatory START_HERE/governance, evaluation and compute ledgers read. No qualified runner identified; no Actions dispatched.

## New verified source-level findings

1. [OVERRIDE-93](../research/4400_LINUXCNC_OVERRIDE_93_FEED_INHIBIT_SS_BIT_COUPLING_SOURCE_AUDIT_2026-11-01.md): both stable v2.9.10 and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` compute `if (enables & feed_inhibit)` with a BOOL. Since `SS_ENABLED=0x01`, `M51 P0` clears the only bit the condition tests. `motion.feed-inhibit` can therefore fail to zero net feed scale when spindle speed override is disabled. Conditional source-confirmed arithmetic, not observed motion.
2. [OVERRIDE-94](../research/4400_LINUXCNC_OVERRIDE_94_SPINDLE_INHIBIT_SS_BIT_SPEED_ON_SOURCE_AUDIT_2026-11-01.md): same mask coupling exists for `spindle.N.inhibit`; `spindle.N.speed-out` scales with net scale but `spindle.N.on` remains independently based on spindle state.
3. [OVERRIDE-95](../research/4400_LINUXCNC_OVERRIDE_95_M51_SELECTED_SPINDLE_DROPPED_AT_TASK_SOURCE_AUDIT_2026-11-01.md): `M51 P0 $1` is selected in interpreter and NML but Task passes **only mode** to global motion SS bit. Status copies global SS bit to all spindles. **Corrected predecessor OVERRIDE-SCOPE-01**, which had incorrectly described interpreter selection as end-to-end per-spindle override control.
4. [10-case disconnected acceptance](../guides/4000-linuxcnc-m51-inhibit-coupling-disconnected-acceptance-2026-11-01.md): O93-01..O95-10 ALL NOT RUN. Tests separate interpreter/canonical, Task/NML, motion queued masks, HAL speed/ON, and actual physical feedback (not tested).

## Same-session distinct trajectory-planner continuation

[OVERRIDE-96](../research/4400_LINUXCNC_OVERRIDE_96_M52_ADAPTIVE_FEED_CLAMP_REVERSE_VERSION_SOURCE_AUDIT_2026-11-01.md) traces stable v2.9.10 adaptive-feed clamp to ±1.0 versus development clamp to ±[DISPLAY]MAX_FEED_OVERRIDE, and both versions' `tpSetRunDir` rejection while moving, causing an intermediate zero-feed request before reversing. Upstream QtPlasmaC HAL consumes adaptive feed. **SOURCE/DOC-CONFIRMED only, NO EXECUTION.** After high-value O93/O94/O95 reproductions, a bounded software-only M52 +1.2/−0.5 version comparison is a distinct option if the qualified runner exists. Otherwise rotate; do not create a compulsory plasma product.

## Precise next action

- Verify qualified isolated runner labels `[self-hosted, openpressbrake]` before any compute. Run O93-01/02 and O94-05/06 first (one-spindle software-only), then O95-08 (two-spindle selector loss), preserving actual job timestamps, source commit and raw HAL/Task traces. **Never GitHub-hosted Actions** and no physical actuator.
- If runner unavailable, rotate to another distinct LinuxCNC implementation question; do not repeat this static mask audit or manufacture unexecuted tests. Before upstream fix, check intentional spindle-sync exception and exact queued-mask transition, then propose smallest source correction only if reproduced.
- Correct any other curriculum statements that confuse interpreter `M51 $n` selection with Task/motion per-spindle behavior. Do not reopen graduated levels. Preserve personnel-safety independent authority and sealed evaluation.
- `LAB_COMPUTE_LOG.md` and `evaluation/FEEDBACK_SCORE_LOG.md` unchanged; no new job runtime, evaluator score, physical or test-confirmed verdict. Keep hourly curriculum enabled.
