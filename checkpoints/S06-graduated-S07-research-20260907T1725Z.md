# Curriculum checkpoint — S06 graduated / S07 research active

- S06 status: **GRADUATED at 1000 level**.
- Authoritative S06-016 run: `34146966388`, fixture commit `c116c997e39506bb82bbae6cce777bde19015fde`, lab exit `0`, `linuxcnc-ai-fi-v1` overall `PASS`.
- Accepted capture: 170/170 rows, zero sampler overruns, verified function order, separate injection/response/recovery evidence.
- S07 status: **RESEARCH active**.
- Pinned LinuxCNC revision remains `8bf4605ae81042248add031e94c77300406e0413`.

## Exact next-work checkpoint

Resume `guides/S07-restart-recovery-state-integrity-research.md` and do these in order:

1. Trace pinned `scripts/linuxcnc.in::Cleanup()` plus the startup sequence far enough to identify the exact old-runtime teardown and new-runtime creation boundaries that an experiment can independently observe.
2. Trace pinned `src/hal/hal_lib.c` through `hal_init()`, `hal_exit()`, HAL shared-memory reference lifetime, dangling-component handling, and destruction/reuse conditions.
3. Trace pinned motion/homing initialization: locate the exact symbols that initialize, clear, set, and publish per-joint homed state and machine enable/estop state on a fresh runtime.
4. Build `source-analysis/S07-state-ownership-reset-matrix.md` with columns: state, owning subsystem/process, volatile/persistent storage, startup initial value, reset trigger, HAL/status observable, recovery requirement, and physical-truth implication.
5. Perform the targeted community pass for restart-after-fault, stale HAL namespace/failed teardown, re-home expectations, and absolute-encoder restart behavior. Community claims remain leads until reconciled.
6. Only after the state matrix identifies one unambiguous representative volatile state and one meaningful recovery boundary, freeze S07-017 using the S06 evidence schema. Require explicit old-runtime disappearance, new-runtime identity, healthy restart control, state reset/reconstruction oracle, HARNESS_INVALID teardown-race rule, and the non-claim that process restart is not physical-machine recovery.

Do not reuse S04's restart-race workaround as assumed LinuxCNC semantics; source-trace it and then design the lifecycle experiment around independently observable identity/teardown evidence.
