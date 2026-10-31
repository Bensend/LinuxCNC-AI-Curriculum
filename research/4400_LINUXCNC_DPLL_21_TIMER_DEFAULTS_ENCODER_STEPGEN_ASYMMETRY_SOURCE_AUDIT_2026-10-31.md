# 4000-LC-DPLL-21 — HostMot2 DPLL defaults, timer-number asymmetry and servo-thread limits

**UTC session start:** 2026-10-31T03:32:53.631Z. **LinuxCNC-first, NON-GRADUATED, static source/docs/community reconciliation.** Follows [HAL-19](4400_LINUXCNC_HAL_19_REAL_MESA_7I95T_PID_WRITE_PROBE_GATE_ORDER_SOURCE_AUDIT_2026-10-31.md), [HAL-20](4400_LINUXCNC_HAL_20_MR1_7I96S_PID_PROBE_SSR_POSTGUI_ORDER_SOURCE_AUDIT_2026-10-31.md), [HM2-ETH-14](4400_LINUXCNC_HM2_ETH_14_PPOLL_IRQ_TIMEOUT_COUNTER_SOURCE_AUDIT_2026-10-31.md) and [HM2-ENCODER-18](4400_LINUXCNC_HM2_ENCODER_18_FIRMWARE_GATED_PROBE_LATCH_VS_G38_SOURCE_AUDIT_2026-10-31.md). This adds **DPLL register/default behavior and invalid-input asymmetry**, not another claim that HAL functions run in insertion order.

## Concrete question and pinned evidence

If a Mesa configuration sets `stepgen.timer-number=1` but leaves `dpll.01.timer-us` untouched, is it guaranteed to sample before the nominal HostMot2 read? How do invalid timer numbers behave, and can DPLL repair a misordered HAL graph?

