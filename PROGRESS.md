# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **S05 — disagreement/redundancy monitoring patterns** are **GRADUATED** at 1000 level. **S06 — fault injection framework** is now active in **RESEARCH / SOURCE** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

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

### S06 research / source state

S06 has started with `guides/S06-fault-injection-framework-research.md`.

Initial framework findings:

- choose and name the injection layer before implementation: HAL value, publication/freshness, realtime ordering, motion feedback interface, HostMot2 LLIO, transport, or lifecycle/state;
- preserve the production mechanism under test and inject at an explicit boundary;
- predeclare a healthy control, injected fault, independent oracle, harness-invalid criteria, recovery criterion, non-claims, and attempt family;
- `mux2` is a transparent live-versus-fault selector at the pinned source revision;
- `sample_hold` freezes its prior `s32` output while `hold` is true;
- documented `streamer`/`halstreamer` can feed deterministic realtime HAL sequences through a FIFO;
- documented `sampler`/`halsampler` can capture same-cycle realtime evidence for non-realtime analysis;
- S03 provides the below-HAL test-double pattern, S04 the value-path freeze/adversarial-control pattern, and S05 the predeclared threshold/persistence/order pattern;
- an experiment must distinguish evidence that the **fault was injected** from evidence that the **subsystem responded**. A circular oracle is not acceptable.

No strong community source for a canonical LinuxCNC fault-injection framework was found in the initial targeted pass, so S06 is deliberately grounded in official HAL/test primitives, pinned source, and accepted curriculum experiments rather than claiming an upstream framework that is not evidenced.

## Promotion / uncertainty queue — active additions

- S04 device-specific heartbeat/timestamp/sequence semantics: **2000 / HIGH** — stronger freshness evidence is hardware/protocol-specific and does not alter the graduated mismatch-vs-freshness result.
- S04/S05 false-positive/false-negative tradeoffs at zero and very low velocity: **2000 / HIGH** — thresholds require a chosen sensor/process/noise model; no universal threshold is taught.
- S05 physical independence/common-cause diagnostic coverage: **later safety engineering / CRITICAL** — ordinary HAL experiments cannot validate physical independence or safety integrity; the 1000-level module explicitly makes no such claim.
- S05 timing skew between individually valid channels: **2000 / HIGH** for hardware-specific bounds — the generic mechanism is graduated; actual device/bus skew needs architecture-specific evidence.
- `timedelay.elapsed` observability/version behavior: **2000 / LOW** — pinned source can retain a previously published nonzero elapsed value after the internal timer resets. This does not affect S05's boolean persistence conclusion because `timedelay.out` is the state oracle.
- S06 deterministic sequence/freshness source choice (`streamer` versus tiny realtime sequence component): **current / MEDIUM** — resolve before freezing S06-016 because the first framework experiment should not accidentally make userspace scheduler timing the mechanism under test.
- S06 machine-readable laboratory result schema: **current / HIGH** — should be defined before S06 graduation because reusable fault-injection evidence is a central learning objective.

All previously recorded promotion items remain active; consult graduated handoffs and prior history for their full rationale.

## Current checkpoint / exact resume point

Continue **S06 — fault injection framework** from RESEARCH / SOURCE.

1. Finish pinned source inventory for `streamer` / `sampler` and inspect the repository lab runner/artifact schema.
2. Define the reusable experiment-result schema: injected-fault evidence, subsystem-response oracle, healthy/adversarial controls, realtime ordering, recovery, harness-invalid classification, raw trace, exit code, and non-claims.
3. Decide whether S06-016 should use only stock HAL primitives or a tiny realtime sequence+counter component. Prefer stock components unless they make timing/freshness evidence circular or userspace-scheduler-dependent.
4. Freeze S06-016 acceptance gates **before** implementation. Include at least healthy baseline, stuck/frozen value, single-cycle jump, deterministic age/skew case, fault removal/recovery, and an explicit adversarial example of an invalid circular oracle.
5. Only then implement/run the laboratory experiment. Preserve the three-attempt safeguard and do not relabel a HAL-level injection as physical hardware/transport evidence.
