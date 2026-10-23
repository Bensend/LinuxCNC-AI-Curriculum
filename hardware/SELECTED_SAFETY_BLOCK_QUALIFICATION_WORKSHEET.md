# Selected Safety Block Qualification Worksheet

Purpose: learner-facing gate between a reusable safety block template and schematic capture. Completing this worksheet permits engineering capture only when the evidence supports it; it does **not** establish machine validation, certification, achieved PL/SIL, or permission to operate hazardous machinery.

## A. Identity and provenance

- Block instance ID:
- Template/family:
- Manufacturer:
- Exact part/family and hardware revision:
- Safety manual/datasheet revision/date:
- Configuration/firmware relevant to safety behavior:
- Evidence classification for each source (`DOC-CONFIRMED`, `SOURCE-CONFIRMED`, `TEST-CONFIRMED`, `INFERENCE`, `UNKNOWN`):

## B. Traceability allocation

- `SRS-*` implemented:
- `PHY-*` required:
- `AUTH-*` authority allocation:
- `DEP-*` dependencies/CCFs:
- `ARC-*` architecture allocation:
- `VAL-*` validation cases:
- `HF-*` human-factor constraints:
- `CHG-*` active changes/stale evidence:
- Current UNKNOWNs:

No upstream ID may silently disappear. Resolve or explicitly carry `STALE`, residual-risk and UNKNOWN state.

## C. Electrical/interface evidence

Record selected-device evidence, not generic curriculum values:

| Item | Product value/behavior | Source | Evidence class | Blocking unknown? |
|---|---|---|---|---|
| supply/reference | | | | |
| input thresholds / leakage | | | | |
| output type / current / load | | | | |
| test-pulse / OSSD behavior | | | | |
| filtering / timing assumptions | | | | |
| de-energized state | | | | |
| protection / wiring constraints | | | | |
| connector/pin behavior | | | | |
| environmental limits | | | | |

### Cross-product compatibility gate

When the chain uses separately selected products/families, record evidence for each interface, not merely each component in isolation:

| Producer -> receiver | Electrical compatibility | Pulse/filter/diagnostic interaction | startup/reset interaction | manufacturer application restriction | Evidence | Blocking unknown? |
|---|---|---|---|---|---|---|
| | | | | | | |

Matching nominal voltage, connector type or logical signal name is not sufficient compatibility evidence. Unresolved behavior that can alter detection, fail-safe state, diagnostics, reset/rearm or output authority is **SCHEMATIC-BLOCKING**.

### Pulse-parameter direction and target gate

A numeric pulse tolerance is **not transferable between ports**. For each safety-related signal, record separately (a) who generates the pulse, (b) whether it is an OSSD output test pulse, a safe-controller output pulse driving a solenoid, or a supply interruption, (c) the exact receiver/target and its documented behavior, and (d) the safety-controller input filter and fault-detection configuration. A matching `5 ms` number or 24 V supply does not establish compatibility. In the documented EUCHNER CTP-I.-AP (2126290-08-07/24 §10.9) and CTP-L.-AP (2124217-08-06/21 §10.10) examples, `5 ms` is specified for **solenoid-control output pulses** and separately for UB supply dips; the FO1A/FO1B receiver must instead meet its own pulsed-OSSD requirements and selected switch data. See `research/4400_CTP_SAFE_RECEIVER_VS_SOLENOID_PULSE_INTERFACE_NOTE_2026-10-22.md`. These are DOC-CONFIRMED device-family examples, not a selected schematic or safety-response limit. If the producer/receiver pairing cannot be evidenced, retain **SCHEMATIC-BLOCKING** status.

## D. State and restart/rearm semantics

Describe separately:

- safety demand:
- reset request:
- deliberate reset event/edge if required:
- reset accepted:
- rearm eligible:
- safety permissive:
- ordinary start/cycle request:
- startup behavior:
- power-loss behavior:
- power-restoration behavior:
- held/stuck reset behavior:
- fault latch/clear owner:
- service/mode transition behavior:
- safeguarded-space occupancy/visibility assumptions:

Required checks:
- `RESET INPUT ACTIVE != DELIBERATE RESET EVENT PROVED`.
- `RESET ACCEPTED != HAZARDOUS MOTION COMMANDED`.
- `RESET DEVICE ACCESSIBLE != SAFEGUARDED SPACE CLEAR PROVED`.
- `POWER RESTORED != REARM ELIGIBLE`.

## D1. Conditional whole-body-access, scanner signal, and restart-authority gate

