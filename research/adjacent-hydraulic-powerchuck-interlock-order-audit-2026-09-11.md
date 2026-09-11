# Adjacent hydraulic-machine evidence — `powerchuck` interlock and realtime ordering audit

Date: 2026-09-11
Course context: **3600 Press Brakes — adjacent architecture evidence only**
Status: BOUNDED COMMUNITY/CONFIG ANALYSIS; not press-brake implementation evidence

## Why inspect this

The current 3600 checkpoint asked for one independent public LinuxCNC hydraulic-machine implementation with an executable mode/output interlock pattern, preferably including a physical/process completion witness, after the final Ursviken press-brake decoder source remained unavailable.

The LinuxCNC forum `powerchuck` example is a small hydraulic/pneumatic chuck controller used on a lathe. It is **not** a press brake and must not be copied as a hydraulic ram controller. It is useful because it exposes a concrete command/interlock/output chain and a real HAL scheduling issue that generalizes to press-brake decoder review.

Public thread:
https://forum.linuxcnc.org/47-hal-examples/47966-powerchuck-hal-component-operates-hydrualic-chucks-collet-closers-etc

The final-machine archive is linked by the forum as `powerchuck.zip`, but the attachment contents were not retrievable in this session. Therefore internal component branches are not source-confirmed here. The forum discussion and posted HAL remain inspectable evidence.

## Publicly described interface

The author describes:

- `ChuckIn` / `ChuckOut`: define default grip behavior;
- `CycleChuck`: momentary foot-pedal/request input;
- `SpindleEnable`: must be false before chuck state/mode may change;
- `SpindleBrake`: must be true before chuck state/mode may change;
- `ChuckSolenoid`: hydraulic/pneumatic actuator command;
- optional single-switch direction mode.

The author explicitly says spindle brake and spindle enable should preferably come from feedback sensors, because the mechanism must not actuate after spindle motion begins.

**Evidence class:** `COMMUNITY-REPORTED DESIGN/IMPLEMENTATION INTENT`.

A later user reports compiling the component, wiring the nets correctly after fixing signal naming, modifying it, and using it successfully on a CNC lathe. That is useful field-use evidence, but does not independently verify every internal branch.

**Evidence class:** `COMMUNITY-REPORTED FIELD USE`.

## HAL execution order found in the posted configuration

The public HAL example schedules:

```text
hm2_7i96s.0.read
motion-command-handler
motion-controller
pid.x.do-pid-calcs
pid.z.do-pid-calcs
pid.s.do-pid-calcs
hm2_7i96s.0.write
powerchuck
```

LinuxCNC same-thread functions execute in `addf` order, as already source/documentation traced by the curriculum's H04 work.

Therefore, if `powerchuck` changes `ChuckSolenoid` during its invocation, and that solenoid is ultimately routed through HostMot2 hardware output, the shown schedule means:

1. `hm2.write` has already published this servo period's output image;
2. `powerchuck` then computes the new solenoid state;
3. the new state cannot reach the HostMot2 write until the **next** servo-thread invocation.

This is a one-period command-age boundary.

**Evidence class:** `CONFIG-CONFIRMED` ordering + existing curriculum `SOURCE/DOC-CONFIRMED` HAL scheduling semantics.

## Why this matters for the press-brake decoder contract

This adjacent example gives a concrete warning for the proposed press-brake chain:

`semantic state -> hydraulic decoder -> ordinary authorization -> hardware write`

If the machine-specific decoder or authorization gate runs **after** the hardware write, a newly detected ordinary-control fault or interlock change can leave the old actuator command published for one additional period.

That may or may not be acceptable for a particular non-safety control function, but the latency must be deliberate and bounded. It cannot be inferred away because all blocks reside in the same realtime thread.

For a press brake with multiple spool valves, proportional valves, pressure control and Y1/Y2 synchronization, this scheduling requirement is more consequential: the final output combination should be computed before the hardware-write function that publishes it.

