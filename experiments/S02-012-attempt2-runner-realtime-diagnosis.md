# S02-012 Attempt 2 — HARNESS INVALID (hosted-runner realtime policy)

Module: S02 — watchdog design patterns
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Workflow run: `34090492326`
Source commit: `5004397c79ad3cbac7baa5b5b5f194b5a31b3e12`
Lab exit code: `2`
Classification: **HARNESS INVALID**

## Result

Attempt 2 materially corrected attempt 1 by applying LinuxCNC's normal run-in-place capability target:

```text
sudo make setcap
```

The build output confirms `setcap cap_ipc_lock,cap_net_admin,cap_sys_rawio,cap_sys_nice+ep ../bin/rtapi_app` completed successfully. Despite that, this hosted GitHub runner still reported:

- realtime scheduling unavailable;
- fallback to POSIX non-realtime;
- testing-only override available via `LINUXCNC_FORCE_REALTIME=1`.

The HAL topology readiness gate again failed before Gate 1. There are therefore still **no watchdog-behavior observations** from this attempt.

## Interpretation

This narrows the harness failure from “missing normal run-in-place setup” to “hosted runner does not grant the scheduling behavior LinuxCNC's uspace realtime check requires even after the executable capability setup succeeds.”

Do not reinterpret this as a LinuxCNC `watchdog(9)` failure. The tested component functions were never scheduled.

## Bounded next correction

For this **software-semantics-only** laboratory, use LinuxCNC's own explicitly testing-only override:

```text
export LINUXCNC_FORCE_REALTIME=1
```

The override is acceptable only because the experiment's evidence contract already excludes production realtime latency, deadline guarantees, physical outputs, HostMot2 hardware behavior, STO, and functional-safety claims. It is intended to let the hosted runner instantiate the production HAL component/thread topology so state-machine semantics can be exercised.

The next attempt must retain `sudo make setcap` and all original S02 behavioral gates unchanged. A PASS may be labeled TEST-CONFIRMED only for the generic HAL software semantics exercised at the pinned revision. It must not be used as evidence that this runner provides production realtime scheduling.
