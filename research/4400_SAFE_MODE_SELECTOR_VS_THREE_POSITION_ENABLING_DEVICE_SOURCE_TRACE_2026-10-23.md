# 4400 — safe mode selection is not an ordinary HMI setting; enabling devices are not E-stops

**Evidence status:** `DOC-CONFIRMED` for manufacturer guidance and product descriptions; `INFERENCE` for the cross-machine hazard analysis; `UNKNOWN` for any selected machine's control implementation, integrity, stopping/holding and occupancy. Research recorded 2026-10-23; no simulation or physical test.

## Authoritative manufacturer guidance inspected

1. Pilz, **Must an operating mode selector switch be safely evaluated?**, current official technical FAQ: https://www.pilz.com/en-INT/support/faq/standards/articles/167661 . The guidance, referring to the Machinery Directive 2006/42/EC and applicable standards, says that each selector position should enable only one mode, selecting a mode must not itself initiate machine operation, and E-stop/emergency-off must retain precedence. Pilz explicitly warns that ordinary standard control cannot itself perform a safety-related evaluation of the selector. **This is manufacturer guidance about regulatory/standards interpretation, not a verbatim full standard text.** Exact jurisdiction, machine C-standard and selected safety requirements still govern the final design.
2. Pilz, **PITenable enabling switch**, current official product description: https://www.pilz.com/en-INT/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch . It describes a three-level Off-On-Off manually operated enabling device for situations with a suspended guard, including the released/middle/overpressed protective behavior. The product description identifies compatible Pilz safety-evaluation systems. It does not provide the selected machine's safety performance or a universal safe-speed setting.
3. Rockwell Automation, **440J grip enabling switches**, official product description: https://www.rockwellautomation.com/en-nl/products/hardware/safety-products/440j-grip-switches.html . It identifies dual three-position enabling switches and *optional separate* jog and E-stop devices. A grip enabling device is therefore not automatically an E-stop or jog command; these are distinct allocated functions.
4. Fiessler, **FMSC-FP** manufacturer brochure doc1872 (2025-10-15), printed p. 5, https://www.fiessler.de/default-wAssets/docs/download/FMSC-Schaltgeraete/prd-fmsc-switching-device-engl-doc1872-comp.pdf , and current product page https://www.fiessler.de/en/products/safety-products/safety-footpedals/safety-foot-pedals-fe-fs.php . Four selected pedal authorization modes (1 only, 2 only, OR, AND) and separate mode/pedal/relay diagnostic indications are documented. Exact installed selection and protective response remain unknown.

## Transfer reasoning

A press-brake foot pedal, a robot teach-pendant grip, a mill setup selector and a guarded cell's maintenance mode can share an **abstract** Off-On-Off or mode-selection idea without sharing the same *safety function*. A press-brake pedal may request a production stroke while its overtravel generates a stop demand; a robot enabling grip may be used with suspended guard protection during manual teach; an ordinary LinuxCNC setup-mode button only requests normal control behavior. **None of these inputs alone proves safe speed, standstill, load holding, absence of personnel in the zone, or maintenance energy isolation.** A safety-related controller and selected physical final elements must own the credited personnel-protection function.

### Mode authority table (requirements, not a wiring truth table)

| Hazard question | Selected-mode evidence needed | Misleading shortcut to reject |
|---|---|---|
| Can a selector alone start motion? | Independent safety requirements and transition/new-start behavior | HMI mode button also triggers cycle start |
| Are modes mutually exclusive? | Selector safety evaluation and exact physical mode/zone mapping | Two modes active simultaneously because ordinary software bitmask permits it |
| Is E-stop still effective in setup/muting? | Selected safety-function allocation, independent final-element and physical response | Mode disables all stop requests for convenience |
| Who is authorized to hold-to-run? | Person/zone identity, exact enabling input, retained-start prevention | Two-pedal OR mode presented as two-person AND |
| Can someone remain inside after reset? | Occupancy/escape/access prevention and deliberate new start | Guard closed/HMI green implies zone empty |
| Does the enabling switch equal E-stop? | Product's distinct enabling and optional E-stop allocation | Overtravel input is labeled E-stop without correct circuit or safety evaluation |
| Does selected safe speed exist? | Safety-rated monitoring/stop function and machine-specific measured validation if required | LinuxCNC jog speed parameter treated as safety-rated |

**Adversarial case:** an operator is inside a robot cell holding a three-position enabling grip. The ordinary HMI reports `SETUP`, but the safety selector is in automatic mode after replacement wiring. The enabling grip is held in its middle position; the gate appears closed on the HMI. Do not declare this safe or assign a generic stop category. Record the conflicting mode evidence, prevent personnel-exposed hazardous operation, trace the independent safety-controller selector and enabling input, protective devices and occupancy/escape provisions, and require selected machine validation. A release or panic overpress is a stop *demand*; the actual final element and physical stop must be witnessed separately.

## Human-factors design consequence

Mode selection should be explicit, unambiguous, accessible only to authorized personnel, easy to diagnose, and unable by itself to initiate a cycle. Requiring a separate deliberate start after the appropriate rearm reduces accidental restart risk. Guard reinstatement, pedal identity and mode indication should be easier to use correctly than to bypass. If servicing demands repeated defeat of a safeguard, redesign access/diagnostics rather than treating that behavior as inevitable.

## Provenance ledger

| ID | Claim | Class | Limit |
|---|---|---|---|
| MODE-01 | Each mode should be exclusive; selection alone must not initiate operation | DOC-CONFIRMED manufacturer guidance | Pilz FAQ; not full normative standard text |
| MODE-02 | Ordinary standard controller cannot by itself safety-evaluate selector | DOC-CONFIRMED manufacturer guidance | Exact selected architecture still needed |
| MODE-03 | Pilz PITenable is a three-level Off-On-Off device used when guard protection is suspended | DOC-CONFIRMED product description | No selected-machine integrity/stopping result |
| MODE-04 | Rockwell 440J has optional jog/E-stop distinct from enabling switch | DOC-CONFIRMED product description | Product variants differ |
| MODE-05 | Fiessler FMSC-FP exposes four pedal selection modes | DOC-CONFIRMED manufacturer docs | No installed selector/zone mapping |
| MODE-06 | Wrong OR/AND/automatic/setup selection can alter who can request hazardous motion | INFERENCE | Requires machine-specific hazard analysis |
| MODE-07 | Selected safe speed, actual stop, PL/SIL, occupancy, reset and maintenance isolation | UNKNOWN | Must be evidenced, not assumed |

**Minimum operation restriction:** if the selected machine's independent personnel-protection function is not established, do not operate with people exposed. Experimental operation only isolated/remote with people outside danger zone and residual risk recorded. No ordinary LinuxCNC/FPGA safety authority transfer.
