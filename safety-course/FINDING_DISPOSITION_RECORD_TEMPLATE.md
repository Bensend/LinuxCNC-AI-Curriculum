# Reusable Safety Finding / Disposition Record

Use this template when inspection, proof testing, commissioning, troubleshooting, observation, incident evidence, or environmental/process evidence contradicts or materially weakens an accepted safety proposition.

A finding preserves the original adverse observation. Repair and later passing evidence are appended; they do not rewrite the finding.

## Identity and observation

- `FIND-ID:` FIND-____
- `state:` OPEN | CONTAINED | CORRECTIVE_ACTION_IN_PROGRESS | READY_FOR_REPROOF | REPROOF_COMPLETE | ACCEPTED_CLOSED | REDESIGN_REQUIRED | DECOMMISSIONED
- `observed_utc:`
- `machine/use_state:`
- `observation:`
- `evidence:` EVID-____
- `evidence_class:` SOURCE-CONFIRMED | DOC-CONFIRMED | TEST-CONFIRMED | COMMUNITY-REPORTED | INFERENCE | UNKNOWN
- `acceptance_criterion:`
- `result:` PASS | FAIL | INDETERMINATE | UNKNOWN

## Immediate safety disposition

- `potentially_invalidated_propositions:` PROP-____
- `immediate_hazard_implication:`
- `containment:`
- `operation_allowed_while_open:`
- `residual_risk_or_unknown:`

If the finding makes a safety-critical proposition `UNKNOWN` or failed, do not treat ordinary controller health, alarm acknowledgement, reset, or production demand as substitute acceptance evidence. If exposed operation cannot meet the minimum safe-to-operate threshold, keep people outside the danger zone and use isolated/remote experimental operation only under a machine-specific plan.

## Dependency / show-where-used trace

- `implicated_dependencies:` DEP-____
- `affected_safety_functions:` SF-____
- `affected_propositions:` PROP-____
- `unaffected_propositions_reviewed:`
- `why_unaffected:`
- `cross_function_common_cause_review:`

Do not stop the trace at the safety PLC, LinuxCNC, FPGA, or sensor boundary. Include shared physical/environmental dependencies such as power, final elements, mechanical transmission, contamination, temperature, vibration, hydraulic/pneumatic supply, alignment, mounting, tooling/load, and process response when actually applicable.

## Cause and correction

- `suspected_cause:` INFERENCE | UNKNOWN | other evidence class
- `cause_evidence:` EVID-____
- `corrective_action:` CHG-____
- `design_or_process_change_required:`
- `recurrence_links:` FIND-____
- `recurrence_class:` FIRST_KNOWN | REPEAT_SAME_DEPENDENCY | REPEAT_SAME_PROPOSITION | CROSS_FUNCTION_PATTERN | UNKNOWN
- `escalation_review_required:` YES | NO | UNKNOWN
- `escalation_reason:`

A repeated finding is not automatically proof of one root cause. It is a trigger to test whether the prior diagnosis/correction, maintenance interval, proof method, environment, design margin, installation, or human workflow is inadequate.

## Re-proof and acceptance

- `reproof_obligations:` VAL-____
- `new_evidence:` EVID-____
- `physical_propositions_reproved:` PROP-____
- `configuration_identity_checked:`
- `exceptional_states_forces_simulations_cleared:`
- `acceptance_authority:`
- `acceptance_utc:`
- `closure_status:`
- `remaining_unknowns:`

## Return to ordinary operation

- `finding_closed:` YES | NO
- `reset_rearm_completed:` YES | NO | N/A
- `fresh_ordinary_demand_required:` YES | NO
- `fresh_ordinary_demand_observed:` YES | NO | N/A

`FINDING CLOSED != RESET/REARM != FRESH ORDINARY START DEMAND`.

## Minimal recurrence/escalation test

Before treating a recurrence as another isolated repair, answer:

1. Is the same `DEP-*` or `PROP-*` implicated again?
2. Did the prior corrective action actually address the demonstrated cause, or only restore function temporarily?
3. Is a shared environmental or physical dependency affecting multiple channels/functions?
4. Is the proof/inspection method sensitive enough to detect the degradation before exposure becomes unacceptable?
5. Does maintenance frequency match observed degradation, without inventing a universal interval?
6. Does normal operation, setup, cleaning, access, or production pressure predictably encourage the condition or its concealment?
7. Would a design change make the safe condition easier to maintain than repeated procedural correction?

Any unresolved safety-critical answer remains `UNKNOWN` and prevents unsupported closure.