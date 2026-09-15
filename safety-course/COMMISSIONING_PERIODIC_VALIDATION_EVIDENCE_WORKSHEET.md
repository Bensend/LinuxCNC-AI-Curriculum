# Commissioning / Periodic-Validation Evidence Worksheet

Status: curriculum working artifact

Purpose: make safety-function validation repeatable and evidence-bearing without collapsing commanded state, indication, independent feedback, physical condition, hazardous-energy isolation, safety reset, or ordinary LinuxCNC/FPGA rearm into one `READY` bit.

This worksheet is machine-agnostic. It does **not** assign a required PL/SIL, stopping distance, pressure threshold, hydraulic truth table, proof-test interval, or other machine-specific value. Those remain design/risk-assessment/measurement inputs.

## Evidence labels

Use only these labels for claims recorded here:

- `SOURCE-CONFIRMED` — directly supported by an authoritative source.
- `DOC-CONFIRMED` — supported by project/machine documentation whose applicability is established.
- `TEST-CONFIRMED` — directly observed in the identified test configuration.
- `COMMUNITY-REPORTED` — reported by a community source but not independently established.
- `INFERENCE` — engineering inference; state the premises.
- `UNKNOWN` — not established. `UNKNOWN` never means safe or validated.

## Core rule

A safety function is not validated because software commanded a safe state, an HMI displayed green, a PLC/FPGA bit changed, or one test passed once. The record must identify the deliberate stimulus, expected safety response, independent observation, restoration behavior, restart behavior, evidence provenance, and the configuration to which the evidence applies.

Ordinary LinuxCNC, networking, and the normal FPGA/controller may request more restrictive behavior and may provide diagnostics. They must not be treated as the sole authority proving an independent personnel-safety function.

## Validation identity

| Field | Record |
|---|---|
| Machine / test article | |
| Safety function ID and plain-language purpose | |
| Hazard / hazardous motion or energy addressed | |
| Test date/time | |
| Tester | |
| Independent witness/reviewer when required by local procedure | |
| Hardware revision | |
| Safety-controller / relay revision and configuration | |
| LinuxCNC configuration / commit | |
| FPGA / firmware commit | |
| Wiring / schematic revision | |
| Relevant parameter set | |
| Instruments / test equipment and calibration status | |
| Preconditions / environmental state | |
| Evidence label(s) | |

## Function proof record

| Step | Required record |
|---|---|
| 1. Hazard boundary | What person/hazard interaction is this function intended to prevent or limit? |
| 2. Initiating stimulus | Exact deliberate input/fault/action applied. Do not substitute a software variable for the physical stimulus unless the variable itself is the test target. |
| 3. Expected independent response | What safety-related outputs/final elements should change, and what must remain inhibited? |
| 4. Independent observation | Feedback, contact state, physical observation, measurement, or other evidence that does not merely echo the command. |
| 5. Residual/stored energy | What energy can remain after the stop? If maintenance isolation is claimed, link the energy-source inventory and isolation verification instead of inferring zero energy from stopped motion. |
| 6. Diagnostic behavior | What should LinuxCNC/HMI/FPGA report? Diagnostic correctness is recorded separately from safety-function success. |
| 7. Reset behavior | What deliberate reset is required? Confirm reset does not itself initiate hazardous motion. |
| 8. Restart behavior | Confirm restoration/reset does not automatically restart production or replay a stale actuator command. Record the separate deliberate start/rearm action. |
| 9. Fault persistence | If the initiating fault remains, confirm reset/rearm cannot silently clear the protective state. |
| 10. Result | PASS / FAIL / BLOCKED / UNKNOWN, with evidence location. |

## Deliberate fault/stimulus set

Select only applicable cases and add machine-specific cases from the risk assessment. Never mark an unperformed case PASS.

| Case | Applicable? | Expected behavior defined? | Performed? | Result / evidence |
|---|---|---|---|---|
| E-stop actuation | | | | |
| Guard/interlock opening | | | | |
| Safety input channel discrepancy / detectable wiring fault | | | | |
| Final-element feedback fails to reach expected state | | | | |
| Safety reset held continuously | | | | |
| Start command held during reset/restoration | | | | |
| LinuxCNC process crash / loss of normal-control command freshness | | | | |
| FPGA normal-control watchdog expiry | | | | |
| Network loss and reconnection | | | | |
| Power loss and restoration | | | | |
| Stale/nonzero actuator command present before recovery | | | | |
| Required sensor/feedback missing or `UNKNOWN` | | | | |
| Maintenance bypass/temporary override active | | | | |
| Stored-energy or reaccumulation condition applicable to maintenance work | | | | |

## Restoration and production-rearm proof

Record these as separate gates. A single aggregate `READY` indication is insufficient evidence.

| Gate | Evidence required | Result |
|---|---|---|
| Initiating demand removed / condition corrected | direct condition evidence | |
| Safety final elements in expected state | independent feedback or justified physical verification | |
| Temporary bypasses/overrides removed | lifecycle/restoration evidence | |
| Guards/protective devices restored | direct/independent evidence appropriate to device | |
| Maintenance hazardous-energy controls released under procedure | energy-control record when applicable | |
| Safety reset accepted | safety-system evidence | |
| Ordinary controller state sane | LinuxCNC/FPGA diagnostics; not safety proof | |
| Stale commands/integrators cleared or forced safe | controller/FPGA evidence | |
| Separate deliberate production start/rearm required | functional test | |
| No automatic hazardous restart on power/network restoration | functional test | |

