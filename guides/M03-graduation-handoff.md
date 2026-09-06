# M03 graduation handoff — one servo-period trace

Course level: 1000 foundations

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: **GRADUATED**

## What a fresh AI must know

`motmod` creates `servo-thread` and exports `motion-command-handler` and `motion-controller`, but HAL configuration decides where those functions are inserted and therefore what runs before/after them in a particular machine.

`emcmotCommandHandler()` is a realtime HAL function that uses a nonblocking command mutex attempt. If Task owns the shared command structure, the servo invocation does not wait; command handling is deferred. A command is recognized as new when `commandNum` differs from `commandNumEcho`; processing updates echo/status state but does not imply a fixed userspace-to-motion latency.

Within `emcmotController()`, `process_inputs()` samples each active joint's `joint.N.motor-pos-fb` early. In the ordinary non-index-search path, joint feedback is derived from motor feedback minus backlash-filter and motor-offset terms. After kinematics, fault/mode/homing/planner/setpoint work, `output_to_hal()` forms and publishes the new motor command and publishes joint command/feedback near the end of the invocation.

Therefore HAL function placement matters. A feedback producer scheduled before `motion-controller` can affect that controller invocation. A producer scheduled after motion cannot be observed by motion until a later invocation. A control function scheduled after motion can consume motion's newly published command in the same HAL-thread pass, relying on H04's within-thread list-order result.

## Runtime verification

Lab `008` / Actions run `34029848545`, job `101477262140`, curriculum SHA `10f187e8...` used the pinned canonical linuxcncrsh simulation where motor command is looped directly into motor feedback and a sampler is scheduled after motion.

Observed:

- motion-command-handler < motion-controller < sampler.0;
- zero sampler overruns;
- 2175 moving samples;
- lagged feedback error exactly zero (`lag_avg=0`, `lag_max=0`);
- same-sample feedback error materially nonzero (`4.16551724138e-06` average);
- joint command equals same-sample motor command (`cmd_avg=0`, `cmd_max=0`).

Thus the canonical loopback's one-controller-invocation phase relation is TEST-CONFIRMED. It is not a universal LinuxCNC latency rule.

## Failure/exception boundaries

- Task holding the command mutex defers command handling; it does not make the realtime function block.
- Inactive joints skip relevant paths.
- Homing index search deliberately breaks the ordinary motor-feedback-to-joint-feedback formula.
- Extra joints have a distinct output path.
- Fault, limit, homing, kinematics, teleop/free/coordinated, and planner states can alter command evolution.
- HAL composition is configuration-defined.
- No M03 evidence establishes realtime deadline compliance, physical I/O timing, Ethernet/FPGA transaction timing, encoder validity, watchdog behavior, or functional safety.

## Durable artifacts

- `guides/M03-servo-period-trace-initial.md`
- `call-flows/M03-one-servo-period.md`
- `lab-jobs/008-m03-servo-cycle-loopback.sh`
- `lab-results/M03-008-servo-cycle-loopback-accepted.md`
- `exams/M03-adversarial-exam.md`
- `exams/M03-adversarial-answer-key.md`

## Promotion queue

- Task-side command mutex hold duration and command-to-echo latency distribution — 2000/R05/T02, HIGH.
- Full coordinated/free/teleop planner and kinematics branch trace — M08/M01/M02 then 2000, HIGH.
- Cross-thread memory visibility/timing when read/write functions occupy different realtime threads — 2000/R02/H04, HIGH.
- Physical hardware read/write transaction timing — HostMot2/hm2_eth/IO critical path, CRITICAL.
- Stale/frozen feedback safety implications — S-series, CRITICAL.
- Stable 2.9.x source/runtime comparison for these exact paths — 2000/version comparison, MEDIUM.

## Graduation sufficiency

M03 is sufficient for the 1000-level objective: a fresh AI can locate where joint feedback enters motion, trace the significant one-invocation ordering to where a new command leaves motion, understand the command-handler synchronization boundary, predict how HAL scheduling changes same-pass dataflow, reproduce the canonical loopback experiment, and avoid turning a configuration-specific one-cycle observation into a universal latency or safety claim.

Next critical-path module: **HM01 — HostMot2 architecture and registration lifecycle**.
