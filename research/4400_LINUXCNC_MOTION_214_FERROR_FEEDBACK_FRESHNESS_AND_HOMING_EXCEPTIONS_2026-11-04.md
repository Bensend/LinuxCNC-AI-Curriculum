# MOTION-214 — Following-error detection is not a feedback freshness monitor

**Status:** NON-GRADUATED; SOURCE-CONFIRMED for LinuxCNC v2.9.10; conditional inference for HostMot2 Ethernet; NOT RUN. No machine authorization.

## Question and decision
MOTION-213 established a conditional stale-HAL-feedback path after recoverable Ethernet read errors. HM2-178/180 already cover watchdog and packet-error behavior; further packet-by-packet restatement has low information gain. This lesson instead asks: **will LinuxCNC's following-error test distinguish stale position feedback from genuine stationary feedback, and which special cases suppress the test?**

## Provenance and source trace
Inspected upstream [LinuxCNC v2.9.10 control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c), blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, `src/emc/motion/control.c`, joint-input loop near lines 437–489. Also [motion.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c), blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`, HAL pin definitions near lines 773–785 and initialization near 927–966. Cross-reference [MOTION-213](4400_LINUXCNC_MOTION_213_READ_FAILURE_STALE_FEEDBACK_WRITE_CONTINUITY_2026-11-04.md), development revision `cdf957bd00bbcc4c569f01e7eed5b154422b816c`; **do not assume identical HostMot2 failure handling between revisions**.

## Exact calculation and exception order
For each active joint, `joint->motor_pos_fb` is copied from `joint.N.motor-pos-fb`. Normally `pos_fb = motor_pos_fb - (backlash_filt + motor_offset)`. During the specific `get_homing_at_index_search_wait(joint_num) && get_index_enable(joint_num)==0` transition, the code instead assigns `pos_fb = pos_cmd` to tolerate the encoder index step change. For a **homed extra joint**, the code sets `ferror=0`; otherwise `ferror=pos_cmd-pos_fb`. It records the absolute-error high-water mark, then computes:

`limit = max(min_ferror, max_ferror * abs(vel_cmd) / vel_limit)` if `vel_limit > 0`; otherwise `limit=min_ferror`.

The flag uses **strict greater-than**: `abs(ferror) > limit`. The subsequent joint-fault path near lines 838–844 reports a following-error fault if the flag is set; HAL exposes `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.f-errored` and `joint.N.error`. Default initialization is `min_ferror=0.01`, `max_ferror=1.0` in internal joint units; real INI settings and units govern an actual configuration.

### Consequences
1. **SOURCE-CONFIRMED:** No sample timestamp, packet sequence number or read-success bit participates in this formula. An unchanged HAL motor-position sample is indistinguishable from a legitimately stationary position at the calculation site.
2. **INFERENCE, conditional:** If a recoverable HostMot2 read misses an update, motion's command continues changing and the old `motor-pos-fb` is held, following error may eventually exceed its velocity-scaled limit. This is an indirect *position discrepancy* detection, **not** a bounded communications-freshness detector. It may not trip during a short outage, when command is stationary, or when the selected feedback source itself tracks generated steps rather than physical movement.
3. **SOURCE-CONFIRMED:** During the index-search completion condition, `pos_fb=pos_cmd` masks following error at that instant even if `motor_pos_fb` changes discontinuously. Homed extra joints set ferror to zero by design. Neither special case should be generalized to ordinary joints.
4. **UNKNOWN:** Exact ordering between a particular LinuxCNC development build's Ethernet receive failure, motion cycle, FPGA watchdog expiration and physical drive response; no measured time bound or safety claim.

## Disconnected arithmetic exercise (NOT RUN)
Assume a conventional active joint, no backlash or offset, `min_ferror=.01`, `max_ferror=1`, `vel_limit=10`, `vel_cmd=2`, so limit is `max(.01,1*2/10)=.2` in configured units. Hold feedback at 5.000 while commands are 5.100, 5.200 and 5.201. Predicted flags: false, false (strict equality), true. If command remains 5.000 and feedback remains 5.000 despite a communication outage, predicted flag remains false indefinitely at this calculation site. These are **mathematical predictions**, not LinuxCNC test results.

## Verification worksheet / falsification
All cases are isolated, no physical machine, no real outputs:
- A: `abs(error)=limit` must not assert `f-errored`.
- B: `abs(error)>limit` must assert `f-errored`; inspect joint-error propagation separately.
- C: `vel_cmd=0` must use the minimum-error floor.
- D: `vel_limit<=0` must use the minimum-error floor (no division).
- E: add nonzero `backlash_filt` and `motor_offset` to show motor-pos-fb differs from pos-fb.
- F: index-search-wait and index-enable=0 forces pos-fb=pos-cmd; vary the enable bit to exit this exception.
- G: homed extra joint sets ferror=0; compare ordinary joint with identical feedback.
- H: freeze motor-pos-fb and move pos-cmd through the threshold; compare a frozen pos-cmd control.
- I: substitute HostMot2 stepgen `position-fb` for an encoder to demonstrate the different physical observability contract, without claiming missed steps were measured.
- J: compare stable v2.9.10 and pinned development control.c before making cross-version assertions.

**No test executed.** An isolated self-hosted `[self-hosted, openpressbrake]` experiment is justified only after freezing a minimal HAL/INI fixture and expected outputs; never use GitHub-hosted Actions.

## Practical integration walkthrough
For a Mesa stepper axis, trace `hm2_*.stepgen.N.position-fb → joint.N.motor-pos-fb` and `joint.N.motor-pos-cmd → hm2_*.stepgen.N.position-cmd` in the actual HAL file. Label this as commanded/generated-step feedback, not independent encoder evidence. For a servo axis, trace the encoder's physical origin and scaling separately. During diagnosis, record `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.f-errored`, `joint.N.motor-pos-fb`, motion command, `hm2_*.packet-error*`, and `hm2_*.io_error` in the same timebase where possible. **Do not infer that a nontripped ferror flag proves fresh feedback.** A physical safety chain remains independent of LinuxCNC's software status.

## Claims ledger
| Claim | Class | Scope | Missing evidence |
|---|---|---|---|
| ferror formula, strict comparison, special cases | SOURCE-CONFIRMED | stable v2.9.10 control.c | runtime fixture |
| HAL diagnostic pins | SOURCE-CONFIRMED | stable v2.9.10 motion.c | machine wiring |
| stale samples can escape ferror threshold | INFERENCE from formula and MOTION-213 | cross-revision conditional | isolated version-matched test |
| watchdog independently guarantees safe outputs | NOT CLAIMED | — | hardware, firmware, wiring and timing evidence |

**Learning-method note:** This rotates from repeatedly analyzing Ethernet branches to a different causal subsystem with a falsifiable cross-layer question. Preserve the boundary between source-confirmed arithmetic and unexecuted transport/physical consequences. Existing graduation, blind evaluation and independent personnel-safety gates remain unchanged.
