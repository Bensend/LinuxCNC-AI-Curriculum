# Active Curriculum Session State

Session start UTC: `2026-09-12T17:14:06Z`
Session end UTC: `2026-09-12T17:17:36Z`
Actual elapsed: **3.5 minutes**
Status: **CLOSED — F02 external gate preserved; 3600 tandem cascade ordering/source boundary sharpened.**

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED**. No correctly routed information-separated evaluator result was found, so F02 remains the sole known 2000-series graduation gate and was not self-scored.

## Work completed

New durable artifacts:

- `research/3600-tandem-cascade-ordering-source-reconciliation-2026-09-12.md`
- `checkpoints/3600-tandem-cascade-ordering-next-2026-09-12.md`

The Ursviken/Pullmax February and July field chronology was reconciled against LinuxCNC `pid.c` at `f325d51f52da7d5e0e227ac35e3672ee6f873b4f` and official HAL scheduling semantics.

The February field report describes a per-side position-PID output feeding a per-side velocity-PID command, with the velocity-PID output driving each servo valve. The July field report later describes a successful 90-degree bend using two per-side position PIDs plus a differential synchronization PID with command 0 and feedback `Y1-Y2`, slowing the leading side.

Pinned `pid.c` confirms that each PID instance exports an independent realtime `<name>.do-pid-calcs` function; LinuxCNC does not encode parent/child cascade execution internally. HAL realtime functions execute according to `addf` ordering. Therefore an outer-position -> inner-velocity cascade is same-cycle only if the outer PID executes before the inner PID. Reversing that order does not disconnect the cascade; it makes the inner loop consume the previous cycle's outer output. The same ordering issue applies to differential production, sync PID execution, correction insertion, final limiting/mapping and hardware write.

The research also tightens three boundaries:

- HAL float typing does not enforce engineering units; the position-output -> velocity-command unit contract is configuration-owned.
- per-loop `saturated` is controller-local and does not establish downstream valve/hydraulic authority.
- coherent `Y1-Y2` feedback freshness cannot be inferred from two encoders merely existing on the same machine.

Adversarial boundary review passed **7/7**. No synthetic lab was run because generic `addf` ordering is already source/documentation-confirmed and a toy fixture would not reveal the missing final machine HAL/component implementation. Laboratory compute is unchanged.

## Next checkpoint

1. Re-check F02 first and preserve evaluator identity/header plus the full response before changing F02 status.
2. Correctly routed F02 PASS/no corrections closes F02 and the 2000 series; do not self-certify it.
3. If F02 remains blocked, do not add another synthetic tandem/cascade fixture merely to demonstrate PID ordering.
4. Reopen tandem work only for the promised final Ursviken config or equivalent inspectable HAL/component source.
5. Required source must expose enough to reconstruct: `hardware read -> Y1/Y2 feedback -> differential -> outer PIDs -> sync PID -> correction insertion -> optional inner velocity PIDs -> downstream limiting/mapping -> hardware write`.
6. Capture exact `addf` order, velocity-feedback producer/units, correction sign/selection, limits/saturation, dither/deadband handling, process gating, freshness/disagreement, faults and recovery.
7. PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**.

Overlap: **No overlap.** Previous completed canonical lesson ended `2026-09-12T16:11:43Z`; this session began `2026-09-12T17:14:06Z`, **62m23s later**.

Short-session continuation check: a useful unblocked source-reconciliation task existed and was completed. Further progress on this branch now requires the final/equivalent inspectable machine implementation rather than another generic ordering experiment.
