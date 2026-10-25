# 4400-SAW-01 — Twelve paper transfer scenarios and blank witness
**2026-10-25 | PAPER / NOT SCORED | no live saw or blade-contact test**

For each case distinguish normal control state, independent safety function, physical hazard, maintenance/guard condition and what selected evidence is missing.

1. Red motor paddle OFF, blade coasting, yellow power ON on a documented SawStop PCS. Which protection may remain active and which hazard persists?
2. Same saw, yellow main power also removed. Can the prior coast-down detection claim be assumed unchanged?
3. LinuxCNC spindle speed reads zero immediately after a stop request. Is blade standstill proven?
4. A blade is swapped to a heavier or unusual tooth design. Which manufacturer compatibility and stopping assumptions become stale?
5. Bypass was used for a special material, and the next shift cuts ordinary stock. Which mode-restoration and fresh-start evidence is required?
6. Felder PCS key switch allows deactivation. Is key possession proof of a safe work method?
7. A blade guard is removed for a wide panel because it is awkward. What low-friction guard/fixture redesign should be considered?
8. A riving knife is removed because the saw has a contact brake. Which distinct hazard worsens?
9. The contact brake works but a board kicks back toward a helper. Which safety function did not address that event?
10. A machine E-stop cuts motor power, but the blade continues to rotate. Can maintenance begin?
11. A protective cartridge reports healthy but the saw has an exposed belt under the table. What remains hazardous?
12. An HMI reports 'safe' while the selected bypass indicator is ambiguous. What should the independent reviewer demand before release?

## Blank qualified selected-machine witness
| Required record | Status |
|---|---|
| Machine, motor, brake/detection model and revision | UNKNOWN |
| Blade/insert/guard and material compatibility | UNKNOWN |
| Power and motor-paddle state versus monitored coast-down state | UNKNOWN |
| Independent blade standstill/guard access and kickback controls | UNKNOWN |
| Bypass authorization, status, duration and restoration | UNKNOWN |
| Maintenance isolation, residual motion, deliberate fresh start | UNKNOWN |
| Qualified no-person-exposure validation method and acceptance | NOT DESIGNED |
| G0/G1/G2/G3/G4 and external competency status | HOLD/HOLD/NOT RUN/NOT AUTHORIZED/NOT AUTHORIZED; NOT SCORED |

Do not perform a skin-contact demonstration, bypass activation, intentional kickback or energized fault injection based on this paper card. No actual stopping time, braking distance, detection reliability or PL/SIL inferred.
