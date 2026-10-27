# 4400-CHIP-01 — Auxiliary conveyor technician transfer card
**2026-10-25 | 14 PAPER cases | UNSCORED / NOT RUN**

For each case: identify the actual nip/auger/chute hazard, who can command motion, whether physical energy is isolated, the guard/access proposition, and the next qualified witness. Do not touch a moving conveyor, defeat a guard, or test a jam on live equipment.

| # | Situation |
|---|---|
| 1 | Belt is silent midway through a machining cycle; Setting 114 has not elapsed. |
| 2 | A jam stops forward motion; operator assumes it is safe to reach into the chute. |
| 3 | A second person presses manual CHIP REV during cleanout. |
| 4 | M33 has been issued but the drive power remains connected. |
| 5 | CNC main door is closed while an external discharge nip is accessible. |
| 6 | A chip bin is swapped below a raised conveyor while it is enabled. |
| 7 | Main CNC disconnect is locked but auxiliary conveyor has a separate feed. |
| 8 | A guard was removed because screws were repeatedly lost. |
| 9 | Maintenance person wants to remove a stuck chip with a hooked tool. |
| 10 | Overload reverses the belt automatically on one model; another has manual reverse only. |
| 11 | Settings 114/115/196 changed after a controller update. |
| 12 | Power returns with a previously retained ordinary conveyor request. |
| 13 | Machine builder maps a LinuxCNC custom M-code to conveyor output and calls it M31. |
| 14 | A contractor and operator both believe the other owns the isolation key. |

## Blank qualified witness (no fabricated answers)
| Required evidence | Entry | Status |
|---|---|---|
| Exact machine, conveyor model and firmware/options | ____ | UNKNOWN |
| Hazard and external access geometry | ____ | UNKNOWN |
| Timed/reverse/manual command source map | ____ | UNKNOWN |
| Guard and safety-related inhibit circuit, actual final element | ____ | UNKNOWN |
| Separate electrical/pneumatic/mechanical isolation map | ____ | UNKNOWN |
| Physical stop and no-restart validation method/results | ____ | NOT RUN |
| Cleanout usability and guard restoration check | ____ | NOT RUN |
| Qualified evaluator, owner and release decision | ____ | HOLD |

These are learner-visible practice prompts, **not a sealed blind benchmark**. Independent fresh transfer must be separately conducted and scored.

## 2026-10-27 OEM firmware discriminator — not an additional scored exercise
[CHIP-03 original manufacturer-source delta](../research/4400_CHIP_03_HAAS_CONVEYOR_DOOR_OPEN_AUTO_START_SOFTWARE_REVISION_OEM_SOURCE_DELTA_2026-10-27.md) documents Haas service guidance: software **100.17.000.1016** is associated with conveyor/auger starting without operator action even with doors open; the manufacturer recommends **100.17.000.2030 or greater**. A separate pre-fix M31 timer-retrigger behavior is not the same as ordinary scheduled Settings 114/115 cycling. Classic Haas Control and NGC door rules differ. Before evaluating cases 5, 11 or 12, record exact controller family, installed version, option and relevant door/conveyor wiring; otherwise **UNKNOWN**. A software patch or door indication cannot substitute for lockable isolation during hazardous unjamming. No physical test or evaluator result; original 14 cases remain PAPER ONLY.
