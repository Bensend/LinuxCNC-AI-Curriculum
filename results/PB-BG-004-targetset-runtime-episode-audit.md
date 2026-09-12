# PB-BG-004 TargetSet-generation / runtime-episode bridge — independent audit

Date: 2026-09-12
Status: TEST-CONFIRMED / frozen Gates A–J 10/10

## Provenance

- frozen experiment: `experiments/PB-BG-004-targetset-runtime-episode-plan.md`
- implementation: `lab-jobs/089-pb-bg-004-targetset-runtime-episode.sh`
- workflow: `34670275431`
- job: `103490218883`
- source commit: `fdb75f88bde3700ccf1306a4d16b9ed7e9843670`
- retained artifact: `10290233358`
- exact Actions job interval: `2026-09-12T03:24:26Z` to `2026-09-12T03:24:35Z` = 9 s = 0.15 min

## Independent retained-state review

Direct inspection of `lab-results/pb-bg-004/records.json` supports every frozen gate:

- **A PASS** — generation 10 plus explicit arm creates episode 1; completion becomes true only while episode 1 / generation 10 is current.
- **B PASS** — TargetSet invalidation clears episode authority and completion, retaining generation 10 only as historical `last_invalidated_gen`.
- **C PASS** — attempted rearm of the same invalidated generation 10 is blocked as `STALE_GENERATION_REARM_BLOCKED`.
- **D PASS** — newer generation 11 without explicit arm remains unauthorized with `ARM_REQUIRED`.
- **E PASS** — explicit arm of generation 11 creates distinct episode 2; episode 1 is not resurrected.
- **F PASS** — ordinary authorization loss clears episode 2 authority/completion and marks generation 11 invalidated.
- **G PASS** — recovery of ordinary authorization does not resume episode 2; even explicit same-generation rearm is blocked after invalidation.
- **H PASS** — reference loss and feedback loss independently revoke episodes bound to fresh generations 12 and 13.
- **I PASS** — a fresh generation 14 creates episode 5 despite the scenario declaring an externally equal numeric target; authority follows generation/episode identity, not numeric coincidence.
- **J PASS** — the retained fixture emits no `limit3`, posthome, motor, hydraulic or safety-authority command.

Frozen Gates A–J: **10/10 PASS**. The predeclared prediction matched observation.

## Adversarial interpretation

`last_invalidated_gen` is intentionally conservative: once a TargetSet generation loses runtime authority, that exact generation cannot be used to create a new episode. A production implementation could choose a different explicit reconciliation model, but it must provide equally strong evidence that old target authority cannot silently return after an invalidating event.

The fixture does not model numeric targets at all. It therefore cannot establish the correctness, reachability or physical consequence of a target. It establishes only the bridge from current TargetSet provenance to application-owned runtime authority.

## Sufficiency / next-work decision

PB-BG-004 closes the immediate TargetSet-to-runtime-episode ownership bridge. The chain from imported feature through current TargetSet into a fresh runtime episode now has deterministic invalidation semantics. Further synthetic ownership cases would have diminishing value.

The next useful 3600 work should return to source/community/implementation evidence: operator-facing bend-program workflow and machine-specific target/calibration integration, or another unresolved press-brake domain area from the dependency map. Do not add motor physics or invent a flange-to-X formula merely to extend the simulation chain.

The global 2000-series gate remains the information-separated F02 handoff evaluation and must not be self-scored by this learner.