## Periodic validation / inspection trigger matrix

Do not invent a universal proof-test interval here. Use the applicable standard, manufacturer requirements, risk assessment, local procedure, component safety manual, and machine history. Revalidation is also event-driven.

| Trigger | Required action |
|---|---|
| Initial commissioning / substantial retrofit | validate every affected safety function and restoration/restart path before production exposure |
| Safety-related hardware replacement | determine affected functions; revalidate affected function chain and final-element feedback |
| Wiring change | revalidate affected channels, fault detection, final elements and restoration behavior |
| Safety logic/configuration change | revalidate affected functions plus reset/restart interactions |
| LinuxCNC/FPGA change touching safety interface or normal output authority | revalidate boundary behavior, diagnostics, watchdog/rearm and stale-command handling; do not treat this as proof of the independent safety system by itself |
| Guard/protective-device geometry or mounting change | revalidate affected protective function; obtain machine-specific distance/time evidence where required |
| Hydraulic/mechanical change affecting stopping or stored energy | reopen the relevant risk/measurement evidence; do not carry forward old stopping/energy claims blindly |
| New hazard, process, tooling or operating mode | perform change review and validate affected functions |
| Failure, near miss, unexpected restart, defeated safeguard, or contradictory feedback | quarantine the affected claim; investigate and revalidate before relying on it |
| Periodic inspection/proof-test due under applicable procedure/manual/standard | execute defined test set and retain evidence |

## Hazardous-energy procedure inspection note

For servicing/maintenance energy control, OSHA 29 CFR 1910.147 requires documented energy-control procedures where applicable, verification of isolation before work, treatment of stored/reaccumulating energy, and a periodic inspection of the energy-control procedure at least annually. The periodic inspection must be performed by an authorized employee other than the employee(s) using the procedure being inspected, correct deviations/inadequacies, and be certified with the machine/equipment, date, employees included, and inspector. This is an energy-control-procedure requirement; it must not be misrepresented as a universal annual proof-test interval for every functional-safety component.

Source: OSHA 29 CFR 1910.147(c)(4), (c)(6), (d)(5), (d)(6), and (e), current text accessed 2026-09-15.

## Evidence disposition

| Finding | Disposition |
|---|---|
| PASS with traceable evidence | retain with exact configuration identity |
| FAIL | function is not validated; record corrective action and retest |
| BLOCKED | identify missing measurement/source/access; do not infer PASS |
| UNKNOWN / contradictory evidence | fail closed for curriculum claims; resolve before promotion or production reliance |

## Adversarial Safety Sandbox cases

1. **Green-HMI false proof:** HMI says `SAFE`; independent final-element feedback is contradictory. Expected: validation FAIL/UNKNOWN, never PASS.
2. **Command-echo trap:** controller commands output OFF and reads back its own command variable. Expected: this is not independent proof of final-element state.
3. **Held-start recovery:** START remains held while E-stop is reset. Expected: reset alone does not initiate hazardous production motion.
4. **Network stale-command replay:** network drops with a nonzero command, then reconnects. Expected: stale command is not replayed; explicit sane-state rearm is required.
5. **Watchdog category confusion:** FPGA watchdog successfully inhibits normal outputs. Expected: record useful fault containment, but do not relabel it as proof of the independent safety function.
6. **Power-cycle false restoration:** controller/HMI reboots and initializes indicators to normal while a physical bypass remains. Expected: restoration gate remains failed/unknown.
7. **Unperformed test inflation:** a checklist row is applicable but was never stimulated. Expected: cannot be marked PASS.
8. **Configuration drift:** prior validation used a different safety configuration/wiring revision. Expected: evidence applicability must be reassessed; old PASS is not silently inherited.
9. **Stored-energy confusion:** ram/motor is stopped but hazardous stored energy remains for maintenance exposure. Expected: stopped motion does not establish maintenance isolation.
10. **Annual-interval overgeneralization:** OSHA annual LOTO procedure inspection is used to claim every safety device needs exactly a one-year proof-test interval. Expected: reject; derive each applicable interval from its governing evidence.
11. **Defeated guard discovered:** bypass is found during periodic inspection. Expected: affected validation claim is quarantined, deficiency corrected, and applicable function revalidated before reliance.
12. **Post-change carryover:** guard geometry, hydraulic behavior, or final element changes but old stopping/validation evidence is retained unchanged. Expected: change trigger forces evidence review/revalidation.

## Curriculum acceptance criteria

A learner/agent passes this artifact only if it can:

- distinguish commissioning validation from ordinary diagnostics and from maintenance LOTO verification;
- demand independent evidence rather than command echoes;
- preserve safety reset, production restart and normal-controller rearm as distinct actions;
- treat `UNKNOWN` and contradictory feedback as unresolved rather than safe;
- identify configuration/change triggers that invalidate or narrow old evidence;
- explain why OSHA's annual energy-control-procedure inspection is not a blanket proof-test interval for every safety component;
- refuse to invent stopping distance, hydraulic response, PL/SIL, diagnostic coverage or proof-test interval without applicable evidence.

## Next independent curriculum branch

Develop a **safety change-control / evidence-invalidation matrix**: map hardware, wiring, firmware, LinuxCNC, FPGA, hydraulic, mechanical, tooling and protective-device changes to the exact prior evidence that must be reopened, the minimum retest boundary, and the authority required before returning to production. Keep it separate from the primary Safety Sandbox relay/contactor fault-model lane.
