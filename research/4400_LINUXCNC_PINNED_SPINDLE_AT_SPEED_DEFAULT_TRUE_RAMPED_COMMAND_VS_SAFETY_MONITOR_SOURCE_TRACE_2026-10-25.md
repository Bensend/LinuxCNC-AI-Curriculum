# 4400 — LinuxCNC spindle at-speed can be true without physical feedback
**2026-10-25 | SOURCE-CONFIRMED pinned LinuxCNC 062dc7c097693bb68e76192516cd92878dd5ecdf | No runtime or machine test**

## Question
Does LinuxCNC `spindle.N.at-speed` establish a measured safe speed, a standstill or a personnel-safety function? Can motion be released with an unwired input or with a command-ramp proxy?

## Pinned primary source inventory
- `src/emc/motion/motion.c`, **lines 739–742**: `hal_pin_new_bool(... HAL_IN, ..., 1, "spindle.%d.at-speed", num)`; explicit comment says default **1** for an unwired input to avoid blocking machines without at-speed feedback. [Pinned source](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/motion/motion.c#L739-L742).
- `src/emc/tp/tp.c`, **lines 3467–3476 and 3549–3563**: when a trajectory segment needs at-speed, planner checks `spindle_status[s].at_speed`; false yields `TP_ERR_WAITING`. [Pinned source](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/tp/tp.c#L3549-L3563).
- `src/emc/motion/command.c`, **lines 1819–1825 and 1856–1860**: spindle on/off can set the pending at-speed barrier for the next feed; stop barrier notes the input defaults to 1 if unwired. [Pinned source](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/motion/command.c#L1856-L1860).
- `docs/src/examples/spindle.adoc`, section **Spindle Soft Start**, shows `spindle.0.speed-out → limit2 ramp → near` comparing commanded and ramped command and wiring `near.out → spindle.0.at-speed`. Although surrounding prose discusses actual spindle speed, the shown HAL snippet contains **no independent measured spindle feedback** in that at-speed comparison. [Pinned example](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/docs/src/examples/spindle.adoc).
- `src/hal/components/near.comp`, **lines 1–28**, implements scale/absolute-difference approximate equality on its two input numbers, without knowing whether either is a real sensor. [Pinned component](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/components/near.comp).
- `lib/hallib/lathe.hal`, **lines 43–61**, demonstrates a *different* HAL arrangement: encoder velocity → lowpass/scale → `near_speed.in2`, command → `near_speed.in1`, `near_speed.out → spindle.0.at-speed`. This is an example with a simulated encoder in this file, not proof of physical sensor integrity. [Pinned HAL](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/lib/hallib/lathe.hal#L43-L61).
- `src/hal/components/spindle_monitor.comp`, **lines 1–47**, separate ordinary HAL component: at-speed set in state 1 when `fabs(command-feedback)<threshold`; in state 2 underspeed sets an underspeed output when command exceeds feedback by threshold, **but this branch does not clear the previously set at-speed output**. Idle state clears both outputs. This is **exact component behavior at the pinned revision**, not a general claim about all VFD drivers or selected hardware. [Pinned component](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/hal/components/spindle_monitor.comp).

## SOURCE-CONFIRMED call/data-flow distinction
```text
G-code spindle on/off with optional at-speed wait
 -> motion command sets pending at-speed barrier
 -> trajectory planner checks spindle_status[*].at_speed
 -> false waits; true allows ordinary feed/probe scheduling

HAL at-speed input can be:
 A. unwired: initialized true in motion.c
 B. "soft-start" example: near(command, ramped command), not physical feedback
 C. feedback example: near(command, encoder-derived estimate), still ordinary HAL
 D. arbitrary external component: exact source/config must be inspected
```
This gate governs **normal motion sequencing**. It is not an independent certified SLS/SOS, E-stop, guard, brake, valve, hydraulic load-hold or electrical isolation mechanism.

## Important adversarial predictions (SOURCE-CONFIRMED, not TEST-CONFIRMED)
1. **Unwired input:** initial `at-speed` true; a wait barrier cannot independently establish actual spindle speed. Source is explicit about permissive default.
2. **Ramped command only:** `near` may become true when two command-side values converge even if actual spindle is stalled, disconnected or still coasting. This is a logical consequence of the shown signal sources; actual selected machine behavior UNKNOWN.
3. **Ordinary feedback:** encoder-derived estimate can improve process readiness but must still address sensor coupling, freshness, fault diagnostics, drive stop, and physical containment; no safety rating inferred.
4. **spindle_monitor component:** after at-speed is latched, underspeed output can assert without clearing at-speed in state 2. This is component-local source behavior; wiring into any selected application UNKNOWN.

## Safety integration with MON-01
The [MON-01 module](../safety-course/4400_MON_01_SAFE_SPEED_MODE_SELECTION_ENCODER_CCF_AND_PHYSICAL_STOP_MODULE_2026-10-25.md) separates normal CNC sequencing, independently qualified speed-monitoring, final physical stop/hold and deliberate restart. A green `spindle.0.at-speed` bit cannot close any personnel-safety proposition. For OpenPressBrake, neither a spindle example nor any ordinary LinuxCNC speed/ready signal establishes Y1/Y2 independent hydraulic/gravity holding.

## Evidence ledger and limitations
**SOURCE-CONFIRMED** only at pinned LinuxCNC revision and exact cited files. **DOC-CONFIRMED** shipped example prose/config, not external machine performance. **TEST-CONFIRMED** none. **COMMUNITY-REPORTED** none. **INFERENCE** stalled/coasting counterfactual and cross-machine transfer. **UNKNOWN** selected HAL wiring, actual sensors, physical speed, PL/SIL, reaction/stopping distance, Y1/Y2 hold and restart. No simulation/build/test; G0/G1 HOLD, G3/G4 NOT AUTHORIZED, no people-exposed operation.
