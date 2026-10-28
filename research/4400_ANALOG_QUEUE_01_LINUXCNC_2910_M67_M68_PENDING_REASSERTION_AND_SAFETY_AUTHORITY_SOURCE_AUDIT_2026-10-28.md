# 4400-ANALOG-QUEUE-01 — M68 immediate analog OFF does not cancel an earlier pending M67
**2026-10-28 | LinuxCNC v2.9.10 static source trace | NON-GRADUATED | no runtime/physical test**

## Question and novel mechanism
Can a normal-control sequence request a motion-synchronized analog value using M67, immediately replace the pin value using M68, and then have the **older pending M67 value applied at the next motion**? At the inspected source revision, the separate immediate and pending storage paths permit this sequence. This is a **SOURCE-CONFIRMED code-path implication**, not a TEST-CONFIRMED run or an assertion about an installed OpenPressBrake valve.

This is **not** a discovery that synchronized I/O exists: the [M62–M65 laser source audit](4400_LINUXCNC_PINNED_M62_M65_DIO_MOTION_QUEUE_VS_LASER_SAFETY_INHIBIT_SOURCE_TRACE_2026-10-25.md) and [M63 air-cleaning trace](4400_AIR_CLEAN_01_LINUXCNC_PINNED_M62_M63_QUEUED_AIR_OUTPUT_SOURCE_TRACE_2026-10-27.md) already establish the digital-output queue and abort distinction. **Increment:** an exact *analog* cross-mode overwrite/reassertion path and its physical safety boundary, not another generic queued-output lesson. Full PROGRESS, research plan, canonical index and cumulative design were searched for M67/M68/analog-output predecessors; no named M67/M68 source-depth lesson was found.

## Pinned original source: LinuxCNC/linuxcnc v2.9.10
The following paths were directly fetched from the upstream repository at tag **v2.9.10**. Blob identifiers make the inspected bytes recoverable; line references are to that tag.

