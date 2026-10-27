# 4400-MAGCHUCK-01 — Magnetic workholding: power loss versus actual part retention

**Study date:** 2026-10-27 UTC. **Status:** NON-GRADUATED documentary source audit; conditional to actual grinding/milling/turning magnetic workholding, not an OpenPressBrake installation claim.

## Novelty and predecessor check

Direct full canonical 978-line safety index inspection found no `magnetic chuck`, `magnetic workholding`, or grinding-workpiece pole/contact-area lesson. Existing `VAC-01` covers vacuum workholding, `MAG-01` covers ferromagnetic guard switches, `TOOL` covers tool retention, and the new `ABRASIVE-01` covers wheel burst. **This is a distinct workpiece-ejection and retention mechanism**, not a generic 'power off means safe' lesson.

## Original sources

| Source | Directly verified fact | Scope boundary |
|---|---|---|
| HSE *Safety in the use of abrasive wheels*, HSG17 third edition 2000, **original 53-page PDF directly read**, printed p.16 ¶44: https://www.hse.gov.uk/pubns/priced/hsg17.pdf | **DOC-CONFIRMED:** permanent magnetic tables do not require power; actual holding depends on workpiece material, surface, contact area; stops/fixtures and substantial table guards address ejection. | UK guidance, not an installed machine holding test. |
| Walker Magnetics / Industrial Magnetics **NEOMAX Permanent Magnetic Grinding Chuck**, manual **900627**, ©2021, **original 8-page PDF directly read**, printed pp.2–4: https://assets.magnetics.com/assets/files/manuals/900627_Neomax_C2_Chuck_Manual.pdf | **DOC-CONFIRMED exact product:** manually switched permanent magnet needs no external supply during hold; parts must bridge poles, contact area/thickness/roughness/rust and material affect holding. Manual warns finger crush from magnetic attraction, inadequate grip with one-pole narrow workpieces, and need to check stability and guards. | Does not establish a holding force for any selected part; manual performance table is product-specific and not copied as a universal rating. |
| Walmag **Grindmaster electro-permanent grinding chuck**, manufacturer product page, **directly read 2026-10-27**: https://www.walmagmagnetics.com/products/electro-permanent-magnetic-chuck-for-grinding-grindmaster | **DOC-CONFIRMED exact product architecture:** pulse-to-magnetize/demagnetize; permanent magnets hold after pulse and during loss of electrical power. Page explicitly distinguishes powered electromagnetic vs electro-permanent vs manual permanent systems. | Walmag's marketing '100% work safety' is **NOT** a machine safety-function certification or proof of actual part retention. Catalog 'up to' surface holding force is not a part-specific shear/ejection rating. |
| Existing `VAC-01` and `ABRASIVE-01` learner routes | Vacuum reserve, wheel burst and magnetic workholding are **separate** physical propositions. | No direct selected-machine combination or common-cause test. |

## Three distinct magnetic technologies — not interchangeable

1. **Permanent, mechanically switched:** field may persist without electricity; ON/OFF actuator state and pole contact geometry matter.
2. **Powered electromagnetic:** field depends on energized coils (unless separately supported by a selected backup architecture); power-loss behavior must be established for exact product.
3. **Electro-permanent:** a short pulse changes magnetic state, which can persist without supply. **Loss of power does not necessarily release the part**, but neither does persistent magnetization prove the part is adequately held against machining forces.

## Failure paths and authority

- **Normal CNC/PLC:** magnet ON command, feedback, spindle enable, HMI 'clamped' and part-program start are normal process signals unless a selected safety-related architecture is justified. **INFERENCE:** none independently proves the actual contact area, material permeability, machining shear load, or retained physical part.
- **Physical hold:** pole bridging, actual part material, thickness, flatness, rust/burr/air gap, location on chuck, fixture/stops, machining force vector and protective ejection enclosure must be evaluated. A nominal maximum normal pull force is not automatically the shear force available under grinding or milling.
- **Power failure:** permanent/electro-permanent may continue holding; conventional electromagnetic may lose hold without adequate backup. This is architecture-dependent. **'Power OFF = released' and 'power OFF = safely held' are both invalid universal rules.**
- **Maintenance:** finger-crush/pinch hazard can persist after electrical isolation when permanent magnetic force remains. Mechanical handling and safe demagnetization must follow exact product instructions. A CNC E-stop is not proof that a permanent magnetic field is gone.
- **Operator behavior:** avoid a workflow where small or awkward workpieces tempt operators to skip pole extensions, stops or guards. Make correct fixtures easy to select and identify; reject unsafe setups rather than encouraging manual handholding.

## Adversarial claim table

| Tempting claim | Why it fails | Needed independent witness |
|---|---|---|
| 'Walmag says 100% safe during outage.' | Manufacturer describes magnetic state, not all possible loads, surfaces, contact or ejection trajectories. | Exact selected part/fixture holding and ejection risk evidence. |
| 'The magnet remains ON with power removed.' | Does not prove adequate force for small/hardened/rusty workpiece or safe maintenance access. | Actual material, pole coverage, surface and load case. |
| 'A small part sits on one pole.' | Walker explicitly warns poor holding when narrow parts contact only one pole. | Qualified pole-extension/fixture and load validation. |
| 'HMI clamped bit is green.' | Command/status does not prove physical magnetic force or workpiece contact. | Independent selected physical/functional witness. |
| 'E-stop removes power so hand can enter.' | Permanent field and attraction/crush may persist. | Exact magnetic release, safe part support, motion/energy isolation. |
| 'Same chuck holds different alloy.' | Magnetic properties vary, especially hardened/alloy steels. | Material-specific qualification and physical proof. |

## Cross-machine and no-lab decision

Useful for grinders, mills, lathes and robotic loading **only if installed**; not evidence OpenPressBrake uses magnetic workholding. This is a distinct branch from the closed 3000 tracks. General mechanisms are adequately source-established; remaining questions require exact hardware, part geometry, force directions and qualified physical proof. **No energized machining, deliberate drop/ejection, magnet crush or hazardous test** is justified. No performance level, force threshold, safety rating or stopping limit invented. Selected `PHY/VAL/PT` UNKNOWN/NOT RUN; no external score or compute. G0/G1 HOLD for OpenPressBrake.
