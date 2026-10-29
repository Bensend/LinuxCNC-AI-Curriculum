# 4400-OVERRIDE-SCOPE-01 — M48/M49 spindle-selection documentation does not match pinned interpreter

**2026-10-29 | 4000 safety-course source-depth | NON-GRADUATED / NO RUNTIME TEST**

## Concrete question and predecessor check
A two-spindle LinuxCNC machine uses ordinary feed/spindle overrides for operator convenience. Does an `M49 $1` command disable the override for spindle 1 only, as the official M48/M49 manual's optional `$` sentence suggests? Can an operator use `M51 P0 $0` to disable only spindle 0? These are **normal control** questions, not safety-speed functions.

Before claiming novelty, searched the full canonical safety index, full research plan and historical PROGRESS for `M48`, `M49`, `M50`, `M51`, `M52`, `adaptive feed` and `feed override`. Existing [FEED-JOG-01](4400_LINUXCNC_FEED_HOLD_INHIBIT_JOG_STOP_SAFETY_AUTHORITY_SOURCE_AUDIT_2026-10-27.md) covers **M53 feed-hold enable** and joint wheel-jog divergence, not M48/M49 dollar-word rejection or M51 spindle-0 selection. [G95-SPEED-01](4400_G95_SPEED_01_LINUXCNC_2910_SPINDLE_SELECTION_RPS_FEEDBACK_AND_FALSE_FEED_SOURCE_AUDIT_2026-10-29.md) covers G95's same-block spindle selector and speed feedback, not override scope. This is a **new exact source/documentation discrepancy**, not a new safety-function competency.

## Pinned evidence — LinuxCNC v2.9.10, commit `86cdca76fa2a36274c432caa21952b23c267989a`

1. **DOC-CONFIRMED:** [Official pinned M-code source, lines 263–303](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/m-code.adoc#L263-L303) says M48 enables feed and spindle overrides, M49 disables both, and these commands take an optional `$` to determine which spindle they operate on. It separately describes M50 feed-only and M51 selected-spindle override. Exact documentation blob `bd388ccd0da40c9a2df2910037ce34de1e47c820`.
2. **SOURCE-CONFIRMED:** [`interp_check.cc` lines 263–272](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_check.cc#L263-L272) allows a standalone `$` only with its enumerated consumers: M3/M4/M5/M19/M51, spindle G-codes, or an S word. **M48 and M49 are not in that list.** Thus a standalone `M49 $1` or `M48 $1` is predicted to be rejected by this check, not to select a single spindle. Exact source blob `ee5164c895dd6610826b8621f64660c90de70233`.
3. **SOURCE-CONFIRMED:** [`interp_convert.cc` lines 3598–3616](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3598-L3616) implements M48/M49 as a feed override command **plus a loop over every configured spindle**. The code does not consult `block->dollar_flag` or `block->dollar_number` in either branch. If a `$` is legal because another command in the same block consumes it, the M48/M49 override loop still has no per-spindle selection. Exact blob `f01a359652d588d59c9e210fa441a99d2ee19598`.
4. **SOURCE-CONFIRMED:** [`interp_convert.cc` lines 3632–3657](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3632-L3657) handles M51 independently. Without `$`, `e=-1` and the loop changes **all** spindles. With `$`, the check rejects `dollar_number <= 0` and `>= num_spindles`; consequently `M51 P0 $0` is predicted to be rejected, even though spindle 0 is otherwise a valid spindle index. `M51 P0 $1` is source-supported for a configuration with at least two spindles. No assertion is made about why the exclusion of 0 exists.
5. **Version cross-check:** Inspected newer pinned development `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7`: [`interp_check.cc` lines 271–279](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/rs274ngc/interp_check.cc#L271-L279) still excludes M48/M49; [`interp_convert.cc` lines 4368–4427](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/rs274ngc/interp_convert.cc#L4368-L4427) still loops all spindles for M48/M49 and rejects `$0` for M51. Source blobs `b2c8bfc80b8e35f8acca3f2dfa535249a47a1712` and `379b21eaba65840ce4160e7ea70df60c12fad9ff`. This is a two-revision static source cross-check, not a run.

## Prediction table (static, not executed)

| Program block, two configured spindles | Source-derived expected interpreter behavior | What must not be inferred |
|---|---|---|
| `M49` | Disable feed override and speed override for both spindle 0 and 1. | Neither spindle has a safety-rated speed cap. |
| `M48` | Enable feed override and speed override for both. | It does not command a safe speed. |
| `M49 $1` | `$` has no accepted consumer; reject before normal M49 conversion. | Do not rely on a successful per-spindle M49. |
| `M48 $1` | Same standalone-dollar rejection. | No selective enable is established. |
| `M51 P0 $1` | Disable spindle 1's speed override only (when spindle 1 exists). | Not a safety-rated speed limit; other paths remain. |
| `M51 P0 $0` | Reject at M51's `<=0` selector check. | Do not assume spindle-0 selective operation. |
| `M51 P0` | Disable speed override for all configured spindles. | Feed override and adaptive feed are separate. |

**Nuance:** A `$` word shared with an S word or other recognized consumer in the *same* block can pass the global dollar check, but M48/M49 themselves still ignore the selector. The exact multi-command side-effect order for any proposed combined block is **not** asserted without its complete interpreter path or runtime witness.

## Safety relevance and practical human factors
A spindle-override slider is a normal operator preference, not independent overspeed protection. On a two-spindle lathe or dual-head mill, a builder might expect `M49 $1` to isolate a single spindle's override, see an interpreter error, or mistakenly conclude the other spindle's override remains available after a successful unqualified M49. The safer ordinary HMI design labels **which spindle's override is actually enabled**, displays the source of the setting, and treats a rejected program block as an error requiring review rather than silently translating it to another action. It does not claim that override state proves actual RPM, chuck/tool retention, standstill, safe access or guarding.

For a machine requiring personnel-protective reduced speed, derive the independent safety function, selected hardware and physical speed witness; do not reclassify M48/M49/M51 or an HMI slider as safety-related control. In OpenPressBrake, no installed spindle is asserted; transfer is only to the general normal-control versus safety-authority distinction.

## Evidence status and next discriminator
**SOURCE-CONFIRMED:** both inspected interpreter revisions and exact branches. **DOC-CONFIRMED:** pinned M-code reference text. **DOC/SOURCE CONFLICT:** M48/M49 optional `$` documentation versus parser/implementation. **INFERENCE:** operational confusion and any actual HMI consequences. **TEST-CONFIRMED none; COMMUNITY-REPORTED none; UNKNOWN:** executable behavior of a specific machine/configuration, physical speed and independent protection.

The static interpreter path already answers the immediate question; **no simulation, GitHub Actions workflow or machine operation justified**. A future isolated parser regression test would be warranted only to resolve a consequential version-specific discrepancy not settled by source, on a proven disconnected local `[self-hosted, openpressbrake]` runner. **G0/G1 HOLD; independent 2520–25F0 evaluation OPEN.**

## Same-session cross-version documentation persistence

The newer inspected development documentation [`m-code.adoc` M48/M49 section](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/docs/src/gcode/m-code.adoc#L331-L346) **still says** M48/M49 accept an optional `$` selector, while the same revision's parser and converter still reject standalone `$n` on M48/M49 and loop over all configured spindles. Development docs blob `5495864386f88238ede66940affaf44c90b1e5e7`. Thus this is not only a stale v2.9.10 manual statement; the **DOC/SOURCE discrepancy persists across both inspected revisions**. This is a documentation/source reconciliation, not a runtime reproduction or upstream defect classification.
