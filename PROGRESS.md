# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **S04 — stale/frozen feedback** are **GRADUATED** at 1000 level. **S05 — disagreement/redundancy monitoring patterns** is now active in **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

### S04 graduation evidence

Authoritative redesigned experiment `34127182365` / source commit `bb0b6ce8e7a630a837079aadb39964d04ea66e66` completed successfully with lab exit code `0` and artifact digest `sha256:83bde681d123949feba28d5a69cd1ef69da642a202750ee285955f164dd00e56`.

The experiment executed both halves of the central S04 prediction in one LinuxCNC/HAL runtime:

- stationary frozen feedback equal to command was observed for **600 sampled servo cycles** with no realtime threshold crossing, no `f-errored`, no joint error, no motion/amp disable, and zero sampler overruns;
- after returning to live loopback, commanded motion was established, feedback was frozen, the stock realtime comparator observed strict `abs(f-error) > f-error-lim`, the following-error diagnostic asserted, ordinary joint/motion enable was removed, and sampler overruns remained zero.

This TEST-CONFIRMS the source-grounded teaching that following error detects command/feedback mismatch rather than generic sample age. An unchanged position value while command is equal and stationary does not prove feedback freshness.

Durable S04 artifacts:

- `call-flows/S04-frozen-feedback-to-following-error.md`
- `experiments/S04-014-feedback-freeze-plan.md`
- `experiments/S04-014-accepted-result.md`
- `exams/S04-adversarial-exam-and-answer-key.md`
- `guides/S04-graduation-audit-and-fresh-ai-handoff.md`

The fresh-AI novel scenario passed: device-owned advancing sample metadata can strengthen ordinary freshness evidence for one channel while numerical agreement alone still cannot establish another channel's freshness. The counterfactual promotion test passed. S04 makes no claim about physical STO, stopping performance, PL/SIL/category, or safety-rated sensor diagnostic coverage.

### S05 source and experiment state

The required documentation/community/source chain is now represented by:

- `guides/S05-disagreement-redundancy-monitoring-research.md`
- `call-flows/S05-disagreement-voting-persistence.md`
- `source-analysis/S05-component-semantics-and-boundaries.md`
- `experiments/S05-015-disagreement-voter-persistence-plan.md`

Pinned stock HAL semantics now traced:

- `sum2.comp`: with gains `+1/-1`, produces signed disagreement `A-B`.
- `wcomp.comp`: `under=(in<=min)`, `over=(in>=max)`, `out=!(under||over)`; exact thresholds are outside the healthy strict interior.
- `maj3.comp`: normal output is true for at least two true inputs; voter output does not expose dissent identity, freshness, quality, or provenance.
- `timedelay.comp`: while input differs from output, an internal timer accumulates realtime `fperiod`; on/off delays qualify assertion and recovery. Its `elapsed` output is not explicitly cleared when input already equals output, so S05 does not use `elapsed==0` as a state oracle.

The chosen two-channel numeric monitor is:

`sensor A/B publication` → `sum2(A-B)` → `wcomp(-T,+T)` → `or2(under,over)` raw disagreement → `timedelay` persistence → diagnostic/status.

Function ordering remains part of the architecture. Acquisition must precede comparison for same-cycle intent; comparison precedes persistence; observers/responses must be placed deliberately. A one-cycle sample-age difference during motion can create apparent disagreement even if each sample is individually correct at its own acquisition instant.

Experiment S05-015 was frozen **before implementation** with binary-exact threshold `T=0.125`, `on-delay=0.050 s`, `off-delay=0.030 s`, and explicit gates for equal values, sub-threshold disagreement, exact-threshold behavior, short versus sustained fault persistence, short versus sustained recovery, one dissenting `maj3` leg, common-mode equal wrong values, and function ordering. A deterministic timing-skew adversarial case uses `Ts=0.010 s`, `v=20 units/s`, giving `0.200 units` apparent one-cycle disagreement > `T`.

Production lab job: `lab-jobs/015-s05-disagreement-voter-persistence.sh`

Authoritative first attempt: workflow **`34137614386`**, source commit **`084c227657dc09dc2962105236a455dc6d674b87`**. It was **in progress** at the latest checkpoint; do not infer PASS from workflow status. Inspect the lab's own `LATEST.exit_code.txt` and artifact/output.

## Promotion / uncertainty queue — active additions

- S04 device-specific heartbeat/timestamp/sequence semantics: **2000 / HIGH** — stronger freshness evidence is hardware/protocol-specific and does not alter the graduated mismatch-vs-freshness result.
- S04/S05 false-positive/false-negative tradeoffs at zero and very low velocity: **S05/S06/2000 / HIGH** — thresholds require a chosen sensor/process/noise model; no universal threshold is taught.
- S05 independence/common-cause assumptions for redundant sensors: **current / CRITICAL** — S05 must make these assumptions explicit before graduation because numerical agreement/voting can hide common-mode failure.
- S05 diagnostic comparison versus safety-rated diagnostic coverage: **later safety engineering / CRITICAL** — no PL/SIL/category claim is made; ordinary HAL experiments cannot validate physical independence or safety integrity.
- S05 timing skew between individually valid channels: **current / HIGH** — source/call-flow and the predeclared adversarial arithmetic now establish the mechanism; preserve it in the exam/handoff and do not overclaim any hardware-specific skew.
- `timedelay.elapsed` observability/version behavior: **2000 / LOW** — pinned source can retain a previously published nonzero elapsed value after the internal timer resets. This does not affect S05's boolean persistence conclusion because `timedelay.out` is the state oracle.

All previously recorded promotion items remain active; consult graduated handoffs and prior history for their full rationale.

## Current checkpoint / exact resume point

Continue **S05** from EXPERIMENT.

1. Inspect workflow `34137614386` and the lab's own exit code/output. Require Gates A–J from `experiments/S05-015-disagreement-voter-persistence-plan.md`; do not weaken acceptance criteria after observing results.
2. If PASS, create an accepted-result artifact that reconciles every gate and explicitly preserves the limits: agreement is not correctness/freshness; majority is not dissent diagnosis; ordinary HAL logic does not establish independence or safety integrity.
3. If HARNESS INVALID or a gate fails, diagnose before rerunning and count materially similar attempts under the three-attempt safeguard.
4. After accepted independent evidence, move to S05 adversarial exam. Include a misleading "two sensors agree so state is safe/correct" premise, a one-cycle skew scenario, a two-bad-leg majority case, threshold-boundary reasoning, and a bounded HAL modification task that preserves raw channels alongside a vote.
5. Perform corrections, fresh-AI novel-scenario handoff, counterfactual promotion test, and graduate S05 only if independence/common-cause and timing-skew boundaries remain explicit.
6. Then activate S06 — fault injection framework according to the dependency graph.
