# 4400 — OEM optional guarding, mute-state, auxiliary plug and hydraulic add-on source audit
**Original 2026-10-23 documentary continuation | no selected-machine configuration, live test or personnel-safety authorization.**

## Why this branch matters
A press-brake safety design may be altered by **installed options and software-selectable production steps**, not merely by replacing a valve or guard. An official OEM manual shows a presence-sensing mute position, step-selectable footswitches, a removable auxiliary-interface plug, and additional hydraulic actuators. None of these is a generic safety architecture for LinuxCNC; together they expose the danger of treating a machine model name or green HMI indicator as a complete safety configuration.

## Primary source and scope
Cincinnati Incorporated, *90–350 PROFORM+ Hydraulic Press Brake*, EM-560 (N-06-14), copyright 2013, manufacturer PDF: https://wwwassets.e-ci.com/PDF/Preinstallation/Press-Brakes/em-560-n-06-14-osmm-90-350-proform-plus.pdf . Directly inspected printed **1-1/1-2, 6-1, 8-1, 8-4, 8-5, 8-6, 9-1** (PDF pp. 6–8, 40–41, 46, 49–50, 52). This is a 2014-era historical manual, **not** evidence of the selected OpenPressBrake installation or current ANSI B11.3 requirements. Related earlier [OEM ram/LOTO/rescue audit](4400_CINCINNATI_PROFORM_RAM_RESTRAINT_LOTO_RESCUE_MANUAL_ERRATA_AUDIT_2026-10-23.md) covers mechanical support and internal figure-reference errors.

## Exact manufacturer facts and narrow interpretation
| OEM feature | Directly documented fact | What it does NOT prove |
|---|---|---|
| Optional presence sensing | Figure 1-1 item 7 lists a presence sensing device as **optional**; rear guarding is **optional** in Figure 1-2 item 7. | Model family name or brochure picture does not establish which access paths are guarded on a particular serial number. |
| Guard mute position | Printed 8-4 states that the presence-sensing interface interrupts downstroke in STROKE mode until a configured **Guard Mute Position**. At mute, the presence-sensing device no longer supplies point-of-operation protection; a red guard-off indicator illuminates. | A mute indicator is not an independently proven alternative safeguard, actual slow speed, stopping distance, operator clearance or safe permission to enter the die area. |
| Programmable footswitch | Printed 8-5 describes **step-wise selection** of which active footswitch(es) must be pressed, including combinations, and refers to a separate EM-508 software supplement. | Footswitch combinations are not automatically an ISO 13851 two-hand protective function, a safety-rated occupancy check, or proof all helpers are protected. |
| Auxiliary Device Interface (ADI) | Printed 8-5 describes a **removable plug assembly** and an OEM default plug when no additional third-party equipment is connected; a three-position hold-to-run footswitch accompanies the option. | The document does not supply the plug pinout, actual safety chain or whether a specific installed plug would bypass any safety function. Treat interface semantics **UNKNOWN** pending OEM circuit drawings. |
| Three-position hold-to-run | Printed 8-6 describes a center hold position and both release and overtravel as causing stop or upward movement on this model; historical text references B11.3-2012. | The manual alone does not prove independent monitored safe speed, stop/hold performance, anti-repeat or machine-level safe-mode acceptance. |
| Hydraulic power clamps | Printed 8-4 says hydraulic power can unclamp upper/lower die holders; installed location can vary. | “Pump off” or generic LOTO does not by itself prove clamping state, stored hydraulic pressure or die retention for an installed option. |
| Auto Crown | Printed 8-1 describes a bed-mounted hydraulic cylinder, and potentially two on longer machines, used to deform the bed under forming load. | Main ram pressure-zone diagram cannot be assumed to cover auxiliary bed/crown hydraulic energy or maintenance exposure. |
| Ordinary key/control | Printed 6-1 describes CONTROL ON/OFF keyswitch preventing operator-station cycling while drive motor may still be running. | A keyed control inhibit is not a padlockable energy isolator or proof of ram restraint. |

**Evidence:** all above manufacturer statements are **DOC-CONFIRMED** at the exact 2014 product scope. The consequences and failure scenarios below are **INFERENCE**, requiring selected-machine confirmation. No source code, electrical safety circuit, pressure test or measured stop is available.

## Four distinct failure paths
**FP1 — option mismatch:** retrofit documents front AOPD as installed but the machine has a different or absent device, and rear/side access is unprotected. A copied safety diagram misses an actual exposure. *Discriminator:* physical installed-device inventory and accessible-zone walkdown, including helper and rear access; qualified review before any hazardous testing.

