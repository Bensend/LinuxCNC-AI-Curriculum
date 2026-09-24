# Safety selected-block qualification checkpoint — 2026-09-24T09:51Z

Status: adversarial restart/rearm/output-witness review complete; reusable templates checked against three materially different professional architecture families; minimum evidence package before schematic capture is now durable. Generic safety schematics remain NOT FROZEN. External/fresh 2520–25F0 competency gates remain open and uncontaminated.

Durable additions/changes:
- `research/SAFETY_RESTART_REARM_OUTPUT_WITNESS_AND_ARCHITECTURE_AUDIT_2026-09-24.md`
- `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md`
- strengthened `hardware/SC-CORE_IMPLEMENTATION_SPEC_TEMPLATE.md`
- strengthened `hardware/SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md`

New freezes:
- `RESET INPUT ACTIVE != DELIBERATE RESET EVENT PROVED`;
- `RESET DEVICE ACCESSIBLE != SAFEGUARDED SPACE CLEAR PROVED`;
- `POWER RESTORED != REARM ELIGIBLE`;
- `MATCHING COMMAND/FEEDBACK != INDEPENDENT PHYSICAL WITNESS`;
- `FINAL-ELEMENT FEEDBACK HEALTHY != COMMON DEPENDENCY ABSENT`.

Professional-family audit:
- Rockwell GuardLogix: programmable safety logic can own reset semantics and transition checking is application/standards dependent.
- SICK deTec4 Core: protective device can require external restart interlock and external EDM implementation.
- Pilz PNOZ s4: compact relay architecture can combine dual-channel diagnostics, monitored start and feedback-loop monitoring.

Conclusion: reusable contracts must specify semantic obligations and evidence ownership, not universal reset edge/timing or one vendor's internal allocation.

Schematic-capture evidence gate now requires selected product/revision, traceability, electrical evidence, state/restart semantics, exact energy path, witness proposition, dependency/CCF record, failure-state table, human/service boundary, validation plan, integrity-claim boundary and disposition of UNKNOWNs. Any UNKNOWN that can alter interface compatibility, fail-safe state, diagnostics, reset/rearm, energy-path authority or a safety-critical dependency is schematic-blocking.

No executable question survived authoritative source/engineering reasoning. No simulation/build/test compute was run and no GitHub-hosted minutes were consumed.

Exact next work:
1. Apply the qualification worksheet to one inspectable professional input -> safety logic/controller -> output/final-element/EDM reference chain as a worked example.
2. Fence all product-specific electrical/timing/reset values from generic requirements.
3. Attack the example for hidden assumptions: reset edge/timing, OSSD/test pulses, feedback independence, power restoration, common 24 V/0 V and physical witness.
4. Correct reusable templates only if the example exposes a genuinely generic evidence gap.
5. Do not freeze a generic safety schematic or invent machine-specific values.
