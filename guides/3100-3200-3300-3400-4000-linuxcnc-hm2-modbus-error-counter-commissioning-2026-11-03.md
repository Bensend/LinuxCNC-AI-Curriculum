# LinuxCNC Mesa PktUART Modbus: build, schedule, diagnose and verify error counters

**Scope:** 4000 implementation and 3100 mill / 3200 lathe / 3300 plasma / 3400 router / 3600 press-brake transfer. SOURCE/DOC-CONFIRMED, not a validated machine configuration. Read [HM2-MODBUS-175 audit](../research/4400_LINUXCNC_HM2_MODBUS_175_PARSE_ERROR_COUNTER_AND_HAL_DIAGNOSTIC_SOURCE_AUDIT_2026-11-03.md) first.

## 1. Distinguish the three buses

1. hm2_eth is Ethernet transport between LinuxCNC and Mesa FPGA. Its packet-error, io_error and watchdog are **not** Modbus RTU slave reply status.
2. HostMot2 PktUART is an FPGA hardware UART resource; a bitfile exposing pktuart.0 is necessary.
3. hm2_modbus is a HAL realtime state machine using PktUART to exchange Modbus RTU commands with downstream devices. Its command.MM.errors, error-code, disabled, and instance fault are a separate diagnostic namespace.

Do not substitute hm2_modbus for an independent personnel-safety controller, physical STO, or guarded actuator isolation.

## 2. Inspect the upstream working example, not a fabricated production machine

Use upstream development commit 67437d8865e431a9a33f74cee912dbf891d3b4c5:
- configs/by_interface/mesa/hm2-modbus/7i96s-modbus-bldc.ini
- configs/by_interface/mesa/hm2-modbus/hm2-stepper-eth-modbus.hal
- configs/by_interface/mesa/hm2-modbus/brushless-dc-motor-driver.mbccs
- configs/by_interface/mesa/hm2-modbus/brushless-dc-motor-driver.hal

The INI chooses a 1 ms servo period, Mesa 7i96S at 10.10.10.10, one PktUART and the binary command file. Main HAL loads kinematics, motmod, hostmot2, hm2_eth and hm2_modbus, then schedules:

    addf hm2_7i96s.0.read servo-thread
    addf hm2_modbus.0.process servo-thread
    addf motion-command-handler servo-thread
    addf motion-controller servo-thread
    addf hm2_7i96s.0.write servo-thread

The example is not proof that any installed machine has a working Modbus drive, index, safety or feedback chain. Its stepgen position feedback is FPGA generated-step position, not necessarily independently sensed axis position.

## 3. Compile the source configuration (only in a disconnected development environment)

The bundled example has an XML .mbccs source; the INI expects .mbccb binary. The upstream README documents:

    mesambccc -v -o brushless-dc-motor-driver.mbccb brushless-dc-motor-driver.mbccs

Inspect the emitted pin and command map before using it. The MBCCS specifies suspend=true, a 9600-to-57600 startup exchange, and a read-register command for BLDC telemetry. The secondary HAL file sets rtpwm/current/frequency scale factors then sets hm2_modbus.0.suspend false. Suspended startup is an initialization sequencing mechanism, not an independently verified physical inhibit.

## 4. Distinguish observed state from actual slave health

Capture at least these HAL signals at the same servo-cycle boundary: hm2_modbus.0.fault, fault-command, last-error-code, command.00.errors, command.00.error-code, command.00.disabled, suspend, hm2_7i96s.0.packet-error, packet-error-level, io_error and watchdog.has_bit. Pin names must be confirmed with halcmd show pin/param on the actual bitfile and command map. An unchanged process value is not proof of a fresh slave response.

When diagnosing an unexpected 0 in instance fault, inspect command disabled and the per-command counter; when diagnosing an unexpected nonzero errors value after a successful reply, compare internal expected counter transition with the published HAL pin. Never automatically reset a disabled command solely because fault is false.

## 5. Reproducible no-machine oracle

Before executable work, use the A–F controls frozen in the audit and the [fixture README](../examples/4000_hm2_modbus_175/README.md). A packet test must distinguish: valid response, wrong CRC, valid CRC with wrong register byte count, valid CRC with wrong coil/input byte count, timeout, and startup suspension. For each response record requested slave/function/register count, received PDU byte count, CRC validity, parser return, private counter, HAL errors pin, disabled, error-code, instance fault and event sequence.

Expected **current source** trace for five CRC-valid wrong-register-length replies:

    attempt   set_error internal   parser return   after HANDLE internal   HAL errors   disabled
       1             1                 0                    0                 1          0
       2             1                 0                    0                 1          0
       3             1                 0                    0                 1          0
       4             1                 0                    0                 1          0
       5             1                 0                    0                 1          0

This table is a **source-derived prediction, NOT measured output**. For five CRC-invalid replies, the parser returns -1, the private counter should reach five and disabled should assert. The first four normal errors do not necessarily update command error-code, which is written on disable in the inspected code.

## 6. Patch review and acceptance

The review-only patch changes the two wrong-byte-count branches to return -1 and publishes HAL errors=0 after a genuine successful normal-command parse. It deliberately does not redefine the instance fault pin or solve all possible parse error paths. A maintainer should first check that all parse_data_frame switch branches return success only for actual success; then run the A–F matrix against v2.9.10 and pinned development in a qualified disconnected environment, with a mock PktUART if available. Build/test status here: **NOT RUN**.

## 7. Operator and machine integration boundary

For a plasma power source, lathe spindle, router VFD or press-brake auxiliary, the Modbus response may report a device status but cannot itself establish actuator physical state, command freshness, independent stop/hold, or a safe re-enable. Integrate explicit command acknowledgment and freshness checks for ordinary control, plus separate physical safety authority. Preserve all existing independent evaluation and OpenPressBrake G0/G1 holds.

## 8. Fresh-AI challenge (unscored, answers not hidden)

Given a valid-CRC register reply with the wrong byte count repeated six times, explain exactly why the current source may never set disabled. Then explain why a CRC failure produces a different result. Finally identify two HAL pins that can contradict a naive "everything healthy" conclusion after an error. Score this only as a source-comprehension exercise; it is not a blind evaluation and does not change graduation.
