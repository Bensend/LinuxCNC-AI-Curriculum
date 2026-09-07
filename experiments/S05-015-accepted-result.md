# S05-015 — accepted disagreement/voter/persistence result

- Module: S05 — disagreement/redundancy monitoring patterns
- Course level: 1000
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Workflow: `34137614386`, attempt 1
- Source commit: `084c227657dc09dc2962105236a455dc6d674b87`
- Artifact: `linuxcnc-lab-015-s05-disagreement-voter-persistence-34137614386-1`
- Artifact digest: `sha256:c97840e998d47702ef8672f9209a76b6f05fa276f03513c2f4eae48bf02ccb2a`
- Lab exit code: `0`
- Result: **PASS / TEST-CONFIRMED within stated software-lab scope**

## Predeclared prediction reconciliation

The acceptance gates were frozen in `experiments/S05-015-disagreement-voter-persistence-plan.md` before implementation. No gate was weakened after observing the run.

| Gate | Predeclared prediction | Observation | Result |
|---|---|---|---|
| A — equal values | `A=B=1.0` gives `d=0`, inside=true, no raw/persisted fault | `d=0 inside=TRUE under=FALSE over=FALSE raw=FALSE persisted=FALSE` | PASS |
| B — sub-threshold | `d=-0.0625` remains strictly inside ±0.125 | `d=-0.0625 inside=TRUE raw=FALSE persisted=FALSE` | PASS |
| C — exact threshold | `d=-0.125` belongs to fault region | `inside=FALSE under=TRUE over=FALSE raw=TRUE persisted=FALSE` | PASS |
| D — short fault | raw fault before 50 ms on-delay does not persist | raw=true while persisted=false | PASS |
| E — sustained fault | fault held beyond on-delay asserts persisted fault | `raw=TRUE persisted=TRUE` | PASS |
| F — short recovery | healthy interval shorter than 30 ms off-delay does not clear | `raw=FALSE persisted=TRUE` | PASS |
| G — sustained recovery | healthy state beyond off-delay clears | `raw=FALSE persisted=FALSE` | PASS |
| H — one dissenting voter leg | 2-of-3 output follows majority while dissent stays visible only in raw pins | `(T,T,F)->T`; `(F,F,T)->F` | PASS |
| I — common-mode wrong agreement | synthetic `A=B=42` still reports agreement | `d=0 inside=TRUE raw=FALSE persisted=FALSE` | PASS |
| J — function order | `sum2 -> wcomp -> or2 -> timedelay -> maj3` visible in realtime thread | thread showed functions in exactly that order | PASS |

The deterministic skew analysis also matched the predeclared arithmetic: with `Ts=0.010 s`, `v=20 units/s`, a one-cycle age mismatch gives `v*Ts=0.200 units`, greater than the 0.125 threshold even when both samples are exact at their own acquisition instants.

## Evidence established

**TEST-CONFIRMED at the pinned revision in the hosted userspace realtime lab:**

1. `sum2` configured `+1/-1` can form signed channel disagreement `A-B`.
2. `wcomp(min=-T,max=+T)` treats exact threshold equality as outside the healthy strict interior, so the chosen raw-fault construction is `|A-B| >= T` for symmetric valid bounds.
3. `timedelay.out` rejects short fault excursions and short recovery intervals according to the configured on/off persistence delays.
4. `maj3` masks one dissenting boolean leg in its voted output; the raw input pins must remain available if dissent identity matters.
5. Equal wrong synthetic values remain numerically in agreement because the comparator has no independent truth reference.
6. Realtime function order is an architectural property of the HAL configuration and was visible in the fixture.

## Important observation about `timedelay.elapsed`

The run showed `elapsed=0.05` at the short-boundary sample while `timedelay.out` was still false, and later retained `elapsed=0.03` after recovery. This does not contradict the lesson because the immutable plan deliberately used `timedelay.out`, not `elapsed`, as the persistence-state oracle. The pinned source analysis already showed that `elapsed` is not explicitly republished as zero in the branch where input equals output. Exact `elapsed` observability/version behavior remains a LOW-priority 2000-level item.

## Failure and diagnostic boundaries

The experiment confirms the intended failure-domain distinctions rather than erasing them:

- **single-channel disagreement:** can be detected when it exceeds the configured numerical/persistence criteria;
- **common-mode equal wrong value:** not detected by numerical agreement alone;
- **single dissent in 2-of-3:** functional vote may remain with the majority while the vote itself loses dissent identity;
- **two bad/common-cause voter legs:** not prevented by majority arithmetic;
- **timing skew:** can create a false disagreement when channel ages differ during motion.

## Safety boundary / non-claims

This PASS does **not** establish sensor independence, independent power/cabling, controller redundancy, diagnostic coverage, fault exclusion, safe failure fraction, PL/SIL/category, STO integrity, stopping performance, or validation of any complete safety function. These are ordinary LinuxCNC HAL comparison/voting/persistence semantics in a software laboratory.

## Prediction-check conclusion

The predeclared central prediction matched independent runtime evidence without post-hoc gate changes. The experiment therefore satisfies the S05 independent-verification and prediction-check requirements for 1000-level graduation, subject to exam, corrections, handoff, and promotion audit.