# ECAT-EL7041-146 — EL7041 modParam switch fall-through writes unrelated SDOs

**2026-11-02 | 4000 LinuxCNC implementation; 3100 mill / 3400 router stepper transfer | NON-GRADUATED | SOURCE-ONLY.**

## Selection and provenance

START_HERE, governance, active checkpoint, PROGRESS, LESSON_LOG, LAB_COMPUTE_LOG and blind-feedback ledger were read. The repository tree and full historical progress contain no EL7041/motorFullsteps/0x8010 predecessor. [ECAT-12](4400_LINUXCNC_ETHERCAT_12_SYNC_UNIT_FRESHNESS_LATE_OUTPUTS_SOURCE_AUDIT_2026-10-30.md) addresses master WKC/freshness; [ECAT-ENC-143](4400_LINUXCNC_ECAT_ENCODER_143_EL5101_RECONNECT_WRAP_FREQUENCY_SOURCE_AUDIT_2026-11-02.md) addresses EL5101 counter recovery, neither this device's SDO switch. Qualified isolated compute was not established; no workflow dispatched.

Maintained **out-of-tree** [linuxcnc-ethercat release commit 56515f4](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/commit/56515f4aac313551346289d9c227193f50e9602a), published **2026-10-29T03:20:29Z** (not a new November release). [src/devices/lcec_el7041.c](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/devices/lcec_el7041.c), blob `75d5428695085be053837c27220b81a6740ec835`, lines 25–101 (parameter descriptors), **361–505** (switch), 507–529 (initialization failure). Current default branch independently has the same blob. [src/lcec_conf.h](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_conf.h), lines 187–200, defines typed `bit/s32/u32/flt` **union**. [EL7041 guide](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/el7041.md) gives XML syntax; [device YAML](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/devices/EL7041.yml) leaves TestingStatus blank. Bounded upstream issue search found no matching SDO issue; absence is not established.

## Call flow and exact defect

`<slave type="EL7041"><modParam .../></slave>` → typed parsed modparam → `lcec_el7041_init` → `handle_modparams` → `lcec_write_sdo16` on `0x8010`. The `switch(p->id)` has **no break** after `MOTOR_EMF` (398–403), `MOTOR_FULLSTEPS` (404–408), `ENCODER_INCREMENTS` (409–413), `START_VELOCITY` (414–418) or `DRIVE_ON_DELAY` (419–423). First break is after `DRIVE_OFF_DELAY` (430). **The same p->value is reused for each unintended write**, not the next configured modParam.

### Frozen isolated-call oracle (all writes accepted)

| Only modParam supplied | Expected ordered SDO attempts (object 0x8010) |
|---|---|
| `maxCurrent=2.5` (FLOAT, control) | `:01=2500` |
| `motorFullsteps=200` (U32) | `:06=200; :07=200; :09=200; :10=200; :11=200` |
| `encoderIncrements=4000` (U32) | `:07=4000; :09=4000; :10=4000; :11=4000` |
| `startVelocity=50` (U32) | `:09=50; :10=50; :11=50` |
| `driveOnDelay=100` (U32) | `:10=100; :11=100` |
| `driveOffDelay=150` (U32, control) | `:11=150` |
| `motorEMF=1.0` (FLOAT) | `:05=1000` then `:06/:07/:09/:10/:11` using the same union's `u32` view; **not** integer 1 |

The motorEMF extra numeric values depend on representation/architecture: do not invent their value. Each SDO rejection returns -1 immediately and makes initialization report -EIO; successful later modParams can overwrite earlier writes depending on XML order. This is a source-derived **attempt sequence**, not proven terminal acceptance or physical motor behavior. `EL7041`, `EL7041_1000`, `EL7041-1000` and `EP7041` share this init; supported SDOs vary by hardware. `EL7041-0052` instead uses a separate `lcec_el70x1.c` position-mode driver.

## Reproducible disconnected verification and repair boundary

Use a **fake** `lcec_write_sdo16` recorder and one typed `lcec_slave_modparam_t` plus ID=-1 terminator at a time; compare ordered `(index,subindex,value)` to the frozen table. Inject failure on the second write of `motorFullsteps`: expect no third write and init failure. Repeat with reversed two-modParam ordering to establish last-write ownership. No live EtherCAT. A minimal correction adds explicit breaks after each case, preserves conversions/error propagation, and tests both variant descriptors. No patch was applied.

**SOURCE-CONFIRMED:** missing breaks, union, attempted SDO call order, error return, shared init. **INFERENCE:** accepted unintended writes could change encoder increments, start speed and drive on/off delays. **UNKNOWN:** actual terminal SDO acceptance, firmware, motor response and physical machine. **TEST-CONFIRMED none.** No build/HAL/EtherCAT/machine/evaluator/Actions; hosted/self-hosted 0/0 min. Independent personnel-safety authority unaffected.

[Guide](../guides/3100-3400-4000-linuxcnc-ethercat-el7041-sdo-and-encoder-status-commissioning-2026-11-02.md) · [Checkpoint](../checkpoints/20261102T0440Z-4000-linuxcnc-el7041-next.md).
