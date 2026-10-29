# 4400-HBH-CONFLICT-01 — ROSS HBH: conflicting manufacturer pages on gravity holding and valve construction
**2026-10-29 UTC | original-manufacturer webpage conflict audit | NON-GRADUATED | NO MACHINE TEST.**

## Decision-critical question and predecessor check
Can a qualified designer accept an HBH-family valve as the *sole* sustained gravity-load restraint based on its product page? **No: the manufacturer's own two current web surfaces contradict each other.** This is a **new exact-source contradiction and correction to earlier confidence**, not a new pressure-intensification or block/bleed concept. Predecessors: [HYD-BB-BS-01 ROSS comparison](4400_ROSS_HBB_BLOCK_BLEED_VS_HBH_BLOCK_STOP_MONITORING_AND_LOTO_SCOPE_AUDIT_2026-10-26.md), [four-function decision card](../safety-course/4400_HYD_BB_BS_01_STOP_HOLD_BLEED_MAINTENANCE_FOUR_FUNCTION_COMPARISON_2026-10-26.md), and [HYD-INT-01](4400_HYD_INT_01_ROSS_AGGRESSIVE_HYDRAULICS_TRAPPED_ROD_SIDE_PRESSURE_INTENSIFICATION_AUDIT_2026-10-27.md). Directly searched the full canonical index, research plan and progress for HBH/HBB/ROSS/intensification before selecting this narrow delta.

## Two original ROSS web surfaces inspected 2026-10-29
1. [ROSS HBH series product page](https://www.rosscontrols.com/en/series/1312-hbh), “Product Overview,” “Key Engineering Features,” “Technical Specifications,” and FAQ (web retrieval 2026-10-29). **DOC-CONFIRMED *page assertion*, not certified machine performance:** describes **poppet-type cartridge main blocking elements** with **spool-type solenoid pilots**, near-zero leakage, vertical gravity-load holding following loss of power/supply, and potential **Category 4 / PL e** with properly integrated external monitoring. This is the page relied upon in the 2026-10-26 predecessor.
2. [ROSS document landing page titled HBH Series Operating Instructions RC-HBH-OI](https://www.rosscontrols.com/en/documents/242/block-stop-hbh-series-valve-systems), “Overview,” “Technical Specifications,” “Important Limitations,” FAQ (web retrieval 2026-10-29). **DOC-CONFIRMED *landing-page assertion*, not full PDF inspection:** calls HBH **redundant spool-type**, says **normal spool leakage occurs**, restricts its role to **momentary stop rather than extended holding**, recommends additional pilot-operated check/counterbalance/mechanical locking for long-term hold, and gives **Category 3 / PL d** with conditional higher claims. Its FAQ explicitly says HBH is *not* suitable as the sole extended hold.
3. [ROSS HDBH series product page](https://www.rosscontrols.com/en/series/1313-hdbh) independently describes a *different* redundant spool-type, momentary-stop family with leakage and supplemental hold. **INFERENCE:** possible product-family copy/mapping confusion in the HBH document landing-page text, but that is **not proven**; do not silently reassign its claims to HDBH.
4. The document landing page links an original HBH PDF (`RC-HBH-OI`) and the product page links operating instructions, but the attempted PDF retrieval exposed only a web viewer/inaccessible object; **no complete original manual bytes, hash, printed edition, or drawing were inspected**. Thus it is **UNKNOWN** which page accurately represents the currently orderable HBH variant, whether a revision or catalogue mapping explains the difference, and which certification applies. The conflict cannot be settled by treating the document landing page as if the PDF had been read.

## Adversarial contradiction matrix
| Safety proposition | HBH product page | RC-HBH-OI *landing-page summary* | Engineering status |
|---|---|---|---|
| Main blocking internals | Poppet cartridge; pilot spool | Redundant spool type | **CONFLICT / UNKNOWN** pending exact BOM, actual operating instructions, cross-section |
| Extended vertical load hold | Advertises holding, near-zero leakage | Says momentary stop, normal leakage; additional hold required | **CONFLICT / UNKNOWN**; **DO NOT USE AS SOLE PROOF** |
| Safety integrity | Conditional Cat 4 / PL e statements | Cat 3 / PL d with conditional SIL claims | **CONFLICT / UNKNOWN**; no transfer of PL/SIL to machine |
| Monitored output | Inductive element-position switches with external safety logic | Inductive switches with external monitoring | **DOC-CONFIRMED shared concept**, not pressure/ram witness |
| Maintenance access | No implicit personal LOTO waiver | No implicit personal LOTO waiver | Positive isolation, trapped-pressure verification and independent load support remain separate |

**The safe conservative interpretation is not “HBH definitely leaks” or “HBH definitely holds.”** It is **insufficient documentation for a safety-critical selection**. A position switch does not measure fluid sealing, load drift, cylinder integrity or hose rupture.

## Physical failure path / safe architecture
A designer selects a generic “HBH” from a page, assumes indefinite vertical ram holding, and omits an independent positive support or additional load-hold element. A real variant may differ, a valve may leak, a pilot/check may be bypassed, or a downstream hose/cylinder seal may fail. **INFERENCE:** the load may descend despite healthy valve-position diagnostics. Opposite hazard: if holding oil is trapped, local pressure intensification/thermal rise may remain despite supply gauge zero; see HYD-INT-01. No machine-specific valve truth table or outcome is claimed.

**Minimum evidence to reopen:** (a) exact selected order code and as-built hydraulic topology, (b) immutable complete OEM instructions/catalogue and revision with genuine valve-section schematic and certified safety data, (c) written manufacturer clarification resolving poppet/spool and Cat/PL conflict, (d) each Y1/Y2 independent gravity restraint, downstream hose/cylinder leakage and pressure-zone analysis, (e) qualified isolated/remote physical stop/hold and fault validation with no exposed personnel, (f) distinct maintenance LOTO, mechanical support, deliberate reset/restart. Do not use an unverified internet summary or ordinary LinuxCNC/HAL/FPGA bit as a safety authority.

## Evidence classification / computation
- **DOC-CONFIRMED:** what each manufacturer-hosted webpage *states* and that they contradict. **NOT DOC-CONFIRMED:** a reconciled HBH mechanism, actual certified variant, complete PDF edition, or selected-machine safe holding.
- **INFERENCE:** copy/mapping confusion possibility, hypothetical gravity-drop failure chain and safer procurement workflow.
- **UNKNOWN:** actual installed OpenPressBrake hydraulic elements and selected HBH applicability; full original manual and clarification; stop/hold/pressure performance.
- **SOURCE-CONFIRMED:** predecessor curriculum document assertions and this recorded source correction, not a LinuxCNC implementation finding.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** not used.
- **Compute:** zero hosted, zero self-hosted. No workflow, build, simulation, pressure test, physical machine movement or independent evaluator. This contradiction requires **document clarification before** any question-driven lab.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No personnel-exposed hazardous operation. This exact-OEM conflict is conditional Stage B evidence **only if the selected machine actually uses the relevant valve**, not another owner-facing Stage A appendix.
