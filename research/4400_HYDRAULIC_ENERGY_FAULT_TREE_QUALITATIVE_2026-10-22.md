# 4400 — Qualitative hydraulic stored-energy fault tree and independent proof obligations

**Status:** teaching-only logical decomposition. No selected machine, hydraulic truth table, probability, diagnostic coverage or integrity target. Source context: HAWE D 6335/D 6368/B 5488, Parker HY10-1632-M2/US and OSHA 1910.147(d)(5)–(6), detailed in companion research.

## Three different top events

Do not combine these into the single vague top event `hydraulics unsafe`:

- **T1 — unexpected hazardous ram/beam motion while a person is exposed.** This requires a hazardous motion mechanism, an ineffective protective/holding boundary for that scenario, and exposure. Gravity, stored pressure, external force and alternate hydraulic routes are *candidate* mechanisms, not facts about a selected machine.
- **T2 — hazardous pressure release while a person opens a service boundary.** This requires a pressure-containing zone, a path to release into the exposure zone and ineffective energy-control protection. A single pressure tap can be unrelated to the opened volume.
- **T3 — hazardous restart or motion after restoration.** This requires energy/motion capability, a restart demand or inadvertent transition, and ineffective restart/occupancy protection. A stale ordinary LinuxCNC command is one possible input, but the independent safety controller must retain personnel-safety authority.

These are qualitative conjunctions of conditions, not calculated Boolean minimal cut sets for an installed system. Do not assign occurrence probabilities without a defined architecture and failure data.

## Distinct evidence chains

| Claim under review | Candidate observable | Critical missing independence or physical witness |
|---|---|---|
| `valve reached expected state` | exact valve-position sensor | sensor target, shared pilot/reference, valve mechanical behavior, relevant alternate paths |
| `selected line depressurized` | pressure instrument at mapped tap | connected volume, calibration/health, isolation/check elements, reaccumulation |
| `accumulator discharged` | selected discharge-valve feedback and pressure on actual accumulator fluid side | alternate charge source, blocked discharge, gas-side residual pressure and manufacturer instructions |
| `beam physically restrained` | direct selected restraint/load-path evidence | rated mechanical support, gravity/external load, wear, engagement and structural common causes |
| `safe to rearm` | independent safety controller state plus verified physical prerequisites | guard/occupancy, retained start, fault latches, power restoration, unresolved evidence conflict |
| `safe for maintenance` | authorized energy-control and physical verification record | personal lockout, every relevant pressure zone, load restraint, continued verification where needed |

## Four common-cause attacks

**CCF-A — shared hydraulic pilot:** Two electrically separate valve commands share pilot pressure. The same pilot fault can alter both valve responses. The existence of shared pilot in a selected machine is UNKNOWN until the diagram is reviewed. Electrical dual-channel count is not hydraulic independence.

**CCF-B — shared feedback reference:** A common supply/reference or connector fault makes two sensors simultaneously plausible or invalid. Product-specific diagnostics and actual wiring determine whether this is detected; do not assign DCavg or claim safe fault reaction without evidence.

**CCF-C — common pressure-port assumption:** A single gauge is treated as witness for two volumes separated by a seated/check valve. The physical topology may prevent that measurement from covering both volumes. Only the selected schematic/inspection can determine coverage.

**CCF-D — shared load path:** A redundant valve system still relies on one unverified structural restraint or common hydraulic holding path. Component-level redundancy does not establish independent load-holding safety functions.

## Contradiction policy

A controller indication and independent physical witness can disagree. This is not automatically a sensor fault or a controller fault; it is an unresolved *evidence conflict*. Preserve the narrow proposition each witness actually measures, mark the broader `PHY-*` claim NOT ESTABLISHED, block personnel-exposed operation/rearm as appropriate, and open `VAL/DEP/UNK/CHG` records. Do not change software to mask the contradiction before understanding the physical mechanism.

## Human-factor fault path

`test point inaccessible -> frequent guard removal / improvised pressure check -> exposure during maintenance -> bypass normalized` is a foreseeable **INFERENCE**, not an inevitability. The design response is an accessible, protected and labeled test interface, suitable independent instruments, safe visual observation, simple guard restoration, and clear fault/status meaning. A safeguard that is routinely inconvenient enough to invite defeat needs engineering redesign.

## Validation planning, without hazardous test instructions

For each top event, identify the selected SRS and physical safe-state proposition, its final elements, independent witnesses, expected fail disposition, maintenance restriction, and acceptance criteria **before** considering fault injection. Do not perform hazardous faults with exposed personnel. Where a machine lacks minimum independently established protection, testing must be isolated/remote with people outside the danger zone and residual risk explicit. No simulation is justified before the selected hydraulic topology and witness definitions exist.

## Source/evidence ledger

- HAWE/Parker/OSHA facts: DOC-CONFIRMED within their product/regulatory scope.
- The fault-tree decomposition and CCF candidates: INFERENCE/design analysis.
- Actual circuit topology, accumulator presence, pilot/common reference, pressure zones, failure modes, stopping/holding outcomes: UNKNOWN.
- TEST-CONFIRMED: none. SOURCE-CONFIRMED LinuxCNC behavior is only the previously pinned iocontrol ordinary-control interface, not a machine safety function.

## Direct source navigation (publication-review addition)

- [HAWE SAKB D 6335, 08-2025 rev 1.1](https://productfinder.hawe.com/downloads/D6335-en.pdf)
- [HAWE NSV D 6368, 06-2026 rev 1.3](https://productfinder.hawe.com/downloads/D6368-en.pdf)
- [OSHA 29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147)

These links identify source families/editions used by the companion investigation; they do **not** make this qualitative note an as-built machine design or a physical validation result. Verify exact selected product/manual and the proposition each source supports before publication.
