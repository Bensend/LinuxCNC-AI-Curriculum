# 4400-HYD-BB-BS-01 — Two redundant hydraulic safety-valve families deliberately choose opposite pressure states
**Original manufacturer comparison | 2026-10-26 | PAPER ONLY / NON-GRADUATED.**

## Original sources inspected
ROSS Controls, *HBB Hydraulic Block & Bleed Valve Systems*, https://www.rosscontrols.com/en/series/1311-hbb, Product Overview and scope paragraph (accessed 2026-10-26). ROSS Controls, *HBH Hydraulic Block & Stop Valve Systems*, https://www.rosscontrols.com/en/series/1312-hbh, Product Overview and certification notes (accessed 2026-10-26). Separate [manual L-O-X](4400_ROSS_HYDRAULIC_LOX_T1_T2_BLEED_VS_CYLINDER_HOLD_ISOLATION_SOURCE_AUDIT_2026-10-26.md). Manufacturer pages describe product families, not selected-machine as-built certification.

## Original 2026-10-26 manufacturer page assertions — HBH later DISPUTED (see correction below)
- **HBB** is a redundant **block-and-bleed** 3/2 spool valve family. When deenergized/faulted, the described function blocks supply and **vents downstream hydraulic energy** to tank. Each valve has inductive position sensing monitored by an **external safety controller**. ROSS explicitly warns that downstream pilot checks, counterbalance valves and closed-center valves can interfere with bleed completeness, and may be beneficial or detrimental depending on the actual required safety function.
- **HBB manufacturer scope restriction:** ROSS states HBB is for **routine, repetitive, production-integral tasks**, while **maintenance requires full lockout/tagout**. A redundant externally monitored HBB does not substitute for personal energy isolation.
- **HBH** was described by the product page as a different redundant **block-and-stop/load-holding** family with poppet cartridge elements and separate spool-type pilot solenoids. **This exact component/holding claim is DISPUTED by the 2026-10-29 source conflict below.** The manufacturer describes blocking fluid flow in both directions and holding a vertical cylinder load on power loss; each valve element has inductive position switches for **external monitoring**. This is a **manufacturer-stated capability**, not evidence that a particular installed ram remains supported after a hose break, cylinder seal leak, manual release or structural failure.
- HBH product page notes its Cat 4/PL e/SIL 3 performance is **conditional on properly integrated safety control**, and **certifications pending on specific models**. Neither product page is an assembled press-brake safety calculation or a certificate for the user's machine.

## Safety-function mismatch
| Safety objective | HBB family claim | HBH family claim | What remains unproven |
|---|---|---|---|
| Block new hydraulic supply | Yes | Yes | Exact installed valve, position and monitoring |
| Remove downstream hydraulic energy | Designed to bleed | Designed to block/hold, not generic bleed | Trapped zones, checks, pilot/return routing |
| Hold vertical gravity load | Bleed may remove supporting pressure | Manufacturer describes load holding | Actual line break, mechanical support, leak, relief, fault |
| Personnel maintenance access | Manufacturer requires full LOTO | No general waiver of LOTO | Positive support, personal locks, verified pressure zones |
| Fault diagnostic evidence | External position monitoring | External position monitoring | Complete risk-derived diagnostic coverage/PL/SIL |
| Fresh restart | Must be designed separately | Must be designed separately | No automatic rearm/motion authority |

## Five adversarial questions
1. What happens if the HBB bleeds a chamber that was the only restraint for a gravity load? **INFERENCE:** potential descent; cannot assign an outcome without as-built topology.
2. What happens if a downstream check blocks HBB bleed? **DOC-CONFIRMED** manufacturer warns this can prevent complete energy removal; actual trapped volume UNKNOWN.
3. What happens if HBH holds pressure but maintenance needs zero energy? Independent restraint and separate qualified pressure release must be designed; no assumed safe release path.
4. Does a valve-position sensor prove cylinder movement impossible? No; only its monitored element, with external logic and physical path still requiring proof.
5. Does an OEM marketing claim for PL e establish the press brake's PL e? No; exact integration, variant certificate, CCF/DC and physical validation are absent.

## Low-friction architecture and hard boundary
Write the SRS **before** selecting block-and-bleed versus block-and-stop. Make the correct safety mode obvious to a technician: PROTECTIVE STOP / LOAD HELD / PRESSURE RETAINED / MAINTENANCE ISOLATED are different. Make personal LOTO and positive load support accessible and quick. Avoid hidden manual bypass, long guard removal or reliance on LinuxCNC/FPGA to substitute for independent safety logic.

**Evidence:** DOC-CONFIRMED exact ROSS HBB/HBH product descriptions and HBB maintenance limitation; INFERENCE application fault matrix; SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none; UNKNOWN selected OpenPressBrake actual valves, PL/SIL, stopping/holding/pressure zones and physical validation. No physical tests or compute. **G0/G1 HOLD; no personnel-exposed operation.**
## 2026-10-29 safety-critical source correction — HBH claim DISPUTED
**Do not read the 2026-10-26 HBH poppet/vertical-load-hold paragraph as an accepted valve-selection or physical-holding fact.** The [new direct ROSS page-conflict audit](4400_HBH_CONFLICT_01_ROSS_HBH_PRODUCT_VS_OPERATING_INSTRUCTIONS_LANDING_PAGE_STOP_HOLD_LEAKAGE_AUDIT_2026-10-29.md) found that ROSS's HBH product page describes poppet blocking, near-zero leakage and gravity holding, but ROSS's *HBH RC-HBH-OI document landing page* describes spool valves, normal leakage, momentary stopping only, supplemental hold and a different Cat/PL. The full original operating-instructions PDF was not inspected. **DOC-CONFIRMED conflict between two manufacturer-hosted web assertions; actual variant, internals, long-term holding and integrity UNKNOWN.** The earlier table's HBH load-hold entries must be read as **unverified conflicting manufacturer claims**, not design acceptance. Request exact part suffix, immutable original instructions and written OEM reconciliation before safety allocation. Do not generalize HDBH to HBH or reverse. G0/G1 HOLD.
