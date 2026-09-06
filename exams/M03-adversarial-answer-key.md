# M03 adversarial exam — answer key and correction pass

Result: **PASS** at 1000-level foundation depth.

1. A producer scheduled before `motion-controller` can update `joint.N.motor-pos-fb` before `process_inputs()` samples it, so that controller invocation can consume the newly produced value.
2. `motmod` creates/exports but does not `addf` the motion functions. HAL configuration determines their scheduled order.
3. `process_inputs()` reads `joint_data->motor_pos_fb`; ordinary feedback subtracts backlash filter and motor offset. Later `get_pos_cmds()` and compensation paths evolve commands; `output_to_hal()` forms/publishes `motor_pos_cmd`, `joint_pos_cmd`, and `joint_pos_fb`.
4. `emcmotCommandHandler()` uses `rtapi_mutex_try`; failure to acquire returns without blocking. The command remains eligible for a later invocation rather than being established as processed now.
5. A differing command number identifies new work; echo fields mark accepted/processed command state. They do not establish a fixed command latency or realtime deadline.
6. In the canonical loopback, motion samples the old shared `Xpos` early and writes the new motor command to that same signal late. A post-controller sampler therefore sees old feedback publication and new command together. Arbitrary hardware layouts can place fresh feedback producers before motion and need not show this relation.
7. Homing index search intentionally overrides the ordinary feedback relationship around index capture, so the simplified formula is not universal.
8. Source conclusions are pinned to `8bf4605...`; stable 2.9.x requires corresponding source comparison and, for runtime claims, a stable-revision experiment.
9. Schedule the synthetic feedback producer before `motion-controller`; sample producer output plus motion-published feedback after motion and verify same-pass equality under a discriminating changing input.
10. Inspect thread order and signal writers/readers first, then sample around motion with a changing source. Move only the producer's relative position while holding other conditions fixed; if the phase changes, the delay is configuration/order dependent rather than a universal internal one-period rule.
11. No. M03 establishes software execution/data phase only. Fault-detection, following-error policy, physical I/O freshness, watchdogs, machine hazards, and functional safety remain separate modules.

## Correction pass

No core M03 source conclusion required correction after lab 008 or the exam. The principal wording discipline is retained: the one-cycle relation is **canonical-loopback-specific**, not a universal LinuxCNC servo latency statement. Task command mutex timing, planner branch depth, cross-thread exchange, hardware transaction timing, and safety implications remain promoted rather than silently generalized.
