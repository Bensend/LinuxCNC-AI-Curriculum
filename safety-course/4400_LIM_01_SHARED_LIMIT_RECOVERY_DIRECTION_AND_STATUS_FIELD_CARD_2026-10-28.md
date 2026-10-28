# 4400-LIM-01 — Shared hard-limit recovery is not a safe-direction detector
**2026-10-28 | practical technician/source-reading card | PAPER ONLY**

**The important distinction:** a normal LinuxCNC limit switch tells the controller an input is active. It does **not** prove a machine is safely stopped, physically held, free of trapped pressure, or clear of people.

## The surprising v2.9.10 behavior
The pinned [source audit](../research/4400_LIM_01_LINUXCNC_2910_SHARED_HARD_LIMIT_OVERRIDE_DIRECTION_AND_STATUS_SCOPE_SOURCE_AUDIT_2026-10-28.md) traces `joint_jog_ok`: with **separate** positive and negative limit signals, the source rejects a jog farther into the asserted limit. With a **shared** signal that sets both flags, its code explicitly cannot know the safe direction and skips that local direction check. This is not permission to move. Other constraints may still act, but none proves the machine's physical safe direction.

A second trap: `halui.joint.N.override-limits` is populated from a **global any-override** status in the pinned Task code. A joint-specific-looking green light does not prove which joint's limit was overridden. The command builds its mask from all currently tripped joints, not solely the nominal joint argument.

## No-energy desk review
| What a reviewer sees | What can be claimed | What cannot be claimed |
|---|---|---|
| One limit active, distinct + / - wiring documented | Controller can distinguish sign in its ordinary jog check. | No guarantee of clearance, deceleration or personnel protection. |
| Both signs active, shared wiring or unexplained fault | Controller cannot infer which direction is safe from those flags. | Do not approve a guessed recovery jog. |
| Per-joint override indicator true | Some ordinary override mask bit is active. | Do not infer the displayed joint alone is bypassed. |
| `HOME_IGNORE_LIMITS=YES` | Homing has a distinct exception for its own limit check. | No safe homing direction, switch geometry or machine-specific release proven. |
| Jog completes, mask returns to zero | Ordinary LinuxCNC monitoring is re-enabled in the inspected path. | Does not prove safety output action, ram holding, clearance or safe restart. |

**Safer/easier workflow:** document actual switch identities, accessible inspection points, directional markings, and a clear **stop/inspect/repair/requalify** route. A recurring need to defeat a limit or remove a guard is an engineering usability defect. For a press brake, never use a generic LinuxCNC jog to replace independent Pilz/AKAS safeguarding, Y1/Y2 gravity restraint, and qualified isolation.

**Do not perform an energized test to answer this lesson.** A qualified machine team must separately establish any recovery method and exclude personnel from the danger zone. Preserve the actual wiring, selected hardware and test results privately; publish only redacted status. No OpenPressBrake machine facts or independent competency scores were established.
