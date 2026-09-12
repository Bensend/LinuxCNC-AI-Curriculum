# 3600 Actuator-Authority / Extra-Joint Adversarial Review — Answers and Score

Date: 2026-09-12
Frozen question commit: `a2a74c8c662c72cef094cdb7a6b6f919fbc04ae7`
Scope: ordinary-control/source review only.

## 1 — PID saturated false vs downstream lock

**Answer:** No. `pid.N.saturated` mirrors the stock PID's internal `limit_state`, which is set by that PID instance's own `maxoutput` clipping. A locked brake, inhibited amplifier, unavailable hydraulic path or later limiter is downstream unless external HAL feeds that state back into PID enable/inputs. The PID can therefore remain unsaturated while physical authority is absent.

**Score:** 1/1.

## 2 — motor command vs authority

**Answer:** No. Pinned `control.c` publishes `joint.N.amp-enable-out` from the joint enable flag, while a homed extra joint separately passes `posthome-cmd + motor_offset` to `motor-pos-cmd`. The command pass-through is not gated by `amp-enable-out`; a command value is not permission to actuate.

**Score:** 1/1.

## 3 — homed extra-joint feedback freeze

**Answer:** Ordinary MOTMOD following-error supervision will not necessarily trip; for a homed extra joint pinned source explicitly sets `joint->ferror = 0` as not relevant. The external post-home controller therefore needs its own tracking/convergence/stall witness using actual feedback, current command/episode provenance and suitable validity/fault logic.

**Score:** 1/1.

## 4 — amplifier-fault call flow

**Answer:** `process_inputs()` reads `joint.N.amp-fault-in` and sets `JOINT_FAULT_FLAG`. `check_for_faults()` sees the fault on an active enabled joint, reports amplifier fault, sets the joint error flag and sets `emcmotInternal->enabling = 0`. `set_operating_mode()` then performs the disable transition, clearing active joint enable flags and motion enable while preserving error cause. Later HAL output publication maps the cleared joint enable flag to `joint.N.amp-enable-out = FALSE`.

**Score:** 1/1.

## 5 — feedback ignored vs unavailable to external logic

**Answer:** No. The documentation statement describes MOTMOD ownership after a homed extra joint transfers to `posthome-cmd`. The encoder/HAL signal can still be routed to a machine-specific external controller or supervisor. What cannot be assumed is that MOTMOD's normal post-home following-error logic is supervising it.

**Score:** 1/1.

## 6 — version trap

**Answer:** The conclusions are not currently pinned-revision-only. On 2026-09-12 the GitHub blob SHA for `src/hal/components/pid.c` was identical between pinned `8bf4605...` and upstream master, and the blob SHA for `src/emc/motion/control.c` was also identical. This proves equivalence at those two source points only; it is not a claim about every historical release or future commit.

**Score:** 1/1.

## 7 — minimum signal separation

**Answer:** Keep at least: (a) TargetSet/current command episode and resulting `posthome-cmd`; (b) LinuxCNC joint authority request / `amp-enable-out`; (c) observed drive/amplifier/brake readiness where the hardware exposes it; (d) actual position feedback plus freshness; (e) external tracking/convergence/stall result; (f) drive/amplifier fault; (g) reference/limit state; and (h) episode-bound completion/at-position. Exact sequencing delays, thresholds and safety behavior are machine-specific and are deliberately omitted.

**Score:** 1/1.

## 8 — ready drive, engaged brake

**Answer:** `amp-fault-in` can remain false, drive-ready can remain true, and stock PID saturation can remain false if its own `maxoutput` is not reached. On a homed extra joint MOTMOD following error is intentionally zeroed. Thus multiple stock/drive witnesses can look healthy while the mechanism does not follow command. Independent tracking/stall/authority supervision is required where the machine architecture depends on detecting that condition.

**Score:** 1/1.

## Result

**8/8 PASS.**

No correction to the new source contracts was required. The review reinforces three non-collapsible distinctions:

1. controller command is not actuator authorization;
2. actuator authorization/request is not proof of physical readiness or motion;
3. homed extra-joint tracking validity is not supplied by ordinary MOTMOD following-error supervision.

No functional-safety claim is made.
