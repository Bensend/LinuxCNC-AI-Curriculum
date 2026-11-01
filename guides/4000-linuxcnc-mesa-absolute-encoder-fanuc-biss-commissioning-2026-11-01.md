# 4000 / 3100 / 3200 / 3500 — Mesa absolute-encoder source-to-HAL commissioning walkthrough (2026-11-01)

**Purpose:** build an inspectable HostMot2 SSI/BiSS/Fanuc integration contract for mills, lathes, gantries and robot joints. **Status:** source-only, no energized hardware, no acceptance/qualification. Use [ABSENC-126](../research/4400_LINUXCNC_ABSENC_126_FANUC_REGISTER_PAYLOAD_CACHE_SOURCE_AUDIT_2026-11-01.md) and [ABSENC-127](../research/4400_LINUXCNC_ABSENC_127_BISS_DDS_ZERO_AND_DELAYED_DATA_INVALID_SOURCE_AUDIT_2026-11-01.md).

## End-to-end data path
1. HostMot2 config parser recognizes `ssi_chan_N=...`, `biss_chan_N=...`, `fanuc_chan_N=...` in [hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/hostmot2.c#L341-L445).
2. `hm2_absenc_parse_md` matches a firmware module descriptor and a configured channel, creates `<board>.{ssi,biss,fanuc}.NN` pins and `frequency-khz`, `timer-number`, `data-invalid` [abs_encoder.c](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L379-L497).
3. The host or DPLL triggers a serial conversion. Without DPLL, `<board>.trigger-encoders` exists; [official scheduling note](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/man/man9/hostmot2.9.adoc#L1445-L1456) recommends placing it before `<board>.read`. With DPLL, follow the firmware's timed trigger mode; do not assume the function exists.
4. `hm2_read` finishes TRAM, processes absolute encoder data, and `hm2_sserial_read_pins` converts raw fields into HAL pins [hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/hostmot2.c#L94-L123); [sserial.c](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/sserial.c#L1826-L1876).
5. `hm2_write` calls `hm2_absenc_write` to update clock/timer/format registers when parameter values change [hostmot2.c](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/hostmot2.c#L126-L177).

## Preflight inventory (no hardware commands)
| Question | Evidence to capture |
|---|---|
| Which Mesa board and FPGA bitfile? | Exact board ID, bitfile hash, HostMot2 module descriptors and firmware version |
| Which absolute-encoder protocol and channel? | Physical encoder manual/revision; SSI/BiSS/Fanuc, bit widths, Gray/straight binary, CRC/status bits |
| How is the conversion triggered? | DPLL present? `timer-number`, trigger function availability, `addf` ordering, servo period |
| What is the true clock? | `frequency-khz`, FPGA module clock, computed DDS, encoder clock specification |
| Which status means valid? | Transport `io_error`, busy/transfer-complete, format-specific status, age/freshness; delayed `.data-invalid` is **not** a per-cycle witness |
| Which position is trusted? | Encoder rawcounts, scaled position, motor/joint feedback, homing trust and mechanical gearing; do not equate any one with physical absolute truth |

**Illustrative format only, not a runnable machine configuration:** `biss_chan_0=position%24e` expresses a 24-bit encoder field; real devices often include additional pad, status and CRC bits and require the complete documented bitstream. `fanuc_chan_0=AA64` is a predefined format. Both require firmware supporting the protocol. Never copy these fragments into a powered machine without validating the actual bitstream and bitfile.

## Register and timing preflight
- **Fanuc:** record requested `filter`, `frequency-khz`, `timer-number` and `num_read_bits`. For each register write, compare *calculated payload*, *actual transmitted payload* and *cached desired payload*. The pinned driver writes `buff` where `buff2`/`buff3` are calculated; this is a **source finding**, not an observed board failure.
- **BiSS:** compute `dds=floor(65536*frequency_khz*1000/FPGA_clock_hz)` before allowing the setting. Reject zero DDS in an offline preflight. Check vendor's clock limits and required frame duration, not merely a nominal 500 kHz default.
- **SSI/BiSS/Fanuc:** log serial trigger phase, TRAM read completion, format-specific error/status and actual encoder position. At 1 kHz the `.data-invalid` driver pin takes about 5002 consecutive busy reads to assert; never use it as the sole immediate freshness gate.
- **HAL thread ordering:** for a non-DPLL system the documented conceptual sequence is `trigger-encoders` -> `read` -> feedback consumers -> control calculations -> `write`. A DPLL system uses its own trigger phase; inspect the actual `addf` order and DPLL parameters. `hm2.read` may return early on transport error, so record the transport state as well.

## Disconnected exercise and acceptance ladder — all NOT RUN
1. **Code reading:** identify the three Fanuc register addresses, three computed words, three transmitted pointer arguments and cache updates in both pinned revisions. Expected static result: last two arguments reference `buff`, not `buff2`/`buff3`.
2. **Clock arithmetic:** with a *hypothetical* 100 MHz FPGA clock, calculate DDS for 0, 1, 2 and 500 kHz. Expected: 0, 0, 1 and 327. Do not execute divide-by-zero; verify a proposed guard instead.
3. **Validity timing:** simulate 5001 busy cycles, then one more, then 51 and 52 clean cycles. Expected delayed assertion/clearance from ABSENC-127. Keep physical data freshness separate.
4. **Transport isolation:** simulate `io_error` and `-EAGAIN` early returns; demonstrate that a previously published HAL position can persist without a new sample.
5. **Firmware contract:** inspect a real public Mesa bitfile/HDL or register description and verify whether the Fanuc register write candidate is compatible; no inferred physical fix until then.
6. **Commissioning transfer:** draw two feedback chains: a lathe spindle index/turn-count chain and a gantry axis absolute-position chain. Identify what must be independently validated before motion is permitted. Personnel-safety authority remains separate.

## Debugging decision path
If position freezes, **first** check transport and read cadence, **then** trigger timing and busy flags, **then** protocol status/CRC, **then** scaling and count wrap, **then** register programming. A clean `.data-invalid` pin is not enough to skip the earlier checks. If only Fanuc settings appear ineffective, compare actual register payload against desired cached values before changing cables or mechanics.

## Evidence and next work
Official docs: [development hostmot2(9)](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/man/man9/hostmot2.9.adoc#L438-L599); [stable hostmot2(9)](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/man/man9/hostmot2.9#L416-L545). Source pins stable `86cdca76fa2a36274c432caa21952b23c267989a`, development `06864e23559e70463fc7112d5ce77138bcbc288c`. No upstream automated absolute-encoder driver test was found in the inspected **stable repository filename tree**; this is not proof none exists elsewhere. No build, HAL execution, simulation, real FPGA or physical encoder tested. Use only qualified, physically disconnected `[self-hosted, openpressbrake]` compute if needed. Never GitHub-hosted runners. Reuse existing HostMot2 driver test infrastructure where possible rather than inventing a product build.