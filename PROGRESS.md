# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **S04 — stale/frozen feedback** are **GRADUATED** at 1000 level. **S05 — disagreement/redundancy monitoring patterns** is now active in **RESEARCH/SOURCE** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

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

### S05 initial research/source state

`guides/S05-disagreement-redundancy-monitoring-research.md` begins the required documentation → community → source chain.

Pinned stock HAL components inspected so far:

- `near.comp`: approximate two-value agreement; relative and absolute tolerance tests are ORed.
- `wcomp.comp`: strict interior window with inclusive `under`/`over` boundaries; undefined if `max <= min`.
- `sum2.comp`: can form signed disagreement `A-B` with gains `+1/-1`.
- `maj3.comp`: boolean 2-of-3 majority voter; voter output alone does not identify the dissenting channel, establish freshness, or exclude common-cause failure.
- `timedelay.comp`: persistence qualification using realtime `fperiod`; intentionally adds detection/recovery delay.

Representative ordinary diagnostic flow under study:

`sensor A + sensor B publication` → `sum2(A-B)` → `abs` or signed bounds → `wcomp`/`near` tolerance → optional `timedelay` persistence → diagnostic latch/status/ordinary response.

Function execution order is part of the design: acquisition must precede comparison for same-cycle intent; comparison precedes persistence; persistence precedes any same-cycle response. S05 must retain raw per-channel observations and health/freshness metadata instead of collapsing everything into a voted result.

Community research reinforces two boundaries without serving as implementation proof: multiple feedback devices can have different control/diagnostic roles, and LinuxCNC/HAL redundancy logic is not automatically a safety-rated redundancy architecture. “Redundancy” must name its failure domain: sensor, cable, controller, communication, or functional-safety architecture.

## Promotion / uncertainty queue — active additions

- S04 device-specific heartbeat/timestamp/sequence semantics: **2000 / HIGH** — stronger freshness evidence is hardware/protocol-specific and does not alter the graduated mismatch-vs-freshness result.
- S04/S05 false-positive/false-negative tradeoffs at zero and very low velocity: **S05/S06/2000 / HIGH** — thresholds require a chosen sensor/process/noise model; no universal threshold is taught.
- S05 independence/common-cause assumptions for redundant sensors: **current / CRITICAL** — S05 must make these assumptions explicit before graduation because numerical agreement/voting can hide common-mode failure.
- S05 diagnostic comparison versus safety-rated diagnostic coverage: **later safety engineering / CRITICAL** — no PL/SIL/category claim is made; ordinary HAL experiments cannot validate physical independence or safety integrity.
- S05 timing skew between individually valid channels: **current / HIGH** — experiment or adversarial analysis should show that acquisition phase difference can create apparent disagreement during motion.

All previously recorded promotion items remain active; consult graduated handoffs and prior history for their full rationale.

## Current checkpoint / exact resume point

Continue **S05** from RESEARCH/SOURCE.

1. Finish a pinned source/call-flow guide for one representative two-channel numeric monitor and one three-channel boolean voter. Preserve exact boundary semantics and realtime `addf` ordering assumptions.
2. Freeze a bounded experiment before implementation. Preferred cases: equal channels; sub-threshold disagreement; exact-threshold boundary; short over-threshold excursion rejected by persistence; sustained excursion accepted; recovery timing; one dissenting input under `maj3`; common-mode identical wrong value still reported as agreement; and a deterministic one-cycle sampling-skew adversarial case.
3. Decide whether `wcomp` on signed difference or `abs + comp` is the clearest primary oracle. Prefer stock production components. Treat `timedelay` as the persistence mechanism if its semantics match the final plan.
4. Do not repeat S04's machine-disable experiment unless needed. S05's independent evidence should primarily verify disagreement/voting/persistence semantics and the limits of agreement as a correctness/freshness claim.
5. After the experiment, perform the adversarial exam, corrections, fresh-AI handoff, counterfactual promotion test, and graduate S05 only if independence/common-cause and timing-skew boundaries are explicit.
