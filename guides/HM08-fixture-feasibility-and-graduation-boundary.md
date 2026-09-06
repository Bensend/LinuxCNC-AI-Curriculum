# HM08 fixture feasibility and 1000-level graduation boundary

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Question

Can the existing upstream no-hardware `hm2_test` fixture execute a meaningful production HostMot2 watchdog bite/recovery experiment without inventing a fake hardware watchdog model?

## Findings

### What `hm2_test` actually provides — SOURCE-CONFIRMED

`src/hal/drivers/mesa-hostmot2/hm2_test.c` describes itself as a low-level I/O driver with unchanging compiled-in information. Its read callback copies bytes from a static test-pattern register file. Its write callback discards address/data/size and always returns success. Its reset callback also simply returns success.

The fixture has test patterns 0–14 aimed at progressively malformed/limited IDROM registration cases. The most complete inspected patterns establish IDROM metadata and pin descriptors, but no existing pattern supplies a watchdog module descriptor plus mutable watchdog status/timer/reset registers.

After constructing a pattern, the driver assigns the static read/success-stub write callbacks and calls the real production `hm2_register()`.

### Upstream test intent — SOURCE-CONFIRMED

`tests/hm2-idrom/README` says the fixture exists to test `hm2_register()` using a fake AnyIO board with a static register file. The associated test matrix checks registration diagnostics. Repository search found no upstream watchdog-specific `hm2_test` test.

### Why the proposed bite/recovery experiment is not minimal

A test that merely adds a watchdog module descriptor could legitimately exercise production watchdog parsing/export and establish the exported default timeout in a fake-board registration path. But the stronger proposed gates require more:

- synthetic status-bit detection requires the fake register file to change after registration or a new control path that mutates it;
- user-clear -> force-write recovery requires observing production writes and distinguishing timer/status/reset writes, whereas the existing write callback intentionally discards them;
- realistic bite progression would require invented timer/pet semantics that the fixture does not model.

Adding mutable status injection plus a write-capture register model would materially change the fixture from its current static-registration purpose. Adding timer expiry/bite behavior would go further and create a simulation of FPGA behavior. Such a simulation could test host-side logic only if carefully labeled, but it cannot validate physical bite timing, electrical output state, watchdog effectiveness, or safety behavior.

## Experiment decision

**PROMOTE** the fake-LLIO watchdog state-transition experiment to **2000 / MEDIUM** rather than modify the upstream fixture during HM08 1000-level work.

Reason: HM08's foundation objective—understanding watchdog software architecture, cycle ordering, visible state, reset gating, and safety boundary—is already source/documentation grounded. The missing no-hardware experiment would not validate the consequential physical behavior and requires invasive fixture instrumentation. It therefore does not materially improve the 1000-level conclusion enough to justify pretending the current static fixture is a watchdog emulator.

A future 2000-level experiment may add an explicitly test-only LLIO register model and verify production host-side functions. It must declare that the injected status bit is synthetic and must not claim FPGA timing/electrical behavior.

## Additional integration evidence

Current example configurations wire `hm2_*.watchdog.has_bit` into an `estop-latch` fault input. This is useful configuration evidence that the HAL pin is intended to participate in machine fault handling, but it is not evidence that the HostMot2 watchdog or the resulting estop chain is safety-rated.

## 1000-level graduation sufficiency

HM08 can proceed to adversarial exam/corrections/handoff without this experiment because:

1. production source establishes parse/export, read detection, ordinary write pet preparation, timeout programming, user-clear recovery gating, `hm2_force_write()` recovery, and `io_error` boundaries;
2. official documentation independently establishes the public timeout/`has_bit` model and describes board-side high-impedance behavior;
3. the physical/electrical claim remains only DOC-CONFIRMED and is explicitly promoted to representative-hardware commissioning;
4. the fake fixture cannot strengthen that physical claim;
5. no downstream 1000-level module needs a fabricated watchdog timer model.

## Promotion queue additions

- Fake-LLIO mutable-register production watchdog host-state experiment: **2000 / MEDIUM**.
- Representative-board bite latency, output electrical state, firmware-specific behavior: **advanced hardware/commissioning / CRITICAL**.
- Safety architecture using watchdog/estop chain: **advanced safety / CRITICAL**.
