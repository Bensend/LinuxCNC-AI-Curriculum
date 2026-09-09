# D01-004 — Clean retention lineage attempt 2 reconciliation

Date: 2026-09-09 UTC

Status: **RUNTIME + LOCAL RETENTION CHECK PASS / PUBLISHED ARTIFACT RETENTION FAIL**

Workflow: `34362010265`
Job: `102501097837`
Artifact: `10109273124`
Artifact digest: `sha256:67cb26faa474e9a5e0cb4aa80d2ee1906edce4453f28fc7345de45f55f143d3c`
Source commit: `f0cd9efed7cf82f76b300f104decdccf3e4085c6`

Frozen D01-002 P0-P8 and Gates A-J remain unchanged and **UNSCORED**.

## What passed

The corrected clean preflight reached the already-validated real `motmod + trivkins` duplicated-Y runtime fixture and reproduced the planned discriminators without retuning:

- settled principal/duplicate Y commands and feedbacks at `10`;
- low duplicate-only offset `0.020`: duplicate ferror `-0.02`, applicable limit `0.05`, duplicate fault clear, Cartesian-Y observer `10`, motion enabled;
- high duplicate-only offset `0.200`: principal ferror `0`, duplicate ferror `-0.2`, duplicate fault asserted, Cartesian-Y observer `10`, motion disabled;
- fresh explicit re-enable was observed only after cause clear;
- atomic sampler captured `2200` rows;
- `sampler.0.overruns=0`;
- local collector stderr was empty;
- analysis retained phase-before-mutation witnesses and the hidden-low/high-trip windows;
- the job locally inventoried the expected source patch, pinned SHA, INI/HAL, topology/thread, startup logs, samples and recorder-health files.

The local inventory ended with `D01-018 EVIDENCE RETENTION PREFLIGHT PASS`.

## Why the attempt is still harness-invalid

Inspection of the *downloaded GitHub Actions artifact*, rather than only the job's local assertions, found that the workflow artifact contains only the lab-runner wrapper outputs (`LATEST.*` and `run-34362010265-1/{stdout,stderr,metadata,exit_code}`). The actual `lab-results/d01-018-evidence/` directory is absent.

The cause is deterministic: `.github/workflows/lab-runner.yml` uploads only:

```text
lab-results/run-${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT}
lab-results/LATEST.*
```

but D01-018/019 wrote its evidence package to:

```text
lab-results/d01-018-evidence/
```

Therefore the complete trace/config/patch package existed on the ephemeral runner and was locally checked, but was not durably published. Gate J explicitly requires those retained files, and the authoritative run may not be launched on the strength of console inventory alone.

This is an **evidence-publication path defect**, not a LinuxCNC behavioral failure and not a reason to retune `0.020 / 0.200 / 0.050` or alter any frozen gate.

## Three-attempt classification

This is attempt 2 of the clean evidence-retention lineage. One materially similar correction is allowed. The correction must change only publication placement so that the existing evidence directory lands beneath the runner's uploaded `run-${id}-${attempt}` tree. No runtime or gate changes are permitted.

## Next checkpoint

Run exactly one clean-retention attempt 3 with the evidence package physically under the workflow's uploaded run directory. After completion, download the GitHub artifact and verify the evidence files themselves—not merely an inventory printed to stdout. If that succeeds, the clean retention lineage is complete and one separate authoritative D01 run may be constructed with frozen D01-002 P0-P8 and Gates A-J unchanged. If attempt 3 fails materially similarly, stop this lineage under the three-attempt rule and redesign the retention mechanism before further lab execution.
