# IO05 experiment decision — Smart Serial analog packing without hardware

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Determine whether existing upstream no-hardware infrastructure can exercise the production `hm2_sserial_write_pins()` path strongly enough to verify analog numeric scaling/packing without inventing remote-device behavior.

## Fixture audit

Pinned `hm2_test.c` is a no-hardware LLIO driver with an unchanging compiled-in register image. Its read callback copies bytes from that static image; its write callback discards address/data and always reports success.

The upstream `tests/hm2-idrom` fixture explicitly uses this fake board to exercise HostMot2 registration against static test patterns. Repository code search of `tests` found no Smart Serial-specific test fixture.

## Why stock `hm2_test` is insufficient

A production-path Smart Serial analog test would need, at minimum:

1. a valid Smart Serial module descriptor and pin routing;
2. mutable command/data/status registers so startup/wait/Do-It transitions can occur;
3. a remote identity and descriptor table that discovery code can read;
4. write capture for remote process-data words and command/CS registers;
5. deterministic prior-command-clear and error status so `hm2_sserial_write_pins()` reaches normal state 3;
6. an oracle for expected packed signed/unsigned/boolean fields.

Stock `hm2_test` supplies none of the mutable Smart Serial protocol behavior and discards writes, so it cannot observe the output register image.

## Decision

**PROMOTE — 2000/HIGH.**

A redesigned mutable fake Smart Serial remote could exercise production host packing and fault-state logic and would be valuable advanced verification. However, building that fixture is materially larger than the IO05 1000-level interface-pattern objective and would constitute a new synthetic remote model.

The future experiment must be labeled narrowly: it can TEST-CONFIRM host-side production scaling/packing/state transitions. It cannot establish FPGA Smart Serial timing, remote firmware correctness, DAC transfer, physical +/-10 V accuracy, analog-enable terminal behavior, amplifier response, or functional safety.

## 1000-level sufficiency impact

This promotion does not block IO05 graduation because:

- public 7I77 Smart Serial interface semantics are documented;
- the production host source path from descriptors through HAL creation, clamp/scale/packing and TRAM is directly traced;
- no current-level safety claim depends on simulated physical behavior;
- the absence of a suitable existing fixture is explicitly recorded rather than papered over with a stand-alone reimplementation.
