# MOTION-229 — HostMot2 Ethernet TRAM receive validity and index feedback (4000, NON-GRADUATED)

## Question and scope
After the MOTION-228 FPGA index-latch handshake, what happens if the Mesa Ethernet queued read times out, or if a full-length packet is received but its transaction counter is wrong? Does LinuxCNC process the encoder index-clear indication? This investigation concerns LinuxCNC **v2.9.10**, not an unverified current/development version. It does not assert physical index-capture latency.

## Immutable provenance (read directly)
- [hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c), blob `75619ae3f6925087a6693c5421bbf629f4459d94`, lines ~77–124: `hm2_read_request` and `hm2_read`.
- [tram.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/tram.c), blob `d060f6cbb448b98f8d42bb54ccb76037e07f765e`, lines ~130–188: TRAM pointers, queued reads, and `hm2_finish_read`.
- [hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c), blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`, lines ~899–962: `hm2_eth_receive_queued_reads`.
- [MOTION-228 encoder latch/clear](4400_LINUXCNC_MOTION_228_HOSTMOT2_INDEX_LATCH_CLEAR_2026-11-05.md), encoder.c blob `9719d41419da9220761637e002024cdc9d17a8ba`: driver clears HAL index-enable only after processing returned latch/control bits.

## Source-confirmed call chain
`hm2_read_request` enqueues TRAM reads, then `hm2_read` calls `hm2_finish_read`. On `-EAGAIN`, `hm2_read` **returns before** `hm2_encoder_process_tram_read`. On latched `io_error`, it also returns before processing. Thus a recoverable read failure prevents that cycle's encoder processing and HAL index-enable acknowledgement; the FPGA may still have captured the index independently. This is a **host observation delay**, not evidence that the physical pulse was missed.

The Ethernet receive routine allocates a temporary packet buffer, retries nonblocking receives until the expected packet length arrives or the deadline is reached, and clears queue metadata on length failure. If `record_soft_error` returns a recoverable result, it returns `-EAGAIN`; `hm2_read` skips the encoder processing. When the configured error policy latches `io_error`, the path instead blocks further processing until reset/recovery.

**Subtle ordering boundary:** on a full-length receive, the routine copies each queued slice from the temporary packet into its destination buffer **before** checking `confirm_read_cnt != read_cnt`. If the counter differs *and* the timestamp is still before the deadline, control returns to receive another packet; a later valid packet can overwrite the first copy. If the counter differs at/after the deadline, this loop is not reentered. The visible source does not enforce a final counter-equality check before returning. Therefore full packet length alone is not sufficient proof that the copied data belongs to the expected transaction. This is a conditional source-level diagnostic concern, **not** a demonstrated hardware malfunction. It also means that a transient mismatch can modify TRAM memory even when no subsequent encoder callback runs, depending on the eventual return path.

`tram.c` assigns each TRAM entry's destination pointer into a persistent contiguous `tram_read_buffer`. No buffer clearing is shown in the inspected receive-failure path. Therefore on a skipped read the previous published HAL encoder state remains until another processing path updates it; do not claim the entire buffer is guaranteed immutable in every failure scenario because the full-length/mismatched-counter path may have already copied bytes.

## Disconnected inspection exercise (not executed)
```sh
git clone https://github.com/LinuxCNC/linuxcnc.git
cd linuxcnc && git checkout v2.9.10
grep -nE 'hm2_read\(|hm2_finish_read|hm2_encoder_process_tram_read' src/hal/drivers/mesa-hostmot2/hostmot2.c
grep -nE 'hm2_finish_read|receive_queued_reads|tram_read_buffer' src/hal/drivers/mesa-hostmot2/tram.c
sed -n '899,965p' src/hal/drivers/mesa-hostmot2/hm2_eth.c
```
Review-only matrix; do **not** inject faults into a connected machine:

| Scenario | Expected source path | What may be concluded |
|---|---|---|
| No packet of expected size before deadline, recoverable soft error | `-EAGAIN` -> early return | No encoder callback this cycle; no new HAL index-clear acknowledgement |
| Repeated failure latches `io_error` | blocked read/processing | Host I/O fault, not proof FPGA did/didn't capture index |
| Full-length correct counter before deadline | queued slices copied, counter accepted | Encoder callback may process returned index latch |
| Full-length wrong counter with time remaining, then correct packet | first slices copied, retry, then overwritten | Intermediate TRAM mutation possible; eventual accepted data determines processing |
| Full-length wrong counter at/after deadline | slices copied; retry condition false | **Potential acceptance of mismatched data** in inspected source; requires independent executable/transport verification |
| Correct packet but encoder latch bit still armed | encoder callback executes but does not clear index-enable | No observed qualified FPGA index event yet |

## Practical diagnostic consequences
Capture the thread order and `hm2_*.io_error`/packet-error counters alongside `joint.N.index-enable`, encoder raw counts, and homing state. A stuck index-enable with communication errors cannot distinguish missing hardware index from delayed host acknowledgement. For a real Mesa configuration, check `hm2_*.read` before `motion-controller` and `hm2_*.write` afterward; do not bypass independent personnel safety or use live fault injection. A proposed software fix must validate counter, payload bounds and packet provenance **before** copying into TRAM destinations and must be tested on a disconnected harness before hardware deployment.

## Evidence ledger
**SOURCE-CONFIRMED (v2.9.10):** early return on `-EAGAIN`; queued-copy-before-counter-validation; deadline-gated retry; persistent TRAM destination pointers; index clear requires encoder callback. **INFERENCE:** host-observation delay and conditional mismatch acceptance. **NOT RUN:** packet-injection test, compilation, simulated machine, hardware, GitHub Actions. **UNKNOWN:** actual transport incidence, FPGA capture timing, stable/development parity, whether a deployment has additional mitigations. Reconcile with prior HM2-180/184/185 and MOTION-213 before proposing a patch; do not call this a newly reproduced defect.

## Next
Rotate to 3100 mill probing (G38.x interpreter→motion probe input/abort and real HAL/INI example) for higher information gain. Retain the conditional Ethernet counter-boundary issue as a targeted, version-pinned verification item, not an endless homing subseries. No hosted Actions; only justified tagged self-hosted compute. Graduated/blind/independent safety gates unchanged.
