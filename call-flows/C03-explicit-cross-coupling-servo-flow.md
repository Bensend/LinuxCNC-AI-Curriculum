# C03 — explicit cross-coupling servo call flow

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Evidence class: **SOURCE-CONFIRMED topology/arithmetic**, with experiment-specific wiring frozen in C03-025.

## End-to-end signal path

```text
trajectory / motion
    |
    v
joint.1.motor-pos-cmd  (base coordinated Y command)
    |
    +-------------------------+-------------------------+
                              |                         |
feedback A -----------------> sum2 cross-diff <-------- feedback B
                              |  D = -A + B
                              v
                           scale
                         C = Kc * D
                              |
                    +---------+---------+
                    |                   |
                    v                   v
             sum2 command-A       sum2 command-B
             base + C             base - C
                    |                   |
                    v                   v
                 PID A                PID B
                    |                   |
                 effort A            effort B
                    |                   |
                    v                   v
                 plant A              plant B
                    |                   |
                    +--> feedback A    +--> feedback B
```

The explicit new C03 mechanism is the path from **both feedback signals** through relative disagreement and correction into **different per-side commands**. C02 lacked this path: both local PIDs simply consumed the same base command.

## One servo invocation

Frozen C03-025 function order:

```text
motion-command-handler
motion-controller
c03-cross-diff
c03-cross-scale
c03-cmd-a
c03-cmd-b
[realtime arithmetic oracle functions]
c03-pid-a.do-pid-calcs
c03-pid-b.do-pid-calcs
c03-plant-a
c03-plant-b
sampler.0
```

### 1. Motion produces the base command

`motion-controller` updates the joint command for the current servo period. C03 uses the duplicated-Y command only as a common **base** reference; the experimental plants remain outside motion's joint feedback path so a deliberately asymmetric simulated plant does not turn into a motion following-error abort before the control-law comparison can be made.

### 2. `c03-cross-diff`

Pinned `sum2.comp` is stateless. With `gain0=-1` and `gain1=+1`:

```text
D = feedback_B - feedback_A
```

The feedback values are the plant states left from the previous plant invocation because the plants have not yet run in this servo invocation.

### 3. `c03-cross-scale`

Pinned `scale.comp` is also stateless:

```text
C = Kc * D
```

`Kc=0` removes the coupling contribution without changing the rest of the topology. `Kc=0.5` is the frozen experimental coupling condition; it is not a physical-machine tuning recommendation.

### 4. Per-side command sums

Two pinned `sum2` instances create:

```text
command_A = base + C
command_B = base - C
```

For the intended negative-feedback sign, if A is ahead of B then `D < 0` and `C < 0`; therefore A's command is reduced relative to base while B's command is increased.

### 5. Realtime arithmetic oracle

C03-025 also schedules `sum2` instances that calculate residuals from the already-produced HAL signals:

```text
residual_C = C - 0.5*D
residual_A = (command_A - base) - C
residual_B = (command_B - base) + C
```

These residuals are sampled directly. This avoids pretending that six-decimal `halsampler` text values can always be recomputed to a `1e-9` oracle after formatting. It also makes Gate E test the **coupler's own same-stage signals**, rather than post-plant feedback values from later in the servo invocation.

### 6. Local PIDs

PID A and PID B remain the independent C02 instances. Each reads its own corrected command and its own feedback. Nothing in the PID component itself gains peer awareness; the peer information has already been incorporated explicitly into the corrected command before PID execution.

### 7. Plants

Plant A and plant B integrate their respective PID outputs. The experiment keeps A gain `1.0` and changes B to `0.25` for phases 2–4. That is the same asymmetric-plant concept used by C02.

### 8. Sampler observation

`sampler.0` runs after both plant functions. One row therefore contains the cross-coupler signals generated earlier in the invocation and the feedback values after the plants have advanced.

This produces a deliberate staging distinction:

```text
sampled D / C / command_A / command_B
    = values used by this invocation's PIDs

sampled feedback_A / feedback_B
    = plant state after this invocation's plant updates
```

Consequently, `D == sampled_feedback_B - sampled_feedback_A` is **not** a required same-row identity. Gate E instead checks the sampled coupler signals/residuals directly, while Gates D/F/G use post-plant feedback separation as the plant-level outcome metric.

## Failure branches

### Wrong sign

If `D` or one command-sum sign is reversed, the correction can reinforce disagreement. This is a behavioral control-law failure if the topology and observations are valid; it is not a reason to retune a frozen gate after the result.

### Missing/aliased feedback

If both disagreement inputs accidentally use one feedback signal, the experiment no longer tests relative feedback. Named components alone do not prove topology; preserved HAL wiring is required.

### Coupling gain zero

At `Kc=0`, `C` must be zero (within the frozen numerical oracle) and command A/B collapse back to the shared base command. This supplies the within-run uncoupled control condition.

### Sensor fault

A frozen/scaled/jumping feedback can make an explicit coupler command the otherwise healthy side. C03's nominal experiment does not establish fault tolerance; C05 owns deeper feedback-fault injection.

### Saturation / authority

The simple `sum2` + `scale` path has no built-in correction limit. A real design needs explicit authority limits and failure policy. C03's bounded simulation trajectory prevents this omission from being used as a safety claim; limiter/saturation behavior belongs in promoted/downstream work.

## Safety boundary

A successful C03 experiment can show that an explicit feedback-difference correction changes the two local commands and reduces disagreement in one pinned software fixture. It cannot show that a real hydraulic/mechanical tandem machine is aligned, stable over its operating envelope, tolerant of sensor faults, or protected by a safety-rated anti-racking function.
