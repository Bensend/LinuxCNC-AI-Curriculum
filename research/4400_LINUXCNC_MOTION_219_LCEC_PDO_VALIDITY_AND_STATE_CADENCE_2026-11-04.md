# MOTION-219 — LinuxCNC-EtherCAT PDO validity versus AL-state cadence (4000; NON-GRADUATED)

Date: 2026-11-04. Scope: source inspection only; no runtime, hardware, compute, or Actions.

## Provenance and dependency
Third-party **sittner/linuxcnc-ethercat**, pinned master commit `225d5a3589a7cf8ccb8ee9edc894c1ddad4a7b13` (2026-08-07 archive notice). This is **not** LinuxCNC core and this archived tree is not automatically the recommended maintained deployment branch. Inspect deployment fork and IgH master version separately before implementing a machine. Primary sources: [master.c](https://github.com/sittner/linuxcnc-ethercat/blob/225d5a3589a7cf8ccb8ee9edc894c1ddad4a7b13/src/master.c), [main.c](https://github.com/sittner/linuxcnc-ethercat/blob/225d5a3589a7cf8ccb8ee9edc894c1ddad4a7b13/src/main.c), [lcec.h](https://github.com/sittner/linuxcnc-ethercat/blob/225d5a3589a7cf8ccb8ee9edc894c1ddad4a7b13/src/lcec.h). Previous prerequisite: MOTION-213 through MOTION-218 on stale feedback and scheduling. Blob SHAs observed: master.c `e6b984b4a647ec1a1211d4c857521b3e52873856`, main.c `7a9b603a6e9e547aeb605e8d26b8df88a8c43f91`, lcec.h `e5a5a6a92c8599c8cb8ccd43fa9c69419ad23005`.

## Source call chain
1. `main.c` exports per-master `lcec.<master>.read`/`write` and aggregate `lcec.read-all`/`write-all` HAL realtime functions (lines 294–318). HAL thread order is configured by the machine; exporting functions does not schedule them.
2. `master.c:lcec_read_master` (lines 350–410) invokes distributed-clock cycle start; checks `state_update_timer`; under mutex calls `ecrt_master_receive`, `ecrt_domain_process`, and *only on state-check cycles* `ecrt_master_state`; subsequently updates master HAL state and calls each slave's `proc_read`.
3. `master.c:lcec_write_master` (lines 413–457) invokes each slave's `proc_write`, queues domain with `ecrt_domain_queue`, calls pre-send DC callback, `ecrt_master_send`, then post-send callback.
4. `lcec.h` defines `LCEC_STATE_UPDATE_PERIOD=1000000000LL` ns. Master and slave AL state are therefore periodically sampled, **not per-cycle acknowledgments**. At 1 ms servo period the intended check cadence is approximately 1 s, not 1 ms.

## Key finding and bounded inference
In the inspected `lcec_read_master` body there is **no call to `ecrt_domain_state`**, no examination of domain working-counter status, and no branch that gates slave `proc_read` on a freshly verified working counter or operational state. `proc_read` is invoked on every read cycle when registered. `lcec_write_master` similarly queues/sends without a local domain-working-counter gate. Thus the inspected top-level code does **not establish per-cycle PDO validity**, even when the master/slave state HAL pins report OP. This does **not prove** that the underlying IgH master fails to handle bad frames or that every device-specific callback publishes stale data; those paths remain uninspected.

The source exposes AL/master fields such as `slaves_responding`, `link_up`, `state_op`, `all_op`, and slave `online`/`operational` through HAL data structures. These represent **bus/AL state**, not a verified freshness timestamp for every PDO. The exact exported HAL names and global aggregation semantics must be verified in the corresponding initialization and update functions before using them in a machine HAL file. Do not invent `working-counter` or `pdo-fresh` pins.

## Practical disconnected exercise
Assume servo period 1 ms, last state poll at t=0, last good process data at t=200 ms, and a lost PDO exchange at t=201 ms. At t=201 ms, the lcec read path still invokes `ecrt_master_receive`/`ecrt_domain_process` and slave `proc_read`; the cached AL state may still show OP until the next state poll. **Prediction:** OP cannot be used to certify that t=201 ms PDO bytes are fresh. **Unverified:** whether those bytes retain their prior values or are changed by IgH/device-specific handling. Compare `ecrt_domain_state` working-counter status and slave-specific input handling against the actual IgH revision to settle this.

## Implementation walkthrough / diagnostic matrix
- Inspect actual HAL function order with `halcmd show thread`: require receive/read before motion/PID, write/send after, according to selected driver configuration. A different order changes latency and observability.
- Log per-cycle motion command, motor-position feedback, lcec master AL status, and separately obtained IgH domain WC status with a common cycle counter. Do **not** treat slow AL updates as PDO-validity proof.
- Cases for independent review: (A) OP+good WC, (B) OP+bad WC for one cycle, (C) OP+bad WC for 100 cycles, (D) slave SAFEOP while master link up, (E) unplugged cable between state polls, (F) servo deadline overrun with otherwise good WC. For each distinguish transport validity, data age, physical motion, and controller following error. No expected runtime outcome is claimed for unexecuted cases.
- Machine-specific safety interlocks must retain independent personnel-safety authority; software feedback-validity instrumentation is diagnostic and not a safety-rated stop.

## Evidence ledger
| Claim | Evidence | Status |
|---|---|---|
| HAL read/write function exports | pinned main.c lines 294–318 | SOURCE-CONFIRMED |
| receive/process then slave proc_read | pinned master.c lines 376–408 | SOURCE-CONFIRMED |
| domain queue/send after proc_write | pinned master.c lines 435–457 | SOURCE-CONFIRMED |
| AL state update interval 1e9 ns | pinned lcec.h constant and master.c timer | SOURCE-CONFIRMED |
| No per-cycle domain_state/WC gate in inspected top-level read/write | complete inspected functions | SOURCE-CONFIRMED narrow |
| Specific stale PDO byte behavior and actual exported pin spellings | IgH/device/init paths not yet inspected | OPEN |
| Runtime EtherCAT behavior | no execution | NOT TESTED |

## Next checkpoint
Trace pinned `master.c` HAL initialization/update functions and `src/slave.c` pin exports; inspect actual IgH `ecrt_domain_state` and `ec_domain_state_t` working-counter semantics plus device callback. If archived branch is not representative, identify maintained fork/version and compare before making deployment guidance. Produce a minimal HAL ordering example only after validating actual names. If unavailable, rotate to LinuxCNC trajectory planner source. No graduated-level or evaluation-gate change.
