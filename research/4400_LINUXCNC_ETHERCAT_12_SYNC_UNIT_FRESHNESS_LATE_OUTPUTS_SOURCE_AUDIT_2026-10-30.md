# 4000-LC-ECAT-12 — LinuxCNC EtherCAT Sync Units: new-image freshness, WKC and late output replay

**2026-10-30 | LinuxCNC-first 4000 source continuation | NON-GRADUATED | static only.**

## Scope and provenance

This examines the separate maintained [linuxcnc-ethercat/linuxcnc-ethercat](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat) HAL driver, **not LinuxCNC core** and not a generic EtherCAT guarantee. Exact source commit [`56515f4aac313551346289d9c227193f50e9602a`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/commit/56515f4aac313551346289d9c227193f50e9602a) was published **2026-10-29T03:20:29Z** (release commit), first audited by this curriculum 2026-10-30. Do not describe it as newly published today.

- [`src/lcec_main.c`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_main.c), blob `85fc4a195c1e7c83d27835285e50a9c744e7eecf`: global read/write ~1478–1504, `lcec_read_master` ~1640–1800, `lcec_write_master` ~1850–1970, `lcec_read_sync_unit` ~2451–2518, `lcec_write_sync_unit` ~2524–2560.
- [`src/lcec_syncunit.h`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/src/lcec_syncunit.h), blob `7cee2b17e334ec295dcbf2f9cb4b28a8b4035147`: `lcec_su_rx_publish` ~152, `lcec_su_rx_fetch` ~162, `lcec_su_tx_publish` ~178, `lcec_su_tx_take` ~197.
- [`documentation/multi-rate.md`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/multi-rate.md), blob `c68fdc5e5580e9ab92522245091f5c4c0085c601`: fastest bus cycle, integral slower Sync Units, HAL thread ordering ~79–112.
- [`documentation/master-pins.md`](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/master-pins.md), blob `7129de28867f5677883ffbf15e4faa84479e9ccb`: WKC/state ~17–36, DC synchrony ~52–85, Sync Unit `fresh`/`stale-count`/`late-count` ~125–155.

## End-to-end cycle

1. `lcec.read-all` loops masters and calls `lcec_read_master`; `lcec.write-all` loops `lcec_write_master`. The master bus thread calls `ecrt_master_receive`, processes queued domains, samples per-domain working-counter state, and publishes received process images to threaded Sync Units. The write path queues domains and sends via `ecrt_master_send`. **SOURCE-CONFIRMED.**
2. The documentation's multi-rate example runs the EtherCAT bus at 125 µs and slower units at integer multiples. It explicitly requires unit `read` before its consumers and unit `write` after producers, with a fast bus thread. This is **DOC-CONFIRMED example architecture**, not a measured cycle on a particular machine.
3. The bus publishes a received image with `lcec_su_rx_publish`, which increments a generation counter. A unit thread uses `lcec_su_rx_fetch` with a seqlock-style consistency check; it sets `fresh=1` only when the fetched generation differs from `rx_gen_seen`. If no new generation arrives, it sets `fresh=0` and increments `stale-count` once Sync Units have started. **SOURCE-CONFIRMED.**
4. **Important distinction:** `lcec_read_sync_unit` marks `torn = !ok || gen==0` and returns early only for a torn/no-initial-image condition. If `ok` is true but `gen` equals the previous generation, it sets `fresh=0` **yet still calls the slave `proc_read` callbacks on the prior complete image**. Thus `fresh=0` is a valid indication of no newly published image, while a slave HAL value may still be processed from the prior image. This is a **SOURCE-CONFIRMED stale-image processing path**, not proof of a failed physical drive.
5. **New generation is not necessarily a complete exchange.** `lcec_read_master` publishes a processed domain image when it was queued and processed, while separately recording `ecrt_domain_state` and WKC. No WKC-complete gate appears around `lcec_su_rx_publish` in the inspected path. Therefore `fresh=1` alone does **not** certify `wkc-state==EC_WC_COMPLETE`, every slave operational, or all data semantically valid. **SOURCE-CONFIRMED separation of checks; INFERENCE for actual partial/stale PDO contents.**
6. On outputs, the unit thread publishes an image through `lcec_su_tx_publish`. The bus thread uses `lcec_su_tx_take` to copy a consistent newer image into a staging buffer before replacing the domain image. If no new image is available, it increments `late-count` and can resend the last outputs for a bounded run. After `LCEC_SU_STALL_SENDS` missed sends, it stops queuing that unit until a new publish, intending that EtherCAT slaves' SyncManager watchdogs respond. **SOURCE-CONFIRMED software intent; actual slave watchdog behavior, output state and timing are machine-/slave-dependent and UNKNOWN.** This is not a safety-rated stop.
7. Master `wkc` and `wkc-state` aggregate domain state; `wkc-min` and change count begin only after the first complete exchange. Per-unit WKC state is separate. A complete WKC and a new image still do not prove physical actuator position, tool clearance or safe motion.

