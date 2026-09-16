# Safety Maintenance Handoff / Shift-Change Continuity Worksheet

## Purpose

Use this worksheet when safety-related maintenance, troubleshooting, replacement, validation, or restoration is incomplete at a technician/crew/shift handoff. It preserves what is physically controlled, what is incomplete, and what the incoming authorized worker must independently verify before exposure or work resumes.

Evidence labels: `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`.

## Frozen rule

**A handoff record transfers information and responsibility; it does not transfer proof. Locks/tagout devices, isolation, blocking, restraint, stored-energy control, and required verification remain physical protections. The incoming worker must not rely solely on the outgoing worker's statement, CMMS state, HMI indication, or this worksheet as proof that hazardous energy is controlled.**

A safety-relevant `UNKNOWN` remains `UNKNOWN` across shift change. It may not be silently converted to assumed-safe because the outgoing worker left.

## Authoritative basis

### E1 — continuity across shift/personnel changes

Classification: `SOURCE-CONFIRMED`.

OSHA 29 CFR 1910.147(f)(4) requires specific procedures during shift or personnel changes to ensure continuity of lockout/tagout protection, including orderly transfer between off-going and oncoming employees to minimize exposure to unexpected energization/startup or release of stored energy.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

### E2 — incoming verification is not replaced by briefing

Classification: `SOURCE-CONFIRMED`.

OSHA guidance states that an incoming employee should not depend on another employee or supervisor who has left for assurance that equipment is safe. OSHA interpretation also states that merely reviewing tests in a job briefing and relying on a locked lockbox is insufficient; verification is required on each shift before authorized employees begin work.

Sources:
- https://www.osha.gov/etools/lockout-tagout/hot-topics/energy-control-program/energy-control-circuitry-prohibition
- https://www.osha.gov/laws-regs/standardinterpretations/1999-11-16

### E3 — stored/reaccumulating energy remains part of the handoff

Classification: `SOURCE-CONFIRMED`.

OSHA 1910.147(d)(5) requires potentially hazardous stored/residual energy to be relieved, disconnected, restrained, or otherwise rendered safe; where it can reaccumulate to a hazardous level, verification must continue until servicing is complete or reaccumulation is no longer possible.

Source: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

### E4 — out-of-service status is not a substitute for LOTO during exposure

Classification: `SOURCE-CONFIRMED`.

OSHA's 2025 interpretation permits non-LOTO continuity/out-of-service devices while awaiting parts only when no employee is exposed to hazardous unexpected energization/startup or release of stored energy. Before servicing exposure resumes, authorized employees must verify isolation and apply the required lockout/tagout protection.

Source: https://www.osha.gov/laws-regs/standardinterpretations/2025-11-24

These sources establish energy-control continuity principles. They do not establish machine-specific safe hydraulic states, pressure limits, blocking methods, stopping distances, or safety-performance levels.

## Handoff identity

| Field | Record |
|---|---|
| Machine / asset | |
| Work order / incident | |
| Date/time | |
| Outgoing authorized worker / crew | |
| Incoming authorized worker / crew | |
| Overall job-control responsible person if applicable | |
| Current machine status | OUT OF SERVICE / LOCKED-TAGGED / TESTING TRANSITION / INSTALLED-PENDING-VALIDATION / OTHER |
| Related energy-control procedure | |
| Related substitution/change-impact/validation record | |

## 1. Hazard and energy-state map

Do not write only `machine locked out`. Record each relevant energy path.

| Hazard / energy source | Isolation point / control method | Physical device/state | Stored or gravity energy control | Reaccumulation possible? | Incoming verification required | Evidence/status |
|---|---|---|---|---|---|---|
| Electrical mains | | | | | | |
| 24-V/control power | | | | | | |
| Drive DC bus / capacitors | | | | | | |
| Hydraulic pressure/accumulator | | | | | | |
| Pump/motor energy | | | | | | |
| Pneumatic pressure | | | | | | |
| Gravity / raised members | | | | | | |
| Springs / mechanical stored energy | | | | | | |
| Thermal/process/other | | | | | | |

