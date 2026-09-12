# PB-BG-003 run 084 authoritative audit

Date: 2026-09-12
Frozen contract: `experiments/PB-BG-003-episode-at-position-plan.md`
Corrected harness: `lab-jobs/084-pb-bg-003-separated-witnesses.sh`
Workflow: `34664404337`
Job: `103473294403`
Source commit: `681cbc18ac4516dae0ffa3979a5575b6e99ec366`
Artifact: `10288293731`
Retained raw evidence: `lab-results/pb-bg-003-corrected/raw.csv`

## Lineage

Run 083 is retained as **HARNESS INVALID** because it collapsed the frozen reference, ordinary-authorization, drive, feedback and controller/joint-fault witnesses into one generic health input. Run 084 changes only that observability defect: the frozen prediction, P0–P7 scenario semantics and Gates A–J remain unchanged, while the corrected raw CSV retains each synthetic invalidation channel separately.

The test remains a pure software state contract. It does not connect to LinuxCNC/HAL, a drive, encoder, motor, hydraulic system or physical machine.

## Independent raw audit

The retained trace contains exactly 28 rows with strictly monotonic `seq=1..28`.

### Gate A — retained sequence integrity: PASS
`seq` is contiguous 1–28 with no duplicate or missing invocation.

### Gate B — nominal episode 1: PASS
P0 rows 1–2 remain incomplete. Row 3 has active/completed episode 1 and `at_position=1` only after the synthetic completion witness becomes true.

### Gate C — same numeric target reissue creates a new episode: PASS
P1 row 4 requests target 10 again but advances `active_episode` from 1 to 2, clears completion identity and keeps `at_position=0` despite unchanged numeric target.

### Gate D — fresh completion belongs to episode 2: PASS
P1 row 6 has completed episode 2 and `at_position=1`; completion was not inherited from episode 1.

### Gate E — reference loss/regain does not resurrect: PASS
P2 row 7 drops only `reference_valid`, invalidates episode 2 and latches reconciliation. Row 8 restores `reference_valid` while all other validity columns are healthy, but the episode remains invalid, reconciliation remains required and `at_position=0`.

### Gate F — reconcile alone does not resurrect: PASS
P3 row 9 performs reconciliation and clears the reconciliation latch while leaving episode 2 invalid and incomplete. Row 10 explicitly authorizes target 12 as episode 3; row 11 supplies fresh completion and asserts `at_position=1` for episode 3.

### Gate G — drive fault revocation and raw recovery: PASS
P4 row 12 drops only `drive_valid`, revoking completion and latching reconciliation. Row 13 restores drive validity but leaves episode 3 invalid and `at_position=0`.

### Gate H — transient feedback invalidation remains visible: PASS
P5 row 17 drops only `feedback_valid` for one invocation and invalidates episode 4. Row 18 restores the raw feedback-validity input, yet episode validity remains false, reconciliation remains latched and `at_position=0`.

### Gate I — distinct controller-fault and ordinary-authorization paths: PASS
P6 row 22 drops only `controller_fault_clear`; row 23 restores it but does not resurrect episode 5. P7 row 27 drops only `ordinary_authority`; row 28 restores it but does not resurrect episode 6. Both distinct frozen invalidation families therefore reach the same fail-closed episode policy without being observationally collapsed.

### Gate J — no false-positive completion rows: PASS
Every retained row with `at_position=1` (P0/3, P1/6, P3/11, P5/16, P6/21, P7/26) has all five validity inputs true, `completion_ready=1`, `episode_valid=1`, `reconcile_required=0`, and `completed_episode==active_episode`.

## Score

Frozen Gates A–J: **10/10 PASS**.

The predeclared prediction matches the retained evidence for the bounded software state contract: application-owned episode identity prevents the enumerated same-target replay and post-invalidation auto-resume errors, provided the lower-level validity/completion witnesses supplied to the policy are themselves trustworthy.

## Documentation/source reconciliation

The adjacent source/doc audit `research/press-brake-backgauge-extra-joint-feedback-boundary-2026-09-12.md` narrows the meaning of those lower-level witnesses. LinuxCNC extra joints transfer post-home command ownership to `joint.N.posthome-cmd`; documented extra-joint behavior does not make ordinary post-home LinuxCNC motor-feedback/following-error semantics sufficient proof of physical target completion. Therefore PB-BG-003's `completion_ready`/feedback-validity inputs represent coherent independent-controller/commissioning witnesses, not an invented guarantee from LinuxCNC motion.

## Evidence classification and boundary

**TEST-CONFIRMED** only for the deterministic application state/episode policy.

Not established:

- physical encoder truth or independence;
- backgauge mechanical position;
- motor/drive dynamics;
- homing-switch repeatability;
- commissioned position/velocity tolerances;
- diagnostic coverage;
- stopping time/distance;
- functional-safety integrity.

## Sufficiency / next checkpoint

PB-BG-003 is closed for its stated preparation question. Another motor simulation would not add information to this policy result.

The 2000-series critical path remains the genuinely information-separated F02 fresh-AI evaluation; the current learner must not self-score it. While that external gate remains unavailable, the next dependency-safe 3600 backgauge task is to document **bend-program/backgauge sequencing ownership**: how an application should issue an episode-tagged target set to independently controlled extra joints and advance a bend step only from coherent current-episode completion, including interruption/reconciliation behavior. Do not represent extra joints as ordinary coordinated G-code axes unless source/config evidence specifically makes them so.
