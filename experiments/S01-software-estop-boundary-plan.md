# S01 — bounded software E-stop boundary experiment plan

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Independently verify one production LinuxCNC software path without physical hardware:

`enabled baseline -> external-style iocontrol.0.emc-enable-in TRUE to FALSE -> Task E-stop status -> motion.motion-enabled FALSE`.

This experiment verifies **software/controller behavior only**. It is deliberately incapable of proving physical emergency-stop effectiveness, STO, torque removal, stopping time, PL, SIL, or category.

## Prediction recorded before execution

From the pinned Task/iocontrol and motion source:

1. with `emc-enable-in=TRUE`, after E-stop reset and Machine ON, LinuxCNC can reach an enabled baseline;
2. forcing the external E-stop input FALSE will cause Task to report E-stop and will drive motion disabled;
3. `iocontrol.0.user-enable-out` will be/return FALSE while the controller is in internal E-stop;
4. `motion.motion-enabled` will become FALSE after the fault is processed;
5. merely returning `emc-enable-in` TRUE is not evidence of a physical safe reset; software recovery should be observed as a distinct controller sequence rather than inferred from input release alone.

## Harness design

Reuse the hardened headless simulation pattern from IO07 and the already built pinned LinuxCNC environment. Avoid HostMot2 and physical I/O.

Use a minimal simulation HAL in which `iocontrol.0.emc-enable-in` is not looped directly from `user-enable-out`; instead give the input one controlled software writer so the test can emulate an external permissive.

Capture at a sufficiently high/realtime-oriented cadence where practical:

- controlled external-estop source value;
- `iocontrol.0.emc-enable-in`;
- `iocontrol.0.user-enable-out`;
- `iocontrol.0.user-request-enable`;
- `motion.motion-enabled`;
- Task state/status through the LinuxCNC status interface;
- relevant error/status channel output.

## Sequence

1. verify exact source SHA and clean current-run metadata;
2. start LinuxCNC headlessly with bounded startup/teardown;
3. set external permissive TRUE;
4. request E-stop reset, then Machine ON;
5. require baseline Task ON / `motion.motion-enabled=1` / external input TRUE;
6. timestamp injection and drive external permissive FALSE;
7. require observed E-stop state and `motion.motion-enabled=0` within a bounded observation window;
8. record `user-enable-out` state;
9. return external permissive TRUE but do not silently call that a safety reset; capture resulting controller state before any explicit reset/on command;
10. perform explicit software reset/re-enable only if useful for recovery-state characterization;
11. preserve raw logs, commands, SHA, timestamps, exit code and assertions.

## Acceptance gates

PASS only if all are true:

- the baseline was demonstrably enabled before injection;
- the injected source is demonstrably the writer feeding `emc-enable-in`;
- the test sees the input transition TRUE -> FALSE;
- Task/controller E-stop status responds;
- `motion.motion-enabled` deasserts;
- the artifacts are unquestionably from this run and pinned revision;
- the result text explicitly says the test proves no physical safety performance.

If the Task status observer is too slow to capture a transient intermediate state, that is not permission to invent it. Use durable final states and/or add a higher-cadence observer in a materially corrected attempt.

## Failure classification

- startup/harness failure before verified baseline: **HARNESS INVALID**, not a failed LinuxCNC prediction;
- injection not actually connected to `emc-enable-in`: **HARNESS INVALID**;
- input transition observed but motion remains enabled through the bounded window: **PREDICTION FAILURE — investigate source/runtime before rerun**;
- observer races around transient reset/request pins: preserve raw evidence and redesign sampling rather than polling until the expected value appears.

After at most three materially similar failed/stalled attempts, explicitly choose ESSENTIAL NOW / PROMOTE / DROP per `MODULE_TEMPLATE.md`.

## Evidence boundary

A pass may be labeled TEST-CONFIRMED only for the tested LinuxCNC software state path on the pinned simulation build. Physical E-stop hardware, STO, brakes/contactors, stored energy, reaction/stopping time, fault tolerance and machine-specific compliance remain outside this experiment.
