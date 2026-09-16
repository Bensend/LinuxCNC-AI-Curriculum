# Safety Sandbox Learner / Evaluator Contract

Status: WORKING CURRICULUM CONTRACT

Purpose: define what a learner may observe, what an evaluator may inject or withhold, and what constitutes a safety overclaim in the Safety Sandbox. This is a curriculum/evaluation artifact, not a claim that LinuxCNC, an FPGA, a PLC, or any generic circuit is safety-rated.

## Evidence vocabulary

Every material claim must be tagged as one of:

- `SOURCE-CONFIRMED` — directly supported by inspectable source code or an authoritative primary source.
- `DOC-CONFIRMED` — directly supported by authoritative documentation.
- `TEST-CONFIRMED` — demonstrated by a recorded test within its stated configuration and limits.
- `COMMUNITY-REPORTED` — reported by a practitioner/community source but not independently established here.
- `INFERENCE` — engineering conclusion drawn from identified evidence.
- `UNKNOWN` — evidence is absent, stale, contradictory, configuration-dependent, or requires physical measurement.

`UNKNOWN` is not a weak PASS. It blocks any claim that depends on the unknown fact.

## Core architecture boundary

The learner must keep these authorities distinct:

1. **Normal machine control** — LinuxCNC task/motion/HAL, normal FPGA logic, HMI, network transport, process sequencing.
2. **Normal-control fault containment** — watchdogs, command freshness, stale-feedback detection, output inhibition, explicit controller rearm.
3. **Independent safety-related control** — safety devices/controllers/final elements whose suitability must be established independently for the actual application.
4. **Physical hazardous-energy isolation/restraint** — disconnects, lockable isolation, dissipation, blocking/restraint and verification appropriate to the energy source and servicing task.

A signal may cross boundaries for status/diagnostics without transferring authority. A normal FPGA watchdog can remove ordinary output authority; that does not make it the personnel-safety authority. A LinuxCNC ESTOP state can be useful machine-control state; it is not proof of LOTO isolation.

## Learner-visible information

A scenario may expose only information an engineer could legitimately possess at that stage:

- machine-family hazard map and task boundary;
- declared safety functions and intended safe state;
- normal-control command/status traces;
- safety-device input states where the architecture exposes them diagnostically;
- final-element command and independent feedback as separate observations;
- reset/restart/rearm state;
- energy-source inventory entries that have actually been established;
- source/documentation excerpts with provenance;
- prior test evidence whose configuration identity still matches;
- explicit `UNKNOWN` fields.

The UI must visually distinguish **commanded**, **reported**, **independently witnessed**, and **physically verified** state. A single green `SAFE` lamp must never collapse these categories.

## Evaluator-hidden information

The evaluator may withhold facts whose absence is itself part of the exercise, including:

- a welded or mechanically stuck final element;
- a broken, shorted, cross-connected or spoofed feedback path;
- stale network/FPGA state that still looks plausible;
- a held reset/start input;
- a defeated guard/interlock;
- a second hazardous-energy source or stored-energy mechanism;
- a configuration change that invalidates old evidence;
- a maintenance bypass left active;
- a sensor frozen at a plausible value;
- a mismatch between commanded and physical state;
- a changed machine-family hazard boundary or task.

Hidden faults must not require the learner to guess arbitrary machine facts. The scenario must provide a legitimate path to discover the problem, declare it `UNKNOWN`, request the missing observation, or refuse an unsafe conclusion.

## Evaluation invariant

A correct learner response follows:

`hazard -> safety function -> claimed safe state -> authority -> independent witness -> reset/restart conditions -> residual unknowns`

The evaluator grades the chain, not whether the learner says the preferred buzzword.

## Automatic overclaim failures

The following are curriculum FAIL conditions unless the scenario explicitly supplies independent evidence making the claim true:

