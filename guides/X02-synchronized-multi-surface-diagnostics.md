# X02 — Synchronized multi-surface diagnostics

Status: **RESEARCH / SOURCE-INVENTORY ACTIVE**  
Course level: **2000**  
Prerequisite: X01 technically accepted recorder-integrity contract  
Pinned LinuxCNC baseline: `8bf4605ae81042248add031e94c77300406e0413`

## Learning objective

A fresh AI engineer must be able to correlate LinuxCNC diagnostic observations that originate on different execution surfaces without inventing simultaneity or causality. X02 must identify who owns each observed value, when/how it is refreshed, how a userspace observer obtains it, what sequence/freshness evidence exists, and how X01 recorder-integrity failures invalidate a correlation interval.

The target is not merely “collect more logs.” The target is a defensible evidence model for questions such as:

- Did a realtime HAL/motion event precede a Task/NML state transition?
- Are two displayed values observations of one underlying update or independently polled snapshots?
- Does an apparent delay reflect the machine/controller, a status-publication cycle, a GUI poll interval, or recorder loss?
- Can an event be correlated across realtime HAL evidence and non-realtime NML status without assigning both the same wall-clock timestamp after the fact?

## Inherited X01 validity contract

Before X02 interprets timing across surfaces, the recorder interval must establish:

1. producer recorder health (`overruns/full/depth` where applicable);
2. sampled deterministic witness continuity where coverage claims depend on cycle continuity;
3. userspace drain lifecycle integrity;
4. exact topology/provenance and relevant thread/function order; and
5. bounded uncertainty when observations come from different processes/update loops.

An interval failing those checks is **UNUSABLE/UNCERTAIN FOR CORRELATION**, not silently repaired by interpolation or wall-clock matching.

## Initial surface inventory

### Surface A — realtime HAL / motion-visible pins

Official LinuxCNC documentation describes `motion`/`motmod` as a realtime component that interacts with HAL. Motion's HAL pins are updated in realtime-controller execution. X01 already provides a same-invocation realtime sampler mechanism for selected HAL-visible values.

Initial questions:

- Which motion state transitions needed by X02 are directly visible as HAL pins?
- In which realtime function are they refreshed relative to the X02 sampler function?
- Can a deterministic cycle/event witness be injected/read in the same thread without altering the phenomenon being diagnosed?

### Surface B — motion status consumed by Task

Pinned `src/emc/task/taskintf.cc` states that local `emcmotStatus` is populated in `emcMotionUpdate()` and then referenced by joint/trajectory update functions to avoid repeated `usrmotReadEmcmotStatus` calls. This gives X02 an explicit non-realtime/status-publication boundary to trace rather than assuming an NML field is identical in time to a HAL pin carrying a related quantity.

Required source trace next:

`realtime motion state -> usrmot status shared-memory interface -> emcMotionUpdate() -> EMC_MOTION_STAT fields -> EMC_STAT publication`.

### Surface C — Task/NML status

Pinned `src/emc/task/emctaskmain.cc` documents a cyclic Task process. It owns an `RCS_STAT_CHANNEL *emcStatusBuffer` and global `EMC_STAT *emcStatus`; its main cycle plans/executes commands and publishes status. Current LinuxCNC Python-interface documentation says user interfaces monitor results by observing the LinuxCNC status structure and that the normal Python pattern is `linuxcnc.stat()` followed by `stat.poll()` when current status is required.

This is a crucial X02 distinction: a Python/UI `poll()` is a userspace observation of a status channel. It is not automatically a timestamped realtime sample taken at the moment a corresponding HAL value changed.

### Surface D — command/error channels

The Python interface documents separate command, status, and error NML channels. Pinned Task source also owns `emcCommandBuffer`, `emcStatusBuffer`, and `emcErrorBuffer`. X02 should decide whether command serial/echo state or error-channel messages provide useful correlation markers, but must not assume message arrival order across separate channels creates one global total order.

## Initial source inventory

| Path / symbol | Execution context | X02 question | State |
|---|---|---|---|
| `src/emc/motion/*` / motion controller functions | realtime | exact HAL/motion event production and cycle ownership | deeper trace required |
| `src/emc/task/taskintf.cc::emcMotionUpdate()` | Task/userspace-side motion interface | when one motion-status snapshot is acquired and fanned into EMC status | source inventory confirmed; body trace next |
| `src/emc/task/emctaskmain.cc` Task main loop | non-realtime cyclic Task process | status refresh/publish cadence and ordering vs plan/execute | source inventory confirmed; exact publish flow next |
| `EMC_STAT` / `EMC_MOTION_STAT` definitions | NML/status data model | which fields have explicit sequence/heartbeat/echo semantics | trace next |
| Python `linuxcnc.stat().poll()` implementation | userspace UI/API | whether poll exposes sequence/freshness metadata and what a poll boundary means | trace next |
| X01 `sampler.c::sample()` + `halsampler` | realtime producer + userspace drain | trustworthy HAL-side evidence and invalid-interval rules | accepted prerequisite |

