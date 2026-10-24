# 4400 — Common DC-bus / motor regeneration / energy isolation: blank evidence witness
**2026-10-24 | CONDITIONAL MACHINE INTAKE | ALL CASES NOT RUN**

**This is an evidence collection contract, not permission or instructions to perform live electrical work.** Only qualified authorized personnel following the selected OEM/site electrical safety procedures may perform required physical measurements. No student live-cabinet experiments; keep personnel outside the hazard zone for unqualified experimental operation.

| Witness ID | Question / required artifact | Owner and revision | Evidence location (restricted when proprietary) | State |
|---|---|---|---|---|
| CB-PHY-01 | Is a common DC bus actually present? As-built supply/inverter/busbar/extension topology | — | — | UNKNOWN |
| CB-PHY-02 | Every AC source: transformer feed, alternate supply, regenerative AFE, input busbars | — | — | UNKNOWN |
| CB-PHY-03 | Every DC source: feeder, DC/DC converter, battery/energy storage, other cabinet, optional bus switch | — | — | UNKNOWN |
| CB-PHY-04 | Every motor type and credible externally driven/PM regeneration path, including gravity | — | — | UNKNOWN |
| CB-PHY-05 | Every auxiliary/relay/brake chopper/resistor circuit and accessible hazardous conductor | — | — | UNKNOWN |
| CB-PHY-06 | Exact selected OEM/model/option/manual and lockable isolation device per relevant source | — | — | UNKNOWN |
| CB-PHY-07 | OEM-required discharge delay, accessible approved test points, qualified tester/verification procedure | — | — | UNKNOWN |
| CB-PHY-08 | Isolation/zero-voltage physical proof for each required zone, including reaccumulation controls | — | — | NOT RUN |
| CB-PHY-09 | Independent hazardous-motion stop, coast, gravity holding and access protection | — | — | NOT RUN |
| CB-PHY-10 | Deliberate safety rearm, occupancy clear, fresh motion start and post-maintenance check | — | — | NOT RUN |
| CB-PHY-11 | Change control for added inverter, capacitor, bus extension, drive firmware or PM motor | — | — | NOT RUN |

**Causal failure injection on paper (NOT RUN):** local breaker opens but shared bus remains connected; drive ready signal false while bus charged; external DC feeder energizes; PM shaft rotates; bleed path defective; capacitor extension added; output grounding attempted while PM shaft rotates; power restored with retained start demand. These are *analysis cases*, not instructions to create hazards.

**Decision:** Installed bus presence: UNKNOWN. If definitively absent, mark `CB-PHY-01 N/A` and document the actual alternative topology. If present, no `VAL/PT` physical claim may close from ordinary controller bits or paper reasoning. Record `BND/ENE/HAZ/SF/SRS/AUTH/DEP/ARC/PHY/VAL/PT/CHG/RR/UNK` IDs and machine-specific restricted evidence; do not publish proprietary diagrams.

**Release state:** `G0/G1 HOLD`; `G3/G4 NOT AUTHORIZED`; no personnel-exposed operation authorized. Cross-reference [source audit](../research/4400_COMMON_DC_BUS_REGENERATION_REENERGIZATION_AND_ISOLATION_OEM_AUDIT_2026-10-24.md).
