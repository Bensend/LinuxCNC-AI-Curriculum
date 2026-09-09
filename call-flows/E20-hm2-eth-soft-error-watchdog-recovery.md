# E20 call flow — hm2_eth soft-error accumulation versus HostMot2 watchdog recovery

Date: 2026-09-10
Scope: LinuxCNC 2.9.x/current-lineage reasoning; exact implementation remains version-pinned.

## v2.9.8 queued-read path

Source: `src/hal/drivers/mesa-hostmot2/hm2_eth.c`, tag `v2.9.8`.

```text
HostMot2 realtime read phase
  -> llio.send_queued_reads = hm2_eth_send_queued_reads()
     -> appends confirmation reads
     -> send UDP request

  -> llio.receive_queued_reads = hm2_eth_receive_queued_reads()
     -> if saturated comm_error_counter but io_error was externally cleared:
          comm_error_counter = 0
     -> derive packet-read-timeout
          <=0 => 80% convention
          <100 => percentage of llio.period
          result bounded below by 100 us
     -> poll nonblocking receive until expected-size packet or deadline

     timeout / wrong packet size
       -> clear queued read bookkeeping
       -> record_soft_error()
          -> needs_soft_reset = 1
          -> packet-error = 1
          -> packet-error-total++
          -> comm_error_counter += max(packet-error-increment, 1)
          -> clamp to packet-error-limit
          -> packet-error-level = accumulator
          -> at limit:
               io_error = 1
               packet-error-exceeded = 1
               return failure
          -> below limit: soft failure remains recoverable by later cycles
       -> return -EAGAIN or hard-failure result at limit

     expected-size response
       -> copy queued read data
       -> reject stale/mismatched confirmation until deadline where possible
       -> compare returned write confirmation
          mismatch -> record_soft_error()
          match    -> decrement_soft_error()
                       comm_error_counter -= max(packet-error-decrement,1)
                       clamp at 0
                       packet-error-level = accumulator
                       packet-error = 0
                       packet-error-exceeded = 0
```

## Current master delta

Current master preserves the same conceptual soft-error accumulator but changes implementation details:

- receive timing is delegated through the newer `eth_socket_recv(board, ..., read_timeout)` network backend;
- HAL values use accessor functions;
- confirmation bookkeeping is a combined read/write structure;
- `has_written_cnt` prevents comparison against uninitialized write-confirmation state;
- queue-reset handling is factored into a helper.

Therefore tests of *state transitions* can be shared conceptually, but tests of exact timing/syscall/packet-loop behavior must be version-specific.

## Separate HostMot2 watchdog flow

```text
HostMot2 write function executes often enough
    -> watchdog is petted
    -> board I/O pins remain mapped to configured module instances

write/pet is absent too long
    -> watchdog bites
    -> physical I/O pins disconnect from module instances / become input state
    -> internal FPGA module state generally continues
       (encoders can count; step/PWM state can continue internally)

watchdog reset / soft reset
    -> restores board pin configuration according to driver/firmware contract
    -> does NOT itself prove:
         physical actuator followed prior commands
         machine geometry remained valid
         feedback is fresh/independent
         homing/state assumptions remain valid
         machine-level motion is authorized
```

## Authority boundary

`packet-error`, `packet-error-level`, `packet-error-exceeded`, `io_error`, `needs_soft_reset`, and watchdog state are related evidence surfaces, not aliases.

A machine recovery state machine needs explicit stages such as:

```text
TRANSPORT_FAULT
  -> transport transactions become healthy again
DRIVER_RECOVERY
  -> io_error / soft reset handling completed
BOARD_IO_RECOVERY
  -> watchdog/pin authority explicitly known/restored
STATE_REVALIDATION
  -> machine-specific feedback/homing/interlocks revalidated
REAUTHORIZE
  -> deliberate machine-level decision to permit motion
```

Collapsing these stages into `if (!packet_error) enable_motion` is the primary E20 adversarial anti-pattern.

## Evidence needed for the frozen experiment

The first deterministic E20 experiment should sample one realtime record containing at least:

- phase;
- injected transaction error;
- current-cycle packet-error model;
- packet-error-total;
- packet-error-level;
- packet-error-exceeded;
- io_error;
- explicit external io_error-clear request;
- needs-soft-reset;
- watchdog-bit model;
- board-physical-I/O-authority model;
- internal-generator-state model;
- machine-reauthorize output.

Producer-side recorder continuity/overrun evidence is required before exact cycle-latency claims are accepted.
