# C03 — phase publication and explicit cross-coupling boundary

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Source-level arithmetic

Pinned `sum2.comp` computes each scheduled output as:

```text
out = in0 * gain0 + in1 * gain1 + offset
```

Pinned `scale.comp` computes:

```text
out = in * gain + offset
```

Therefore the C03 fixture is intentionally transparent rather than hiding synchronization behavior in a bespoke component:

```text
D = feedback_B - feedback_A                # sum2, gains -1,+1
C = Kc * D                                 # scale
command_A = base + C                       # sum2, gains +1,+1
command_B = base - C                       # sum2, gains +1,-1
```

With `feedback_A > feedback_B`, `D < 0`. Positive `Kc` then makes `C < 0`, lowering A's command and raising B's command. The frozen Gate-E sign oracle follows directly from those source equations.

## Scheduling boundary

The fixture schedules, in order:

```text
motion command handling
motion controller
D calculation
C scaling
A/B command sums
local PID A/B
plant A/B
sampler
```

The coupler therefore uses feedback available before the two simulated plants advance during that servo invocation; the sampler observes after plant advancement. Exact arithmetic involving the coupler must use the sampled internal `D`/`C` signals (or realtime residuals), not recompute `D` from same-row post-plant feedback and assume those values were the coupler inputs.

## Userspace configuration is not a phase transaction

`halcmd` is a command-line/userspace mechanism for manipulating HAL. Realtime HAL functions are executed by scheduled realtime threads. Two sequential invocations such as:

```text
halcmd sets c03-kc 0.5
halcmd sets c03-phase 3
```

must not be treated as an atomic servo-cycle update. The realtime thread may run between those writes. C03-025 attempt 1 demonstrated exactly why a test phase marker must be regarded as instrumentation with its own publication semantics.

For attempt 2, a new phase is published only after the associated configuration write has been allowed to settle for 20 nominal 1 ms servo periods. The decisive phase then retains its originally frozen >=3 s observation window. This does not filter evidence after the result; it makes the phase label truthfully describe configuration that was already established before the label became visible.

## Control and safety boundary

Even if C03 demonstrates a reduction in disagreement in the deterministic toy plants, the justified conclusion is narrow:

```text
explicit relative-feedback cross-coupling can alter/reduce disagreement
```

It does **not** establish:

```text
physical actuator alignment
stability for arbitrary gains, delays, saturation, compliance or hydraulic interaction
fault tolerance
validated press-brake synchronization performance
safety-rated anti-racking protection
```

A real hydraulic press-brake design must separately address sensor plausibility, asymmetric valve/flow dynamics, pressure/load coupling, saturation, mechanical compliance, stopping behavior, fault detection, homing/squaring, and the machine's safety architecture. C03 is a software-control-topology lesson, not a validated machine-control law.
