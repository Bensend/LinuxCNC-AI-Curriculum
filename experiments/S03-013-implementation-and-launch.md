# S03-013 — Mutable LLIO Implementation and Launch

Status: **IMPLEMENTED / RUNNING**  
Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Curriculum source commit: `4069107dd0e38cad194d63fc24d037a6c8c5f034`  
Workflow run: `34099929612`

## Why this fixture is valid for the central S03 host-side claim

The stock upstream `hm2_test` driver is intentionally static and discards writes, so it cannot independently distinguish a stale HostMot2 publication from an unchanging fake register file and cannot prove write suppression. Lab 013 therefore patches only the test LLIO implementation while leaving production `hostmot2.c`, `ioport.c`, TRAM logic, HAL GPIO publication, and normal exported `hm2_test.0.read` / `hm2_test.0.write` functions unchanged.

The resulting board is a smallest-valid one-IOPort derivative of upstream test pattern 12. Pattern 12 already supplies the one-port IDROM shape and 24 primary IOPort pin descriptors. Lab 013 adds the missing internally consistent module descriptor and explicit stride fields needed by `hm2_ioport_parse_md()`.

## Exact synthetic IDROM/module descriptor

The fixture uses:

- IDROM type 2 at `0x400`;
- module-descriptor offset 64, so the first descriptor begins at `0x440`;
- pin-descriptor offset `0x200`, so pin descriptors begin at `0x600`;
- one I/O port, 24 pins, 24-bit port width;
- ClockLow 2 MHz and ClockHigh 20 MHz;
- instance stride 0 = 4;
- register stride 0 = `0x100`;
- IOPort base address `0x1000`.

The first module descriptor words are:

- `d0 = 0x01010003`: GTag 3 / IOPort, version 0, ClockTag 1, one instance;
- `d1 = 0x00051000`: base `0x1000`, five registers, stride selectors 0/0;
- `d2 = 0x0000001f`: multiple-register mask required by IOPort.

This matches the pinned IOPort parser's consistency requirement: version 0, five registers, instance stride 4, and multiple-register mask `0x001f`.

## Test-only LLIO observability

The derivative adds only LLIO-side observability/control:

1. `hm2_test.0.s03-input-word` — mutable fake physical IOPort Data readback at `0x1000`;
2. `hm2_test.0.s03-io-error` — HAL RW alias of the exact allocated `llio.io_error` flag tested by production HostMot2;
3. `hm2_test.0.s03-write-count` — count of actual LLIO write callback entries;
4. last write address/word capture for debugging.

The write callback intentionally does **not** feed command data back into the mutable input word; this avoids creating an artificial loopback between command and physical input state.

## Predeclared gates implemented verbatim

### Gate A — harness validity

- normal `hm2_register()` must succeed;
- `hm2_test.0.gpio.000.in` must publish TRUE after the mutable input word becomes bit 0 = 1;
- configuring GPIO 001 as output and commanding it must cause the LLIO write count to become nonzero.

Failure here is HARNESS INVALID and cannot count against S03.

### Gates B/C — persistent communication error

- set the exact LLIO `io_error` TRUE;
- change fake physical input bit 0 from 1 to 0;
- change GPIO 001 command;
- after normal realtime cycles, require GPIO 000 HAL input to remain TRUE and require LLIO write count to remain unchanged.

### Gate D — recovery of host processing

- clear LLIO `io_error`;
- require GPIO 000 input to publish FALSE from the changed backing register;
- require LLIO write count to advance again.

## Evidence boundary

A PASS will independently verify only the pinned **generic HostMot2 host-side** stale-publication/write-suppression/re-entry behavior. It does not model UDP packet loss, socket timeout timing, Ethernet hardware, FPGA state, HostMot2 watchdog bite timing, connector electrical state, Smart Serial remote recovery, drive response, actuator torque, braking, resynchronization safety, or functional safety.

## Documentation/community cross-check

Current LinuxCNC `hm2_eth(9)` documentation explicitly warns that transient packet loss can leave stale feedback visible and describes escalation to a permanent low-level I/O error when `packet-error-level` reaches its limit. It also notes that some HostMot2 special functions do not recover cleanly from packet loss. This supports the importance of the S03 stale-state boundary, but the documentation is not substituted for the production-path host experiment.

## Exact next checkpoint

Inspect workflow `34099929612` by its own artifact and exit code. If registration or baseline publication/write capture fails, classify **HARNESS INVALID**, diagnose the descriptor/build/runtime issue, and do not interpret the stale-state prediction. If Gates A-D pass, commit the accepted result, run the S03 adversarial exam including a stale-but-plausible feedback debugging scenario and a recovery/resynchronization trap, then perform the fresh-AI handoff/counterfactual promotion test before graduation.