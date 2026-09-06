# IO01 adversarial exam and correction key

Pinned revision: `8bf4605ae81042248add031e94c77300406e0413`

## Questions

1. A Mesa encoder HAL `count` pin does not change for one servo cycle. Prove why that alone does not establish that the physical encoder stopped.
2. Trace the normal source path from the exported HostMot2 realtime `read` function to scaled encoder `position` publication, including the gates which can skip processing.
3. Misleading premise: "HostMot2's encoder count register is 16 bits, therefore LinuxCNC position rolls over every 65536 counts." Refute this precisely and identify the remaining ambiguity.
4. Explain why asserting encoder `reset` does not imply that the FPGA counter itself becomes zero.
5. An encoder is moving very slowly and no new count arrives in the latest read. Why can `velocity` remain nonzero? What finally forces STOPPED?
6. Failure trace: LLIO reports `io_error` after a previously good sample. What happens to encoder post-processing during `hm2_read()`, and why is a frozen HAL value not proof of fresh zero motion?
7. Version-sensitive question: may these conclusions be projected from development SHA `8bf4605...` to every v2.9 installation? Why or why not?
8. Small modification task: design the least-invasive no-hardware fixture change that could test wrap extension and reset behavior while still executing production HostMot2 encoder processing. State what that test still could not prove.

## Checked answers

1. An unchanged HAL value can result from no new physical edge, a temporary `-EAGAIN` read completion, `io_error` causing early return, unchanged TRAM data, or host-side state logic. Freshness must be established at the read/TRAM boundary before physical stop is inferred.

2. HAL realtime thread -> board HostMot2 `read` -> `hm2_read()` -> optional `hm2_read_request()` -> queued TRAM/LLIO transaction -> `hm2_finish_read()` -> `-EAGAIN`/`io_error` gates -> `hm2_encoder_process_tram_read()` -> per-instance raw-count extension/index handling -> zero-offset/logical count -> 64-bit logical count divided by scale -> HAL position publication, with velocity/control state updated from the same completed host-side register image.

3. The driver extends the 16-bit hardware count using `hal_extend_counter(...,16)` into internal 64-bit state. Ordinary rollover therefore does not force a 65536-count public position rollover. The unresolved bound is how large an inter-sample jump can occur before the 16-bit delta becomes ambiguous; that is promoted.

4. Reset moves the host `zero_offset_64` to the current accumulated raw count. Logical count is computed relative to that offset; the underlying hardware count continues.

5. The MOVING state uses captured timestamp history and the current timestamp counter to bound velocity even without a new edge. The estimate decays until elapsed time reaches `vel-timeout`, then velocity/rpm are set to zero and state returns STOPPED.

6. Generic `hm2_read()` returns before encoder post-processing when `io_error` is asserted. Previously published HAL values can remain visible. Therefore "unchanged" is not equivalent to "freshly sampled and stationary."

7. No. These are SOURCE-CONFIRMED for the pinned development SHA. Stable must be inspected or tested before implementation details are asserted identical.

8. Extend `hm2_test` so a test harness can mutate selected fake register locations between production `hm2_read()` calls and capture writes. Use synthetic counter/timestamp snapshots to drive production TRAM and encoder post-processing. This still does not test FPGA quadrature decoding, network/PCI timing, electrical integrity, physical edge-rate margin, or safety.

## Adversarial corrections

The exam exposed one phrasing risk: a "frozen encoder" must not be taught as synonymous with a fresh zero-delta sample. The call-flow guide now explicitly places LLIO completion and `io_error`/`-EAGAIN` gates before encoder processing and recommends freshness localization before physical diagnosis.

No core source conclusion required reversal. The no-hardware lab was deliberately classified PROMOTE rather than being simulated and mislabeled TEST-CONFIRMED.

## Result

PASS for IO01 1000-level scope. A fresh engineer can distinguish transport freshness, TRAM state, host reconstruction, FPGA capture, and physical signal layers; can trace count/reset/scale/velocity behavior; and can identify what remains unverified.
