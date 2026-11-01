# 4000 / 3100 — LinuxCNC leadscrew compensation: disconnected calibration and reload acceptance

**Status:** SOURCE/DOC-CONFIRMED planning only; all 14 cases **NOT RUN**. No installed machine, no hardware or Actions compute. Based on [COMP-88](../research/4400_LINUXCNC_COMP_88_LEADSCREW_TABLE_PARSE_FALLBACK_SOURCE_AUDIT_2026-11-01.md), [COMP-89](../research/4400_LINUXCNC_COMP_89_TCL_RELOAD_JOINT_AND_ACK_SOURCE_AUDIT_2026-11-01.md), stable v2.9.10 and pinned development \`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1\`.

## 3100 mill/lathe/gantry calibration contract

- Measure **physical tool-point position with an independent instrument** in machine units, at ascending nominal positions in both travel directions. Distinguish encoder motor position from physical linear displacement, hysteresis and thermal drift. Do not infer physical accuracy from a compensated HAL feedback pin.
- For \`COMP_FILE_TYPE=0\`, rows are \`nominal actual_forward actual_reverse\`. For type 1 they are \`nominal forward_trim reverse_trim\`; type-1 trims equivalent to type-0 are \`nominal-actual\`. Limit 256 rows, strictly increasing nominal values. Avoid blank/comment-only lines in a native LinuxCNC file.
- Copy an upstream sim fixture for **syntax understanding only**: [servo_sim.ini](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/tklinuxcnc/servo_sim.ini) and [screwcompX.dat](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/tklinuxcnc/screwcompX.dat). The sample has a large artificial -4-position deviation and must not be treated as machine metrology.
- INI skeleton for an **offline simulator**: \`[JOINT_0] MAX_VELOCITY=1.0; MAX_ACCELERATION=10.0; BACKLASH=0.02; COMP_FILE=comp0.dat; COMP_FILE_TYPE=0\` (one key per line in the actual INI). Use the upstream complete simulation INI/HAL for other required keys. Do not change real-machine configs.
- Example \`comp0.dat\` (no header or blank lines): two lines, \`0 0.002 -0.003\` and \`10 10.004 9.998\`. Equivalent type-1 lines: \`0 -0.002 0.003\`, \`10 -0.004 0.002\`. At nominal 5, target forward/reverse trims \`-0.003/+0.0025\`. Filtered realtime motor command only converges toward the target; exact convergence time depends on servo period, limits and feed scale.

## Frozen disconnected cases

| Case | Input / setup | Source-derived prediction to check | Required evidence |
|---|---|---|---|
| C1 | Valid type-0 two-row table | Two entries accepted, interpolation at 5 yields -0.003/+0.0025 target trims | Parsed rows, Motion table, HAL correction by direction |
| C2 | Equivalent type-1 table | Same target trims as C1 | File type, per-joint HAL trace |
| C3 | Header \`# calibration\` before rows | Parser stops immediately, returns 0 if no transport error; with BACKLASH=0.02 and no table entries, runtime targets +/-0.01 | Loader return, entries, HAL backlash-corr |
| C4 | Blank line after first valid row | Loader stops; only first entry accepted; no later interpolation | Loader return, table entry count, HAL trace |
| C5 | Descending/duplicate nominal after two rows | Motion logs ordering error; no append for offending row; commandStatus may remain OK | Error channel, commandStatus, table entries |
| C6 | 257 strictly increasing rows | 257th append refused; caller may still see OK | Error channel, 256-entry table, return |
| C7 | Native table reloaded unchanged | Append-only path rejects duplicate range, does not replace | Before/after entry count, error log |
| C8 | Reload a file whose nominals all exceed previous max | Existing table extended, not replaced | Entry count and interpolation |
| C9 | Tcl \`emc_joint_load_comp 1 <file> 1\` on two-joint development fixture | Serialized command carries joint 0 despite requested 1 | Tcl/NML/Task trace and joint-specific HAL |
| C10 | Same Tcl call on stable v2.9.10 | Joint field is not explicitly initialized; actual target **UNKNOWN** until observed | Serialized NML bytes and Task target |
| C11 | Tcl invalid type \`not-a-number\` | Error message set but Tcl returns OK and may send indeterminate type | Tcl result, NML send trace, no physical I/O |
| C12 | Missing file through Tcl vs INI startup | Loader fopen returns -1; Tcl return can still be OK, startup INI path returns error | Task result, Tcl result, startup log |
| C13 | Motion reversal, zero velocity, feed-hold | Target follows velocity sign, holds last target at zero velocity; filtered correction ramps subject to net feed scale | Same-servo-cycle \`joint.N.vel-cmd/backlash-corr/backlash-filt/motor-pos-cmd\` |
| C14 | Closed-loop motor feedback with external metrology | \`joint.pos-fb = motor.pos-fb - (backlash_filt+motor_offset)\`; physical accuracy not guaranteed | HAL values plus independent measured tool-point error |

All C1–C14 are **NOT RUN**. Case C10 deliberately has no guessed stable target. Source-level prediction is not a pass verdict.

## Strict preflight reference

The optional [pure Python checker](../examples/4000_linuxcnc_comp_table_preflight.py) rejects malformed lines, nonfinite numbers, nonmonotonic nominals and >256 entries, and computes type-0/type-1 normalized trims. It is **intentionally stricter** than LinuxCNC's native parser (which accepts extra tokens after three numbers). It has embedded unit tests but **was not executed**. Suggested isolated invocation:

~~~sh
python3 examples/4000_linuxcnc_comp_table_preflight.py --self-test
python3 examples/4000_linuxcnc_comp_table_preflight.py comp0.dat --type 0 --at 5
~~~

## Verification gate and next work

Only run software-only tests when an independently qualified, disconnected \`[self-hosted, openpressbrake]\` runner is available. No GitHub-hosted Actions fallback. Record exact upstream tag/commit, actual fixture bytes, commands, stdout/stderr, Task/NML trace, HAL samples, test verdicts and authoritative job runtime. A validator PASS does **not** authorize motion, establish tool-point metrology, or override independent safety and evaluation gates. Otherwise rotate to a distinct LinuxCNC implementation question.
