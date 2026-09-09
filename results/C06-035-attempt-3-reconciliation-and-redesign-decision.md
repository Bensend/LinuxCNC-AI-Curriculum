# C06-030 Attempt 3 Reconciliation and Three-Attempt Decision

Classification: **HARNESS INVALID before LinuxCNC execution**

Workflow: `34302451216`
Job: `102312063998`
Artifact: `10085401335`
Curriculum source commit: `99f8890e466706fc182dfd7b79f2929ca9680b2f`

## Observed failure

The workflow selected `lab-jobs/035-c06-transport-watchdog-authoritative-shmem-ref-fix.sh`, but the wrapper's own first Python transformation failed to parse because nested triple-quoted Python strings were not escaped safely. Retained stderr begins with a Python `SyntaxError` at the embedded `old='''...'''` source block. Inner exit code is `1`.

No LinuxCNC checkout/build, HAL registration, P0-P6 phase, or behavioral observation occurred in this attempt. Frozen Gates A-H remain **UNSCORED** and the frozen prediction is neither confirmed nor falsified.

## Three-attempt rule

C06-030 has now consumed three authoritative attempts without reaching valid behavioral evidence:

1. Attempt 1: legacy/direct HAL pointer export incompatible with pinned opaque-reference HAL API — HARNESS INVALID before P0.
2. Attempt 2: opaque references/getters/setters adopted, but reference slots remained outside HAL shared memory — HARNESS INVALID before P0.
3. Attempt 3: source-grounded shared-memory correction was wrapped using a fragile nested source-rewriting layer that itself had a syntax error — HARNESS INVALID before LinuxCNC execution.

Decision: **ESSENTIAL NOW, REDESIGN**.

Communication-fault versus watchdog-fault separation is the central learning objective of C06 and feeds later failure-engineering work, so the independent behavioral verification cannot be dropped or promoted merely because this harness family became awkward. However, continuing to stack wrappers on wrappers is now explicitly prohibited.

## Clean-redesign constraint

Retire `033 -> 034 -> 035` as an implementation lineage. Preserve them as failed evidence, but do not create an attempt 4 by editing or wrapping them.

The next experiment implementation must start from a clean, auditable source artifact and satisfy these construction preconditions *before* consuming another authoritative behavioral attempt:

- Build one standalone lab patch or fixture source, not runtime text rewriting of an earlier attempt.
- Put lab-only opaque HAL reference slots in a single `hal_malloc()`-allocated structure. Pinned HAL documentation states that `hal_malloc()` allocates from HAL shared memory and is intended for pin/parameter storage.
- Compile that fixture in a **non-authoritative construction preflight** that does not score C06 behavior.
- Load it and prove all required lab control pins plus the real HostMot2 `io_error` and watchdog pins exist.
- Retain production-source SHA-256 checks for `hostmot2.c`, `tram.c`, and `watchdog.c`.
- Only after construction/load preflight passes, freeze the clean fixture bytes/patch SHA and run one new authoritative behavioral experiment against the already-frozen C06-030 P0-P6 and Gates A-H.

The preflight is a redesign validation, not a fourth attempt at the retired harness family.

## Source reconciliation

Pinned LinuxCNC HAL evidence clarifies the attempt-2 defect: modern `hal_pin_new_bool()` / `hal_pin_new_ui32()` use opaque reference handles, but the caller-provided handle storage is still part of HAL's shared-memory object model. `hal_malloc()` is the supported allocator for that storage. Thus opaque handles do not imply ordinary file-scope process memory is valid pin-reference storage.

Current official LinuxCNC documentation still independently distinguishes hm2_eth packet-error escalation from HostMot2 watchdog state: packet loss raises packet-error state toward low-level `io-error`, while the firmware watchdog is serviced by HostMot2 write activity and changes board I/O connectivity when it bites. A historical developer field report also warns that packet loss can *cause* a watchdog bite by delaying service; causal linkage does not make the two states identical.

## Exact next checkpoint

Perform a clean construction-only C06 fixture redesign in one standalone source/patch artifact. First run a non-authoritative compile/load preflight proving shared-memory HAL reference construction and the required HAL object set. Do **not** score P0-P6 and do not launch another behavioral run until that preflight passes. Then execute the frozen C06-030 experiment once with the preflight-proven fixture.
