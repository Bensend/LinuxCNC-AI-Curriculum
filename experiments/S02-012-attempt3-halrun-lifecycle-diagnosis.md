# S02-012 Attempt 3 — HARNESS INVALID (interactive HAL lifetime)

Module: S02 — watchdog design patterns
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Workflow run: `34090889576`
Source commit: `b2d2c155f60b3bc42d4d0f8ae72f5d78f6c9bb4a`
Lab exit code: `2`
Classification: **HARNESS INVALID**

## What changed from attempt 2

Attempt 3 retained normal `sudo make setcap` and added LinuxCNC's testing-only `LINUXCNC_FORCE_REALTIME=1` override. The LinuxCNC diagnostic changed materially:

- attempt 2: realtime scheduling unavailable / POSIX non-realtime fallback;
- attempt 3: `SCHED_FIFO available` and `Using POSIX realtime`, with an explicit warning that the kernel is not PREEMPT_RT and latency may be unbounded.

This demonstrates that the third attempt crossed the prior realtime-environment startup gate. It still failed the external HAL topology readiness probe before behavioral Gate 1.

## Remaining harness defect

The harness launches:

```text
halrun -I -f /tmp/s02-watchdog.hal ... &
```

`halrun -I` processes the file and then starts an **interactive** `halcmd` session. The documented lifecycle tears the realtime environment down when that session ends. In a non-interactive CI background job, stdin is not a durable user terminal; EOF can terminate the interactive session immediately after the file is processed. That creates a race in which the topology can be created and torn down before the separate `halcmd show ...` readiness probes attach.

The clean stderr—no component load/configuration error after the POSIX-realtime startup messages—is consistent with a lifecycle teardown rather than evidence that `watchdog(9)` itself failed.

## Material correction

Keep the interactive session's stdin deliberately open with a private FIFO/file descriptor for the duration of the external probes. The test will close that descriptor during cleanup. This makes the HAL lifetime an explicit part of the harness rather than an accidental property of CI stdin.

The fourth attempt must keep:

- the original S02 behavioral gates unchanged;
- `sudo make setcap`;
- the testing-only force-realtime disclosure;
- the same evidence boundary excluding realtime latency and physical/safety claims.

A valid topology followed by a behavioral failure is no longer to be classified automatically as a harness problem; it must be reconciled against pinned `watchdog.c` and the predeclared oracle.
