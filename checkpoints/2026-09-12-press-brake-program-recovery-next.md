# Checkpoint — press-brake program execution/recovery

- 2000 critical path remains externally blocked only by genuinely information-separated F02 fresh-AI evaluation. Do not self-score it.
- 3600 dependency-safe work this session source-confirmed that `emcTaskAbort()` clears pending/interpreter execution state, queues synchronization, closes the task plan and resets unflushed segments. Abort is not pause and does not imply automatic aborted-line continuation.
- Official GUI/G-code docs independently distinguish Pause/Resume from Stop/Abort and warn about Run From Selected Line. Do not use generic run-from-line as automatic press-brake recovery.
- Durable contracts:
  - `research/press-brake-bend-program-execution-recovery-2026-09-12.md`
  - `research/press-brake-operator-program-state-contract-2026-09-12.md`
- Next unblocked 3600 work if F02 remains externally blocked: bounded search for an inspectable public press-brake Run UI/state implementation. Trace program-row persistence, pause/abort behavior, row advance, restart/recovery, and command surface. If unavailable after one bounded pass, record SOURCE UNAVAILABLE and move to machine-specific calibration/correction ownership; do not add another synthetic ownership fixture merely for depth.
