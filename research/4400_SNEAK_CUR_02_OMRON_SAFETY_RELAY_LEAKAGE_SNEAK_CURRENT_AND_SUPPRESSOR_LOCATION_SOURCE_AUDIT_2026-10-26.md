# SNEAK-CUR-02 — OFF command, leakage and unintended coil-holding paths
**4400 safety-course source audit; 2026-10-26; NON-GRADUATED.** Distinct from COIL-SUP-01 *dropout timing*: this branch asks whether a load can remain or become energized through **an unintended circuit path**, including suppression placement and shared return wiring.

## Direct manufacturer documentation
- **OMRON, Safety Precautions of Safety Relays**, original https://www.ia.omron.com/product/cautions/16/safety_precautions.html :
  - §3-(1)-4: a CR network across **open contacts** can allow current through an inductive load, with circuit-specific effects; manufacturer cautions against two capacitor arrangements that can increase contact-welding risk. The exact diagrams/connection points matter.
  - §3-(2)-6: explicitly warns **not to allow leakage current to flow to relay coils** and provides corrective examples.
  - §3-(2)-8: documents a **sneak-current series path** through multiple coils after switching contacts, potentially preventing release. This is an actual manufacturer-described circuit phenomenon, not a hypothetical OpenPressBrake fault.
  - §3-(2)-5: suppressor selection and coil release are separate concerns; a protection part is not a permission to bypass safe-state validation.
- **OMRON, General Purpose Relay Safety Precautions**, original https://www.ia.omron.com/product/cautions/36/safety_precautions.html : independently describes CR, diode, diode-plus-Zener and varistor tradeoffs and warns about contact-welding and release effects.
- **Rockwell Automation, Machinery Safebook 5**, printed p.54, https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/safebk-rm002_-en-p.pdf : mechanically linked/mirror contacts can provide specified contactor diagnostic feedback, but coil release time and final physical stopping are distinct propositions.

## Evidence ledger
| Proposition | Label | Limitation |
|---|---|---|
| A contact-bypass CR path may carry current while the mechanical contact is open | DOC-CONFIRMED OMRON | Current magnitude and effect on any selected load UNKNOWN |
| Multi-coil shared circuit can create sneak current after contacts open | DOC-CONFIRMED OMRON | Not evidence of an OpenPressBrake wiring defect |
| Leakage/sneak current can delay or prevent a relay releasing under some wiring/load conditions | DOC-CONFIRMED OMRON | Whether a selected coil remains held requires exact circuit analysis/qualified verification |
| OFF status of normal PLC/HAL output does not exclude a separate unintended energizing path | INFERENCE | Must inspect **both** supply and return, suppression, parallel indicators, auxiliary power |
| A coil remaining energized implies a specific hydraulic spool or physical ram motion | **NOT ESTABLISHED** | Exact valve, fluid paths, mechanical load and feedback UNKNOWN |

## Counterexample: logical OFF is not an electrical isolation proof
Imagine a coil K driven by a nominally open output contact. A parallel suppression/indicator path, cross-feed through another coil or shared return may supply residual current. **Do not claim the current is sufficient to hold K** until the exact topology, voltage, coil pickup/dropout limits, temperature, transient response and fault assumptions are documented. Conversely, a multimeter reading some voltage on a high-impedance input is not proof of dangerous delivered power. A green diagnostic and a measured open contact each answer only their own propositions.

## Failure-path and design-review matrix
1. Two coils share a return and one contact opens: inspect for a series sneak-current path, not just the open switch.
2. An electrician moves a snubber from **across the load** to **across the contact**: changed leakage, stored charge and switching stress invalidate previous assumptions.
3. A plug-in suppressor includes an indicator LED or polarity element: require exact schematic; visual LED state is not coil-current or valve-position proof.
4. A safety relay's contact welds: mechanically linked feedback may detect some failures but cannot by itself guarantee power interruption; review redundancy and final elements.
5. A shared supply is restored with a held pedal: independent fresh start and safe-state checks required; no automatic rearm.
6. A fault monitor sees an OFF command but no release: use qualified, isolated diagnostics to discriminate supply/return cross-feed, welded contact, coil current and physical actuator.
7. A retrofit adds a convenience lamp to a safety output: treat its possible current path as a change-control event.
8. A safety controller and ordinary FPGA share a pilot supply/0 V: analyze common-cause and fault injection without promoting the FPGA to safety authority.

