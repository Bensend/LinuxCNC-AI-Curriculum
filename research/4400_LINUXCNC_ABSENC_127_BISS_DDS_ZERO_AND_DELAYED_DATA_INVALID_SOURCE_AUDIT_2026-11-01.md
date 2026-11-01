# 4000-LC-ABSENC-127 — BiSS DDS-zero arithmetic and delayed data-invalid indication (2026-11-01)

**Status:** SOURCE-CONFIRMED static / DOC-SOURCE-CONFLICT / numeric INFERENCE / TEST-CONFIRMED none / NON-GRADUATED.

## Pinned source and intended contract
Stable LinuxCNC v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a`: [BiSS setup and write](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L169-L195), [BiSS arithmetic](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L581-L609), [TRAM read and error counter](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L490-L551). Development `06864e23559e70463fc7112d5ce77138bcbc288c`: [BiSS setup](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L171-L205), [write](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L598-L625), [read/error](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L505-L567), [HAL pin export](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L469-L481), [decoded pin publishing](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/sserial.c#L1826-L1876), [HostMot2 read order](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/hostmot2.c#L94-L123).

Official development [hostmot2(9) SSI/BiSS documentation](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/man/man9/hostmot2.9.adoc#L438-L455) and [BiSS packet/validity section](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/man/man9/hostmot2.9.adoc#L557-L578) describe a `.data-invalid` pin when the transfer is still busy at read time. Stable official [hostmot2(9)](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/man/man9/hostmot2.9#L416-L425) calls the pin `.data-incomplete` whereas the inspected stable driver actually exports `.data-invalid` via `hal_pin_bit_newf` around lines 446–452. **Stable documentation's name is not the reliable HAL pin spelling.**

## Mechanism A — BiSS clock value can produce zero DDS before division
Both pinned `hm2_absenc_write` BiSS branches compute, in effect:

```text
dds = (uint32_t)(65536 * (frequency_khz * 1000 / fpga_clock_hz))
filt = 32768 / dds
filt = min(filt, 63)
```

`frequency-khz` is a writable HAL real parameter initialized to 500 in the setup function; the inspected write branch **does not reject zero or a too-small positive frequency** before the division. With `frequency-khz=0`, `dds=0` for a positive clock. For a *hypothetical* 100 MHz FPGA clock and 1 kHz requested BiSS clock, the integer cast truncates `0.65536` to **zero**; 2 kHz gives `1.31072` -> **1**. Therefore the low-frequency boundary depends on FPGA clock and truncation. At 100 MHz the threshold for DDS >=1 is approximately **1.525879 kHz**.

**SOURCE-CONFIRMED:** the code reaches integer division by `dds` without an explicit nonzero guard in the inspected branch. **UNKNOWN:** runtime result on a particular realtime architecture (C integer divide-by-zero is undefined behavior), and whether upstream HAL validation elsewhere prevents a particular invalid setting. Do not assert a reproduced kernel crash.

## Mechanism B — `.data-invalid` is a delayed, hysteretic diagnostic, not a same-cycle validity flag
`hm2_read` processes the TRAM transfer, then `hm2_absenc_process_tram_read`. That function first invokes `hm2_sserial_read_pins(chan)`, which writes decoded position/bit pins, **before** checking the SSI/BiSS/Fanuc busy flag. For busy data it increments a static per-channel `err_count` until 5001, and sets `.data-invalid` only on the *next* bad cycle. On good data it decrements from >4950, then clears the pin on a later good cycle.

At an **assumed 1 kHz** read rate, starting with counter 0, the first assertion is on the **5002nd consecutive bad read** (about 5.002 seconds), and a saturated counter requires **52 consecutive good reads** to clear (about 52 ms). These are source-derived cycle counts, **not** measured times. The one-time warning threshold is likewise after 5000 bad reads, not instantaneous. If a single bad read occurs, the exported `.data-invalid` remains false. The position pin has already been decoded from the TRAM buffer; the busy flag does not gate that publication.

This is a documentation/implementation distinction: the docs describe `.data-invalid` as true when transfer was still underway, while the implementation deliberately delays assertion. It is a **persistent-fault indicator**, not a per-sample freshness/CRC proof. The channel's own format-specific `error`, `pos_invalid` or CRC fields must be considered separately, and no independent safety function should rely on these software diagnostics.

## Minimal source-derived truth table (NOT RUN)
| Condition | Position pin updated? | `.data-invalid` |
|---|---|---|
| First busy read, counter starts 0 | Decoder called before busy test | Remains 0 |
| 5001st consecutive busy read | Decoder called | Remains 0 |
| 5002nd consecutive busy read | Decoder called | Becomes 1 |
| First good read after saturation | Decoder called | Remains 1 |
| 52nd good read after saturation | Decoder called | Clears to 0 |

This assumes successful HostMot2 TRAM read and valid format parsing; transport-level `io_error` or `-EAGAIN` can return earlier from `hm2_read`.

## Practical guard and tests
- Treat `frequency-khz` as an engineering configuration parameter: enforce **strictly positive, FPGA-clock-specific DDS >=1**, plus encoder vendor's clock range, before writing. No arbitrary universal minimum is claimed.
- For each absolute encoder channel, distinguish **transport success**, **transfer complete**, **format-specific error bits**, **decoded position**, and **elapsed sample age**. The stock delayed pin alone cannot establish all five.
- Disconnected tests (all **NOT RUN**): (1) fake low-level clock and set 0/1/2/500 kHz without executing a real division-by-zero on hardware; instrument the computed DDS and a guard candidate; (2) drive busy flags for 1, 5001, 5002 cycles and then 51/52 good cycles; (3) verify position publication ordering; (4) inspect one board's actual firmware and read/trigger schedule. Use only qualified `[self-hosted, openpressbrake]` isolated compute, never a machine.

## Claims ledger
| Claim | Class | Caveat |
|---|---|---|
| BiSS DDS can truncate to zero before unguarded integer division | SOURCE-CONFIRMED; numeric INFERENCE | Actual exception behavior UNKNOWN |
| Busy flag checked after decoded pin publication | SOURCE-CONFIRMED both versions | Physical data content UNKNOWN |
| Error pin delayed ~5002 bad cycles / 52 good cycles | SOURCE-CONFIRMED counts; time INFERENCE | Assumes contiguous reads and no early transport return |
| Stable manual says data-incomplete, stable code exports data-invalid | DOC/SOURCE-CONFLICT | Use actual installed HAL pin inventory |
| A particular encoder reports an incorrect position | UNKNOWN | No hardware/firmware run |

**Related:** [ABSENC-126](4400_LINUXCNC_ABSENC_126_FANUC_REGISTER_PAYLOAD_CACHE_SOURCE_AUDIT_2026-11-01.md); [commissioning guide](../guides/4000-linuxcnc-mesa-absolute-encoder-fanuc-biss-commissioning-2026-11-01.md).