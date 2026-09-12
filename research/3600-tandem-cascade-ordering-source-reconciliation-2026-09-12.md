# 3600 — Tandem Y1/Y2 cascade ordering source reconciliation

Date: 2026-09-12

## Scope

This note reconciles the Ursviken/Pullmax field reports of cascaded per-side position/velocity control and later Y1/Y2 differential synchronization against stock LinuxCNC PID and HAL scheduling semantics. It does **not** claim the final machine HAL/configuration is known; the promised final configuration is still unavailable in the public thread as inspected.

LinuxCNC source revision used for source-level claims: `f325d51f52da7d5e0e227ac35e3672ee6f873b4f`.

## Community evidence

The Ursviken/Pullmax retrofit chronology reports:

- February 13, 2026: each ram side drove its servo valve from a velocity-PID output; the position-PID output was wired as the velocity-PID command. The builder reported that left/right synchronization worked, but the machine groaned and tuning/nonlinear hydraulics remained unresolved.
- July 20, 2026: the builder described the physical valves as tee'd from the same pump and the original flow-divider behavior as electronically emulated in LinuxCNC HAL.
- July 22, 2026: after a reported 90-degree steel bend, the builder described two per-side position PIDs plus a sync PID with command 0 and feedback `Y1-Y2`, whose correction slows the side that is ahead.

Classification: **COMMUNITY-REPORTED FIELD SUCCESS / FINAL SOURCE UNAVAILABLE**.

Forum source: https://forum.linuxcnc.org/show-your-stuff/58003-ursviken-pullmax-optima-130-press-brake-retrofit-with-4-axis-backgage?start=30

## Source-grounded PID semantics

Pinned `src/hal/components/pid.c` documents and implements one independent realtime function per PID instance, exported as `<name>.do-pid-calcs`.

For a position loop:

- `command` and `feedback` are position quantities;
- `error = command - feedback`;
- the output represents the control effort needed to reduce that error and is conventionally a velocity quantity for a position loop;
- `maxoutput` limits **that PID block's output**;
- `saturated` is asserted only when that PID block reaches its configured `maxoutput`;
- disabling the PID resets the integrator and forces output to zero.

The component documentation explicitly allows the same PID implementation to be used for speed loops and other controlled quantities. Therefore a field wiring of:

`position_pid.output -> velocity_pid.command`

is semantically coherent **only if** the velocity PID's command/feedback units are velocity-compatible and its output is interpreted as the downstream actuator command. The LinuxCNC PID component itself does not create or verify that unit contract; HAL wiring owns it.

Source: `src/hal/components/pid.c`, revision `f325d51f52da7d5e0e227ac35e3672ee6f873b4f`, especially `calc_pid()` and `export_pid()`.

Official documentation corroborates that `pid.N.output` is the loop output, `pid.N.enable` zeroes output/resets internal integrators when false, and `pid.N.saturated` means only `output = +/- maxoutput` for that PID block.

## Realtime call-flow consequence

Each PID instance exports a separate `<name>.do-pid-calcs` function. HAL realtime threads call functions in the order they were added with `addf`.

Therefore a same-thread cascade has a behaviorally significant ordering requirement:

1. acquire/update the feedback signals needed by the loops;
2. run the outer position PID;
3. run the inner velocity PID that consumes the outer PID's output;
4. apply any downstream mapping/limiting and write the actuator command.

If the velocity PID executes **before** the position PID in the same thread, it consumes the previous cycle's outer-loop output. That is a deterministic one-servo-period stale-command boundary, not an abstract tuning detail.

Likewise, a tandem sync correction has its own ordering dependency. If the sync PID's correction is meant to affect the same servo cycle, its differential feedback must be produced and the sync PID must run before the correction-selection/insertion stage and before the final per-side actuator outputs are committed. The public field report does not expose this ordering.

Official scheduling evidence:

- HAL Basics: `addf` determines a realtime function's position in a thread.
- `halcmd(1)`: a thread calls its functions in the order they were added.

## What the February + July chronology does and does not establish

### Established at community level

A plausible field chronology is:

`Y target`
→ per-side position PID
→ per-side velocity command
→ per-side velocity PID
→ servo-valve command

with later differential synchronization based on `Y1-Y2` and a correction that slows the leading side.

