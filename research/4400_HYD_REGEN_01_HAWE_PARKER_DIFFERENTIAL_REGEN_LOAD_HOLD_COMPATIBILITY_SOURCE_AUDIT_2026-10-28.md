# 4400 HYD-REGEN-01 — Hydraulic differential regeneration is a different load path, not a safe-speed or holding function
**Session:** 2026-10-28T08:31:37.518Z | **Status:** original manufacturer documentary source audit, NON-GRADUATED. No selected-machine hydraulic circuit or physical test.

## Question and predecessor novelty gate
Can a fast-approach regenerative circuit alter the actual pressure, force, speed and load-holding compatibility even though the ordinary controller reports a low-speed or stop command? **Yes, conditionally; the exact circuit and valve variant control the answer.** The canonical safety index and research plan were inspected directly. HYD-INT-01 already teaches rod-side pressure intensification from a blocked return; SET-FLUID-01 already distinguishes ordinary slow jog from safety-reduced speed; HYD-HOLD-01 and CP-01..06 already teach pilot/relief/hold dependencies; DCB-01's *electrical* regeneration is unrelated. **Increment here:** directly documented *hydraulic cross-port regeneration*, a specific load-holding-valve incompatibility, and a selectable high-speed/high-force fluid path. This is not a rediscovery of those earlier mechanisms.

