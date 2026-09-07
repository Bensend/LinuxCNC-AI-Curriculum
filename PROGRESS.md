# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **S06 — fault injection framework** are **GRADUATED** at 1000 level. **S07 — restart/recovery/state integrity** is now the highest-priority unblocked module and is activated in **RESEARCH** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

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

### S05 graduation evidence

Authoritative experiment `34137614386`, source commit `084c227657dc09dc2962105236a455dc6d674b87`, completed with lab exit code `0`. Artifact digest: `sha256:c97840e998d47702ef8672f9209a76b6f05fa276f03513c2f4eae48bf02ccb2a`.

All predeclared S05-015 Gates A–J passed without post-hoc gate changes:

- equal and sub-threshold values remained healthy;
- exact `A-B=-0.125` asserted the selected `wcomp` boundary fault;
- short fault persistence was rejected and sustained fault accepted;
- short healthy recovery did not clear and sustained recovery did;
- `maj3` masked one dissenting leg in the voted result while raw inputs preserved the dissent;
- synthetic `A=B=42` remained numerically healthy, TEST-CONFIRMING that agreement is not correctness;
- HAL thread order showed `sum2 -> wcomp -> or2 -> timedelay -> maj3`;
- deterministic one-cycle skew arithmetic gave `0.200` apparent disagreement at 20 units/s and 10 ms period, above the 0.125 threshold.

The adversarial exam passed. The bounded modification task strengthened one design rule: retain raw channels and dissent diagnostics in parallel with a functional majority vote; do not retain only the vote. The fresh-AI novel scenario combined S04 freshness and S05 common-cause reasoning: two physically separate sensors passing through one stalled publication bridge can agree perfectly while both published values are stale.

The counterfactual promotion test passed. S05 makes no claim about physical channel independence, diagnostic coverage, PL/SIL/category, STO, stopping performance, or validation of a complete safety function.

Durable S05 artifacts:

- `guides/S05-disagreement-redundancy-monitoring-research.md`
- `call-flows/S05-disagreement-voting-persistence.md`
- `source-analysis/S05-component-semantics-and-boundaries.md`
- `experiments/S05-015-disagreement-voter-persistence-plan.md`
- `experiments/S05-015-accepted-result.md`
- `exams/S05-adversarial-exam-and-answer-key.md`
- `guides/S05-graduation-audit-and-fresh-ai-handoff.md`

### S06 graduation evidence

S06 is **GRADUATED** at 1000 level.

Authoritative experiment S06-016, workflow run `34146966388`, fixture source commit `c116c997e39506bb82bbae6cce777bde19015fde`, completed with lab exit code `0`. The job-produced `linuxcnc-ai-fi-v1` result classified the experiment `PASS`.

All frozen Gates A–J passed without post-hoc weakening:

- actual realtime function order was verified before accepting behavior;
- realtime sampler captured all 170 required rows with zero overruns;
- healthy publication remained current and both stock detectors stayed clear;
- a scheduled freeze independently showed healthy sequence advancing while published sequence stayed at 49 through cycle 79, with age growing to 30 cycles; age detection asserted and value mismatch eventually asserted;
- recovery at cycle 80 restored current publication and cleared both detectors;
- cycle 100 produced exactly one +5.0 value jump with current sequence: value detector asserted, age detector stayed clear, and cycle 101 recovered;
- cycles 130–139 published exactly one-cycle-old ramp values/sequence: numeric mismatch remained 0.01 below the 0.05 detector threshold while age mismatch was exactly 1 cycle above the 0.5 threshold, so only the age detector asserted;
- the machine-readable result explicitly rejected the circular proposition that the fixture's own fault-mode bit proves both injection and subsystem response.

Source work established the reusable evidence boundary for `streamer`, `sampler`, HAL stream FIFO semantics, stock comparator behavior, and the curriculum lab runner. A current-documentation versus pinned-source conflict on exported `sampler.N.sample-num` is preserved rather than silently reconciled; S06-016 does not depend on that field.

The adversarial exam passed. A post-result correction records that rounded six-decimal trace text is not a bit-exact floating threshold oracle. The fresh-AI novel scenario established a stronger transfer rule: **freshness metadata has provenance**. A sequence number generated downstream of a frozen source proves downstream publication cadence, not source-measurement freshness.

