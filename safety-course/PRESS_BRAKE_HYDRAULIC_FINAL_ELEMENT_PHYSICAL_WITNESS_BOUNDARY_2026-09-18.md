# Press-brake hydraulic final-element / physical-witness boundary

Date: 2026-09-18

## Question

What can be established from public professional press-brake hydraulic evidence about the chain from safety command to hydraulic final element to actual ram/load state, without inventing an OpenPressBrake hydraulic truth table?

## Evidence

### HAWE SAKB — real press-brake hydraulic architecture

**DOC-CONFIRMED.** HAWE's current SAKB product documentation identifies a hydraulic drive intended for CNC press brakes. The architecture consists of one central control block plus two separate suction valves, is intended for use with NSV anti-cavitation valves, and is stated by HAWE as certified according to DIN 12622. This is useful machine-class evidence because the final hydraulic architecture is not a single abstract `HYDRAULICS ENABLE` bit.

Source: HAWE, *Control system for CNC press brakes type SAKB*, D 6335 product/download page, current document dated 2025-08-26: https://www.hawe.com/products/product-finder/integrated+solutions/control+for+press+brakes/sakb+-+control+for+press+brakes/downloads/

### HAWE switching-position monitoring

**DOC-CONFIRMED.** HAWE defines switching-position monitoring as sensing the position of a valve switching element, commonly using proximity sensors or displacement transducers, and identifies a press safety valve as a typical application.

Source: HAWE Fluid Lexicon, *Switching position monitoring*: https://www.hawe.com/fluid-lexicon/switching-position-monitoring/

This supports a crucial proposition boundary: valve-position feedback is evidence about the valve switching element. It is not, by itself, direct proof of ram standstill, pressure removal, accumulator discharge, load retention, or absence of every hazardous energy source.

### HAWE ePRAX modular — stored hydraulic energy remains an explicit machine fact

**DOC-CONFIRMED.** HAWE's ePRAX modular press-brake drive controls each cylinder with a separate regulated servomotor/drive and states that return stroke is powered partly by temporarily stored hydraulic energy. The system also integrates anti-cavitation valves and is stated as certified according to DIN EN 12622.

Source: HAWE, *ePRAX modular - Control for press brakes*: https://www.hawe.com/en-us/products/product-finder/integrated+solutions/control+for+press+brakes/eprax-modular+-+control+for+press+brakes/

This is direct evidence against teaching `motor/drive off == hydraulic energy absent` as a generic press-brake rule.

### HAWE EV2D — electrical command/current feedback remains upstream of hydraulic truth

**DOC-CONFIRMED.** HAWE describes EV2D as a proportional amplifier developed for safety-relevant press-brake processes and separately documents current-feedback measurement at valve outputs. Current feedback can establish an electrical actuator proposition; it does not directly establish spool position, hydraulic flow/pressure, cylinder motion, or ram retention.

Source: HAWE, *Digital amplifier EV2D – Ready for safety-relevant processes in the press brakes*, 2022-10-12; HAWE servo-hydraulics product documentation.

## Frozen proposition ladder

Do not collapse these propositions:

`SAFETY LOGIC DEMANDS SAFE STATE`

`!= VALVE ELECTRICAL COMMAND REMOVED / CHANGED`

`!= COIL CURRENT IN EXPECTED STATE`

`!= VALVE SWITCHING ELEMENT IN EXPECTED POSITION`

`!= HYDRAULIC PATH IN EXPECTED STATE`

`!= CYLINDER / RAM PHYSICALLY STATIONARY OR RETAINED`

`!= STORED HYDRAULIC ENERGY CONTROLLED`

`!= ALL HAZARDS ABSENT`

`!= PERSONNEL ACCESS SAFE`.

A witness is only evidence for the proposition it actually observes.

## Failure-path analysis

Commissioning/validation must challenge at least these disagreements when the selected machine architecture makes them possible:

1. safety output changes but valve electrical command does not;
2. electrical command changes but measured coil current does not;
3. coil current is plausible but monitored valve position disagrees;
4. monitored valve position is plausible but ram motion/position evidence disagrees;
5. pump/servo drive is disabled while stored hydraulic energy remains;
6. one hydraulic element reports the expected state while another required element is failed, stale, unmonitored, or masked;
7. safety state is restored while stale LinuxCNC `START`, `JOG`, `DOWN`, or `ENABLE` intent remains asserted.

A disagreement in a proposition required for the safety function removes the authority that depended on that proposition. A diagnostic acknowledgement does not constitute repair, physical proof, safety rearm, or fresh production intent.

## OpenPressBrake transfer

**INFERENCE / DESIGN RULE, not machine-specific fact.** Ordinary LinuxCNC, HAL and the normal FPGA may issue normal valve/current commands and consume diagnostics, but they must not be promoted to sole personnel-safety authority merely because they can observe those signals. A safety architecture must define which independent witnesses and final elements prove each required hazard-control proposition.

**UNKNOWN until the actual machine is characterized:** cylinder topology and areas; valve truth table; valve normal/fault positions; anti-cavitation/load-holding behavior; accumulator existence/volume/precharge; pressure thresholds; stopping time/distance; ram mass/load path; leakage behavior; required redundancy/category/PL/SIL/DC; which signals are safety-rated; and what exact physical state constitutes safe access.

Do not infer any of those from SAKB/ePRAX/EV2D.

## Practical human-factors rule

Diagnostics should name the failed proposition rather than present a generic `SAFETY OK` lamp. Examples: `VALVE COMMAND OFF / POSITION NOT PROVED`, `RAM STANDSTILL NOT PROVED`, `STORED PRESSURE NOT PROVED SAFE`, or `RESTART RESET REQUIRED`. This makes the safer repair path easier than bypassing an opaque interlock.

If the required physical hazard proposition cannot be established, do not operate with people exposed to that hazard. Experimental operation must be isolated/remote with people outside the danger zone and residual risk stated.

## Evidence status / next question

This study closes a conceptual gap but does **not** close the requested same-machine chain. Public HAWE product material found in this pass exposes real press-brake hydraulic architecture, stored-energy facts, and valve-position monitoring as a professional technique, but not a complete public SAKB/ePRAX safety state machine tying a specific valve-position disagreement to ram/load disposition, repair, re-proof, safety rearm, and fresh production START.

Next evidence target: a manufacturer/OEM hydraulic press or press-brake commissioning/service document that exposes the complete chain `safety demand -> redundant hydraulic final elements -> element-position/pressure/motion witness disagreement -> physical load-safe disposition -> repair -> re-proof -> safety reset/rearm -> separate fresh cycle initiation`.
