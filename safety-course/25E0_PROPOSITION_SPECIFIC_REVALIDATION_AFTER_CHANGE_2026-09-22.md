# 25E0 — Proposition-specific revalidation after exception or change

## Purpose
A cleared alarm, removed force, replaced part, restored guard, matching configuration checksum, or successful reset is not itself proof that the physical safety proposition affected by the intervention is true again. Production return must be impact-based: determine what evidence the change made stale, then re-prove the affected proposition with an appropriate witness and acceptance authority.

## Evidence boundary

**DOC-CONFIRMED — Siemens SINAMICS G220:** after component replacement or firmware update a reduced Safety Integrated acceptance test is required. Siemens' component-specific table does not treat all replacements identically. Encoder replacement, for example, calls for testing STO/SS1 and testing actual-value acquisition by operating/traversing in both directions, with updated hardware/firmware documentation. This is strong evidence for change-specific rather than generic revalidation.

**DOC-CONFIRMED — Siemens SINUMERIK Safety Integrated:** acknowledging replacement hardware is followed by a required functional test. For sensor module / DRIVE-CLiQ motor replacement Siemens calls out encoder recalibration, checking safety actual-value acquisition including speed, direction and absolute position where applicable, and documenting checksum/hardware/software data. Acknowledgment initiates reset; it does not substitute for the subsequent function test.

**DOC-CONFIRMED — Siemens S120:** initial Safety Integrated commissioning requires a complete acceptance test; safety-function expansion, hardware changes, software upgrades and similar changes may permit reduced scope only after defining the affected acceptance-test objects/logical groups. Acceptance is performed by an authorized person and recorded.

**DOC-CONFIRMED — Pilz:** validation belongs to the machine lifecycle and its appropriate depth depends on the application/change. Pilz explicitly distinguishes minor changes from complex/significant changes rather than prescribing one undifferentiated test after every intervention.

## Core method
For every exceptional state, repair, replacement or configuration change, record this chain before production return:

`change -> affected safety function -> proposition/evidence made stale -> required physical re-proof -> acceptance authority -> configuration/documentation update -> reset/rearm -> fresh ordinary demand`

Do not start with a convenient available diagnostic and ask whether it is green. Start with the physical proposition that must be true.

### Evidence classes that must remain separate
1. **Component health** — device diagnostics/configuration communication indicate a component is internally healthy enough to report.
2. **Input/witness integrity** — the field device and wiring actually witness the intended physical variable/state.
3. **Final-element state** — contactor, valve, brake, drive safety function, etc. reached the required state.
4. **Process response** — hazardous motion/pressure/energy actually responded as required.
5. **Stopping/holding performance** — where the safety function depends on time, distance, speed, retention or drift, the relevant physical performance remains within the machine-specific validated criterion.
6. **Configuration identity** — safety parameters/software/hardware identity correspond to the accepted configuration.
7. **Exceptional-state clearance** — forces, simulations, jumpers, bypasses and temporary modes are positively absent rather than merely forgotten.
8. **Reset/rearm state** — safety logic is eligible to return, without conflating reset with start.
9. **Ordinary-demand freshness** — production Start/Cycle/Jog authority is handled separately from restored safety eligibility.

A single `OK` bit must not collapse these classes.

## Change-impact matrix

| Change / exceptional state | Evidence made stale | Required re-proof category | What is NOT enough |
|---|---|---|---|
| safety encoder / speed witness replacement | calibration, direction/sign, actual-value acquisition, safety monitoring chain | calibration/identity plus physical actual-value and affected safety-function acceptance tests | device online; checksum accepted; alarm cleared |
| safety drive/parameter/firmware change | configuration identity and any affected safe-motion behavior | impact analysis plus complete/reduced acceptance appropriate to affected functions | successful download; no diagnostics |
| guard/interlock sensor replacement or rewiring | correspondence between physical guard state and safety input; fault behavior | physical actuation through relevant states and affected safety-function response/fault test | input bit toggles from bench manipulation |
| brake replacement/work | prior evidence of holding capability and, where used, brake-test baseline | machine-specific holding/brake proof and affected stop/retention validation | brake command active; brake switch active; old proof result |
| hydraulic valve replacement/work | prior final-element response evidence; possibly stopping/holding behavior | physical valve/function response and affected process-level validation | coil de-energized; spool switch alone unless that is the accepted proposition |
| hydraulic plumbing change | assumptions about trapped volumes, energy path, pressure witness coverage and process response | renewed hazard/energy-path review plus physical tests at the actual affected points | one upstream pressure gauge reads low |
| pressure sensor replacement/relocation | calibration and proposition-to-location mapping | calibration plus demonstration that the location witnesses the required volume/state | plausible pressure number |
| temporary force/simulated witness/jumper | authenticity of every proposition overridden by the temporary state | positive removal plus real field actuation and revalidation of the overridden proposition | force disabled; simulation screen closed; jumper believed removed |