- LinuxCNC development `24e84c4506b41634240f7087f0295e361a954886` (2026-10-30T10:04:49Z): [`dpll.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/dpll.c), blob `004939ac71cd35e0d5a71377346fdc6836493f5b`; [`encoder.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/encoder.c), blob `4ed8ad05e22405c8221d31d624d56e637dfefe19`; [`stepgen.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/stepgen.c), blob `4daaa54f3fb63b6af2dc2d83a31ebfbb7b47ca23`; [`hostmot2.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/hostmot2.c), blob `f83e48fad84639eb1c095335ce908b4d408a4d38`.
- LinuxCNC **stable v2.9.10** cross-check: `dpll.c` blob `e66af3019291cef4cc640b552dd70d023aad44f2`, `encoder.c` `9719d41419da9220761637e002024cdc9d17a8ba`, `stepgen.c` `8eb43d9a7d8e42573ef653cb82460609d2864ae4`; same relevant defaults and invalid-number branches in inspected source.
- [Pinned development hostmot2(9) documentation](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man9/hostmot2.9.adoc), blob `da9f56a494f345fc1920878ace5729d80377e7dd`, lines 237–301, 389–403 and 1058ff. [Mesa developer PCW's 2018 forum explanation](https://forum.linuxcnc.org/pathpilot/34369-dpll-configuration) is **COMMUNITY-REPORTED**: PCI bitfiles often omit DPLL; Ethernet jitter makes it more valuable. This is context, not a measured result for this course.

## 1. DPLL activation is not implicit

`dpll.c::hm2_dpll_parse_md` lines 31–117 requires a valid module descriptor and honors `num_dplls=0` as disable. Its four HAL `dpll.0N.timer-us` pins initialize to **+100.0 µs** (development lines 72–79; stable lines 99–102). The upstream documentation recommends **negative** timer offsets for read-side sampling (for example -50 or -100 µs), with magnitude greater than worst-case read-time variation. The positive initialization is **not a promised pre-read default**.

The `encoder.timer-number` and `stepgen.timer-number` pins default to **-1**, meaning no DPLL latching. `0` selects nominal-read latching and `1..4` selects DPLL offset timer. The pins are **module-level** (one encoder timer-number and one stepgen timer-number per HostMot2 card), not individually selectable per encoder/stepgen instance in this driver. A DPLL module alone does not mean either sampling path has been armed.

**Source-grounded counterexample:** set only `stepgen.timer-number 1` on a card that exports the pin and leave `dpll.01.timer-us` at its source default +100 µs. That is **not** the negative pre-read timing described by the documentation. Exact physical latch timing, firmware capabilities and following-error impact remain UNKNOWN; no runtime test was performed.

## 2. Two firmware/pin-availability gates are not identical

`encoder.c` lines 423–430 first checks DPLL module presence, then writes/reads a candidate encoder DPLL timer register and exports `encoder.timer-number` only if readback is zero (lines 485–489). `stepgen.c` lines 875–880 exports `stepgen.timer-number` when the DPLL module is present. The driver therefore does **not** prove that every Mesa bitfile supports both timer pins merely because the DPLL itself exists. Verify `halcmd show pin` and actual module descriptors on the target firmware; no 7i95T or 7i96S bitfile identity is inferred from the public INI alone.

## 3. Invalid timer-number values have asymmetric fallbacks

**SOURCE-CONFIRMED in stable and development:**

| HAL input | Encoder path (`encoder.c` 270–280) | Stepgen path (`stepgen.c` 491–501) |
|---|---|---|
| -1 | writes 0 (DPLL sampling disabled) | writes 0 (disabled) |
| 0 | writes enable bit 15, timer 0 | writes enable bit 15, timer 0 |
| 1..4 | writes enable bit 15 plus timer number in bits 12.. | same encoding |
| out of range, e.g. 5 | **local** value coerced to -1, register disabled; HAL pin remains 5 | HAL pin itself reset to **0**, timer 0 enabled |

The distinct invalid-input behavior is important for configuration review and diagnostics. Do not call it a physical malfunction: register writes and hardware results were not executed. The source paths do not provide a unified validation/error report for the two modules.

## 4. DPLL affects FPGA sampling, not HAL producer/consumer order

`hostmot2.c::hm2_read` lines 94–123 finishes the input transfer, processes encoder/stepgen feedback and DPLL phase status. `hm2_write` lines 126–177 prepares TRAM outputs and invokes `hm2_dpll_write` after TRAM write to update timer phase registers. `dpll.c::hm2_dpll_process_tram_read` lines 124–134 publishes `phase-error-us` from the readback sync register and the supplied period. `hm2_dpll_write` lines 136–214 initializes base frequency from the servo period if unset, configures filter/limits, and converts timer offsets to register fields.

**INFERENCE constrained by SOURCE:** a correctly configured DPLL can make encoder/stepgen sampling more repeatable relative to the servo cycle; it **cannot** reorder `motion-controller`, `pid`, `hm2.write`, `or2` or `debounce`. Thus it does not fix HAL-19's early hardware write or HAL-20's post-motion input conditioning and post-write SSR inversion. An `hm2.read` temporary failure may still skip feedback publication (see HM2-ETH-11/14); a DPLL pin does not certify fresh feedback.

The source's initial 100-call phase reset and default time constant 2000 are implementation details, not a verified lock time. `phase-error-us` is a diagnostic of the DPLL loop, **not** an independent timestamp of a probe contact, nor proof that the network packet arrived on time. Physical sampling jitter and following-error benefit require machine-specific evidence.

## Minimal practical review (no execution)

1. Inventory loaded bitfile/module descriptors and actual HAL pins; do not assume DPLL or either timer-number exists.
2. Record the exact `hm2.read` and `hm2.write` addf positions and all producers/consumers.
3. Record `dpll.01.timer-us` **and** `encoder.timer-number` / `stepgen.timer-number`; never infer pre-read latching from timer-number alone.
4. Distinguish `-1` disabled, `0` nominal read, `1..4` offset timer; reject invalid values explicitly in configuration review instead of relying on inconsistent driver fallbacks.
5. Monitor phase-error trend, servo jitter, packet errors, actual feedback freshness and following error separately; only a controlled, physically isolated test could establish machine-specific benefit.
6. Keep ordinary LinuxCNC/FPGA monitoring distinct from independently designed personnel protection.

**Evidence ledger:** driver branches **SOURCE-CONFIRMED**; hostmot2(9) offset recommendation **DOC-CONFIRMED**; PCW field explanation **COMMUNITY-REPORTED**; reduced jitter and latency outcomes on an actual machine **UNKNOWN**; no **TEST-CONFIRMED** evidence generated. No compute, simulation, workflow, firmware change, physical operation or graduation. **Next:** inspect a specific real Mesa DPLL-enabled configuration with exact bitfile and hardware status, or rotate to another unworked LinuxCNC implementation path if no qualified firmware evidence is available.
