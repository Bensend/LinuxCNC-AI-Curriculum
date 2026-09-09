# C08 — Fault to Retained Diagnostic Evidence

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## A. HAL-visible realtime fault trace

```text
realtime producer(s)
  -> update cause / symptom HAL objects
  -> HAL thread dispatch reaches sampler.N at its configured position
       -> sampler.c::sample()
            -> reads configured HAL values into one local record
            -> hal_stream_write()
                 -> copies record
                 -> assigns successful-enqueue sample number
                 -> release-publishes FIFO input index
                 OR, if full:
                 -> increments producer overrun
                 -> returns -ENOSPC
  ... independently ...
userspace halsampler
  -> hal_stream_attach()
  -> hal_stream_wait_readable()
  -> hal_stream_read()
  -> continuity check / typed formatting
  -> stdout/file retained artifact
```

### Ordering claim

Values within one successful sampler invocation are captured together at that function's point in the realtime thread. FIFO publication uses acquire/release index ordering. The trace does **not** tell us that sampler ran after a producer unless thread function order is retained.

### Validity claim

Retain both sides:

- producer: `overruns`, `full`, `curr-depth`, configuration, function order;
- consumer: attach success, stderr, exit/completion, sample tags/raw records.

Consumer tags alone are insufficient because a write rejected by a full FIFO increments producer overrun before a successful-enqueue sample number is assigned.

## B. Task operator-error evidence

Representative rejected-command path:

```text
Task state/command logic detects invalid condition
  -> emcOperatorError(message)
       -> channel-space check
       -> format EMC_OPERATOR_ERROR
       -> rcs_print(message)                 [process/log descendant]
       -> emcErrorBuffer->write(error_msg)   [NML descendant]

userspace UI/script consumer
  -> updateError() / error_channel equivalent
       -> emcErrorBuffer->read()
       -> recognizes EMC_OPERATOR_ERROR_TYPE
       -> copies text to consumer state
       -> UI/script may retain/display it
```

Command result/status is a separate path:

```text
sent command serial
  -> Task status publication
  -> userspace updateStatus()
  -> emcCommandWaitDone()
       -> compare echo_serial_number
       -> EXEC / DONE / ERROR
```

### Cross-surface boundary

The process print, NML error message, command status and realtime HAL trace do not share a universal atomic timestamp. If an experiment combines them, retain collector clocks/timestamps and call the relation **correlated evidence**, not one atomic trace, unless an explicit common synchronization mechanism is introduced and proven.

## Diagnostic decision rule

Use the evidence surface closest to the question:

- topology/object question -> `halcmd`;
- same-cycle HAL ordering -> sampler/Halscope with function-order provenance;
- Task command acceptance/completion -> status NML + serial;
- Task diagnostic publication -> error NML/process log;
- physical state -> independent plant/device measurement in addition to controller evidence.

Never upgrade diagnostic evidence into a safety guarantee.