1. Treating LinuxCNC ESTOP, machine-off, task-disabled, feed-hold, zero command, or HAL state as proof of hazardous-energy isolation.
2. Treating an FPGA watchdog or communications timeout as proof that personnel are protected by a safety-rated function.
3. Treating a command echo as independent final-element feedback.
4. Treating HMI color/text as physical proof of guard, contactor, valve, pressure, motion or isolation state.
5. Declaring a safety function restored merely because its initiating device returned healthy.
6. Allowing reset itself to initiate hazardous motion when a separate deliberate restart is required by the architecture.
7. Replaying a stale actuator command automatically after network, FPGA, controller or safety-state recovery.
8. Converting missing, contradictory or stale evidence to a benign default instead of `UNKNOWN`/inhibited state.
9. Claiming PL, SIL, Category, PFHd, diagnostic-coverage percentage, stopping distance, safe pressure, or other quantitative safety performance without the required design-specific evidence.
10. Treating a previous PASS as permanently valid after a relevant wiring, configuration, guarding, mechanical, hydraulic, tooling or software change.
11. Treating an E-stop as a maintenance energy-isolation procedure.
12. Permitting a maintenance bypass/temporary override to become an unbounded production mode.
13. Assuming a guard may unlock/open while the hazardous condition persists merely because a stop request was issued.
14. Treating ordinary PLC/LinuxCNC/FPGA control alone as LOTO-equivalent protection for servicing outside a specifically justified alternative-protection case.

## Strong-answer requirements

A high-quality learner answer should:

- identify the exposed person/task and hazard before discussing implementation;
- distinguish stop from isolation;
- name which subsystem has normal-control authority and which has independent safety authority;
- require independent feedback where the safety claim depends on final-element state;
- state what observation would resolve each important `UNKNOWN`;
- preserve manual reset and separate restart/rearm semantics where applicable;
- require deliberate recovery after stale-command/watchdog events;
- account for residual/reaccumulating energy where servicing is involved;
- refuse machine-specific numeric claims when measurements/design evidence are absent;
- identify evidence provenance and configuration identity.

## Scenario contract

Each Safety Sandbox scenario should declare, in evaluator metadata:

| Field | Requirement |
|---|---|
| Machine family | press brake, plasma, mill, lathe, robot/cell, etc. |
| Task | production, setup, jam clearing, troubleshooting, maintenance, commissioning |
| Exposed person | operator, setter, maintenance, bystander, integrator |
| Hazard boundary | physical zone/process where harm can occur |
| Hazardous energies | known sources plus intentionally hidden candidate if used |
| Safety function under test | E-stop, guard, EDM, reset, isolation, watchdog containment, etc. |
| Intended safe state | qualitative only unless sourced/measured |
| Learner-visible signals | exact list |
| Hidden fault(s) | exact evaluator-only list |
| Required discovery path | observation/test/reasoning path available to learner |
| Evidence classes available | SOURCE/DOC/TEST/etc. |
| Forbidden overclaims | scenario-specific additions to global list |
| Minimum PASS claims | assertions learner must establish |
| Required UNKNOWNs | facts learner must not pretend to know |
| Restoration gate | what must be true before reset/restart/rearm |

## Machine-family adaptation

The evaluator should reuse the same reasoning contract while changing the physical hazard boundary.

### Press brake

Typical questions: point-of-operation crushing, ram/gravity or hydraulic stored energy, guard/light-curtain behavior, final hydraulic/electrical elements, reset and deliberate stroke restart. Do not invent hydraulic truth tables, pressure thresholds or stopping distance.

### Plasma / laser / waterjet

Typical questions: gantry motion, torch/process energy, stored electrical/pneumatic energy, extraction/auxiliaries and access to the process envelope. Process-off and motion-off may be different claims.

### Mill / lathe

Typical questions: spindle/axis motion, stored rotational energy, chuck/tool/workholding hazards, guard access and drive final elements. Zero speed command is not proof of standstill.

### Robot / automated cell

Typical questions: perimeter access, trapped persons, restart visibility, multiple actuators/energy sources and coordinated recovery. A clear HMI screen does not prove the cell is clear.

## Evaluator test families

Use the existing fault-injection catalog and coverage map rather than inventing redundant fault lists. Minimum evaluator families are:

- input open/short/channel disagreement;
- guard/interlock defeat or timing mismatch;
- welded/stuck final element plus EDM/feedback behavior;
- held/stuck reset and separate restart;
- communications/watchdog loss and stale-command recovery;
- frozen/stale/disagreeing sensor evidence;
- residual or reaccumulating hazardous energy;
- maintenance bypass lifecycle failure;
- configuration/evidence invalidation;
- compound faults crossing two authority layers.

