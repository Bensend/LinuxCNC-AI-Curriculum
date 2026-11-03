# 4000-LC-HM2-MODBUS-175 — Mesa PktUART Modbus error-count, parse-result and HAL diagnostic audit

**Status:** SOURCE/DOC-CONFIRMED conditional; numerical state predictions INFERENCE; TEST-CONFIRMED none; NOT RUN. Non-graduated 4000 implementation research, 3100/3200/3300/3400/3600 transfer. Inspected 2026-11-03 UTC. No hardware, build, simulation, workflow or external evaluator.

## Why this is new, and predecessor check

This is the **hm2_modbus Modbus RTU application state machine over Mesa PktUART**, not the Ethernet transport packet-counter issue (HM2-ETH-11/14/82/83), HostMot2 watchdog replay (WD-84/85), or SmartSerial remote scanning (SSERIAL-54–57). Search of PROGRESS for hm2_modbus/MBCCB found no predecessor. Historical LAB_COMPUTE_LOG has no hm2_modbus-specific authoritative run. Do not import TEST-CONFIRMED status from generic communication/watchdog labs.

## Pinned primary sources

- LinuxCNC development commit 67437d8865e431a9a33f74cee912dbf891d3b4c5: [hm2_modbus.c](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/src/hal/drivers/mesa-hostmot2/hm2_modbus.c), blob 4935ea3008560bb2b751cefa44c42948b78054d8.
- Stable [v2.9.10 hm2_modbus.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/drivers/mesa-hostmot2/hm2_modbus.c), blob 6754dbd775a8cddbdc5d35b654faa85ff7538d4e.
- [hm2_modbus(9)](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/man/man9/hm2_modbus.9.adoc) (dev), blob 2c82facfa002e386703d9e7249641e57d8b4fb9d; [mesambccc(1)](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/docs/src/man/man1/mesambccc.1.adoc), blob bf70720af8ead80c251a510eabf0656cbbd2857b.
- Upstream example: [7i96s Modbus BLDC INI](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/configs/by_interface/mesa/hm2-modbus/7i96s-modbus-bldc.ini), [main HAL](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/configs/by_interface/mesa/hm2-modbus/hm2-stepper-eth-modbus.hal), [device MBCCS](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/configs/by_interface/mesa/hm2-modbus/brushless-dc-motor-driver.mbccs), [scale HAL](https://github.com/LinuxCNC/linuxcnc/blob/67437d8865e431a9a33f74cee912dbf891d3b4c5/configs/by_interface/mesa/hm2-modbus/brushless-dc-motor-driver.hal).
- Line anchors below are development revision unless prefixed stable. This source was read, not executed. Upstream tests for the exact counter/byte-count conditions were not established by this bounded search; absence is UNKNOWN.

## Controller and real-config contract

hm2_modbus uses HostMot2 PktUART, **not** a generic Linux userspace serial-port Modbus loop. It requires an FPGA bitfile exposing PktUART; hm2_modbus(9) recommends PktUART v3+, supports v2 with limitations, and rejects older versions. The upstream 7i96S INI sets [EMCMOT] SERVO_PERIOD=1000000, [HOSTMOT2] DRIVER=hm2_eth/BOARD_IP=10.10.10.10, [MODBUS] PORTS=hm2_7i96s.0.pktuart.0 and MBCCBS=brushless-dc-motor-driver.mbccb. The HAL loads hostmot2, hm2_eth and hm2_modbus and orders read -> hm2_modbus.0.process -> motion command handler -> motion controller -> write. The MBCCS file has suspend=true, a 9600-to-57600 baud initialization sequence, and a register-read command. The later HAL file sets three scales and then releases suspend. This is an **upstream illustrative configuration**, not a verified production installation.

The official docs define hm2_modbus.N.command.MM.errors as consecutive errors, reset on command success; command.MM.error-code as the last error code; command.MM.disabled as the state after five consecutive errors. They describe instance fault and fault-command separately. These are distinct HAL observables: do not equate fault=false with all commands enabled and fresh.

## Finding A — successful reply resets private count, not published HAL error count

SOURCE-CONFIRMED, both revisions. Development hm2_modbus.c lines 475–488: set_error increments cc->errors and publishes the value to the HAL command errors pin; error-code is published only inside the >=MAX_ERRORS/disabled branch. MAX_ERRORS is 5 (line 66). Lines 1081–1086: STATE_HANDLE_DATA calls parse_data_frame; when return >=0, it sets current_cmd(inst)->errors=0 but does **not** publish zero to inst->hal->cmds[cmdidx].error. Stable lines 1069–1073 and 460–479 are equivalent using direct HAL dereferences.

State inference for two CRC failures followed by a valid response:
- After first failure: private=1, HAL errors=1.
- After second: private=2, HAL errors=2.
- After valid reply: private=0, **HAL errors remains 2**.
- After a new error: private=1, HAL errors=1.

The documented "consecutive errors" HAL pin is stale during recovery. For the first four normal-command errors, error-code may remain zero despite errors>0, because set_error only writes it on disable. The global last-error-code also is not populated by set_error for normal commands; do not treat it as a per-command error mirror.

## Finding B — malformed *CRC-valid* reply length can evade the five-consecutive-errors rule

SOURCE-CONFIRMED control flow; repetition outcome INFERENCE until executed. Development parse_data_frame at lines 1769–1778 (R_COILS/R_INPUTS) calls test_bytecount, then set_error(ERANGE), force_resend, **break** on a mismatch. Lines 1786–1796 (R_INPUTREGS/R_REGISTERS) likewise set_error(ERANGE), force_resend, **break** if the reply's byte count differs from requested register count*2. Both breaks leave the switch and reach the function's final **return 0** (line 1964). STATE_HANDLE_DATA interprets >=0 as success and resets the private consecutive-error counter to zero. Stable v2.9.10 exhibits the same break/return pattern (test_bytecount around 1810–1813, register count around 1826–1831, STATE_HANDLE_DATA 1069–1073).

A repeated, CRC-valid reply with the correct slave/function but wrong byte count is predicted to produce the sequence private 1->0 on each attempt; HAL errors becomes 1, command remains enabled instead of disabling at 5. A corrupted CRC is a **different control**: that branch returns -1 and can accumulate errors to 5. This distinction is crucial; a generic "five bad replies" test that uses only CRC failures misses the bug.

## Finding C — instance fault is not an aggregate per-command-health latch

SOURCE-CONFIRMED. For ordinary commands, set_error only updates command-specific state. STATE_HANDLE_DATA lines 1099–1103 clears inst->hal->fault after completing the frame path **without conditioning on parse_data_frame success**. Thus a CRC failure or a byte-count failure may leave instance fault false even though command errors/disabled remain asserted. A timeout path do_timeout (lines 729–744) explicitly sets instance fault true; it can later be cleared on a subsequent handled frame. Do not wire a process readiness claim to fault alone. Exact temporal visibility in a real HAL sampler is UNKNOWN.

## Other boundaries and open issues

- The register-length mismatch uses byte count versus requested count; the coil/input test also checks PDU size. A CRC-valid malformed frame is feasible as a test oracle, but whether a specific device emits one is UNKNOWN.
- Some other parse cases call set_error and break but still return 0; this audit does not exhaustively classify all parser branches. A bounded follow-up should enumerate every non-success return and pin update.
- Changing instance fault to a persistent aggregate would alter documented/reset semantics; **not proposed without a producer/consumer and machine-state review**.
- A review-only patch for A/B is supplied at ../examples/4000_hm2_modbus_175/development_counter_parse_review_only.patch. It is not applied, built, or executed.
- A model-level deterministic oracle and source-to-machine commissioning guide are at ../examples/4000_hm2_modbus_175/README.md and ../guides/3100-3200-3300-3400-4000-linuxcnc-hm2-modbus-error-counter-commissioning-2026-11-03.md.

## Frozen A–F discriminator / no-motion first

A: 1, 2 CRC errors then valid reply: HAL errors should return to zero on success (currently source predicts stale 2).
B: 5 consecutive CRC errors: disabled asserted at 5, error-code EBADE.
C: 5 CRC-valid, wrong register byte-count replies: expected 5/disabled; current source predicts HAL errors=1 and not disabled.
D: same as C for coils/inputs using test_bytecount.
E: one timeout, then valid reply: distinguish instance fault, per-command count and reset.
F: startup suspend=true; configure scaling in second HALFILE; release suspend; verify no commands emitted before release (requires isolated hardware/simulator and appropriate transport instrumentation).

Freeze the exact frame bytes/CRC, timeouts, HAL snapshots per servo cycle and raw PktUART events before claiming runtime behavior. Never use a personnel-exposed machine as a fault injector. Independent safety authority and existing OpenPressBrake G0/G1 HOLD are unaffected.

## Evidence decision

A/B/C are **source-confirmed control-flow findings**, not measured runtime or physical-machine outcomes. Docs and real example source were inspected. No LinuxCNC build, PktUART simulation, Mesa board, MBCCB compilation, Actions, independent evaluator, or physical test ran. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG remain unchanged. 1000/2000/F02/3000 remain graduated/closed; 4000 non-graduated. Qualified isolated [self-hosted, openpressbrake] runner remains prerequisite for any justified executable oracle; MOTION-144 remains the earlier first executable priority.
