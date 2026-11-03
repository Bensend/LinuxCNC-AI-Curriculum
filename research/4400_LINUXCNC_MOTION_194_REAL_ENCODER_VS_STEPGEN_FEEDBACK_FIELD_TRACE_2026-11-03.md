# MOTION-194 — Field encoder feedback versus HostMot2 stepgen estimates (2026-11-03)

**Status:** 4000 NON-GRADUATED; source/config-confirmed wiring, physical behavior UNKNOWN; no execution. **Priority:** LinuxCNC motion/feedback, not safety-course advancement.

## Question and provenance
MOTION-193 established that AXIS `core_sim.hal`, Tcl `basic_sim`, and bundled 7i96S stepgen position feedback are not independent mechanical measurements. This lesson asks whether a real publicly inspectable Mesa installation demonstrates the different, encoder-backed signal path. Previous checkpoint: `checkpoints/20261103T1834Z-4000-linuxcnc-motion-193-next.md`.

Sources:
1. LinuxCNC upstream 2.9.10 `configs/by_machine/smithy/924.hal` and `924.ini`: https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/924.hal and https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/924.ini . This is a **negative control**: although the card allocates 3 encoders, axis X/Z feedback uses stepgen.position-fb; encoder.00 is spindle only.
2. LinuxCNC issue #2388, opened 2023-03-10, contains a user's `halcmd show sig` from a Mesa 5i25/7i76 machine: https://github.com/LinuxCNC/linuxcnc/issues/2388 . **FIELD-REPORTED configuration snapshot, not an upstream-tested or pinned source revision.** It provides a concrete encoder-backed **A joint** amid stepgen-backed X/Y/Z joints. This issue concerns homing behavior; do not infer a proven homing root cause from its signal snapshot.
3. LinuxCNC upstream 2.9.10 `configs/by_machine/smithy/924.hal` for explicit `addf` order. This does not prove the field machine uses that order.

## Exact field signal provenance (A joint)
From the reported `halcmd show sig`:
- `joint.3.motor-pos-cmd` -> `A-pos-cmd` -> `pid.a.command`.
- `hm2_5i25.0.encoder.01.position` -> `A-pos-fb` -> BOTH `joint.3.motor-pos-fb` and `pid.a.feedback`.
- `joint.3.vel-cmd` -> `pid.a.command-deriv`.
- `joint.3.amp-enable-out` -> `A-enable` -> `pid.a.enable`, `hm2_5i25.0.pwmgen.00.enable`, and a GPIO output.
- `pid.a.output` -> `A-idbin` -> `idb.0.in`; `idb.0.out` -> `A-idbout` -> `hm2_5i25.0.pwmgen.00.value`.

**Important correction to simplistic diagrams:** `pid.a.output` does NOT feed PWM directly. An intermediate `idb.0` block intervenes, and its implementation, configuration and limiting behavior are not established by this signal dump. No claim of amplifier drive magnitude or physical response is warranted. Likewise, encoder position is a hardware-counter measurement only to the extent the encoder is physically installed, scaled, wired and healthy; this snapshot alone cannot certify those conditions.

In the *same* snapshot, X/Y/Z `joint.N.motor-pos-fb` are fed by `hm2_5i25.0.stepgen.N.position-fb`. Therefore, the same Mesa machine mixes feedback provenance by joint. A global label such as 'Mesa closed-loop' is insufficient.

## Comparison with pinned upstream negative control
The Smithy 924 5i20 HAL loads `num_encoders=3 num_pwmgens=1 num_stepgens=2`, but its `encoder.00.position` goes to `spindle.0.revs`; X and Z use stepgen position-fb. Its `addf` sequence is `hm2_5i20.0.read` -> `motion-command-handler` -> `motion-controller` -> ClassicLadder/lowpass -> `hm2_5i20.0.write`. No axis PID is scheduled in this example. INI uses `LINEAR_UNITS=inch`, 1,000,000 ns servo period, X scale -101600 and Z scale -50800 (step units per inch). Do not apply these scales or timing to the independent field A joint.

## Implementation contract for a verified encoder servo
A valid *new* servo example must separately establish: (1) actual encoder connector and quadrature count scale in counts/machine-unit; (2) encoder position as `joint.N.motor-pos-fb` AND PID feedback; (3) command/velocity feed-forward and output engineering units; (4) explicit `addf` ordering read -> motion -> PID -> output conditioning -> write; (5) enable, fault and amplifier interface behavior; (6) following-error thresholds in joint units; (7) independently observed physical motion. None of these can be replaced by an AXIS feedback-display setting or stepgen estimate.

## Disconnected discriminating exercise (NOT RUN)
Given a mixed machine, unplug or freeze the *hypothetical* A encoder in an offline model while continuing the commanded trajectory; compare `A-pos-cmd - A-pos-fb` and motion following-error handling to a simulated X stepgen estimate with the same physical stall. **Prediction:** only the encoder-backed joint can expose stalled physical motion through its feedback path, *provided* the encoder actually tracks that motion and the feedback update is valid; stepgen estimate may continue to follow generated steps. This is a source-grounded conditional prediction, not a tested machine fault. No physical unplugging or motion is authorized.

Freeze an oracle for later isolated self-hosted simulation: record per-servo-cycle command, raw encoder counts, scaled encoder position, PID output, post-idb output, enable, motion f-error, and timing; force stale encoder input, sign inversion, scaling mismatch and disabled output separately. The field issue does not supply these traces.

## Evidence ledger / unresolved
- SOURCE-CONFIRMED: upstream Smithy HAL and INI text at v2.9.10; no axis encoder feedback in that example.
- FIELD-REPORTED: LinuxCNC issue #2388 signal topology of one A encoder servo and X/Y/Z stepgen axes; not independently built or reproduced.
- INFERENCE: encoder-backed feedback can detect deviations stepgen feedback cannot; depends on real sensor integrity.
- UNKNOWN: field `idb.0` implementation, A encoder scale, PID tuning, `addf` ordering, actual drive and fault behavior, homing issue root cause.
- TEST-CONFIRMED: none this session. No build, runtime, hardware, Actions or compute.
- Graduated 1000–3000, blind evaluation and independent personnel-safety authority unchanged.

## Next high-information work
Find a complete, revision-pinned **encoder-backed Mesa axis** HAL+INI pair (prefer upstream or a fixed commit) exposing `addf`, `encoder.scale`, PID, output conditioning and drive enable. If unavailable, use an upstream Pico servo HAL/INI as a complete comparative source but label it non-Mesa; or rotate to plasma/press-brake DXF CAM provenance. Do not repackage the same signal dump as executable evidence.
