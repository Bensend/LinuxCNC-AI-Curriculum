# 4400 — Three software reset timelines, one physical safety boundary

**Learner-visible source reasoning; no simulation or machine testing.** Based on pinned LinuxCNC v2.9.10 `estop_latch.comp` and `halcompile.g`. Use alongside the guard-release physical witness card. State `SOURCE-CONFIRMED` for source logic, `INFERENCE` for conditional input sequences, and `UNKNOWN` for any actual machine's input timing.

## Timeline 1 — Ordinary observed reset

| Step | `ok_in` | `fault_in` | `reset` | `old_reset` before call | `ok_out` after call | Explanation |
|---|---|---|---|---|---|---|
| new instance, first call | 1 | 0 | 0 | 0 | 0 | no reset edge |
| next call | 1 | 0 | 1 | 0 | 1 | rising edge recognized |
| following call | 1 | 0 | 1 | 1 | 1 | no new edge; state retained |

## Timeline 2 — Held-high reset before first call

| Step | `ok_in` | `fault_in` | `reset` | `old_reset` before call | `ok_out` after call | Explanation |
|---|---|---|---|---|---|---|
| new instance, first call | 1 | 0 | 1 | 0 | 1 | zero-initialized history makes held-high input look like an edge |
| next call | 1 | 0 | 1 | 1 | 1 | remains in OK state unless a fault arrives |

**Key distinction:** a software sampling edge at startup does not establish an intentional reset action after all hazards have been verified safe.

## Timeline 3 — Fault arrives while reset remains high

| Step | `ok_in` | `fault_in` | `reset` | `old_reset` before call | `ok_out` after call | Explanation |
|---|---|---|---|---|---|---|
| initially OK | 1 | 0 | 1 | 1 | 1 | already latched |
| fault appears | 1 | 1 | 1 | 1 | 0 | fault branch trips |
| fault clears, reset held | 1 | 0 | 1 | 1 | 0 | no new rising edge, remains faulted |
| reset goes low | 1 | 0 | 0 | 1 | 0 | re-arms edge detector only |
| reset goes high | 1 | 0 | 1 | 0 | 1 | software latch re-enters OK |

The software watchdog toggles only while `ok_out` is TRUE in the no-fault branch. Its toggling is not proof of external E-stop integrity, actual contactor separation, drive torque removal, ram restraint, pressure discharge or physical gate egress.

## Transfer to guard locking and maintenance

A guarded press brake, lathe, mill or robot cell can have the software `ok_out=1` while physical hazards remain, or `ok_out=0` while the machine still has inertia, gravity load or stored hydraulic energy. Never use this state alone to approve guard unlock, inside access or maintenance. Separate (1) normal LinuxCNC request/status, (2) safety-related independent control, (3) physical final-element effect and (4) independently witnessed machine safe-state proposition. A worker escape release must be mechanically accessible under the selected design; it is not LOTO.

## Source review questions

1. Which line zeroes `old_reset`? Why does a held-high first sample matter?
2. Why does a held-high reset **not** automatically rearm after a subsequent fault?
3. Which declared fault inputs default permissive, and what happens if no external fault source is wired?
4. Which pins in the sample `plasma-thc-sim/estop.hal` are ordinary software feedback, not independent physical witnesses?
5. What would change if a selected machine requires a deliberately observed reset transition after power-up? Identify the **independent safety controller** that must implement it, rather than changing ordinary HAL and claiming a safety rating.

No live hazardous test is needed to answer these source questions. Any machine-level validation remains UNKNOWN until a qualified, isolated procedure is executed with the actual safety system and physical witnesses.
