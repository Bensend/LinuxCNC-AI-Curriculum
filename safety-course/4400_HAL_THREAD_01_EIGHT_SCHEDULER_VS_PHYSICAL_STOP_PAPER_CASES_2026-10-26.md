# HAL-THREAD-01 — Eight scheduler-stop versus physical-stop cases

**PAPER ONLY / UNSCORED / NON-GRADUATED.** Based on [pinned two-revision source audit](../research/4400_LINUXCNC_HAL_STOP_THREADS_NO_FINAL_ELEMENT_SAFE_STATE_TWO_REVISION_SOURCE_AUDIT_2026-10-26.md). No live fault injection, no hidden answer or graduation claim.

1. A technician runs `halcmd stop` while a normal output last reads TRUE. Does the inspected `hal_stop_threads` function set that output FALSE? Trace the source path.
2. The same command is issued during an in-flight realtime callback. Compare the stable 2.9.10 and pinned development ULAPI paths without inventing latency.
3. An HMI displays `realtime stopped` and `ram position stable`. Does that prove gravity load holding? Name the required independent physical witnesses.
4. A drive has a vendor watchdog feature, but the actual enable/configuration is unknown. Can the controller claim a safe stop after HAL callbacks cease?
5. A lathe spindle continues coasting after commanded motion stops. What distinguishes a zero speed command, a measured standstill and an independent protective stop?
6. A plasma table's ordinary torch output ceases refreshing. Which evidence establishes actual high-voltage/arc isolation?
7. HAL `start` is issued after maintenance. What separate safety reset and fresh-motion authorization must remain required?
8. A technician complains that the machine is difficult to recover after a software fault and wants a permanent jumper. Propose a simpler diagnosis/recovery path that does not compromise guards or independent safety.

For each case classify **SOURCE-CONFIRMED, DOC-CONFIRMED, INFERENCE or UNKNOWN**, state a falsifier, and identify the minimum independent evidence. No scoring until a separate evaluator selects a novel challenge and preserves precommitment. **G0/G1 HOLD.**
