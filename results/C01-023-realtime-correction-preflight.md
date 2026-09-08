# C01-023 realtime-correction preflight reconciliation

## Disposition

**HARNESS INVALID / implementation preflight — no LinuxCNC behavioral evidence.**

This run is not counted as C01-023 behavioral attempt 2. The frozen Gates A-H remain unchanged.

## Run identity

- workflow: `34209095831`
- job: `102005554568`
- artifact: `10049047409`
- triggering curriculum commit: `6e7139202a5c89360c35d879f5b571ca51584d76`
- intended pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- result: workflow failure; inner lab exit `1`

## What happened

The first implementation of the realtime-sampler correction contained a shell variable typo in a redundant checkout assertion:

```bash
[[ "$ACTUAL_COMMIT" == "$LINUXC_COMMIT" ]] ...
```

The harness runs with `set -u`, so the undefined `LINUXC_COMMIT` terminates the script immediately after cloning/checking out LinuxCNC. The log prints the expected checked-out SHA, but the build, LinuxCNC runtime, realtime sampler, coordinated move, behavioral comparisons, and Gate H cleanup sequence never execute.

Therefore this run cannot support either PASS or FAIL for any behavioral prediction. It is an implementation/preflight failure only.

## Correction

Commit `5b2309fb33e0a39b56f1cb7ea61b113cfacd95ae` removes the bad assertion while retaining the correct pinned-SHA guard:

```bash
[[ "$ACTUAL_COMMIT" == "$LINUXCNC_COMMIT" ]] || { ...; exit 20; }
```

The subsequent workflow is the candidate behavioral run for the same-cycle observation correction.

## Integrity rule

This failed preflight is retained rather than hidden. Its compute cost should be included when the laboratory compute ledger is next backfilled, but it must not be described as a failed LinuxCNC experiment because LinuxCNC behavior under test was never reached.
