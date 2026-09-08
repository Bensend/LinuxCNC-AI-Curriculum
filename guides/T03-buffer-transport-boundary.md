# T03 — pinned NML buffer and transport boundary

Status: **SOURCE-CONFIRMED configuration boundary; transport internals partly promoted**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Why this matters

A fresh AI must not flatten all LinuxCNC NML observations into one generic "message bus." The pinned stock configuration gives the command, status, and error channels materially different buffer semantics, and the optional server boundary is ordinary userspace IPC rather than realtime servo transport.

## Pinned stock configuration

At the pinned revision, `configs/common/linuxcnc.nml` defines:

```text
B emcCommand SHMEM localhost 8192  ... TCP=5005 xdr queue confirm_write serial
B emcError   SHMEM localhost 8192  ... TCP=5005 xdr queue
B emcStatus  SHMEM localhost 20480 ... TCP=5005 xdr
```

The same file declares the controller process `emc` as read/write on `emcCommand`, writer on `emcStatus`, and writer on `emcError`. `emcsvr` is configured as the master/server-side participant, and the ordinary `xemc` client is configured as writer for commands and reader for status/error.

## Source-grounded engineering implications

### Command is a queued, serialized command stream

The stock `emcCommand` buffer explicitly carries `queue`, `confirm_write`, and `serial` configuration options. Combined with the pinned Python and Task source traced elsewhere in T03, the command path must be reasoned about using command identity/order and semantic result separately.

A successful write/echo proves neither that the command was valid in the current Task state nor that a requested physical effect occurred.

### Status is a snapshot/world-model stream, not a command queue

The stock `emcStatus` buffer does **not** carry the `queue` option. Task periodically writes its aggregate `EMC_STAT`, and clients poll/copy the currently available status image.

Therefore a status sample should be treated as a controller world-model snapshot with an echo serial and aggregate state, not as a guaranteed one-record-per-command event history. A client that needs command causality must correlate serial/state predicates rather than infer it from poll count.

### Error is a separate queued reporting stream

The stock `emcError` buffer explicitly carries `queue`. Task/operator helpers write human/operator reporting there separately from aggregate status.

This explains why "no error returned by one poll" is not interchangeable with semantic success: the error stream has its own consumption timing and is not the Task status field.

T03-020 deliberately captures both matching aggregate ERROR and an independently consumed error-channel tuple for the same negative case.

## Local/remote boundary

The stock buffer declarations are SHMEM-local but include `TCP=5005 xdr`, and `emcsvr` is configured as the server/master participant. Pinned `emcsvr.cc`, already inventoried in the T03 research guide, opens the same named command/status/error channels and runs the NML server infrastructure.

This establishes a bounded architectural claim:

**Remote NML access extends the same ordinary userspace channel model across an NML server boundary; it is not LinuxCNC's realtime motion/servo transport and is not itself physical-feedback or safety evidence.**

## What is not yet claimed

The 1000-level course does not yet claim exact queue depth, overwrite/drop behavior under saturation, reconnect semantics, TCP-loss behavior, or multi-client remote ordering beyond what has been directly source/experiment verified.

Those questions are valuable but require deeper `libnml` transport/buffer internals and fault injection. They are candidates for 2000-level study unless T03 behavioral evidence exposes a contradiction that would invalidate the basic command/status/error teaching.

## Evidence classification

- stock buffer options and process permissions: **SOURCE-CONFIRMED** from pinned `configs/common/linuxcnc.nml`;
- Python serial/echo and `wait_complete()` behavior: **SOURCE-CONFIRMED** in `guides/T03-command-acknowledgement-boundary.md`;
- Task read/status/error ownership and `emcsvr` channel opening: **SOURCE-CONFIRMED** in `guides/T03-nml-architecture-research.md`;
- exact saturation/loss/reconnect semantics: **UNKNOWN / promotion candidate**.

## Fresh-AI rule

When debugging NML, first identify which evidence stream is being observed:

1. command write/serial/echo;
2. aggregate Task/status snapshot;
3. queued operator/error report;
4. downstream motion/I/O state;
5. physical feedback;
6. independent safety state.

Never substitute one for another without a source- or experiment-grounded causal bridge.