If a source remains energized, state why, what exposure is prevented, and what exact boundary prevents it from becoming hazardous. Do not infer that STO, a software disable, E-stop, closed valve, HMI status, or ordinary FPGA output is an energy-isolating device without authoritative machine/procedure evidence.

## 2. Physical protection continuity

| Item | Outgoing state | Incoming independently verified? | Evidence / discrepancy |
|---|---|---|---|
| Personal/group locks and tags | | | |
| Group lockbox / keys / responsibility | | | |
| Disconnects / isolating valves | | | |
| Blocks / pins / mechanical restraint | | | |
| Pressure discharge / accumulator control | | | |
| Reaccumulation monitoring/control | | | |
| Barriers / restricted work area | | | |
| OUT OF SERVICE / DO NOT OPERATE status | | | |

**Hard stop:** if the incoming worker cannot verify the protection required by the applicable energy-control procedure, do not resume exposed servicing. Resolve the discrepancy first.

## 3. Incomplete safety-system state

| Safety-related item | Exact current state | What is physically missing/changed? | Evidence label | May normal production resume? |
|---|---|---|---|---|
| E-stop chain | | | | NO unless validated/restored |
| Guards/interlocks/locks | | | | |
| Light curtain/laser/protective device | | | | |
| Safety relay/PLC/I/O | | | | |
| Contactors / EDM | | | | |
| Drive STO/safe-motion | | | | |
| Hydraulic/pneumatic safety final elements | | | | |
| Mechanical restraint/holding function | | | | |
| Reset/restart/rearm path | | | | |

## 4. Temporary maintenance/test alterations

Every temporary alteration gets its own row. `None known` is weaker than a deliberate inspection.

| Temporary alteration | Location / exact identity | Why installed | Can it defeat/alter a safety claim? | Removal/restoration condition | Incoming verified present/absent |
|---|---|---|---|---|---|
| Jumper / bridge | | | | | |
| Forced I/O / software force | | | | | |
| Test plug / breakout | | | | | |
| Bench supply / USB / external ground | | | | | |
| Diagnostic override / maintenance parameter | | | | | |
| Removed guard / switch actuator | | | | | |
| Temporary hose/valve/mechanical fixture | | | | | |

A reboot-cleared software force does not prove that physical jumpers, fixtures, bypass plugs, changed wiring, or maintenance parameters were restored.

## 5. Replacement / repair state

| Field | Record |
|---|---|
| Failed/removed component | |
| Installed component exact MPN/revision/firmware | |
| Exact / manufacturer-approved successor / engineered equivalent / UNKNOWN | |
| Provenance record | |
| Wiring/configuration changes | |
| Mechanical alignment/actuation changes | |
| Calibration/teach data affected | |
| Safety-network/device identity affected | |
| Current lifecycle state | QUARANTINE / APPROVED-SPARE / INSTALLED-PENDING-VALIDATION / IN-SERVICE-VALIDATED |
| Change-impact/equivalence record | |

`INSTALLED-PENDING-VALIDATION` must not become `IN-SERVICE-VALIDATED` merely because the machine powers up or ordinary motion works.

## 6. Unresolved observations and UNKNOWNs

| Question / discrepancy | Why it matters to safety | Current evidence | Exact evidence needed to close | Owner |
|---|---|---|---|---|
| | | | | |

Examples that must remain explicit when applicable: unknown hydraulic spool/fail state; unknown stored pressure; unverified EDM feedback; uncertain guard alignment; unverified safety signature/configuration; unknown jumper status; unresolved reaccumulation; untested reset/restart behavior.

## 7. Exact next safe work step

Do not hand off `continue troubleshooting`. Define the next bounded step.

| Field | Record |
|---|---|
| Question to answer | |
| Required physical protection before starting | |
| Required incoming verification | |
| Test/inspection stimulus | |
| Independent witness/observation | |
| Expected bounded result | |
| If result fails | remain/return OUT OF SERVICE; record failure; do not weaken safety claim |
| Required restoration after test | |

