# Safety curriculum checkpoint — 25F0 capstone audit next

UTC checkpoint: 2026-09-24T02:45Z

## Durable state

- Press-brake professional architecture trace remains durable.
- `research/25F0_PRESS_BRAKE_SRS_VALIDATION_FAULT_MATRIX_2026-09-24.md` now converts the fault seed into SRS-linked validation cases.
- Cases cover stuck motion-permitting valve, false valve feedback, broken safety channel, common electrical/control supply, common pilot/hydraulic supply, safety-output removal, power restoration, trapped/accumulator pressure, gravity-loaded beam, maintenance access inside the die space and common-cause bridges.
- Every case separates demand, failed path, independent response, physical witness, residual hazardous-energy proposition and rearm/revalidation condition.
- Adversarial commissioning cases explicitly reject healthy status/feedback as a substitute for physical proof.
- No executable compute was justified and no GitHub-hosted compute was used.

## Exact next work

1. Audit 25F0 against the cross-machine capstone contract and current safety syllabus/competencies.
2. Determine whether plasma/cutting-machine safety remains a genuine learner-facing gap. Add only a safety transfer delta if required; do not regress to closed 3300 manufacturing instruction.
3. Confirm every press-brake validation row names a physical witness appropriate to the proposition and leaves unsupported physical behavior UNKNOWN.
4. If no material gap remains, create the canonical learner route and separate no-solution information-isolated evaluator handoff, then mark 25F0 READY FOR EXTERNAL/FRESH EVALUATION rather than self-graduating.
5. Any justified executable compute must target `[self-hosted, openpressbrake]` only.
