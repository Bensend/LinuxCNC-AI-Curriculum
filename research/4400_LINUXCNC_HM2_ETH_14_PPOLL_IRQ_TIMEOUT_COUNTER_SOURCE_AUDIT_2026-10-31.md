# 4000-LC-HM2-ETH-14 — HostMot2 Ethernet receive timing, field regression and counter acceptance

**2026-10-31 | LinuxCNC-first continuation | NON-GRADUATED | source + upstream field history; no local runtime.** Extends [HM2-ETH-11](4400_LINUXCNC_HM2_ETH_11_SPLIT_READ_PACKET_LOSS_STALE_FEEDBACK_SOURCE_AUDIT_2026-10-30.md).

## Questions

Does the development HostMot2 UDP receive path behave like stable v2.9.10? Does real field evidence resolve the previous read-counter-at-deadline corner case? What should a LinuxCNC engineer measure before altering timeout settings?

## Exact provenance

- Development LinuxCNC [`24e84c4506b41634240f7087f0295e361a954886`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886), [`hm2_eth.c` lines 930–1077](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/hm2_eth.c#L930-L1077), blob `4c671e7609294430f85e6fde923e780be46dc81d`; [`hm2_eth_net_posix.c` lines 150–177](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/hm2_eth_net_posix.c#L150-L177), blob `4e8ddb48d688015b0b25b7a2fe4d95c87dbd43d1`.
- Stable [v2.9.10 `hm2_eth.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c), blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`.
- Upstream [issue #4525, `hm2_eth read timeout`](https://github.com/LinuxCNC/linuxcnc/issues/4525), opened 2026-09-13; specifically [report of bisected field behavior](https://github.com/LinuxCNC/linuxcnc/issues/4525#issuecomment-6384780834) and [maintainer's follow-up](https://github.com/LinuxCNC/linuxcnc/issues/4525#issuecomment-6403060242). [PR #4719](https://github.com/LinuxCNC/linuxcnc/pull/4719) proposes receive/CPU-affinity changes; its final merge/deployment status was **not established** in this audit.

## Version-sensitive source path

1. Stable v2.9.10's queued receive uses `recv(..., MSG_DONTWAIT)` with a bounded busy/poll loop and `rtapi_delay(READ_PCK_DELAY_NS)` on negative receives. Development calls a board-selected `eth_socket_recv` with the **remaining** deadline interval; POSIX implementation uses `ppoll(POLLIN, timeout)` followed by `recv` when ready. These have different scheduler/NIC interrupt sensitivity and CPU behavior. **SOURCE-CONFIRMED**, not a universal performance ranking.
2. Development `packet-read-timeout`: a value `<=0` selects 80; values below 100 mean **percentage of `llio.period`**, and the resulting timeout has a 100,000-ns floor. At a 1-ms servo period, the default 80 means an 800,000-ns deadline. It is not 80 ns or 80 µs. **SOURCE-CONFIRMED.**
3. The read packet includes a 16-bit last-write count from communication control and writes then reads back a 32-bit scratch `read_cnt` plus `write_cnt` (lines 949–974). Received data is copied into queued buffers **before** checking read-count validity. The retry predicate is `mismatched_read_cnt && t2 < deadline`; when a full-length mismatched response arrives **at/after** the deadline, that predicate is false. A matching `write_cnt` (or `has_written_cnt=false` during startup) can permit the function to decrement soft errors and return success. **SOURCE-CONFIRMED conditional branch** in both inspected versions. An actual stale/foreign response with those exact counter conditions is **NOT TEST-CONFIRMED**.
4. A wrong-length/timeout response increments `packet-error-total` and `packet-error-level`; below the configured limit, `-EAGAIN` causes generic HostMot2 to skip processing fresh TRAM feedback. Reaching the limit asserts `io-error`. A **full-length** read-counter mismatch at the deadline is not necessarily recorded by that error accounting. A successful return should not be confused with proof that the response was from the intended request.

## Independent field history, correctly classified

Upstream #4525 reports a 7i92 + Smart Serial setup at 1 kHz on PREEMPT_RT with a Realtek `r8169` NIC and no `isolcpus`. The reporter's clean-build bisects and 120-second comparisons distinguish an RT CPU-affinity regression from the `ppoll` receive change. Reported measurements include **9 errors/120 s** at the relevant `ppoll` revision with pinned CPU, versus **0** at the predecessor, and **0** for a proposed polling variant on that machine. The report later distinguishes IRQ/CPU assignment, NIC driver and wakeup behavior. These are **COMMUNITY-REPORTED field tests**, not tests executed by this curriculum; the causal explanation is environment-specific, and the maintainer later suggested keeping nonblocking polling out of a general solution in favor of affinity/NIC corrections. The issue does **not** test the late read-counter mismatch identified above. No claim that the regression affects all Mesa boards, all kernels, or current released LinuxCNC.

## Discriminating engineering diagnostic

Capture LinuxCNC version/commit, Mesa board and Smart Serial topology, INI servo period, `packet-read-timeout`, `packet-error-total`, `packet-error-level`, `io-error`, `read.time`, `read.tmax`, `servo-thread.tmax`, NIC model/driver, IRQ affinity and RT thread affinity. Distinguish **(A)** physical network delay, **(B)** realtime scheduling/IRQ wakeup, **(C)** soft timeout with stale HAL feedback, **(D)** latched `io-error`, and **(E)** conditional full-length read-count mismatch. A missing error counter increment does not prove every read payload was valid under the inspected predicate.

Do not indiscriminately increase timeouts or replace feedback with commanded position: either can mask a bad scheduling/communication condition. For source-level review, a safe proposed acceptance predicate would reject a mismatched read count regardless of deadline, but compatibility/retry policy must be reviewed by upstream maintainers before claiming it is a correct production patch. **No patch or upstream report submitted.**

## Verification and boundaries

The **branch predicate** and version difference are SOURCE-CONFIRMED. Field timing and bisects are COMMUNITY-REPORTED. Actual mismatched full-length response acceptance, physical motion and safe-state behavior remain UNKNOWN; TEST-CONFIRMED none. A future isolated packet replay should freeze a synthetic datagram, matching/mismatching read and write counters, and timestamps just before/at/after deadline; use only the local `[self-hosted, openpressbrake]` runner after dispatch and I/O isolation are established. Do not spend GitHub-hosted minutes. This lab is **not justified yet** solely to reconfirm the predicate; maintainer protocol intent remains an open question. Personnel safety must remain independent of LinuxCNC and Mesa/FPGA control.
