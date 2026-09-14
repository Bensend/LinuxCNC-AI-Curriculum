# 3400 Routers / Woodworking — Motion DOUT transition source closeout

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: **SOURCE-CLOSED at LinuxCNC Motion/HAL layer; physical-output shutdown remains hardware/driver-specific**

## Question

What happens to an already-applied custom `motion.digital-out-NN` value (for example an M64-controlled drawbar output) across program Abort, Motion Disable / machine OFF, E-stop/task state, and shutdown?

This matters because the router ATC examples use custom Motion DOUTs for pneumatic actuators. Built-in `iocontrol.0.tool-change` cleanup must not be assumed to clean arbitrary DOUTs.

## Source trace

### DOUT command ownership

`EMCMOT_SET_DOUT` in `src/emc/motion/command.c` has two paths:

- immediate (`now`): calls `emcmotDioWrite(index, value)` and writes the HAL `motion.digital-out-NN` pin;
- synchronized: queues the DOUT change in the trajectory planner with `tpSetDout()`.

`emcmotDioWrite()` writes `emcmot_hal_data->synch_do[index]`; `control.c` later samples that HAL pin back into `emcmotStatus->synch_do[]` for status reporting.

### Program Abort

`EMCMOT_ABORT` stops active motion according to mode, aborts the coordinated trajectory planner when appropriate, clears motion/joint error state, clears pause/at-speed state, and resets several interpreter-diagnostic pins. The inspected case does **not** call `emcmotDioWrite()` and does not iterate over `synch_do[]` to clear custom Motion DOUTs.

Therefore an already-applied M64 value is not reset by the Motion Abort case itself.

A synchronized DOUT that has not yet executed is different: aborting/clearing the trajectory queue can prevent a queued future transition from occurring. This distinction is important:

`queued future DOUT event != already-applied HAL DOUT state`.

### Motion Disable / machine OFF

`EMCMOT_DISABLE` only clears the deferred `emcmotInternal->enabling` request (plus mode requests for inverse-only kinematics). In the servo controller, the disable transition clears the coordinated trajectory/interpolator state and drops Motion enable. The inspected disable path contains no custom-DOUT reset.

Thus Motion disable and an already-applied `motion.digital-out-NN` are separate state domains at this layer.

### E-stop/task state

The pinned upstream `tests/motion-logger/startup-gcode-abort/expected.motion-logger.in` documents the Task transition into `EMC_TASK_STATE_ESTOP` as:

1. Abort Motion;
2. stop spindle;
3. send E-stop to IO;
4. disable amps;
5. Disable Motion;
6. Abort Motion again;
7. abort IO;
8. unhome volatile-home joints.

The observable Motion sequence contains `ABORT`, `SPINDLE_OFF`, and `DISABLE`, but no `SET_DOUT` cleanup. Since the traced Motion Abort/Disable handlers do not reset custom DOUTs, Task E-stop cannot be treated as an implicit reset of arbitrary `motion.digital-out-NN` state.

This does **not** mean physical machinery remains energized on E-stop. A correctly designed machine may gate field power, output enables, pneumatic dump valves, VFD/drive enable, or other hardware independently. It means only that the generic Motion DOUT value is not itself a safety or cleanup primitive.

### Shutdown / HostMot2 boundary

The Motion/HAL source establishes only the software-pin lifetime while the component remains loaded. On LinuxCNC shutdown, component unloading removes that HAL source; the resulting physical terminal state is driver/FPGA/board and external-circuit dependent.

HostMot2 has a hardware watchdog with a configured timeout between `hm2_*write()` calls. That watchdog is a separate board-level failure mechanism from Motion DOUT semantics. Do not generalize a particular Mesa FPGA watchdog/output-safe-state behavior to every parallel-port, EtherCAT, Modbus, GPIO, custom component, or other output path.

The correct machine contract is therefore:

`program DOUT intent -> Motion HAL pin -> machine-specific HAL interlock/gate -> hardware driver/board -> field power/actuator`

with explicit cleanup/permission at the machine-specific layer when actuator state matters after abort, disable, E-stop, or restart.

## Router / ATC consequence

For a custom rack ATC or drawbar controlled directly by M64/M65:

- do not assume program Abort deasserts the drawbar;
- do not assume machine OFF / Motion Disable deasserts it;
- do not assume built-in iocontrol abort cleanup affects it;
- do not use the Motion DOUT itself as a safety-rated E-stop mechanism;
- explicitly reconcile physical clamp/tool/pocket state after interruption before allowing M6 retry;
- where a fail-safe actuator state is required, enforce it with suitable machine-level logic and/or hardware rather than depending on interpreter cleanup.

## Lab decision

The proposed DOUT transition lab is **not run**. The original uncertainty was whether LinuxCNC Motion itself clears an already-applied DOUT on these transitions. Pinned source plus the upstream Task E-stop motion-logger fixture answer that question directly. A lab would add little independent information unless a future question concerns a specific hardware driver/board terminal state.

A future hardware-specific test may still be valuable for a named board/output path, especially shutdown/watchdog behavior, but that belongs to the relevant hardware integration branch rather than generic 3400 Motion semantics.

## Evidence ledger

- `SOURCE-CONFIRMED`: immediate DOUT writes call `emcmotDioWrite()`; synchronized DOUT writes enter TP.
- `SOURCE-CONFIRMED`: `EMCMOT_ABORT` does not explicitly clear custom Motion DOUTs.
- `SOURCE-CONFIRMED`: `EMCMOT_DISABLE` and servo disable transition do not explicitly clear custom Motion DOUTs.
- `TEST/SOURCE-CONFIRMED`: Task E-stop produces Motion Abort + spindle off + Disable sequence with no DOUT reset command in the upstream fixture.
- `SOURCE-CONFIRMED`: Motion status mirrors current DOUT HAL pin state separately from motion-enable state.
- `UNKNOWN / HARDWARE-SPECIFIC`: exact physical output voltage/current during LinuxCNC process teardown for arbitrary drivers and external circuits.

## Adversarial boundary review

1. Does Abort cancel a future queued synchronized DOUT transition? **Potentially yes through TP abort; do not confuse that with clearing an already-applied DOUT.**
2. Does Motion Disable imply DOUT low? **No evidence; source says no generic reset.**
3. Does E-stop make field hardware safe? **Machine design may do so, but not because Motion DOUT is automatically reset.**
4. Does iocontrol toolchange abort cleanup reset a custom M64 drawbar? **No. They are separate output domains.**
5. Can HostMot2 watchdog behavior be generalized to all output hardware? **No.**
6. Is an M64 drawbar output a safety-rated hold-to-run function? **No evidence; ordinary machine-control output only.**
7. Is blind M6 retry after abort defensible? **No; physical and logical tool state must be reconciled.**

Result: **7/7 boundaries preserved.**

## Promotion / stop

3400 R5 reaches a clean information-gain stop at the generic LinuxCNC layer. Reopen only for a named hardware output path or a real router implementation that adds explicit abort/restart reconciliation. Rotate to an underdeveloped 3000 track rather than over-mining generic Motion behavior.
