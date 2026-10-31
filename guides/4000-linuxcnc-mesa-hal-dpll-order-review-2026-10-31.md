# 4000 LinuxCNC — Mesa HAL ordering and DPLL review card (source-only)

**Scope:** practical review of a selected INI/HAL, not a ready-to-deploy machine patch. Based on [HAL-19](../research/4400_LINUXCNC_HAL_19_REAL_MESA_7I95T_PID_WRITE_PROBE_GATE_ORDER_SOURCE_AUDIT_2026-10-31.md), [HAL-20](../research/4400_LINUXCNC_HAL_20_MR1_7I96S_PID_PROBE_SSR_POSTGUI_ORDER_SOURCE_AUDIT_2026-10-31.md), [DPLL-21](../research/4400_LINUXCNC_DPLL_21_TIMER_DEFAULTS_ENCODER_STEPGEN_ASYMMETRY_SOURCE_AUDIT_2026-10-31.md).

## Paper dependency test

For each `addf` in the **actually selected** HALFILEs, mark (a) signals read, (b) signals published, (c) first downstream consumer, (d) first hardware write. Use a per-iteration table; a producer after its consumer means a preceding-iteration value. Include non-PID outputs, input filters, GUI signal nets and optional `TWOPASS` ordering.

| Example | Source order | Consequence, not measured latency |
|---|---|---|
| Public 7i95T HAL-19 | `read -> write -> motion -> PID` | PID output is not written until later iteration |
| Public MR-1 7i96S HAL-20 | `read -> motion -> PID -> write` | PID output available to same-iteration write |
| MR-1 enable-indicator path | `write -> not.0` | SSR0 command receives older inversion result |
| MR-1 touch/tool setter | `motion -> or2 -> debounce` | motion sees conditioned signal in subsequent iteration |
| HAL-19 motion-type probe gate | `motion -> and2 -> comp -> conv` | multi-stage delayed probe qualification; G38.5 level-sensitive pitfall |

## DPLL checks

`timer-number=-1` means disabled; `0` nominal read; `1..4` one of four offset timers. **Read `dpll.01.timer-us` too**: both inspected stable and development drivers initialize it to **+100 µs**, whereas documentation recommends **negative** read-side offsets. Encoder and stepgen timer-number are module-level pins and have different invalid-value fallbacks (encoder disables invalid, stepgen coerces invalid to timer 0). No pin means do not invent it: verify firmware module descriptors. DPLL timing does **not** repair HAL addf ordering.

## Probe/G-code/GUI discriminator

On a machine with separate touch probe and tool setter, distinguish both raw inputs, combined OR, debounce output, `motion.probe-input`, `#5070`, `#506x` and any GUI LED signal. G38.3 is a probe move even when used for repositioning; it does not guarantee travel to the programmed endpoint. G38.5 can report a clear-level result without a new transition if a gating network holds the input false. The public MR-1 `probe` and `probe-in` signal names are not shown bridged in its selected HAL files; inspect the loaded graph before trusting the LED.

**Falsifiable offline question:** If the PID command is current but an SSR output lags one servo iteration, is Ethernet necessarily the cause? No: inspect whether the SSR's logic producer runs after `hm2.write`. If a DPLL timer is set to 1 but its offset is untouched, is pre-read sampling proven? No: source default is +100 µs.

**Before any physical commissioning:** capture exact running HAL/INI and bitfile identity, machine-independent E-stop/protection architecture, and qualified physical isolation. No person-exposed machine test follows from this desk review.

**Multi-card caution:** `hm2_dpll_write` uses one function-static 100-call startup phase-reset counter, not one per card. On multi-Mesa configurations, do not assume 100 reset writes per board; inspect actual phase-error traces before drawing a lock-time conclusion. This is a static code finding, not a demonstrated multi-board defect.
