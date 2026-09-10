# X02 adversarial exam — synchronized multi-surface diagnostics

Status: **FROZEN BEFORE ANSWERING**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Authoritative experiment contract: `experiments/X02-001-multi-surface-generation-correlation-plan.md`.

## Questions

1. A Python observer polls `linuxcnc.stat()` twice 200 microseconds apart and gets the same `taskbeat`, same `heartbeat`, and same `motion_type`, but different local monotonic timestamps. What can and cannot be inferred about LinuxCNC state freshness?
2. Explain the source-level distinction between `stat.taskbeat` and `stat.heartbeat`. Which producer loop owns each, and why is neither Python observer time?
3. A trace shows `motion_type=0` for two adjacent Python observations while `taskbeat` advances from 500 to 501 and motion heartbeat advances from 910 to 911. Does equal `motion_type` prove the two observations represent the same machine generation? Explain.
4. A 50 ms Python polling phase shows successive motion-heartbeat deltas of roughly 48–52. Does this prove the realtime servo thread skipped cycles? What stronger interpretation is supported?
5. HAL `motion.motion-type` produces ordered states `[0,1,0,2,0]`; Python sees `[0,1,0,2,0]`, with no shared generation ID or common producer timestamp. What relationship is justified, and what same-cycle claim is not justified?
6. A recorder trace has visually plausible state transitions but `sampler.N.overruns` increased and the deterministic payload-cycle witness contains a gap. May it be used to establish exact cross-surface ordering? Why or why not?
7. Describe the pinned source publication path from realtime `emcmotStatus->motionType` to Python `linuxcnc.stat().motion_type`, naming the important process/shared-memory/NML boundaries.
8. Misleading premise: “Because Task publishes a fresh `EMC_STAT` every Task cycle, each Python `stat.poll()` must correspond one-to-one with a Task generation.” Diagnose the premise and identify the witness that falsifies it experimentally.
9. You are extending X02 to include a second HAL signal. Specify the minimum evidence/provenance changes required so that adding the signal does not silently weaken the recorder-integrity or correlation claims.
10. A field engineer reports that a GUI value froze for 150 ms while the machine continued moving. Give an evidence-preserving diagnostic sequence that distinguishes observer/UI staleness, Task/NML publication staleness, recorder loss, realtime execution failure, and physical motion behavior without conflating these layers.

## Scoring

2 points each, 20 total. Critical traps: Q1, Q4, Q6, Q8, Q10. A critical-trap miss blocks technical graduation until corrected.
