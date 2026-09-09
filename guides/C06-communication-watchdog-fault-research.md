# C06 — Communication / Watchdog Fault Handling — 1000-level Research and Source Pass

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: RESEARCH / SOURCE

## 1000-level objective
Trace the distinction between an hm2_eth host-side communication failure and a HostMot2 FPGA watchdog bite, identify the HAL-visible evidence and recovery boundaries, and build a reproducible generic fault experiment without claiming functional-safety guarantees.

## Official documentation findings
Current LinuxCNC HostMot2 documentation says the firmware watchdog is petted by the HostMot2 write function. If the timeout expires, board I/O pins are disconnected from their module instances and become high-impedance inputs; module state such as encoder counters and generators may continue internally, but generated signals are no longer relayed to motors. The documented default watchdog timeout is 5 ms.

Current hm2_eth documentation separately defines `packet-read-timeout` and packet-error escalation. A timeout value <=0 means 80% of the thread period; values below 100 are percentages; larger values are nanoseconds, with a 100 us minimum. The documentation warns that too-short timeout can create spurious errors while too-long timeout can create realtime-delay errors. Communication errors may accumulate until `io-error` becomes TRUE and requires manual reset.

These are two related but non-identical mechanisms: transport/read health is host-side hm2_eth state; watchdog timeout is FPGA-side loss of timely pet/write activity.

### Documentation-divergence warning
The LinuxCNC documentation currently presents a material wording divergence. The current stable/master **HostMot2 driver guide** describes a watchdog bite as disconnecting the board I/O pins from module instances and leaving internal module state running, but does not say that all communication stops. The current `hostmot2(9)` **man-page text**, like older HostMot2 documentation, still says that when the watchdog bites, "all communication with the board stops." The pinned source used by this course contains a host-side path that can process watchdog status after a successful low-level read and later perform `hm2_force_write()` recovery.

Therefore C06 does **not** teach "watchdog bite itself proves communication stopped" as an invariant. The contradiction exists even among current official documentation surfaces, not merely between old and new releases. For diagnostic reasoning, prefer the pinned implementation and the actual board/firmware contract being tested; treat the blanket communication-stop wording as a statement requiring version/firmware-specific verification rather than using it as an inference from `watchdog.has_bit` alone.

## Pinned source findings
### `src/hal/drivers/mesa-hostmot2/hm2_eth.c`
Pinned `receive_queued_reads()` derives the effective receive timeout from `packet-read-timeout`, enforces the 100 us minimum, calls the Ethernet receive routine, and on wrong-sized/failed receive resets queued reads and records a soft communication error. `record_soft_error()` increments/clamps `comm_error_counter`; at `packet-error-limit` it sets low-level `io_error` TRUE and exports packet-error-exceeded state. Clearing `io_error` permits the receive path to reset a counter that had reached the limit.

Default pinned parameters observed in source:
- `packet-read-timeout = 80` (percent-of-thread semantics)
- `packet-error-limit = 10`

### `src/hal/drivers/mesa-hostmot2/watchdog.c`
`hm2_watchdog_process_tram_read()` deliberately returns early while low-level `io_error` is asserted. Otherwise it checks the watchdog status bit; a bite sets HAL `watchdog.has_bit` and `llio->needs_reset`.

`hm2_watchdog_write()` also returns while `io_error` is asserted or `has_bit` remains asserted. On normal service it enables the watchdog. If reset state is pending after the user clears the relevant condition, it calls `hm2_force_write()` to restore FPGA configuration, aborting recovery if `io_error` reappears. It warns if `timeout_ns < 1.5 * period_ns`.

`hm2_watchdog_force_write()` programs the watchdog timeout and clears watchdog status. The pinned default `watchdog.timeout_ns` is 5,000,000 ns.

## Initial call/failure flow
```text
servo thread
  -> hm2 board read/request path
     -> hm2_eth queued receive
        -> receive succeeds
           -> packet error state can decay
           -> HostMot2 TRAM data processed
           -> watchdog status may be observed
        -> receive fails/times out
           -> reset queued reads
           -> record_soft_error()
           -> packet-error-level rises
           -> at packet-error-limit: io-error = TRUE

later HostMot2 write service
  -> if io-error: watchdog write/recovery path returns
  -> otherwise normal write activity services board and watchdog

FPGA watchdog independently measures elapsed servicing time
  -> timeout expires
  -> watchdog bites
  -> external I/O pins disconnect/become inputs
  -> status eventually observed when communication permits
  -> watchdog.has_bit = TRUE; needs_reset = 1
  -> user clears condition
  -> hm2_force_write() attempts configuration recovery
```

## Important non-equivalences
```text
one packet error != permanent io-error
io-error != necessarily watchdog.has_bit
host receive timeout != proof FPGA watchdog bit
watchdog bite != proof communication has stopped in the tested driver/firmware contract
watchdog bite != proof physical machine reached a safe state
I/O pins becoming inputs != complete machine functional-safety architecture
clearing a HAL fault != proof external plant state is safe to resume
```

## Community leads (not authoritative)
LinuxCNC forum examples show users observing the hm2_eth `packet-error`, `packet-error-level`, `packet-error-limit`, `packet-read-timeout`, and `io_error` pins on real Mesa Ethernet systems. One field discussion warns that hiding stale-feedback packet errors by substituting commanded position for feedback may avoid following-error trips but can mask real problems; this is retained only as a community-reported diagnostic/safety lead, not a design recommendation.

A 2016 developer discussion provides a useful causal example: a missing hm2_eth read response could delay realtime processing long enough that a Mesa watchdog might subsequently bite. A 2025 field report likewise pairs watchdog indications with network/realtime troubleshooting. These are retained as community/developer experience, not normative behavior. They support a causal chain `transport/timing problem -> delayed watchdog service -> possible watchdog bite`, but never the state identity `packet error == watchdog bite`.

## Source questions for next pass
1. Locate exactly where HostMot2 generic read/write functions call the low-level queued hm2_eth operations and where watchdog prepare/process functions sit in TRAM ordering.
2. Trace `io_error`, `needs_reset`, `needs_soft_reset`, packet-error and watchdog status from low-level driver through HAL-visible pins.
3. Determine a deterministic laboratory fault-injection method that does not require physical Ethernet hardware. Prefer a test seam or mock low-level interface over timing-dependent host-network disruption.
4. Freeze an experiment before implementation that distinguishes at least: transient packet error, escalated `io-error`, watchdog-bite state, and recovery.

## Safety boundary
C06 is about LinuxCNC/HostMot2 fault behavior and observability. It does not establish a safety function. Before any physical-machine application, actual output electrical states, drives/valves, energy removal, external safety hardware, restart interlocks, and applicable safety standards require independent engineering verification.