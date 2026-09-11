# Accurpress ordinary bend-enable -> ram PWM disable call flow

Date: 2026-09-11
Course context: dependency-safe 4600 preparation
Public config: `bender_2022-04-25.hal`
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`

## Question

What does the 2022 Accurpress `bend-enable` signal actually do when it goes false, and how is that different from the separate `remote-estop -> estop_latch.ok-out` path?

## Public HAL topology

The relevant HAL connects one signal, `bend-enable`, from `pressgui.enable-button` to all of:

```text
press.interlock
simple-tp.0.enable
pid.0.enable
hm2_7i97.0.pwmgen.00.enable
hm2_7i97.0.ssr.00.out-01
estop-latch.0.ok-in
estop-latch.0.reset
```

The ram servo functions execute in this order:

```text
hm2_7i97.0.read
press
simple-tp.0.update
pid.0.do-pid-calcs
...
hm2_7i97.0.write
```

The separate remote-E-stop branch is:

```text
hm2 input-02-not -> estop-latch.0.fault-in
estop-latch.0.ok-out -> GUI enable light + hm2 SSR out-02
```

`estop-latch.0.ok-out` is not shown feeding `bend-enable`, `simple-tp.0.enable`, `pid.0.enable`, or `pwmgen.00.enable`.

Classification: **CONFIG-CONFIRMED**.

## Servo-cycle behavior when `bend-enable` becomes false

### 1. `press.interlock` is not the effective mid-cycle output gate

The public `press.comp` reads `interlock` only in idle state 0. Therefore a false `press.interlock` does not itself force an active approach/bend/return state to a terminal fault transition.

However, the same `bend-enable` signal independently disables downstream planner/controller/output blocks, so the software effect of a GUI disable is stronger than the press state machine alone suggests.

### 2. `simple_tp` stops requesting further target motion but respects acceleration

Pinned `src/hal/components/simple_tp.comp` states that when `enable` is false it sets `vel_req = 0`. The implementation then ramps `current_vel` toward that request by at most `maxaccel * fperiod` and integrates the resulting velocity into `current_pos`.

Therefore the exact source behavior is:

```text
enable false
 -> desired/required velocity becomes 0
 -> current commanded velocity ramps toward 0 at maxaccel
 -> current-pos continues integrating while current-vel is nonzero
```

This is worth stating precisely: the pin description says “sets velocity to zero immediately,” but the implementation applies the existing acceleration-limited ramp to `current_vel`. The control request is zero immediately; the planner's commanded velocity need not numerically jump to zero in one invocation.

Classification: **SOURCE-CONFIRMED**.

### 3. PID output is forced to zero when disabled

Pinned `src/hal/components/pid.c` documents and implements that with `enable == false`:

- the error integrator is reset;
- output calculation is bypassed;
- final PID output is forced to zero.

Classification: **SOURCE-CONFIRMED**.

This means that in the Accurpress topology the PID disable dominates the planner's gradual deceleration from the actuator-command perspective: even if `simple_tp.current-vel/current-pos` are still evolving toward rest, PID output becomes zero when the same `bend-enable` sample is false.

### 4. HostMot2 PWM instance is disabled in the hardware enable register

Pinned `src/hal/drivers/mesa-hostmot2/pwmgen.c` builds `pwmgen.enable_reg` by setting an instance bit only when that instance's HAL `enable` pin is true, then writes the enable register through the low-level I/O layer.

Because the Accurpress thread places `hm2_7i97.0.write` after the PID and other control functions, a servo invocation observing `bend-enable=false` reaches the HostMot2 write with `pwmgen.00.enable=false` and the corresponding enable bit cleared.

Classification: **SOURCE-CONFIRMED + CONFIG-CONFIRMED call flow**.

## End-to-end ordinary-control chain

For a servo-thread invocation in which the HAL signal is already false:

```text
pressgui.enable-button / bend-enable = false
        |
        +-> press.interlock = false
        |     (only checked by press state 0; active state may remain unchanged)
        |
        +-> simple-tp.0.enable = false
        |     -> vel_req = 0
        |     -> planner current_vel ramps toward 0 at maxaccel
        |
        +-> pid.0.enable = false
        |     -> integrator reset
        |     -> pid.0.output = 0
        |
        +-> hm2_7i97.0.pwmgen.00.enable = false
              -> HostMot2 PWM enable bit cleared
              -> hm2_7i97.0.write publishes disabled instance state
```

This is an ordinary software disable path. It does not establish the physical hydraulic safe state, which depends on the connected interface/cabinet/valve hardware.

## Important remote-E-stop contrast

The public HAL does **not** show `remote-estop` or `estop-latch.0.ok-out` forcing `bend-enable=false`.

So two statements can both be true:

1. **GUI bend-enable false has a direct ordinary software path to PID-zero and PWM-disable.**
2. **The shown remote-E-stop latch is not part of that software gating path.**

The remote-E-stop latch's `ok-out` does drive a physical SSR output. That may remove machine authority externally, but the cabinet destination and safety architecture are not established by the public HAL and must remain UNKNOWN.

## Failure/recovery implications

- If `bend-enable` falls during an active press state, downstream control output is disabled even though `press.state` may remain 5/6/8/etc. This can create a **state/actuator-authority split** that recovery logic must handle explicitly.
- Re-enabling without resetting or reconciling the press state could allow the downstream planner/controller to resume from a state whose semantic assumptions no longer match the physical process. The public source has not yet been shown to implement a dedicated recovery-state reconciliation for this case.
- Therefore a future 4600 press-cycle contract should not only define how authority is removed; it should define what state is retained/latched and what conditions are required before authority can be restored.

The last point is an **INFERENCE** from the source topology, not yet TEST-CONFIRMED on this public machine.

## Adversarial checks

### “Because `press.interlock` is only checked in idle, bend-enable cannot stop an active cycle.”

Rejected. `bend-enable` independently disables PID and HostMot2 PWM, so ordinary output authority is removed through downstream gates even if the press state machine does not transition.

### “`simple_tp.enable=false` instantly makes `current_vel=0`.”

Rejected by source. It makes `vel_req=0`; `current_vel` is still acceleration-limited toward zero.

### “PID zero alone proves the physical valve is safe.”

Rejected. It proves the software PID output becomes zero. Output-type/offset/interface electronics and hydraulic safe state require separate tracing.

### “Remote E-stop uses the same disable chain.”

Rejected for the shown HAL. Its latch output is not netted to the ordinary ram enable signal.

## Precise next checkpoint

Use this call flow when building the generic state-transition contract: every state must distinguish **semantic state**, **ordinary actuator authorization**, and **safety authorization**. Define what happens when ordinary authorization disappears mid-state and what evidence is required before re-enable. Then inspect the public Accurpress source/GUI for any explicit state reconciliation on re-enable before calling that behavior implemented.
