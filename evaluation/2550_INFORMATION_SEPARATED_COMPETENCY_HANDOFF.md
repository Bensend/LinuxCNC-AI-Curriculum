# 2550 — information-separated competency evaluator handoff

## Information-separation rule

This file specifies the evaluation protocol only. It contains no hidden solution. The evaluator must select a novel scenario whose expected reasoning/result is not exposed to the learner before commitment.

## Scenario requirements

Choose a machine safety function substantially different from the worked 2550 examples. Supply enough evidence to reason about the method, while deliberately including at least two traps among:

- topology that appears more redundant than the real final-element path;
- stale or mismatched use-profile/B10d evidence;
- a diagnostic that witnesses only an intermediate proposition;
- a shared power/routing/environment/connector dependency;
- a certified subsystem whose capability is overextended to the complete function;
- a plausible calculation based on an incorrect application assumption;
- ordinary controller diagnostics presented as though they had safety authority.

Do not require the learner to invent missing numerical reliability, diagnostic, demand-rate, stopping-time, PLr or physical machine data. Missing consequential evidence should be recognized as UNKNOWN.

## Learner precommitment deliverables

Before revealing evaluator expectations, require the learner to submit:

1. safety-function/SRS boundary and PLr provenance;
2. subsystem decomposition;
3. proposed Category reasoning for each self-designed subsystem;
4. MTTFd/B10d/use-profile evidence audit;
5. DC/DCavg diagnostic-proposition audit;
6. CCF/dependency analysis;
7. achieved-integrity claim or explicit statement that evidence is insufficient;
8. calculation/model limitations;
9. physical validation still required;
10. ordinary-control versus personnel-safety authority boundary;
11. release decision for personnel-exposed operation.

## Scoring dimensions

Score independently:

- requirement/PLr provenance;
- Category fault-behavior reasoning;
- reliability/use-profile reasoning;
- diagnostic reasoning;
- CCF/dependency reasoning;
- subsystem/composition reasoning;
- uncertainty discipline;
- calculation-versus-validation boundary;
- safety authority boundary;
- release decision and consequence awareness.

## Critical failures

A critical failure includes:

- deriving PLr from architecture;
- equating Category 4 with PL e without the other required evidence;
- treating a Category-2 test channel as redundant functional safety path by default;
- overlooking a disclosed common dependency that defeats the claimed architecture;
- accepting stale/mismatched use-profile evidence as current;
- using diagnostic state as physical safe-state proof;
- treating a tool result as complete machine validation;
- inventing missing safety-critical physical or reliability facts;
- allowing ordinary LinuxCNC/FPGA control to become sole personnel-safety authority without evidence;
- authorizing personnel-exposed operation when a consequential safety proposition remains unproved.

## After precommitment

Only after the learner commits:

1. reveal/derive the evaluator's independent expected analysis;
2. score each dimension;
3. classify misses as retrieval, mechanism, evidence, uncertainty, transfer, or safety-boundary errors;
4. correct only the underlying curriculum weakness;
5. perform a novel transfer retest before treating the competency as secure;
6. record results in the repository feedback score log without leaking sealed future answers.

## Status

2550 learner material is ready for this external/fresh evaluation. Until it is executed successfully, 2550 is **not self-graduated**.
