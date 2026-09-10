# X02-001 preflight attempt 1 reconciliation

Session start marker: `2026-09-10T09:13:11Z`.

## Provenance

- Frozen behavioral contract: `experiments/X02-001-multi-surface-generation-correlation-plan.md`, frozen at `903036d31e8c1e4d114cf43878c96a4e789744d7`.
- Preflight source commit: `6eb541572e33168dac3e4eb67df3b01a62c02e85`.
- Workflow: `34454522362`, job `102797694203`, retained artifact `10143051352`.
- Job runtime: 2026-09-10T08:19:20Z–08:24:03Z = 283 s = 4.72 min. Inner lab: 08:19:24Z–08:23:55Z.

## Classification: HARNESS / SETUP-ORDER FAILURE

The workflow failed in the independent recorder-integrity scorer on `payload cycle discontinuity`; this is not X02 behavioral evidence.

The retained raw recorder evidence explains the failure. `recorder-health.txt` reports `overruns-before=0` but `depth-before=11`, proving the FIFO already contained setup-time records before the explicit measurement enable. The beginning of `realtime.samples` is `0 0 0`, `1 0 0`, `2 0 0`, `3 6 0` ... and later jumps from payload cycle 13 to 37 while stream tags remain contiguous. The source witness was still executing while sampler enable/setup commands were being issued.

Root cause in harness 053: `sampler.0` was added to the already-running `servo-thread` before `sampler.0.enable` was set to 0. Therefore setup-time samples entered the FIFO before the intended P0–P4 measurement interval. Zero producer overruns do not rescue those rows: the contamination is caused by unintended recording while setup proceeds, not FIFO loss.

## Correction

Attempt 2 uses `lab-jobs/054-x02-001-multi-surface-preflight-enable-order-fix.sh`. It changes only setup ordering: after `loadrt sampler`, set `sampler.0.enable 0` **before** `addf sampler.0 servo-thread`. P0–P4, polling rates, retained row count, fields, behavioral predictions, and frozen Gates A–J are unchanged.

Commit `08bfb98c411d6d51abb6c72a6992dcb94ea2d290` launched workflow `34459587342`.

## Exact next checkpoint

Inspect workflow `34459587342` and its retained artifact only. First require `depth-before=0`, 20,000 retained rows, zero producer overruns, contiguous stream tags, and +1 deterministic payload continuity. Only then score the already-frozen preflight predicates. If valid, launch a separate unchanged authoritative X02-001 run. If invalid, classify the defect without retuning behavioral phases/rates/gates.