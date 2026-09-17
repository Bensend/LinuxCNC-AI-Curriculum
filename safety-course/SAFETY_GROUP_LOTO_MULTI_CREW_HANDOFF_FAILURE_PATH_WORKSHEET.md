# Safety Group LOTO / Multi-Crew Handoff Failure-Path Worksheet

## Purpose

This worksheet teaches a narrow but high-consequence servicing boundary: how hazardous-energy control can fail when several authorized employees, crews, crafts, shifts, or energy domains share one machine. It is **not** a substitute for an employer's machine-specific energy-control procedure, and it does not redefine normal production safeguarding.

## Frozen architecture rule

**A group lockout is not merely a lockbox state. Protection depends on individual exposure accountability, verified isolation of every applicable hazardous-energy source, continuity across crew/shift changes, and an explicit controlled transition whenever testing or positioning temporarily requires energization.**

A LinuxCNC screen, FPGA bit, safety-controller status, contactor command, hydraulic command, HMI `SAFE` indication, or supervisor statement is not by itself proof of electrical/hydraulic/mechanical energy isolation.

## Evidence labels

Use the repository evidence vocabulary without dilution:

- **SOURCE-CONFIRMED** — directly established by inspected implementation/source.
- **DOC-CONFIRMED** — explicitly established by authoritative documentation.
- **TEST-CONFIRMED** — reproduced by a recorded physical/executable test.
- **COMMUNITY-REPORTED** — credible report not independently verified here.
- **INFERENCE** — engineering conclusion derived from evidence but not directly established.
- **UNKNOWN** — missing, conflicting, stale, or machine-specific evidence.

## Authoritative baseline

### OSHA 29 CFR 1910.147 group protection

**DOC-CONFIRMED:** 29 CFR 1910.147(f)(3) requires group lockout/tagout to provide protection equivalent to personal lockout/tagout. It assigns primary responsibility to an authorized employee for a defined group, requires that person's ability to ascertain individual exposure status, requires an overall authorized coordinator when multiple crews/crafts/departments are involved, and requires each authorized employee to apply/remove a personal device when beginning/ending work.

Source: OSHA, `29 CFR 1910.147(f)(3)`, https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147

### Shift/personnel continuity

**DOC-CONFIRMED:** 29 CFR 1910.147(f)(4) requires specific procedures for shift/personnel changes, including orderly transfer of protection between off-going and oncoming employees so protection does not disappear during the handoff.

OSHA's group-LOTO enforcement guidance further states that verification is required by each group of workers before work starts at shift changes and emphasizes continuing individual control/accountability.

Sources:
- OSHA, `29 CFR 1910.147(f)(4)`, same standard URL above.
- OSHA Directive STD 01-05-019, `29 CFR 1910.147 ... Inspection Procedures and Interpretive Guidance`, https://www.osha.gov/enforcement/directives/std-01-05-019

### Stored/residual energy

**DOC-CONFIRMED:** after isolation, potentially hazardous stored/residual energy must be relieved, disconnected, restrained, or otherwise rendered safe. If stored energy can reaccumulate to a hazardous level, verification must continue until servicing is complete.

Source: OSHA, `29 CFR 1910.147(d)(5)`, standard URL above.

### Temporary energization for test/positioning

**DOC-CONFIRMED:** 29 CFR 1910.147(f)(1) provides a bounded sequence when LOTO devices must temporarily be removed for testing/positioning: clear tools/materials; remove employees from the machine/equipment area; remove LOTO devices as specified; energize/test/position; then deenergize all systems and reapply energy-control measures before servicing continues.

Sources:
- OSHA, `29 CFR 1910.147(f)(1)`, standard URL above.
- OSHA eTool, `Testing of Machines`, https://www.osha.gov/etools/lockout-tagout/tutorial/testing-machines

**DOC-CONFIRMED, scope warning:** OSHA's 2024 interpretation states that this exception is limited to the time necessary for testing/repositioning and does not permit ordinary servicing to remain energized merely because energization is convenient.

