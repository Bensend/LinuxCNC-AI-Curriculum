# X01-001 preflight attempt 2 reconciliation

Session start marker: **2026-09-10T00:13:27Z**.

## Verdict

Clean-lineage preflight attempt 2, workflow **34416110919**, is **HARNESS FAIL / NO BEHAVIORAL SCORE**. The retained artifact (`linuxcnc-lab-028-x01-sampler-retention-preflight-array-fix-34416110919-1`, artifact ID `10129220945`, SHA-256 `096809fbe79d438471984826f23dc23eefde237389909950bcd930dc54abd9c2`) shows exit code 1. The local `x01_source` component compiled successfully, but baseline HAL setup stopped before P0-P5 because `x01-source.0.value-0` did not exist.

## Root cause

Attempt 1 corrected the declaration from invalid `value[15]` to valid indexed HALNAME `value-##[15]`. At the pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`, `docs/src/hal/comp.adoc` states that `#` denotes an array item and that hash marks are replaced with a **zero-padded number having the same width as the number of `#` characters**. Therefore `value-##[15]` exports `value-00` through `value-14`, not `value-0` through `value-14`.

The attempt-2 wrapper changed only the declaration and left the generated HAL net/getp references unpadded. The first observed failure is consequently deterministic and local to the harness naming convention:

`/tmp/x01-baseline.hal:7: Pin 'x01-source.0.value-0' does not exist`

This is not recorder-retention, FIFO-overrun, servo-thread, or control-loop evidence.

## Source / call-flow verification

Official `halsampler(1)` documentation describes the intended path as realtime `sampler` -> shared-memory FIFO -> non-realtime `halsampler` -> output file/stdout. It also states that FIFO overwrite is reported as `overrun` and, with `-t`, gaps in sequential sample numbers quantify lost recorder samples. `sampler(9)` separately exposes `curr-depth`, `full`, and `overruns` and defines overruns as attempts to write while the FIFO has no room. These semantics support the frozen X01 distinction: a recorder FIFO loss demonstrates missing retained observations, not by itself a skipped control-loop execution.

## Adversarial classification

- P0-P5: **not reached**.
- Gates A-J: **UNSCORED**.
- Frozen sample counts, FIFO depths, phase order, predicates, and gate definitions: **unchanged**.
- Clean-lineage harness attempt budget: attempt **2/3 consumed**.
- Failure class: deterministic harness pin-name mismatch.

## Correction and next checkpoint

Created `lab-jobs/029-x01-sampler-retention-preflight-pin-name-fix.sh`, which applies only two naming corrections to the frozen preflight harness: valid `value-##[15]` declaration plus zero-padded `value-00..value-14` HAL references. Push commit `45cb4c16b717d85889326467433e115096df4358` automatically launched clean-lineage preflight attempt **3/3** as workflow **34420657736**.

**Next work checkpoint:** inspect only workflow `34420657736` and its retained artifact. If all frozen P0-P5 runtime predicates execute coherently, classify the preflight as validated and launch a separate unchanged authoritative X01 run. If attempt 3 fails, do not silently open a fourth clean-lineage preflight; reconcile the three-attempt ceiling and course rules before any further execution. Gates A-J remain unscored until the authoritative run.
