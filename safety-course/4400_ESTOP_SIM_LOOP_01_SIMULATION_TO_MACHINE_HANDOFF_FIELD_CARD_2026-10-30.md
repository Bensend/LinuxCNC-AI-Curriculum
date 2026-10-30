# 4400-ESTOP-SIM-LOOP-01 — Simulation E-stop loopback is not a machine E-stop
**PUBLIC UNSCORED technician/AI review card | 2026-10-30 | NO LIVE MACHINE TEST**

## The misleading copy-paste
An official LinuxCNC stepper setup example contains:

```hal
net estop-loop iocontrol.0.user-enable-out iocontrol.0.emc-enable-in
```

The same official chapter says that the example assumes **no external E-stop button**. The `core_sim.hal` file explicitly labels itself a simulation configuration and uses the same loopback. The software output indicates LinuxCNC's internal state; the input is where an external E-stop condition should be reported. A net joining them is **not a physical safety input**.

## Five field scenarios — explain before proposing a change
1. A simulation starts successfully with this line. Does that prove an external E-stop circuit works? **No.** There is no external device in this connection.
2. A real machine has an independent safety relay that opens the motor contactor, but this line remains. Can LinuxCNC still appear internally enabled? **Potentially yes.** Physical stopping may still work independently; software feedback does not prove it.
3. A builder removes the physical relay and relies on `emc-enable-in` alone. Is this a personnel-protective E-stop? **No.** The normal LinuxCNC I/O controller is non-realtime and not a qualified independent safety controller.
4. The operator clears the E-stop and holds Cycle Start. What is required? **Separate, deliberate restart authorization** after independently justified safe state, not an assumed automatic continuation. Actual installed behavior remains UNKNOWN.
5. A technician proposes forcing the input TRUE to silence nuisance faults. What is the engineering response? **Find and repair the fault/status wiring or redesign the nuisance-prone workflow.** Do not defeat the protection or conceal its diagnostic state.

## Paper-only handoff for a qualified reviewer
Record the exact loaded HAL/INI revision, locate every source driving `emc-enable-in`, and trace external protective devices to **independent safety logic**, **physical final elements**, and the **machine-specific stop/hold witness**. Then map any status fed back to LinuxCNC as *diagnostic only*. Include loss-of-power, cable fault, stuck-on, reset/restart, access and gravity/inertia cases. No live probe, guard bypass, motor start or ram movement is requested.

**Authority rule:** LinuxCNC/HAL/FPGA handles normal control and diagnostics; selected independent safety logic owns personnel-protective decisions; final elements and physical validation establish actual safe state. For OpenPressBrake, Y1/Y2 stop/hold and Stage A A–G remain UNKNOWN; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed operation.

**Source trail:** [Pinned source audit](../research/4400_ESTOP_SIM_LOOP_01_OFFICIAL_STEPPER_EXAMPLE_EXTERNAL_ESTOP_FEEDBACK_COPY_RISK_SOURCE_AUDIT_2026-10-30.md), [LinuxCNC v2.9.10 stepper guide](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/stepper.adoc), [simulation HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/lib/hallib/core_sim.hal), [development io(1) pin definitions](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man1/io.1.adoc). **SOURCE/DOC-CONFIRMED** examples and pin roles; **INFERENCE** conditional field failure; **TEST-CONFIRMED none**. This is unscored transfer practice, not a blind evaluator challenge.

## Compare two shipped source configurations
**Simulation/stepper teaching loop:** `user-enable-out → emc-enable-in` is an **internal echo**; the official stepper chapter says no external E-stop button is assumed. **Smithy 924 example:** [`hm2_5i20.0.gpio.037.in → emc-enable-in`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/924.hal#L99-L101) is labeled **Safety Relay Monitoring Contacts**. The second demonstrates how an *external status input* can reach normal LinuxCNC diagnostics; neither file proves actual physical stopping or authorizes copying a relay topology without review. In either case, the selected independent safety system and final elements—not this software feedback—must provide personnel protection.

**Sixth adversarial desk case:** The shipped Smithy example maps a safety-relay monitoring input into `emc-enable-in`, but also sets a separate `Enable` HAL signal TRUE and connects it to PWM/charge-pump/GPIO enables. Does the feedback pin's E-stop state prove all ordinary enables drop? **No.** They are different source nets; independent physical power removal and safe-state behavior remain unverified. Inspect each actual actuator's final element rather than assuming one software status bit controls every output. [Pinned source](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/by_machine/smithy/924.hal#L33-L100).
