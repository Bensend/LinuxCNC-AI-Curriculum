# IO01 — graduation handoff

Module: IO01 — quadrature encoder register-to-HAL path
Course level: 1000
Status: GRADUATED
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## What a fresh AI must know

The normal HostMot2 encoder feedback path is not "read one 16-bit count and publish it." Generic `hm2_read()` first completes the low-level/TRAM read and applies communication gates. Only after a successful enough read does it call `hm2_encoder_process_tram_read()`, which interprets the already-populated TRAM image.

The encoder host path then:

- extends the FPGA-facing 16-bit counter into internal 64-bit raw-count state;
- consumes index/latch completion state;
- applies reset/index by moving a host zero offset rather than resetting the FPGA raw counter;
- publishes logical count and scaled position from 64-bit host state;
- estimates velocity with event timestamps and a STOPPED/MOVING state machine, so no new edge does not necessarily mean immediate zero velocity;
- publishes filtered A/B/index and quadrature-error information from control/latch state.

## Critical call flow

`HAL realtime thread -> hm2_read() -> optional hm2_read_request() -> LLIO/TRAM completion -> EAGAIN/io_error gates -> hm2_encoder_process_tram_read() -> per-instance count/index/position/velocity processing -> HAL pins`

Read `call-flows/IO01-encoder-register-to-hal.md` before debugging this path.

## Failure/debugging model

A frozen HAL encoder value is not automatically a frozen physical encoder. Localize freshness in this order:

1. HostMot2 read function invocation;
2. LLIO completion and `io_error` / `-EAGAIN` state;
3. TRAM register-image change;
4. host 16-bit extension, zeroing, scale, and velocity-state processing;
5. FPGA quadrature capture/filter/timestamp behavior;
6. physical A/B/index wiring and signal integrity.

That ordering is a major IO01 result because stale transport data and true zero motion can look identical at the final HAL pin if freshness is not checked separately.

## Evidence status

SOURCE-CONFIRMED at the pinned revision:

- generic successful-read boundary before encoder post-processing;
- timestamp/counter/latch TRAM registration and processing model;
- 16-bit to 64-bit host count extension;
- reset/index zero-offset semantics;
- scale/position publication;
- low-speed velocity timeout behavior;
- control/filter/quadrature-error publication path.

DOC-CONFIRMED:

- public HostMot2 encoder pin/parameter behavior for rawcounts/count/position/velocity/reset/index/scale/vel-timeout.

Not TEST-CONFIRMED in IO01:

- changing encoder samples through production HostMot2 using the stock no-hardware fixture;
- FPGA quadrature decode/filter/timestamp implementation;
- physical encoder signal integrity or maximum edge rate;
- safety-rated feedback behavior.

## Why the experiment was promoted

Pinned `hm2_test` supplies an unchanging compiled-in fake register image and discards writes. It is excellent for registration tests but cannot generate the multi-cycle counter/timestamp/latch transitions needed for IO01 without adding mutable fake-FPGA behavior. That extension is valuable, but belongs in IO03/2000 rather than being hidden inside a foundation-level test and mislabeled as hardware evidence.

## Promotion queue

- exact `hal_extend_counter(...,16)` ambiguity/rate bound — IO03/2000 HIGH;
- mutable fake-LLIO production encoder experiment — IO03/2000 HIGH;
- FPGA quadrature/filter/timestamp implementation — HM05/2000 HIGH;
- illegal A/B sequence and quadrature-error fault injection — IO03/2000 HIGH;
- precise index-arm/event/read latency — IO02/2000 MEDIUM;
- stable-v2.9.10 source comparison — 2000 MEDIUM;
- physical edge-rate/electrical qualification — advanced hardware HIGH;
- plausibility/redundancy/safety architecture — S04/S05/advanced safety CRITICAL.

## Graduation sufficiency

IO01 graduates because its 1000-level objective is the host-side register-to-HAL execution path and its important state transformations. Those are source-grounded and cross-checked against public documentation; failure boundaries are explicit; the adversarial exam passed; and the missing runtime experiment has been honestly classified and promoted rather than simulated. The unresolved items do not invalidate the foundation-level call flow.

## Next critical-path module

Proceed to **IO04 — PWM/PDM command path**. Establish the inverse hardware-output direction: HAL command/configuration -> HostMot2 pwmgen preparation/write -> TRAM/register transport boundary. Preserve the same separation between host-side command generation, FPGA behavior, physical analog/output electronics, and safety.