Required when a person can pass the entry sensing plane or remain inside a safeguarded space. Record `BND/HAZ` entry/egress and blind-space geometry, `SF/PHY` occupancy/protection propositions, `SRS/AUTH` independent restart-inhibit owner, `ARC/DEP` exact scanner case/field/receiver mapping and common dependencies, `HF` visibility/escape/defeat incentives, `VAL/PT` trapped-person and retained-start contradictions, and `UNK/RR/CHG` unresolved restrictions and stale evidence. A field-clear, guard-closed, or reset-accepted status cannot prove the area is empty or authorize an ordinary cycle start.

For selected SICK S300 applications, verify the exact manual edition, whether local OSSDs are used, whether the downstream controller reads EFI OSSD status or protective-field status, allocation of each field, monitoring-case selection, scanner location/configuration-carrier identity, and who implements the downstream restart interlock. S300 8010948/ZD76/2025-08-19 documents hazards from inactive local OSSDs/EFI status, unallocated fields, downstream interlock ownership, monitoring-case switching, and incorrect system-plug connection. These are product-specific DOC-CONFIRMED constraints; selected-machine physical coverage and safe response remain UNKNOWN until verified.

Adversarial `VAL` cases: field clear while a person remains inside; wrong-but-valid monitoring case; wrong EFI bit or unallocated field; held ordinary start after reset; replacement with mismatched configuration; and healthy controller/valve feedback contradicted by physical motion/pressure evidence. Do not operate with people exposed when the minimum protection proposition is unestablished. See `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` §11B and the manufacturer's exact revision.

## E. Hazardous-energy path

Draw or describe the exact path from energy source to hazardous motion/process and identify what this block can interrupt, inhibit, hold, exhaust or monitor.

- energy source(s):
- controlled path:
- safety action:
- energy/hazard that can remain after action:
- gravity/external-force/stored-energy path:
- production safeguard vs maintenance-isolation boundary:

## E1. Maintenance energy-control continuity gate

Complete this section when servicing can expose people to hazardous energy. This is a separate proposition from the production safety function.

| Required record | Evidence / linked package IDs | Status / UNKNOWN |
|---|---|---|
| hazardous-energy source(s) and `ENE-*` | | |
| actual energy-isolating device(s) used for servicing | | |
| lockout/restraint/personal-control method | | |
| residual/stored-energy disposition after isolation | | |
| initial physical verification before work | | |
| credible reaccumulation/re-energization path | | |
| continued-verification method and basis when reaccumulation is credible | | |
| group/crew coordination and each exposed worker's personal-control proposition, when applicable | | |
| shift/personnel-change continuity and incoming-worker verification opportunity, when applicable | | |
| bounded test/positioning re-energization sequence, when necessary | | |
| re-isolation/reapplication of energy control before servicing resumes | | |
| safeguard restoration and final release witness | | |

Required checks:
- `PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION`.
- `INITIAL ISOLATION VERIFIED != HAZARDOUS REACCUMULATION IMPOSSIBLE`.
- `GROUP COORDINATOR CONTROL != EACH EXPOSED WORKER'S PERSONAL ENERGY-CONTROL PROTECTION`.
- `PREVIOUS SHIFT VERIFIED ISOLATION != INCOMING SHIFT HAS VERIFIED ISOLATION`.
- `TEMPORARY REENERGIZATION FOR TEST/POSITIONING != SERVICING MAY CONTINUE ENERGIZED`.
- `AUTHORIZED OVERRIDE != SAFEGUARD NO LONGER REQUIRED`.
- `BYPASS PERMISSION != ALTERNATE PROTECTION PROVED`.

If the selected block is only a production safety element, say so explicitly. Do not credit its inhibit, status, EDM, valve-position indication, STO state, or LinuxCNC/FPGA state as proof of maintenance isolation unless the exact physical proposition and application evidence justify that claim.

## F. Witness proposition

For every feedback/witness:

| Witness | Physical/electrical target observed | Relationship to target | What it proves | What it does NOT prove | Shared dependency | Required physical witness |
|---|---|---|---|---|---|---|
| | | | | | | |

A feedback signal is not independent evidence merely because its electrical value is plausible. Name the actual target and the mechanical/electrical relationship that makes the signal evidence of that target.

Required checks:
- `MATCHING COMMAND/FEEDBACK != INDEPENDENT PHYSICAL WITNESS`.
- `FINAL-ELEMENT FEEDBACK HEALTHY != COMMON DEPENDENCY ABSENT`.
- `EDM SATISFIED != HAZARDOUS ENERGY ABSENT`.
- HMI/LinuxCNC status is not personnel-safety authority.

### Hydraulic pressure-zone witness qualification (when applicable)

