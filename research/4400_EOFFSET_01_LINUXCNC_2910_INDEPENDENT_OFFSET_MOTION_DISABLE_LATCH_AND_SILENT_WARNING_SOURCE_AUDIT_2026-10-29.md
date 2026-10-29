# 4400-EOFFSET-01 — External-offset motion, retained state, and a silent disable-warning path
**2026-10-29 | NON-GRADUATED 4400 safety/source study | LinuxCNC v2.9.10 | no lab, no selected machine**

## Safety question and novelty
**Can an operator treat G-code feed hold, disabling an external-offset enable input, or a quiet LinuxCNC log as proof that an independently commanded offset has been removed and the machine is physically safe?** No. The relevant mechanisms are different and the physical machine has not been tested.

The existing [G64/G92 positioning audit](4400_G92_PERSIST_01_LINUXCNC_2910_UNSPECIFIED_AXIS_OFFSET_AND_RESTART_SOURCE_AUDIT_2026-10-28.md), [M67/M68 queued analog audit](4400_ANALOG_QUEUE_01_LINUXCNC_2910_M67_M68_PENDING_REASSERTION_AND_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-28.md), and 2570/2580 safety lessons cover other normal-control command/state boundaries. A direct scan of the full safety index and research plan found no external-offset `eoffset` source trace. This study does **not** reopen graduated 1000/2000 or completed 3000 work.

