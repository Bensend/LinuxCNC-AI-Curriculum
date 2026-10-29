# 4400-G95-SPEED-01 — Feed per revolution is not proof of real spindle speed (technician card)
**2026-10-29 | paper/offline review only | NON-GRADUATED**

Read [the pinned LinuxCNC v2.9.10 G95 source audit](../research/4400_G95_SPEED_01_LINUXCNC_2910_SPINDLE_SELECTION_RPS_FEEDBACK_AND_FALSE_FEED_SOURCE_AUDIT_2026-10-29.md), [the existing spindle-at-speed source trace](../research/4400_LINUXCNC_PINNED_SPINDLE_AT_SPEED_DEFAULT_TRUE_RAMPED_COMMAND_VS_SAFETY_MONITOR_SOURCE_TRACE_2026-10-25.md) and the [MON-01 safety-speed boundary](4400_MON_01_SAFE_SPEED_MODE_SELECTION_ENCODER_CCF_AND_PHYSICAL_STOP_MODULE_2026-10-25.md).

## The four distinctions
1. **G95 F** means distance per spindle revolution; it is ordinary motion control, not threading or personnel protection.
2. **`spindle.N.speed-in`** is actual RPS input, **not RPM** and not `speed-out` (commanded RPM). Verify the named physical source, units, selection and freshness from existing drawings/HAL records.
3. **Same-block spindle selection matters:** in v2.9.10 `G95 $1 F0.2` selects spindle 1, but a later `G95 F0.2` with no `$` resets the interpreter's feed-mode spindle to 0. A preceding `M3 $1` or `G96 $1` is not a substitute.
4. **G95's target feed uses `fabs(speed-in) * F`** in the planner. The interpreter's nonzero-S check reads programmed spindle state, not physical feedback. `at-speed` is an ordinary HAL input and can be unwired/default TRUE; none is independent safe-speed, stopped-spindle or chuck-guard evidence.

## Four adversarial desk cases (UNSCORED / NOT RUN)
| Given existing record | Question for reviewer | Expected source-grounded distinction |
|---|---|---|
| `G96 S140 D5000 $1` then `M3 $1` then `G95 F0.2` | Which spindle is selected by the G95 **feed mode**? | 0, because `interp_execute.cc:256–264` resets to 0 absent a `$` on the G95 block. No claim of actual motion. |
| `G95 $1 F0.2`, `spindle.1.speed-in` connected to `encoder.1.velocity-rpm` | What unit mistake matters? | G95 expects **RPS**; RPM supplies a 60× numerical value. Actual machine speed/feed is not inferred from this desk case. |
| Program S1200, encoder physically failed, `speed-in` stuck positive | Does parser's nonzero-S check prove rotation? | No. It checks `settings->speed[]`; normal TP uses supplied `speed-in` float without local sensor-provenance check. |
| `G95` chosen for threading | Is this phase-synchronized threading? | No. Tagged manual says use G33/G76; separate `revs`/index path and independent safety requirements. |

## A safer, easier integration
Mark the actual encoder's RPS signal, command RPM, `at-speed` source and selected spindle number on one offline diagram. Give normal diagnostics an explicit **FEEDBACK UNKNOWN / INVALID** state rather than a falsely reassuring green light. Do not bypass the sensor with a command signal for production convenience. A shop that repeatedly does this has a usability/design defect to correct, not a reason to bless the bypass.

**Stop boundary:** no live signal injection, spindle start, tool feed, guard bypass, cabinet opening, machine tests or physical calibration under this card. Any qualified commissioning later needs a separate isolation/remote test plan and independently established guard, safe-stop, coast/containment and deliberate-restart requirements. **G0/G1 HOLD**, independent 2520–25F0 evaluation OPEN; no physical TEST-CONFIRMED evidence.
