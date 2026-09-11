# PB-PREP-001 067/068 harness reconciliation

Date: 2026-09-11

Status: **HARNESS-ONLY RECONCILIATION — NO A/B/C BEHAVIORAL VERDICT**

Pinned LinuxCNC target: `8bf4605ae81042248add031e94c77300406e0413`

## Frozen interpretation boundary

The behavioral contract in `experiments/PB-PREP-001-y1y2-insertion-comparison-plan.md`, `experiments/PB-PREP-001-behavioral-execution-freeze.md`, and `experiments/PB-PREP-001-P2-P7-runner-implementation-contract.md` remains unchanged. In particular, P2–P7 timings/disturbances, A/B/C equations, controller/plant constants, U_MAX/DIFF_MAX, Gates A–J, and the rule `B/P6 downstream-only saturation missing => INCONCLUSIVE` are not retuned from these failures.

## Run 067 — direct 29-element stream

Workflow: `34550104154`
Job: `103111016396`
Source commit: `8ad6ef12d42334959ecbedc9b451154771b3ad4d`
Job interval: `2026-09-11T01:17:57Z` through `2026-09-11T01:22:12Z`
Exact job runtime: **255 s = 4.25 min**
Classification: **HARNESS INVALID**

Pinned-source inspection established `HAL_STREAM_MAX_PINS=21` in `src/hal/hal.h`, while the 067 direct schema requested 29 logical witnesses as 29 physical stream elements. The retained failure (`stream: ERROR: more than 21 items`) is therefore a construction limit, not A/B/C behavior. No behavioral gate is scored from 067.

The earlier conversational estimate of 447 seconds is superseded by the authoritative GitHub Actions job timestamps above. Repository compute accounting must use the exact job interval rather than that estimate.

## Pre-result packed redesign

`experiments/PB-PREP-001-P2-P7-stream-limit-redesign.md` was frozen before inspecting the 067 result. It keeps all 29 logical witnesses but encodes them into 21 physical stream elements using `state_word`, `disturbance_word`, and `ferror_limit_word`. No behavioral parameter was changed.

## Run 068 — packed wrapper construction

Workflow: `34550419067`
Job: `103111965316`
Source commit: `f68d641317a94c6ce42936f933bc808ae423ed02`
Job interval: `2026-09-11T01:22:47Z` through `2026-09-11T01:22:56Z`
Exact job runtime: **9 s = 0.15 min**
Classification: **HARNESS INVALID**

068 never reached LinuxCNC. The outer shell wrapper invoked Python with here-document delimiter `PY`, while the raw analyzer template embedded inside that Python program also contains its own standalone `PY` terminator. The shell therefore terminated the *outer* here-document at the analyzer's inner delimiter. Python received a truncated program and reported:

`SyntaxError: unterminated triple-quoted string literal`

This is a mechanical wrapper-delimiter collision. It does not test the packed-stream representation and provides no behavioral evidence.

## Revision 069 correction

`lab-jobs/069-pb-prep-001-p2-p7-packed-stream-delimiter-fix.sh` changes only the 068 outer patcher's here-document delimiter from `PY` to a unique `PYFIX`, leaving the generated analyzer's own `PY` delimiter intact. Static checks require exactly one `PYFIX` opener/closer and verify that the inner analyzer delimiter was not altered.

## Adversarial integrity notes

- The physical packed schema is exactly 21 elements: 4 s32 + 17 float.
- Packed state bits occupy only bits 0–13 of `state_word`, avoiding signed-s32 ambiguity at the top bit.
- Frozen disturbance values are exactly representable under the specified integer scaling.
- The ferror-limit packing remains valid for this fixture because `[JOINT_1]` and `[JOINT_3]` configure `FERROR=5` and `MIN_FERROR=1`, well inside the unsigned-16 scaled capacity. A valid retained trace should therefore decode positive effective limits no greater than the configured 5-unit maximum; any contradictory decoded value is a harness-integrity problem, not a behavioral result.

## Next acceptance rule

Inspect run 069 only after it completes. First verify pinned provenance, 21-element schema, row counts, producer overruns, deterministic payload continuity, disturbance isolation, decoded ferror-limit range, and A/B/C topology. Only then apply the already-frozen Gates A–J. If B/P6 does not show the downstream-only final-saturation discriminator, classify the otherwise-valid comparison `INCONCLUSIVE`; do not strengthen P6 after seeing the result.

No conclusion from PB-PREP-001 may be promoted into a physical hydraulic suitability or functional-safety recommendation.
