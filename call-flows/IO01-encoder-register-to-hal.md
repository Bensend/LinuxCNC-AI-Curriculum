# IO01 — encoder register-to-HAL call flow

Course level: 1000
LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Evidence: SOURCE-CONFIRMED unless otherwise marked.

## Scope

This trace covers the generic HostMot2 host-side read cycle for incremental encoder state. It begins at the exported HostMot2 realtime read function after an LLIO transaction is requested and ends at encoder HAL publication. It does not prove FPGA quadrature decoding, electrical signal integrity, physical edge-rate margin, or safety-rated feedback.

## 1. Realtime entry: `hm2_read()`

`src/hal/drivers/mesa-hostmot2/hostmot2.c` exports a per-board HostMot2 `read` function. On each invocation:

1. If the low-level driver has no outstanding read request, `hm2_read()` calls `hm2_read_request()`.
2. `hm2_read_request()` stores the current HAL thread period into `llio->period`, queues the normal TRAM read plus raw/TPPWM reads, calls the transport-specific queue/read hook, marks `read_requested=true`, and records `read_time`.
3. Back in `hm2_read()`, `read_requested` is cleared.
4. If `llio->io_error` is already asserted, processing returns without publishing newly interpreted encoder state.
5. `hm2_finish_read()` completes the LLIO/TRAM transaction. A temporary `-EAGAIN` returns immediately without processing the module buffers. A persistent/transport error which asserts `io_error` likewise stops publication.

The key ordering boundary is therefore: **encoder state is interpreted only after the generic TRAM/LLIO read has completed successfully enough to pass these gates.**

## 2. Module post-read ordering

After successful completion, `hm2_read()` calls module post-processing functions in a fixed source order. At the pinned revision the sequence begins:

`watchdog -> GPIO -> encoder -> inmux -> ...`

The encoder step is:

`hm2_encoder_process_tram_read(hm2, period)`

This function consumes buffers that were populated by the already completed TRAM transaction. It is not itself performing Ethernet/PCI register I/O.

## 3. Encoder TRAM image and registration order

`hm2_encoder_parse_md()` allocates/registers encoder read regions. The timestamp-count region is registered before the per-instance counter/timestamp regions and the latch/control regions. The source explicitly requires this order so event timestamps can be interpreted relative to the sampled timestamp counter.

At runtime, the post-read code therefore observes one coherent host-side TRAM image produced by the generic read cycle, subject to the guarantees/limitations of the selected LLIO transport.

## 4. Per-instance count reconstruction

`hm2_encoder_process_tram_read()` iterates configured encoder instances and delegates to the per-instance processing path.

The normal count path calls `hm2_encoder_instance_update_rawcounts_and_handle_index()`:

- extracts the FPGA-facing 16-bit encoder count;
- calls `hal_extend_counter(..., 16)` against prior host state;
- maintains an internal 64-bit `rawcounts_64` accumulator;
- publishes the public `rawcounts` representation;
- checks latch/index completion state and reconstructs the latched count against prior count history.

This makes ordinary 16-bit register wrap a host-side reconstruction problem rather than a public 16-bit rollover. It does **not** prove that arbitrarily large inter-read jumps are unambiguous; that limit is promoted to IO03/2000.

## 5. Reset/index zero-offset path

`hm2_encoder_instance_update_position()` applies logical zeroing after raw-count reconstruction:

- when HAL `reset` is asserted, `zero_offset_64` is moved to the current accumulated raw count;
- logical count becomes `rawcounts_64 - zero_offset_64`;
- the physical FPGA counter is not reset by this host operation;
- when an armed index latch completes, the reconstructed latched count can become the new zero offset unless `no-clear-on-index` is selected;
- the index handshake clears the public `index-enable` indication after the event is consumed.

Thus `rawcounts` and logical `count/position` intentionally represent different state domains.

## 6. Position and scale publication

The internal 64-bit logical count is divided by encoder `scale` to publish floating-point `position`. A zero scale is treated as invalid and repaired to 1.0 rather than being used as a divisor.