The February post proves that a position→velocity cascade was actually being tested. The July post proves that the later successful-bend architecture retained per-side position PIDs and added a differential synchronization concept.

### Still UNKNOWN

The public chronology does **not** establish:

- whether the velocity PIDs remained in the July successful-bend configuration;
- the velocity feedback producer and units used by the inner loops;
- exact `addf` order;
- whether sync correction is inserted before or after the velocity PID;
- whether correction modifies velocity command, PID output, valve command, or another intermediate signal;
- correction polarity/selection algebra beyond the prose phrase "slowing the one that is ahead";
- per-side and sync `maxoutput` settings;
- downstream clipping after PID output;
- valve deadband/dither compensation;
- process-state gating across fast approach, change point, bending, dwell, decompression and return;
- feedback freshness/disagreement logic;
- fault ownership and recovery.

These remain **UNKNOWN**, not implementation details to infer.

## Failure-path implications

### Wrong function order

If outer and inner loops are wired correctly but ordered incorrectly in the same servo thread, the inner velocity loop receives a one-cycle-old outer-loop command. This may be stable, unstable, or merely degrade phase margin depending on plant/tuning; the generic LinuxCNC source cannot decide the machine-specific consequence.

### Unit-contract mismatch

LinuxCNC HAL pins are typed but not dimensionally typed. A float can be connected even when engineering units are conceptually wrong. A position-PID output used as a velocity command is legitimate only because the designer chooses gains/scales consistent with that contract.

### Saturation witness mismatch

`position_pid.saturated`, `velocity_pid.saturated`, and any sync PID saturation are three distinct controller-local witnesses. None proves that the final valve command, H-bridge/current regulator, hydraulic flow, external amplifier, or cylinder motion retained authority. Downstream limits must remain separate evidence.

### Differential-loop freshness

A sync PID operating on `Y1-Y2` is only as current as the two position samples feeding the difference. The public thread does not establish whether those samples are acquired in one hardware read phase or can be skewed. Treat simultaneous/fresh differential feedback as an explicit requirement, not an assumed property.

## Prediction check

Prediction before source reconciliation: if the Ursviken position PID truly feeds a velocity PID, stock LinuxCNC should expose PID instances independently and make same-cycle cascade behavior depend on HAL function ordering rather than automatically enforcing parent/child execution.

Observed: **MATCH**. `pid.c` exports an independent realtime function per loop, while HAL `addf` order controls execution order. No cascade relationship is encoded inside the PID component.

## Adversarial verification

1. **Does `position_pid.output -> velocity_pid.command` automatically guarantee correct engineering units?** No. HAL float typing does not enforce dimensions; scaling/gains and feedback producers must establish the unit contract.
2. **Does LinuxCNC automatically execute a position PID before the velocity PID it feeds?** No. Each PID is an independent exported realtime function; `addf` ordering determines execution order.
3. **If the inner PID runs first, is the cascade disconnected?** No. It remains connected but consumes the prior-cycle outer output, introducing one servo-period command age.
4. **Does the July statement "two position PIDs plus one sync PID" prove the February velocity PIDs were removed?** No. The later summary is not an exhaustive wiring disclosure.
5. **Can `sync_pid.saturated` be treated as proof that Y1/Y2 valve commands are not saturated?** No. PID-local saturation is distinct from downstream per-side clipping/authority.
6. **Can the reported successful bend establish correct ordering across all phases and fault cases?** No. It is useful field evidence, not an inspectable implementation or exhaustive validation.
7. **Can a differential sample be assumed coherent because both encoders are on the same machine?** No. acquisition/read ordering and freshness remain an implementation question.

Result: **7/7 boundary checks PASS**.

## Curriculum impact

The tandem branch gains a more precise source-grounded implementation question without changing PB-PREP-001's verdict.

The next source must expose the actual final execution graph, not merely PID names. A useful artifact must show enough HAL/component source to reconstruct:

`hardware feedback read -> Y1/Y2 feedback production -> differential production -> outer PIDs -> sync PID -> correction-selection/insertion -> optional inner velocity PIDs -> final limit/mapping -> hardware write`

including thread order and failure gates.

Until then:

- field topology remains **COMMUNITY-REPORTED**;
- generic PID behavior and HAL ordering are **SOURCE/DOC-CONFIRMED**;
- final tandem correction insertion and realtime order remain **UNKNOWN**;
- PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**.
