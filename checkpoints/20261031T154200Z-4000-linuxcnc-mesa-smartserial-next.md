# 2026-10-31 — LinuxCNC-first Mesa Smart Serial source continuation

**4000 ACTIVE / NON-GRADUATED.** Graduated 1000/2000/F02/3000 remain CLOSED; blind independent evaluator OPEN; physical OpenPressBrake G0/G1 HOLD; personnel safety independent; hourly task enabled.

## Completed source work
- [SSERIAL-54](../research/4400_LINUXCNC_SSERIAL_54_MULTI_REMOTE_FAULT_SCAN_EARLY_RETURN_SOURCE_AUDIT_2026-10-31.md): both v2.9.10 and pinned development `hm2_sserial_check_remote_errors` return from the *whole* scan when any preceding remote lacks bit8, potentially hiding later remote errors; [review-only one-line patch](../patches/4000_LINUXCNC_SSERIAL_54_REMOTE_FAULT_SCAN_v2.9.10_REVIEW_ONLY.patch) changes `return 0` to `continue`. Not built/tested/submitted.
- [SSERIAL-55](../research/4400_LINUXCNC_SSERIAL_55_WAIT_MASK_PARAMETER_ACK_FAILURE_SOURCE_AUDIT_2026-10-31.md): stable v2.9.10 DoIt error mask mistakenly compares `1 < index` (dev fixes to `1 << index`); both revisions overwrite state3 error recovery and can mark a parameter written after failed wait. Dev includes explicit FIXME. No runtime proof.
- [SSERIAL-56](../research/4400_LINUXCNC_SSERIAL_56_REAL_8I20_7I77_HAL_ORDER_FRESHNESS_SOURCE_AUDIT_2026-10-31.md): pinned upstream Smithy 5I20/8I20 configuration runs BLDC after HostMot2 write, adding a command publication iteration; channel input read has no transfer-error gate while channel output repack does; source fault counter 10/1/200 threshold strict >; official 2.9 doc pin-name drift; real post-GUI fault/status displays.
- [Practical disconnected 14-case guide](../guides/4000-linuxcnc-mesa-smart-serial-fault-freshness-acceptance-2026-10-31.md) freezes oracles. Source-only; all test cases NOT RUN.

## Next highest-value unblocked work
1. If and **only if** qualified isolated `[self-hosted, openpressbrake]` compute is positively available, implement the tiny two-remote R1/R2/R3 test, capture both pre-patch and post-patch log/return evidence, verify all source pins, and preserve exact job timestamps. Never hosted runners or physical drives.
2. Otherwise investigate another **distinct** LinuxCNC implementation topic: G-code cutter compensation G41/G42 entry and exit geometry, real mill/router CAM postprocessor assumptions, or HostMot2 Smart Serial parameter state-machine correction if a genuinely new evidence gain remains. Avoid re-auditing SSERIAL-54/55 without a test oracle.
3. Check upstream status/version if later source fixes appear. Do not assume this source audit proves an installed 7I77 or 8I20 defect.

## Evidence/compute
SOURCE/DOC-CONFIRMED static and conditional INFERENCE only; TEST-CONFIRMED none. No build, simulation, hardware, evaluation, or Actions compute (hosted/self-hosted 0/0 minutes). LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. The current hourly curriculum is still required and remains enabled.
