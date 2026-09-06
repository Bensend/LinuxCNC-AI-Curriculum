# IO01 — no-hardware encoder experiment feasibility

LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Decision: **PROMOTE** production-path mutable encoder experiment to IO03/2000.

## Question

Can the existing upstream fake-LLIO fixture exercise production HostMot2 encoder processing across multiple samples without inventing substantial FPGA behavior?

## Upstream fixture facts

Pinned `src/hal/drivers/mesa-hostmot2/hm2_test.c` describes itself as a low-level I/O test driver providing unchanging compiled-in information with no hardware.

Its LLIO callbacks are decisive:

- `hm2_test_read()` copies bytes directly from `me->test_pattern.tp8[addr]` into the requested buffer and returns success.
- `hm2_test_write()` ignores the address, buffer, and size and returns success.
- the test-pattern array is populated during module initialization from the selected static pattern.

The upstream `tests/hm2-idrom` suite uses this fixture specifically to exercise `hm2_register()` against a static fake AnyIO register file.

## Consequence for IO01

The host encoder state machine needs register state to change across reads in order to discriminate:

- 16-bit counter wrap extension;
- reset zero-offset behavior after movement;
- position scaling as counts evolve;
- event timestamp changes;
- the MOVING/no-new-edge `vel-timeout` transition;
- index/latch arm/complete handshakes.

The stock fixture supplies no mechanism for those runtime transitions. Because writes are discarded, production HostMot2 control writes also cannot cause a modeled fake board state change.

## Alternatives considered

### 1. Copy encoder algorithms into a standalone test
Rejected for evidence purposes. It could test a reimplementation, not the production `encoder.c` path.

### 2. Patch production encoder functions to expose internals
Rejected at 1000 level. This is invasive and risks changing the behavior under test.

### 3. Extend `hm2_test` with mutable register injection/write capture
Technically viable and the preferred future approach. A minimal advanced fixture could expose controlled register-image mutation while retaining the production `hm2_read()` -> TRAM -> `hm2_encoder_process_tram_read()` path. However, timestamp/event/index progression would still be synthetic, and any FPGA/electrical claim would remain invalid.

## Decision

Under the curriculum's investigation-control rule, the no-hardware experiment is **PROMOTE**, not an IO01 graduation blocker.

Reason:

- IO01's 1000-level objective is the host-side register-to-HAL architecture and normal execution path.
- Documentation and pinned source establish that path directly.
- The existing upstream test fixture is structurally incapable of generating the required multi-cycle encoder register transitions.
- Creating a mutable fake FPGA is valuable but is a higher-depth test-harness project rather than necessary evidence for the foundation-level call flow.

## Promotion target

**IO03 / 2000 — HIGH**

Build a mutable `hm2_test`-derived fixture that can inject counter/timestamp/control snapshots and capture control writes while invoking the production HostMot2 read path. Use it to test wrap ambiguity boundaries, reset/index behavior, velocity timeout, stale/frozen samples, illegal quadrature indicators, and recovery/freshness behavior. Explicitly label all generated register sequences synthetic.

## Evidence classification

- Stock fixture immutability: **SOURCE-CONFIRMED**.
- Inability of stock fixture to exercise changing encoder samples: **SOURCE-CONFIRMED / INFERENCE from fixture contract**.
- Proposed mutable-fixture design: **INFERENCE / future experiment**.
- Physical encoder/FPGA behavior: **UNKNOWN / not tested**.