**FP2 — mute as permission:** controller reaches a software-configured position, guard-off light illuminates and an operator assumes the area is safe. The OEM explicitly says the presence-sensing device no longer provides point-of-operation protection during mute. *Discriminator:* independently qualified mode-specific alternative safeguarding, actual motion/speed/stop/load-hold witness, access geometry and deliberate reset; do not rely on LinuxCNC command velocity.

**FP3 — plug as undocumented bypass:** technician substitutes a default/removable ADI plug while a third-party device is installed. The OEM documents the plug's existence but **not its pinout or safety behavior**. *Discriminator:* selected OEM wiring diagrams, plug ID/part number, safety-chain dependency, fault/defeat analysis, authorized configuration control. Do **not** call the plug a safety bypass without circuit evidence; do not use an unknown plug in a live machine.

**FP4 — omitted hydraulic option:** generic maintenance LOTO assumes only the main ram cylinders; an installed hydraulic die clamp or Auto Crown adds stored-energy and falling-tool/bed hazards. *Discriminator:* option-by-option hydraulic circuit and mechanical load-path inventory, qualified physical isolation/holding witnesses.

## Selected-machine option inventory and release form (blank, not filled)
| ID | Required evidence | Current |
|---|---|---|
| OPT-01 | Machine model/serial and actual as-built option list, revisions and field retrofits | UNKNOWN |
| OPT-02 | Front/rear/side guard, helper access and sheet sweep map, including physical installed device variants | UNKNOWN |
| OPT-03 | Each motion mode/step and guard mute/blanking configuration, change authority and provenance | UNKNOWN |
| OPT-04 | Selected safety function during mute: independent stop/safe motion/holding, access coverage and witness | UNKNOWN |
| OPT-05 | Footswitch station ownership, step-wise selection, inactive-station treatment and fresh restart | UNKNOWN |
| OPT-06 | ADI plug/cable variant, OEM pinout, interface safety authority and no-unauthorized-bypass proof | UNKNOWN |
| OPT-07 | Hydraulic die-clamp/Auto Crown/other auxiliary energy sources and isolators | UNKNOWN |
| OPT-08 | Qualified validation, fault tests, human-factors observed workflow and independent physical witness | NOT RUN |

Each row needs evidence ID, revision, person, date, photograph/schematic where permitted, and **proposition-specific** acceptance. An HMI tag is monitoring/diagnostics, not personnel-safety authority. The independent safety controller/final elements and physical energy removal/ram restraint must be evidenced separately from ordinary LinuxCNC/FPGA.

## Human-factors design
A workable guard-off transition should be conspicuous and explain **what protection was removed and what remains**, rather than display a misleading green “ready.” Normal sheet positioning and helper workflow should not require frequent guard defeat. Guard removal/reinstallation, tool changes and maintenance should be supported by accessible controls, visible mechanical supports and low-friction procedures. If a safety function cannot be used conveniently, redesign the workflow rather than accepting defeat. **No claim of observed shop behavior:** these are design hypotheses.

## Adversarial counterexamples
1. “This model supports optional rear guarding, so our rear is protected.” **Reject:** optional does not mean installed.
2. “The mute lamp is on, so safe slow speed is verified.” **Reject:** it only signals the specified mute state; physical alternative protection unproven.
3. “We have two footswitches enabled, so both workers are safe.” **Reject:** selected station logic is not occupancy protection or two-hand safety.
4. “The OEM provides a default ADI plug, so it is an approved safety bypass.” **Reject:** undocumented electrical/safety semantics, unknown installed device.
5. “We mapped the ram cylinder, so all hydraulic energy is covered.” **Reject:** hydraulic clamps and Auto Crown may create additional energy zones.
6. “The key is OFF, so maintenance is isolated.” **Reject:** OEM says motor may still run in that key state.

## Uncertainty and continuation
**DOC-CONFIRMED:** OEM optional-device, mute, footswitch, plug, clamp, Auto Crown and control-key statements. **INFERENCE:** hazard and bypass incentives. **SOURCE-CONFIRMED:** none new. **TEST-CONFIRMED:** none. **UNKNOWN:** actual ADI safety chain, third-party protective device, selected machine option list, all physical stop/hold/access/escape/energy/restart witnesses and current standard compliance. No generic numeric limits, plug wiring, safety PL/SIL or hydraulic truth table invented. Selected `IN-01..10 UNKNOWN`, `OPT-01..08 UNKNOWN/NOT RUN`, `VAL/PT NOT RUN`; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Original archive **6/85 pending**, not affected by this new original research.

**No lab:** this is a documentation and installed-configuration question; simulation of imagined plugs or pressure zones would produce false certainty. For any machine without demonstrated minimum safeguarding, no personnel-exposed operation; isolated/remote development only with people outside the hazard zone and residual-risk review.