Test count is not diagnostic-coverage percentage and must never be scored as such.

## Human-factors scoring

The evaluator should reward architectures where the safe path is also the easy path. Penalize designs that predictably encourage defeat of safeguards, such as:

- nuisance reset loops with no diagnostic explanation;
- guards that must routinely be removed for normal work when an accessible alternative is feasible;
- ambiguous `SAFE`/`READY` indicators that hide the reason restart is blocked;
- bypasses that survive reboot or shift change without unmistakable indication and restoration proof;
- recovery sequences that make stale-command replay easier than deliberate rearm.

The learner is not rewarded for adding friction merely because it sounds conservative. Safeguards should be practical, comprehensible and difficult to bypass accidentally.

## Source anchors

- `DOC-CONFIRMED`: OSHA machine-guarding guidance states that an interlocked gate is not acceptable if a person can reach the danger zone before the hazard has stopped; where inertia remains, access must remain prevented until the hazardous motion stops.
- `DOC-CONFIRMED`: OSHA machine-maintenance guidance distinguishes stopping from isolation and calls for isolation, lock/tag, relief of stored/residual energy and verification before servicing; return to service includes confirming guards/safety devices are in place and checking the area before energization/startup.
- `DOC-CONFIRMED`: OSHA interpretation on PLC alternative protection says PLC-based protection is not a general substitute for LOTO; alternative protection for qualifying minor servicing requires an application-specific hazard analysis and effective protection.
- `DOC-CONFIRMED`: Rockwell DCST/DCSTL documentation separates dual-channel safety-input validity, reset actions, and guard-lock feedback; DCSTL states unlock is issued only when the hazard is not present.
- `DOC-CONFIRMED`: Rockwell SS1/SOS documentation distinguishes manual reset from automatic restart and warns automatic restart is appropriate only where its use cannot create an unsafe condition.

Primary references:
- https://www.osha.gov/etools/machine-guarding/introduction/safety-considerations
- https://www.osha.gov/laws-regs/standardinterpretations/1996-05-28-2
- https://www.osha.gov/laws-regs/standardinterpretations/2008-01-25
- https://www.rockwellautomation.com/en-us/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/safety-instructions/dcst.html
- https://www.rockwellautomation.com/en-id/docs/studio-5000-logix-designer/37-00/contents-ditamap/instruction-set/safety-instructions/dcstl.html
- https://www.rockwellautomation.com/en-id/docs/studio-5000-logix-designer/38-01/contents-ditamap/instruction-set/drive-safety-instructions/ss1.html

## Acceptance examples

### A — stale network command

Hidden fault: LinuxCNC-to-FPGA transport drops while the last motion/current command remains nonzero.

PASS: learner requires freshness timeout to remove ordinary output authority, explicit recovery/rearm, and no automatic replay; learner does not call the watchdog safety-rated.

FAIL: learner says Ethernet reconnect may simply resume the last command because the safety circuit is separate.

### B — welded contactor

Hidden fault: contactor command is OFF but the physical final element remains made.

PASS: learner demands independent final-element feedback, blocks restoration/reset as appropriate, and distinguishes the diagnostic observation from physical hazard removal.

FAIL: learner accepts the OFF command bit as proof.

### C — servicing after E-stop

Hidden fact: stored hydraulic/gravity energy remains.

PASS: learner refuses to treat E-stop as maintenance isolation and requires task-specific energy isolation/restraint/dissipation and verification.

FAIL: learner says E-stop plus LinuxCNC disabled is sufficient for maintenance access.

### D — guard access with run-down

Hidden fact: hazardous motion continues after stop command due to inertia.

PASS: learner identifies access timing/guard locking as unresolved and requires prevention of access until the hazard is absent.

FAIL: learner assumes opening the interlock immediately is safe because the stop request was accepted.

## Next independent curriculum work

Create a compact evaluator rubric and scorecard that can grade a learner answer against this contract without exposing hidden answers before commitment. The rubric should score hazard identification, authority separation, independent evidence, recovery semantics, UNKNOWN discipline, human factors and overclaim avoidance; it must not award points for verbosity or unsupported standards jargon.
