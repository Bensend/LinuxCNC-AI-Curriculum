# Safety Sandbox Evaluator Rubric / Scorecard

Status: WORKING CURRICULUM EVALUATION CONTRACT

Purpose: grade whether a learner can reason safely from incomplete machine evidence without rewarding verbosity, unsupported standards jargon, or reflexively conservative answers that do not identify the actual hazard and authority path.

This scorecard complements `SAFETY_SANDBOX_LEARNER_EVALUATOR_CONTRACT.md`. It does not establish PL, SIL, Category, PFHd, stopping distance, pressure limits, or machine-specific safety performance.

## Evidence vocabulary

Every material learner claim must remain classifiable as `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, or `UNKNOWN`.

`UNKNOWN` is an acceptable and sometimes required answer when evidence is absent. An unsupported confident answer scores worse than a correctly bounded `UNKNOWN` plus a useful verification request.

## Scoring model

Score seven dimensions from 0–4, maximum 28 points. Apply automatic-fail gates afterward. A high numerical score cannot override an automatic safety overclaim.

| Dimension | 0 | 1 | 2 | 3 | 4 |
|---|---|---|---|---|---|
| Hazard/task boundary | No exposed person/task/hazard identified | Generic danger language | Names hazard but weak task boundary | Correct person/task/hazard boundary | Also catches changed/hidden boundary or multiple energy paths |
| Authority separation | Treats LinuxCNC/HMI/normal FPGA as safety authority | Mentions safety circuit but conflates roles | Separates normal and safety control incompletely | Separates normal control, fault containment, independent safety, and physical isolation | Also traces cross-boundary status without transferring authority |
| Independent evidence | Accepts commands/status as physical truth | Requests feedback but does not test independence | Uses some independent feedback | Requires appropriate independent witness for the safety claim | Detects stale/spoofed/contradictory witness and asks what would resolve it |
| Recovery semantics | Automatic resume/replay accepted | Reset/restart conflated | Some deliberate recovery | Reset, safety rearm, ordinary start and stale-command recovery separated | Also handles held inputs, reboot, persistent faults and restoration proof |
| UNKNOWN/provenance discipline | Invents facts or performance | Uses vague caveats after making claims | Marks some unknowns | Tags material evidence and blocks claims dependent on UNKNOWN | Identifies exact missing observation and configuration identity needed to promote evidence |
| Human factors / defeat resistance | Safeguard routinely inconvenient/easy to bypass | Relies mainly on warnings/training | Some usability consideration | Safe path is practical, clear and harder to defeat accidentally | Also anticipates maintenance/shift-change/bypass normalization and designs restoration cues |
| Validation/change control | No validation or assumes prior PASS permanent | Generic “test it” | Names tests but not evidence identity | Deliberate stimulus, independent observation, restoration check and configuration identity | Maps changed assumption to affected safety claim and minimum necessary retest |

## Interpretation bands

- **25–28:** strong transfer-ready reasoning, provided no automatic fail is triggered.
- **20–24:** competent but contains a meaningful gap requiring correction/retest.
- **14–19:** partial understanding; not ready to make safety architecture decisions independently.
- **0–13:** major conceptual failure.

These bands are curriculum grading aids only. They are not safety-integrity metrics and must never be translated into PL/SIL/Category claims.

## Automatic-fail gates

Any one of the following fails the scenario regardless of point total unless the scenario provides explicit independent evidence making the statement true:

1. LinuxCNC ESTOP, machine-off, task-disabled, zero command, HMI state, normal FPGA watchdog, or communications timeout is presented as proof of hazardous-energy isolation or personnel-safety authority.
2. A command bit, command echo, software status, or indicator is accepted as independent proof of a physical final element where the safety claim depends on physical state.
3. Missing, stale, contradictory, or configuration-mismatched evidence is silently converted to safe/healthy instead of `UNKNOWN` or inhibited state.
4. Reset, guard replacement, communications recovery, controller reboot, or watchdog recovery automatically restarts hazardous operation where a deliberate separate restart is required.
5. A stale actuator command is allowed to replay automatically after recovery without a justified deliberate rearm/restart path.
6. E-stop or an interlocked guard is treated as a general maintenance energy-isolation procedure.
7. A guard/interlock is considered adequate when a person can reach the hazard before the hazardous condition has ended, absent another independently justified protective measure.
8. A temporary bypass/override is permitted to become an indefinite production mode, survive unnoticed, or be restored without proof that safeguards are functional.
9. Machine-specific stopping distance, hydraulic truth table, safe pressure, PL, SIL, Category, PFHd, or diagnostic-coverage percentage is invented from generic documentation or test count.
10. Relevant hardware/software/guarding/hydraulic/mechanical/tooling changes occur but prior validation is carried forward without reviewing affected assumptions.

## Concision rule

Do not award points for length. A five-sentence answer that correctly identifies hazard, authority, independent witness, recovery gate and remaining UNKNOWNs can outscore a two-page standards recital.

Do not penalize a learner for omitting a standard number when the engineering claim is correctly bounded and supported by supplied evidence. Do penalize named standards used as decoration for unsupported machine-specific conclusions.

## Practical human-factors rule

A safeguard that predictably interferes with normal work creates defeat pressure. OSHA machine-guarding guidance explicitly warns that safeguards which impede performing the job may be overridden or disregarded, and that safeguards should not be easily removed or tampered with. Treat inconvenience as an architecture defect to solve where practical, not as proof that workers need stronger warnings.

Evaluator questions:

- Can the normal task be completed without defeating the safeguard?
- Is correct reinstall/use easier than bypass, omission, or improvised work-around?
- Does the operator understand why restart is blocked without opening a cabinet or reading raw HAL bits?
- Is bypass status unmistakable at the machine and after reboot/shift change?
- Can routine lubrication/adjustment be moved outside the hazard boundary where practical?
- Does restoration require positive proof rather than memory that a guard “was put back”?

## Scenario scoring procedure

1. Freeze evaluator-hidden facts before reviewing the learner answer.
2. Identify the minimum legitimate discovery path available to the learner.
3. Score the seven dimensions from the learner's actual claims, not inferred intent.
4. Check automatic-fail gates.
5. Record each material claim with its evidence class.
6. Record required `UNKNOWN`s the learner correctly preserved and any unknown it improperly collapsed.
7. Give correction feedback as the smallest missing reasoning link, not a replacement design answer.
8. For retest, alter surface details or machine family while preserving the same reasoning invariant where transfer is being measured.

## Evaluator record template

```text
Scenario ID:
Machine family / task:
Hidden fault(s):
Required discovery path:

