# X02 fresh-AI transfer — multi-surface diagnostics

Status: **PREPARED / UNSCORED**

Do not let the learner that authored X02 self-score this packet. Use a genuinely information-separated evaluator or fresh learner.

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Allowed learner material

- `call-flows/X02-multi-surface-status-publication.md`
- `call-flows/X02-motion-type-cross-surface-witness.md`
- `research/X02-nml-freshness-community-doc-crosscheck.md`
- `research/X02-generation-witness-adversarial-notes.md`
- `results/X02-001-authoritative-audit-and-sufficiency.md`
- referenced pinned LinuxCNC source

Do not provide `exams/X02-adversarial-answers-and-score.md` as a shortcut to the transfer answers.

## Transfer scenario

A diagnostic collector for a LinuxCNC machine stores three streams:

1. a realtime/HAL sampler row containing a deterministic cycle witness and `motion.motion-type`;
2. a Python status row containing local monotonic time, `taskbeat`, `heartbeat`, and `motion_type`;
3. GUI event timestamps.

During a reported 120 ms “freeze,” the Python collector continues producing rows. Across several rows, GUI and Python monotonic timestamps increase. `taskbeat` repeats for a while, then advances by 1. Motion `heartbeat` repeats longer and later jumps by 37. `motion_type` remains `0` throughout. The HAL sampler reports zero producer overruns and a contiguous deterministic payload witness for the same broad interval, but there is no shared generation identifier between individual HAL and Python rows.

## Questions for the fresh learner

1. Classify what each of the three clocks/witnesses establishes: Python monotonic time, `taskbeat`, and motion `heartbeat`.
2. Does constant `motion_type=0` prove machine-state freshness? Why or why not?
3. What does the later motion-heartbeat jump of 37 establish, and what does it not establish?
4. Is the HAL interval eligible as complete recorder evidence? State the evidence supporting the answer.
5. Can the collector join each Python row to the nearest HAL row and call them “the same control cycle”? Explain precisely.
6. Give the shortest discriminating diagnostic path to separate: repeated Python/NML observation, Task publication progress, motion-status generation progress, recorder loss, realtime execution failure, and physical motion.
7. State one safe engineering conclusion and one overclaim that must be rejected from the scenario.

## Evaluator expectations

A passing fresh learner should independently recover the following mechanisms rather than merely quote phrases:

- consumer observation time is not producer generation time;
- `taskbeat` and motion `heartbeat` belong to different producer loops;
- repeated generation values can coexist with increasing observer time;
- a large generation delta between observations means skipped observations, not automatically skipped producer execution;
- equal state is not freshness evidence;
- an X01-valid realtime recorder interval requires producer-health and deterministic continuity evidence;
- ordered cross-surface state consistency is weaker than same-cycle identity without a shared generation ID;
- realtime execution failure and physical motion each require evidence independent of observer/NML freshness.

Recommended pass threshold: all seven answers materially correct, with no unsafe same-cycle/timestamp or physical-motion inference. Record errors as mechanism, evidence-integrity, generation/observer conflation, or safety-boundary errors rather than simply marking prose quality.

## Graduation rule

Do not mark X02 fully GRADUATED until the fresh learner demonstrates course-level transfer on this or an equivalently novel information-separated scenario. Preserve the score and any correction separately.
