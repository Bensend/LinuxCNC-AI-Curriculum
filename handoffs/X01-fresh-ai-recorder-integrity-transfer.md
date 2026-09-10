# X01 fresh-AI handoff — recorder integrity transfer

Status: **PREPARED / UNSCORED — INFORMATION-SEPARATED EVALUATOR REQUIRED**  
Course level: 2000

The learner that authored/reconciled X01 must **not** answer or score this handoff. Give the scenario to a genuinely fresh AI together with only the allowed artifacts below and the referenced pinned LinuxCNC source. Record the fresh response and independent score separately.

## Allowed artifacts

- `guides/X01-recorder-perturbation-and-long-duration-retention.md`
- `call-flows/X01-sampler-recording-and-loss-boundary.md`
- `experiments/X01-002-sampler-retention-redesign.md`
- `results/X01-002-authoritative-evidence-review.md`
- pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`, especially:
  - `src/hal/components/sampler.c`
  - `src/hal/components/sampler_usr.c`
  - HAL stream implementation/API documentation

Do **not** provide `exams/X01-adversarial-answers-and-score.md` as a substitute for independent reasoning.

## Novel scenario

A LinuxCNC machine records these values in one `sampler` channel at 1 kHz:

- `joint.0.motor-pos-fb`;
- an application-generated monotonic `diagnostic-cycle` value;
- a fault-state bit.

The sampler is configured with FIFO depth 128. `halsampler -t` writes to a userspace logging process that later forwards files over the network.

During a 6-second fault event, the published file contains 5,620 syntactically valid rows. Every retained `-t` prefix is contiguous and there are no printed `overrun` lines. Near the fault transition, `motor-pos-fb` appears to jump by 0.8 mm. The retained diagnostic-cycle values show one jump of 381 counts. A maintenance snapshot taken shortly after the event shows `sampler.0.overruns=379`; `sampler.0.full` is false by then. The logging process was also restarted about 30 seconds later for an unrelated network problem.

The controls engineer says:

> “The `-t` timestamps are continuous, so the recorder did not drop anything. The 0.8 mm jump must have happened in the servo loop or at the encoder.”

### Fresh-AI task

Using only the allowed artifacts/source:

1. Classify which observations are direct recorder-health evidence, which are retained-payload evidence, and which are merely later/contextual observations.
2. Decide whether the engineer's conclusion is justified. Separate what can be concluded about recorder loss, realtime-loop execution, and physical motion.
3. Explain how contiguous `-t` prefixes can coexist with the stated producer-overrun and payload evidence at the tested/pinned X01 model.
4. Trace the relevant producer-full failure path from `sampler.c::sample()` and the userspace tag/output path from `sampler_usr.c::main()`.
5. State what the later logging-process restart can and cannot explain about the six-second event.
6. Propose the minimum additional evidence/capture changes needed before a future trace could support a stronger attribution of a position discontinuity.
7. Identify at least two claims that remain outside X01-2000 even if the recorder evidence is made trustworthy.
8. State whether X01's accepted evidence contract is sufficient as a prerequisite for beginning X02 synchronized multi-surface diagnostic work, and explain any boundary X02 must inherit.

The response must cite exact source symbols/paths for the producer and userspace paths and must explicitly preserve uncertainty where the evidence cannot distinguish recorder, scheduler/control, and physical phenomena.

## Independent evaluation requirement

The evaluator should score whether the fresh response transfers the mechanism rather than parroting phrases. A passing response must, at minimum:

- reject clean `-t` continuity as sufficient proof of producer integrity;
- use producer-overrun + deterministic payload discontinuity as evidence of missing recorder coverage in this scenario;
- refuse to convert recorder loss into proof of a realtime loop skip or physical position jump;
- correctly locate `sampler.c::sample()` and `sampler_usr.c::main()` in distinct execution contexts;
- distinguish an event-time recorder-loss mechanism from a later reader/network process restart unless evidence links them;
- preserve provenance, thread order, producer health, payload witness and bounded reader lifecycle in its proposed capture changes;
- identify at least two valid out-of-scope physical/durability/safety claims; and
- carry the recorder-integrity validity boundary forward into X02.

**No learner-side PASS/FAIL is recorded here.** Graduation remains pending until a genuinely fresh evaluator completes and records this handoff.