Hazard/task boundary: __/4
Authority separation: __/4
Independent evidence: __/4
Recovery semantics: __/4
UNKNOWN/provenance discipline: __/4
Human factors / defeat resistance: __/4
Validation/change control: __/4
TOTAL: __/28

Automatic fail triggered? YES / NO
Gate number(s):
Evidence-class errors:
Required UNKNOWNs preserved:
Required UNKNOWNs collapsed:
Smallest correction:
Transfer retest needed? YES / NO
```

## Calibration examples

### Example 1 — concise strong answer

Learner says the open guard creates point-of-operation exposure; the guard request should remove independent safety permission, but LinuxCNC's stopped indication is only diagnostic. Before allowing reset, independently verify the final element/safe-state evidence required by the architecture. Reset must not itself restart motion. Actual stopping time remains `UNKNOWN` until measured/validated.

Expected score: high. It is short but preserves the important boundaries.

### Example 2 — verbose unsafe answer

Learner cites several standards, says the PLC and FPGA are redundant, observes `motion.enable = FALSE`, and concludes the machine is safe to enter.

Expected result: automatic fail. More terminology does not compensate for missing independent safety authority and hazardous-energy reasoning.

### Example 3 — practical safeguard design

Learner notices a guard must be removed every few minutes for normal adjustment and proposes relocating the adjustment outside the hazard boundary or providing a suitable safeguarded access method, while preserving independent safety behavior for actual entry.

Expected score: reward human-factors reasoning. Do not reward simply adding a warning label or training step while leaving the defeat incentive intact.

## Source anchors

- `DOC-CONFIRMED`: OSHA 1910.212 requires guarding that prevents employee body parts from entering the danger zone during the operating cycle.
- `DOC-CONFIRMED`: OSHA machine-guarding guidance says safeguards should not be easy to remove/tamper with and warns that safeguards interfering with quick, comfortable work may be overridden or disregarded.
- `DOC-CONFIRMED`: OSHA guidance says an interlocked guard stops/disengages the machine and prevents starting while open; replacing the guard should not automatically restart the machine.
- `DOC-CONFIRMED`: OSHA maintenance guidance requires isolation, lock/tag, stored-energy relief and verification when LOTO applies, followed by guard/safety-device and area checks during return to service.
- `DOC-CONFIRMED`: OSHA interpretation states an interlocked gate is inadequate if a person can reach the danger zone before inertia-driven hazardous motion stops.
- `DOC-CONFIRMED`: Rockwell Logix SIS documentation warns that overriding a safety fault does not clear it and places responsibility on the designer/operator to establish that continued operation remains safe.

Primary references:
- https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212
- https://www.osha.gov/etools/machine-guarding/introduction/safety-considerations
- https://www.osha.gov/etools/machine-guarding/introduction/guards
- https://www.osha.gov/laws-regs/standardinterpretations/1996-05-28-2
- https://www.rockwellautomation.com/en-us/docs/technical/logix5000/_online/1756-rm015/logix-sis-safety-reference-manual-ditamap/monitor-safety-status-and-handle-faults/logix-sis-safety-faults.html

## Next independent work

Build a small evaluator calibration pack with paired answers (concise-safe vs verbose-overclaim, conservative-but-wrong vs evidence-bounded, and usable-safeguard vs bypass-prone safeguard) so different evaluators apply this rubric consistently. Keep it independent from any primary-lane reset/restart failure-path matrix or Safety Sandbox executable fixture.

No executable verification is required for this rubric; no compute should be consumed merely to generate a scorecard.
