# C02 — PID / integ function and state guide

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Evidence class unless noted: **SOURCE-CONFIRMED**.

## `src/hal/components/pid.c` — `hal_pid_t`

One `hal_pid_t` instance contains the runtime state for one PID loop: its own enable, command, feedback, error, derivative history, integrator state, gains, output, saturation state, previous command/feedback and `error_previous_target` selection. `rtapi_app_main()` allocates an array sized to the requested channel count and calls `export_pid()` independently for each element.

This is the source-level basis for C02's phrase **independent loop state**. Distinct HAL names are not the whole argument; the backing runtime structures are distinct instances.

## `rtapi_app_main()` / `export_pid()`

`rtapi_app_main()` accepts either `num_chan=` or `names=`, allocates one `hal_pid_t` per loop, and invokes `export_pid()` for each instance. `export_pid()` then creates that instance's command, feedback, error, output, enable, gain and limit pins and exports one realtime function `<prefix>.do-pid-calcs` bound to the address of that specific `hal_pid_t`.

Therefore two named functions may be scheduled separately and each function receives only its own instance pointer. Stock PID does not gain peer-loop visibility merely because two instances execute in the same servo thread.

## `calc_pid(void *arg, long period)`

Execution context: realtime HAL function, once each time its exported function is invoked by a HAL thread.

Behaviorally important sequence for C02:

1. Convert thread period to seconds and reciprocal.
2. Read this instance's `enable`.
3. Read this instance's `command` and `feedback` once into locals.
4. Calculate and publish this instance's error.
5. If enabled, update this instance's integrator; if disabled, reset its integrator to zero.
6. Update derivative/history state belonging to this instance.
7. If enabled, calculate this instance's output from its own state/gains and apply output limits; if disabled, force output to zero.
8. Publish output and saturation state.

There is no peer PID pointer or peer feedback/error read in this path.

### `error-previous-target` trap

`export_pid()` initializes `<prefix>.error-previous-target` to true. In `calc_pid()`, when that mode is active and not suppressed by an index-enable transition, the published error is `prev_cmd - feedback`, not current `command - feedback`. This is useful for matching motion's following-error convention but makes a naive current-command arithmetic oracle invalid.

C02-024 explicitly sets this pin false on both loops before behavioral evidence. That is a fixture clarification, not a post-result threshold change.

### Disable behavior

When `enable` is false, pinned source resets `error_i` to zero and later forces output to exactly zero. Other state such as the instantaneous error observation and command/feedback history still has defined update behavior. Consequently:

```text
nonzero error
!= nonzero actuator command
```

and

```text
PID output forced to zero
!= safety-rated actuator isolation
```

The C02 failure phase uses this as an independence oracle only.

## `src/hal/components/integ.comp` — generated per-instance function

`integ.comp` exports per-instance pins `in`, `gain`, `out`, `reset`, `max` and `min`. One invocation reads that instance's current `out`; if reset is asserted it sets output to zero, otherwise it advances:

```text
out += gain * in * fperiod
```

and then applies that instance's limits.

There is no peer-instance read. Two named `integ` instances therefore provide two deterministic, separate simulated plant states when wired to separate PID outputs/feedback signals.

## C02 servo-stage consequence

With the frozen function order:

```text
motion-controller
PID A
PID B
plant A
plant B
sampler
```

each PID consumes feedback from the plant state produced by the previous servo invocation, then each plant advances once using the newly calculated PID output, and sampler observes the resulting post-plant state. A same-row sampler tuple is simultaneous at the observation point, but `pid.error` in that row reflects pre-plant feedback from earlier in that servo invocation.

This is a **function-stage relationship**, not an observation tear. C02-024 must not demand same-row `command - sampled-post-plant-feedback == sampled-error` unless it accounts for the one-stage timing.

## Failure / safety boundary

Two stock PID instances with two separate feedback paths can disagree while sharing a command. That fact alone does not create a cross-loop comparator, squaring controller, disagreement trip, hydraulic coupling model, or safety-rated anti-racking function. Those mechanisms must be added and verified explicitly in C03 or later work.