Source: OSHA interpretation, `Lockout/Tagout (LOTO) Feasibility and "Alternative Methods"`, 2024-10-21, https://www.osha.gov/laws-regs/standardinterpretations/2024-10-21

## Scope boundary for OpenPressBrake/LinuxCNC teaching

Keep three concepts separate:

1. **Normal safeguarding:** E-stop, guards/interlocks, safe-motion/stop functions, independent safety logic, final elements, EDM, restart/rearm behavior.
2. **Hazardous-energy control for servicing:** physical isolation plus stored-energy control and verification appropriate to the task.
3. **Ordinary control:** LinuxCNC/HAL, FPGA, HMI, proportional command, motion program and diagnostic transport.

**INFERENCE:** these layers can cooperate operationally, but ordinary control must not silently become the sole servicing-isolation authority. Likewise, LOTO does not prove that the machine's normal safeguarding architecture is correctly designed or validated.

## Job-level worksheet

### A. Define the servicing boundary before anyone signs on

| Field | Record |
|---|---|
| Machine / equipment ID | |
| Work order / task | |
| Primary authorized employee | |
| Overall coordinator if multiple crews | |
| Crew/craft leads | |
| Planned shifts / handoffs | |
| Machine-specific energy-control procedure/revision | |
| Drawings / energy-source inventory revision | |
| Expected test/position cycles requiring temporary energization | |
| Known configuration/bypass/maintenance state before isolation | |

### B. Energy-domain ownership map

Do not treat `machine power OFF` as a complete energy inventory.

| Hazardous-energy domain | Isolation point / device | Stored-energy control | Verification method | Responsible authorized person/crew | Reaccumulation possible? | Evidence state |
|---|---|---|---|---|---|---|
| Electrical mains / branch | | | | | | UNKNOWN |
| DC/control supplies relevant to task | | | | | | UNKNOWN |
| Hydraulic pump/supply | | | | | | UNKNOWN |
| Accumulator / trapped hydraulic pressure | | | | | | UNKNOWN |
| Gravity / elevated ram or member | | | | | | UNKNOWN |
| Springs / elastic/mechanical preload | | | | | | UNKNOWN |
| Pneumatic / stored pressure | | | | | | UNKNOWN |
| Drive/DC-bus stored energy | | | | | | UNKNOWN |
| External/remote/auxiliary feed | | | | | | UNKNOWN |
| Other task-specific energy | | | | | | UNKNOWN |

Machine-specific pressure thresholds, discharge times, blocking methods, stopping distances and hydraulic truth tables remain **UNKNOWN** until supported by applicable documentation and/or physical evidence.

### C. Individual exposure accounting

| Person | Authorized for this task? | Crew | Personal device applied | Isolation verification completed/observed per procedure | Exposure begins | Exposure ends | Personal device removed | Notes |
|---|---|---|---|---|---|---|---|---|
| | | | | | | | | |

Failure-path question: **Can the coordinator know, without guessing, whether every person represented by the group protection is clear before any path to reenergization becomes possible?**

If `NO` or `UNKNOWN`, do not treat the group release as ready.

## Handoff challenge

At every shift/personnel change, challenge the continuity rather than assuming yesterday's state remains valid.

| Check | Result | Evidence / person |
|---|---|---|
| Off-going and oncoming responsibility explicitly transferred | PASS / FAIL / UNKNOWN | |
| Oncoming crew/persons accounted for | PASS / FAIL / UNKNOWN | |
| Departing personnel accounted for | PASS / FAIL / UNKNOWN | |
| Personal protection transferred without an unprotected interval | PASS / FAIL / UNKNOWN | |
| Applicable isolation remains in place | PASS / FAIL / UNKNOWN | |
| Stored-energy controls/restraints still effective | PASS / FAIL / UNKNOWN | |
| Reaccumulating energy rechecked where applicable | PASS / FAIL / UNKNOWN | |
| New crew verified isolation as required by procedure | PASS / FAIL / UNKNOWN | |
| Temporary test/position state is not being mistaken for isolated state | PASS / FAIL / UNKNOWN | |
| Machine/configuration/work scope unchanged since prior verification | PASS / FAIL / UNKNOWN | |

