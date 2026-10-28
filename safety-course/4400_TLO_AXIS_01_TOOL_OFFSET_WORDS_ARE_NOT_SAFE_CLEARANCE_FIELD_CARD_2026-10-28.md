# 4400-TLO-AXIS-01 — Tool offset words are not a safe-clearance witness
**Technician field card | 2026-10-28 | paper/source only | NO physical test or machine authorization**

Read [exact pinned source audit](../research/4400_TLO_AXIS_01_LINUXCNC_2910_G432_AXIS_WORD_MODAL_MOTION_DOC_SOURCE_CONFLICT_2026-10-28.md) after [ATC tool retention](4400_ATC_01_TOOL_RETENTION_DRAWBAR_PNEUMATIC_RELEASE_AND_SERVICE_MODULE_2026-10-25.md), [probe prestate](../research/4400_PROBE_EDGE_01_LINUXCNC_2910_G38_PRESTATE_EDGE_AND_FALSE_SUCCESS_SOURCE_AUDIT_2026-10-28.md), and [G64/G92 clearance](4400_PATH_BLEND_G92_01_CLEARANCE_AND_COORDINATE_TRUST_FIELD_CARD_2026-10-28.md).

## What can go wrong?
The v2.9.10 G-code manual says G43.2 offset changes do not cause motion. The inspected interpreter nevertheless **allows G43.2 axis words to inherit an already active G0/G1**, unlike G43.1. The same block can therefore be processed as both an additive offset and a normal traverse/feed request. **Source path confirmed; actual nonzero movement NOT TESTED.** Do not attempt to settle this by trying it on a live machine.

## Five quick discriminators
| Question | Useful evidence | Never infer |
|---|---|---|
| What tool is physically held? | Independently inspected tool, capture and retention | M61/`#5400` proves physical tool |
| What offsets are applied? | Current `#5081–#5089`, units and active modal state | Loaded tool `#5401–#5409` equals applied offsets |
| Does the program change compensation? | G43.1 replacement vs G43.2 additive H/axis form | Every G43.2 axis form is guaranteed motion-free |
| What motion is pending? | Prior G0/G1 mode, reviewed motion queue and clearance | “No G0 on this line” means no motion |
| Can someone access the hazard? | Independently validated guard, stop/hold, energy isolation and restart | A LinuxCNC offset, limit or HMI lamp grants safety access |

## Practical workflow
1. Keep tool measurement/offset editing **separate from** commanded motion; show active tool, applied offset, modal G0/G1, current position and next move in one place.
2. For additive wear offsets, use a reviewed, version-verified procedure. Until the G43.2 axis-word conflict is resolved in a **disconnected simulation**, do not rely on that form to be nonmoving. Ordinary soft limits are not fixture/person clearance proof.
3. Make safe setup, guard replacement, and tool-change verification quicker than bypass. Missing physical proof must display **UNKNOWN / HOLD**, not “ready.”
4. Keep ordinary LinuxCNC/HAL/FPGA for normal control and diagnostics. Independent safety-related control plus physical energy-removal/holding elements must own personnel protection.
5. If minimum stop/hold/guard/restart protection is absent, **do not operate with people exposed**. Any later experimental operation requires separately qualified isolation/remote execution with people outside the danger zone and residual risk stated.

**Status:** DOC/SOURCE CONFLICT; TEST-CONFIRMED **none**; selected OpenPressBrake hardware **UNKNOWN**; independent evaluator **OPEN**; **G0/G1 HOLD**. No person-exposed operation.

**Adversarial caveat:** G43.1's exemption from *inherited* modal motion does not prove that a line explicitly combining G43.1 axis words with G0/G1 is rejected. The manual calls such a combination an error; the pinned source's explicit-motion branch warrants a separate **disconnected-simulation** check. Do not use either unverified form as a physical clearance procedure.
