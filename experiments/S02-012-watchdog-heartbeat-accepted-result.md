# S02-012 — Accepted Watchdog Heartbeat Result

Module: S02 — watchdog design patterns
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Accepted workflow run: `34091326973`
Accepted source commit: `888a06f985e02101f866a8c07ab866c2520316a3`
Lab exit code: **0**
Lab UTC interval: `2026-09-07T06:32:55Z` to `2026-09-07T06:36:07Z`
Classification: **TEST-CONFIRMED within bounded software-semantics scope**

## Harness history and evidence integrity

Three prior executions were rejected as harness evidence before accepting this run:

1. run `34086302076`: **HARNESS INVALID** — run-in-place capability setup omitted; HAL topology never became ready;
2. run `34090492326`: **HARNESS INVALID** — `sudo make setcap` succeeded but the hosted runner still rejected realtime scheduling; HAL topology never became ready;
3. run `34090889576`: **HARNESS INVALID** — LinuxCNC's testing-only force-realtime override crossed the scheduling startup gate, but the background interactive `halrun -I` session could see CI stdin EOF and tear its environment down before external probes attached.

The accepted run retained normal `sudo make setcap`, retained the testing-only `LINUXCNC_FORCE_REALTIME=1` disclosure, and explicitly held `halrun -I` stdin open with a private FIFO/file descriptor for the duration of external probing. No behavioral acceptance gate was weakened during these corrections.

## Raw-artifact gates

The workflow artifact's own `LATEST.exit_code.txt` is `0`, and its metadata binds the evidence to source commit `888a06f...` and workflow run `34091326973`.

Observed gates:

```text
HAL ready at probe 2
initial-disabled=PASS
estop-latch-heartbeat-source-ok=PASS
armed ok-out=TRUE
enable-rise-arms=PASS
heartbeat samples=TRUE,TRUE,FALSE ok-out=TRUE
healthy-heartbeat=PASS
frozen-input=FALSE bitten-ok-out=FALSE
freeze-causes-bite=PASS
post-resume-with-enable-still-high ok-out=FALSE
resume-alone-does-not-rearm=PASS
enable-low ok-out=FALSE; after rising edge ok-out=TRUE
explicit-enable-cycle-rearms=PASS
S02 generic watchdog heartbeat lab completed successfully.
```

These observations match the predeclared oracle derived from pinned `watchdog.c`.

## TEST-CONFIRMED claims

At the pinned revision, in this userspace software laboratory:

- `watchdog(9)` can be armed by the required `enable-in` rising edge;
- a live toggling input can keep `ok-out` asserted while transitions arrive inside the timeout budget;
- freezing the heartbeat causes `ok-out` to deassert;
- resuming heartbeat transitions while enable remains high does **not** automatically recover;
- an explicit enable FALSE→TRUE cycle re-arms the component.

The experiment also confirms the practical design distinction that a watchdog heartbeat is a transition/liveness signal. Its absolute TRUE/FALSE level is not the health criterion.

## Explicit non-claims

The accepted runner used LinuxCNC's **testing-only** `LINUXCNC_FORCE_REALTIME=1` override on a non-PREEMPT_RT hosted kernel. Therefore this result does **not** establish:

- production realtime scheduling quality, jitter, deadline compliance, or exact worst-case detection latency;
- HostMot2 firmware watchdog bite/recovery behavior;
- actual FPGA or connector pin voltage/current/high-impedance behavior;
- external charge-pump or safety-relay operation;
- drive disable, STO, zero torque, brake/contactor behavior, or stopping time;
- diagnostic coverage, independence, PL, SIL, category, or any functional-safety certification.

Those claims require evidence in their own failure domains.

## Adversarial reconciliation

The accepted behavior survives the S02 adversarial cases:

- stuck-high and stuck-low are both failed heartbeats because neither transitions;
- timely but logically dangerous commands can still satisfy liveness watchdogs;
- two watchdogs do not automatically provide independent diagnostic coverage;
- a HostMot2 high-impedance fail state is not automatically a physical safe actuator state;
- shared CPU/scheduler/power/software paths create common-cause weaknesses;
- a software lab timeout is not a machine stopping-time measurement.

## Result

S02 has sufficient source, documentation/community reconciliation, reproducible bounded experiment, adversarial correction key, and fresh-AI claim boundaries to graduate at the 1000-level curriculum scope.
