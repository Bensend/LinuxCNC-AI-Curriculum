# MOTION-213 — HostMot2 read failure, feedback publication and write continuity (2026-11-04)

**Scope:** 4000 LinuxCNC implementation, NON-GRADUATED. **Pin:** LinuxCNC development `cdf957bd00bbcc4c569f01e7eed5b154422b816c`. **Evidence:** SOURCE-CONFIRMED conditional control flow; runtime behavior NOT TESTED. This complements, rather than supersedes, HM2-178/180/187 and MOTION-212.

## Source call chain
- [hostmot2.c lines 77–123](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hostmot2.c#L77-L123): `hm2_read_request` enqueues TRAM/raw/TP reads, sends request and timestamps `read_time`. `hm2_read` clears `read_requested` before checking `io_error`. A `-EAGAIN` from `hm2_finish_read` returns **before** encoder/stepgen/GPIO HAL publication. Latched `io_error` likewise returns before publication.
- [tram.c lines 153–189](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/tram.c#L153-L189): `hm2_finish_read` passes negative transport results through unchanged; zero maps to `-EIO`; positive maps to zero. Note `hm2_read` explicitly tests **only** `-EAGAIN` before the separate `io_error` test. Therefore a hypothetical `-EIO` with `io_error` still false would not by itself stop the process-read functions; whether a real transport path can produce that combination is UNKNOWN.
- [hm2_eth.c lines 984–1077](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L984-L1077): missing/short queued reply resets queue, increments soft-error counter and returns `-EAGAIN` while under limit; when threshold reached it sets `io_error` and returns zero. A full-sized response copies queued bytes into TRAM buffers **before** checking read counter; mismatch retries only while `t2 < read_deadline`. The prior HM2-180 analysis already covers deadline-edge stale acceptance; this lesson adds the **servo publication/write** consequence, not a new proof of that defect.
- [hostmot2.c lines 126–174](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hostmot2.c#L126-L174): `hm2_write` has its own `io_error` early return but **no direct check of whether this cycle's read succeeded**. It prepares stepgen/PWM/GPIO and queues writes if `io_error` is false.

## Derived servo-cycle behavior (INFERENCE from separately scheduled HAL functions)
In a configuration ordered `hm2.read → motion → PID → hm2.write`, a recoverable Ethernet read timeout (`-EAGAIN`, below the configured error threshold) leaves last-published feedback pins unchanged. HAL still executes motion and PID functions in their declared order; `hm2.write` can run because the error latch remains false. Thus the command may be computed from feedback older than one cycle. **This is a feedback-freshness gap, not proof of a physical runaway, and not proof that every timeout transmits a write.** The FPGA watchdog and machine configuration can change outcomes; independent personnel-safety authority is outside this software path.

When the soft-error threshold is reached, `io_error` becomes true, preventing read publication and causing the subsequent `hm2.write` function to return. Clearing `packet-error` counters is not equivalent to proving fresh feedback or a physically stopped actuator. A full-length mismatched response accepted at the deadline may instead be processed as apparently valid, as previously identified in HM2-180.

## Minimal disconnected exercise (no machine)
Freeze a hypothetical servo sequence with an encoder at 5.000 mm at tick N-1 and a commanded target of 5.100 mm at N. Inject one `-EAGAIN` read at N while error count remains below limit. Expected source-path result: encoder HAL pin still 5.000 mm; motion/PID consume that pin; write function is eligible to prepare outputs. Do **not** invent PID voltage or physical position without the actual gains and drive model. At N+1 inject a valid fresh reply: the encoder pin updates again. Repeat with a threshold-reaching timeout: `io_error` true, write returns early.

## Verification matrix
| Case | Injection / inspection | Source-predicted observable | Boundary |
|---|---|---|---|
| A | successful queued read | process-read functions publish HAL feedback | conditional SOURCE |
| B | short/missing reply, under soft limit | -EAGAIN; process-read skipped | SOURCE |
| C | same B with servo addf ordering | prior HAL feedback available to motion/PID | INFERENCE; no run |
| D | same B, io_error remains false | hm2.write eligible; no read-success gate | SOURCE |
| E | soft limit exceeded | io_error latched; read/write early return | SOURCE |
| F | manually clear io_error | does not itself prove data freshness | SOURCE/INFERENCE |
| G | full-size wrong read counter before deadline | retry; TRAM copy happens before retry | SOURCE |
| H | full-size wrong counter at/after deadline | potentially accepted; see HM2-180 | SOURCE conditional |
| I | -EIO while io_error false | hm2.read lacks explicit non-EAGAIN guard | SOURCE branch; reachability UNKNOWN |

## Implementation guidance
For a real configuration, inspect `addf` ordering and the **actual** `joint.N.motor-pos-fb` producer; record transport `io_error`, packet-error total/level and watchdog status alongside command, feedback and following error. Treat a repeated feedback value as ambiguous: a stationary axis and a missed network update can look identical without a freshness counter or independent sample. Design a disconnected, instrumented fault-injection test before claiming that motion follows stale data in a particular LinuxCNC release. No change to qualified machine enable, physical output wiring or safety logic is authorized.

**Unresolved:** Does `hm2_eth` ever return a non-`-EAGAIN` negative value without setting `io_error`? What precisely is the output/FPGA watchdog state after one or multiple missed replies? Requires pinned transport branches and executable disconnected verification. No build, simulation, machine, Actions, lab compute or evaluator used.