## Low-friction safer architecture
Prefer manufacturer-validated final-element wiring with **separately documented coil suppression**, clear supply/return boundaries, compatible output load ratings, monitored feedback where appropriate, readable terminal/connector labels and a simple replacement checklist. Protect wiring from moisture/swarf and use captive labeled plug assemblies so the correct repair is easier than a bypass. Never prescribe a bleeder resistor, shunt, coil topology or numeric leakage threshold without the selected manufacturer's requirements and qualified design analysis.

## Explicit machine evidence gaps
Selected as-built OpenPressBrake wiring, coil identity, output module, suppressor placement, actual leakage, pilot/return paths, safety controller, contactor/valve feedback, physical Y1/Y2 stop and gravity hold, hydraulic isolation, PL/SIL and restart remain **UNKNOWN**. G0/G1 HOLD. No live circuit, physical or computational test authorized.

[Companion paper module](../safety-course/4400_SNEAK_CUR_02_LEAKAGE_BACKFEED_AND_FRESH_RESTART_FIELD_MODULE_2026-10-26.md). **No new SOURCE-CONFIRMED LinuxCNC, TEST-CONFIRMED or COMMUNITY-REPORTED evidence.**

## Independent original manufacturer example: an OFF solid-state safety output is not ideal zero leakage
**Banner Engineering, historical Safety Modules catalog**, original manufacturer PDF https://info.bannerengineering.com/cs/groups/public/documents/literature/73850_04.pdf , printed pp.124 and 126 (PDF pp.20 and 22), direct document examined 2026-10-26. For **MM-TA-12B** and **MM2-TA-12B** product entries the catalog specifies **maximum OSSD leakage 1.2 mA, inclusive of faults such as open 0 V**, and **OFF-state voltage 1.2 V max**; also specifies output test pulses and a maximum load capacitance. **DOC-CONFIRMED for these historical catalog entries only.** This is an inspectable counterexample to the idealization `OFF = literally zero output current`. It is **not** evidence that 1.2 mA is present, dangerous, harmless, or permitted for any OpenPressBrake output/coil; nor is the historical catalog a current product-selection standard. The selected output/load compatibility, diagnostic pulses, wiring and actual physical final-element response remain UNKNOWN. The catalog's two product entries have different test-pulse period wording; do not transfer timing across variants without the exact current manual.

## Predecessor reconciliation — leakage and sneak current were already taught
The canonical index already links [OMRON/Schneider SUPPRESS-01](4400_OMRON_SAFETY_RELAY_DIODE_SUPPRESSION_RELEASE_DELAY_AND_SNEAK_CURRENT_OEM_AUDIT_2026-10-26.md), [Rockwell IntelliVAC LEAK-01](4400_ROCKWELL_INTELLIVAC_OFF_STATE_LEAKAGE_SNUBBER_POWER_UP_AND_DELAY_OEM_AUDIT_2026-10-26.md), and [PointMax SA+ crossfeed](4400_ROCKWELL_POINTMAX_SAFETY_OUTPUT_SA_BACKFEED_DETECTED_NOT_SAFE_OEM_AUDIT_2026-10-25.md). These already cover contact-bypass current, series sneak paths and OFF-command ambiguity. This artifact's distinct evidence is the directly inspected **historical Banner MM-TA/MM2-TA OFF-state leakage rating** and the integrated three-way failure-path/physical-witness distinction, **not** discovery of a new failure mechanism. [Full overlap/method reconciliation](4400_SAFETY_SOURCE_OVERLAP_RECONCILIATION_AND_NOVELTY_CHECK_METHOD_2026-10-26.md).
