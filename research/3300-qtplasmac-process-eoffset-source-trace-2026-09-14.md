# 3300-P1 — QtPlasmaC process state and external-offset ownership source trace

Date: 2026-09-14

Status: **SOURCE TRACE SUBSTANTIALLY COMPLETE — P1 remains an active 3000 specialization, not a graduation claim**

Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`

## Purpose

Trace the real QtPlasmaC `plasmac.comp` cutting sequence and establish exactly where plasma Z-height requests stop being process-component state and become LinuxCNC Motion external-offset motion.

This pass deliberately avoids a synthetic lab because the source and Motion implementation directly answer the current ownership question. A later lab is justified only if a non-duplicate runtime uncertainty remains, especially abort/offset cleanup or stale process-input behavior across a new pierce episode.

## Primary source inventory

- `src/hal/components/plasmac.comp` — realtime plasma process controller and THC state machine.
- `lib/hallib/qtplasmac_comp.hal` — QtPlasmaC HAL wiring, including `plasmac.{x,y,z}-offset-counts` and eoffset enables.
- `src/emc/motion/axis.c` — external-offset count accumulation, external-offset trajectory planner, applied/requested offset surfaces and soft-limit bounding.
- `src/emc/motion/control.c` — coordinated trajectory update and external-offset insertion call site.
- `docs/src/motion/external-offsets.adoc` — official external-offset public contract.
- `docs/src/plasma/qtplasmac.adoc` and Plasma Cutting Primer — intended QtPlasmaC/THC behavior and operating modes.

## Source-level process states

`plasmac.comp` exposes the following state set at this revision:

`IDLE -> PROBE_HEIGHT -> PROBE_DOWN -> PROBE_UP -> ZERO_HEIGHT -> PIERCE_HEIGHT -> TORCH_ON -> ARC_OK -> PIERCE_DELAY -> PUDDLE_JUMP -> CUT_HEIGHT -> CUT_MODE_01/CUT_MODE_2 -> PAUSE_AT_END -> SAFE_HEIGHT/MAX_HEIGHT -> END_CUT -> END_JOB`

with side/recovery states for:

- `TORCHPULSE`;
- `PAUSED_MOTION`;
- `OHMIC_TEST`;
- `PROBE_TEST`;
- `SCRIBING`;
- `CONSUMABLE_CHANGE_ON/OFF`;
- `CUT_RECOVERY_ON/OFF`.

This is a realtime process state machine, not a torch-on relay wrapper around ordinary XYZ G-code.

## Normal cut flow

### 1. Start and IHS qualification

When a cutting request begins from `IDLE`, the component holds feed and decides whether a new initial-height-sense/probe is required. It rejects a pre-existing breakaway, float-switch or ohmic-contact condition rather than treating that signal as a fresh probe event.

If skip-IHS conditions are met, prior cut-height information may be reused. Otherwise it establishes probe-start state and enters `PROBE_HEIGHT`.

**Contract:** a sensor being high is not equivalent to a valid new probe episode. The state machine qualifies the contact against the current probing phase.

### 2. Probe-height / probe-down / probe-up

`PROBE_HEIGHT` and `PROBE_DOWN` drive `z_offset_counts` while `z_offset_enable` is asserted. The probe path supports ohmic sensing and float-switch sensing.

Important source behavior:

- an ohmic-enabled setup can retry and fall back to the float switch after the configured number of ohmic attempts;
- reaching the lower physical/probing bound without valid contact pauses the program (or fails a probe test);
- after contact, `PROBE_UP` backs away until the contact releases before freezing the material datum;
- the released-contact position plus the configured ohmic or float travel offset establishes `zero_target`;
- `cut_target`, `pierce_target`, optional puddle-jump target and safe targets are then derived from that datum;
- per-cut `offset_min`/`offset_max` are derived from actual Z position, machine soft limits and the configured maximum-offset margin.

This makes the IHS result a phase-qualified material datum, not simply a raw input transition.

### 3. Pierce height

`PIERCE_HEIGHT` moves requested Z offset counts toward the pierce target. It does not advance merely because the requested count target has been written: it also waits until the actual applied `z_offset_current` corresponds to the target before proceeding.

That requested-versus-applied distinction matters because Motion plans external offsets under acceleration and velocity limits.

### 4. Torch start / Arc OK

`TORCH_ON` asserts the torch and initializes an arc-fail timeout. `ARC_OK` waits with feed held.

If transfer does not occur before `arc_fail_delay`, the torch is turned off, a restart delay is applied and the attempt count is incremented. After `arc_max_starts`, an automatic job is paused or a manual cut is stopped.

Arc-start failure is therefore distinct from an arc that was valid and is later lost.

### 5. Arc OK production and loss qualification

Modes differ:

- mode 0 synthesizes Arc OK from stable arc voltage within configured high/low limits;
- modes 1/2 use the external `arc_ok_in` signal.

In either case, loss is qualified by `arc_lost_delay`; it is not necessarily acted upon on the first bad servo sample. During an active cut, a qualified lost Arc OK turns the torch off, pauses the program, marks probing required and sends the process toward `MAX_HEIGHT` unless Arc OK is explicitly ignored for the current mode/operation.

### 6. Pierce delay and puddle jump

`PIERCE_DELAY` holds normal feed for a stationary pierce, or can coordinate supported moving-pierce behavior with requested-feed/adaptive-feed and Z-offset transitions. After the pierce interval, the sequence can enter `PUDDLE_JUMP` and then `CUT_HEIGHT`.

### 7. Cut-height transition

`CUT_HEIGHT` moves requested Z external offset to the cut target and again waits for the *applied* offset to reach that target before releasing feed hold and entering the cutting state.

### 8. THC qualification and correction

For modes 0/1, `CUT_MODE_01` uses arc voltage. THC target acquisition and correction are gated rather than continuously active:

- THC must be enabled and not explicitly disabled;
- mesh/Arc-OK-ignore paths inhibit normal THC behavior;
- target acquisition waits for cutting velocity to reach approximately 99.9% of requested rate (except the component's laser-mode special case);
- target acquisition may require THC delay and/or stable sampled voltage;
- corner lock can suppress height changes below the configured velocity percentage;
- void lock can suppress height changes across large voltage transitions;
- height override is handled as Z external-offset movement;
- PID-like voltage error output is deadbanded and clipped to the configured THC velocity.

Before a THC count update is accepted, the component checks the candidate against the per-cut `offset_min`/`offset_max`. A violation turns the torch off, pauses the program and sends the state to `MAX_HEIGHT`.

Mode 2 substitutes external move-up/move-down requests for the internal arc-voltage loop but retains corner-lock and offset-bound checks.

## End-of-cut and recovery behavior

### Normal end

`PAUSE_AT_END` can delay torch-off/end motion. `SAFE_HEIGHT` retracts through the Z external-offset request. `MAX_HEIGHT` drives Z offset counts back to zero. `END_CUT` clears THC/Arc-related process state.

`END_JOB` does not merely set a logical 'done' bit. It continues requesting Z offset return to zero and waits until Motion reports external offsets no longer active before resetting job state completely.

### Pause / sensor / arc faults

During an automatic cut, pause, breakaway, unexpected float/ohmic contact and valid arc loss are separate branches. Typical handling is:

`torch off -> program pause -> probe required/inhibit as applicable -> MAX_HEIGHT -> cleanup/recovery`

The exact branch depends on state and fault class.

### Offset-limit fault

The component monitors Motion's `motion.eoffset-limited` feedback through `plasmac.offsets-limited`. If Motion reports an active external offset being soft-limit limited, `plasmac` turns the torch off, pauses a running program, inhibits probing, records a pause stop type and enters `MAX_HEIGHT`.

This is *in addition to* the component's own per-cut `offset_min`/`offset_max` checks used before THC movement.

### Cut recovery

`CUT_RECOVERY_ON/OFF` uses X/Y external offsets for recovery positioning. It can also temporarily apply alignment-laser X/Y offsets. Recovery completion waits not only for requested count values to return to zero but for the actually applied X/Y offsets to report zero before clearing recovery state and releasing feed hold.

Therefore cut recovery is not equivalent to 'rewind the G-code line'. It has machine-state reconciliation in the external-offset layer.

## External-offset ownership trace

### QtPlasmaC side

`qtplasmac_comp.hal` wires:

- `plasmac.x-offset-counts -> axis.x.eoffset-counts`;
- `plasmac.y-offset-counts -> axis.y.eoffset-counts`;
- `plasmac.z-offset-counts -> axis.z.eoffset-counts`;
- `plasmac.xy-offset-enable -> axis.x/y.eoffset-enable`;
- `plasmac.z-offset-enable -> axis.z.eoffset-enable`.

Motion reports:

- `motion.eoffset-active -> plasmac.offsets-active`;
- `motion.eoffset-limited -> plasmac.offsets-limited`;
- per-axis applied offsets are available as `axis.<L>.eoffset` and are wired back into the process component where needed.

### Motion side

At each servo period, `axis_plan_external_offsets()`:

1. reads the current `axis.<L>.eoffset-counts`;
2. computes count delta since the previous period;
3. when enabled, homed and Motion-enabled, accumulates `delta * eoffset-scale` into the external-offset planner target;
4. exposes the requested target separately from the applied current offset.

The actual external offset is generated by a `simple_tp` instance with its own velocity and acceleration allocation.

During coordinated motion, Motion first obtains the nominal trajectory position from the coordinated trajectory planner. `axis_update_coord_with_bound()` then updates the external-offset planner and adds its current position to the Cartesian command with `axis_apply_ext_offsets_to_carte_pos(+1, ...)`.

Soft-limit logic can clamp the combined command and stop growth of the external-offset planner. Thus the effective command path is:

`QtPlasmaC process/THC state`
`-> plasmac.{x,y,z}-offset-counts + enable`
`-> qtplasmac_comp.hal`
`-> axis.<L>.eoffset-counts/enable`
`-> Motion axis_plan_external_offsets() request accumulation`
`-> Motion simple_tp external-offset planning`
`-> nominal coordinated TP position`
`-> axis_update_coord_with_bound()`
`-> add current external offset to Cartesian command`
`-> soft-limit bounding`
`-> downstream kinematics/joint command path`

**Key boundary:** `plasmac.comp` owns the process decision and requested count evolution. LinuxCNC Motion owns the applied offset trajectory, acceleration/velocity allocation, insertion into Cartesian motion and final soft-limit clipping.

## Requested, applied and nominal position are distinct

Three surfaces must not be collapsed:

1. nominal G-code/axis position;
2. requested external offset;
3. currently applied external offset.

`axis.L.pos-cmd` is intentionally reported without the applied external offset in `axis_output_to_hal()`. `axis.L.eoffset-request` and `axis.L.eoffset` expose the requested and applied offset separately.

QtPlasmaC explicitly waits for applied offset convergence at important transition points such as pierce height and cut height.

## Important external-offset semantics

Official Motion documentation and source establish:

- all relevant joints must be homed before count deltas are accepted;
- external offsets have separately allocated velocity and acceleration via `OFFSET_AV_RATIO`;
- disabling `axis.L.eoffset-enable` while a nonzero offset exists **does not clear the offset**; the current offset is held;
- offset clearing requires an explicit return through counts, an eoffset-clear request, or machine-off/on initialization according to the documented contract;
- an applied offset may lag the requested offset;
- `motion.eoffset-limited` means Motion had to bound external-offset/net motion at a soft limit;
- external-offset soft-limit behavior can stop without a normal deceleration interval, so operating close to soft limits is explicitly warned against.

These semantics make 'disable THC' and 'remove already-applied Z offset' two different actions.

## Failure/recovery matrix

| Event | Detection / qualification | Source-visible reaction | Evidence |
|---|---|---|---|
| Probe/contact already active before IHS | state-qualified sensor check in IDLE | pause or probe-test abort; probe inhibit | SOURCE-CONFIRMED |
| Ohmic contact unavailable but float switch hits | ohmic attempts vs configured maximum | retry ohmic, then fall back to float when allowed | SOURCE-CONFIRMED |
| Probe reaches lower bound with no valid contact | Z/probe bound check | program pause or probe-test error -> MAX_HEIGHT/test cleanup | SOURCE-CONFIRMED |
| Pierce target exceeds allowed Z height | target compared with computed max | pause/error rather than continue | SOURCE-CONFIRMED |
| Arc fails to start | `arc_fail_delay`, attempt count | torch off/retry; pause/stop after max starts | SOURCE-CONFIRMED |
| Arc is lost during cut | Arc OK after `arc_lost_delay` qualification | torch off, program pause, probing required, MAX_HEIGHT | SOURCE-CONFIRMED |
| Breakaway/float/ohmic event during active cut | state-qualified input | torch off, pause, probe required/inhibit, MAX_HEIGHT | SOURCE-CONFIRMED |
| THC candidate exceeds per-cut offset bound | candidate count vs offset_min/max | torch off, pause, zero PID output, MAX_HEIGHT | SOURCE-CONFIRMED |
| Motion reports net eoffset soft-limit limitation | `motion.eoffset-limited` + active offset | torch off, pause, probe inhibit, MAX_HEIGHT | SOURCE-CONFIRMED |
| Cut recovery offsets not yet physically returned | requested counts + applied eoffset checks | remain in recovery cleanup; do not release feed hold | SOURCE-CONFIRMED |
| Job ends with residual Z external offset | END_JOB checks counts and Motion active state | drive requested Z offset to zero and wait | SOURCE-CONFIRMED |

## Adversarial boundary review — 8/8 passed

1. **Premise:** clearing `z-offset-enable` removes the current external offset.  
   **Reject.** Motion documents and implements hold behavior for a nonzero offset when enable is removed.

2. **Premise:** `plasmac.z-offset-counts` directly writes the Z joint command.  
   **Reject.** Counts become a separately planned axis external-offset request in Motion and are inserted after nominal coordinated-position generation.

3. **Premise:** Arc OK loss pauses on the first bad input sample.  
   **Reject.** Arc loss uses `arc_lost_delay`; mode 0 also has voltage/sample qualification.

4. **Premise:** an ohmic failure always aborts IHS.  
   **Reject.** The source supports bounded ohmic attempts and float-switch fallback.

5. **Premise:** requested pierce/cut height is enough to advance state immediately.  
   **Reject.** the source waits for applied external offset/current-position agreement at the target.

6. **Premise:** only generic Motion soft limits bound THC.  
   **Reject.** QtPlasmaC computes per-cut offset bounds and checks them before THC updates; Motion independently enforces net soft limits and reports eoffset limitation.

7. **Premise:** cut recovery is ordinary G-code rewind.  
   **Reject.** the realtime component owns X/Y eoffset recovery positioning and waits for actual offset cleanup.

8. **Premise:** entering `END_JOB` proves all offsets are already zero.  
   **Reject.** `END_JOB` actively drives residual Z offset counts to zero and waits for external-offset activity to clear.

## Evidence classification

### SOURCE-CONFIRMED

- process state sequence and transitions described above;
- probe qualification and ohmic/float fallback;
- separate arc-start retry and arc-loss paths;
- THC target qualification, corner/void lock and per-cut bounds;
- Z count generation and X/Y cut-recovery offsets;
- Motion external-offset request/application separation and insertion point;
- Motion soft-limit clamp and active/limited feedback.

### DOC-CONFIRMED

- public external-offset count/scale/enable/request/current semantics;
- independent external-offset velocity/acceleration allocation;
- enable-does-not-clear behavior;
- warning about abrupt soft-limit stopping;
- QtPlasmaC mode 0/1/2 Arc OK / arc-voltage topology.

### COMMUNITY-REPORTED / not used as source proof in this artifact

Real-machine commissioning reports show configuration mistakes in QtPlasmaC mode, THCAD polarity and THCAD frequency/scaling can produce apparent Arc OK/voltage failures. Those are preserved separately in the P2 build-diary comparison.

## Lab decision

**NO NEW LAB.** The immediate P1 ownership and sequence questions are answered directly by pinned source and Motion documentation. A toy THC or state-machine fixture would duplicate stronger evidence.

A lab becomes useful if P1 later needs independent runtime verification of a consequential edge that source alone does not settle, especially:

- abort while a nonzero QtPlasmaC Z external offset is still applied;
- a stale/high Arc OK or probe input carried into a new pierce request;
- relationship between requested/applied eoffset state during an induced soft-limit interruption.

## Current P1 decision

P1 has enough source-level structure to stop rereading the state machine and proceed to real-machine/config evidence. It is **not yet a standalone graduated module**: production configuration variation, community commissioning history, independent verification and handoff/exam work belong in the wider 3300 plasma specialization.

## Exact continuation

Proceed to **3300-P2**:

1. preserve at least two real QtPlasmaC/PlasmaC machine implementation chronologies with differing hardware;
2. seek downloadable HAL/INI/config evidence where possible rather than relying only on prose;
3. prioritize a THCAD + separate Arc OK machine, an ohmic + float fallback machine, Powermax RS485 if inspectable, and a tandem-gantry implementation;
4. carry observed configuration failures back against this source contract;
5. then proceed to 3300-P3 material/CAM/post/recovery workflow.
