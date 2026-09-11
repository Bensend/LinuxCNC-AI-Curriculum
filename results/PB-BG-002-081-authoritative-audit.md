# PB-BG-002 run 081 — authoritative evidence audit

Status: **TEST-CONFIRMED / FROZEN GATES A–J 10/10**  
Course context: 3600 press-brake preparation; this does not unblock F02 or constitute 3600 graduation.  
Frozen contract: `experiments/PB-BG-002-extra-joint-typed-position-contract.md`  
Pinned LinuxCNC source baseline inherited from frozen contract: `8bf4605ae81042248add031e94c77300406e0413`

## Execution provenance

### First execution — HARNESS INVALID

- Workflow: `34653080261`
- Job: `103439436331`
- Artifact: `10284322257`
- Source commit: `a5864bfa8823c7a5498cebc01a93510f542d3313`
- Lab job: `lab-jobs/081-pb-bg-002-typed-position.sh`
- Harness self-report: A–J 10/10
- Independent disposition: **HARNESS INVALID / NO BEHAVIORAL VERDICT**

Independent inspection found that `seq` restarted whenever the test created a fresh harness for another adversarial case. The frozen contract required one monotonically increasing invocation counter across the retained atomic table. The run was therefore rejected despite its self-reported PASS. No P0–P7 behavior, thresholds, or frozen gates were changed in response.

### Corrected authoritative execution

- Workflow: `34653163036`
- Job: `103439697147`
- Artifact: `10284317276`
- Source commit: `087aff9f2187596ea51d1b574097411755ede321`
- Job execution/check lifetime: `2026-09-11T22:15:12Z` to `2026-09-11T22:15:19Z` (7 s)
- Retained evidence: `lab-results/run-34653163036-1/PB-BG-002-081-invocation-evidence.csv`
- Retained rows: **44**
- Evidence SHA-256: `43b6b8ae6761087166881ce2e06dd761378d755260fb16f61eb507822197e4c8`
- Lab exit code: `0`

The evidence-plumbing correction only made the table-level invocation witness monotonically increase from 1 through 44 and exposed the already-frozen `normal_planner_enabled` witness. Gate D was also made to explicitly test the existing normalized multi-invocation planner progression rather than merely relying on code inspection. The frozen behavior contract and pass criteria were unchanged.

## Independent retained-evidence review

The corrected CSV was inspected independently of the harness summary.

### P0 — pre-home isolation

Row 1 rejects an in-range typed request while unhomed: owner remains `NONE` and no post-home command is effective. Row 2 records the abstract home-complete transition to `IDLE_REFERENCED`, while the old numeric target remains only displayed and does not replay.

### P1 — bounded normal move and completion witness

Rows 3–7 show one accepted target with a normalized planner sequence `0 -> 20 -> 40 -> 60`. Completion remains false while the planner is approaching. At row 6 the planner has reached 60 while feedback remains 50, and completion is still false. Only row 7, with planner and valid feedback both at 60 and healthy authorization/drive state, asserts `typed_move_complete=true`; the owner then returns to `NONE`.

The numeric step and tolerance values are test normalization only. They are not recommended machine speed, acceleration, accuracy, or commissioning values.

### P2 — configured-range adversaries

Rows 8 and 9 reject targets `-1` and `101` against the normalized `[0,100]` test range. Neither acquires an owner or produces an effective post-home command. Row 10 proves the invalid displayed value does not replay. Row 11 requires a new valid request before `TYPED_MOVE` ownership is acquired.

### P3 — authorization loss and stale-target suppression

Rows 12–18 show an active typed move revoked in the same invocation in which `machine_authorized=false` is observed. The state becomes `FAULTED`, owner becomes `NONE`, and the active executable target is cleared. Authorization returning does not restart the move. Recovery passes through `RECONCILE`; after recovery the old numeric display remains visible but does not become an executable request.

### P4 — fault separation

The three independent cases retain distinct causes:

- row 21: `FEEDBACK_INVALID`;
- row 26: `DRIVE_FAULT`;
- row 31: `STALL_SUSPECT`.

Each drops ownership, sets `reconcile_required`, then passes through `RECONCILE` before returning to referenced idle. `STALL_SUSPECT` remains an abstract supervisor input; this experiment does not identify its physical cause or freeze a numeric threshold.

### P5 — false-completion adversaries

Rows 34–38 all keep completion false when any required witness is absent. In particular, row 34 has planner convergence without feedback convergence; row 35 has feedback convergence while planner motion is still incomplete; rows 36–38 revoke/fault rather than complete when authorization, drive health, or feedback validity is absent at apparent geometric convergence.

### P6 — reference loss through recovery

Rows 39–43 fault a typed move, lose `homed` during reconciliation, and finish recovery in `UNREFERENCED`. A later home event returns the abstract state to referenced idle but does not replay the old displayed target. A new request remains required.

### P7 — `limit3.load` bypass trap

Row 44 injects `load_bypass_requested=true` with an otherwise valid typed request. It is rejected before ownership; `load_bypass_used=false` and no successful completion is credited. All ordinary typed-move rows retain `normal_planner_enabled=true` and `load_bypass_used=false`.

## Frozen gate score

| Gate | Result | Evidence conclusion |
|---|---|---|
| A | PASS | No typed motion effective while unhomed. |
| B | PASS | Homing alone does not replay the pre-home request. |
| C | PASS | Only a new, in-range, healthy referenced request acquires typed ownership. |
| D | PASS | Normal planner progress is explicitly multi-invocation; target copy is not completion. |
| E | PASS | Completion requires planner convergence, valid feedback convergence, authorization, drive health and reference validity. |
| F | PASS | Authorization loss revokes the move and the stale target does not replay. |
| G | PASS | Feedback, drive and abstract stall faults remain distinguishable and reconcile-gated. |
| H | PASS | Reference loss through recovery ends unreferenced and prevents stale replay. |
| I | PASS | Out-of-range targets never acquire ownership or become effective post-home commands. |
| J | PASS | Ordinary moves never use the `load` bypass; the bypass trap cannot earn completion. |

**Score: 10/10 PASS. PB-BG-002 is TEST-CONFIRMED under its frozen abstract contract.**

## Adversarial interpretation boundary

This result establishes only the ordinary-control ownership/sequencing contract represented by the retained table. It does **not** establish real stopping distance/time, servo gains, safe velocity/acceleration, encoder mechanical integrity, brake timing, hard-stop survivability, Z1/Z2 collision avoidance, safe homing geometry, a numeric stall threshold, or any functional-safety performance.

It also does not prove that `limit3` alone supplies every production interlock. The architectural conclusion is narrower: for a homed extra-joint backgauge, a separate bounded planner feeding `joint.N.posthome-cmd` can be given a fail-closed typed-target ownership contract, while `limit3.load`-style teleport behavior must remain outside normal typed positioning.

## Sufficiency and next checkpoint

PB-BG-001 and PB-BG-002 together are sufficient for the first-stage operator capability contract: native hold-to-jog plus referenced, range-checked typed absolute positioning with explicit revocation/reconciliation and no stale replay.

The next highest-information work is **backgauge homing/reference and production completion semantics**, not a motor simulation. Trace and compare a real extra-joint homing path and the public Ursviken/open-source backgauge implementation for: home switch/index ownership, post-home coordinate establishment, physical limit handling, feedback/drive fault response during homing, and what the HMI should use as a production-ready `at-position` witness. Freeze another experiment only if source/community evidence leaves a generic sequencing ambiguity worth testing.