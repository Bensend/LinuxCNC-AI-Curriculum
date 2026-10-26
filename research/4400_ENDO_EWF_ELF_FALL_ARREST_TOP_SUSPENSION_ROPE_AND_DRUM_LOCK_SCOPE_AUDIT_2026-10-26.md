# 4400-MECH-01A — A "fall-arrest" label does not identify every broken mechanical link

**2026-10-26 | Original manufacturer-source investigation | NON-GRADUATED | documentary only.** No claim that the inspected products are installed on OpenPressBrake. No machine test, no numerical press-brake safety rating.

## Frozen question and scope
Does a spring balancer's integrated fall-arrest device, secondary suspension chain, and drum lock protect the *same* failure, and does any one prove that a suspended tool is safe for personnel access? Inspect the original English portion of ENDO KOGYO **BMU-0002, issued June 2021**, covering EWF-9…120 and ELF-15…70. Compare one distinct manufacturer product where rope-break protection is explicitly claimed.

**Primary source:** [ENDO BMU-0002 bilingual 32-page operating manual](https://endo-kogyo.co.jp/pdfs/ja/spring_balancer/standard_spring_balancer/instruction/001_JP_EN_User_BMU-0002.pdf) (English pp. 22–30, PDF pp. 21–29), and [ENDO support](https://www.endo-kogyo.co.jp/english/product/balancer/support.html). **Contrast:** [CMCO/Yale YBA/YBA-L manufacturer's product description](https://www.cmco.com/en-sg/products/rigging-equipment/below-the-hook/spring-tensioners/yba-and-yba-l-spring-balancers/).

## Original OEM observations (DOC-CONFIRMED)
| Mechanism | ENDO evidence | Narrow legitimate claim | Not established |
|---|---|---|---|
| Internal fall-arrest pin | BMU-0002 §4-3-2, English p.22 (PDF p.22): spring rupture activates pin and arrests drum rotation | A stated **spring-rupture** response within the specified balancer family | Wire-rope/terminal/bottom-hook rupture, entire tool support path, press-brake beam |
| Auxiliary top suspension rope/chain | §5-2-1, English pp.24–25: independent hanger, OEM-specified strength >=10x balancer maximum capacity and slack to limit body fall to 100 mm | A **top-hook/support** failure backup for this ENDO installation | Tool-rope break or bottom-hook failure; 10x/100mm are NOT general machine standards |
| Drum lock | §4-3-3, §6-3 and §6-4-3: intended for tool removal/replacement; confirm lock; different tool mass prohibited for lock-based replacement | Limited OEM **service-operation** drum restraint when correctly engaged | General-purpose personal energy isolation, safe access beneath load, all component failures |
| Wire rope, bottom hook, latches | §6-1, English p.27: inspect wear, broken strands, terminal, hooks and latches; §6-2 prohibits being directly beneath suspended tool | Inspections and exclusion remain necessary despite internal fall-arrest | No explicit all-fault cable/bottom-hook arrest guarantee |
| Release of internal arrest | §7-2, English p.30: release procedure conditional on tension/fault | A reset/recovery procedure exists and can reintroduce motion | Automatic authorization to work beneath the load |

**Important internal-document ambiguity:** §4-3-2 first describes preventing a spring-rupture-induced fall, then cautions that the device is **not designed to prevent tools from falling**. Do not silently resolve the contradiction. Conservative reading: the named device has a *specific* spring-rupture/drum mechanism; it does **not** prove comprehensive tool retention. Exact translation intent is **UNKNOWN**; obtain OEM clarification before any broader safety claim. This is not a fabricated contradiction or a numerical performance conclusion.

**Distinct counterexample:** CMCO/Yale YBA/YBA-L describes an **additional mechanism** to lock the rope if the suspended weight is lost, bottom hook breaks or rope breaks. **DOC-CONFIRMED for the described YBA family only**. **Critical scope discriminator:** CMCO explicitly says the rope-lock mechanism prevents **rope whipping** after a rope/bottom-hook break; if the load has become mechanically detached, this statement does **not** establish that the tool remains suspended. Rope-whip suppression and retained-tool protection are different physical propositions. The contrast demonstrates that similarly named spring balancers can address *different mechanical fault sets*. It does not prove any assembled machine safe.

## Failure-path decomposition (INFERENCE, not test results)
- **F1 spring breaks, tool cable intact:** ENDO internal drum arrest is the described path; inspect exact model and mechanical condition.
- **F2 top hook/hanger breaks, main rope intact:** ENDO auxiliary suspension is the described path; independence of its anchor is crucial.
- **F3 tool wire rope/termination/bottom hook breaks:** the ENDO internal drum and top-body backup do **not** by their documented mechanisms establish a retained tool. The exact tool-fall outcome is **UNKNOWN**, not TEST-CONFIRMED.
- **F4 lock releases or spring tension changes during tool swap:** §6-3 explicitly warns of rapid retraction or falling tool; "drum locked" is not a blanket maintenance-safe proposition.
- **F5 someone reaches beneath suspended tool:** manufacturer explicitly prohibits this even with its safety features. Do not treat a control-state signal as a physical exclusion witness.

## Engineering implications
Map every possible fall path separately: fixed support -> primary top hook -> balancer body -> drum/spring -> rope/termination -> bottom hook -> actual load. For each proposed secondary path, identify **which broken link it bridges**, its independent anchor, rated load and installation/inspection method. An auxiliary rope connected to the same failing hanger can be a common-cause defect; a cable-only arrest does not address a falling balancer body. This is an **INFERENCE**-based fault-tree method.

Low-friction improvement: make an OEM-approved auxiliary suspension captive, make hooks/latches visible for inspection, keep tool exchange at a supported accessible height, provide a reachable maintenance stop/fixture and clearly label that the device is **not** personnel protection beneath the suspended load. Do not retrofit an improvised load-bearing cable or change spring tension without selected OEM instructions and qualified review.

## Evidence ledger and boundaries
- **DOC-CONFIRMED:** exact ENDO sections above; CMCO YBA product description. ENDO manual issue 2021-06.
- **SOURCE-CONFIRMED:** none (not LinuxCNC implementation research).
- **TEST-CONFIRMED:** none; no physical or laboratory experiment.
- **COMMUNITY-REPORTED:** none relied on.
- **INFERENCE:** independent fault paths, failure-coverage comparison, human-factors design pattern.
- **UNKNOWN:** ENDO wording resolution; installed OpenPressBrake counterbalancer, cable, gas spring, guard support, exact rated support/anchor, physical Y1/Y2 hold, independent evaluation.

**Next evidence:** selected-machine inventory before any applicable test. If none installed, record qualified N/A; do not extrapolate to press-brake hydraulic ram. **G0/G1 HOLD; no personnel-exposed operation authorized.**
