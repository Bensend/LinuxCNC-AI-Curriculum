# C06-036 clean-fixture preflight reconciliation

Status: **PREFLIGHT PASS / NON-AUTHORITATIVE**

This run is the required post-three-attempt redesign proof. It is not an execution of frozen C06-030 phases P0–P6 and does not score Gates A–H.

## Authoritative metadata

- Curriculum source commit: `b01334819a6cec1fae13527cf42916d118666ec7`
- Workflow run: `34306117465`
- Job: `102323048875`
- Artifact: `10086772790`
- Artifact digest: `sha256:15f69e87bb268091b4cf220e0e68e439af6ee4e9b642939292de6f61d9bb31fb`
- Job start: `2026-09-09T03:11:06Z`
- Job end: `2026-09-09T03:15:02Z`
- Exact job compute: 236 s = **3.9 min**
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Exit code: `0`

## What was proven

The clean standalone construction compiled and loaded LinuxCNC with a new `hm2_test` pattern 15 containing one valid IOPort descriptor and one real HostMot2 watchdog descriptor. The lab-only opaque HAL reference slots were allocated as one `hal_malloc()` structure rather than ordinary file-scope C storage. The run used current `hal_pin_new_*`, `hal_get_*`, and `hal_set_*` accessors.

The load-only HAL proof found all required fixture controls:

- `hm2_test.0.c06.fail-reads-remaining`
- `hm2_test.0.c06.watchdog-status-command`
- `hm2_test.0.c06.read-success-count`
- `hm2_test.0.c06.read-fail-count`
- `hm2_test.0.c06.write-success-count`
- `hm2_test.0.c06.consecutive-failures`
- `hm2_test.0.c06.io-error-mirror`
- `hm2_test.0.c06.watchdog-status-mirror`

It also found the real generic HostMot2 objects required by the frozen experiment:

- `hm2_test.0.io_error`
- `hm2_test.0.watchdog.has_bit`
- `hm2_test.0.watchdog.timeout_ns`

The fixture initialized and registered test pattern 15 successfully, then unloaded cleanly.

The job compared SHA-256 manifests before/after fixture construction and rejected any change to production `hostmot2.c`, `tram.c`, `watchdog.c`, or `hostmot2-lowlevel.h`. Only the laboratory `hm2_test.c` seam was changed.

## Three-attempt redesign criterion

This closes the construction defect family that invalidated C06-030 attempts 1–3:

1. obsolete/direct HAL storage assumptions;
2. opaque-reference handles outside HAL shared memory;
3. nested wrapper/source-rewriter quoting failure.

The accepted preflight is a fresh standalone construction. It does not inherit the retired `033 -> 034 -> 035` wrapper chain. Its exact tested patch is durably retained at `lab-results/run-34306117465-1/c06-clean-hm2test.patch`; the next authoritative run must apply that retained preflight-tested patch directly rather than regenerate or reinterpret it.

## Behavioral status

**UNSCORED.** The run explicitly did not execute P0–P6. Frozen C06-030 Gates A–H, thresholds, failure count, watchdog status address/bit, phase semantics, and safety boundary remain unchanged.

## Authorized next step

Execute one authoritative C06-030 run by applying the exact retained C06-036 fixture patch to the pinned LinuxCNC revision, proving production-source integrity again, then running frozen P0–P6 with one atomic realtime sampler stream. Preserve the complete patch, HAL/build logs, raw trace, analyzer output, and artifact before scoring Gates A–H.
