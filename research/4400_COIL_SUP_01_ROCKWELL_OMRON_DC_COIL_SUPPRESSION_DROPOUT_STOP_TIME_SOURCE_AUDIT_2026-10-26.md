# COIL-SUP-01 — Coil surge suppression can lengthen the safety stop chain
**4400 safety-course source audit; 2026-10-26; NON-GRADUATED.** This is a new output-stage timing/architecture lesson, not a design for any installed OpenPressBrake component. Do not substitute it for selected-machine stop-time measurement.

## Original manufacturer sources inspected
1. **Rockwell Automation, Machinery Safebook 5**, chapter 4, printed p.54 (PDF p.55), official original https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/safebk-rm002_-en-p.pdf . Manufacturer explicitly identifies control-relay/contactor dropout as a contributor to safety-distance calculation and states that DC coil suppression increases dropout time, with the change depending on suppression type. The book is a *historical* implementation guide (cites ISO 13849-1:2008); it is **not** the current normative standard text.
2. **OMRON Industrial Automation, Safety Precautions of Safety Relays**, §§3-(1)-4, 3-(2)-5, official https://www.ia.omron.com/product/cautions/16/safety_precautions.html . Diode, diode-plus-Zener, varistor and CR suppression have different release behavior. Manufacturer explicitly warns that installed surge absorbers lengthen relay release time and requires actual-circuit checking. A diode-plus-Zener can shorten release relative to a plain diode; it is **not** automatically approved for any safety output.
3. **OMRON, FAQ02129**, original https://www.ia.omron.com/support/faq/answer/18/faq02129/ . For inductive DC loads such as solenoid valves, suppression protects switching electronics but a diode increases solenoid release time; a series Zener arrangement can shorten it subject to device ratings.
4. **Schneider Electric TeSys K contactor accessories**, official https://www.productinfo.schneider-electric.com/nadigest/5c51d645347bdf0001f1f280/Master/17718_MAIN%20%28bookmap%29_0000058904.xml/%24/_17718027_60720 . Manufacturer lists *different* clip-on varistor and diode-plus-Zener suppression accessories, including LA4KE1B versus LA4KC1B for relevant voltage ranges. Catalog listing is **not** a measured timing comparison or proof of safety suitability.

## Evidence ledger
| Claim | Evidence label | Boundary |
|---|---|---|
| Switching an inductive DC coil produces back EMF that can damage outputs; protection may be required | DOC-CONFIRMED OMRON | Does not authorize an arbitrary suppression circuit |
| Suppression topology changes DC coil/contactor or valve release behavior | DOC-CONFIRMED Rockwell and OMRON | Exact release time and scatter are UNKNOWN for a selected coil |
| Rockwell states AC-coil dropout is not affected in the context of its Safebook comparison | DOC-CONFIRMED *scoped quotation* | Not a universal AC suppression guarantee or a selected-device test |
| A safety controller can withdraw its output while a suppressed downstream DC coil still holds its armature for a finite interval | INFERENCE from documented physical mechanism | Neither output-OFF nor coil-voltage-OFF proves final contact/spool state |
| The changed coil release may affect actual hazardous stop distance | INFERENCE consistent with Rockwell stop-time discussion | No numerical distance/time/PL/SIL can be assigned here |
| Selected OpenPressBrake coil, suppressor, valve spool, hydraulic stop and gravity hold | UNKNOWN | G0/G1 HOLD |

## Time-chain and authority trace (symbolic, not a numerical design)
Protective demand -> qualified independent safety input/logic -> safety output changes -> **output driver/suppression and coil current decay** -> contactor armature or valve actuator release -> final electrical/hydraulic energy path changes -> physical motion decelerates/stops -> gravity load remains supported. An EDM auxiliary contact can report supported contactor state, but **cannot** by itself prove hydraulic spool, pressure isolation, Y1/Y2 stopping or load support. A normal LinuxCNC/FPGA pin is only a diagnostic or ordinary motion-inhibit signal.

For any selected design, review the *actual* worst-case end-to-end stop-time and physical holding proof using the applicable edition of the relevant standard and qualified evidence. Do not add example milliseconds from another device to an imaginary press-brake stopping distance.

## Adversarial failure paths
1. A technician replaces a failed DC-coil suppressor with a plain diode: reduced EMI may coexist with **slower** contactor/valve release. Prior stopping evidence becomes STALE.
2. A suppressor is removed to accelerate release: higher transient voltage may damage the safety output or cause unintended behavior. Faster theoretical release is not a safe shortcut.
3. A safety relay goes OFF; an HMI immediately paints a green STOP icon: the icon proves only the reporting chain, not the contactor/spool/ram.
4. A safety contactor's NC auxiliary changes state: use it only as the **qualified contactor feedback proposition**, not as physical beam support.
5. A solenoid-operated hydraulic valve returns under spring force: the manufacturer model's spool, hydraulic circuit, pressure and gravity holding remain separate UNKNOWNs.
6. A replacement valve plug contains a built-in LED/suppressor while the prior plug did not: inspect exact part, polarity, leakage, supply and wiring; revalidate affected stop function.
7. A controller output transistor is protected but a common 0 V/24 V or connector fault defeats multiple paths: review common-cause dependencies and feedback coverage.
8. A design assumes an AC coil will always be unaffected by suppression: reject cross-product extrapolation from Rockwell's general guide.

## Practical implementation and human factors
Use an **OEM-matched, documented** coil/suppression assembly and connector; label exact replacement part and polarity; keep service spares unambiguous. Require change-control when a plug, diode, relay, valve, coil supply, output module or wire route changes. Make correct replacement easier than improvised field diode soldering. Plan accessible qualified test points and observable independent physical witness without requiring a technician to defeat a guard.

**No SOURCE-CONFIRMED new LinuxCNC claim, TEST-CONFIRMED result or COMMUNITY-REPORTED claim.** Documentary gates and scenarios live in [COIL-SUP-01 field module](../safety-course/4400_COIL_SUP_01_SAFETY_OUTPUT_COIL_SUPPRESSION_AND_STOP_TIME_FIELD_MODULE_2026-10-26.md). G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; no personnel-exposed hazardous operation.
