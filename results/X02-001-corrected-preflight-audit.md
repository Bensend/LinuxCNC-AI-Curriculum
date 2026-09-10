# X02-001 corrected preflight — independent artifact audit

Date: 2026-09-10

Classification: **VALID NON-AUTHORITATIVE PREFLIGHT — Gates A–J 10/10 PASS**

Frozen contract: `experiments/X02-001-multi-surface-generation-correlation-plan.md`, frozen in commit `903036d31e8c1e4d114cf43878c96a4e789744d7`.

Corrected preflight workflow: `34459587342`
Job: `102813964655`
Source commit: `08bfb98c411d6d51abb6c72a6992dcb94ea2d290`
Retained artifact: `10145085665`
Lab metadata start/end: `2026-09-10T09:15:05Z` → `2026-09-10T09:19:00Z` = **235 s / 3.92 min**.
Pinned LinuxCNC commit: `8bf4605ae81042248add031e94c77300406e0413`.

## Why this is attempt 2, not a new behavioral lineage

Attempt 1 (`34454522362`) was recorder-invalid because `sampler.0` became runnable before its default enable state was cleared. Its retained FIFO already contained setup-time records (`depth-before=11`). The only correction in `054-x02-001-multi-surface-preflight-enable-order-fix.sh` disables `sampler.0.enable` **before** `addf sampler.0 servo-thread`. Frozen P0–P4 phases, requested observation rates, witness fields, predictions, and Gates A–J are unchanged.

## Raw-artifact integrity audit

The workflow conclusion was not used as the evidence oracle. The retained ZIP was downloaded and the raw `realtime.samples`, `python-status.csv`, `recorder-health.txt`, readiness/provenance files, and predeclared model were inspected independently.

Recorder facts:

- `depth-before=0`: the setup-order correction eliminated the attempt-1 contamination.
- `overruns-before=0`, `overruns-after=0`.
- `realtime.samples` contains exactly **20,000** retained rows.
- Retained stream tags are exactly contiguous: 0…19,999; zero +1 violations.
- Deterministic realtime payload cycles are exactly contiguous: 26…20,025; zero +1 violations.
- Stop/drain is bounded; `depth-after-disable=19` is drained after realtime production is disabled and does not indicate producer loss.
- The complete ordered realtime `motion_type` transition sequence is `[0, 1, 0, 2, 0, 1, 0, 2, 0]`.

Python facts:

- `python-status.csv` contains **7,351** observations.
- `taskbeat` spans 125…10,804 with **2,145 unique generations** and no backwards movement.
- motion heartbeat spans 306…11,599 with no unexplained bounded-run reversal.
- Python's ordered nonduplicate `motion_type` sequence is exactly `[0, 1, 0, 2, 0, 1, 0, 2, 0]`, matching the realtime sequence.
- P1 fast idle contains **5,203** adjacent same-`taskbeat` repeats while observer monotonic time increases.
- Across the full Python trace there are many non-one-to-one generation-delta combinations. Examples include `(Δtaskbeat, Δmotion heartbeat)=(1,2)` and `(5,6)`, so neither counter is treated as a proxy for the other.
- There are **2,136** adjacent observations where a generation witness advances while `motion_type` remains equal.
- In P3 slow polling there are **93** adjacent pairs with a generation delta >1. Typical deltas are about `(47,50)` and `(48,51)`; observed maxima are Δtaskbeat=48 and Δmotion-heartbeat=51.

## Frozen Gates A–J

| Gate | Result | Independent reason |
|---|---|---|
| A — provenance/readiness | PASS | Exact LinuxCNC SHA, fixture/model, periods, thread topology, selected pins, Python provenance, readiness and raw inventory are retained. |
| B — realtime recorder validity | PASS | 20,000 rows; zero overruns; zero stream-tag gaps; zero deterministic-payload gaps; clean `depth-before=0`; bounded stop/drain. |
| C — same-Task-generation repeat | PASS | 5,203 P1 adjacent pairs have increasing observer time with identical `taskbeat`. |
| D — Task-generation advance | PASS | 2,145 unique `taskbeat` values spanning 125…10,804; no backwards movement. |
| E — motion-generation relationship | PASS | Adjacent observations include unequal counter deltas such as (1,2) and (5,6); motion heartbeat and taskbeat are not treated one-for-one. |
| F — selected-state transition consistency | PASS | Python ordered nonduplicate `motion_type` sequence equals the valid realtime HAL sequence: 0,1,0,2,0,1,0,2,0. |
| G — equal-state/non-freshness | PASS | 2,136 adjacent cases retain equal `motion_type` while taskbeat and/or motion heartbeat advances. |
| H — slow-observer skip | PASS | 93 P3 adjacent pairs skip >1 producer generation; typical deltas are ~47–51. |
| I — invalid-recorder exclusion | PASS | This run admits no recorder-invalid P1–P4 interval. The accepted X01-002 producer-overrun + deterministic-payload-discontinuity artifact remains the explicit P5 counterexample and is excluded from exact correlation by construction. |
| J — no timestamp-simultaneity claim | PASS | No nearest-timestamp join is used. `monotonic_ns` establishes observer ordering/time only; correspondence is stated using generation witnesses and ordered state. |

**Preflight score: 10/10 PASS.**

## Adversarial interpretation check

Several tempting but invalid conclusions are explicitly rejected by this artifact:

1. The 5,203 same-taskbeat fast polls do **not** mean Task stalled; they show the observer can poll the same published generation repeatedly.
2. The 93 slow-observer skips do **not** mean realtime/control cycles were lost; the X01-valid recorder remains contiguous and overrun-free while Python simply observes a sparse subset of generations.
3. Equal `motion_type` values do **not** prove freshness or shared generation; thousands of equal-state pairs have newer generation witnesses.
4. The exact agreement of ordered state transitions does **not** create a shared clock. There is still no common generation ID joining a realtime sample to one Python status object.
5. A green workflow alone would have been insufficient; attempt 1 was a useful counterexample because its setup contamination was visible only in retained recorder evidence.

## Decision and next action

The corrected preflight validly exercises frozen P0–P4 and all Gates A–J without behavioral retuning. It therefore authorizes a **separate unchanged authoritative X02-001 run**. That run must execute the same corrected behavior, retain a distinct artifact, and be independently audited before X02 technical acceptance.