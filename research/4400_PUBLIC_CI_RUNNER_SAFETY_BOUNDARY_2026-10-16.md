# 4400 — Public CI runner versus physical machine safety (2026-10-16)

Status: SOURCE-CONFIRMED from public curriculum main `068a278e37a92c7a3dcbcf8c266d43c5ab81cc07`, plus DOC-CONFIRMED GitHub documentation. No physical validation, no jobs run.

## Workflow source findings
- `.github/workflows/lab-runner.yml` uses `ubuntu-latest` and executes selected lab scripts on manual dispatch or push; it must not be dispatched under the no-hosted-compute rule.
- `.github/workflows/append-lab-compute.yml` uses `ubuntu-latest` for a push-triggered ledger update; do not trigger it.
- `.github/workflows/append-lesson-log.yml` uses `[self-hosted, openpressbrake]` with repository write permission and shell/git operations; physical isolation of that runner is UNKNOWN.
- `.github/workflows/pb-dxf-001.yml` manually runs a fixture on the same labeled self-hosted runner; isolation is UNKNOWN.
- `lab-runner.yml` directly interpolates `inputs.job_file` into an inline shell script. GitHub documents this as a script-injection-prone input pattern. Use an intermediate environment variable and a strict allowlist in any redesign.

## Boundary
A runner label is a scheduling selector, not a machine-I/O or network isolation control. GitHub warns that self-hosted runners for public repositories may be persistently compromised. The correct next step is **not** to change `ubuntu-latest` to the panel-PC label without isolation evidence. Quarantine hosted jobs, keep local compute unexecuted until qualified, and use a separate reviewed environment with no machine-control, USB, fieldbus, or controller-network path.

Normal LinuxCNC/FPGA status and CI output cannot establish independent personnel safety, hazardous-energy isolation, hydraulic load holding, or machine stopping behavior. Selected-machine physical facts remain UNKNOWN. No personnel-exposed hazardous operation is justified without independent validation.

## Evidence and next work
DOC-CONFIRMED: https://docs.github.com/en/actions/reference/security/secure-use ; https://docs.github.com/en/actions/concepts/security/script-injections ; https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax .

Next: obtain authorized workflow quarantine/review, qualify runner isolation, preserve the occupied lesson-log append request, and continue source-based safety work. No GitHub-hosted minutes or physical tests consumed.