The counterfactual promotion test passed. S06 explicitly makes no physical sensor, HostMot2/FPGA, transport, diagnostic-coverage, PL/SIL/category, safe-stop, or physical-machine timing claim.

Durable S06 artifacts:

- `guides/S06-fault-injection-framework-research.md`
- `guides/S06-fault-injection-framework-developer-guide.md`
- `source-analysis/S06-streamer-sampler-and-lab-runner.md`
- `forum-findings/S06-documentation-community-reconciliation.md`
- `call-flows/S06-fault-injection-evidence-flow.md`
- `experiments/S06-result-schema-v1.md`
- `experiments/S06-016-framework-fixture-plan.md`
- `experiments/S06-016-accepted-result.md`
- `lab-jobs/016-s06-fault-injection-framework.sh`
- `lab-results/S06-016.result.json`
- `lab-results/S06-016.trace.txt`
- `exams/S06-adversarial-exam-and-answer-key.md`
- `guides/S06-graduation-audit-and-fresh-ai-handoff.md`

## Promotion / uncertainty queue — active additions

- S04 device-specific heartbeat/timestamp/sequence semantics: **2000 / HIGH** — stronger freshness evidence is hardware/protocol-specific and does not alter the graduated mismatch-vs-freshness result.
- S04/S05 false-positive/false-negative tradeoffs at zero and very low velocity: **2000 / HIGH** — thresholds require a chosen sensor/process/noise model; no universal threshold is taught.
- S05 physical independence/common-cause diagnostic coverage: **later safety engineering / CRITICAL** — ordinary HAL experiments cannot validate physical independence or safety integrity; the 1000-level module explicitly makes no such claim.
- S05 timing skew between individually valid channels: **2000 / HIGH** for hardware-specific bounds — the generic mechanism is graduated; actual device/bus skew needs architecture-specific evidence.
- `timedelay.elapsed` observability/version behavior: **2000 / LOW** — pinned source can retain a previously published nonzero elapsed value after the internal timer resets. This does not affect S05's boolean persistence conclusion because `timedelay.out` is the state oracle.
- S06 exported `sampler.N.sample-num` documentation/source conflict: **2000 / LOW** — current docs say it auto-increments while the pinned realtime body does not update the exported field; accepted S06 evidence uses an explicit sampled cycle instead.
- S06 source-origin freshness metadata semantics: **2000 / HIGH** — real timestamp/sequence/heartbeat provenance is device/protocol-specific; S06 teaches the provenance rule and makes no physical freshness claim.
- S06 automatic lab-runner ingestion/indexing of `linuxcnc-ai-fi-v1`: **2000/tooling / MEDIUM** — the schema is proven at job level; automatic runner support is useful but not required for the graduated evidence chain.
- S06 physical fault representativeness and diagnostic coverage: **later safety engineering / CRITICAL** — software injection cannot validate physical fault coverage or safety integrity, and S06 explicitly says so.

All previously recorded promotion items remain active; consult graduated handoffs and prior history for their full rationale.

## Current checkpoint / exact resume point

Begin **S07 — restart/recovery/state integrity** in RESEARCH at pinned revision `8bf4605ae81042248add031e94c77300406e0413`.

1. Establish intended restart/recovery behavior from current official docs and examples: machine enable/disable, estop/reset boundaries, HAL component lifecycle, LinuxCNC process restart, and configuration reload where documented.
2. Search community reports specifically for stale retained state, restart-after-fault traps, homing/state assumptions, HAL teardown/restart issues, and what operators/integrators expect after communication or realtime failures. Treat reports as leads only.
3. Source-inventory `linuxcnc.in` cleanup/startup, `hal_lib.c` component/shared-memory lifecycle, `rtapi_app` teardown/re-init, motion/task state reset/initialization, and any explicit persistent state mechanisms. Trace at least one complete restart path.
4. Define which states are expected to reset, which may intentionally persist outside a process (files/config/device state), and which require re-homing/revalidation rather than assuming software restart restores machine truth.
5. Before any S07 experiment, use the S06 framework: name the lifecycle injection boundary, independently prove old-runtime teardown/new-runtime identity, predeclare retained/reset-state expectations, include a healthy restart control, define HARNESS_INVALID separately from behavioral failure, and never equate process restart with physical-machine recovery.
