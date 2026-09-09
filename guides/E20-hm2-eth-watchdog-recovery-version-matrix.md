# E20 — hm2_eth / HostMot2 watchdog recovery across versions

Date: 2026-09-10
State: SOURCE / COMMUNITY RESEARCH ACTIVE
Priority: highest unblocked 2000-series prerequisite after S02 technical closure

## Why E20 exists

E20 is not a generic Ethernet troubleshooting lesson. Its purpose is to establish which communication-loss, soft-error, watchdog, `io_error`, and recovery claims are valid for a *specific LinuxCNC version*, and which claims are unsafe to generalize across old releases, 2.9.x, and current master.

The central question is: **after an hm2_eth read/write anomaly, what exact software state changes, what HostMot2/watchdog state changes, what recovery is possible without a process restart, and what evidence is required before re-authorizing motion?**

This is a prerequisite for F02 compound-fault sequencing because a compound-fault state machine must not assume that transport recovery, `io_error` clearing, watchdog reset, physical I/O restoration, and machine-state re-authorization are the same event.

## Source/doc anchors

### Current release anchor: LinuxCNC v2.9.8

Source: `src/hal/drivers/mesa-hostmot2/hm2_eth.c` at tag `v2.9.8`.

Relevant flow in the queued-read path:

1. `hm2_eth_send_queued_reads()` emits the read request and includes confirmation counters in the request set.
2. `hm2_eth_receive_queued_reads()` derives its deadline from `packet-read-timeout`; values below 100 are treated as a percentage of the realtime thread period, with a 100 us lower bound.
3. If the receive size is wrong at the deadline, the queued-read state is cleared and `record_soft_error()` is called.
4. If the read packet arrives, the received read data are copied into queued destinations.
5. The driver checks the returned write-confirmation counter. A mismatch also calls `record_soft_error()`.
6. A clean cycle calls `decrement_soft_error()`.

`record_soft_error()` in v2.9.8:

- sets `llio.needs_soft_reset = 1`;
- sets `packet-error = TRUE`;
- increments `packet-error-total`;
- increments the communication-error accumulator by `packet-error-increment` (minimum 1);
- clamps at `packet-error-limit`;
- publishes `packet-error-level`;
- at the limit, sets `llio.io_error = TRUE` and `packet-error-exceeded = TRUE`.

`decrement_soft_error()` reduces the accumulator by `packet-error-decrement` (minimum 1) on a clean confirmed cycle, clamps at zero, and clears the current-cycle `packet-error`/`packet-error-exceeded` outputs. Thus a single good packet is not equivalent to erasing the accumulated history unless the configured decrement and current level make that true.

Important recovery detail: at the beginning of the receive path, if the accumulator is at the error limit but userspace/HAL has cleared `io_error`, the driver resets the internal communication-error counter to zero. This establishes that `io_error` can participate in a software recovery request, but **clearing it is not by itself evidence that physical outputs are restored, machine position is trustworthy, or motion should be automatically re-authorized.**

Source URL: https://raw.githubusercontent.com/LinuxCNC/linuxcnc/v2.9.8/src/hal/drivers/mesa-hostmot2/hm2_eth.c

### Current master anchor

Current master retains the same high-level soft-error state machine: `record_soft_error()` sets `needs_soft_reset`, current-cycle error, cumulative error count and level, asserts `io_error` at the limit, and `decrement_soft_error()` decays the level after clean cycles.

However, implementation details have already changed relative to v2.9.8. Master uses the newer HAL accessor API, has a revised Ethernet backend abstraction (`hm2_eth_net_*`), and its queued-read confirmation bookkeeping uses a combined read/write confirmation structure plus `has_written_cnt`. The receive implementation also differs: master delegates timeout handling to `eth_socket_recv(board, ..., read_timeout)` instead of v2.9.8's explicit `MSG_DONTWAIT` polling loop.

Therefore a test that depends on exact receive-loop timing, syscall behavior, counter layout, or observable latency must be version-pinned even when the higher-level soft-error contract appears equivalent.

Source URL: https://raw.githubusercontent.com/LinuxCNC/linuxcnc/master/src/hal/drivers/mesa-hostmot2/hm2_eth.c

## Watchdog is a distinct state machine

Stable/current HostMot2 documentation says the watchdog is petted by the HostMot2 write function. When it bites, board I/O pins are disconnected from their module instances and become high-impedance inputs; internal HostMot2 module state is not generally destroyed. Encoder instances may continue counting and step/PWM generators may continue evolving internally even though those generated signals are no longer relayed to the physical pins.

That yields four deliberately separate questions after a communication fault:

1. **Transport state:** did the host receive/confirm the current hm2_eth transaction?
2. **Driver fault state:** what are `packet-error`, level/limit, `packet-error-exceeded`, `needs_soft_reset`, and `io_error`?
3. **Board I/O authority:** has the HostMot2 watchdog bitten, and have pins actually been restored to their configured function after reset?
4. **Machine authorization:** has the control state machine intentionally re-established whatever homing, feedback plausibility, interlocks, and operator acknowledgement are required before motion?

A correct design must not collapse these into one `communication_ok` boolean.

Stable HostMot2 documentation: https://www.linuxcnc.org/docs/stable/html/en/drivers/hostmot2.html
Master hostmot2(9): https://linuxcnc.org/docs/master/html/en/man/man9/hostmot2.9.html

## Documentation/version delta already found

Older HostMot2 documentation (2.5/2.7 era) explicitly said that when the watchdog bites, **all communication with the board stops**, and older text described resetting the watchdog as resuming communication. Current stable/master HostMot2 documentation describes the I/O-pin disconnection and internal-module continuation but no longer presents watchdog bite in that same blanket 'all communication stops' wording.

