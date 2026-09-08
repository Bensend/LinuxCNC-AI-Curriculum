# C05 Fresh-AI Novel Scenario Handoff and Promotion Audit

## Novel scenario
A dual-actuator machine reports nearly identical A/B encoder positions while moving. An independent dial/laser reference, unavailable to the controller, later shows side B actually lagged by 0.35 in during part of the move. Separately, a maintenance change is known to have altered B encoder scaling. From the C05 artifacts and referenced LinuxCNC source, determine what the controller-visible agreement proves, what fault classes remain possible, what additional evidence is required, and whether ordinary HAL/PID disagreement logic alone is a safety-rated protection mechanism.

## Handoff solution
1. Controller-visible A/B agreement proves only that the two feedback values presented to the control logic agreed within the observed tolerance. It does not prove equal physical position.
2. The independent reference falsifies the inference `feedback agreement -> physical agreement` for this scenario. A scale/configuration error can make a physically lagging side numerically agree with the other side; freeze/jump/wiring/electronics/common-mode errors are also possible until independently excluded.
3. To isolate root cause, compare each sensor channel against an independent physical reference while also checking raw counts/electrical state/configured scaling and the commanded/controller output path. A second value derived from the same corrupted measurement is not independent evidence.
4. PID/cross-coupler response is response to the measurement supplied to it; it is not an oracle for plant truth. Correcting a false measurement can drive the real plant in the wrong direction.
5. Ordinary HAL/PID monitoring demonstrated here is not safety-rated sensor-fault handling. Safety claims require a separately justified architecture, failure analysis, diagnostics, hardware behavior, and applicable safety engineering.

## Evaluation
**PASS at 1000 level.** The novel scenario is not answered verbatim by either C05 experiment, but it transfers the central distinction demonstrated by C05-028/C05-029: measured feedback can diverge from simulated/physical truth and controller reaction cannot identify the fault origin by itself. The solution preserves explicit uncertainty rather than inventing diagnostic certainty.

## Promotion / uncertainty queue
| Item | Current evidence | Why deferred | Consequence if wrong | Destination | Blocks 1000? | Why safe to promote |
|---|---|---|---|---|---|---|
| Physical encoder electrical/mechanical fault signatures | C05 software fault fixtures only | Requires actual sensor/hardware fault injection and IO-path detail | Changes diagnostic specificity, not the demonstrated measurement-vs-truth distinction | 2000 / IO03-S06 | No | Core C05 claim holds for any mechanism capable of corrupting reported feedback |
| Safety-rated redundant-position architecture | Explicitly outside ordinary HAL/PID proof | Requires standards, hardware architecture, diagnostic coverage and machine hazard analysis | Material to a real safety design | 2000+ / S01-S05 | No, provided boundary remains explicit | C05 makes no safety-rating claim and warns against using its fixture as one |
| Exact discrimination among plant fault, scale error, freeze, jump, wiring and common-mode corruption | Experiments prove non-uniqueness from controller-visible feedback alone | Needs independent sensors/metrology and fault-specific tests | Affects diagnosis | 2000 | No | The 1000-level teaching is precisely that controller feedback alone is insufficient |

## Counterfactual promotion test
Assume every promoted hardware-specific expectation above turns out differently: a real encoder fails by a different electrical signature, a safety architecture uses different redundancy, or a physical fault requires different metrology. None overturns these central, independently demonstrated teachings:

- the controller acts on the feedback value supplied to it;
- a supplied feedback value can be frozen, scaled, or jumped independently of the simulated plant state;
- controller-visible agreement/disagreement alone does not establish physical truth or unique root cause;
- ordinary HAL/PID behavior is not by itself a safety-rated protection claim.

Therefore the promoted items do not invalidate the C05 evidence chain, downstream prerequisite, or retained safety boundary.

## Graduation sufficiency
C05 has pinned-source grounding, official/community research, end-to-end call-flow documentation, two independent reproducible failure-mode experiments (C05-028 and C05-029), preserved invalid attempts, a predeclared prediction/evidence chain, a 10/10 adversarial exam already recorded in course state, corrections, and this novel-scenario handoff. The 1000-level minimum evidence floor is satisfied.

**Decision: C05 — GRADUATED at 1000 level.**