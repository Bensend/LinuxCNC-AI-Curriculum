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

The HYDAC SAF catalog example `SAF20E12Y1T330A` (part 2120394) demonstrates why a family label and optional gauge are insufficient for a selected-machine safety claim; see `research/4400_HYDAC_SAF_EXACT_CATALOG_SELECTED_BLOCK_GATE.md` and `safety-course/4400_HYDAC_SAF_GAUGE_ZERO_TECHNICIAN_ADVERSARIAL_EXERCISE.md`. This is DOC-CONFIRMED product catalog identity plus INFERENCE about proof boundaries, **not** a frozen hydraulic truth table or personnel-exposed validation. The same HYDAC part 2120394 catalog page warns that legacy 2SV5 and newer WSM solenoid coils are **not interchangeable**, and a 2SV5-to-WSM replacement requires the matching coil as well as valve; treat a valve/coil revision as a `CHG` event with electrical, mechanical and functional requalification, not as a shape-compatible drop-in. This catalog-specific DOC-CONFIRMED service constraint does not establish a safe machine response.

**SAF catalog-option ambiguity gate:** do not infer automatic accumulator discharge from the product-family label `SAF`, a generic `Valve Type: Solenoid` field or a family illustration. HYDAC part 2076241 is explicitly coded `SAF20M16-N350C S60` / manual discharge even though its generic field lists `Solenoid`; part 2120394 is `SAF20E12Y1T330A` / solenoid plus manual discharge. Gauges and bleed variants can be optional. Record exact model code, ordered accessories, coil/valve identity, as-built ports and independent discharge/pressure witnesses; treat `M`↔`E` or `Y`↔`Z` substitution as `CHG` and mark affected proofs STALE. See `research/4400_HYDAC_SAF_MANUAL_AUTO_BLEED_OPTIONAL_GAUGE_VARIANT_AUDIT_2026-10-22.md`. DOC-CONFIRMED catalog descriptions are **not** a selected machine's power-loss response or physical safe-state proof.

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


## C2. Conditional safety PLC port-role / diagnostic-pulse substitution gate (2026-10-24)

For every **selected** controller terminal, document `SAFETY_OUTPUT / STANDARD_AUXILIARY / TEST_PULSE / SAFE_INPUT / STANDARD_INPUT`, exact configured function, supply, producer/receiver and physical final-element authority. Do not infer safety capability from a 24 V pin, connector shape, PLC RUN LED, CRC or HMI status. The [Pilz PNOZ m B0 OEM 1002660-EN-13 audit](../research/4400_PILZ_PNOZ_MB0_SAFE_VS_AUX_OUTPUT_TEST_PULSE_CUTOVER_SOURCE_AUDIT_2026-10-24.md) demonstrates model-specific safe `O0..O3` versus auxiliary and test-pulse output classes; printed p.45's 330 µs/5 ms maximum self-test OFF intervals belong to **different** output types and cannot be used as generic receiver tolerance or machine stop time. Capture diagnostic-pulse wire segregation, load/receiver thresholds, coil suppression, external feedback, separate output supply and the OEM-required post-project-change functional check. An unresolved role/compatibility/final-element path is **SCHEMATIC-BLOCKING**; machine physical stop/hold evidence remains **MACHINE-VALIDATION-BLOCKING**. The installed PLC family and all physical witnesses remain UNKNOWN until selected-machine evidence exists.

### Conditional buffered-power/UPS supply-domain qualification (2026-10-28; only if selected hardware warrants)
The [PWR-UPS-01 original manufacturer audit](../research/4400_PWR_UPS_01_PILZ_PHOENIX_ROCKWELL_SEPARATE_24V_DOMAINS_AND_BUFFERED_POWER_AUDIT_2026-10-28.md) extends the **existing** 24 V/common-dependency checklist, not the short owner A–G request. For each *actual* rail, annotate source/isolator/fuse, UPS or battery backup, 0 V/reference, protected separation, rated operating range, loss/return timing, load(s), diagnostic owner and safe-state consequence. Distinguish: IPC/HMI power, safety logic/input supply, safety semiconductor-output supply, safety sensor feed, contactor/valve actuator supply, and hydraulic/mechanical holding energy. Attach exact OEM wiring and selected physical witness, or mark UNKNOWN. Never infer that an HMI or safety-controller RUN LED proves physical actuator OFF/ram held.

**Conditional numerical example, not a product recommendation:** Pilz B0 1002660-EN-13 system/SC supply tolerance 24 V −20%/+25% = **19.2–30 V**; Phoenix TRIO-UPS 2907160 battery-mode published range **18–30 V**. If directly paired without additional qualified regulation/threshold management, the published envelopes alone do not guarantee voltage compatibility at 18 V. The Pilz manual's 20 ms buffering statement is **furnace/EN 298-specific**; the Phoenix <75 ms switch-over figure does not prove actual DC waveform interruption. Exact selected PSU, UPS, battery state, fault diagnostics (Pilz example LOAD SUPPLY versus SUPPLY LOW/HIGH), restart, isolation and final-element response require qualified design review. No live fault injection or hazardous test to fill a blank.
