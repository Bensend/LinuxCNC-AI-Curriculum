# 4400-SPINDLE-ORIENT-01 — “Oriented” is not “locked” or safe to reach
**2026-10-28 | technician/reviewer field card | PAPER ONLY / UNSCORED / NOT GRADUATED**

Read the [exact LinuxCNC v2.9.10 source audit](../research/4400_SPINDLE_ORIENT_01_LINUXCNC_2910_CUMULATIVE_ACK_VS_PHYSICAL_LOCK_SOURCE_AUDIT_2026-10-28.md) after [BAR-02 Haas M19/physical block](../research/4400_HAAS_AD0021_M19_ORIENTATION_VS_SPINDLE_PHYSICAL_BLOCK_SERVICE_AUDIT_2026-10-25.md) and [ATC-01 tool capture](4400_ATC_01_TOOL_RETENTION_DRAWBAR_PNEUMATIC_RELEASE_AND_SERVICE_MODULE_2026-10-25.md).

## One-minute decision
A green **M19 complete**, `spindle.N.locked`, `spindle.N.brake`, or `spindle.N.at-speed` indication **must not** authorize a person to open a guard, reach into a toolchanger, remove a liner, or put hands near a spindle. LinuxCNC's normal `orient.comp` in v2.9.10 counts **101 qualifying position-error samples cumulatively**, not necessarily consecutively, and has no velocity check. The normal motion controller sets `locked` and **commands** brake when the `is-oriented` input asserts; it does not prove a physical locking pin or brake has engaged. An unwired `at-speed` pin starts TRUE. **These are source-level facts, not evidence of an actual fault on a particular machine.**

## Paper-only failure path
| Observed signal | What it actually tells you | What it does **not** prove |
|---|---|---|
| `orient.is-oriented` | Normal orientation component's accumulated position-error criterion reached | Continuous dwell, true standstill, fresh encoder, physical brake |
| `spindle.N.is-oriented` | HAL input asserted by whatever the machine wires to it | Independent safe-stop or qualified guard-unlock condition |
| `spindle.N.locked` | Motion set an ordinary HAL output after acknowledgment | Mechanical locking force or engagement |
| `spindle.N.brake` | Motion requests a brake state | Brake contact, holding capacity, or stopped spindle |
| `spindle.N.at-speed` | Normal feed/status input, initialized TRUE if unwired | Safe zero speed or confirmed coast-down |
| `spindle.N.on=FALSE` | Normal spindle command off | No orient-PID torque, no residual motion, no stored energy |

**Question for a reviewer:** a technician sees `locked=TRUE`, the spindle coasts slightly, and someone suggests increasing the normal orientation tolerance or adding a longer `debounce` as a “safety fix.” **Response:** do not tune normal control as a substitute for independent protection. Preserve the fault; keep people out; identify the actual safety-rated standstill/guard function (if any), independent final elements, physical brake/lock, isolation and tooling capture. Use qualified manufacturer guidance and controlled validation. Do not bypass the guard to “see if it really stops.”

## Safer architecture is easier
Give operators separate, legible **Orient for process**, **Stopped/guard-release eligible** (only when supported by a validated independent safety function), and **Service isolated/restraint verified** indications. Make the physical guard and approved lock/fixture straightforward to use and reinstall. Avoid ambiguous “LOCKED” HMI text without explaining that the LinuxCNC pin is merely a software state. Require a deliberate new start after protective restoration. If the minimum safe-to-operate boundary cannot be established, **do not operate with people exposed**; any experimental operation needs independent authorization, isolation/remote execution and people outside the hazard zone.

## What remains unproved
Exact selected machine, HAL wiring, encoder fault detection, real spindle stop/coast/hold time, brake/lock capacity, tool capture, guarding, safety function and reset/restart: **UNKNOWN / NOT RUN**. No numeric thresholds, safety PL/SIL or measured stopping distance inferred. No hosted/local compute; no physical test; no independent competency score. OpenPressBrake G0/G1 HOLD; G3/G4 NOT AUTHORIZED.

**Timing and cancellation caveat:** 101 is a count of qualifying `orient.comp` invocations, **not a specified number of milliseconds**. The output clears when orientation is disabled; Motion can nevertheless retain its ordinary `locked` completion latch until a subsequent command changes it. Tagged `emctaskmain.cc` also treats both `ORIENT_NONE` and `ORIENT_COMPLETE` as normal Task wait completion states; a successful Task wait is not a mechanical-restraint certificate. No observed timing or fault injection is claimed.
