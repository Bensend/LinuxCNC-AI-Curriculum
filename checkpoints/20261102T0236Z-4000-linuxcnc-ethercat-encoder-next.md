# 2026-11-02 ~02:36Z — ECAT-ENC-143 encoder reconnect / count-width checkpoint

**LINUXCNC FIRST | 4000 hardware/software implementation + 3200/3100/3400/3500 transfer | NON-GRADUATED.**

## Durable work completed

- [ECAT-ENC-143 pinned source investigation](../research/4400_LINUXCNC_ECAT_ENCODER_143_EL5101_RECONNECT_WRAP_FREQUENCY_SOURCE_AUDIT_2026-11-02.md) compares maintained linuxcnc-ethercat EL5101's 16-bit signed counter and EL5151's 32-bit counter at upstream commit `56515f4aac313551346289d9c227193f50e9602a`. Source traces operational loss, first-sample rebaseline, index latch, WKC/state update cadence and historically inconsistent frequency-scale default/comment.
- [Eight-case disconnected commissioning guide](../guides/3200-3400-4000-linuxcnc-ethercat-el5101-encoder-continuity-preflight-2026-11-02.md) includes exact pin semantics, candidate XML, LinuxCNC 2.9 versus 2.10 `initf` caveat, and expected numeric counter examples. **All new runtime cases NOT RUN**.
- Historical PROGRESS checked for EL5101/EL5151, ECAT-12 already covers general Sync Unit WKC/generation; do not repackage that as new. No compute, hardware, independent evaluation or change to graduation.

## Evidence boundaries

**SOURCE-CONFIRMED:** non-operational read returns with published position unchanged; first recovered read seeds `last_count` and discards offline movement; modulo-16-bit count cannot distinguish >half-range motion; `enc-frequency-scale=0.05` default and contradictory in-code comment; slave operational state check nominal 1 s after startup while domain WKC is sampled each bus cycle. **INFERENCE:** illustrative +500 lost counts and ±16 wrap calculations. **UNKNOWN:** actual encoder movement, physical max speed, Beckhoff device revision, IgH bus timing, installed config, signed narrowing behavior of a tested binary. Do not treat `slave-oper`, WKC or `fresh` alone as a valid position witness.

## Highest-value next checkpoint

1. Check whether a **positively qualified and physically disconnected** runner labeled **both** `[self-hosted, openpressbrake]` exists, without dispatching hosted workflows. If yes, run a bounded fake-PDO EL5101 driver test for guide A–G, **first** confirming harness can isolate driver `proc_read` and HAL pin exports without actual bus. Capture source SHA, compiler/ABI, raw and derived pin traces, test assertions, actual job timestamps, runtime, stdout/stderr and exit code. Do not wire machine actuators.
2. If isolated compute is unavailable, rotate to a distinct **LinuxCNC core** question with meaningful cross-machine implementation impact (e.g. motion `joint.N.f-error` diagnostic state publication vs fault timing, or interpreter/tool-data persistence). **Before naming a new lesson**, search full historical PROGRESS/LESSON_LOG/research and lab-results for same causal mechanism and existing executable evidence. Avoid further unrun EL5101 fixtures.
3. Only if an actual device/installation becomes available: confirm EL5101/EL5151 hardware revision and PDO mapping, counter rate, index behavior, calibrated frequency scale and communication-loss recovery policy. Do not claim physical correctness from static source.
4. Preserve 1000/2000/F02/3000 closed status, blind evaluator separation, independent personnel-safety authority and OpenPressBrake G0/G1 HOLD. Keep recurring hourly curriculum enabled. No new authoritative lab runtime or evaluator result; LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged.

## Compute and overlap

No new GitHub Actions dispatch, hosted/self-hosted compute **0/0 min**, LinuxCNC build, HAL session, EtherCAT simulator, physical machine or independent evaluator. This is source-only work. Previous THREAD-142 checkpoint was ~01:37Z; this session began ~02:34Z; no known same-curriculum overlap. Other automations unknown.
