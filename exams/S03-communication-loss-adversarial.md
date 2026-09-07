# S03 — Communication-Loss Adversarial Exam

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Status: **exam authored; final grading depends on S03-013 independent verification**

## Purpose

Test whether a fresh AI can reason about transport errors, HostMot2 host state, stale HAL publication, recovery, watchdog boundaries, and physical-machine claims without conflating them.

## Questions

### 1 — Misleading stale-feedback premise

A machine is moving when `hm2_<board>.0.io_error` becomes TRUE. `hm2_<board>.0.encoder.00.position` then remains numerically constant for 200 servo periods. An engineer says: "The encoder proves the axis stopped immediately when communication failed."

Is that conclusion justified? Trace the relevant pinned HostMot2 read path and state what additional evidence would be needed to establish actual axis motion.

### 2 — Failure-path trace

Trace a representative path from repeated hm2_eth read/response failures through the driver's packet-error policy to persistent LLIO `io_error`, then through generic HostMot2 behavior. Distinguish:

- a transient packet error;
- accumulated packet-error level;
- persistent `io_error`;
- stale published HAL state.

Do not claim a precise number of lost packets unless the active increment/decrement/limit configuration establishes it.

### 3 — Command-delivery trap

While persistent `io_error` is TRUE, a HAL output command changes from 0 to 1. What can and cannot be inferred about the corresponding FPGA/connector state? Identify the source-level host boundary that controls the inference.

### 4 — Recovery trap

An operator clears `io_error`; one later software cycle completes without reporting an error. A proposed recovery sequence immediately restores machine enable because "communications are healthy again."

Explain why that premise is too strong. Separate:

1. permission for host communication attempts to resume;
2. observed fresh HostMot2 publication/write activity;
3. board/remote/drive state synchronization;
4. validated machine-safe recovery.

### 5 — Watchdog conflation

Are an hm2_eth `io_error` and a HostMot2 firmware watchdog bite the same event? Explain their relationship and why neither, by itself, proves STO, zero torque, or a safety-rated stop.

### 6 — Version-sensitive field report

A 2016 forum report says an older hm2_eth implementation could wait long enough after a missing read response to miss realtime deadlines and provoke a watchdog bite. May that exact timing behavior be asserted for the pinned 2026 revision? How should the report be used?

### 7 — Small design/configuration task

You are designing a non-safety diagnostic layer for a controller that consumes HostMot2 encoder feedback over Ethernet. Sketch a HAL/software policy that prevents downstream diagnostics from silently treating a last-known value as fresh after communication errors. It must not fabricate feedback or claim functional-safety coverage.

### 8 — Novel combined-fault scenario

At cycle N, the displayed encoder value is 125.0 and a drive-enable command is TRUE. Communication then escalates to persistent `io_error`. At N+1 the motion layer changes its command and some independent fault logic requests disable, but the visible encoder value remains 125.0.

A technician sees the unchanged encoder and a software disable request and concludes: "The drive is disabled and the axis is stationary."

Using only S03-level evidence, explain every inference that is valid and every physical conclusion that remains unproven.

## Answer key / grading criteria

### 1

**Pass:** Reject the premise. At the pinned revision, generic HostMot2 read processing returns before per-module TRAM-to-HAL publication when persistent `llio.io_error` is set; a prior encoder value can therefore remain visible without being a fresh sample. Actual motion requires independent physical/drive/encoder evidence known to be fresh, not the stale HAL value alone.

### 2

**Pass:** Explain that hm2_eth detects transport/response failures and updates packet-error state; repeated/weighted errors raise `packet-error-level`, and reaching `packet-error-limit` escalates to persistent low-level `io_error`. Generic HostMot2 then suppresses fresh normal module publication/writes while that state persists. Do not equate one packet error with permanent failure or invent a fixed packet count independent of configured policy.

### 3

**Pass:** A changed HAL command proves only a host-side desired value. `hm2_write()` returns early under persistent `io_error`, so the ordinary HostMot2 path may not call the LLIO write mechanism for that new command. The actual FPGA/connector state requires separate evidence; the answer must not infer that the old command, new command, or zero necessarily exists physically.

### 4

**Pass:** Clearing `io_error` removes the generic HostMot2 barrier to attempting processing; it is not a synchronization certificate. Require successful fresh reads, expected write activity/acknowledgment where available, sane state comparisons, and machine-specific recovery interlocks/procedures before re-enable. A software test fixture can prove resumed host processing but not real board/drive/mechanical state or safe recovery.

### 5

**Pass:** They are distinct mechanisms. `io_error` is the LLIO/host communication-failure state. The firmware watchdog is serviced through successful HostMot2 activity and may bite when servicing stops, changing FPGA I/O ownership according to firmware behavior. Their timing and causal relationship depend on circumstances. Neither establishes downstream STO/zero torque/safe stop without board/drive/safety evidence.

### 6

**Pass:** No. Treat the historical report as COMMUNITY-REPORTED evidence and a failure-mode lead. Reconcile current behavior against the pinned source/experiment before asserting version-specific timing semantics.

### 7

**Pass:** Track an explicit communication/freshness validity state alongside the numeric feedback; on packet errors or persistent `io_error`, mark feedback invalid/stale and prevent consumers from presenting it as current. Recovery requires a defined number/condition of confirmed fresh cycles or state validation before clearing the diagnostic. The policy may inhibit ordinary control/diagnostics as appropriate, but must not be labeled safety-rated without separate evidence.

### 8

**Pass:** Valid: the last published encoder value was 125.0; persistent communication failure can prevent a fresh value from replacing it; a software disable request exists at the host side. Unproven: actual axis position/motion, whether the new command or disable reached the board/drive, FPGA output state, drive enable/STO state, torque, braking, and stopping. A correct answer explicitly refuses to combine two host-side observations into a physical safety claim.

## Fresh-AI pass condition

A fresh AI passes if it answers the novel scenario without using "unchanged feedback = stationary" or "software disable = physical torque removed," correctly identifies `io_error` as a host/LLIO boundary rather than a safety function, and proposes a diagnostic freshness policy that preserves uncertainty rather than fabricating machine state.
