# ECAT-EL7041-147 — Encoder overflow/underflow PDO bit-position cross-wire

**2026-11-02 | 4000 LinuxCNC / 3100 mill + 3400 router transfer | NON-GRADUATED | SOURCE-ONLY.**

## Pinned provenance and predecessor

Same maintained out-of-tree [linuxcnc-ethercat release 56515f4](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/commit/56515f4aac313551346289d9c227193f50e9602a), published 2026-10-29; first audited here 2026-11-02. [lcec_el7041.c](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/devices/lcec_el7041.c), blob `75d5428695085be053837c27220b81a6740ec835`, lines 308–337 (PDO mapping), **544–550** (registration), **629–640** (HAL status read), 713–719 (separate count delta). [lcec_ethercat.c](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_ethercat.c) lines **730–752** defines `lcec_pdo_init`: supplied offset and bit-position pointers are registered with IgH. [Device YAML](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/devices/EL7041.yml) has blank testing status. No EL7041-specific predecessor in full curriculum progress/tree; [ECAT-ENC-143](4400_LINUXCNC_ECAT_ENCODER_143_EL5101_RECONNECT_WRAP_FREQUENCY_SOURCE_AUDIT_2026-11-02.md) is different.

## Exact source mechanism

Compact encoder TxPDO defines **0x6000:04 = underflow** and **0x6000:05 = overflow**. The driver registers them as:

```c
lcec_pdo_init(s, 0x6000, 0x04, &hd->count_underflow_pdo_os,
              &hd->count_overflow_pdo_bp);
lcec_pdo_init(s, 0x6000, 0x05, &hd->count_overflow_pdo_os,
              &hd->count_underflow_pdo_bp);
```

The **offset** pointers match their source bits but the **bit-position** pointers are crossed. These adjacent one-bit entries are in the same compact PDO byte (after latch-C, external latch and set-counter-done), so reading a mixed offset/bit-position pair returns the *other* status bit under the declared packed mapping. The read function publishes these values as `enc-count-overflow` and `enc-count-underflow`.

| Raw :04 underflow | Raw :05 overflow | HAL underflow (existing) | HAL overflow (existing) |
|---:|---:|---:|---:|
| 0 | 0 | 0 | 0 |
| 1 | 0 | **0** | **1** |
| 0 | 1 | **1** | **0** |
| 1 | 1 | 1 | 1 |

The driver's signed-16 delta accumulation is separate; this finding does **not** establish miscounted position or reversed physical movement. It also separately rebaselines encoder count after loss of operational state, but that generic continuity mechanism is credited to prior ECAT-ENC-143 rather than claimed as new.

## Frozen verification and correction

With a fake IgH PDO registration/byte buffer, inject :04-only, :05-only, both, neither; capture registered `offset/bit_position` pointers and HAL status outputs. Both-low/both-high alone are insufficient. Correct by passing `&hd->count_underflow_pdo_bp` to :04 and `&hd->count_overflow_pdo_bp` to :05, leaving the PDO layout and `EC_READ_BIT` unchanged. Require unchanged one-hot oracle after correction. No harness execution or patch occurred.

**SOURCE-CONFIRMED:** crossed pointers, PDO definitions and read path. **INFERENCE:** swapped diagnostic labels under standard mapping. **UNKNOWN:** IgH runtime map, terminal behavior, firmware, physical effects. **TEST-CONFIRMED none.** No build, EtherCAT, machine, evaluator or Actions; hosted/self-hosted 0/0 min. Independent safety remains separate.

[Guide](../guides/3100-3400-4000-linuxcnc-ethercat-el7041-sdo-and-encoder-status-commissioning-2026-11-02.md) · [Checkpoint](../checkpoints/20261102T0440Z-4000-linuxcnc-el7041-next.md).
