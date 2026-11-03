# HM2-182 — POSIX timed receive and HostMot2 decode gate (2026-11-03)

**4000 / NON-GRADUATED.** Source-confirmed conditional implementation path at LinuxCNC development commit `cdf957bd00bbcc4c569f01e7eed5b154422b816c`; no executable or machine result.

## Question and prediction
Does the timed POSIX receive prevent a full-length, wrong-counter reply that completes after the deadline from being decoded? **Pre-inspection prediction:** a timeout passed into `ppoll` constrains the wait for readiness, but not the subsequent `recv` completion timestamp; a counter check conditioned on remaining deadline can therefore admit the reply. Falsifier: a post-receive unconditional counter check, or an independent validation gate before module decode.

## Immutable evidence and function trace
- [hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth.c), `hm2_eth_receive_queued_reads` near lines 1012–1085: deadline derives from `this->read_time + read_timeout`; `eth_socket_recv(..., remaining_ns)` is called only when positive; after a full-length response the queue buffers are copied; mismatch retries only if `confirm_rw_cnt.read_cnt != read_cnt && t2 < read_deadline`. When `t2 >= deadline`, the mismatch is not rejected by that condition. The subsequent write-ack check is **separate** and does not compare the read counter.
- [hm2_eth_net_posix.c](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hm2_eth_net_posix.c), blob `4e8ddb48d688015b0b25b7a2fe4d95c87dbd43d1`, `hm2_posix_eth_socket_recv`: converts nanoseconds to a `timespec`, calls `ppoll(..., POLLIN, &ts, NULL)`; if ready, invokes `recv(sockfd, buffer, len, 0)`. There is **no post-recv monotonic deadline check in this function**. A ready socket does not prove the later `recv` completed before the caller's deadline.
- [hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/cdf957bd00bbcc4c569f01e7eed5b154422b816c/src/hal/drivers/mesa-hostmot2/hostmot2.c), `hm2_read_request` records `read_time` after queuing; `hm2_read` calls `hm2_finish_read`, skips module processing on `-EAGAIN` or asserted `io_error`, otherwise calls watchdog/GPIO/encoder/stepgen and other `*_process_tram_read` functions. **No additional read-counter check appears in this downstream dispatcher.**

## Exact conditional acceptance scenario
1. A request with read counter N is queued; an earlier reply with counter N−1 is available.
2. The POSIX `ppoll` begins with positive remaining time and reports `POLLIN`; `recv` returns a full-length datagram at or after the request deadline. The socket function itself does not recheck time.
3. `hm2_eth_receive_queued_reads` copies the response to TRAM, finds a mismatched read counter, but `t2 < read_deadline` is false. It resets queue and reaches the separate write-ack/error accounting path.
4. **Only if** that path returns a non-`-EAGAIN` result and `io_error` is not set does `hm2_read` proceed to normal module decoding.

**SOURCE-CONFIRMED:** the conditional bypass and missing downstream validation. **INFERENCE:** a delayed `recv` can furnish the required timestamp ordering in an actual system. **UNKNOWN:** actual occurrence frequency, EVL implementation differences, whether all payload fields reflect the older transaction, actual physical machine effects. This is not TEST-CONFIRMED and is not proof of incorrect mechanical position.

## Implementation correction and regression oracle
A review-only fix should compare the echoed read counter **unconditionally** before accepting/committing queued payloads; if mismatched, retry while time remains or return the existing soft-error/`-EAGAIN` path after deadline. Avoid copying unverified bytes to shared TRAM buffers where possible. Preserve the separate write acknowledgment, queue reset, initialization, packet-size, error threshold and counter wraparound semantics.

Deterministic disconnected harness cases: (A) matching packet before deadline => decode once; (B) mismatch before deadline then match => only matching payload decoded; (C) mismatch exactly at deadline => no decode; (D) mismatch after deadline from an earlier `ppoll` readiness => no decode; (E) short packet => no decode; (F) matching read but mismatched write acknowledgment => existing independent write-error behavior; (G) no remaining time before receive => no socket call; (H) `-EAGAIN` => module decoders not invoked. Record monotonic timestamps, both counters, bytes, queue reset, soft errors, LLIO return, io_error and module decode calls. Expected outcomes C/D describe the **desired corrected behavior**, not current test results.

For Mesa mills/routers/plasma/press brakes, document the distinction between read freshness, stepgen command-derived feedback, independent encoders and independent personnel-safety authority. Do not run fault injection on a physical machine.

## Evidence and readiness
No code patch, test, build, lab compute or workflow dispatched. MOTION-144 remains the first executable priority only after independently verified isolation of `[self-hosted, openpressbrake]`; never use GitHub-hosted runners. No graduated course or safety evaluation gate changed. Next: inspect `hm2_eth_net_evl.c` for parity and prototype a source-context review-only patch or rotate to a new LinuxCNC core topic if no new evidence.
