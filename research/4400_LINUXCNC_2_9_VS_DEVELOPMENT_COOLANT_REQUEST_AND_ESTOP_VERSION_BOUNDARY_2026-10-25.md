# 4400-DUST-02 — LinuxCNC 2.9 versus development coolant command and E-stop source boundary
**2026-10-25 | SOURCE-CONFIRMED pinned snapshots only | NO RUNTIME | NON-GRADUATED**

## Why this matters
The 4400-DUST-01 source audit identified development Task transitions explicitly calling `emcCoolantFloodOff()`. Do **not** silently assume the same Task source path exists in the 2.9 stable branch, or that either path establishes an external dust collector's actual behavior.

## Exact source snapshots
- Development: `LinuxCNC/linuxcnc@062dc7c097693bb68e76192516cd92878dd5ecdf`.
- 2.9: `LinuxCNC/linuxcnc@a33293f46575c809e082e0806e79ab996f982513`.
- Read `src/emc/task/taskclass.cc`, `src/emc/task/emctask.cc`, `src/emc/task/emctaskmain.cc` at both revisions.

| Behavior | Development 062dc7c | 2.9 a33293f |
|---|---|---|
| Flood ON/OFF dispatch | `emctaskmain.cc:2151–2156` invokes Task methods | `emctaskmain.cc:2055–2060` invokes wrapper methods |
| Task method body | `taskclass.cc:437–448` directly sets `emcioStatus.coolant.flood` and HAL output | `taskclass.cc:644–659` constructs `EMC_COOLANT_FLOOD_ON/OFF` messages and calls `sendCommand` |
| Task state ESTOP/OFF/ON/RESET | `emctask.cc:331–366` explicitly calls `emcCoolantFloodOff()` in these cases | `emctask.cc:309–374` contains **no explicit `emcCoolantFloodOff()`** in corresponding cases; calls `emcIoAbort` in several cases |
| Status-driven additional OFF | `emctaskmain.cc:3605–3610` checks status and requests OFF | `emctaskmain.cc:3431–3435` checks status and requests OFF |

**SOURCE-CONFIRMED:** version-sensitive command-routing implementation and direct Task-state call difference. **UNKNOWN:** exact 2.9 iocontrol downstream `emcIoAbort` output behavior, timing, HAL wiring and physical fan/collector behavior; not inferred from absence of the direct call. Even the development source does not establish when an external relay physically opens, whether a separate collector remains powered, or whether a fire-isolation system responds.

## Safety engineering consequence
Do not build a safety function on assumed M8/M9/E-stop flood-pin timing. A dust collector may be shop-owned, a CNC-owned blast gate may be separate, and the collector's fire/deflagration controls require their own authority. An external physical witness is necessary for each selected machine and software revision. The safest design makes the command/actual-flow/fire-protection distinction obvious to maintainers and does not rely on an undocumented software E-stop side effect.

## Evidence and next work
SOURCE-CONFIRMED exact pinned code; DOC-CONFIRMED no new manufacturer claim; TEST-CONFIRMED none; INFERENCE safety consequence; UNKNOWN downstream iocontrol/selected physical truth. If a real selected 2.9 interface requires source-level routing certainty, trace its pinned iocontrol `sendCommand`/`emcIoAbort` implementation; do not invent a universal physical truth table. No simulation or hosted/local compute justified for the source-path comparison. No physical machine test or independent evaluation.

## 2.9 iocontrol downstream source reconciliation (same session)
The initial source comparison stopped at the Task-to-iocontrol boundary. Subsequent direct source inspection **resolves that specific gap**:
- `src/emc/task/taskclass.cc:592–600` `Task::emcIoAbort(reason)` creates `EMC_TOOL_ABORT` and calls `sendCommand(&ioAbortMsg)`.
- `src/emc/iotask/ioControl.cc:868–876` handles `EMC_TOOL_ABORT_TYPE`, sets `emcioStatus.coolant.flood=0` and `iocontrol_data->coolant_flood=0`. It handles flood ON/OFF at lines 1071–1080.
- `src/emc/iotask/ioControl_v2.cc:1004–1013` likewise clears flood on `EMC_TOOL_ABORT_TYPE`; ON/OFF at lines 1223–1232.
- `src/emc/task/emctask.cc:315–365` invokes `emcIoAbort` for OFF, ESTOP_RESET and ESTOP, but not the ON branch. Thus the **direct Task flood-off calls differ** from development; 2.9 has an **abort-message-to-iocontrol OFF path** for those three states. A 2.9 ON transition is not shown to turn flood OFF by this state handler.
- **SOURCE-CONFIRMED for exact pinned code**, not TEST-CONFIRMED runtime or a selected HAL/physical collector. The specific 2.9 iocontrol executable variant and downstream external wiring remain machine/configuration-dependent.

**Corrected inference:** do not say 2.9 never clears flood on E-stop simply because the direct Task call is absent. Trace the `emcIoAbort -> EMC_TOOL_ABORT -> ioControl[(_v2)]` path. The version difference still matters for command routing and ON-state behavior; it does not grant a reliable collector fire/LEV safety function.