If temporary energization is required for testing/positioning, use the applicable controlled deenergize/remove-control/energize-test/deenergize/reapply-control sequence; do not turn a bounded test state into production permission.

## 8. Responsibility transfer gate

Outgoing worker confirms:

- [ ] current hazardous-energy state is recorded without substituting paperwork for physical control;
- [ ] every known temporary jumper/force/fixture/override is recorded;
- [ ] removed or incomplete safeguards are recorded;
- [ ] installed-but-unvalidated replacements are clearly identified;
- [ ] safety-relevant `UNKNOWN`s are preserved;
- [ ] exact next work/validation step is recorded.

Incoming worker confirms before exposed work:

- [ ] applicable personal/group LOTO protection is correctly established for this shift/work;
- [ ] required isolation/deenergization has been independently verified under the applicable procedure;
- [ ] stored/residual/reaccumulating energy and mechanical/gravity restraint have been checked as applicable;
- [ ] temporary alterations and incomplete safeguards have been physically reconciled against this record;
- [ ] discrepancies were resolved before work resumed.

| Transfer | Name / role | Date/time | Notes |
|---|---|---|---|
| Outgoing | | | |
| Incoming | | | |
| Coordinating authorized person if applicable | | | |

## 9. Return-to-service gate

This handoff worksheet **cannot authorize return to service by itself**. Before normal production, the applicable closeout must establish, within the affected scope:

1. maintenance/test tools, jumpers, forces, fixtures, temporary supplies and overrides removed;
2. original or approved wiring/configuration/mechanical installation restored;
3. guards/protective devices restored;
4. replacement/change-impact requirements satisfied;
5. affected physical safety functions and relevant fault paths re-challenged;
6. EDM/final-element proof checked where applicable;
7. reset/restart/rearm behavior validated;
8. personnel cleared and applicable energy-control release procedure completed;
9. unresolved safety-relevant `UNKNOWN`s either closed or explicitly prevent return to service.

## Failure-path challenges

Before accepting a handoff, challenge these cases:

1. Outgoing technician says `hydraulics are safe` but no exact pressure/isolation/restraint evidence is recorded.
2. Personal locks are removed before incoming protection is established, creating an unprotected transfer gap.
3. Incoming shift trusts the lockbox/job briefing without performing its required verification.
4. Machine is marked OUT OF SERVICE overnight, then exposed servicing resumes without renewed/continued LOTO protection.
5. Guard is physically reinstalled but a temporary actuator/jumper remains.
6. Software force disappeared on reboot, so the team assumes all test alterations are gone.
7. Replacement safety device powers up normally but remains `INSTALLED-PENDING-VALIDATION`.
8. Raised beam/axis is electrically isolated but gravity restraint is not transferred/verified.
9. Accumulator was discharged on the prior shift but can reaccumulate.
10. LinuxCNC/HMI says `SAFE` while independent safety-controller/final-element state is unresolved.
11. One crew believes another crew owns overall group-lockout responsibility.
12. An unresolved `UNKNOWN` is omitted from the new shift's work order because it was verbally discussed.

## LinuxCNC / FPGA boundary

LinuxCNC/HAL/FPGA/HMI may display maintenance state, preserve logs, inhibit ordinary commands, and make incomplete work obvious. These are useful defense-in-depth and human-factors aids. They do not replace physical energy isolation, personal/group lockout, blocking/restraint, independent safety-system authority, or incoming verification. Reboot/network recovery must not silently turn an incomplete maintenance state into normal actuator permission.

## Next-work checkpoint

Build a **return-to-service restoration sweep worksheet** focused on the final transition from maintenance/test state to production. It should cross-check temporary jumpers/forces/fixtures, guards, wiring/configuration, final-element feedback, stored-energy controls removed only when appropriate, affected safety-function re-challenges, reset/restart behavior, personnel clearance, and configuration/evidence identity. Keep it independent of the primary lane's setup/service-mode and professional machine trace work.