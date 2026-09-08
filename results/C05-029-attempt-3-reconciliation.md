# C05-029 attempt 3 reconciliation

## Verdict

**HARNESS INVALID. No behavioral conclusion.**

Authoritative workflow `34251704209`, job `102147446647`, source commit `7fb5624bfcd271e1103d31bde16571be872c9ec9` completed with workflow failure and inner exit `1`. GitHub job runtime was 210 s (16:32:47Z–16:36:17Z); the inner lab metadata spans 16:32:50Z–16:36:10Z.

The LinuxCNC fixture built and reached runtime. Gate-A provenance/topology passed, the machine homed, entered MDI, and phase 1 began. FIFO 0 reported zero overruns. The run then stopped with:

`HARNESS_INVALID: split sampler trace empty`

## Root cause

Attempt 2 introduced a second realtime sampler FIFO but intentionally did not attach a userspace `halsampler` reader until after realtime sampling was disabled. That assumption was wrong. `halsampler` is not merely a post-hoc FIFO dump in this harness: the userspace reader is what activates/drains the selected sampler channel. FIFO 0 had a live `halsampler -c 0` process and produced records; FIFO 1 had no live reader during the experiment and therefore produced no usable trace. Attempt 3 repaired only generator quoting, so it exposed this latent transport defect unchanged.

This is an observation-harness defect, not evidence about scale faults, jumps, PID behavior, cross-coupling, or sensor-failure semantics. Frozen C05-029 Gates A–H and all behavioral values remain untouched.

## Three-attempt rule

C05-029 has now accumulated three harness-invalid attempts in the same essential experiment family:

1. attempt 1 exceeded the stream per-sample item limit;
2. attempt 2 failed in wrapper-generation quoting before LinuxCNC ran;
3. attempt 3 reached LinuxCNC but proved the deferred secondary-FIFO reader invalid.

Classification: **ESSENTIAL NOW**. C05 graduation still needs valid independent scale/jump evidence; promotion would leave the current 1000-level sensor-failure objective under-verified.

A further retry is allowed only as a **materially redesigned observation transport**, not another small patch to the deferred-drain scheme.

## Material redesign

Run two `halsampler` userspace readers concurrently for the entire decisive experiment, one per realtime FIFO. Preserve both raw traces. After both readers stop, exact-join only identical realtime sample numbers and require consecutive joined rows and zero overruns on both FIFOs. No interpolation, nearest-neighbor matching, row deletion, relabeling, behavioral retuning, or gate changes are permitted.

This removes the invalid assumption that FIFO 1 can be left unread during acquisition while preserving the frozen behavioral experiment.
