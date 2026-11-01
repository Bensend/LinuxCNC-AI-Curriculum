# STEPGEN-98 — Live HostMot2 step scale reinterprets feedback; accumulator wrap has one-LSB arithmetic discrepancy
**4000 LinuxCNC implementation. NON-GRADUATED. 2026-11-01 UTC.**

## Provenance
Inspected `src/hal/drivers/mesa-hostmot2/stepgen.c` at stable v2.9.10 peeled commit [`86cdca76fa2a36274c432caa21952b23c267989a`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/stepgen.c) (blob `8eb43d9a7d8e42573ef653cb82460609d2864ae4`) and development [`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/drivers/mesa-hostmot2/stepgen.c) (blob `4daaa54f3fb63b6af2dc2d83a31ebfbb7b47ca23`). Main symbols: `hm2_stepgen_process_tram_read`, `hm2_stepgen_instance_prepare_tram_write`, `hm2_stepgen_prepare_tram_write`. Official [HostMot2 stepgen interface](https://linuxcnc.org/docs/html/man/man9/hostmot2.9.html) documents `position-scale` as a writable parameter.

## Scale discontinuity — substantive implementation implication
In both versions, the read side publishes `position-fb = (subcounts / 65536.0) / position_scale`, while the write side converts a commanded machine-unit velocity to steps/s by multiplying `new_vel * position_scale`. The parameter is read live; there is no corresponding rescaling of accumulated historical `subcounts` when it changes. **SOURCE-CONFIRMED.**

**Deterministic arithmetic example (not a LinuxCNC run):** with 1,000 accumulated whole steps and 200 steps/mm, reported position is 5.0 mm. If `position-scale` is changed to 400 steps/mm while the accumulator remains at 1,000 steps, the next computed position is 2.5 mm: a **2.5 mm HAL feedback discontinuity without requiring physical movement**. The newly commanded step rate also doubles for the same machine-unit velocity. For the public [MR-1 configuration](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.hal), that `position-fb` is routed to `joint.0.motor-pos-fb`; a following-error response is possible depending on joint settings and execution order, **not demonstrated**. A static `setp ...position-scale [JOINT_0]STEP_SCALE` at startup does not itself exhibit this hazard; it requires a subsequent live change.

**Engineering rule:** treat scale changes as an offline reconfiguration requiring axis state reconciliation, not an operator feed-override control. Capture both `position-scale` and the raw stepgen count in diagnostics. Do not use a live scale write to fix a missed-step or wrong-homing problem.

## Distinct 32-bit wrap arithmetic (small magnitude)
Both revisions calculate `acc_delta = (s64)acc - (s64)prev_accumulator` and correct wrap with **`RTAPI_UINT32_MAX` = 4,294,967,295**, rather than the modulus **2^32 = 4,294,967,296**. The index/probe latch delta branches use the same correction. **SOURCE-CONFIRMED code and integer arithmetic.**

For a forward wrap `prev=0xFFFFFFFE`, `acc=0x00000002`: raw difference = −4,294,967,292; the implemented correction gives **+3**, whereas modulo-2^32 displacement is **+4**. Reverse `prev=0x00000002`, `acc=0xFFFFFFFE` gives implemented **−3**, expected **−4**. Each affected wrap has an error of **one 16.16 fractional tick = 1/65,536 step**. At an illustrative 200 steps/mm, that is **0.0000000762939453125 mm** per affected wrap. The accumulator wraps every 65,536 whole steps; typical machine-scale impact is tiny, and no physical or runtime error is claimed. It is *not* the separate HostMot2 encoder timestamp-wrap mechanism in [HM2-TIMESTAMP-76](4400_LINUXCNC_HM2_TIMESTAMP_76_ENCODER_16BIT_ROLLOVER_LATENCY_SOURCE_AUDIT_2026-10-31.md).

The wrap analysis assumes successive reads do not span more than half the 32-bit range; multiple-wrap/alias behavior is a separate unresolved timing boundary. No claim is made that the firmware's physical output missed a step because of this host-side readback arithmetic.

## Exact disconnected discriminators
- Freeze a software-only fixture with fixed accumulator `subcounts = 65536 * 1000`, then evaluate readback with scale 200 and 400; compare to actual independent simulated axis state. Do not inject into an operating machine.
- Pure integer reference: evaluate `prev=0xFFFFFFFE, current=2` and reverse, compare `±3` from current source to mathematically expected `±4`. If writing a regression test, assert **both** the original implementation and the proposed corrected model explicitly, so it cannot pass by merely testing itself.
- Before proposing upstream changes, verify current upstream revision, firmware accumulator semantics, and intended overflow assumptions; do not call this a measured machine defect.

**Evidence:** SOURCE-CONFIRMED conditional scale and wrap arithmetic in both pinned revisions; DOC-CONFIRMED parameter; INFERENCE for joint following-error/physical effect; TEST-CONFIRMED none. No Actions, build, runtime, simulation, hardware, or independent evaluator.