## Interlock observability lesson

The author recommends using actual spindle/brake feedback signals for the interlock rather than only command intent. This yields a general pattern:

```text
requested mode
    + actual machine-state witness
    -> authorization decision
    -> hydraulic output
```

That is stronger than:

```text
requested mode
    + software command state
    -> hydraulic output
```

when the physical subsystem can fail to achieve the commanded state.

The pattern transfers to press brakes only at the architectural level. Examples:

- commanded pressure-dump mode should preferably have a measured pressure-decay witness;
- commanded Y1/Y2 valve action should be checked against independent ram-scale response;
- stateful valve actuators may need direct position/current feedback where process feedback is too delayed or ambiguous.

## Signal-integration failure observed in the thread

A user initially created separate HAL signal names (`SpindleEnable`, `SpindleBrake`) that were not actually connected to the machine's existing spindle signals. The component pins therefore remained false even though the machine's `spindle-enable` signal changed.

After reconnecting to the actual lowercase machine signal, the integration worked.

This is an important HAL lesson for 3600 commissioning:

**matching semantic names do not create connectivity.** Trace the actual signal writer and every reader. A press-brake decoder can appear correctly named while still consuming an un-driven signal.

## Missing completion witness

The inspected public HAL and discussion show a solenoid command and spindle/brake authorization, but they do not expose a chuck-pressure switch, jaw-position switch, clamp-confirm input, or bounded hydraulic completion timeout in the visible excerpt.

Therefore this example does **not** satisfy the strongest desired pattern:

`command -> physical effect -> completion witness -> fault if absent`.

Classify that portion as **UNKNOWN / NOT SHOWN** rather than assuming the chuck is confirmed merely because the solenoid was commanded.

## Adversarial checks

### Trap 1 — same thread means same-cycle output

A reviewer sees `hm2.write` and `powerchuck` in `servo-thread` and concludes the solenoid update is written immediately.

**Reject.** `addf` order matters. In the posted HAL, the hardware write precedes `powerchuck`, so a new component output waits until the next write invocation.

### Trap 2 — `SpindleBrake` pin name proves physical brake engagement

**Reject.** A HAL pin name is not provenance. The author explicitly prefers sensor feedback, but the actual net must be traced to its writer to know whether it is command state or physical feedback.

### Trap 3 — successful solenoid command proves the hydraulic mechanism completed

**Reject.** No completion sensor is visible in the inspected excerpt. Commanded output is not physical completion.

### Trap 4 — this lathe component proves a press-brake hydraulic pattern is safe

**Reject.** It is adjacent ordinary-control evidence only. Press-brake hydraulic sequencing, Y1/Y2 synchronization, decompression and functional safety require their own machine-specific evidence and hazard analysis.

## Derived 3600 review rule

For every press-brake machine-specific hydraulic decoder, document the exact same-period chain:

```text
hardware/process inputs acquired
-> semantic/process state evaluated
-> hydraulic mode decoded
-> ordinary authorization/interlocks evaluated
-> final output image produced
-> hardware write publishes outputs
```

Then independently trace feedback/diagnostic witnesses back into the next evaluation cycle.

If the actual order differs, record the resulting state age explicitly in servo periods and justify it.

## Precise next-work checkpoint

1. Search for a second adjacent LinuxCNC hydraulic actuator example that includes an explicit **completion/pressure/position witness and timeout/fault branch**, not merely command interlocking.
2. Prefer inspectable `.comp`, ClassicLadder, HAL, or repository source over forum prose.
3. Trace `request -> interlock -> output -> completion witness -> timeout/fault -> output inhibit/recovery` and exact realtime/userspace context.
4. Then compare the verified pattern against the 3600 decompression and hydraulic-decoder contract without copying machine-specific thresholds or valve combinations.
5. Preserve current blockers: S02/E20/X01/X02 fresh-AI handoffs remain information-separated; F02 remains blocked; PB-PREP-001 remains INCONCLUSIVE.
