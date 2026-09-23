# 25C0 — Designing for humans who will defeat safeguards: entry model

## Mission

Treat foreseeable safeguard defeat as an engineering input, not as an operator-morality problem. A safeguard that repeatedly blocks necessary setup, recovery, visibility, cleaning or maintenance creates pressure to bypass it. The design response is to remove the incentive where practical, make correct use easy, make defeat difficult, and preserve a safe mode for legitimate exceptional work.

## Authoritative anchor

Pilz's machinery-safety compendium, discussing safeguard manipulation, states that manipulation should be anticipated when restricted machine functions or unacceptable difficulties tempt or force users to improve the safety concept. It recommends anticipating/removing manipulation incentives, making manipulation difficult by design, and using field/service experience to identify deficiencies. Pilz's current ISO 14119 guidance also says all machine lifecycle phases and alternative/setup modes must be considered when preventing manipulation.

Evidence class: **DOC-CONFIRMED** for those principles.

Schmersal's ISO 14119 guard guidance similarly emphasizes evaluation of foreseeable defeat and readily available tools. Current coded interlocks demonstrate one design measure—high coding can make simple spare-actuator defeat harder—but coding does not remove the underlying incentive or prove the complete safeguard adequate.

Evidence class: **DOC-CONFIRMED** for product/standard guidance; **INFERENCE** for the human-factors consequence.

## Defeat-pressure model

For each safeguard, ask four questions before selecting more hardware:

1. **What legitimate task causes friction?** Production loading, jam clearing, setup, alignment, tool change, cleaning, inspection, troubleshooting, maintenance, recovery after a trip.
2. **What does the operator lose by obeying it?** Time, visibility, access, process state, diagnostic information, comfortable posture, easy restart, ability to jog/set up.
3. **What is the easiest foreseeable bypass?** Spare tongue/magnet, taped sensor, defeated latch, held button, bridged contact, software override, leaving a guard removed, repeated indiscriminate reset.
4. **Can the design make correct behavior easier than that bypass?** Hinged/captive guard, better viewing window/lighting, local diagnostic, correctly placed reset, safe setup mode with enabling device, tool-less legitimate access where appropriate, captive fasteners, accessible cleaning point, fault indication that identifies the real problem.

Freeze: **HIGH-CODING INTERLOCK != LOW DEFEAT INCENTIVE.**

Freeze: **DIFFICULT TO BYPASS != CONVENIENT TO USE CORRECTLY.** Both dimensions matter.

Freeze: **NUISANCE TRIP != REASON TO WIDEN OR BYPASS A SAFETY LIMIT WITHOUT REVALIDATION.** The nuisance trip is evidence to diagnose sensor placement, timing, process interaction, contamination, alignment, or mode design.

## Human-factors review table

| Surface | Ask | Red flag | Preferred engineering response |
|---|---|---|---|
| normal production | does safeguarding add repeated unnecessary motions/delay? | guard routinely left open/defeated | redesign access/handling while preserving hazard boundary |
| visibility | can operator see process/tool/workpiece with guard in place? | guard removed to inspect | window, lighting, camera or safer viewing geometry |
| nuisance trips | is the trip understandable and attributable? | repeated reset until machine runs | useful diagnostics; fix root cause rather than weaken trip |
| reset | can resetter see the protected space and know why reset is allowed? | blind/remote reset or confusing multi-reset ritual | deliberate reset location/visibility and clear state indication |
| setup | can required setup be done under a defined restricted mode? | guard defeated to jog/alignment | mode selection + restricted motion + enabling/hold-to-run as justified |
| jam/recovery | is safe recovery fast and obvious? | reach-in while energy remains | designed recovery state and accessible isolation/release method |
| cleaning | are contamination points accessible without dismantling safety hardware? | interlock/guard routinely removed | cleanable geometry/captive access/maintenance mode |
| maintenance | can guard be removed and reinstalled without losing alignment/hardware? | guard discarded after first service | hinges, captive fasteners, locating features, durable connectors |
| diagnostics | does the machine distinguish guard, EDM, drive, pressure, network faults? | technicians bridge channels to find fault | actionable diagnostics that observe but do not own safety authority |
| restart | does clearing a safeguard unexpectedly restart motion? | operators fear normal recovery | reset/rearm separate from motion-start authorization |

## Anti-defeat design sequence

1. Remove or reduce the task friction that creates the incentive.
2. Provide a legitimate mode for necessary exceptional tasks.
3. Make correct safeguard restoration mechanically easy and obvious.
4. Add defeat resistance appropriate to the foreseeable bypass.
5. Provide diagnostics that shorten troubleshooting without bypass.
6. Verify reset/restart behavior and visibility.
7. Review actual service/near-miss/bypass evidence and feed it back into design.

Do not reverse this sequence into `buy a harder-to-defeat switch` while leaving an unusable process unchanged.

## Practical example

A hinged machine enclosure trips whenever opened. Operators must open it repeatedly to align a workpiece and cannot see the alignment through the opaque panel. A high-coded RFID switch may resist a spare magnet/tongue, but it leaves the incentive intact. A better review asks whether a clear impact-resistant viewing panel, improved lighting, external adjustment, or a validated setup mode can remove the reason to open the guard during alignment. If opening remains necessary, the setup mode must define what restricted motion is permitted and under what independent safety controls; ordinary LinuxCNC jog logic is not promoted to personnel-safety authority.

## Minimum-safe-operation boundary

If legitimate setup/recovery cannot be performed without exposing a person to uncontrolled hazardous motion or energy, do not normalize bypass as the operating mode. Redesign the task/safeguard or keep people outside the danger zone during experimental operation. Residual risk and unavailable evidence remain explicit.

## Next work

Turn this model into the required machine-playbook human-factors checklist, then add adversarial reviews covering nuisance-trip pressure, blind reset, maintenance guard removal, setup-mode abuse, poor diagnostics, and production pressure. Preserve machine-specific stopping/energy facts as UNKNOWN unless sourced.

## Sources

- Pilz, *Safety Compendium*, Chapter 4 Safeguards, section 4.4 Manipulation of safeguards.
- Pilz, current `Protection against manipulation / EN ISO 14119` guidance.
- Schmersal, *Safety in system / Design of safety guards under observation of ISO 14119*.