## Directly inspected original sources and evidence
| ID | Class | Exact evidence | Scope / rejected transfer |
|---|---|---|---|
| REGEN-01 | **DOC-CONFIRMED** | HAWE Hydraulik, [Fluidlexikon: Regenerative circuit](https://www.hawe.com/en-us/fluid-lexicon/detail/regenerative-circuit/), inspected 2026-10-28: rod-side discharge is routed into the piston side of a differential cylinder to increase extension speed, at reduced net force. | General fluid principle, not evidence that OpenPressBrake uses this topology. |
| REGEN-02 | **DOC-CONFIRMED** | HAWE, [Load-holding valve LHDV, D 7770, 08-2024 rev 1.0](https://productfinder.hawe.com/downloads/D7770-en.pdf), printed **p. 17/41**, §3.4 NOTICE, original page image inspected: twin circuit symbols **-21/-25 must not be combined with a directional spool having a differential-circuit flow diagram in *any* switching position**; single symbols **-11/-15 cannot be used on the cylinder rod side in that configuration**. | This is an **LHDV family/variant-specific restriction**, NOT a universal prohibition on all load-holding valves or all regenerative circuits. |
| REGEN-03 | **DOC-CONFIRMED** | Same D 7770, printed **p. 24/41**, SAE-11 assembly notice: when using a differential circuit with a corresponding valve, its T connection must be connected to tank; additional conditions apply to T in certain variants. | Do not conflate SAE-11 exception/port condition with the -21/-25 ban. Exact SKU, symbol and port map matter. |
| REGEN-04 | **DOC-CONFIRMED** | Parker Hannifin, [Energy Efficiency in Hydraulics, Bulletin HY11-3338/UK 04/2009](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Controls-Europe/Brochures/HY11-3338UK_Energy-efficiency-HMI09.pdf), printed pp. 6–7, original p.7 image inspected: P-return regenerative examples have limits on arresting pulling loads and can intensify rod-side pressure, potentially to twice pump pressure **in the described arrangement**. | The article's pressure example is **not** a selected-machine pressure estimate, pressure rating or generic regenerative multiplier. |
| REGEN-05 | **DOC-CONFIRMED** | Parker, [Directional Control Valves D111VW, D111VWR and D111VWZ, catalog MSG14-2500/US](https://www.parker.com/content/dam/Parker-com/Literature/Hydraulic-Valve-Division/hydraulicvalve/Catalog-sections-for-websphere/Industrial-Directional-Control/Catalog---Static-Files/D111VW.pdf), printed **A259**, original page image inspected: D111VWR regenerative and D111VWZ switchable hybrid; hybrid diagram explicitly labels regenerative cylinder extension **high speed** versus standard extension **high force**. | Catalog is undated on the inspected pages; do not invent edition year or assume the illustrated valve is installed. |

## Causal model (INFERENCE, not an as-built hydraulic truth table)
A differential cylinder has full-bore area A_cap and annular area A_ann; A_cap > A_ann. In a simplified ideal equal-pressure regenerative extension, effective pressure area is A_cap - A_ann (rod cross-sectional area), while rod-side outflow is recirculated to the cap side. The same pump flow can therefore produce faster extension and lower available thrust than a standard extend path. This is a **conceptual** continuity/force balance; inertia, gravity, leakage, port restrictions, valve overlap, backpressure, cylinder geometry, control and actual plumbing are not known.

- **Normal fast approach:** an intentional regeneration path can change actual flow/speed without a corresponding increase in pump flow. A LinuxCNC velocity setting or proportional-current request does not establish a safety-rated physical limit.
- **Mode-transition fault:** if the actual regenerative-to-standard valve/connection does not follow the ordinary transition command, actual speed/force and pressure zones may differ from the HMI. This is a *possible fault to investigate*, not an asserted machine failure.
- **Stop/holding fault:** a cross-port recirculation path or wrong load-holding valve variant can invalidate a presumed blocked-chamber state. Pump-off, zero command or a generic check-valve icon cannot establish gravity holding.
- **Pressure/witness fault:** rod-side pressure can differ materially from the pump gauge; Parker's described P-return throttling can intensify it. The actual maximum and test-point placement require circuit-specific engineering, not copying the OEM example.
- **Replacement/maintenance fault:** a valve with a similar body/port size but different -21/-25/-11/-15 symbol, pilot/drain or T-port configuration may be incompatible. Treat such substitution as **CHG/STale** and requalify the affected hydraulic safety claims.

## Conditional selected-machine witness (all UNKNOWN / NOT RUN)
| Trace | Needed from qualified private custodian | Wrong shortcut |
|---|---|---|
| **DEP-REGEN-01** | As-built hydraulic schematic, cylinder geometry, all cross-port/check/regen paths, actual valve symbols and part numbers | Generic press-brake schematic or catalog picture |
| **ARC-REGEN-02** | Identify ordinary high-speed/high-force commands versus independent safety-related stop, physical load-holding and energy-removal final elements | LinuxCNC/FPGA command=0 or a low-jog setting |
| **FLT-REGEN-03** | Fault paths for stuck regeneration, cross-port leakage, missing pilot/drain and pressure/flow surge; justify coverage and common causes | One valve-ready bit |
| **PHY-REGEN-04** | Independent stop, motion/overspeed, gravity hold, local pressure-zone, guarding and deliberate rearm witness under qualified isolated/remote test plan | Pump gauge or untested OEM number |
| **CHG-REGEN-05** | Approved variant, installation, maintenance and configuration baseline with revalidation on substitution | Thread fit, similar SKU or successful startup |

**Boundary:** No selected OpenPressBrake regenerative circuit, HAWE LHDV or Parker D111VWR/Z is asserted. No PL/SIL, pressure threshold, speed, stop time, hydraulic truth table, physical test or personnel-exposed release. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No hosted or local compute.

## Practical human factors
The safe path is a legible **one-page valve/port/flow-state map** attached to the approved as-built service packet, labeled approved replacements, and readily accessible external measurement points designed by a qualified team. A confusing generic “regen OFF” label or service drawing that omits the return/pilot path encourages wrong replacements and makes a false safety claim easier. Do not add improvised test hoses or bypass a hold valve to prove the concept.

## Independent adversarial source-scope review (desk-only; not competency score)
- Claim “all regenerative circuits are unsafe”: **REJECTED**; OEMs sell regenerative and hybrid valves; safety depends on the integrated architecture.
- Claim “HAWE forbids all load-holding valves with regeneration”: **REJECTED**; its notice names LHDV symbols and configurations; another SAE-11 port note is conditional.
- Claim “Parker says rod pressure is twice pump pressure on OpenPressBrake”: **REJECTED**; the figure is an example in a particular P-return arrangement.
- Claim “pump off or LinuxCNC low jog proves gravity holding”: **REJECTED**; independent physical proof remains required.

**Information-gain stop:** selected-machine topology and validation cannot be inferred from public examples. Return to restricted Stage A IN-03/04/06/07/08/10 and independent evaluator; otherwise another nonduplicative safety source branch.
