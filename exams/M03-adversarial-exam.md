# M03 adversarial exam — one servo-period trace

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

1. A machine HAL file schedules `hardware-read`, then `motion-controller`, then PID. Explain exactly which feedback value `emcmotController()` can consume in that invocation and why.
2. Misleading premise: “Because `motmod` creates `servo-thread`, it also guarantees `motion-command-handler` and `motion-controller` execute in that order.” Correct the premise and identify where the actual order comes from.
3. Trace one normal active joint through `process_inputs()` and `output_to_hal()`: identify the motor feedback sample, the ordinary joint-feedback calculation, the command-generation boundary, and the final motor command publication.
4. What happens if Task holds the motion command mutex when `motion-command-handler` runs? Does the realtime function block, discard the command, or defer processing? State the source mechanism.
5. Why is `commandNum != commandNumEcho` important? What does echoing establish, and what does it not prove about userspace-to-motion latency?
6. Lab 008 observed `joint.0.pos-fb[n] == Xpos[n-1]` and `joint.0.pos-cmd[n] == Xpos[n]`. Explain why this is expected in the canonical linuxcncrsh loopback and why it must not be generalized to arbitrary hardware configurations.
7. Failure-path question: during homing index search, why can the ordinary formula `joint feedback = motor feedback - compensation/offset` be an invalid description of that servo invocation?
8. Version/scope question: which conclusions may be carried only as pinned-revision evidence, and what would you need before claiming identical behavior for stable 2.9.x?
9. Configuration task: modify the conceptual HAL order so a synthetic feedback producer affects motion in the same servo-thread pass. Where must it be scheduled relative to `motion-controller`, and what experiment would prove the change?
10. Debugging scenario: an integrator sees a one-cycle feedback delay and claims LinuxCNC motion always imposes one servo period of latency. Give a bounded diagnostic procedure using `show thread`, HAL signal topology, and a post-controller sampler to distinguish configuration ordering from an internal universal delay.
11. Safety question: does the source trace or lab 008 establish that stale/frozen feedback will always be detected safely before hazardous motion? Explain the evidence boundary.