## Compare to HostMot2 Ethernet (same session)

[HM2-ETH-11](4400_LINUXCNC_HM2_ETH_11_SPLIT_READ_PACKET_LOSS_STALE_FEEDBACK_SOURCE_AUDIT_2026-10-30.md) showed that a temporary `-EAGAIN` causes generic HostMot2 to **skip** TRAM-to-HAL feedback processing, leaving previous values published. This EtherCAT driver can instead **run `proc_read` on the last complete image** when its generation is unchanged. Both can present old input values to ordinary LinuxCNC control, but they expose different freshness indicators and recovery contracts. Neither a HostMot2 packet-error pin nor an EtherCAT `fresh`/WKC pin is an independent personnel-protective sensor.

## Practical diagnostic and adversarial exercise (unscored)

A 2-kHz EtherCAT drive Sync Unit is serviced by a separate servo thread while an 8-kHz bus thread continues. The drive thread runs one cycle but receives the same input-image generation as last time.

- **Predict `fresh`:** false; `stale-count` increases after startup gate.
- **Predict `proc_read`:** it still runs if the copy was consistent and generation nonzero; the previous image is processed.
- **Predict outputs:** if no newer unit-thread output is published, the bus may resend the prior output for a bounded number of sends, then stop queuing that unit. Do not assume an exact physical stop time.
- **Predict WKC:** cannot infer complete exchange from `fresh` alone; inspect per-unit `wkc-state`, master WKC, slave state and timing.
- **Explain two independent clocks:** HAL unit thread scheduling and EtherCAT distributed-clock synchronization are distinct mechanisms; documentation's phase-lock settings are not evidence of measured machine jitter.

For an inspectable real machine, collect the actual XML slave PDO/DC configuration, LinuxCNC INI/HAL `addf` order, master/slave WKC/state, `fresh`, `stale-count`, `late-count`, and manufacturer watchdog behavior. Never invent a slave's safe output state or safety performance level.

## Evidence and open questions

**SOURCE-CONFIRMED:** separate read/write bus path; per-unit generation freshness; same-generation image still processed; WKC independent from generation; bounded stale-output resend; seqlock and staging protections.

**DOC-CONFIRMED:** multi-rate scheduling example, WKC/fresh/late pin descriptions.

**UNKNOWN:** actual EtherCAT master kernel behavior under packet loss, installed PDO validity, drive fault reaction, SM watchdog configuration, real jitter, physical outputs, safety integrity, whether a particular machine uses this driver revision. **TEST-CONFIRMED: none.**

No build, simulator, workflow, hardware, external evaluation or Actions compute. This source-only audit does not authorize hazardous operation. Only isolated `[self-hosted, openpressbrake]` for any future frozen lab; runner dispatch/isolation remains UNKNOWN.

**Next:** source-trace `lcec_su_rx_publish` with WKC failure injection semantics and the exact output stall counter threshold, then review an inspectable LinuxCNC EtherCAT HAL/XML machine config. Avoid turning this into a safety-course or mandatory product build.
