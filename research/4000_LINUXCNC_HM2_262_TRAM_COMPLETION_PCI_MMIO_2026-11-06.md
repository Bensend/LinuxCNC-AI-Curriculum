# HM2-262 — TRAM completion, stale-buffer guard and PCI MMIO boundary (4000; 2026-11-06)

**Status:** SOURCE-CONFIRMED (LinuxCNC v2.9.10), NON-GRADUATED. No runtime execution, board access or physical motion. Continues HM2-261; corrects its unresolved return-translation question.

## Reproducible source provenance

- [tram.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/tram.c), `hm2_tram_read` lines 149–163, `hm2_queue_read` 165–174, `hm2_finish_read` 176–185, `hm2_finish_write` 207–216; Git blob `d060f6cbb448b98f8d42bb54ccb76037e07f765e`.
- [hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hostmot2.c), blob `75619ae3f6925087a6693c5421bbf629f4459d94`, `hm2_read` ~98–126 and `dummy_queue_read` ~1195.
- [hm2_eth.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_eth.c), blob `1c338be89cb9620a0b6f23c8c21c5e137afaabdc`, `hm2_eth_receive_queued_reads` ~900–961.
- [hm2_pci.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_pci.c), blob `a2082286e8cdd61b72da1e9fc41b11ba449e51da`, `hm2_pci_read` ~214 and `hm2_pci_write` ~228, callback registration ~734–738.

## Return path — an important subtlety

`hm2_finish_read` returns zero when no receive callback exists. With a callback, negative returns are forwarded unchanged; a **zero** receive return emits an error and becomes **-EIO**; positive returns become zero (success). In `hm2_read`, the result is compared **only** to `-EAGAIN`, then `io_error` is checked. Thus a threshold Ethernet read returns 0 from the transport, becomes -EIO in TRAM, but the common read does **not** directly branch on -EIO; it branches on the concurrently asserted `io_error`. This establishes the actual reason feedback processing is suppressed at the threshold. It is incorrect to say that -EIO itself stops the realtime feedback chain.

| Ethernet outcome | Transport return | TRAM finish | Common read behavior | Feedback published? |
|---|---:|---:|---|---|
| Short reply, below limit | -EAGAIN | -EAGAIN | early return | no |
| Short reply, reaches limit | 0, sets io_error | -EIO | io_error early return | no |
| Full reply, confirmed write | 1 | 0 | process feedback | yes |
| Full reply, write-confirm mismatch below limit | 1 if soft-error counter remains below limit | 0 | process feedback | **yes, despite accumulated error** |
| Full reply, write-confirm mismatch at limit | 0, sets io_error | -EIO | io_error early return | no |

**Crucial distinction:** a write-counter mismatch after a full-size read is not automatically equivalent to invalid *read* data. Source copies the queued read bytes into TRAM buffers **before** checking the write counter; below the error threshold the feedback processors still run. Do not infer write success from the presence of fresh read feedback.

## Buffer semantics

Ethernet receives into a stack-local `tmp_buffer` and copies each queued slice into its destination only when `recv == queue_buff_size`. The short-read path resets queue bookkeeping without copying. TRAM read entry pointers are assigned to offsets of a persistent `tram_read_buffer` in `tram.c` ~128–132. Therefore, below-threshold short replies leave previously stored TRAM bytes in memory, but the common `hm2_read` early return prevents those bytes from being reprocessed as fresh HAL feedback in that cycle. This is a **source-supported stale-data suppression mechanism**, not proof of the external controller's response to skipped feedback.

## PCI contrast

The inspected `hm2_pci_read` and `hm2_pci_write` iterate over mapped MMIO registers in 32-bit increments and unconditionally return 1. The driver assigns them to `llio.read` and `llio.write` and sets `threadsafe=1`. Common HostMot2 supplies dummy queue callbacks when a transport lacks queued operations; these delegate to direct read/write and report success for negative-size queue markers. PCI has **no Ethernet receive timeout, write-counter acknowledgment, or packet-error integrator in these callbacks**. This does not prove all PCI bus/device faults are detectable or undetectable; faults outside these callbacks (e.g. bus exceptions or kernel handling) were not inspected. Do not copy Ethernet `io_error` recovery assumptions to PCI.

## Practical inspection exercise (no hardware)

```sh
git checkout v2.9.10
git rev-parse HEAD:src/hal/drivers/mesa-hostmot2/{tram.c,hostmot2.c,hm2_eth.c,hm2_pci.c}
sed -n '149,185p' src/hal/drivers/mesa-hostmot2/tram.c
sed -n '90,126p' src/hal/drivers/mesa-hostmot2/hostmot2.c
sed -n '900,961p' src/hal/drivers/mesa-hostmot2/hm2_eth.c
sed -n '214,240p' src/hal/drivers/mesa-hostmot2/hm2_pci.c
```

Ask a learner to predict: (a) a 4-byte-short Ethernet reply below threshold; (b) the same at threshold; (c) a full reply with unacknowledged write below threshold; (d) a PCI MMIO read from a physically absent device. The first three have source-bounded answers above. **(d) is UNKNOWN** from these callbacks and cannot be inferred from their unconditional success return alone.

## Evidence and limitations

SOURCE-CONFIRMED: callback return translation, io_error guard, copy-on-full-size, PCI MMIO loops and registration. INFERENCE: stale read buffer is intentionally prevented from affecting HAL feedback in a missed cycle; validate with an isolated simulation before calling it TEST-CONFIRMED. UNKNOWN: actual NIC latency, bus fault handling, servo following-error response to frozen feedback, write completion at FPGA, and recovery after io_error clearing. No laboratory compute was dispatched; only a runner carrying both labels `self-hosted` and `openpressbrake` is permitted if a later test is justified. Preserve independent personnel safety and blind-evaluation gates.

**Information-gain stop:** TRAM return ambiguity from HM2-261 is resolved. Rotate to a Mesa encoder/index latch or stepgen implementation with a real HAL/INI rather than endlessly extending the Ethernet fault chain.