| Stage | Exact original source | Observed behavior | Classification |
|---|---|---|---|
| Interpreter | [interp_convert.cc L3381–3395](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3381-L3395), blob `f01a359652d588d59c9e210fa441a99d2ee19598` | M67 calls `SET_MOTION_OUTPUT_VALUE(E,Q)`; M68 calls `SET_AUX_OUTPUT_VALUE(E,Q)`. | SOURCE-CONFIRMED |
| Canonical flags | [emccanon.cc L3232–3266](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L3232-L3266), blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11` | M67 message `now=0`, M68 `now=1`; both append `EMC_MOTION_SET_AOUT` after `flush_segments()`. | SOURCE-CONFIRMED |
| Task | [emctaskmain.cc L1586–1591 and L1960–1965](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L1960-L1965), blob `7292a172023a5b42b023447c2458cb766c93fc9b` | Forwards index/start/end/now to motion; immediate command waits for ordinary prior motion. | SOURCE-CONFIRMED |
| Motion command | [command.c L1534–1544](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1534-L1544), blob `0b79061d39be915bbea548b2c33bb794d31ab302` | `now=1` directly calls `emcmotAioWrite`; `now=0` calls `tpSetAout`. The immediate branch does **not** call `tpClearDIOs` or clear the pending analog mask. | SOURCE-CONFIRMED |
| Pending mask | [tp.c L3608–3615](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3608-L3615), blob `5768d6e6880569f72156ed9a761b5eee531c9fcf` | `tpSetAout` sets `syncdio.anychanged`, ORs `aio_mask`, writes `aios[index]=start`. A second M67 for the **same index** replaces its pending value; other indices retain their pending entries. | SOURCE-CONFIRMED |
| Next motion | [tp.c L1547–1555, L1598–1600, L2491–2504, L3382–3388](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L2491-L2504) | `tpSetupSyncedIO` copies pending state to the trajectory component and clears the pending mask; `tpToggleDIOs` writes the component's analog values on motion execution. | SOURCE-CONFIRMED |
| Abort caveat | [tp.c L3554–3561](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L3554-L3561) | `tpAbort` clears pending synchronized I/O. **Do not** claim that a pending M67 always survives an abort, or that abort itself writes a safe analog value. | SOURCE-CONFIRMED |
| HAL output | [command.c L354–362](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L354-L362) and [motion.c L525–535](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c#L525-L535) | Normal analog HAL output is written only for valid configured channel; actual downstream wiring/actuator is unknown. Named pins are possible; do not assume only numbered pins. | SOURCE-CONFIRMED |

The [official M-code documentation](https://linuxcnc.org/docs/html/gcode/m-code.html) independently documents that M67 is applied at the next motion (or not at all if none follows), while M68 is immediate and breaks blending. **DOC-CONFIRMED**. It does not explicitly describe an M68 canceling a pending M67. The source shows no such cancellation in the inspected branches.

## Adversarial ordering (PAPER ONLY, NOT A RUNNABLE SAFETY TEST)
Assume a valid configured analog channel 0, no intervening abort or queued motion, and normal command execution:

1. `M67 E0 Q1`: pending `aio_mask[0]` requests value 1 at next motion; no immediate analog write.
2. `M68 E0 Q0`: normal immediate write requests value 0, **without clearing** the pending M67 value 1.
3. Subsequent normal G1/G0 motion: `tpSetupSyncedIO` transfers pending value 1; `tpToggleDIOs` can write value 1 at motion execution.

The **conditional reassertion is a source-based inference from confirmed functions**, not a measured HAL waveform. It is a dangerous normal-control assumption if someone interprets M68 as an irrevocable safety OFF. Do **not** perform this sequence on a machine or hazardous analog actuator to verify it. A second M67 on the same channel can replace a pending value, but **neither M67 nor M68 is a protective stop**. M68 alone cannot prove physical OFF, valve closure, ram restraint or safe restart.

## Safety allocation / failure-path review
- **Normal control:** G-code/Task/Motion/HAL/FPGA analog requests may regulate process power, feed or proportional valves. This layer can be delayed, superseded, aborted or wrong.
- **Monitoring:** trend actual analog command, selected driver/actuator feedback and sequence state; do not mistake feedback for independent personnel safety without a qualified safety design.
- **Independent safety-related control:** own guard/AKAS/E-stop response, monitored stop/rearm and any safety-related hydraulic speed/position function. Normal LinuxCNC analog output must have **zero personnel-safety authority**.
- **Physical final elements:** selected hydraulic/electrical/mechanical components must independently establish stopping, gravity-load holding and isolation. An analog zero is not a measured stop or pressure-free state.
- **Human factors:** label normal analog outputs `PROCESS COMMAND — NOT SAFE OFF`, provide a simple independent guard-access/LOTO workflow, and prevent normal recipes from being mistaken for protective inhibit. If guards are cumbersome, fix the ergonomics rather than relying on an M68 macro.

**Qualified evidence to reopen:** selected OpenPressBrake HAL wiring and actual valve driver mapping (if any), selected independent safety program/final elements, and qualified physical stop/hold/rearm witness. No assumption that OpenPressBrake uses M67/M68. G0/G1 **HOLD**, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; no personnel-exposed hazardous operation.

## Evidence and compute
**SOURCE-CONFIRMED** exact pinned implementation above; **DOC-CONFIRMED** official M-code semantics; **INFERENCE** the specified no-abort M67→M68→motion reassertion and any machine-level consequence; **UNKNOWN** actual HAL/driver/wiring, physical output, safety architecture, runtime waveform and stopping/holding; **TEST-CONFIRMED none**; **COMMUNITY-REPORTED none used**. No workflow, simulation, build, test or physical experiment. GitHub-hosted compute **0 min**; self-hosted **0 min**. No lab freeze: source and documentation answer the ordering question sufficiently; a hardware test would require a separately justified, isolated qualified plan.
