# H01 checkpoint — object/connectivity source trace complete; bounded lab launched

Session start: `2026-09-06T06:11:00Z`.
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`.

## Durable work completed

- `call-flows/H01-registration-connectivity-and-function-scheduling.md`
  - inventoried `hal_data_t`, component/pin/signal/parameter/function/function-entry/thread structures and shared-offset relationships;
  - traced `hal_ready()` / unready lifecycle and corrected the overly broad interpretation that ready globally freezes HAL configuration;
  - traced pin creation through dummy-storage pointer initialization;
  - traced signal allocation and signal-owned value storage;
  - traced `hal_link()` pointer redirection plus reader/writer/bidir invariants;
  - traced `hal_unlink()` / `unlink_pin()` snapshot-back-to-dummy behavior and cleanup paths;
  - separated function export from `addf` scheduling and periodic `thread_task()` execution.
- `forum-findings/H01-connectivity-ready-state-field-notes.md`
  - reconciled field reports of writer conflicts, one-pin/one-signal topology, userspace pointer-storage errors, and ready-state usage against pinned source.
- `lab-jobs/006-h01-hal-object-connectivity.sh`
  - predeclared scalar link/unlink, writer-conflict, exported-function/addf and threadbeat predictions;
  - launched exactly one workflow run from commit `62b2892f4f1e769cef5fc6a075b3d7f0f18d15be`.

## Active experiment

- Actions run: `34016051740`
- Job: `101439886671`
- Source curriculum SHA: `62b2892f4f1e769cef5fc6a075b3d7f0f18d15be`
- State at checkpoint: in progress; checkout had begun. No runtime claim is promoted yet.

## Acceptance gates

A run is valid H01 evidence only if it is fresh `006` output from the SHA above and reaches all corresponding assertions:

1. unlinked `or2.0.in0` can be initialized TRUE;
2. first link to `h01-scalar` leaves both pin and signal TRUE (dummy/default copied to initially undriven scalar signal);
3. setting the linked signal FALSE makes the linked pin FALSE;
4. unlink while FALSE then changing the signal TRUE leaves the pin FALSE while signal becomes TRUE (snapshot-to-dummy plus pointer separation);
5. a second `HAL_OUT` writer fails with an identifiable writer-conflict diagnostic;
6. `or2.0` is exported before `addf`, appears in `h01-thread` after `addf`, and `h01-thread.threadbeat` advances after `start`;
7. the explicit successful-completion marker is reached.

If the script fails because a command spelling/output assumption is wrong, classify that run **HARNESS INVALID**, fix only evidence-proven harness defects, and do not promote object-model claims from it. If a semantic assertion contradicts the pinned source prediction, investigate the discrepancy before rerun.

## Exact next-work checkpoint

Inspect run `34016051740` / job `101439886671` to completion. Reconcile every acceptance gate against the readable lab output and exact source SHA. If valid, promote the observed link/unlink/writer/addf behaviors to `TEST-CONFIRMED`, then create the H01 adversarial exam covering shared offsets, ready/unready semantics, pin dummy versus signal storage, writer conflicts, cleanup, function export versus scheduling, and mutex-failure boundaries. Correct any weaknesses, write the fresh-AI H01 handoff, make a graduation-sufficiency/promotion decision, and only then unlock the next HAL lesson on the dependency graph. Do not launch a duplicate `006` while this run is active.