For every pressure gauge/transducer/test port, identify the **exact hydraulic volume it observes** from the selected as-built schematic. Record port/tap location, isolation/check-valve boundaries, gauge calibration/availability, blocked-tap failure, accumulator gas-side energy, separate cylinder/pilot chambers and gravity/external-load holding. A reading of zero at one port establishes at most the narrow instrument/port proposition; it does **not** establish pressure absence elsewhere, standstill, load restraint or safe line disconnection. Cross-check any plausible pressure or valve feedback with a separately justified physical `PHY/VAL` witness and a maintenance isolation/reaccumulation plan.

The HYDAC SAF catalog example `SAF20E12Y1T330A` (part 2120394) demonstrates why a family label and optional gauge are insufficient for a selected-machine safety claim; see `research/4400_HYDAC_SAF_EXACT_CATALOG_SELECTED_BLOCK_GATE.md` and `safety-course/4400_HYDAC_SAF_GAUGE_ZERO_TECHNICIAN_ADVERSARIAL_EXERCISE.md`. This is DOC-CONFIRMED product catalog identity plus INFERENCE about proof boundaries, **not** a frozen hydraulic truth table or personnel-exposed validation.

## G. Dependency / CCF attack

For each item, record whether independent, shared, or UNKNOWN and the consequence of failure:

- 24 V supply and 0 V/reference;
- fuse/protection path;
- connector/cable/wiring route;
- test-pulse source;
- processor/clock/reset/watchdog resource;
- configuration/programming/JTAG/service header;
- safety-output supply;
- pilot/hydraulic/pneumatic supply;
- feedback supply and sensor target;
- common mechanical linkage;
- ordinary FPGA/LinuxCNC interface;
- environmental/common enclosure dependencies.

## H. Failure-state table

| Fault | Expected block state | Diagnostic owner | Final-element effect | Physical proposition | Rearm allowed? | `VAL-*` |
|---|---|---|---|---|---|---|
| open conductor | | | | | | |
| short/cross-short where applicable | | | | | | |
| stuck/held input/reset | | | | | | |
| supply loss | | | | | | |
| supply restoration | | | | | | |
| controller reset/configuration | | | | | | |
| feedback disagreement | | | | | | |
| final-element stuck/welded | | | | | | |
| common-dependency failure | | | | | | |
| service/override restoration error | | | | | | |

Do not invent a response that the selected product/application evidence does not establish; mark it UNKNOWN.

## I. Human factors / service

- fault can be diagnosed without defeating safeguard:
- replacement is keyed/controlled or equivalence check is explicit:
- bypass/muting/service entry authority:
- alternate protection while reduced protection is active:
- indication and timeout/exit behavior:
- power-cycle behavior:
- restoration test:
- guard/safeguard is easy to restore correctly:
- foreseeable shortcut/defeat path and redesign response:

## J. Validation plan

Name concrete tests and witnesses for:

- normal demand and rearm;
- reset held/stuck;
- input restoration without reset;
- reset without ordinary start;
- power loss/restoration;
- feedback disagreement;
- plausible-but-wrong feedback;
- common-dependency fault;
- final-element failure;
- gravity/external/stored-energy case where relevant;
- service/maintenance transition and restoration;
- final-element feedback healthy/expected while an independent machine-level physical witness contradicts the claimed safe state. Retain only the narrow proposition actually proved by the feedback; mark the broader `PHY-*` proposition not established and block rearm/release until resolved.

Machine-specific stopping distance/time, pressure, holding force, safe speed, diagnostic coverage, proof-test interval and PL/SIL/integrity targets remain UNKNOWN until justified by machine/product/site evidence.

## K. Integrity-claim boundary

List component certifications/PL/SIL/category claims only as component evidence. State explicitly why they do or do not support the allocated machine safety function. Never infer achieved machine-level integrity from a component label.

## L. UNKNOWN disposition and schematic decision

For every UNKNOWN classify:

- **SCHEMATIC-BLOCKING** — could change pin/interface compatibility, cross-product compatibility, fail-safe state, diagnostic behavior, reset/rearm behavior, energy-path authority or a safety-critical dependency;
- **MACHINE-VALIDATION-BLOCKING** — schematic can be drawn but machine validation/release cannot proceed;
- **SAFELY DEFERRABLE** — rationale proves it cannot invalidate current capture decisions or safety boundary.

Decision:
- [ ] NOT READY FOR SCHEMATIC CAPTURE
- [ ] READY FOR ENGINEERING SCHEMATIC CAPTURE — not validated/certified/released

Reviewer rationale and evidence gaps:
