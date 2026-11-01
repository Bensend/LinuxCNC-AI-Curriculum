# 4000-LC-ABSENC-126 — HostMot2 Fanuc absolute-encoder register payload versus write cache (2026-11-01)

**Status:** SOURCE-CONFIRMED static / hardware outcome UNKNOWN / NON-GRADUATED. **Scope:** 4000 Mesa/FPGA register integration, 3100/3200/3500 encoder commissioning. Not a safety certification.

## Novelty and pinned provenance
A direct scan of current `PROGRESS.md` and all `research/` filenames found HostMot2 watchdog, stepgen, DPLL, quadrature encoder, Smart Serial and resolver material, but **no prior SSI/BiSS/Fanuc absolute-encoder register payload audit**. This is a new register-command/cached-state mechanism, not a new general watchdog claim.

- Stable LinuxCNC **v2.9.10**, commit `86cdca76fa2a36274c432caa21952b23c267989a`: [abs_encoder.c lines 555–646](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L555-L646), especially [Fanuc writes 611–645](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L611-L645).
- Development snapshot `06864e23559e70463fc7112d5ce77138bcbc288c`: [abs_encoder.c lines 628–673](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/abs_encoder.c#L628-L673); [hostmot2.c write path](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/drivers/mesa-hostmot2/hostmot2.c#L126-L178).
- Official development [hostmot2(9) Fanuc format and pin contract](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/man/man9/hostmot2.9.adoc#L580-L599); stable official [hostmot2(9) Fanuc section](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/man/man9/hostmot2.9#L532-L545).
- Inspected source blob IDs: stable `494c95d0b1e10fcff4ae28b3848e820fcfc216ad`, development `[file fetched at pinned revision]`. No actual firmware image, physical board or encoder was inspected.

## Source trace: which register receives which payload?
`hm2_write()` calls `hm2_absenc_write()` **after** TRAM writes and other module register updates. In the Fanuc branch, the driver calculates three *different* 32-bit values:

| Local variable | Intended contents in source | Destination |
|---|---|---|
| `buff` | timer-number, automatic/manual trigger flags and conditional update bit 7 | `chan->reg_cs_addr` |
| `buff2` | high filter nibble plus clock DDS | `chan->data_reg_addr` |
| `buff3` | read bit count and protocol timing | `chan->rw_addr[2]` |

The first write correctly sends `&buff` to `reg_cs_addr`. **The next two writes also pass `&buff`**, despite testing `buff2 != data_written[1]` and `buff3 != data_written[2]`. They then cache **`buff2` and `buff3` as if those had been transmitted**. This exact mismatch is present in both pinned versions.

**Concrete source-derived discriminator:** change only the Fanuc filter or clock setting, keeping timer and format constant. `buff2` changes and the branch attempts a register write, but the transmitted word is `buff`, not `buff2`. After that write, `data_written[1]` records the intended `buff2`, so subsequent cycles with unchanged parameters do **not** retry the intended word. A change in `num_read_bits` analogously selects the `buff3` branch but writes `buff` and caches `buff3`.

**Inference, not tested:** the hardware's filter/clock and bit-length configuration may not match the displayed HAL settings. Exact hardware behavior depends on the loaded Mesa firmware register implementation and initial register contents, which were not inspected. Do not claim that a physical Fanuc encoder is misreading or that a particular card is affected.

## Minimal correction hypothesis (not applied upstream)
The two payload arguments in the Fanuc branch should be **`&buff2` for `data_reg_addr`** and **`&buff3` for `rw_addr[2]`**, preserving the cache comparisons and update-bit handshake. This is a source-level candidate, **not a verified firmware-compatible patch**: first inspect the firmware register protocol and confirm whether ordering/update-bit semantics require additional sequencing.

## Disconnected verification ladder — NOT RUN
1. Pin exact source, compile a minimal test double for `hm2_absenc_write` or use existing driver test hooks if present; provide fake `llio->write` that records (address, word, count). No real I/O.
2. Initialize a Fanuc channel with nonzero filter/clock/bit length, and set the register addresses to distinct sentinels. Record the **actual word** sent to each address.
3. Change filter only, then bit length only. Compare written payload to the calculated `buff2`/`buff3`; repeat with corrected candidate.
4. Test unchanged settings, update-bit transition and write failures; ensure cache updates only after confirmed successful transport if the transport API permits acknowledgement.
5. Do not promote to TEST-CONFIRMED until actual outputs, toolchain, revision, exit status and authoritative job runtime are retained.

## Claims and dependencies
| Claim | Class | Evidence | Missing |
|---|---|---|---|
| Two Fanuc register writes send `buff` while caching `buff2`/`buff3` | SOURCE-CONFIRMED both revisions | Pinned branch statements | Executable fake-write witness |
| Changed filter/bit length can be marked written without intended payload | SOURCE-CONFIRMED path + INFERENCE downstream | Cache assignments | Firmware semantics |
| Real Fanuc position becomes wrong | UNKNOWN | No hardware or firmware test | Disconnected emulator and qualified physical commissioning |
| Candidate pointer correction sufficient | INFERENCE | Local dataflow | Register-protocol review and tests |

**Transfer:** A fresh integrator must distinguish *requested parameter*, *calculated register value*, *word actually passed to low-level I/O*, *cache state*, and *measured encoder position*. These are five different witnesses.

**Related:** [ABSENC-127](4400_LINUXCNC_ABSENC_127_BISS_DDS_ZERO_AND_DELAYED_DATA_INVALID_SOURCE_AUDIT_2026-11-01.md); [practical guide](../guides/4000-linuxcnc-mesa-absolute-encoder-fanuc-biss-commissioning-2026-11-01.md).