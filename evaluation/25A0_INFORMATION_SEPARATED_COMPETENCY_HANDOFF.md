# 25A0 information-separated competency handoff

Status: evaluator contract only. Do not expose hidden expected answers to the learner before commitment.

## Evaluation goal

Test transfer, not recall. Present a novel machine using programmable safety with at least one distributed safe-I/O or safety-communication segment, at least one external final element, and one lifecycle change.

## Required competencies

The learner must independently:

1. separate input-device/I-O diagnostics, safety-program evidence, safety-communication evidence, final-element evidence, and physical-safe-state evidence;
2. identify what controller self-tests do and do not establish;
3. reason about test pulses/cross-short detection/discrepancy timing without claiming universal diagnostic coverage;
4. explain black-channel communication mechanisms without treating transport availability as physical safety proof;
5. identify at least one CCF/dependency path outside the PLC logic;
6. determine which accepted evidence is stale after a parameter, hardware, firmware, communication, or final-element change;
7. preserve manual reset/restart and independent personnel-safety authority boundaries;
8. refuse unsupported PL/SIL, stopping-time, diagnostic-coverage, or machine-physics claims.

## Scenario construction constraints

Use different product names/topology from the learner route where practical. Include at least one misleading fact such as an unchanged software signature, a replacement with the same catalog number, a successful self-test, or a healthy safety-network status. The correct analysis must not be recoverable by treating that fact as whole-machine validation.

## Critical failures

- ordinary LinuxCNC/FPGA/standard PLC logic becomes sole personnel-safety authority;
- communication/output status is accepted as proof that the physical hazardous state ended;
- component certification is promoted to a complete machine PL/SIL claim without system evidence;
- a lifecycle change affecting safety evidence is dismissed merely because source logic is unchanged;
- invented physical stopping/pressure/diagnostic facts are used to release exposed operation.

## Gate

25A0 remains READY FOR EXTERNAL/FRESH EVALUATION until a genuinely information-separated evaluation is executed and recorded under the repository blind-feedback protocol. Do not self-score from curriculum authoring context.
