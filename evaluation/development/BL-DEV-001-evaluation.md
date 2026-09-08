# BL-DEV-001 — Blind development baseline evaluation

- Date: 2026-09-08
- Bank: development
- Course level: 1000
- Target competency: HAL realtime execution ordering and one-cycle stale-data propagation
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Learner precommit: `evaluation/development/BL-DEV-001-precommit.md`
- Immutable learner commit: `2117ac7103f929a0d90b59551785500d2b59b874` at `2026-09-08T07:15:14Z`
- Learner solve start: `2026-09-08T07:14:45.117642609Z`
- Actual solve time to immutable commit: about `0.48 min`
- Learner confidence: `92%`
- Blind validity: **VALID**

## Information-separation audit

Before the learner response was committed, the learner consulted only `call-flows/H04-addf-to-thread-dispatch.md`. The pinned LinuxCNC implementation and post-commit documentation oracle were deliberately withheld until after commit `2117ac7...` existed. No answer key/checkresult or later source inspection was exposed before commitment.

This is a development-bank challenge, not a sealed benchmark. The challenge is a novel dependency-inversion scenario rather than a verbatim question copied from the H04 guide.

## Oracle revealed after commitment

### Pinned source

`src/hal/hal_lib.c`, `thread_task(void *arg)`, pinned revision `8bf4605ae81042248add031e94c77300406e0413`:

- the source describes `thread_task()` as implementing a HAL thread by running down the thread's function list and calling each function in turn;
- the cyclic dispatcher traverses the thread function-list entries and invokes each stored function pointer before advancing to the next entry;
- no mechanism in this dispatch path retroactively re-runs an earlier consumer after a later producer writes a shared HAL value.

`hal_add_funct_to_thread()` is the configuration path that constructs the ordered function-list entries.

The same source file's safety notice explicitly warns against relying on software alone for machinery safety.

### Independent official documentation

Current LinuxCNC HAL documentation states that `addf` places a function into a realtime thread, permits explicit position control, and that ordering is important for some functions. The HAL tutorial states that `show thread` displays functions in the order they will run.

Sources inspected only after the learner commitment:

- LinuxCNC development HAL Basics: `https://linuxcnc.org/docs/devel/html/en/hal/basic-hal.html`
- LinuxCNC HAL Tutorial: `https://linuxcnc.org/docs/html/hal/tutorial.html`
- pinned `src/hal/hal_lib.c` at revision above

## Reconciliation

The learner predicted that with:

```text
control -> fault_guard -> feedback_sample -> hardware_write
```

`control` and `fault_guard` can both consume values left by the prior cycle before `feedback_sample` publishes the new cycle-N fault, and that `hardware_write` can later consume the already-computed command in the same pass. This matches the pinned sequential dispatch mechanism.

The proposed corrective dependency order:

```text
feedback_sample -> fault_guard -> control -> hardware_write
```

is also correct for the assumptions in the challenge: it places each producer before its same-pass consumer. The learner correctly avoided overclaiming that this proves physical data freshness, eliminates component-internal filtering/pipelining, establishes cross-thread order, or creates a safety-rated function.

The diagnostic recommendation to inspect actual thread order first is direct and discriminating for the stated fault.

## Score

| Dimension | Score | Rationale |
|---|---:|---|
| Prediction / diagnosis | 2/2 | Correct cycle-N stale-data diagnosis and hardware-write consequence. |
| Mechanism | 2/2 | Correctly identified sequential same-thread dispatch and producer-before-consumer dependency ordering. |
| Diagnostic efficiency | 2/2 | `show thread` / actual schedule first, then connectivity and component logic, directly separates ordering from implementation faults. |
| Uncertainty / safety boundary | 2/2 | Explicitly separated same-thread order from cross-thread timing, driver pipelining, component filtering, and functional safety. |
| Confidence calibration | 2/2 | 92% is appropriately high for a course-supported prediction later confirmed by pinned source and official docs without claiming certainty about excluded physical/driver details. |

**Total: 10/10.**

## Error classification

None. No learner correction is required from this baseline.

## Curriculum/process action

- Record this as the baseline starting point; do **not** infer a study-method trend from one score.
- Because there was no miss/partial miss, no immediate corrective transfer retest is required by the protocol.
- Schedule a novel retention/development challenge after roughly 10 subsequent lessons or about 24 hours, whichever is more meaningful, while preserving actual delay.
- Keep sealed benchmark challenges untouched for later milestones.

## Baseline interpretation

This challenge supports transfer of the H04 same-thread ordering mechanism into a novel fault-propagation scenario. It does **not** independently validate all graduated architecture, HostMot2, Task/NML, or safety competencies. Subsequent development challenges must sample different mechanisms rather than repeatedly testing function ordering.
