# X02 — Multi-surface status publication and freshness trace

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Status: SOURCE / CALL-FLOW checkpoint. This artifact intentionally precedes X02-001 experiment freeze.

## Question

When a diagnostic tool compares realtime motion/HAL evidence with Task/NML/Python status, what ordering and freshness evidence actually exists? Wall-clock proximity alone is not sufficient evidence of simultaneity or causal order.

## Surface ownership

### 1. Realtime motion status

`src/emc/motion/control.c` runs the controller function in realtime. Near the end of a completed controller cycle it calls `update_status()`, increments `emcmotStatus->heartbeat`, then sets `emcmotStatus->tail = emcmotStatus->head` to mark the status snapshot complete.

Evidence: SOURCE-CONFIRMED.

### 2. Task-side motion snapshot

`src/emc/motion/usrmotintf.cc::usrmotReadEmcmotStatus()` is a userspace shared-memory reader. It copies the complete `emcmot_status_t`, accepts the copy only when copied `head == tail`, and retries a split read up to three times. A failed coherent read returns `EMCMOT_COMM_SPLIT_READ_TIMEOUT`; the source explicitly treats this as harmless/transient rather than silently accepting the torn snapshot.

`src/emc/task/taskintf.cc::emcMotionUpdate()` uses the motion interface and publishes `emcmotStatus.heartbeat` into `EMC_MOTION_STAT::heartbeat`. It also publishes Task-local command type/echo fields. Therefore motion heartbeat is a useful witness that a Task-visible motion snapshot came from a particular completed motion-cycle generation; it is not a wall-clock timestamp.

Evidence: SOURCE-CONFIRMED.

### 3. Task status publication

`src/emc/task/emctaskmain.cc` owns the Task main loop and the global `EMC_STAT`. `task_beat` is incremented once per Task loop. Task update code copies `task_beat` into `EMC_TASK_STAT::taskbeat`. After subsystem/status update functions have updated the shared `EMC_STAT`, the Task loop executes `emcStatusBuffer->write(emcStatus)` and then performs its configured cycle wait.

This gives two distinct generation witnesses in the published aggregate status:

- `motion.heartbeat`: completed realtime motion-controller generation observed by Task;
- `task.taskbeat`: Task-loop generation that published the aggregate status.

They have different owners and periods and must not be treated as the same clock.

Evidence: SOURCE-CONFIRMED.

### 4. Python `linuxcnc.stat().poll()`

`src/emc/usr_intf/axis/extensions/emcmodule.cc` defines `pyStatChannel` with an `RCS_STAT_CHANNEL *c` and local `EMC_STAT status`. `poll(pyStatChannel*, ...)` validates the channel, calls `c->peek()`, obtains the channel address when it contains `EMC_STAT_TYPE`, and `memcpy`s the published `EMC_STAT` into the Python object's local status. The exposed `taskbeat` property reads that local copy.

Therefore `stat.poll()` is a userspace observation of the latest status-channel publication available when it polls. It does not sample the realtime controller directly, and the local wall-clock time at which Python called `poll()` is not the production time of the motion data inside that status object.

Evidence: SOURCE-CONFIRMED.

## End-to-end generation path

`realtime controller cycle`
→ `update_status()`
→ increment motion `heartbeat`
→ commit coherent motion status with `tail = head`
→ userspace Task `usrmotReadEmcmotStatus()` coherent-copy check
→ `emcMotionUpdate()` maps motion status, including heartbeat, into `EMC_STAT.motion`
→ Task update maps current `task_beat` into `EMC_STAT.task.taskbeat`
→ `emcStatusBuffer->write(emcStatus)` publishes aggregate NML status
→ Python `stat.poll()` peeks status channel and copies published `EMC_STAT`
→ Python reads `motion.heartbeat`, `taskbeat`, positions/state/etc. from that local copy.

This is a publication chain, not an atomic cross-surface sample.

## Freshness and ordering witnesses for X02

1. **Motion heartbeat** — generation witness for completed realtime motion status. Repeated heartbeat in successive Task/Python observations means no newer completed motion generation was represented; it does not alone prove why.
2. **Task heartbeat (`taskbeat`)** — generation witness for Task main-loop/status publication. Repeated taskbeat in repeated Python observations indicates the local/status-channel observation has not advanced to a newer Task publication.
3. **Motion command echo/serial** — command acknowledgement evidence where a diagnostic question is command-specific. Do not substitute it for general motion-status freshness.
4. **Recorder payload-cycle witness and producer-overrun state from X01** — required when correlating an independently sampled HAL/realtime trace. A recorder interval with overrun, payload discontinuity, truncation, unknown topology/order, or provenance loss is invalid/uncertain for correlation.
5. **Wall clock** — useful only as observer-side timing metadata. It cannot establish same-cycle simultaneity between HAL/realtime and NML/Python surfaces.

## Important adversarial cases

- Python can poll rapidly and receive the same Task publication more than once. Similar wall-clock timestamps do not make those observations new machine samples.
- Task can publish a new `taskbeat` while the included motion heartbeat has not advanced. That is a legitimate cross-rate observation and must not be mislabeled a frozen realtime controller without additional evidence.
- Motion heartbeat can advance by multiple generations between Task/Python observations. The consumer then knows it skipped intermediate published motion generations; interpolation cannot reconstruct their exact values.
- A coherent `usrmotReadEmcmotStatus()` copy (`head == tail`) proves structural snapshot coherence at that boundary, not physical sensor simultaneity and not freshness relative to a separately recorded HAL trace.
- A command echo proves receipt/processing semantics for that command path, not that every field in a later diagnostic surface was produced at command time.

## X02-001 design consequence

Before freezing X02-001, the experiment should record at least `(observer monotonic time, taskbeat, motion heartbeat, selected status value)` from Python while a deterministic realtime/HAL witness is recorded through the X01-validated recorder. The experiment must deliberately create different observation rates so it can demonstrate repeated Task publications, skipped motion generations, and valid/invalid correlation intervals. Gates must score generation/order claims from heartbeat/witness relationships rather than from nearest wall-clock timestamps.

An experiment that merely logs HAL and Python timestamps and aligns nearest neighbors is insufficient and must not be accepted as X02 evidence.
