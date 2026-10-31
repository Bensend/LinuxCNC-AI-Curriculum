# 4400-LC-PLASMA-33 — Public 7i96S QtPlasmaC configuration: output order, DPLL, and source boundaries

**Status:** 4000 SOURCE-CONFIRMED static configuration audit / NON-GRADUATED; **no machine or LinuxCNC execution**. Investigated 2026-10-31. This is a machine-specific 3300→4000 implementation transfer, not reopening the graduated 3000 series.

## Question and provenance

Can a public, non-simulation QtPlasmaC/Mesa configuration resolve the prior [PLASMA-32](4400_LINUXCNC_PLASMA_32_QTPLASMAC_OVERCUT_M62_P3_TP_TIMING_AND_FILTER_SOURCE_AUDIT_2026-10-31.md) open question: whether the M62 P3 overcut torch-off command can reach the Mesa write function in the same servo iteration as motion publishes it?

Public configuration (machine status **not independently verified**): [freemoore/linuxcnc, immutable commit 1ed968d900969b8a0e767147d2bfd4b7236ea274](https://github.com/freemoore/linuxcnc/tree/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac). Inspected [7i96s_qtplasmac.hal](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/7i96s_qtplasmac.hal) (blob 5fd0a37c8e99868dec26c881abcd205a514570da), [INI](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/7i96s_qtplasmac.ini) (blob 3f676f29c513af8456abb8c395ca855a4d767040), [custom.hal](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/custom.hal) (blob 83189bcf76386e7a48fba3eafaf898ff0b039f25). PNCconf file header says generated **2025-08-29** with “Master (2.9)”; this does **not** establish the installed runtime revision.

Cross-reference only, **not proof of installed version**: [LinuxCNC v2.9.10 system qtplasmac_comp.hal](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/qtplasmac_comp.hal) (blob f3fc216a4932b02a2fe9e8de95cb7c08ced5931e), [v2.9.10 plasmac.comp](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/plasmac.comp) (blob 8f22cf1789b8adb49fe0a8d7e7cd5bd33444bf6c). The INI refers to `qtplasmac_comp.hal` but **that file is not present at the inspected machine config path**; LinuxCNC's installed system HAL library is a plausible resolver. Confirm effective installed file and `halcmd show sig` before treating the combined graph as verified.

## Source-level call order

The machine HAL specifies a 1,000,000 ns servo period and adds functions in this order:

```text
hm2_7i96s.0.read
motion-command-handler
motion-controller
pid.x / pid.y / pid.z / pid.s
plasmac
hm2_7i96s.0.write
db_float
db_ohmic
db_breakaway
db_arc-ok
```

**SOURCE-CONFIRMED:** `motion-controller → plasmac → hm2.write`. If the active motion segment publishes `motion.digital-out-03` in this servo iteration, the v2.9.10 system HAL wiring `motion.digital-out-03 → plasmac.torch-off` lets `plasmac` observe that value before the **same iteration's** `hm2.write`. The machine HAL connects `plasmac:torch-on` to `hm2_7i96s.0.outm.00.out-04`. The v2.9.10 component contains a `torch_off` check that calls `torch_on_set(FALSE)`. **Inference:** there is no extra whole-servo-cycle scheduling dependency in this segment of the output path. It does **not** prove a physical torch-off edge, network latency, arc-extinction time, exact vertex alignment, or the installed `qtplasmac_comp.hal` version.

The input path is different: `hm2.read` occurs before `plasmac`, but the `db_*` functions execute **after** `plasmac` and `hm2.write`. Thus the newly computed debounced value cannot affect `plasmac` until its next invocation, in addition to the filter's own delay. See [PLASMA-34](4400_LINUXCNC_PLASMA_34_DBOUNCE_INTEGRATOR_FILTER_SERVO_PHASE_SOURCE_AUDIT_2026-10-31.md).

## DPLL, encoder, and other machine-specific details

- The HAL explicitly sets `hm2_7i96s.0.dpll.01.timer-us -50` and `hm2_7i96s.0.stepgen.timer-number 1`. Unlike the previously audited unconfigured +100 µs default, this is an explicit **negative** sampling offset for the step generators. It does not prove that the firmware, device, or runtime actually activated DPLL or that an encoder uses DPLL.
- The same HAL sets `num_encoders=1 num_pwmgens=1 num_stepgens=3`, maps the encoder's **velocity** to `plasmac.arc-voltage-in`, selects `encoder.00.counter-mode 1`, filter 1 and scale -1. An actual volts-per-frequency calibration cannot be established from those values alone.
- `hm2_7i96s.0.watchdog.timeout_ns` is set to 5,000,000 ns (5 ms), five nominal 1 ms servo periods. This is a configured threshold, not measured watchdog behavior, and does not establish independent personnel-safety authority.
- `motion.motion-enabled` drives a signal that `custom.hal` routes to `hm2_7i96s.0.ssr.00.out-00`. This is an ordinary motion/SSR signal, **not** evidence of a qualified safety function.
- INI uses three spindles (cutting/scribing/spotting interface) and a `qtplasmac_gcode` filter for .ngc/.nc/.tap; the three-spindle declaration does not imply three physical rotary spindles.
- INI homing sequence is Z=1, Y=2, X=3, with `HOME_USE_INDEX=NO`. Do not transfer index-homing assumptions from earlier Mesa examples.
- A machine-specific public configuration is useful evidence of **intended wiring**, not proof that its hardware is connected, current, electrically correct, or used without modification.

## Diagnostic/acceptance discrimination

1. Inspect the **effective** installed `qtplasmac_comp.hal` (or migration `plasmac.tcl`) and `halcmd show sig plasmac:torch-off`, `plasmac:torch-on`, `plasmac:arc-ok` before claiming a complete connection.
2. Inspect `halcmd show funct` and `halcmd show thread` for the actual `addf` sequence, plus `halcmd show pin hm2_7i96s.0.dpll.01.timer-us` and `...stepgen.timer-number`; absence of a HAL pin or startup failure falsifies the assumed board/firmware path.
3. A software-only trace should record `motion.digital-out-03`, `plasmac.torch-off`, `plasmac.torch-on`, the Mesa output pin and actual realtime thread order. The physical torch contactor/arc must remain disconnected for such a test.
4. If the installed `qtplasmac_comp.hal` differs, re-evaluate the path; do not silently apply the v2.9.10 system file to an unpinned 2025 installation.

## Evidence matrix and boundary

| Claim | Evidence | Classification |
|---|---|---|
| Motion → plasmac → hm2.write on this HAL | Pinned public machine HAL | SOURCE-CONFIRMED configuration |
| v2.9.10 M62 DIO3 → torch-off | Pinned upstream system HAL + plasmac component + prior PLASMA-32 | SOURCE-CONFIRMED **for v2.9.10** |
| Same-iteration HAL output propagation **if effective wiring matches** | Combined ordered graph | INFERENCE / conditional |
| Installed QtPlasmaC version and effective system HAL | Not captured | UNKNOWN |
| Actual torch-off/arc extinction and watchdog physical behavior | No hardware evidence | UNKNOWN / not tested |

**Next:** use the exact filter semantics in PLASMA-34; then rotate to a genuinely new LinuxCNC implementation topic. No build, simulation, machine operation, CI or independent evaluation performed.
