# Practical 4000 review — real Mesa QtPlasmaC signal timing without assuming hardware success

**Purpose:** reproducible, read-only configuration audit and bounded disconnected software-test specification. References [PLASMA-33](../research/4400_LINUXCNC_PLASMA_33_REAL_7I96S_QTPLASMAC_SERVO_ORDER_AND_DPLL_SOURCE_AUDIT_2026-10-31.md) and [PLASMA-34](../research/4400_LINUXCNC_PLASMA_34_DBOUNCE_INTEGRATOR_FILTER_SERVO_PHASE_SOURCE_AUDIT_2026-10-31.md). No machine operations or CI runs were performed.

## Start from immutable files

Read [machine HAL](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/7i96s_qtplasmac.hal), [INI](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/7i96s_qtplasmac.ini), [custom HAL](https://github.com/freemoore/linuxcnc/blob/1ed968d900969b8a0e767147d2bfd4b7236ea274/configs/7i96s_qtplasmac/custom.hal), [upstream v2.9.10 common wiring](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/qtplasmac_comp.hal) and [upstream v2.9.10 filter source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/dbounce.comp). Confirm that the actual installed library revision matches before asserting a full live graph.

## HAL scheduling worksheet

| Path | Source | Intermediate | Consumer | Scheduled order | First eligible consumer |
|---|---|---|---|---|---|
| Torch-off request | motion.digital-out-03 | plasmac.torch-off → plasmac.torch-on | hm2 outm.00.out-04 | motion → plasmac → hm2.write | same servo iteration **if effective common wiring matches** |
| Float switch | hm2 inm input-09 | db_float.in → db_float.out | plasmac.float-switch | hm2.read → plasmac → db_float | next iteration after filter output; six iteration separations for settled delay=5 |
| Arc OK | hm2 inm input-06-not | db_arc-ok.in → db_arc-ok.out | plasmac.arc-ok-in | hm2.read → plasmac → db_arc-ok | next iteration after filter output; six iteration separations for settled delay=5 |
| Stepgen | motion/joint → PID | stepgen velocity-cmd | hm2.write | motion → PID → hm2.write | same iteration command publication, **not** measured network/step timing |

On an **already authorized, isolated, non-energized** LinuxCNC instance, read only: `halcmd show thread`, `halcmd show funct`, `halcmd show sig plasmac:torch-off`, `halcmd show sig plasmac:torch-on`, `halcmd show pin db_float`, `halcmd show pin db_arc-ok`, and `halcmd show pin hm2_7i96s.0.dpll.01.timer-us`. Capture the output and LinuxCNC version. If any signal or function is missing, stop the assumed trace and resolve effective configuration rather than silently filling the gap.

## Test matrix to freeze before isolated execution

| Case | Input stimulus | Predicted source behavior | Evidence required |
|---|---|---|---|
| A | HHHHHLHH, delay=5, initially low | output becomes high on eighth call, despite L on sixth | realtime same-thread cycle/input/output trace |
| B | six L after settled high, delay=5 | output clears on sixth L call | same-thread trace |
| C | sustained H, delay=0 | filter output high on first call, plasmac can see it next servo iteration under published order | two-function realtime trace |
| D | M62 P3 before overcut arc | DIO3 staged for following motion, not an exact-stop guarantee; output can be consumed by plasmac before hm2.write | canonical segment trace + realtime DIO/torch-on trace |
| E | DPLL timer 1 offset -50 µs | HAL requested pre-read stepgen sampling; no physical timing guarantee | startup logs, HAL pins, board/firmware version |

Do not use userspace `halcmd setp` pulses as an exact servo-cycle generator. Do not claim `halcmd show` alone proves physical response. Never energize torch, drives, or safety outputs to validate a curriculum trace. Ordinary LinuxCNC/HAL is not independent personnel-safety authority.

## Troubleshooting decision tree

If a torch-off output appears one servo iteration late, first compare effective `addf` order and installed common wiring, then capture realtime status. If a float or arc-OK event appears delayed, separate (1) Mesa read phase, (2) dbounce integrator accumulation, (3) dbounce-after-plasmac scheduling, and (4) QtPlasmaC state-machine policy. If an event passes despite intermittent lows, check the integrator model rather than assuming a consecutive-high debounce. If a nominal -50 µs DPLL offset is present, verify firmware and actual timer configuration before interpreting it as hardware-timestamped acquisition.

**Next handoff:** rotate to a distinct mill/lathe implementation source path or CAD/CAM postprocessor acceptance question; avoid repeating the G64/QtPlasmaC output investigation without a new discriminator. Status: SOURCE-CONFIRMED static, TEST-CONFIRMED none.
