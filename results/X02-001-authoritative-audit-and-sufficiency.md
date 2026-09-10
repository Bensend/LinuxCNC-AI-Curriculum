# X02-001 authoritative evidence audit and sufficiency review

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Frozen contract commit: `903036d31e8c1e4d114cf43878c96a4e789744d7`.

Authoritative wrapper source commit: `717fdd0179006d7b5ee27c6a32a5bd8b39816728`.

Workflow `34465218660`, job `102832088115`, retained artifact `10147333312`.

## Independent artifact audit

The artifact ZIP was downloaded and inspected directly. The nested evidence directory `run-34465218660-1/x02-053-preflight-evidence/` contains the complete retained files, including `realtime.samples` (20,000 rows) and `python-status.csv` (7,046 observations), plus fixture INI/HAL, deterministic component source, topology/pin dumps, Python-member source provenance, LinuxCNC logs, recorder health, predeclared model, and scorer summary.

An initial shallow directory listing showed only the runner logs; a deeper recursive inspection confirmed the complete raw traces are in the nested evidence directory. Therefore no evidence-retention defect remains.

## Provenance and runtime

- GitHub job start: `2026-09-10T10:16:52Z`.
- GitHub job completion: `2026-09-10T10:20:34Z`.
- Actual job runtime: 222 s = **3.70 min**.
- Inner lab metadata: `10:16:54Z` through `10:20:30Z`.
- Pinned checkout file contains exactly `8bf4605ae81042248add031e94c77300406e0413`.
- Artifact digest reported by GitHub: `sha256:f14f826400f2a936d5cc519f8c372036e2d0286fca08fe99f8078f69aadf67f6`.

## Raw-trace checks performed independently

`realtime.samples` was parsed independently of the harness scorer.

- retained rows: **20,000**;
- overrun text markers: **0**;
- stream-tag discontinuities: **0**;
- deterministic payload-cycle discontinuities: **0**;
- first record: stream tag `0`, payload cycle `32`, motion type `0`;
- last record: stream tag `19999`, payload cycle `20031`, motion type `0`;
- recorder health: `overruns-before=0`, `depth-before=0`, `overruns-after=0`, `depth-after-disable=25`, `source-cycle-after=20066`.

The fixed-count reader completed before production was disabled. The remaining depth after disable therefore represents post-count production, not truncation of the fixed 20,000-row authoritative interval; the retained interval itself is contiguous and overrun-free.

`python-status.csv` was also parsed independently.

- observations: **7,046**;
- taskbeat range: **171..10750**, backwards movements: **0**;
- motion-heartbeat range: **523..11817**, backwards movements: **0**;
- P1 fast-idle observations: **5,845**;
- P1 adjacent pairs with increasing observer time and unchanged taskbeat: **4,908**;
- adjacent Python pairs where taskbeat and motion-heartbeat deltas are not one-for-one: **522**;
- adjacent pairs where `motion_type` remains equal while at least one generation witness advances: **2,126**;
- P3 adjacent slow-observer pairs skipping more than one Task and/or motion generation: **93**; examples include task/motion deltas `(47,51)`, `(47,50)`, `(46,49)`;
- ordered nonduplicate Python motion states: `[0,1,0,2,0,1,0,2,0]`;
- ordered nonduplicate realtime/HAL motion states: `[0,1,0,2,0,1,0,2,0]`.

All required P0–P4 phase labels are present.

## Frozen Gates A–J

- **A PASS** — exact LinuxCNC SHA, fixture, periods/rates, topology, Python-member provenance and complete raw artifact inventory are retained.
- **B PASS** — the authoritative 20,000-record realtime interval has zero producer overruns, zero stream/payload discontinuities, fixed-count completion and retained raw evidence.
- **C PASS** — 4,908 P1 adjacent observations advance observer time without advancing taskbeat.
- **D PASS** — taskbeat advances from 171 to 10750 with no backwards movement.
- **E PASS** — 522 adjacent observations demonstrate non-one-to-one Task/motion generation deltas.
- **F PASS** — Python and HAL ordered nonduplicate `motion_type` sequences match exactly in this realization; only ordered/subsequence consistency is claimed.
- **G PASS** — 2,126 adjacent pairs retain equal `motion_type` while a generation witness advances.
- **H PASS** — 93 P3 adjacent slow-observer pairs skip multiple producer generations.
- **I PASS** — no X01-invalid interval is admitted; the accepted X01-002 loss case remains the explicit invalid-recorder counterexample.
- **J PASS** — the analysis uses observer monotonic time only for observer order/time; no nearest-timestamp same-cycle identity is claimed.

**Authoritative frozen-gate result: 10/10 PASS.**

Evidence classification: TEST-CONFIRMED for the bounded pinned software fixture; SOURCE-CONFIRMED remains separately documented for the publication path and member provenance.

## Interpretation

The authoritative run demonstrates that a diagnostic consumer can poll repeatedly without obtaining a newer Task generation, that slow observation naturally skips many producer generations, and that an unchanged state value is not a freshness witness. `taskbeat`, motion heartbeat, and observer monotonic time belong to different layers. The matching motion-state transition order supports cross-surface state consistency but does not create a common generation identity between the HAL sample and Python observation.

## Counterfactual sufficiency review

The central X02 teaching does not depend on assuming a hidden timestamp relationship or on a one-to-one Task/motion cadence. In fact, the experiment directly falsifies those assumptions. Remaining boundaries are explicit: this software-only experiment does not establish physical sensor simultaneity, network/UI latency bounds, safety-rated diagnostics, or a universal latency distribution across platforms/configurations.

If those deferred physical/platform-specific quantities differ from current expectations, the central teaching still holds: use producer-owned generation/health witnesses for freshness, retain recorder-integrity evidence, and do not infer same-cycle identity from equal values or nearest observer timestamps. They therefore do not block 2000-level technical acceptance.

**Technical sufficiency decision: X02 is ACCEPTED at 2000 level, pending the curriculum-required adversarial exam and genuinely fresh-AI handoff before full graduation.**
