# BL-DEV-001 — Blind development baseline learner precommit

- Date: 2026-09-08
- Course level: 1000
- Target competency: HAL realtime execution ordering; stale-data propagation across one servo cycle; diagnostic discrimination between ordering and safety authority
- Bank: development
- LinuxCNC revision under evaluation: `8bf4605ae81042248add031e94c77300406e0413`
- Blind state at commitment: learner has **not** inspected the pinned LinuxCNC implementation or an evaluator answer key for this challenge after selection. The only consulted curriculum artifact was `call-flows/H04-addf-to-thread-dispatch.md`.
- Learner solve start UTC: `2026-09-08T07:14:45.117642609Z`

## Challenge packet exposed to learner

A single LinuxCNC HAL servo thread contains four ordinary realtime functions that communicate through HAL values:

1. `feedback_sample` reads a hardware-facing feedback source and writes `fb`;
2. `fault_guard` reads `fb` and writes advisory `permit`;
3. `control` reads `fb` and `permit` and writes an actuator command;
4. `hardware_write` consumes the actuator command for the hardware-facing write path.

The configuration accidentally schedules them in this order:

```text
control -> fault_guard -> feedback_sample -> hardware_write
```

Immediately before servo cycle N begins, the physical/source feedback changes from healthy to faulted. Assume `feedback_sample` would expose that new fault value when it runs during cycle N. Assume all four functions are in the same HAL thread and no other thread modifies these values.

Predict the cycle-N behavior. In particular:

- Can `control` still execute using prior-cycle `fb` and prior-cycle `permit`?
- Can `hardware_write` later in the same cycle consume a command that `control` computed before the new fault became visible to `fault_guard`?
- What function order is required if the advisory guard is intended to affect `control` in the same servo pass as the fresh sample?
- What would you inspect first to distinguish an ordering bug from a component-logic bug?
- State the safety boundary.

Allowed resources before commitment: learner-readable curriculum artifacts only; no pinned LinuxCNC source, no upstream test/checkresult, and no evaluator oracle.

## Immutable learner response

### Primary prediction / diagnosis

Yes. With the functions scheduled `control -> fault_guard -> feedback_sample -> hardware_write`, cycle N can begin with `control` reading the HAL values left by cycle N-1. The new hardware/source fault does not become a HAL-visible `fb` value until `feedback_sample` runs later in the same sequential thread pass. `fault_guard`, which also runs before `feedback_sample`, likewise evaluates the prior-cycle feedback and can leave `permit` in its previous state for that pass. Therefore `control` can compute a cycle-N command from stale `fb` and stale `permit`.

`hardware_write` runs after those functions, but that does not retroactively recompute `control`. It can consume the command already written by `control` earlier in cycle N, so one servo pass of command based on stale feedback/permit can reach the hardware-facing write path.

### Mechanism believed responsible

Within a single HAL realtime thread, scheduled functions are called sequentially in the thread's function-list/addf order. Ordinary HAL values do not have an automatic end-of-cycle transaction barrier that makes later writes visible retrospectively to functions that already executed. Data dependency therefore has to be reflected in the schedule.

For same-pass propagation, the minimum dependency order is:

```text
feedback_sample -> fault_guard -> control -> hardware_write
```

This allows the sample function to publish the cycle-N feedback before the guard reads it, allows the guard to publish the cycle-N advisory permit before control reads it, and leaves the hardware write after control.

### Expected externally observable result

If the thread can be instrumented per cycle, cycle N should show:

- `control` executes before the new fault is sampled and writes a command consistent with N-1 state;
- `fault_guard` also evaluates N-1 `fb`;
- `feedback_sample` then updates `fb` to the faulted value;
- `hardware_write` still observes the command that `control` produced earlier in that same pass;
- on cycle N+1, absent other behavior, the earlier faulted `fb` is available to `control`/`fault_guard`, although the exact resulting command depends on component logic.

Reordering to `feedback_sample -> fault_guard -> control -> hardware_write` should move the advisory response into the same pass as the fresh sample, subject to the component implementations actually updating their outputs as assumed.

### Diagnostic path

First inspect `halcmd show thread` (or equivalent thread/function listing) to establish the actual function order. Then inspect the signal/pin ownership and values to verify that `feedback_sample` writes the `fb` consumed by `fault_guard`/`control`, and that `fault_guard` writes the `permit` consumed by `control`. If order and connectivity are correct, inspect the component logic and per-cycle observations next. Do not start by blaming the hardware or timing jitter when a deterministic dependency inversion is visible in one thread.

### Plausible alternatives

- A component may internally retain, filter, debounce, or intentionally delay state, so correct thread order alone does not prove same-pass reaction.
- A hardware-facing driver may itself pipeline reads/writes, so the physical age of the value sampled by `feedback_sample` is a separate question from HAL function order.
- If any value is actually produced by another thread, the one-thread deterministic ordering argument is insufficient.

### Falsifier

The primary hypothesis would be falsified if pinned source showed that a single HAL thread does not dispatch functions sequentially in its configured list order, or if it showed transactional/snapshot semantics that cause a later producer's write in cycle N to become visible to an earlier consumer as though it had executed first. It would also be falsified for this concrete scenario if the inspected connectivity showed that `control` does not consume the stated `fb`/`permit` values.

### Confidence

`92%`.

### Safety / uncertainty boundary

The `fault_guard` in this challenge is advisory machine-control logic. Reordering HAL functions can reduce deterministic control latency, but it does not make the guard, LinuxCNC, the PC, the HAL thread, or the hardware write path safety-rated. A hazardous machine must not rely on this software ordering alone for required functional-safety risk reduction.

### Resources actually consulted

- `call-flows/H04-addf-to-thread-dispatch.md`

No pinned LinuxCNC source, hidden answer, checkresult, or post-commit oracle was consulted before this response was committed.
