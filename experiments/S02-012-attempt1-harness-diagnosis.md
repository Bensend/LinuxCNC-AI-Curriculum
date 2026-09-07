# S02-012 Attempt 1 — HARNESS INVALID

Module: S02 — watchdog design patterns
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Workflow run: `34086302076`
Source commit: `04f212fbb75a3a13009b3938ecf0085df5fbdbc8`
Lab exit code: `2`
Classification: **HARNESS INVALID**

## Why this is not a watchdog prediction failure

The first S02-012 run completed the run-in-place build but never established the HAL topology needed to exercise the predeclared watchdog gates. Its stderr reported that realtime scheduling was unavailable because `sched_setscheduler(SCHED_FIFO)` was not permitted, that the relevant process capabilities were absent, and that LinuxCNC fell back to POSIX non-realtime. The topology readiness probe then failed and the lab exited 2 before Gate 1.

No observation from this attempt is therefore evidence for or against the predicted `watchdog(9)` transition-timeout or re-arm semantics. In particular, it is invalid to record “watchdog did not arm” or “watchdog timeout failed”; the component/thread topology was never ready.

## Root cause

The lab built a run-in-place uspace LinuxCNC tree and sourced `scripts/rip-environment`, but omitted the normal run-in-place capability setup after `make`. LinuxCNC's own diagnostic explicitly recommended `sudo make setcap` (preferred) or `sudo make setuid` for `rtapi_app`.

This differs from using `LINUXCNC_FORCE_REALTIME=1`: forcing the flag would bypass the capability check for testing, whereas applying the normal run-in-place `setcap` target corrects the missing harness setup and lets LinuxCNC attempt its intended uspace scheduling path.

## Material correction

`lab-jobs/012-s02-watchdog-heartbeat.sh` was corrected to run:

```text
make -j"$(nproc)"
sudo make setcap
```

before sourcing the run-in-place environment. The correction was committed as `5004397c79ad3cbac7baa5b5b5f194b5a31b3e12`, which triggered materially corrected workflow run `34090492326`.

## Acceptance discipline for the corrected run

The corrected run is still required to prove all original, predeclared behavioral gates without weakening them:

1. disabled startup leaves `ok-out` false;
2. enable FALSE→TRUE arms;
3. live transitions keep the watchdog OK;
4. frozen heartbeat causes a bite;
5. resumed heartbeat alone does not re-arm;
6. explicit enable FALSE→TRUE re-arms;
7. thread periods/order are captured so the result is not misrepresented as a physical response-time test.

If the corrected run fails after a valid topology is established, classify that failure separately rather than retroactively changing this attempt's classification.

## Evidence boundary

Even a corrected PASS can only TEST-CONFIRM the generic LinuxCNC HAL software watchdog behavior exercised in this userspace laboratory. It cannot validate HostMot2 FPGA watchdog behavior, board-pin electrical state, external charge-pump circuitry, drive response, STO, stopping time, diagnostic coverage, or any PL/SIL/category claim.
