# X02 — NML freshness / heartbeat documentation and community cross-check

Session start marker: `2026-09-10T06:12:23Z` UTC.

Pinned source baseline remains LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`; source conclusions remain in `call-flows/X02-multi-surface-status-publication.md`.

## Official documentation

The current LinuxCNC Python-interface documentation describes the Python module as an interface to LinuxCNC's NML command, status and error channels. Its usage pattern explicitly says to poll the status channel periodically or as needed. It defines `taskbeat` as the Task main-loop heartbeat counter, incremented every Task cycle, with rate determined by `[TASK]CYCLE_TIME`.

The current INI documentation says `[TASK]CYCLE_TIME` is the period at which TASK runs and describes TASK as communicating with UIs over NML and with realtime motion over non-HAL shared memory.

Evidence classification: DOC-CONFIRMED.

Consequences for X02:

1. `taskbeat` is a Task-generation witness, not a realtime-motion-cycle counter.
2. A Python `stat.poll()` observation is explicitly a status-channel poll. Its local observation time must not be promoted into a production timestamp for the embedded motion fields.
3. `[TASK]CYCLE_TIME` gives configured Task cadence, but does not make a Python poll atomic with a realtime motion cycle.

## Community lead and reconciliation

A 2021 LinuxCNC forum thread, **“changes in NML-interface?”**, reports a user observing `peek()` returning `0` on some polls and a valid status on others while polling around 40 ms. The report is useful as a field warning against assuming every userspace poll yields a new status publication, but it is COMMUNITY-REPORTED only. It does not establish a general timing guarantee, nor does it supersede the pinned source trace.

The thread's quoted application code mirrors the source-level pattern already traced for Python: `peek()`, check for `EMC_STAT_TYPE`, then copy the status structure. This is consistent with the course's stronger source-grounded conclusion that consumers observe a published NML status generation rather than directly sampling realtime motion.

Evidence classification: COMMUNITY-REPORTED, reconciled with SOURCE-CONFIRMED architecture; timing-frequency claim remains non-authoritative.

## X02-001 freeze constraints established by this cross-check

The experiment must not use `poll()` return timing or nearest wall-clock timestamps as its freshness oracle. It must record Python-side monotonic observer time only as metadata and use generation witnesses for claims.

Minimum Python tuple remains:

`(observer_monotonic_ns, taskbeat, motion_heartbeat, selected_status_value)`

The independently recorded realtime/HAL surface must retain an X01-valid deterministic payload-cycle witness and recorder-health evidence. Different consumer rates must be deliberately exercised so the run can demonstrate at least:

- repeated Python observations of one Task generation;
- Task-generation advance without requiring one-for-one motion-generation advance;
- motion-generation skips between slower userspace observations;
- explicit rejection/uncertainty for any realtime/HAL interval whose recorder integrity is not established.

A valid gate may infer ordering/generation relationships from heartbeat deltas and deterministic witnesses. It may not infer same-cycle simultaneity merely because timestamps are close.

## Remaining work before X02-001 freeze

Define the selected status value and deterministic fixture so that a cross-surface relationship is objectively testable without assuming physical simultaneity. Prefer a software-only value whose production path can be traced at the pinned revision. Then predeclare phases, rates, expected heartbeat relationships, invalid-interval handling, and Gates A–J before implementation.