## High-value failure paths

### FP-1 — Coordinator knows the lockbox, not the exposure

**Scenario:** all expected keys appear secured, but a worker entered the hazard zone without being correctly represented in the accountability mechanism.

**Consequence:** group release logic can appear administratively complete while a person remains exposed.

**Control question:** what independent job/accountability step establishes each exposed authorized employee's status?

### FP-2 — Electrical crew and hydraulic crew each assume the other owns stored energy

**Scenario:** electrical isolation is sound; hydraulic supply is stopped; accumulator/trapped pressure or elevated mechanical load remains hazardous because ownership fell between crews.

**Consequence:** `power off` is falsely promoted to `hazard controlled`.

**Control question:** does the energy-domain map assign one explicit owner and verification method to every applicable domain?

### FP-3 — Shift transfer creates a protection gap

**Scenario:** off-going workers remove personal protection before oncoming workers establish theirs, or responsibility is transferred verbally without the procedure's required protection continuity.

**Consequence:** an interval exists in which reenergization can become possible while work remains incomplete.

**Control question:** can the transfer sequence be drawn with no state in which exposed work continues without the required personal/group protection?

### FP-4 — Old verification is inherited after the verifier leaves

**Scenario:** oncoming personnel rely only on an earlier shift's verification or a supervisor statement.

**Consequence:** changed isolation, disturbed blocking, reaccumulated energy, or scope changes can go undetected.

**Control question:** what verification does the oncoming group perform before beginning exposure?

### FP-5 — Test/position cycle becomes an informal energized-service mode

**Scenario:** LOTO is removed for a necessary movement/test, then workers continue troubleshooting or adjustment while energized instead of completing the bounded test and reapplying energy control.

**Consequence:** a narrow exception becomes the de facto servicing method.

**Control question:** is the transition explicitly `clear -> remove personnel -> controlled release -> energize/test/position -> deenergize -> re-isolate -> verify -> resume servicing`?

### FP-6 — Test cycle leaves hidden state behind

**Scenario:** LinuxCNC mode, HAL command, FPGA output, drive enable, hydraulic command, temporary jumper, force, or diagnostic override remains in a different state after the test.

**Consequence:** reenergization later can produce an unexpected command or defeat a safeguard.

**INFERENCE:** ordinary-control/configuration state should be treated as a return-to-service/rearm evidence item, not as proof of physical isolation.

### FP-7 — Personal lock removal exception becomes routine convenience

**Scenario:** absent-worker removal procedure is used casually because locating the worker is inconvenient.

**Consequence:** individual control of hazardous energy is weakened.

**DOC-CONFIRMED:** 1910.147(e)(3) makes removal by someone other than the applier an exception requiring specific documented procedures/training and equivalent safety, including verification that the employee is not at the facility, reasonable efforts to contact them, and ensuring they know before resuming work.

### FP-8 — Reaccumulation goes unwatched

**Scenario:** trapped hydraulic/pneumatic pressure, gravity load, thermal energy, capacitor charge, or another source can return after initial verification.

**Consequence:** a once-valid isolation becomes unsafe while the lock state appears unchanged.

**Control question:** where reaccumulation is possible, what monitoring/reverification is required by the machine-specific procedure?

### FP-9 — HMI/safety diagnostics are mistaken for energy-isolation witnesses

**Scenario:** HMI reports `SAFE`, STO active, contactors commanded open, hydraulic valve commanded off, or FPGA watchdog tripped.

**Consequence:** command/state information is substituted for the physical isolation and stored-energy evidence required for servicing.

**Control question:** which physical energy-isolating devices and verification observations actually support the servicing claim?

### FP-10 — Scope grows without re-evaluating the energy boundary

**Scenario:** a job that began as electrical cabinet work expands to valve, cylinder, drive, guard, or mechanical work.

**Consequence:** the original isolation procedure may not cover the new exposure.