## Official documentation findings

Current documentation establishes several useful boundaries but does **not** by itself prove synchronization:

- The Python interface describes NML command, status and error channels and instructs applications to poll the status channel for current values.
- LinuxCNC Code Notes describe motion as realtime while Task/GUIs are non-realtime, with motion command/status transfer using shared-memory/message-passing plus HAL.
- Core-component documentation states motion is the realtime motion-planner interface and its HAL pins are read/updated by the motion controller.

These sources justify treating HAL/motion and Task/NML as distinct update surfaces. X02 still needs pinned-source tracing and a controlled experiment before claiming measurable ordering/freshness bounds.

Official sources:

- https://linuxcnc.org/docs/devel/html/en/config/python-interface.html
- https://linuxcnc.org/docs/html/code/code-notes.html
- https://www.linuxcnc.org/docs/stable/html/config/core-components.html

## Community research finding

A LinuxCNC forum example creates a userspace Python component that calls `linuxcnc.stat()`/`s.poll()` and then republishes selected status values as HAL pins. This is useful precisely because it exposes a tempting but dangerous architecture: once an NML status value is republished into HAL, it can look like any other HAL pin even though its freshness still depends on the userspace polling loop and upstream Task/status publication.

Community source:

- https://forum.linuxcnc.org/24-hal-components/51171-radius-diameter-programming-and-hal

Classification: **COMMUNITY-REPORTED PATTERN / INVESTIGATION LEAD**, reconciled with official Python-interface semantics but not yet used as synchronization proof.

## Initial call-flow hypothesis to verify from pinned source

```text
realtime motion cycle
  -> motion state + HAL-visible values
  -> motion status shared-memory publication

non-realtime Task cycle
  -> emcMotionUpdate()
     -> read one motion-status snapshot
     -> populate EMC_MOTION_STAT / wider EMC_STAT
  -> status channel publication

independent userspace observer/UI
  -> linuxcnc.stat().poll()
     -> obtain latest available EMC_STAT snapshot
     -> application timestamps/uses it
```

The arrows do **not** yet imply fixed latency or one-to-one cycle correspondence. X02 must locate sequence/heartbeat/serial fields, identify overwrite/latest-state semantics, and experimentally determine what ordering can actually be defended.

## Failure hypotheses / adversarial cases

1. **Fresh HAL + stale NML:** realtime state changes while Task or UI polling is delayed; apparent cross-surface lag is observer/publication latency.
2. **Fresh NML + recorder hole:** NML status appears current while X01 detects missing HAL-side recorder coverage; cross-surface event order becomes uncertain.
3. **Same wall-clock label, different acquisition:** a collector timestamps HAL and NML observations after reading both sequentially and falsely presents them as simultaneous.
4. **Republished stale status:** a userspace status poll is written to a HAL pin and later sampled atomically with true realtime pins; the row is atomic only for the pin values *at sampler invocation*, not for the age of the republished NML information.
5. **Channel-order assumption:** command/status/error messages from distinct NML channels are treated as one globally ordered event stream without source evidence.
6. **GUI smoothness/freshness confusion:** frequent UI redraw creates plausible-looking continuity without proving each displayed value is newly published controller state.

## Pre-experiment questions that must be answered before freezing X02-001

- Which concrete two or three surfaces should X02-001 correlate? Prefer the smallest fixture that exposes a real update-boundary issue.
- What source-owned sequence/heartbeat fields exist in motion status, Task status, and Python `stat` exposure at the pinned revision?
- Where exactly in the Task cycle is `emcMotionUpdate()` called relative to `emcStatusBuffer->write(...)`?
- Can the experiment trigger one deterministic realtime event and preserve both a realtime cycle witness and a Task-side heartbeat/sequence without relying on synchronized wall clocks?
- What bounded delay/jitter should be predicted before execution, and which result would falsify the proposed synchronization model?
- How will X01 health make an interval invalid rather than merely lower-confidence?

## Exact checkpoint

Perform pinned-source call-flow tracing for `emcMotionUpdate()` through Task status publication and for the userspace `linuxcnc.stat().poll()` path. Identify explicit sequence/heartbeat/echo fields available at the pinned revision. Then select the minimal X02-001 surfaces and freeze a predeclared correlation experiment; do not launch it until the ordering/freshness oracle is source-grounded.
