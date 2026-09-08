# C03-025 — explicit relative-feedback cross-coupling

Status: **FROZEN BEFORE IMPLEMENTATION**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Prerequisite: accepted C02-024 retained-evidence result.

## Objective

Test one explicit, transparent cross-coupling law on the same generic two-loop simulation used to establish C02 independence. Determine whether enabling the coupler materially reduces sustained A/B feedback disagreement under an unchanged B-only plant slowdown, and verify that the correction direction actually opposes the measured disagreement.

This experiment tests a software control topology. It does **not** validate a physical dual-actuator machine or safety-rated anti-racking function.

## Frozen topology

Reuse two separate local loops:

```text
base Y command -> corrected command A -> PID A -> plant A -> feedback A
base Y command -> corrected command B -> PID B -> plant B -> feedback B
```

Add only this explicit coupler ahead of the PIDs:

```text
D = feedback_B - feedback_A
C = Kc * D
command_A = base + C
command_B = base - C
```

Pinned `sum2.comp` and `scale.comp` are sufficient to implement the arithmetic transparently.

Local-loop settings remain fixed during decisive comparison:

- PID A/B: `P=4`, `I=0`, `D=0`;
- `error-previous-target=false` for both;
- plant A gain `1.0`;
- disturbed plant B gain `0.25`;
- coordinated base command: long constant-velocity Y move at 60 in/min so all decisive phases occur during motion.

Cross-coupling gain:

- uncoupled: `Kc=0`;
- coupled: `Kc=0.5`.

## Frozen phase sequence

After runtime provenance/homing/startup and while a sufficiently long coordinated Y move is in progress:

1. **Phase 1 — symmetric baseline:** plant A/B gain `1.0`, `Kc=0`, >= 1 s.
2. **Phase 2 — independent disturbed:** plant A `1.0`, plant B `0.25`, `Kc=0`, >= 3 s.
3. **Phase 3 — same disturbance + cross-coupling:** plant A `1.0`, plant B `0.25`, `Kc=0.5`, >= 3 s.
4. **Phase 4 — coupler removed, disturbance retained:** plant A `1.0`, plant B `0.25`, `Kc=0`, >= 3 s.

The B disturbance and local PID gains may not change between phases 2–4.

## Function order / observation model

Frozen intended servo order:

```text
motion-command-handler
motion-controller
cross-difference
cross-scale
command-A-sum
command-B-sum
PID A
PID B
plant A
plant B
sampler
```

The coupler reads feedback available before the plant updates in that servo invocation. `sampler` runs after the plant updates. Therefore any exact arithmetic oracle involving the disagreement used to create `C` must sample the coupler's own `D` signal rather than recompute it naively from same-row post-plant feedback.

## Realtime evidence fields

The same realtime record must include at least:

- base Y command;
- feedback A;
- feedback B;
- coupler disagreement `D`;
- correction `C`;
- corrected command A;
- corrected command B;
- PID output A;
- PID output B;
- `Kc` or a phase value that unambiguously proves coupling state;
- phase.

Plant-gain changes and configuration are also preserved in stdout/configuration evidence. Full raw sampler output must be durably retained under `lab-results/` so it is included in the workflow artifact/result commit.

## Predeclared prediction

With the toy proportional-loop/integrator-plant model under a 1 in/s ramp:

```text
uncoupled approximate disagreement = 0.75 in
coupled Kc=0.5 approximate disagreement = 0.375 in
```

The runtime need not match those exact numbers. The frozen behavioral prediction is that the final-window absolute disagreement in phase 3 is **materially lower** than phase 2 under the unchanged disturbance, and that removing the coupler in phase 4 causes disagreement to increase again.

## Frozen Gates A–H

### Gate A — provenance and topology

PASS only if:

- running LinuxCNC resolves to the build from pinned SHA `8bf4605ae81042248add031e94c77300406e0413`;
- two separate PID instances and two separate `integ` plant instances exist;
- HAL topology proves separate feedback/output paths;
- the explicit `D -> C -> command_A/B` coupler is shown;
- function ordering is printed/preserved.

### Gate B — observation validity and evidence retention

PASS only if:

- sampler is realtime and scheduled after both plants;
- sample numbers are strictly increasing;
- sampler overruns are zero;
- at least 500 valid rows exist in each decisive phase 2, 3, and 4;
- the complete raw sampler trace and relevant LinuxCNC/sampler logs are durably retained under `lab-results/` and published.

Observation tearing or missing full raw evidence is **HARNESS INVALID**, not a behavioral FAIL.

### Gate C — unchanged disturbance/local-loop comparison

PASS only if preserved configuration/runtime evidence shows:

- plant A gain remains `1.0` in phases 2–4;
- plant B gain remains `0.25` in phases 2–4;
- PID A/B gains remain unchanged;
- only `Kc` changes `0 -> 0.5 -> 0` across phases 2–4.

### Gate D — meaningful uncoupled disagreement

Using the **last 500 valid phase-2 rows**, mean absolute `feedback_A - feedback_B` must exceed `0.30 in`.

This prevents a trivial “improvement” when the uncoupled fixture never develops meaningful disagreement.

### Gate E — correction direction / arithmetic

In at least 200 phase-3 rows with `feedback_A > feedback_B` by more than `0.05 in`:

- sampled coupler `D` must be negative;
- sampled correction `C` must be negative;
- corrected command A must be below the base command;
- corrected command B must be above the base command.

Additionally, sampled `C` must equal `0.5 * D` within `1e-9`, and corrected commands must match `base + C` / `base - C` within `1e-9` for the coupler's own same-stage sampled signals.

If sampler staging makes the latter exact arithmetic unobservable as frozen, classify HARNESS INVALID and correct the observation point rather than widening thresholds.

### Gate F — material disagreement reduction

Let `U` be mean absolute A/B feedback separation over the last 500 phase-2 rows, and `X` the same metric over the last 500 phase-3 rows.

PASS only if:

```text
X <= 0.75 * U
```

No post-result threshold adjustment is allowed. The analytic toy model predicts a stronger reduction (~50%); the 25% minimum reduction leaves room for transient/staging effects while remaining behaviorally meaningful.

### Gate G — reversible effect when coupling is removed

Let `R` be mean absolute A/B feedback separation over the last 500 phase-4 rows.

PASS only if:

- phase-4 `Kc=0` and correction magnitude is <= `1e-12` in the evaluated rows;
- `R >= 1.20 * X`.

This checks that the phase-3 reduction is attributable to the explicit coupling path rather than an unrecorded permanent fixture change.

### Gate H — source reconciliation and safety boundary

PASS only if the result explicitly reconciles runtime observations with pinned `sum2.comp`, `scale.comp`, PID, and `integ` semantics and states all of the following:

```text
reduced simulated disagreement
!= proven physical alignment
!= proven stability across plants/gains/faults
!= validated hydraulic/mechanical control law
!= safety-rated anti-racking protection
```

## Invalid/failure handling

- Wrong sign or increased disagreement with valid observation is a **behavioral FAIL** and must be investigated, not tuned away silently.
- Missing/tearing observation, missing raw trace, wrong topology, failed provenance, or changed disturbance/local PID parameters is **HARNESS INVALID**.
- If three materially similar attempts fail/stall, classify remaining work ESSENTIAL NOW / PROMOTE / DROP before any further rerun.

## Exact implementation checkpoint

Implement one headless C03-025 harness from the accepted C02 fixture, adding only the pinned `sum2`/`scale` coupling path and the frozen phase/evidence machinery above. Execute once, preserve raw evidence regardless of pass/fail, and reconcile Gates A–H before changing anything.