**Control question:** what triggers a stop and re-evaluation when the work scope changes?

## Test / positioning transition card

Before temporary energization:

- [ ] Testing/positioning genuinely requires energization; convenience alone is not the basis.
- [ ] Tools/materials and conditions are prepared for the bounded test.
- [ ] Employees are removed from the machine/equipment area as required by the applicable procedure/regulation.
- [ ] Group/personnel accountability is reconciled before devices are removed.
- [ ] Expected motion/energy path and ordinary-control state are known.
- [ ] Any additional safeguarding required for the specific test is identified from applicable procedure/evidence.

After the bounded test:

- [ ] Deenergize all systems required by the energy-control procedure.
- [ ] Reapply energy-control measures.
- [ ] Re-control stored/residual energy.
- [ ] Reverify isolation before servicing resumes.
- [ ] Reconcile temporary LinuxCNC/HAL/FPGA/drive/safety-controller modes, forces, overrides and jumpers.
- [ ] Record any changed machine/configuration state that invalidates earlier verification.

## Release / return-to-service boundary

Do not collapse these into one button press:

1. servicing work complete;
2. tools/materials/nonessential items cleared;
3. machine components/restraints/guards restored as applicable;
4. all exposed personnel accounted for and safely positioned/removed;
5. personal/group energy-control devices released under the approved procedure;
6. affected personnel notified as required;
7. energy restored under controlled conditions;
8. independent safety system state evaluated/reset as applicable;
9. ordinary LinuxCNC/FPGA control rearmed separately;
10. return-to-service authorization established;
11. separate intentional START initiates production motion.

**INFERENCE:** steps 8–11 are architecture teaching boundaries for this curriculum; their exact machine implementation must be established by machine-specific evidence. LOTO release itself must not be taught as equivalent to safety reset, normal-control rearm, or START.

## Stop conditions

Stop the servicing transition and leave the machine controlled/out of service when any safety-relevant item is unresolved, including:

- an exposed person cannot be accounted for;
- an applicable hazardous-energy source has no verified isolation/control;
- stored energy can reaccumulate and required control/monitoring is absent;
- shift-transfer protection continuity is uncertain;
- work scope changed beyond the verified energy-control boundary;
- a temporary test/position cycle was not returned to the controlled state;
- a required restraint/block/guard/isolation device is missing or its status is unknown;
- evidence conflicts and the conflict could change personnel exposure.

## Curriculum exercises

1. Draw a three-crew press-brake servicing example with electrical, hydraulic and mechanical/gravity domains. Find every point where ownership could fall between crews. Do **not** invent the machine's actual valve truth table or pressure threshold.
2. Draw a two-shift group-lockbox state machine. Demonstrate that no exposed worker depends solely on the off-going shift's protection or verification.
3. Add one necessary powered positioning cycle. Prove the servicing sequence returns through deenergization, re-isolation and verification before hands-on work resumes.
4. Inject one stale LinuxCNC command and one HMI `SAFE` indication into the scenario. Explain why neither substitutes for physical energy-control verification.

## Open machine-specific evidence obligations

The following remain **UNKNOWN** until actual machine evidence exists:

- every OpenPressBrake hazardous-energy source and isolation point;
- actual accumulator/trapped-pressure behavior and safe verification method;
- ram/gravity restraint method and rated limits;
- electrical discharge times and test points;
- exact test/position procedures requiring energization;
- exact group-LOTO employer procedure and lockbox architecture;
- who is authorized for each role;
- final restart/rearm sequence and physical witnesses.

Do not infer any of these from generic press-brake architecture.

## Next independent study branch

Build `safety-course/SAFETY_ENERGIZED_TEST_POSITIONING_BOUNDARY_CHALLENGE_SET.md` only if the primary lane has not entered test/position or servicing-energy work. Focus on recognizing when a claimed test/position exception has drifted into routine energized servicing, and on restoring isolation/reverification before exposure resumes. If that overlaps the primary lane, switch to a distinct open safety-documentation or physical-restraint verification branch.