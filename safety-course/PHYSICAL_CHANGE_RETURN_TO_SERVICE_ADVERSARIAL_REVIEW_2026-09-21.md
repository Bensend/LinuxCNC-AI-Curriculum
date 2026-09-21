# Physical-change return-to-service procedure — adversarial review

Date: 2026-09-21

## Scope

Adversarially review `PHYSICAL_CHANGE_TO_RETURN_TO_SERVICE_DECISION_PROCEDURE_2026-09-21.md` against the 25E0 physical-change exercise and the course's practical human-factors rules. This is curriculum INFERENCE unless an underlying statement is already source-confirmed in its cited course study. It does not assign machine-specific PL/SIL, stopping limits, hydraulic thresholds, proof-test intervals, or OpenPressBrake truth tables.

## Result

The procedure's core dependency/evidence-class model survives review, but seven loopholes need to be made explicit in future use.

### 1. Do not limit impact analysis to previously known dependencies

A physical change can create a new hazard path, defeat opportunity, access path, pinch/crush exposure, blind area, or common-cause dependency rather than merely invalidate evidence for an existing function.

Required question before revalidation scoping:

> Did the change create or materially alter a hazard, access path, safeguard defeat path, common-cause dependency, or operating/maintenance task?

If yes, update the hazard/safety-function model first. Repeating old acceptance tests cannot validate a newly created hazard that the old tests never addressed.

Freeze: **OLD TEST SUITE PASSED != NEW/ALTERED HAZARD COVERED.**

### 2. Retained evidence needs positive traceability, not silence

The procedure correctly says retained A/B/C/D evidence must be justified. Strengthen this: retained evidence needs an identified dependency basis and the prior evidence must still be applicable to the current machine condition. `Not obviously changed` is not a justification.

Freeze: **NO KNOWN CHANGE != EVIDENCE STILL APPLICABLE.**

### 3. Temporary bypasses/test aids are themselves return-to-service dependencies

Commissioning can introduce jumpers, forced I/O, maintenance keys, temporary blocks, test fixtures, reduced-speed/service modes, defeated guards, software overrides, disconnected loads, or special hydraulic test connections. Production release must positively verify removal/restoration of every temporary test condition that could alter ordinary protection or motion authority.

Freeze: **VALIDATION PASSED WITH TEST SETUP != PRODUCTION CONFIGURATION RESTORED.**

### 4. The test method can create exposure

A demand/fault/performance test is not automatically safe merely because it validates a safety function. Before deliberately challenging a protective device or final element, establish a test-state hazard boundary: personnel position, remote/isolation strategy where needed, expected motion/energy, abort path, and what must remain independently protective during the test.

If minimum protection cannot be maintained for an energized test, perform it isolated/remote with people outside the danger zone and state residual risk.

Freeze: **TEST REQUIRED != PERSONNEL EXPOSURE JUSTIFIED.**

### 5. Failure disposition must prevent favorable-run cherry-picking

The procedure already requires cause/repair/retest. Add a stronger rule: an unexplained intermittent failure, disagreement, drift, or one bad run followed by a good run is unresolved evidence, not a pass. The repair/retest record must explain why the failed condition no longer invalidates the safety claim.

Freeze: **LATER PASS != EARLIER UNEXPLAINED FAILURE CLOSED.**

### 6. Human factors must include future maintainability and defeat resistance

The existing human-factors question is sound but too narrow if treated only as a final review. Evaluate whether the changed design makes correct installation, alignment, inspection, proof testing and restoration obvious and easy; whether it can be reinstalled incorrectly while appearing healthy; and whether production pressure will predictably encourage bypass.

Prefer keyed/fool-resistant mounting, visible witness marks/status where appropriate, captive/simple hardware, accessible test points, clear labels, and restoration checks when these reduce foreseeable defeat or misassembly. These are design principles, not claims that any one implementation is sufficient for a safety function.

Freeze: **FUNCTIONALLY VALID TODAY != MAINTAINABLE/DEFEAT-RESISTANT OVER LIFE.**

### 7. Production release needs an exact machine-state boundary

The procedure separates validation, personnel clear, reset/rearm and fresh START. Add an explicit release-state check: the machine must be in the intended production configuration/mode, temporary setup authority removed, safeguards restored, unresolved UNKNOWNs dispositioned, and ordinary command sources returned to their intended authority before release.

This reconciles with the parallel Cincinnati setup-mode study: SETUP can retain bounded hazardous-motion authority, so simply changing the selector back is not evidence that tooling/safeguards/test conditions were restored.

Freeze: **MODE RETURNED TO PRODUCTION != PRODUCTION CONFIGURATION REQUALIFIED.**

## 25E0 exercise stress test

### Light-curtain bracket replacement

The exercise correctly invalidates normal-demand/geometry evidence and conditionally invalidates quantitative evidence. The adversarial addition is to ask whether the new bracket changes access around/under/over the field, creates easy misalignment/defeat, can be installed in a plausible wrong position while the receiver remains healthy, or changes the reference from which safety distance/field geometry is established. Those are not answered by a green receiver or unchanged safety signature.

### Hydraulic valve replacement

The exercise correctly shifts evidence toward the hydraulic final element. The adversarial addition is to ask whether the replacement changes failure behavior, flow direction/connection identity, response dynamics, diagnostic/monitoring compatibility, trapped-energy behavior, or another shared hydraulic dependency. Correct part number and restored parameters are installation/configuration evidence only. Machine-specific physical acceptance remains UNKNOWN until authoritative design/OEM evidence supplies it.

## Recommended decision-procedure insertion

Before the existing `Trace affected safety functions` step, add:

1. identify the changed item and temporary conditions;
2. perform a **new/altered hazard and defeat-path check**;
3. if the hazard model changed, update safety-function requirements before scoping revalidation;
4. then trace affected dependencies and A/B/C/D evidence.

Immediately before production release, add:

1. close every failed/intermittent result by cause + repair + retest;
2. remove temporary bypasses/test aids and restore production configuration;
3. requalify affected safeguards/physical geometry;
4. confirm personnel clear and intended operating mode;
5. perform required reset/rearm;
6. require a fresh ordinary START.

## Compute

No simulation or executable test is justified. The unresolved work is engineering reasoning and curriculum hardening, not runtime behavior.
