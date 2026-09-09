# E20 — hm2_eth / HostMot2 watchdog recovery across versions

Date: 2026-09-10
State: SOURCE / COMMUNITY RESEARCH ACTIVE
Priority: highest executable 2000-series prerequisite after S02 technical closure

## Why E20 exists

E20 establishes which communication-loss, soft-error, watchdog, `io_error`, and recovery claims are valid for a *specific LinuxCNC version*. A compound-fault state machine must not assume that transport recovery, `io_error` clearing, watchdog reset, physical I/O restoration, state revalidation, and machine motion re-authorization are the same event.

## Version anchors

### Historical recovery anchor — 2015 / 2.7-era lineage

Commit `554fa0f3cc3ec05cf9a70ef077cdebb32b23e004` (2015-10-10, Jeff Epler) is itself evidence of recovery evolution: its commit message says hm2_eth previously could crash `rtapi_app` when packets were lost because queued counters were not reset after failed receive.

The source at that commit is materially different from current 2.9.x. `hm2_eth_receive_queued_reads()` waits as long as **200 ms** for a queued-read receive, then on wrong size only clears `queue_reads_count` / `queue_buff_size` and returns failure. There is no later `record_soft_error()` accumulator in this path, no current-cycle `packet-error` / error-level decay model, and no `io_error` threshold transition visible in this implementation. The same file's ordinary `hm2_eth_read()` also uses a 200 ms retry window.

Nearby history shows active repair of the transport behavior: `36a814575560f75d8e388023a060b5e4a56d1388` added probe socket-error handling, `214c71b96393f3ccc2e01a0342dcd84abcf612ca` changed blocking/nonblocking socket assumptions, and `c02b3481d8ab72cc776f3d7ca98b576af1538670` added time for a probe response after `-EAGAIN`.

**Teaching consequence:** historical forum reports about long stalls, deadline loss and watchdog bites are consistent with source of that era and must not be silently projected onto current 2.9.x.

Historical source: https://github.com/LinuxCNC/linuxcnc/blob/554fa0f3cc3ec05cf9a70ef077cdebb32b23e004/src/hal/drivers/mesa-hostmot2/hm2_eth.c

### Current 2.9.x release-line anchor — v2.9.10

As of 2026-09-10, v2.9.10 is the current 2.9.x release anchor used by this lesson. Its queued-read path contains the later soft-error state machine also seen in v2.9.8.

`record_soft_error()`:

- sets `llio.needs_soft_reset = 1`;
- sets current-cycle `packet-error = TRUE`;
- increments `packet-error-total`;
- increments the communication-error accumulator by `packet-error-increment` (minimum 1);
- clamps at `packet-error-limit`;
- publishes `packet-error-level`;
- at the limit, asserts `llio.io_error` and `packet-error-exceeded`.

`decrement_soft_error()` decreases the accumulator by `packet-error-decrement` (minimum 1) on a clean confirmed cycle, clamps at zero, publishes the level, and clears current-cycle `packet-error` / `packet-error-exceeded`. Therefore one clean cycle can coexist with nonzero accumulated error history.

At the beginning of `hm2_eth_receive_queued_reads()`, if the accumulator is saturated but HAL/userspace has cleared `io_error`, the internal communication-error counter is reset. That establishes an explicit software recovery interaction, but **clearing `io_error` is not evidence that physical I/O authority, machine geometry, feedback validity, or motion authorization have been restored.**

The v2.9.10 receive path also uses the configurable packet-read timeout derived from the realtime period rather than the historical fixed 200 ms queued-read wait. Confirmation reads are used to reject/identify wrong or stale transactions.

Source: https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c

### Curriculum-pinned / current-master lineage

The curriculum's previously pinned current source was `8bf4605ae81042248add031e94c77300406e0413`; current master must still be treated as moving evidence, not as a release contract.

Current master preserves the high-level soft-error accumulator but changes implementation details: newer HAL accessors, a revised `hm2_eth_net_*` backend, combined read/write confirmation bookkeeping, `has_written_cnt`, and receive timeout handling delegated through `eth_socket_recv(board, ..., read_timeout)` instead of the 2.9.x polling implementation.

Therefore a test of the *state machine* can be shared conceptually across current lineage, while tests of exact receive-loop latency, syscall behavior, packet structure or confirmation layout remain version-pinned.

## Watchdog is a separate state machine

Stable/current HostMot2 documentation says the watchdog is petted by the HostMot2 write function. When it bites, board I/O pins are disconnected from their module instances and become high-impedance inputs; internal HostMot2 module state is not generally destroyed. Encoder instances can continue counting and step/PWM generators can continue evolving internally even though generated signals are no longer relayed to the physical pins.

That yields four distinct questions after a communication fault:

1. **Transport:** was the current hm2_eth transaction received and confirmed?
2. **Driver fault state:** what are `packet-error`, error level/limit, `packet-error-exceeded`, `needs_soft_reset`, and `io_error`?
3. **Board I/O authority:** has the watchdog bitten, and are physical pins actually restored to their configured module functions?
4. **Machine authorization:** have machine-specific homing/state, feedback plausibility, interlocks and acknowledgement/revalidation requirements been deliberately re-established?

A correct architecture must not collapse these into one `communication_ok` boolean.

Stable HostMot2 documentation: https://www.linuxcnc.org/docs/stable/html/en/drivers/hostmot2.html
Master hostmot2(9): https://linuxcnc.org/docs/master/html/en/man/man9/hostmot2.9.html

## Documentation wording delta

