# 4000-LC-HM2-GPIO-132 — Mesa GPIO output latch, direction ordering and false-feedback traps

**Audited:** 2026-11-01 UTC. **Status:** NON-GRADUATED; SOURCE/DOC-CONFIRMED; conditional transport failure INFERENCE; TEST NOT RUN. 3100 mill/router, 3300 plasma and 3600 press-brake normal-control integration transfer.

## Incremental scope and provenance

Historical `PROGRESS.md` and nearest HostMot2/STEPGEN/ABSENC audits were scanned. [ABSENC-126](4400_LINUXCNC_ABSENC_126_FANUC_REGISTER_PAYLOAD_CACHE_SOURCE_AUDIT_2026-11-01.md) already establishes a Fanuc register payload/cache mismatch; [STEPGEN-99](4400_LINUXCNC_STEPGEN_99_FORCE_REPLAY_MODE_REGISTER_OMISSION_SOURCE_AUDIT_2026-11-01.md) addresses stepgen recovery. **This is not a newly discovered generic caching mechanism.** The new concrete question is which **GPIO signal is a physical input versus an output command/latch**, how `is_output` becomes FPGA DDR, and what a cached low-level register write actually proves.

Pinned LinuxCNC stable v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a`: [`ioport.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/ioport.c), blob `406bdce2699ea045d9e6c23fd1bb5516b7f162a7`, `hm2_ioport_gpio_export_hal` ~226–355, `hm2_ioport_update` 472–511, `hm2_ioport_force_write` 514–525, `hm2_ioport_write` 528–553, `gpio_process_tram_read` 577–595, `gpio_prepare_tram_write` 605–625. [`hostmot2.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hostmot2.c) blob `75619ae3f6925087a6693c5421bbf629f4459d94`, `hm2_read` 94–122 and `hm2_write` 125–174. [`hostmot2-lowlevel.h`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/hostmot2-lowlevel.h) blob `b1c2376dd7ce9115936c75d63c16e85eba96eda1`, `llio->write` returns int. [`tram.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/tram.c) `hm2_tram_write` ~189–203 calls `llio->queue_write`, and `hm2_finish_write` ~205–214 calls `send_queued_writes` when present.

Development `06864e23559e70463fc7112d5ce77138bcbc288c`: [`ioport.c`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/ioport.c), blob `4ed2428d12c3144ab1bdd94bd142c33801ce6f57`, retains corresponding control flow with updated HAL APIs. Official stable [HostMot2 driver manual](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/drivers/hostmot2.adoc), blob `cc6845f663f81c61364f73c12b4d109dbc376337`, GPIO section ~430–462, read/write functions ~126–145.

## End-to-end servo execution

The normal HostMot2 `read` path first completes transport read and only then calls `hm2_ioport_gpio_process_tram_read`. It extracts every GPIO data-register bit into `gpio.N.in` and its complement `in_not`, including pins owned by special modules. The manual explicitly warns that **for a normal push-pull output, `in` and `in_not` are undefined**; do not interpret them as independently measured voltage or actuator state. For a configured input, the manual says they reflect the input. For open-drain outputs, the manual permits reading the resulting bus state while released high impedance. That is still not an independent contactor/valve feedback witness.

The normal HostMot2 `write` path first builds GPIO `data_write_reg` from HAL `gpio.N.out` for **full GPIO pins only**; it **queues** the TRAM data write, then calls `hm2_ioport_write` for direction, open-drain and invert configuration; `hm2_finish_write` later flushes queued writes where supported. The physical bus/register arrival order depends on the low-level transport, and is **not established** merely by this call order. `hm2_ioport_update` maps `gpio.N.is_output` to DDR only on pins tagged `HM2_GTAG_IOPORT`. Pins assigned to active StepGen/PWMGen/etc modules have their direction fixed by `direction_at_start` and do not export a normal `gpio.N.out`; their invert/open-drain parameters can still be exposed/aliased. Therefore a HAL pin name being present does not imply the user owns that physical connector line as free GPIO.

On forced initialization, the code writes invert, open-drain, alternate-source and **DDR last** (comment: avoid startup glitches). In normal `hm2_write`, output data TRAM is written before changed DDR configuration. **SOURCE-CONFIRMED software call/enqueue ordering**, not a guarantee of physical register arrival order or glitch-free electrical behavior across all transports, FPGA revisions or startup power sequencing.

## Configuration cache is not FPGA acknowledgment

The `hm2_ioport_force_write_ddr/output_invert/open_drain` helpers call `llio->write` and then `memcpy` the requested register image into `written_*` **without checking the write return value**. `hm2_ioport_write` compares these cached images against desired register images to decide whether to issue future writes. Consequently a failed low-level write *can* leave software's written cache matching the desired image even when the physical FPGA did not accept it; the ordinary change detector alone cannot prove hardware state. This is a **conditional source-derived observability/retry gap**, not proof of an actual dropped Mesa register update. The broader HostMot2 `io_error`/recovery path, transport queuing, watchdog and any forced replay must be evaluated before claiming permanent divergence.

## Practical pin-state truth table

| Configuration | HAL command | Documented electrical interpretation | Can `gpio.N.in` prove external actuator state? |
|---|---|---|---|
| `is_output=0` (full GPIO input) | `out` ignored | High impedance; input samples external level | **No**: measures input level, not necessarily actuator position |
| `is_output=1`, push-pull | `out=0/1` | Drives connector output (possibly inverted) | **No**: manual says `in/in_not` undefined |
| `is_output=1`, open-drain | `out=0` | Drives low | **No**: bus state is not actuator state |
| `is_output=1`, open-drain | `out=1` | Releases high impedance; external device may pull bus | **No**: bus level is readable, not independent process feedback |
| Special-function output | Module pin controls waveform; no full-GPIO `out` | Physical pin owned by active module | **No**: `gpio.N.in` is not a feedback authority |

## Reproducible verification (all NOT RUN)

1. With a qualified **disconnected** fake `llio` or isolated HostMot2 simulator, set one full GPIO `out=1` while `is_output=0`; verify output-data TRAM is prepared but DDR remains input. Then change `is_output=1` and capture **TRAM queue request before DDR write call**, followed by any `send_queued_writes` flush. Record queue/write/flush and physical register order **separately**.
2. Inject a one-time `llio->write` failure for the DDR register without changing the requested HAL parameter. Observe whether the cached `written_ddr` advances and whether the ordinary next-cycle comparison attempts the same DDR write. Capture any transport `io_error` and force-replay path separately.
3. With fake input-data words, verify `gpio.N.in/in_not` decode, but do not infer physical input semantics for push-pull outputs from the fake data.
4. Compare stable/development compiled behavior and actual register writes before proposing any code change. Do not dispatch unqualified self-hosted compute or any GitHub-hosted runner.

**Evidence ledger:** SOURCE-CONFIRMED HAL ownership, DDR/TRAM order, unchecked return/cache; DOC-CONFIRMED push-pull undefined `in`, open-drain bus semantics; INFERENCE dropped-write consequences; TEST-CONFIRMED none. No hardware, FPGA firmware, simulator, physical machine or independent evaluator evidence. [Commissioning guide](../guides/4000-linuxcnc-hostmot2-gpio-command-vs-feedback-commissioning-2026-11-01.md) separates normal-control GPIO from independent personnel-safety authority.
