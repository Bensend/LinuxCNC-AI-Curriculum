# 4400-GRIND-01 — Abrasive wheel overspeed, wear and guard integrity
**2026-10-25 | 4400 safety | NON-GRADUATED | 14 PAPER cases, no test**

## Learning outcome
Use [original OSHA/Norton audit](../research/4400_OSHA_NORTON_ABRASIVE_WHEEL_RPM_WEAR_GUARD_AND_CNC_AUTHORITY_AUDIT_2026-10-25.md) to separate wheel maximum marked speed, actual spindle RPM, wheel diameter, guard geometry, inspection/mounting, coast-down and maintenance from ordinary CNC spindle control. This is cross-machine safety methodology, **not** reopening graduated 3700 Grinding/EDM control work.

### Core lesson
**S command accepted != shaft RPM measured != wheel within marked rating != wheel/guard physically safe.** Wheel burst containment and exposure guarding are physical design problems. On a variable-speed grinder, wear changes diameter and surface speed; increasing RPM to compensate can be allowed only within the applicable wheel/machine limits, not simply because the software calculates it. OSHA §1910.215(d)(1) requires machine spindle-speed check before mounting. Guard exposure and mounting requirements depend on wheel/machine type; do not blindly transfer bench-grinder geometry to a CNC surface grinder.

## 14 technician scenarios (learner-visible, unscored)
For each: identify hazardous event, exact wheel/guard/drive variant, ordinary status, protective final element, independent physical witness, residual risk, no-energy review and fresh restart.
1. Replacement wheel marked for lower maximum RPM than the program's previous wheel.
2. Automatic wheel-wear compensation raises spindle RPM near the marked wheel limit.
3. Wheel diameter input is stale after dressing or replacement.
4. CNC `spindle.N.at-speed` is green with no actual spindle feedback wired.
5. VFD reports requested RPM but the speed sensor is on the motor, not the wheel.
6. Guard opening suitable for new wheel becomes excessive after wear.
7. An operator removes a guard for fixture clearance and leaves it off.
8. Ring-test result is claimed as sufficient without examining wheel bond/type applicability.
9. Wheel has correct rating but wrong flange/blotter/mounting arrangement.
10. E-stop turns drive off but wheel still coasts behind a service door.
11. A wheel change occurs while a previous speed override is retained.
12. A technician assumes OSHA offhand-grinder work-rest spacing applies to every CNC grinder.
13. An engineer proposes normal LinuxCNC S-limit software as the only overspeed safety function.
14. A replacement wheel label is unreadable; the shop wants to estimate the rating from an older wheel.

## Blank qualification worksheet
| Required selected-machine evidence | Status |
|---|---|
| Exact wheel type/bond/diameter/marked max RPM and OEM instructions | UNKNOWN |
| Machine spindle/drive max, actual speed sensor location and independence | UNKNOWN |
| Guard type/exposure/strength and physical retention | UNKNOWN |
| Wheel inspection/mounting/flange/blotter/changeover controls | UNKNOWN |
| Overspeed fault response, physical final element and separate witness | UNKNOWN |
| Coast-down, access prevention and standstill proof | UNKNOWN |
| Maintenance isolation, reset, retained request and fresh start | UNKNOWN |
| Qualified observer, dated validation/inspection and residual risk | NOT RUN |

**No lab:** source and engineering reasoning answer the generic question; a live wheel overspeed/burst experiment is neither justified nor authorized. A selected machine needs qualified review and non-hazardous verification. No fabricated wheel RPM, guard strength, stopping time or safety PL/SIL. No personnel-exposed operation on unverified machinery.

**DOC-CONFIRMED** OSHA/Norton, edition-specific; **SOURCE-CONFIRMED** no new LinuxCNC trace, pinned normal at-speed source already exists; **INFERENCE** separate physical safety authority; **UNKNOWN** selected machine; **TEST-CONFIRMED none**. Independent fresh-AI grading remains open and cannot be inferred from these public cases.