The public s32 count pins should not be mistaken for the precision/storage width used internally for long-travel position reconstruction.

## 7. Velocity publication

The per-instance read processor implements STOPPED/MOVING state rather than deriving velocity from a single adjacent sample only.

- A new event while stopped initializes event-history state and enters MOVING.
- A new edge while moving updates the extended count and event timestamp and computes velocity from displacement/time.
- A one-edge direction reversal is forced to zero velocity to suppress an edge-balancing spike.
- No new edge while MOVING does **not** immediately publish zero. The current timestamp counter bounds how fast the encoder could still be moving without another edge. Reported velocity can decay until `vel-timeout` is reached.
- At/after `vel-timeout`, velocity/rpm become zero and the host state returns to STOPPED.

The thread `period` supplied to `hm2_encoder_process_tram_read()` is part of this host-side timing context; event timing is primarily based on HostMot2 timestamp registers rather than simply `delta_count / servo_period`.

## 8. Control/latch publication

The returned control/latch register also carries filtered A/B/index status and quadrature-error information. `hm2_encoder_read_control_register()` publishes those HAL-visible states. A quadrature-error bit is evidence that the HostMot2 path reported an invalid sequence; it does not identify the physical root cause.

## 9. Failure branches

### `io_error` before or after read completion

`hm2_read()` returns before encoder post-processing. Previously published HAL encoder values can therefore remain visible while communications are faulted; downstream logic must not equate an unchanged value with proven fresh hardware feedback.

### `hm2_finish_read() == -EAGAIN`

The current invocation returns without consuming the TRAM image. This is a temporary-read path, not evidence of a new encoder sample.

### Host count-extension ambiguity

The 16-bit-to-64-bit extension assumes sampling sufficiently often to disambiguate the counter delta. Exact ambiguity/rate bounds remain promoted.

### Electrical/FPGA faults

This call flow starts after FPGA register state exists. It does not validate quadrature waveform quality, input filtering, firmware decode correctness, or physical maximum edge rate.

## 10. Complete normal path

```text
HAL realtime thread
  -> hm2_<board>.read / generic hm2_read()
      -> [if needed] hm2_read_request()
          -> hm2_tram_read() queue setup
          -> LLIO queue/read request
      -> hm2_finish_read()
          -> LLIO/transport completes TRAM buffers
      -> io_error / EAGAIN gates
      -> hm2_watchdog_process_tram_read()
      -> hm2_ioport_gpio_process_tram_read()
      -> hm2_encoder_process_tram_read(hm2, period)
          -> per encoder instance
              -> extend 16-bit hardware count into 64-bit host state
              -> consume index/latch completion
              -> update/reset zero offset
              -> publish raw/logical count + scaled position
              -> update timestamp-based velocity state machine
          -> publish control/filter/quadrature-error state
      -> remaining HostMot2 module post-read processors
```

## Evidence boundary for the no-hardware fixture

Upstream `hm2_test` is a real low-level I/O driver used to exercise production HostMot2 registration without hardware, but at the pinned revision its `read()` merely copies bytes from an unchanging compiled-in test-pattern array and its `write()` discards data and returns success. It has no runtime encoder/event/timestamp model.

Consequently, a multi-cycle IO01 experiment that changes encoder count, timestamp, latch, or control state cannot be obtained from the fixture without adding mutable fake-FPGA behavior. Such an extension could still be valuable at 2000 level, but it would test a synthetic register producer plus the production host processing path—not FPGA quadrature capture or hardware behavior.

## Fresh-AI debugging rule

When an encoder HAL value looks frozen, first determine which boundary is stale:

1. Was the HostMot2 `read` function invoked?
2. Did the LLIO read complete, or did `-EAGAIN`/`io_error` skip processing?
3. Did the TRAM register image change?
4. Did host 16-bit extension/zeroing/velocity state transform it as expected?
5. Only then move outward to FPGA capture and physical A/B/index signals.

That sequence avoids blaming scaling or motion control for transport freshness failures, and avoids blaming Ethernet/PCI when the register image is fresh but the host-side encoder state machine is the actual issue.
