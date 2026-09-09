# X01-001 — Sampler retention integrity and recorder perturbation

Status: **FROZEN BEFORE FIRST RUN**  
Course level: **2000**  
LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Determine whether a LinuxCNC diagnostic recorder can distinguish recorder failure from control-state behavior, and quantify recorder execution cost sufficiently to support X02 synchronized diagnostics.

The experiment must retain raw records and recorder-health evidence; workflow success alone is not an oracle.

## Fixture

Use a standalone `halrun` laboratory fixture with one 1 ms realtime thread and deterministic realtime producer signals. Add `sampler.0` after the producer functions so each retained row sees the completed producer state for that invocation.

Minimum recorded fields:

1. deterministic monotonic producer counter;
2. deterministic phase/state ID;
3. one float waveform derived from the counter;
4. one boolean phase marker;
5. producer/fixture timestamp or cycle counter sufficient to verify ordering.

Retain separately:

- exact HAL topology and `show thread` / function order;
- sampler configuration/depth;
- producer-side `sampler.0.overruns`, `curr-depth`, and `full` observations at phase boundaries;
- `halsampler -t` raw output;
- process exit statuses;
- LinuxCNC source revision and repository experiment commit.

## Frozen phases

### P0 — initialization / provenance

Prove exact source revision, realtime thread period, function order, sampler depth and field mapping before behavioral scoring.

### P1 — normally drained baseline

Run at least 2,000 producer cycles while `halsampler -t` drains concurrently. Expect contiguous implicit tags, monotonic producer counter and zero producer overruns.

### P2 — bounded stop-and-drain

Disable sampling or stop the realtime producer first, capture the remaining FIFO depth, then run `halsampler -n <remaining-depth> -t` (or equivalent already-attached bounded reader design) until clean exit. Verify terminal retained producer values reach the known stop boundary without unexplained truncation.

### P3 — forced consumer starvation / FIFO saturation

Use a deliberately small FIFO or deliberately withhold userspace draining long enough to exceed capacity while the deterministic producer continues. Do not change producer logic. Then drain with tags.

Expect:

- producer counter continued to advance;
- `sampler.0.overruns > 0`;
- retained stream sequence exposes loss by discontinuity and/or `overrun` indication after the drain resumes;
- no claim that the underlying producer/control loop itself skipped cycles merely because recorder rows were lost.

### P4 — recorder load comparison

Compare at least two frozen recorder configurations in otherwise identical 1 ms fixtures:

- narrow recorder: minimum X01 fields;
- wider recorder: substantially more HAL fields, still within supported stream limits.

Measure recorder function execution time using the most direct LinuxCNC-supported timing evidence available in the lab (thread/function timing pins or equivalent retained realtime timing evidence). Record max/representative execution cost and any deadline/latency evidence. Do not infer a deadline miss from sample loss, and do not infer zero perturbation from contiguous tags alone.

### P5 — long-retention publication proof

If P1–P4 pass and lab budget remains reasonable, run a bounded longer capture sufficient to exercise sustained drain and artifact publication. It need not consume an hour; duration should be long enough to demonstrate that the artifact remains complete, tags remain auditable and provenance/health files are published together.

## Frozen gates

- **Gate A — provenance:** exact LinuxCNC revision, experiment commit, topology, thread period/order and sampler mapping retained.
- **Gate B — baseline continuity:** P1 implicit stream tags contiguous across the accepted interval.
- **Gate C — baseline producer health:** P1 producer-side sampler overruns exactly zero.
- **Gate D — same-record deterministic integrity:** P1 recorded producer fields obey their known deterministic relationship with no torn-row contradiction.
- **Gate E — stop/drain terminal retention:** P2 retained terminal producer state reaches the known stopped boundary with bounded-reader success.
- **Gate F — forced-loss detection:** P3 produces nonzero producer overrun evidence and consumer-visible record loss evidence.
- **Gate G — recorder/control distinction:** P3 deterministic producer counter continues through recorder loss; analysis does not mislabel lost recorder rows as proven control-loop skips.
- **Gate H — perturbation measurement:** P4 retains quantitative recorder execution-cost/timing evidence for narrow and wide configurations.
- **Gate I — no false non-perturbation claim:** contiguous tags/zero overruns are not accepted as proof that recorder execution cost is zero or irrelevant.
- **Gate J — durable evidence:** raw tagged traces, phase-boundary health evidence, topology/provenance, process statuses and scoring script/output are all retained in the workflow artifact.

## Adversarial checks built into analysis

The scorer must reject these tempting conclusions:

- “No gaps in the file means the recorder did not perturb realtime execution.”
- “An `overrun` line proves the servo thread missed a deadline.”
- “The file ends cleanly, so all samples that existed were drained.”
- “A sample number in a user-visible HAL pin is necessarily the same sequence used by `halsampler -t`.”
- “Two independent userspace recorders with similar timestamps are automatically same-cycle observations.”
- “Workflow success proves the raw diagnostic evidence is complete.”

## Attempt policy

First run is a **non-authoritative preflight** if implementation details are new. Correct only harness defects that prevent the frozen model from being exercised. P0–P5 semantics and Gates A–J remain unchanged.

After no more than three materially similar failures, classify the experiment ESSENTIAL NOW / PROMOTE / DROP per `MASTER_MISSION.md`.

## Acceptance consequence

Passing X01-001 does not graduate X01 by itself. It supplies the independent evidence needed to finish the X01 developer guide, failure analysis, adversarial exam and fresh-AI handoff. Its main dependency consequence is to unblock X02 synchronized multi-surface diagnostics with a recorder-integrity contract grounded in measured behavior.
