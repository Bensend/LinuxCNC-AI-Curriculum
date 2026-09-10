# X01 adversarial exam — answers and score

Exam frozen first in commit `bf17d022dd6dff8b5235bd6614504bce446716b2`. This file answers that already-frozen exam. It is not a fresh-AI handoff and must not be used to self-certify one.

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Answers

### Q1 — clean tags

**No.** Contiguous `halsampler -t` prefixes and no userspace `overrun` text establish only that the sequence returned for the successfully read stream records is contiguous in that capture. X01-002 P3 directly produced producer-side record loss while those tags remained contiguous. A stronger integrity claim must preserve producer health (`sampler.N.overruns`, `full`, relevant FIFO depth/boundary state) and an independent sampled witness capable of exposing missing source cycles where that claim matters. Provenance/thread order and correct reader lifecycle must also be retained so the evidence is interpretable.

Score: **2/2** — critical trap rejected.

### Q2 — realtime producer flow

With `enable` true, `sampler.c::sample()` reads each configured sampler input into a local `hal_stream_data` record and calls `hal_stream_write(&samp->fifo, data)`. On success it clears `full` and refreshes `curr-depth`. On failed write, the source explicitly treats the FIFO as full/data lost, increments `sampler.N.overruns`, sets `full=1`, and reports `curr-depth=maxdepth`. The function's failed recorder write is not itself a thread-stop action.

Score: **2/2**.

### Q3 — `sample-num`

**No.** The equality is not established by the pinned implementation. `sampler_usr.c::main()` obtains `this_sample` from `hal_stream_read(&stream, buf, &this_sample)` and prints `this_sample-1` when `-t` is enabled. `sampler.c::init_sampler()` exports `sampler.N.sample-num`, but inspected `sampler.c::sample()` does not read, increment, or pass that exported pin to construct the userspace tag. Treating the two as the same source would be an unsupported version-sensitive assumption.

Score: **2/2** — critical trap rejected.

### Q4 — P3 inference

The combined evidence proves that attempted recorder records were lost during FIFO saturation: producer overruns are nonzero/full behavior was observed and the deterministic payload jumps 79->286. The continuing deterministic source and the lack of any independent control-loop fault evidence mean this does **not** prove the realtime control loop skipped cycles, and certainly does not prove physical machine motion jumped.

Score: **2/2**.

### Q5 — killed reader

A clean final text row can hide a **userspace drain-lifecycle truncation**: records may remain in the FIFO after the file's last row. A safer terminal capture is: disable sampler production; record the stopped boundary and remaining FIFO depth; run a bounded `halsampler -n <remaining-depth>`; wait for it to complete; then verify depth reaches zero and retain producer-overrun/health evidence plus the terminal payload/boundary comparison.

Score: **2/2** — critical trap rejected.

### Q6 — correlation boundary

One successful `sampler` row snapshots all configured inputs during one invocation of the scheduled realtime function, avoiding the obvious inter-command tearing of two sequential userspace `halcmd getp` calls. It still samples software-visible values in a defined function order, not analog/electrical events at a literally identical physical instant. Producers earlier/later in the realtime thread can change what the sampler sees, so thread order remains part of provenance.

Score: **2/2**.

### Q7 — timing observation

Justified: in this particular readonly/cloud fixture and run, the wide configuration had larger observed `servo-thread.time`/`tmax` values than the narrow configuration, so recorder configuration has measurable timing evidence worth retaining. Overclaims would include (1) asserting a fixed causal per-channel execution penalty from these two observations, or (2) claiming either configuration is guaranteed safe from production-machine deadline misses or causes/does not cause a production timing failure.

Score: **2/2**.

### Q8 — evidence-preserving width change

Add the two values to the recorder configuration and record the new exact topology/thread order. Preserve/check producer `overruns`, `full` and FIFO-depth health; keep an independent monotonic sampled cycle/timing witness; use bounded capture/drain semantics; retain raw records and provenance; and remeasure recorder/thread timing under the wider configuration. A correlation trace must be marked invalid/uncertain for intervals where producer-loss evidence or witness discontinuity means coverage is missing. Clean-looking application values or `-t` prefixes must not override recorder-health evidence.

Score: **2/2** — critical trap rejected.

### Q9 — sustained boundary

Supported claim: this pinned software fixture successfully retained the predeclared bounded 10,000-record narrow capture with contiguous stream ordering and deterministic payload continuity, producer overruns zero and `full=FALSE`. Not established: indefinite lossless logging; filesystem durability after process/OS crash; power-loss durability; safety-rated/event-log retention; physical sensor simultaneity; or production-machine deadline safety. Any three suffice.

Score: **2/2**.

### Q10 — adversarial attribution

First classify recorder integrity: rising `sampler.0.overruns` is direct producer-side evidence that recorder writes were lost; align that with payload witness gaps, FIFO/full state, reader lifecycle and topology. To claim a realtime control-loop skip needs independent execution/deadline evidence—e.g. a trustworthy scheduler/thread-cycle witness or other source not invalidated by the same recorder. To claim physical motion needs still-separate trustworthy sensor/plant evidence with known acquisition integrity and timing.

With only the stated evidence, the safest classification is **retained diagnostic coverage is compromised by recorder loss; apparent position jump is not attributable to control-loop or physical motion**.

Score: **2/2** — critical trap rejected.

## Score

**20/20 — PASS.** All five critical traps passed.

## Corrections triggered by exam

No new central technical correction was required beyond the authoritative X01-002 correction already incorporated into the guide: clean `-t` continuity alone is not a complete producer-integrity oracle. The exam did surface one wording discipline worth preserving downstream: when recorder coverage is compromised, describe an apparent signal jump as **unattributable from this trace** until an independent execution/physical evidence chain exists.

## Graduation boundary

The adversarial-exam requirement is satisfied. The same learner must not perform or score X01's fresh-AI handoff. Remaining X01 graduation work is to prepare the information-separated handoff package, run the counterfactual promotion/sufficiency decision, and obtain a genuinely fresh evaluator result before labeling X01 graduated.
