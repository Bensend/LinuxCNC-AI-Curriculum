# Accurpress press-brake — enable / E-stop software-path audit

Date: 2026-09-11
Status: **DEPENDENCY-SAFE 4600 PUBLIC CONFIG + PINNED-SOURCE ANALYSIS**
Public HAL: https://forum.linuxcnc.org/media/kunena/attachments/19921/bender_2022-04-25.hal
Public component: https://forum.linuxcnc.org/media/kunena/attachments/723/press_2022-04-25.comp
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`
Pinned helper source: `src/hal/components/estop_latch.comp`

## Question

The 2022 `press.comp` checks `interlock` only while idle and never reads its declared `abort` pin. Does the surrounding HAL provide an external **software** path that removes ram planner/PID/PWM enable when the remote E-stop signal faults?

This audit intentionally distinguishes the visible HAL software path from unknown cabinet wiring and functional-safety hardware.

## HAL path

The relevant public HAL lines are:

```text
#net abort-motion press.abort hm2_7i97.0.inmux.00.input-01 hm2_7i97.0.ssr.00.out-01

net bend-enable pressgui.enable-button press.interlock simple-tp.0.enable
net bend-enable hm2_7i97.0.ssr.00.out-01
net bend-enable => estop-latch.0.ok-in
net bend-enable => estop-latch.0.reset
net remote-estop estop-latch.0.fault-in <= hm2_7i97.0.inmux.00.input-02-not
net estop-loopout pressgui.enable-light hm2_7i97.0.ssr.00.out-02 <= estop-latch.0.ok-out
...
net bend-enable => pid.0.enable
...
net bend-enable => hm2_7i97.0.pwmgen.00.enable
```

### Direct observations

1. The only shown connection to `press.abort` is commented out, so the declared abort pin is not connected by this HAL.
2. `bend-enable` originates at the GUI enable button and directly drives:
   - `press.interlock`;
   - `simple-tp.0.enable`;
   - `pid.0.enable`;
   - `hm2_7i97.0.pwmgen.00.enable`;
   - Mesa SSR output 01;
   - both `estop-latch.0.ok-in` and `estop-latch.0.reset`.
3. The remote E-stop input drives only `estop-latch.0.fault-in` on the shown net.
4. The latch `ok-out` drives `pressgui.enable-light` and Mesa SSR output 02. It is **not** shown as a producer/gate of `bend-enable`.

Classification: **CONFIG-CONFIRMED** for the shown public HAL.

## Pinned `estop_latch` behavior

Pinned LinuxCNC `estop_latch.comp` describes itself as a software E-stop latch. While OK, `fault_in=true` or `ok_in=false` drives `ok_out=false` and `fault_out=true`. The component documentation gives the typical pattern of routing `ok-out` to an enable input such as `iocontrol.0.emc-enable-in`.

In this Accurpress HAL, however, `estop-latch.0.ok-out` is not shown gating the ram planner/PID/PWM enable chain. It feeds only the GUI enable light and SSR output 02.

Classification: **SOURCE-CONFIRMED** for the helper behavior; **CONFIG-CONFIRMED** for the actual Accurpress routing.

## What can and cannot be concluded

### Software conclusion

From the visible HAL alone, a transition on `remote-estop` that faults `estop-latch.0` does not directly clear the `bend-enable` signal. Therefore it does not, through the shown software nets, directly disable `simple-tp.0`, `pid.0` or `hm2_7i97.0.pwmgen.00`.

This is a **software-path topology statement**, not a claim that the physical machine continues moving.

### Unknown external hardware

The two Mesa SSR outputs are physical outputs whose cabinet destinations are not established by this public HAL text. `estop-loopout` on SSR output 02 may participate in an external loop that removes hydraulic/drive authority independently of the software enable pins. SSR output 01 may also control external authorization. Without the machine electrical drawings or an explicit public wiring description, their physical effects are **UNKNOWN**.

Therefore the curriculum must **not** claim either:

- that the machine lacks a functional E-stop; or
- that the shown `estop_latch` provides the machine's required safety function.

Both would exceed the evidence.

## Interaction with `press.comp`

The companion 2022 component:

- checks `interlock` only in idle state 0;
- never reads the `abort` pin;
- uses `up` as the operational abort/return gesture during approach/bend;
- has explicit pressure-limit state 9;
- has no generic process timeout.

Because `press.interlock` is driven from `bend-enable` rather than `estop-latch.ok-out`, the component also does not receive the shown remote-E-stop latch state through its `interlock` input.

Thus there are two separate public-source observations:

1. no active-state remote-E-stop transition exists inside `press.comp`;
2. no shown HAL software gate connects `estop-latch.ok-out` to the ram planner/PID/PWM enable chain.

Again, external hardware may independently dominate the actuator path.

## Adversarial checks

### “There is an `estop_latch`, so E-stop necessarily disables the PID.”

Rejected. The helper's presence is insufficient; trace its `ok-out`. In this HAL it is not connected to `pid.0.enable` or the `bend-enable` producer.

### “The remote E-stop does nothing.”

Rejected as too broad. It definitely changes the software latch and its `ok-out`, which drives a GUI light and a physical SSR output. The physical consequence of that SSR output is not documented here.

### “Because the SSR output is physical, it is safety-rated.”

Rejected. A physical output being involved says nothing by itself about architecture category, diagnostic coverage, force-guided contacts, safe torque/hydraulic removal, PL/SIL, or compliance.

### “The `press.abort` pin protects the active cycle.”

Rejected for the inspected pair. Its only HAL net is commented and the component function does not read it.

## 4600 design implication

A future generic press-brake playbook must document **both**:

1. the ordinary software authorization chain from machine/cycle enable to trajectory/PID/final actuator command; and
2. the independent safety-authority chain that removes hazardous energy/motion.

An AI reviewer should never infer either path from component names. It must trace the producer of each enable through every gate to the final command/output, then separately trace the safety chain from input device to the actual energy-removal elements.

## Precise next checkpoint

The next useful public-source step is to turn the failure-ownership findings into a **state-by-state generic press-cycle transition contract**, using the Accurpress source only as evidence for real pitfalls:

- state entry prerequisites;
- normal success transition;
- pedal/request behavior;
- motion/SYNC fault interruption;
- process/hydraulic fault interruption;
- process timeout;
- machine-disable behavior;
- safety-permission loss observation (diagnostics only, with enforcement kept separate);
- recovery permission;
- retained diagnostic reason.

Do not assign numerical timeout values or safety response times without machine-specific evidence.
