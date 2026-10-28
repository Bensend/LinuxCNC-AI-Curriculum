# 2026-10-28 — Curriculum local-compute runner trigger guard (governance/source audit)
**Non-laboratory repository governance check.** This is not a new 4400 safety competency, a physical safety test, or authorization to execute any workflow.

## Exact current repository workflow inventory
Directly inspected the four existing workflow YAML files on `main` during the 2026-10-28 19:32Z curriculum session:

| Workflow | Trigger | Runner label | Risk / handling |
|---|---|---|---|
| [`lab-runner.yml`](../.github/workflows/lab-runner.yml) | `workflow_dispatch` **and** push to `lab-jobs/**` or its own workflow YAML | **`ubuntu-latest`** | **LEGACY HOSTED TRAP.** Do not dispatch, change trigger paths, or rely on this workflow for compute. When a frozen, question-driven lab is justified, convert to bounded `[self-hosted, openpressbrake]` with safe manual trigger and verify dispatch before running. |
| [`append-lab-compute.yml`](../.github/workflows/append-lab-compute.yml) | push to `LAB_COMPUTE_APPEND_REQUEST.md` | **`ubuntu-latest`** | **LEGACY HOSTED TRAP.** Do not submit append requests via this trigger. Update the ledger only from authoritative runtime using a safe direct Git append/update or convert workflow to self-hosted first. |
| [`append-lesson-log.yml`](../.github/workflows/append-lesson-log.yml) | push to `TIMING_APPEND_REQUEST.txt` or `timing-queue/**` | **`[self-hosted, openpressbrake]`** | Self-hosted route exists, but do not trigger merely to log if direct verified-blob append is available. |
| [`pb-dxf-001.yml`](../.github/workflows/pb-dxf-001.yml) | manual `workflow_dispatch` | **`[self-hosted, openpressbrake]`** | Bounded local example. Not a reason to run unrelated simulation. |

**SOURCE-CONFIRMED** repository workflow configuration, not actual runner availability or runtime. No workflow was dispatched, modified or run in this session. The curriculum source/documentation commits changed none of the hosted workflow's push-trigger paths; no hosted minutes are claimed consumed by these source commits. Actual Actions billing/job runtime was not queried because no new lab was requested or justified.

## Safe future compute decision
1. Freeze an exact unresolved engineering question, expected oracle, evidence retention and bounded runtime before any compute.
2. Check whether the curriculum repository can actually dispatch the local panel PC runner. **Availability remains UNKNOWN** until a justified attempt or authoritative runner-status evidence exists; never infer it from YAML labels alone.
3. If local dispatch works, use or convert a bounded manual workflow with `runs-on: [self-hosted, openpressbrake]`. Avoid push-triggered labs. If unavailable, record the access blocker and continue source/documentation work.
4. Never fall back to `ubuntu-latest`, `ubuntu-24.04` or another hosted runner. Do not send a compute job merely to prove runner access. Append `LAB_COMPUTE_LOG.md` only when authoritative job runtime actually exists.

This guard is an **information-architecture/risk-prevention finding** and must not be counted as machine safety validation, learning competency or laboratory result. The selected OpenPressBrake G0/G1 physical and independent evaluator gates remain unchanged.
