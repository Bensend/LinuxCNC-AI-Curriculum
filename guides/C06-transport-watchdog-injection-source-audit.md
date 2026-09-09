# C06 Transport/Watchdog Injection Source Audit

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Why this audit exists

Frozen C06-030 requires deterministic hardware-free separation of communication failure and watchdog-bite state. This note fixes the source semantics that the authoritative lab harness must preserve before implementing fault controls.

## `hm2_test` low-level seam

Pinned `hm2_test.c` is a fake HostMot2 low-level driver. Its stock `hm2_test_read()` copies bytes from the fixture register image and returns success; its stock `hm2_test_write()` ignores writes and returns success. This makes the test driver the narrowest valid place to inject deterministic read failures or alter the fake watchdog register image without modifying generic HostMot2 logic.

The accepted load preflight adds only a new pattern 15. Its watchdog descriptor has base `0x2000`, three registers and 4-byte register stride, so pinned `watchdog.c` resolves:

- timer address = `0x2000`
- status address = `0x2004`
- reset address = `0x2008`

The authoritative fixture's emulated watchdog-bite input therefore belongs at status register `0x2004`, bit 0.

## Watchdog read state machine

Pinned `hm2_watchdog_process_tram_read()` has two early guards before examining watchdog status:

1. return while low-level `io_error` is true;
2. return while `llio->needs_reset != 0`.

Only after those guards does it test `status_reg[0] & 1`. A set bit asserts the real HAL `watchdog.has_bit` pin and sets `llio->needs_reset = 1`.

Consequence: a communication failure that prevents a valid TRAM read cannot itself be scored as an observed watchdog bite. It may contribute causally to a real FPGA watchdog timing out, but LinuxCNC's HAL-visible watchdog assertion requires a successfully received status image and processing past the `io_error` guard.

## Watchdog recovery state machine

Pinned `hm2_watchdog_write()` independently returns while `io_error` is true or while `watchdog.has_bit` remains true. Once the user clears `has_bit`, `needs_reset` is still set, so a healthy write enters the recovery branch: it zeros the status image, force-writes board settings, and clears `needs_reset` only after successful recovery.

Therefore the frozen P5/P6 distinction is source-mandated rather than an arbitrary test convention: clearing transport `io_error` and clearing watchdog `has_bit` are separate actions with separate consequences.

## hm2_eth escalation comparison

LinuxCNC's hm2_eth interface exposes `packet-error`, `packet-error-level`, and `packet-error-limit`. A detected cycle error raises the error level; successful cycles decrement it; reaching the configured limit causes the board `io-error` state and requires manual reset. This error accumulator belongs to the transport driver, not the HostMot2 watchdog parser.

The C06 fake fixture is therefore allowed to use a small deterministic consecutive-failure threshold solely as a laboratory analogue of low-level escalation. The result must not claim that the chosen threshold numerically reproduces a particular hm2_eth deployment; it tests the generic `io_error` boundary and recovery contract.

## Adversarial checks before implementation

1. **Could `io_error=true` and `watchdog.has_bit=true` coexist?** Yes, historically observed state can coexist; the frozen experiment is about causal/observational distinction, not mutual exclusion. P2 requires `has_bit=false` only because watchdog status is deliberately kept clear.
2. **Could packet loss eventually cause a real watchdog bite?** Yes. Distinct state machines can be causally coupled because communication loss can prevent timely watchdog petting. This does not make packet-error evidence equivalent to watchdog-status evidence.
3. **Does watchdog bite prove the whole machine is safe?** No. HostMot2 documentation describes board I/O disconnection/high-impedance behavior while internal firmware module state can continue. External power stages, hydraulics, mechanics, wiring, and safety architecture remain outside this software-only proof.
4. **May the harness set generic `watchdog.has_bit` directly?** No. P4 must inject only the fake status register bit and let an otherwise valid HostMot2 read assert the real exported pin.
5. **May the harness set `io_error` without any failed low-level reads?** Not for P2. The frozen plan requires consecutive injected read failures followed by harness low-level escalation. The controller may clear `io_error` in P3 because recovery action is explicitly part of the frozen phase.

## Implementation constraint

Keep `hostmot2.c`, `tram.c`, `watchdog.c`, and `hostmot2-lowlevel.h` byte-identical to the pin. Add only lab-scoped controls/counters to `hm2_test.c`, retain the complete patch, and observe the exported generic HAL states rather than inventing substitute learner-only status pins.
