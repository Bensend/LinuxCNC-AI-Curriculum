# M1XX-162 — commissioning user-defined M-codes without mistaking Task completion for machine completion

**Status:** source-grounded implementation walkthrough; no-motion simulation acceptance **NOT RUN**. Cross-machine transfer 3100/3200/3300/3400/3600/4000. Read [source audit](../research/4400_LINUXCNC_M1XX_162_USER_MCODE_TASK_ARGV_PRECISION_ABORT_SOURCE_AUDIT_2026-11-02.md) first.

## Install on an isolated LinuxCNC simulation only

1. Use an independently qualified physically disconnected LinuxCNC simulator, never a panel PC with machine outputs. Do not dispatch hosted Actions. Copy [M150](../examples/4000_m1xx_162/M150) to a directory whose absolute path has **no spaces**, and run `chmod +x M150`. The fixture prints its own argv/PID and has no hardware/IO side effects.
2. Add to a **copy** of the simulation INI: `[RS274NGC] USER_M_PATH = /absolute/no_spaces/mcodes`. Retain existing subroutine paths. Ensure `[DISPLAY]PROGRAM_PREFIX` does not contain a competing executable `M150`. Restart the LinuxCNC Task/application so `emcTaskInit` rescans.
3. Check `M150` recognition in MDI or run the supplied [no-motion G-code](../examples/4000_m1xx_162/test_m150.ngc) only after simulation startup conditions permit it. No axis, spindle, tool, hydraulic or other physical output should be configured.
4. Capture console logs, exact revision, file permissions, Task status and process exit. Do not infer physical device status from Task DONE.

The upstream [xhc-hb04 simulation INI](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/sim/axis/xhc-hb04/mm_base.inc) and [M110](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/nc_files/ngcgui_lib/mfiles/M110) demonstrate real `USER_M_PATH` registration and an external M1xx executable. They are evidence of configuration patterns, **not** evidence that our M150 was run.

## Frozen A–J acceptance cases (all NOT RUN)

| Case | Input / setup | Source-derived expected observation | Discriminator |
| --- | --- | --- | --- |
| A | Executable `M150` present before Task startup, `M150 P1 Q0` | recognized, two numeric argv fields, exit 0 | startup scan / exec |
| B | Create new `M150` only after Task startup | unknown until Task restart | startup registration versus dynamic lookup |
| C | `M150 P0.0000004 Q0` and `M150 P0.0000006 Q0` | argv P prints `0.000000` then `0.000001` | six-decimal text precision |
| D | `M150 P12.3456789 Q0` | argv P prints `12.345679` | normal precision case |
| E | `M150 P1 Q2` (3-second bounded sleep) followed by a second M150 | second helper begins only after first exits | Task wait barrier; actual timing recorded |
| F | `M150 P1 Q7` (script exits 7) followed by another command | Task reports error; subsequent G-code should not execute | child exit versus program result |
| G | `M150 P1 Q9` (8-second bounded sleep), abort during sleep | direct child receives SIGINT in inspected Task abort path | do not assume descendants or machine STOP |
| H | Two executable M150 files in PROGRAM_PREFIX and USER_M_PATH | PROGRAM_PREFIX wins on restart | directory search precedence |
| I | M150 exists but not owner-executable; no other match | unknown M-code | mode-bit gate |
| J | Copy helper to directory containing whitespace | startup may find it, but unquoted path splits at Task argvize | recognition is not successful execution |

Use fresh simulation startup for B/H/I/J to avoid cached registrations. For C/D, inspect **the helper's raw argv strings**, not only Python float conversion. For E/F, retain Task logs and following-command witness. For G, use a bounded child and verify no physical I/O. Case J is an intentionally invalid deployment, not a recommended path convention.

## Interpretation / machine integration

**Do not** put precision-critical bend positions, probe timestamps, lathe phase references or synchronized plasma firing commands into `P/Q` without accounting for the six-decimal formatting boundary. The child receives strings constructed by Task, not the original G-code double values.

**Do not** infer device readiness merely because the helper returned 0. If a peripheral helper is used, it must implement a bounded request/acknowledgement transaction, validate fresh device feedback and return nonzero on failure; any safety-rated function must remain independently implemented and verified.

**Do not** treat M1xx as a servo-cycle callback. The source path is interpreter → Task queue → fork/execvp → waitpid. For path-synchronous signals, inspect native M62/M63/M67 and the motion process boundary; for web/ROS2 exchanges use a separate typed, versioned bridge and explicit freshness policy.

## Review and evidence gate

Record actual LinuxCNC commit, Task log, exact M150 path and permissions, INI search order, argv strings, return status, elapsed times and whether a following G-code line ran. Mark each case PASS/FAIL/HARNESS INVALID with retained raw output. A passing no-motion simulation still cannot authorize real machine operation. Qualified isolated self-hosted compute only; no GitHub-hosted runners; no safety-course advancement or graduated-level reopening.

## Same-session GUI preview discriminator K–L (NOT RUN)

| Case | Input | Predicted result | Required evidence |
| --- | --- | --- | --- |
| K | With no executable M150 registered at Task startup, load a no-motion M150 program into stock Axis preview, then try execution in disconnected simulation | preview parser can accept/display M1xx marker; Task execution rejects unknown M-code | screenshot/preview status **and** Task interpreter error, same INI/startup |
| L | With valid M150 registered, preview then execute `M150 P1 Q7` | preview marker is not a helper invocation; live Task launches helper and rejects its nonzero exit | preview callback path, helper stdout/PID, Task ERROR |

Source: [M1XX-162B addendum](../research/4400_LINUXCNC_M1XX_162_USER_MCODE_TASK_ARGV_PRECISION_ABORT_SOURCE_AUDIT_2026-11-02.md#same-session-gui-preview-continuation--m1xx-162b-visible-m-code-is-not-an-executable-m-code). Stock Axis uses `gcodemodule.cc` preview callbacks for all M1xx numbers; live Task uses startup executable discovery. Do **not** treat successful G-code preview as proof that a custom M-code exists, runs, succeeds, or has actuated any device.
