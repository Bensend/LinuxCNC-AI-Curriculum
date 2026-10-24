# 4400 — CNC replacement / retained safety system: blank cutover continuity worksheet

**Purpose:** reusable, machine-neutral engineering intake. This is a **blank evidence gate**, not a circuit diagram or instruction to energize a machine. The existing safety PLC may be retained, replaced, or absent; the correct answer is established from **as-built** evidence, not this worksheet.

**Sources and lesson:** [4400 brownfield cutover source audit](../research/4400_BROWNFIELD_CNC_RETROFIT_SAFETY_PLC_CUTOVER_AND_LOCKABLE_ISOLATION_AUDIT_2026-10-24.md); [12-case paper technician card](4400_RETAINED_SAFETY_PLC_RETROFIT_CUTOVER_TECHNICIAN_CARD_2026-10-24.md). Reuse cumulative [Safety Design Package](SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md) IDs. **Do not enter private machine schematics, credentials, proprietary PLC programs, serials or photos into this public repository.** Store selected-machine attachments only in an appropriately restricted location and link by non-sensitive evidence ID.

## A. Change and applicability

- Machine class and scope (generic or restricted evidence ID):
- Change trigger: old CNC / new CNC / FPGA / HMI / drives / hydraulic controls / guarding / wiring / service isolators:
- Jurisdiction and applicable safety requirements reviewed by qualified reviewer:
- OSHA 1910.147(c)(2)(iii) replacement/major-repair/renovation/modification trigger determination, evidence and reviewer:
- Safety controller exact manufacturer/variant/firmware/configuration identity (restricted evidence ID):
- Original and proposed diagrams, terminal maps, BOM, revision identities (restricted evidence IDs):
- Baseline safe state and operating modes, including setup/maintenance/rescue:
- Change IDs (`CHG-*`), affected previous `VAL/PT`, status `STALE/UNKNOWN`:
- Independent reviewer and date:

## B. Per-function continuity (repeat for every hazardous motion, access and mode)

| Field | Before (evidence ID) | After (evidence ID) | Status / reviewer |
|---|---|---|---|
| `BND/ENE/HAZ`: exact hazardous energy/exposure | | | |
| `SF/SRS`: demand and required physical reaction | | | |
| `AUTH`: guard/E-stop/reset owner | | | |
| `AUTH`: separate ordinary start and stale-command invalidation | | | |
| `ARC`: safety PLC input and program variable | | | |
| `ARC`: safety PLC output and physical final element | | | |
| `DEP`: shared power, ground, wiring, relay, processor, hydraulic pilot, mechanical paths | | | |
| `PHY`: independent stop witness | | | |
| `PHY`: independent gravity/load-hold witness | | | |
| `PHY`: guarded-space occupancy / escape witness | | | |
| `PHY`: pressure / electrical stored-energy and service isolation | | | |
| `HF`: access, repair, reset visibility, easy guard restoration | | | |
| `VAL/PT`: original baseline, changed negative cases, revalidation | | | |

**Do not claim retained safety-function equivalence** if the final-element output, physical hazard path, program identity, wiring, or required proof differs without a justified `CHG` review.

## C. Boundary audit (must not collapse into one READY bit)

| Question | Evidence ID / actual observation | Disposition |
|---|---|---|
| Can the safety system withdraw final-element authority if LinuxCNC/FPGA commands remain asserted or freeze? | | UNKNOWN / PROVED / FAILED |
| Are any safety-critical acknowledgements, timeouts or reset conditions inherited from the old CNC? | | |
| Is the new `SAFETY_OK` an ordinary status/permissive only, or does it mask loss of physical cut-off? | | |
| Can a retained foot/HMI/network command cause motion immediately after safety reset or power restoration? | | |
| Are both ram Y axes, backgauge and any auxiliary powered devices within the actual protective-stop span? | | |
| Does a controller/valve/EDM READY indication have a separately justified physical witness? | | |
| Can a person remain inside after the entry sensor reports clear? | | |
| Can the correct guard and isolator be restored and checked without a workaround? | | |

## D. Service lockout and stored-energy continuity

| Hazardous energy / zone | Lockable physical isolator and access | Residual energy / reaccumulation | Independent verification and mechanical restraint | UNKNOWN / HOLD |
|---|---|---|---|---|
| electrical supply and drive DC bus | | | | |
| hydraulic pump and separately trapped chambers | | | | |
| gravity-supported ram / tools / sheet | | | | |
| pneumatic / vacuum auxiliaries if installed | | | | |
| independent motion axes / workpiece handling | | | | |

Review OSHA 1910.147 scope and §(c)(2)(iii) **for the actual change**, not as a blanket claim that every software update is a major modification. Control-circuit OFF, LinuxCNC E-stop, PLC READY, one zero-pressure gauge and STO do not alone establish full service isolation.

## E. Bounded verification plan — **planning only**

| `VAL/PT` ID | Unresolved proposition | Independent witness | Predeclared fault/negative case | Personnel exclusion / qualified method | Result |
|---|---|---|---|---|---|
| | | | | | NOT RUN |
| | | | | | NOT RUN |
| | | | | | NOT RUN |

Do not specify a stop-time, pressure, hydraulic valve truth table, PL/SIL, test pulse, gravity restraint rating, or live fault-injection method without selected-product/machine evidence and qualified design. Start with documents and safe de-energized inspection. Any physical verification requires an approved isolated/remote test plan with people outside the danger zone and residual risk explicitly addressed.

## F. Release and change decision

- `G0` documentary completeness: **HOLD / REVIEWED** (evidence):
- `G1` isolated/remote test permission: **HOLD / APPROVED BY QUALIFIED TEAM**:
- `G2` physical validation: **NOT RUN / PASS / FAIL** (evidence):
- `G3` personnel-exposed operation: **NOT AUTHORIZED** until justified:
- `G4` maintenance entry: **NOT AUTHORIZED** until separate isolation/verification:
- `G5` changed-machine revalidation and fresh start: **HOLD**:
- Residual risk and unclosed UNKNOWNs:
- Next missing restricted evidence ID:
- Reviewer and date:

**Stop rule:** if no independently justified minimum physical protection exists for the intended exposure, **do not operate with people exposed**. An experimental operation, if genuinely necessary, must be isolated/remote and separately authorized by qualified personnel with all people outside the danger zone.