Older 2.5/2.7 HostMot2 documentation explicitly said that when the watchdog bites, **all communication with the board stops**, and described resetting the watchdog as resuming communication. Current stable/master documentation retains the physical-I/O disconnection/internal-state distinction but no longer states the same blanket communication-stop rule.

E20 therefore treats the old sentence as a **historical/version-sensitive statement**, not a timeless invariant.

Historical docs:
- https://www.linuxcnc.org/docs/2.5/html/drivers/hostmot2.html
- https://linuxcnc.org/docs/2.7/html/man/man9/hostmot2.9.html

## Community evidence

A 2016 LinuxCNC forum discussion by Jeff Epler describes released 2.7-era hm2_eth as recovering poorly from a missing request/response packet: the wait could be long enough to lose realtime deadlines and allow the board watchdog to bite. He also highlighted the deceptive condition in which Mesa stepgen feedback could keep changing internally after the watchdog disconnected physical step/direction outputs. The historical source above explains why that report must be treated as era-specific rather than current proof.

Thread: https://forum.linuxcnc.org/27-driver-boards/30750-random-read-errors-on-mesa-7i92

A 2020 explanation from PCW describes hm2_eth timing the response against a configured fraction of the servo period and repeated failures accumulating toward a fault threshold. That aligns with later error-level/limit source behavior, but exact defaults and recovery semantics remain source-pinned.

Thread: https://forum.linuxcnc.org/38-general-linuxcnc-questions/39375-read-error-and-following-error-mesa-7i96

A 2024 LinuxCNC 2.9.1 report shows Ethernet latency and watchdog faults appearing together, with community diagnosis treating watchdog bite as potentially downstream of host latency. This reinforces the need for temporal ordering rather than treating whichever diagnostic is most visible as the root cause.

Thread: https://forum.linuxcnc.org/27-driver-boards/51223-mesa-i76e-error-finishing-read-another-time-with-linuxcnc-2-9-1

## Version matrix

| Surface | 2015 / 2.7-era lineage | v2.9.10 | current master | Teaching status |
|---|---|---|---|---|
| Watchdog bite disconnects physical I/O pins | documented | HostMot2 contract | documented | stable high-level claim |
| Internal encoder/step/PWM state can continue while pins are disconnected | documented/community | HostMot2 contract | documented | stable and safety-relevant |
| Watchdog bite means all board communication stops | old docs say yes | not accepted from old docs alone | omitted from current wording | **version-sensitive / must test** |
| Queued-read wait model | fixed ~200 ms loop in inspected 2015 source | realtime-period-derived packet timeout | backend receive abstraction | **strong version delta** |
| Current-cycle packet error + accumulated level/limit | absent from inspected historical queued-read path | yes | yes | later-lineage source contract |
| Clean cycles decay accumulated error level | absent from inspected historical path | yes | yes | later-lineage source contract |
| Saturated counter can reset after external `io_error` clear | absent from inspected historical path | yes | yes | later-lineage recovery interaction; **not motion authorization** |
| Confirmation bookkeeping | minimal queued response | explicit confirmation reads/counters | combined structure + `has_written_cnt` | version-sensitive |
| Packet-loss robustness | historical commits explicitly repair crashes/probe behavior | later fault accumulator | later backend | historically evolved; never assume timeless behavior |

## Call-flow model for current 2.9.x

```text
servo-cycle HostMot2 read request
  -> hm2_eth send queued reads + confirmations
  -> receive/check response before configured deadline
       clean response + confirmation
         -> decrement soft-error accumulator
       timeout/size/confirmation anomaly
         -> record_soft_error
             -> needs_soft_reset
             -> packet-error/current + total + level
             -> at limit: io_error + packet-error-exceeded

HostMot2 write / watchdog pet is related but separate
  -> insufficient effective petting can allow watchdog bite
  -> watchdog bite removes physical pin authority
  -> internal FPGA module state may continue

Recovery
  -> explicit io_error clear can permit driver accumulator recovery
  -> HostMot2/watchdog reset can restore board I/O configuration
  -> machine state revalidation remains separate
  -> motion reauthorization remains an explicit machine-level decision
```

## Adversarial claims E20 must reject

- `packet-error == FALSE` proves the Ethernet link was healthy over an arbitrary prior window;
- clearing `io_error` proves the board watchdog did not bite;
- a successful ping proves realtime HostMot2 transaction health;
- watchdog reset proves physical machine state is synchronized with LinuxCNC;
- changing internal stepgen/encoder values proves physical output pins were active;
- old 2.7 watchdog/communication wording is automatically valid on v2.9.10/master;
- one clean transaction authorizes automatic motion restart;
- `packet-error-level` and watchdog timeout are the same counter/timer;
- a modern recovery result can be backported conceptually to the historical 200 ms implementation without source evidence.

## Experiment-design checkpoint reached

The historical/current source delta is now sufficient to freeze the first no-hardware experiment. It must model **v2.9.10/current-lineage state distinctions**, not pretend to reproduce Ethernet physics or old 2.7 timing. Required phases: baseline; isolated soft packet error below limit; a clean cycle that clears the current-cycle error while accumulated history remains; repeated errors reaching `io_error`; explicit `io_error` clear/driver recovery; watchdog bite as a separate input; deceptive internal-state-continues while physical-I/O-authority is absent; board authority restoration without machine authorization; and explicit state revalidation before reauthorization.

A real Mesa Ethernet board remains desirable later for physical/watchdog/timing validation. Software-only evidence must not claim physical stopping or functional-safety performance.