## Exact evidence (original source, not a runtime test)
- **SOURCE-CONFIRMED, tag `v2.9.10`, blob `c5dbdf908c2b9b46e49601700bcee0a4d692721f`:** [`src/emc/motion/axis.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/axis.c), functions `axis_plan_external_offsets` (approximately lines 460–534), `axis_update_coord_with_bound` (approximately 566–620), `axis_calc_motion` (approximately 655–700), `axis_initialize_external_offsets` (approximately 72–85).
- **SOURCE-CONFIRMED, tag `v2.9.10`, blob `b6e45d590c7d11030654d8f7d13d118f581b6439`:** [`src/emc/motion/control.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c), `emcmotController` (approximately 235–275), `process_inputs` feed-hold scaling (approximately 375–421), `set_operating_mode` machine-on initialization (approximately 890–915), coordinated update (approximately 1325–1360), `eoffset_limited` output (approximately 1555–1567).
- **SOURCE-CONFIRMED, tag `v2.9.10`:** [`src/emc/motion/simple_tp.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/simple_tp.c) shows the disabled planner requests zero velocity, resets `pos_cmd` to current position, and integrates any remaining deceleration. **Disabling is not equivalent to instant zero position.**
- **DOC-CONFIRMED, same tag, blob `9d943f613e1bdd511ecf093d76e6a4eb08ff6f89`:** [original `external-offsets.adoc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/motion/external-offsets.adoc) and [published 2.9 guide](https://linuxcnc.org/docs/2.9/html/motion/external-offsets.html). The guide describes independently planned offset motion, nonzero offset persistence after disabling, abrupt soft-limit clamp and potential following error/lost steps, machine-on reset, and a small-offset design intent.
- **DOC-CONFIRMED:** [`motion(9)` HAL manual](https://linuxcnc.org/docs/2.9/html/man/man9/motion.9.html) distinguishes feed hold for G-code from other motion. Exact local HAL wiring is **UNKNOWN**.
- **Version comparison only:** the retrieved upstream `master` `axis.c` blob `f6dd8d4aef0622c17f1f9dc9041ff5e3db7640e8` still contains the same contradictory disable-warning guard. Master is moving; this is a retrieved blob comparison, not a claim that all releases behave identically.

## Source call flow and non-equivalences
1. In the servo controller, `process_inputs` computes `net_feed_scale` and sets it to zero on a qualifying `feed_hold` input. This is ordinary G-code trajectory control.
2. `get_pos_cmds` separately updates coordinated or teleop trajectory positions. The coordinated branch calls `axis_update_coord_with_bound`, which advances the external-offset `simple_tp`, adds its current offset to the Cartesian command, and bounds the combined command at axis soft limits. Teleop has a distinct external-offset update path.
3. **Later in the same controller cycle**, `axis_plan_external_offsets` samples `eoffset-counts`, computes `delta` against `old_eoffset_counts`, and, if enabled, homed and motion-enabled, accumulates `delta * eoffset-scale` into a **separate requested offset**. This is a source-level scheduling order, not a measured servo latency.
4. The external-offset planner's update is not gated by `net_feed_scale` in the inspected paths. **SOURCE-CONFIRMED structural separation; INFERENCE** a live external-offset input can still command offset motion during an otherwise effective G-code feed hold. The published documentation separately says offsets are not coordinated with G-code. Do not promote this to a physically measured claim.
5. If `eoffset-enable` becomes false, `axis_plan_external_offsets` sets `ext_offset_tp.enable=0` and skips new offset-request accumulation; it **does not zero** the existing `curr_pos`. The disabled simple planner requests zero velocity and decelerates, so even the final retained offset may depend on the state at disable. `eoffset-clear` changes the request toward zero while enabled; it is not an instantaneous independently safety-rated motion stop.
6. A machine-off/machine-on transition calls `axis_initialize_external_offsets` on re-enable, resetting internal offset planner state. The original guide emphasizes maintaining the current machine position through the transition. **Do not equate an internal offset reset with proof of physical position, brake engagement, guard safety, or safe restart.**
7. At a combined soft limit, `axis_update_coord_with_bound` clamps `pcmd_p` to the configured boundary, sets external-offset current velocity to zero and returns a limit indication. The 2.9 documentation explicitly warns this can violate normal deceleration assumptions and cause following errors or lost steps. A software soft limit is not an independent protective stop.

## Distinct source defect: expected warning cannot execute on this branch
Inside the `!eoffset_enable` branch, `axis_plan_external_offsets` first assigns `axis->ext_offset_tp.enable = 0`, then checks:
```c
if (last_eoffset_enable[n]
    && (fabs(*(axis_data->external_offset)) > ext_offset_epsilon)
    && motion_enable_flag
    && axis->ext_offset_tp.enable) {
    /* print "*** External Offset disabled while NON-zero" */
}
```
The final conjunct is **false by the immediately preceding assignment**. Under the inspected v2.9.10 straight-line path, the warning body is unreachable, even if the prior enable was true and the offset nonzero. The same guard was seen in the retrieved newer upstream `master` blob. **SOURCE-CONFIRMED static logic defect, TEST-CONFIRMED none.** Do not infer the absence of a retained offset from the absence of this console warning. This is not a demonstrated physical hazard, and no upstream bug report has been filed.

## Failure-path / adversarial review (paper-only, not a test)
| Situation | Source/documentary basis | What may be falsely assumed | Safer engineering interpretation |
|---|---|---|---|
| G-code feed hold with live offset generator | Feed-hold net scale and offset planner are separate | “All commanded motion is stopped” | Feed hold is an ordinary G-code control. Safety system must independently inhibit hazardous motion; review all offset/jog/drive paths. |
| Disable offset while its request is nonzero | Disabled planner retains position and decelerates; warning unreachable | “Enable off means offset cleared; no alarm means zero” | Show requested and applied offset separately; require explicit deliberate reset/rearm after verification, not just a quiet log. |
| Soft limit reached with an offset | Axis clamp and documented abrupt-stop warning | “Soft limit proves a safe decelerated stop” | Treat software limits as process protection only; design independent safety function and physical stopping means. |
| Machine power cycled with nonzero offset | Planner reinitialized, position maintained per documentation | “Restart proves home, clearance and load holding” | Verify physical trust/clearance and independent safe state before deliberate restart. |
| OpenPressBrake Y1/Y2 or other machine | No as-built `eoffset` config or safety wiring received | “This exact failure is installed” | **UNKNOWN**; require Stage A A–G records before any selected-machine inference. |

## Practical human factors and validation
Make the normal UI label the actual state: **offset REQUESTED**, **offset APPLIED**, **G-code FEED HELD**, **safety PERMITTED** (independent system only), and **physical STOP/HOLD VERIFIED** (qualified witness only). Do not use one green lamp to represent all five. Expose `axis.L.eoffset-request`, `axis.L.eoffset`, `motion.eoffset-active`, `motion.eoffset-limited` in a **diagnostic-only** view; distinguish enable state from offset state. Make the standard offset-off workflow easy and consistent, with explicit safe motion clearing under qualified procedures rather than ad-hoc HAL toggling.

**Paper-only acceptance questions for a fresh reviewer (UNSCORED):** Which state survives disable? Why does a zero feed scale not establish zero external-offset command? What exact predicate makes the console warning unreachable? Which separate authority proves physical safe stop? The answers are in the source links above; these are public study prompts, **not** an independent blind competency evaluation.

**No simulation frozen:** the source resolves the warning-branch reachability and normal-controller separation. Physical response, acceleration, following error and exact installed HAL paths require machine-specific evidence. The local `[self-hosted, openpressbrake]` runner's isolation/access remains unverified; no hosted fallback. If a future *disconnected* lab is justified, predeclare a narrower runtime question and obtain qualified physical isolation before dispatch.

## Evidence boundaries and continuation
**SOURCE-CONFIRMED** v2.9.10 call flow, retained-offset logic, unreachable warning; **DOC-CONFIRMED** published external-offset/soft-limit behavior; **INFERENCE** composite feedhold-plus-live-offset hazard; **TEST-CONFIRMED none**; **COMMUNITY-REPORTED none relied upon**; **UNKNOWN** installed OpenPressBrake offset configuration, safety controller/AKAS, K1/K2/EDM, Y1/Y2 physical stop/hold, guards, isolation, restart, independent evaluator.

No G0/G1 evidence or 2520–25F0 external evaluation was obtained. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation.** No workflows, builds, simulations or physical tests; GitHub-hosted **0 min**, self-hosted **0 min**. `LAB_COMPUTE_LOG.md` and `evaluation/FEEDBACK_SCORE_LOG.md` remain unchanged.
