# 4400 safety — LinuxCNC inhibit/override regression contract (2026-10-13)

**Evidence status:** SOURCE-CONFIRMED conditional expression at pinned LinuxCNC master `2655e62fe6aa38a6a6fa158aab9655911a393c39`; DOC-CONFIRMED published pin and M-code expectations; TEST-CONFIRMED **none**. This is a normal-control correctness investigation, not a personnel-safety qualification.

## Narrow unresolved question

When spindle-speed override is disabled by M49 or M51 P0, does an asserted `motion.feed-inhibit` or `spindle.N.inhibit` continue to suppress the corresponding *ordinary* feed/speed command after the applicable queued/current motion enable mask changes? Source-level Boolean logic is resolved; exact live transition timing and mode-specific exceptions are not.

### Inspected implementation and expected mismatch

- `src/emc/motion/control.c` lines 422–427 selects `enables_queued` in coordinated mode and `enables_new` otherwise.
- Lines 485 and 500 use `enables & hal_get_bool(...inhibit)` to decide whether to zero the feed and spindle scale respectively.
- `src/emc/motion/motion.h` lines 431–435 defines `SS_ENABLED = 0x01` and `FS_ENABLED = 0x02`.
- `src/emc/motion/command.c` lines 1426–1429 clears `SS_ENABLED` for spindle override OFF.
- `control.c` lines 2018–2045 propagates spindle `net_scale` into `spindle.N.speed-out`, while spindle-on is a separate output.
- Current `motion(9)` documentation describes feed-inhibit as inhibiting G-code feed and spindle inhibit as holding spindle speed at zero; the documented behavior does not mention dependency on `SS_ENABLED`.

**SOURCE-CONFIRMED:** with a Boolean TRUE inhibit (1), `enables & 1` is zero whenever `SS_ENABLED` is clear. This is different from a logical test of the inhibit itself. **INFERENCE:** the source path can fail to zero ordinary scale in that state. No machine, drive or physical hazard response has been measured.

## Predeclared bounded regression contract — not executed

Run only on a non-hazardous isolated LinuxCNC test configuration with no connected actuators, if a runtime confirmation is justified for an upstream fix or selected-machine integration. Require a pinned revision, the exact HAL/INI/G-code fixture, actual motion state, both enable masks, inhibit pin state, `net_feed_scale`, `spindle.N.speed-out`, and the requested spindle state at every observation.

| Case | Stimulus | Expected *documented* normal-control proposition | Diagnostic contrast |
|---|---|---|---|
| R1 | Inhibit FALSE, override enabled | Normal nonzero commanded scale permitted | Control baseline |
| R2 | Inhibit TRUE, override enabled | Feed scale / spindle speed command zero in applicable non-synchronized path | Baseline inhibit |
| R3 | Inhibit remains TRUE; disable spindle override via M49 | Inhibit should still suppress the relevant ordinary command | Source expression may not zero scale after selected mask loses bit 0 |
| R4 | Inhibit remains TRUE; disable spindle override via M51 P0 | Same expectation for selected spindle; verify multi-spindle semantics separately | Distinguish global enable mask from spindle selection |
| R5 | Re-enable override while inhibit stays TRUE | Inhibit must not require a new edge to regain effect | Check queued/current transition |
| R6 | Inhibit FALSE after R5 | Normal command may resume under normal machine state | **Not** safety rearm |
| R7 | G33/G76 or G74/G84 | Document exact synchronized/canned-cycle exception and queued flag timing separately | No universal motion-stop claim |

Do not infer physical standstill, braking, energy isolation, or safety-rated stop from a zero software command. If a bounded runtime case is eventually frozen, dispatch it **only** through `[self-hosted, openpressbrake]`, never a hosted runner; record actual job runtime only after authoritative job metadata exists.

## Upstream engineering review, not a code patch

A proposed review question is whether both checks should use the inhibit Boolean directly rather than a bitwise AND with the unrelated spindle override mask. Do not mechanically change source before confirming intended spindle-synchronized exceptions, queue timing, multi-spindle selection, and regression coverage. A fix to ordinary LinuxCNC control would **not** transfer personnel-safety authority to HAL or the FPGA.

## Safety-course transfer

For a press brake, saw, mill, lathe, robot or cutting cell, allocate normal feed/spindle requests to LinuxCNC, diagnostics to independent observations, safety demand/rearm to an independently justified safety-related controller, and hazardous-energy interruption/restraint to selected physical final elements. `SRS` states the physical proposition; `PHY` names actual standstill/restraint/isolation; `AUTH` separates owners; `DEP` records override-mask/common-cause dependencies; `VAL` requires physical witnesses. An asserted normal inhibit is not evidence of a safe state.

**Minimum operate gate:** where the physical protection proposition is unestablished, do not operate with exposed people. Experimental diagnosis must be isolated/remote with everyone outside the hazard zone.

## Provenance

- https://github.com/LinuxCNC/linuxcnc/blob/2655e62fe6aa38a6a6fa158aab9655911a393c39/src/emc/motion/control.c#L422-L505
- https://github.com/LinuxCNC/linuxcnc/blob/2655e62fe6aa38a6a6fa158aab9655911a393c39/src/emc/motion/command.c#L1417-L1435
- https://github.com/LinuxCNC/linuxcnc/blob/2655e62fe6aa38a6a6fa158aab9655911a393c39/src/emc/motion/motion.h#L428-L435
- https://linuxcnc.org/docs/html/man/man9/motion.9.html
- https://linuxcnc.org/docs/html/gcode/m-code.html

Companion earlier source audit remains proposed/unintegrated: `research/LINUXCNC_FEED_SPINDLE_INHIBIT_BITMASK_SOURCE_AUDIT_2026-10-13.md` in the pending 2026-10-13T073346Z patch. This contract must not be mistaken for a completed test.