This wording change is significant enough that E20 must not teach the old documentation sentence as a timeless architectural invariant. The experiment/version matrix must determine the behavior of the actual target revision.

Historical docs:
- https://www.linuxcnc.org/docs/2.5/html/drivers/hostmot2.html
- https://linuxcnc.org/docs/2.7/html/man/man9/hostmot2.9.html

## Community evidence and why it matters

A 2016 LinuxCNC forum thread contains a particularly useful historical warning from Jeff Epler: released 2.7-era hm2_eth did not recover well from a missing request/response packet; the wait could be long enough to miss realtime deadlines and cause the board watchdog to bite. He also noted the deceptive state in which Mesa stepgen feedback could keep changing internally after the watchdog disconnected physical step/direction outputs. This is exactly the sort of cross-layer ambiguity E20 must capture, while treating the report as historical evidence rather than current-version proof.

Thread: https://forum.linuxcnc.org/27-driver-boards/30750-random-read-errors-on-mesa-7i92

A 2020 forum explanation from PCW states that hm2_eth times the Ethernet response against the configured fraction of the servo period and that repeated failures reach an error threshold that disables communication / produces an error. That aligns with the later error-accumulator/limit model and supplies a useful operational observation, but exact defaults and recovery semantics still need source-pinned verification.

Thread: https://forum.linuxcnc.org/38-general-linuxcnc-questions/39375-read-error-and-following-error-mesa-7i96

A 2024 report on LinuxCNC 2.9.1 also shows real systems presenting Ethernet latency and watchdog faults together. Community diagnosis treats watchdog bite as potentially downstream of host latency. This reinforces the need to record temporal ordering rather than infer a single root cause from whichever message is most visible.

Thread: https://forum.linuxcnc.org/27-driver-boards/51223-mesa-i76e-error-finishing-read-another-time-with-linuxcnc-2-9-1

## Initial version matrix

| Surface | 2.5/2.7 documentation/community | v2.9.8 source | current master source/docs | Teaching status |
|---|---|---|---|---|
| Watchdog bite disconnects physical I/O pins | yes | HostMot2 contract | yes | stable high-level claim |
| Internal encoder/step/PWM state can continue while pins are disconnected | yes | HostMot2 contract | yes | stable and safety-relevant |
| Watchdog bite means all board communication stops | explicitly stated in old docs | not accepted from old docs alone | omitted from current wording | **version-sensitive / must test** |
| hm2_eth has current-cycle packet error plus accumulated level/limit | later-era behavior | yes | yes | source-supported for 2.9.8/master |
| Error-level accumulation can assert `io_error` | historical forum describes repeated-fault threshold | yes | yes | source-supported for 2.9.8/master |
| Clean cycles decay accumulated error level | not yet verified for old branch | yes | yes | version-sensitive before generalizing backward |
| Clearing `io_error` can reset saturated internal error counter on next receive | not yet verified for old branch | yes | yes | source-supported for 2.9.8/master; **not motion authorization** |
| Exact receive/deadline implementation | old branch historically poor recovery | explicit nonblocking polling loop | backend receive abstraction | version-sensitive |
| Exact confirmation-counter structure | not yet mapped | separate read/write confirmation fields | combined confirmation structure + `has_written_cnt` | version-sensitive |

## Call-flow model to verify experimentally

For v2.9.8/current-lineage reasoning, the candidate recovery chain is:

```text
servo-cycle HostMot2 read request
    -> hm2_eth send queued reads
    -> receive/check response before deadline
       -> good response + write confirmation
          -> decrement soft-error accumulator
       -> timeout/size mismatch OR write-confirm mismatch
          -> record_soft_error
             -> needs_soft_reset
             -> packet-error/current + total + level
             -> if level reaches limit: io_error + packet-error-exceeded

HostMot2 write path / watchdog petting is related but separate
    -> missed/late effective writes can allow watchdog to bite
    -> watchdog bite disconnects physical I/O pins
    -> internal FPGA module state may continue

Recovery request/observation
    -> clearing io_error may let hm2_eth counter recover
    -> HostMot2 soft reset/watchdog reset path may restore board I/O configuration
    -> machine-level motion authorization must remain a separate explicit decision
```

## Claims E20 must attack adversarially

Do not graduate E20 if the learner accepts any of these without proof:

- `packet-error == FALSE` means the Ethernet link has been healthy for an arbitrary prior window;
- clearing `io_error` proves the board watchdog did not bite;
- a responding ping proves the realtime HostMot2 transaction path is healthy;
- watchdog reset alone proves physical machine state is still synchronized with LinuxCNC state;
- changing internal stepgen/encoder values proves physical output pins were active;
- the old 2.7 'all communication stops' wording is automatically valid on 2.9.8/master;
- one clean cycle authorizes automatic motion restart after a prior communication/watchdog fault;
- `packet-error-level` and HostMot2 watchdog timeout are the same timer/counter.

## Next experiment-design checkpoint

Before implementation, complete a source-level version delta for at least one historical 2.7-era revision, v2.9.8, and the curriculum's pinned current source revision. Then freeze a no-hardware deterministic fault-state model whose phases separately exercise: isolated soft packet error below limit, repeated errors reaching `io_error`, clean-cycle decay, explicit `io_error` clear/recovery request, watchdog-bite state as a separate input, and a deceptive internal-state-continues/physical-authority-lost case. The acceptance gates must forbid automatic motion re-authorization from transport recovery alone.

A real Mesa Ethernet board remains desirable for later validation of exact physical/watchdog recovery timing, but it is not required to establish the software state-machine distinctions first.
