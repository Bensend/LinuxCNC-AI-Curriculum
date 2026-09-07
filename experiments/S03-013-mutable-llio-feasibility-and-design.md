# S03-013 — Mutable LLIO Feasibility and Experiment Design

Status: **DESIGN / FEASIBILITY COMPLETE; production-path experiment still pending**  
Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Determine whether the stock LinuxCNC HostMot2 test infrastructure can independently verify the S03 prediction that persistent LLIO `io_error` stops fresh module publication and suppresses normal HostMot2 writes, leaving previously published HAL feedback visible until communication resumes.

The experiment must exercise the real HostMot2 read/write path. It must not be presented as an Ethernet, FPGA, drive, or physical-safety test.

## Predeclared prediction carried from the call-flow guide

Once a known fresh HostMot2 value has been published, asserting LLIO `io_error` before the next `hm2_read()` should leave that previous HAL value unchanged even if fake backing data changes. `hm2_write()` should likewise produce no low-level write while `io_error` remains asserted. Clearing `io_error` and completing a successful cycle should allow fresh publication and low-level write activity to resume.

Failure of either central prediction blocks S03 graduation until explained.

## Stock `hm2_test` source audit

Pinned source: `src/hal/drivers/mesa-hostmot2/hm2_test.c`.

### Read behavior

`hm2_test_read()` copies bytes directly from `me->test_pattern.tp8[addr]` into the supplied buffer and returns success. The backing register image is initialized from the selected test pattern and is not exposed as a runtime-mutable register model.

### Write behavior

`hm2_test_write()` explicitly discards all four relevant inputs (`this`, `addr`, `buffer`, and `size`) and returns success. Therefore the stock driver has no write-state model and no write-capture oracle.

### Intended scope of the fixture

The source comment describes `hm2_test` as providing *unchanging, compiled-in information*. The upstream `tests/hm2-idrom` suite uses it to feed malformed/static registration patterns to `hm2_register()` and verify validation behavior. This makes it a good registration fixture, but not a state-transition fixture.

## Feasibility result

**The stock fixture is insufficient for S03-013.**

It cannot satisfy either half of the experiment:

1. it cannot mutate a TRAM-backed register after a known fresh publication in a controlled runtime cycle; and
2. it cannot prove write suppression because successful calls to `hm2_test_write()` leave no observable record.

Using an unchanged stock fixture and merely observing an unchanged HAL value would be circular and invalid: the test board is designed to be unchanging regardless of `io_error`.

Likewise, treating the callback's unconditional success as evidence that a command reached any modeled board state would be invalid because the callback throws the command away.

## Smallest valid extension

The correct no-hardware test is a **test-only mutable LLIO derivative** that preserves production HostMot2 logic while adding observability below it.

Required fixture capabilities:

1. Start from a valid HostMot2 registration image containing the smallest usable TRAM-backed module (IOPort is preferred because one input bit and one output bit are sufficient).
2. Preserve normal `hm2_register()` and normal exported HostMot2 read/write functions.
3. Back LLIO reads with mutable register storage.
4. Expose a test-only control capable of changing one backing input register value between cycles.
5. Expose a test-only control capable of asserting/clearing `llio.io_error` without changing the HostMot2 implementation.
6. Record each LLIO write as at least `(address, size, count)` and preferably retain the most recent payload.
7. Keep the observable test controls in the LLIO test driver, not in `hostmot2.c`, so the implementation under test is not modified to manufacture the expected result.

## Required sequence

### Gate A — registration and fresh baseline

- Register the fake board successfully through normal `hm2_register()`.
- Run normal HostMot2 read processing.
- Prove a known backing IOPort input value appears at its HAL input pin.
- Change an output command and prove LLIO write capture advances.

If either baseline observation fails, the harness is **INVALID** and no S03 behavior may be inferred.

### Gate B — stale publication under persistent error

- Change the backing input register to the opposite value.
- Assert `llio.io_error` before the next HostMot2 read.
- Execute the same normal read function.
- Require the HAL input to retain the previously published value rather than the newly changed backing value.

### Gate C — write suppression

- Record the LLIO write-capture count.
- Change the corresponding HAL output command while `llio.io_error` remains asserted.
- Execute the normal HostMot2 write function.
- Require the LLIO write-capture count not to advance.

### Gate D — recovery

- Clear `llio.io_error`.
- Execute a successful read/write cycle.
- Require the changed backing input to become published.
- Require LLIO write capture to resume.

## Evidence boundaries

A passing S03-013 can establish only the **generic HostMot2 host-side behavior** at the pinned revision:

- persistent LLIO error prevents fresh module publication through the normal read path;
- the previous HAL value can therefore remain visible but stale;
- persistent LLIO error suppresses normal HostMot2 write delivery to the LLIO callback;
- clearing the error permits subsequent host read/write processing to resume when the fixture itself succeeds.

It cannot establish:

- actual UDP loss/timeout behavior;
- packet-error timing on a physical Ethernet interface;
- FPGA register state or watchdog timing;
- connector voltage/current/high-impedance behavior;
- servo-drive response, STO state, torque removal, braking, stopping time, or functional safety;
- safe resynchronization of a real machine after communication recovery.

## Adversarial harness checks

1. **Constant-fixture trap:** if the backing input was never mutated, an unchanged HAL pin is not evidence of stale publication.
2. **Write-count trap:** count only actual LLIO write callback entries; do not use host command-pin changes as evidence of delivery.
3. **Error timing trap:** assert `io_error` before the tested `hm2_read()`/`hm2_write()` call, not afterward.
4. **Recovery trap:** successful host processing after clear does not prove real hardware resynchronization.
5. **Instrumentation trap:** do not patch `hm2_read()` or `hm2_write()` with branches that directly encode the expected behavior; instrumentation belongs below HostMot2 in the fake LLIO.
6. **Module-validity trap:** malformed IDROM/module descriptors make the experiment a registration test, not a communication-loss test.

## Decision

Do **not** weaken the experiment to fit stock `hm2_test`. Construct the smallest valid mutable IOPort LLIO derivative or locate an already-valid upstream fixture that can be extended without changing HostMot2 itself.

This is still current-level work because the stale-publication/write-suppression prediction is central to S03. It is not safe to promote the entire independent verification requirement to 2000.

## Exact next checkpoint

Inspect the pinned `hm2_test.c` final IDROM patterns plus the IOPort module-descriptor format in `hostmot2.h`/`ioport.c`. Build a new valid test pattern containing one IOPort instance, then add only three test hooks: mutable register storage, an `io_error` control, and LLIO write capture. Put the resulting production-path test in `lab-jobs/013-s03-hostmot2-stale-state.sh`. A failing registration is HARNESS INVALID and must be fixed before testing the S03 prediction.