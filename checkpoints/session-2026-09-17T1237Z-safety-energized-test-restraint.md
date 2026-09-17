# Safety curriculum checkpoint — energized test boundary + physical restraint

- UTC start: 2026-09-17T12:37:04Z
- UTC end: 2026-09-17T12:43:30Z
- Actual elapsed: 6.4 min
- Overlap status: NONE observed. Work followed the newest independent safety checkpoint and did not modify primary OpenPressBrake power/common-map files.
- Compute: NONE. No GitHub-hosted Actions minutes used; no concrete unresolved executable question justified self-hosted `[self-hosted, openpressbrake]` compute.

## Governance/current-state result

Read `START_HERE.md` first, then current mission/order/curriculum/work-selection/source policy/progress and newest safety checkpoints. 1000/2000 remain graduated/closed; work stayed in the 4000 safety course and did not regress to 3300 manufacturing work.

## Durable work

1. `safety-course/SAFETY_ENERGIZED_TEST_POSITIONING_BOUNDARY_CHALLENGE_SET.md` — commit `71443589`.
   - Freezes the narrow boundary between servicing under verified energy control and a genuinely necessary energized test/positioning transition.
   - Requires a concrete reason energy is necessary, restoration of only needed energy where architecture permits, personnel accounting/protection, stale-command neutralization, bounded test action, deenergization, reapplication of physical energy control and re-verification before exposed servicing resumes.
   - Adds ten transfer challenges spanning press brake, servo, plasma, mill/contactor EDM, robot/cell, hydraulic restraint, repeated bypass pressure, stale commands, energized cabinet measurement and home-shop unattended incomplete-machine state.
   - Preserves `LinuxCNC/HAL/FPGA/HMI state != physical isolation`.

2. `safety-course/SAFETY_PHYSICAL_RESTRAINT_BLOCKING_VERIFICATION_WORKSHEET.md` — commit `52cde29b`.
   - Separates command proof, energy-source proof, stored-energy proof and physical load/restraint proof.
   - Adds explicit restraint capacity/load-path/support-point/reaccumulation questions and a restraint-transfer gate.
   - Applies the method to press-brake ram, vertical CNC axis, robot suspended load and accumulator-backed hydraulic examples without inventing machine-specific values.
   - Treats difficult-to-use maintenance blocking as bypass-pressure evidence and requires restoration accounting so a temporary block does not become a restart hazard.

## Source gain

`SOURCE-CONFIRMED`: OSHA 29 CFR 1910.147(f)(1) defines the temporary testing/positioning sequence; 1910.147(d)(5)-(6) covers stored/reaccumulating energy and verification; OSHA's 2024-10-21 interpretation emphasizes that the energized transition is limited to the time actually necessary and does not authorize energized servicing generally. OSHA Appendix A identifies elevated members, springs, flywheels, hydraulic systems and pressure as examples of stored/residual energy and blocking/bleeding/repositioning as example control methods.

The curriculum keeps those workplace requirements bounded to their scope. Home-shop teaching uses the engineering pattern without falsely claiming a workplace rule automatically applies.

## Exact next work

Build `safety-course/SAFETY_ISOLATION_VERIFICATION_INSTRUMENT_AND_OBSERVATION_MATRIX.md` unless a newer primary checkpoint enters the same topic first. It should distinguish command indication, auxiliary/EDM feedback, voltage/pressure sensing, mechanical observation and direct test of isolation; identify what each observation can and cannot prove; cover failed/stale/miswired sensors and common-reference faults; require verification appropriate to each energy domain; and prevent one HMI/safety-controller indication from being treated as universal zero-energy proof. Keep machine-specific instruments, test points, thresholds and hydraulic facts `UNKNOWN` until installed evidence exists.

## LESSON_LOG safe-append payload

The connector does not expose a dedicated append primitive and `LESSON_LOG.md` is a large shared log, so it was not destructively overwritten from an incomplete fetch. Preserve this exact row for the repository safe-append path:

`| 2026-09-17 | 12:37:04 | 12:43:30 | 6.4 | 4000 Safety | Energized test/positioning boundary challenge set + physical restraint/blocking verification | NONE | No compute; commits 71443589, 52cde29b; overlap NONE |`
