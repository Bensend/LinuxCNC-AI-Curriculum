# X01-001 preflight attempt 1 reconciliation

Session start marker: **2026-09-09T23:13:48Z**.

## Run inspected

- Workflow: `34411511393`
- Job: `102666749355`
- Artifact: `10127525026`
- Curriculum source commit: `47f80b386e09f9b2dac904e83ee3820f673bc436`
- Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`
- Actual job runtime: 2026-09-09T22:18:06Z–22:22:01Z = **3.9 min**.
- Lab metadata inner interval: 22:18:09Z–22:21:54Z.

## Classification

**HARNESS DEFECT; behavioral experiment not reached.**

The retained artifact contains the predeclared model, exact LinuxCNC revision and generated component source, but no phase traces. `halcompile.stderr` fails on:

`pin out float value[15];`

with `Array name contains no #: 'value'`.

LinuxCNC comp indexed-pin declarations require an index placeholder in the HAL name. The correction is therefore only:

`pin out float value-##[15];`

The C-side `value(i)` access and downstream generated HAL pin names `value-0` etc. remain consistent with the intended harness. No P0–P5 behavior ran, no Gate A–J may be scored, and the failure supplies no evidence against the frozen recorder model.

## Retry discipline

This is clean-lineage attempt **1/3**, failing before the experiment proper. `lab-jobs/028-x01-sampler-retention-preflight-array-fix.sh` applies only the demonstrated declaration correction to job 027 and leaves all frozen sample counts, FIFO depth, phases, predicates and Gates A–J unchanged. Its commit launches clean-lineage attempt 2.

## Next checkpoint

Inspect the workflow triggered by commit `9b8260b93cc9cbf85b6588818dc9c223a66cc2a5`. If it reaches P0–P5, inspect retained evidence rather than workflow status. If it fails, classify the new failure independently and do not retune the frozen model. If it passes, launch a separate authoritative X01 run unchanged.
