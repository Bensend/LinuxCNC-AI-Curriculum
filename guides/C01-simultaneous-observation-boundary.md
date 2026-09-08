# C01 — simultaneous observation boundary for duplicated-joint invariants

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Why this artifact exists

C01-023 attempt 1 produced an apparent `0.001 in` difference between duplicated Y joint commands even though pinned inverse-kinematics source assigns the same `pos->tran.y` value to every joint in the duplicated-Y bitmap during one call. The apparent difference was produced by an observation method that performed independent userspace HAL reads while the realtime producer continued to update at a 1 ms servo period.

At the test feed of 60 in/min = 1 in/s, one servo period corresponds to exactly 0.001 in. The same 0.001 signature also appeared between command and feedback endpoints that were directly connected through one HAL signal. That combination is evidence of a torn userspace observation, not evidence that one inverse-kinematics call generated different Y commands.

## Evidence domains

A statement such as

```text
joint.1.motor-pos-cmd == joint.3.motor-pos-cmd
```

is a simultaneous-state assertion. Evidence for it must preserve a common observation instant or a common realtime invocation. The following are different evidence domains:

1. **Sequential userspace reads** — useful for proving that endpoints exist, but not a valid simultaneous equality oracle while a realtime producer can update between calls.
2. **One realtime HAL function invocation** — suitable for a same-cycle multi-channel snapshot when the function reads all relevant signals before the next servo invocation.
3. **Physical actuator/encoder measurements** — separate again; equality of software commands is not equality of physical positions.

## Pinned `sampler` mechanism

At the pinned revision, `src/hal/components/sampler.c` exports one `sampler.N` realtime function per configured FIFO. Its realtime callback iterates the configured sampler pins, copies their values into one sample structure, and writes that sample to the realtime-to-userspace FIFO. Therefore all configured fields in one emitted row originate from one invocation of `sampler.N`.

For C01-023, schedule:

```text
motion-command-handler
motion-controller
sampler.0
```

in the same servo thread. A sampler row then observes the selected joint signals after the motion controller has executed for that servo invocation and before the next invocation begins.

Current LinuxCNC documentation describes the same architecture: `sampler` performs acquisition in realtime and writes samples to a FIFO; `halsampler` merely drains that FIFO in userspace. The Python HAL documentation also recommends disabling sampling before adding the function to a thread, starting the reader, then enabling sampling so startup idle data cannot fill the queue.

References:

- https://linuxcnc.org/docs/master/html/en/man/man9/sampler.9.html
- https://linuxcnc.org/docs/master/html/en/config/python-hal-interface.html

## Correct C01-023 observation contract

The corrected harness must preserve the frozen `1e-9` Gate E tolerance rather than widening it to accommodate userspace timing.

- Gate C may use independent userspace reads to establish that joint 1 and joint 3 command/feedback endpoints exist under distinct names.
- Gate D must independently establish a nontrivial coordinated move.
- Gate E must calculate duplicated-command equality only from fields captured in the same realtime sampler row.
- Gate F may verify the declared ideal loopback, but must state that command/feedback equality is fixture wiring and not an independent plant measurement.
- Gate G must not substitute world-Y status for direct joint-3 evidence.
- Observation reliability must be invalidated if the FIFO overruns or sample continuity required by the oracle is lost.
- Gate H cleanup evidence must still be gathered even if a behavioral gate fails.

## Important limitation of the loopback fixture

In the C01 baseline HAL, each `joint.N.motor-pos-cmd` and `joint.N.motor-pos-fb` pair is attached to the same named HAL signal. Sampling both endpoints therefore verifies that the declared ideal loopback topology is present; it does **not** provide an independent feedback sensor or simulated plant. That stronger evidence belongs in C02 and later modules.

## General engineering rule carried forward

For dual-actuator synchronization, anti-racking, redundant encoders, following-error comparisons, and watchdogs, the observation domain is part of the requirement. A comparison is not well-defined until the curriculum states whether values must be from the same realtime invocation, share a hardware timestamp/latch, or are allowed a bounded age/skew.

Consequently:

```text
same command source
!= same sampled instant
!= same physical position
!= synchronized plant
!= safety-rated protection
```

C01 may establish only the first two boundaries. Later capstone modules must build and test the remaining ones explicitly.
