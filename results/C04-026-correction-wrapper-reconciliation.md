# C04-026 correction-wrapper reconciliation

Status: **HARNESS INVALID / ESSENTIAL NOW redesign**

The frozen C04-026 behavioral experiment has still received only one LinuxCNC execution (attempt 1), which remains HARNESS INVALID for the reasons in `C04-026-attempt-1-reconciliation.md`. Two subsequent correction-wrapper workflow runs failed before LinuxCNC started and therefore provide no machine-behavior evidence:

- workflow `34243479618`, job `102119350223`, artifact `10062964959`, source commit `0fbcb00849f17b7e468f9bd860b4bdd3ff7f30bd`: Python syntax error in the wrapper's nested quoting;
- workflow `34243595136`, job `102119736791`, artifact `10063009655`, source commit `553cb3aa9def030d9b7b115493909ba76df7e892`: wrapper preflight succeeded far enough to prove the Gate-F tuple correction (`outB` index 9) was present, but the generated-source insertion searched for an incorrectly escaped trace marker and asserted count 0.

Neither run started LinuxCNC, altered a frozen gate, or tests the `maxoutput=1.0` prediction.

## Three-attempt discipline

Counting the original invalid behavioral run plus these two materially related correction failures reaches the mission's investigation-control boundary. Do not make another minor quoting/marker patch to the nested injection design.

Classification: **ESSENTIAL NOW**. C04 cannot graduate without a valid same-cycle saturation observation, so the experiment remains required. Begin a materially redesigned harness cycle rather than blindly retrying the same insertion mechanism.

## Redesigned evidence-retention architecture

Use the already-proven `trap cleanup EXIT` behavior in the inherited C03/C04 inner fixture, which copies `c04-026-realtime.txt`, LinuxCNC stdout/stderr and halsampler stderr into `lab-results/c04-026-evidence/` even when the analyzer exits nonzero. Repository state already confirms those files exist from attempt 1, including a 2,426,358-byte raw realtime trace.

For the next authoritative execution:

1. change only Gate-F tuple `outB` from index 8 to 9;
2. delete the stale `lab-results/c04-026-evidence/` directory at the start of the job so stale evidence cannot satisfy retention;
3. extend the workflow artifact upload path to include `lab-results/c04-026-evidence/`;
4. do not inject any pre-analyzer source block;
5. after completion, verify the workflow artifact contains a newly generated raw trace and inspect raw phase-3 `satB`, `satCountB`, `outB`, and `maxOutB` records directly.

This redesign leaves Gates A-H, Kc=0.5, PID gains, plant gains, `maxoutput=1.0`, phase durations, and thresholds unchanged.