## Stress test A — hydraulic / gravity-loaded axis

Scenario: maintenance replaces a directional valve and brake, moves a pressure transducer upstream for easier service, uses a temporary guard-input jumper, and clears all diagnostics. The ram is stationary.

Required reasoning:
- `ram stationary` is process-state evidence at one instant, not proof of retaining capability;
- the new brake invalidates prior brake-capability proof;
- valve work invalidates prior evidence about the final hydraulic element and can affect stop/hold response;
- moving the pressure witness invalidates the prior claim about what hydraulic volume it represents;
- jumper use invalidates the authenticity of guard-state evidence until removed and field-actuated;
- clearing diagnostics establishes none of those physical propositions;
- reset/rearm occurs only after the required propositions are re-established;
- a Cycle Start held through maintenance is not automatically granted fresh production authority merely because safety eligibility returns.

No generic pressure, drift, stopping-distance, brake-torque or timing threshold is supplied here. Those are machine-specific acceptance criteria.

## Stress test B — rotating / servo machine

Scenario: a safety encoder is replaced, safe-speed parameters are restored from backup, a guard switch is replaced, and a simulated safe-speed input used during commissioning is then disabled. The drive reports healthy and configuration checksums match the intended project.

Required reasoning:
- restored parameters/checksum establish configuration identity, not physical encoder calibration/direction/actual-value correctness;
- encoder replacement requires re-proof of the affected actual-value and safe-motion chain;
- guard replacement requires physical correspondence and affected function testing, not merely a toggling input bit;
- `simulation disabled` is weaker than positive clearance plus real witness testing;
- drive healthy does not prove physical stopping performance;
- if the affected safety claim depends on stopping time/distance or monitored speed, revalidate that physical criterion using the machine-specific acceptance method;
- reset and production Start remain distinct transitions.

## Frozen rules

- **PART REPLACED != SAFETY PROPOSITION RESTORED.**
- **ALARM ACKNOWLEDGED != FUNCTION VALIDATED.**
- **CHECKSUM/CONFIGURATION MATCH != FIELD PHYSICS PROVED.**
- **FORCE OR SIMULATION DISABLED != REAL WITNESS REVALIDATED.**
- **COMPONENT HEALTH != FINAL-ELEMENT STATE != PROCESS RESPONSE.**
- **PROCESS AT REST NOW != STOPPING/HOLDING PERFORMANCE VALIDATED.**
- **RESET/REARM != FRESH PRODUCTION DEMAND.**
- **REDUCED ACCEPTANCE TEST != ARBITRARILY SMALL TEST.** Its scope follows the actual change and affected acceptance objects.
- **SAFETY-CRITICAL UNKNOWN blocks the acceptance claim that depends on it.**

## Human-factors requirement
Revalidation must be practical enough that technicians do not gain an incentive to bypass it. Provide a change-category checklist that automatically names the propositions and tests likely to have become stale. Do not make the safe workflow depend on remembering an undocumented tribal sequence. Conversely, convenience cannot turn a physical proof requirement into a software checkbox.

If a required proposition cannot be re-established, the machine is not production-ready. If it cannot meet the minimum safe-to-operate threshold, do not operate with people exposed to the hazard; any justified experimental operation must be isolated/remote with people outside the danger zone and residual risk stated explicitly.

## Curriculum use
A learner presented with a maintenance record should be able to answer five questions before accepting return to production:
1. What changed physically or logically?
2. Which previously accepted propositions did that make stale?
3. What independent physical evidence re-establishes each proposition?
4. Who/what has acceptance authority for that evidence and what record/configuration identity is retained?
5. After safety eligibility is restored, what reset/rearm and fresh ordinary-demand semantics prevent maintenance completion from becoming an unintended start?

## Sources
- Siemens, *SINAMICS G220 Operating Instructions*, section 16.4, “Safety Integrated acceptance test after component replacement.”
- Siemens, *Safety Integrated Function Manual* for SINUMERIK 828D, section 7.7, “Acknowledging hardware replacement.”
- Siemens, *SINAMICS S120 Drive Functions Function Manual*, section 9.10, “Acceptance test and certificate.”
- Pilz, “Safety validation in machinery safety” / lifecycle validation guidance.

Evidence classifications follow `SOURCE_POLICY.md`. No physical machine test or executable laboratory compute was used for this artifact.
