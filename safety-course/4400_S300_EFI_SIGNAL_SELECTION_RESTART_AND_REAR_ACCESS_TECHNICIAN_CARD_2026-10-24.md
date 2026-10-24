# 4400 field card — S300 EFI signal selection, rear-zone access and restart

**Paper-only technician exercise, 2026-10-24.** Companion: [SICK original manufacturer audit](../research/4400_SICK_S300_EFI_RESTART_INTERLOCK_SIGNAL_SELECTION_AND_REAR_ZONE_SOURCE_AUDIT_2026-10-24.md). Read SICK 8010948/ZD76/2025-08-19 printed pp. 23–25, 31–32, 57–58, 88–90, 97–98; use the official PDF https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf . This is **not** a physical commissioning test, a hidden evaluator answer key or machine authorization.

## Core distinction

**Protective field clear != scanner OSSD released != safety PLC rearmed != final elements proven safe != machine deliberately started.** SICK documents that an internal S300 restart interlock affects Flexi Soft via **OSSD status**, but **not** via raw **protective-field status**; in the latter case the controller needs its own interlock. No claim that any scanner or Flexi Soft is installed on OpenPressBrake.

## Technician's paper cases

For every case identify: **(a)** hazard/occupancy, **(b)** source-confirmed versus inferred/unknown, **(c)** actual safety signal and reset owner, **(d)** physical final element/witness, **(e)** safe disposition and missing evidence. No numerical performance guessing.

| ID | Scenario | Required reasoning / safe disposition |
|---|---|---|
| EF-01 | Scanner configured for manual restart; PLC uses **OSSD state**. | SICK documents scanner interlock influence via this path; verify exact installed integration and machine-level deliberate start separately. |
| EF-02 | Scanner configured for manual restart; PLC uses **protective-field state**. | Scanner interlock does **not** propagate via this path; require PLC-side restart interlock and validation; **HOLD** if absent/unverified. |
| EF-03 | Scanner OSSD stays OFF, raw field clears after person passes through to a rear corner. | Whole-body occupancy behind access field is not detected by passage sensor; do not treat field clear as empty area. |
| EF-04 | Field-clear automatically restarts a backgauge. | Reject as proof of deliberate start; require independently designed restart inhibition and local intentional start. |
| EF-05 | Reset button can be reached by someone hidden behind ram. | Reset location/sightline and trapped-person protection unresolved; redesign so correct reset is easy and bypass difficult. |
| EF-06 | Rear gate opens; ram stops but X/R backgauge remains enabled. | Distinct hazardous actuators; stop coverage/final-element map required, not just ram state. |
| EF-07 | Backgauge drive electronics still powered but STO reported. | Powered electronics can coexist with STO; independent drive safety wiring and motion/hold proof needed. |
| EF-08 | Backgauge STO active; vertically mounted R axis slowly settles. | STO is not a mechanical load-hold function. Obtain gravity and brake proof; do not enter. |
| EF-09 | Scanner universal I/O warning signal wired to ordinary PLC and called safety output. | SICK explicitly labels universal I/O non-safe; reject safety credit. |
| EF-10 | Mode changes to setup while an operator is already in the field; new field is smaller. | Switching time/coverage and independent safety case selection must be proven; HMI mode alone not safety authority. |
| EF-11 | Scanner mounting shifted to allow a pallet through. | Blind-zone, mounting and separation assumptions changed; require reassessment and revalidation. |
| EF-12 | Scanner LED green, HMI says SAFE, but safety PLC logic version unknown. | Neither proves which EFI variable controls outputs; request versioned safety project and signal-to-final-element trace. |
| EF-13 | Local E-stop stops X axis but powered sheet follower continues moving. | Auxiliary motion hazard and reciprocal stop mapping; conditional on actual follower installation. |
| EF-14 | After power return scanner shows no obstruction; machine restarts with queued CNC move. | Require deliberate fresh start, stale-command discard and independent safety rearm; software alone is not personnel-safety authority. |
| EF-15 | Maintenance requires crawling around rear scanner to reset. | Predictable guard defeat is an engineering design defect; accessible reset, clear sightline, easy isolation and physical barrier restoration. |
| EF-16 | No S300, no Flexi Soft, only fixed rear fence and monitored door. | OEM EFI failure does not apply; evaluate actual fence, door interlock, stopping, trapped-person and reset independently. |

## Minimal evidence matrix (blank; fill only with selected machine evidence)

| Proposition | Actual component / exact edition | Wiring or geometry witness | Safety controller and final element | Independent physical result | Status |
|---|---|---|---|---|---|
| Rear access detection / guard boundary | UNKNOWN | UNKNOWN | UNKNOWN | NOT RUN | HOLD |
| Occupancy / blind-zone prevention | UNKNOWN | UNKNOWN | UNKNOWN | NOT RUN | HOLD |
| Scanner OSSD vs raw EFI signal selection (if installed) | UNKNOWN | UNKNOWN | UNKNOWN | NOT RUN | CONDITIONAL HOLD |
| Local reset, separate start, power-recovery behavior | UNKNOWN | UNKNOWN | UNKNOWN | NOT RUN | HOLD |
| Backgauge X/R/Z protective stop and hold | UNKNOWN | UNKNOWN | UNKNOWN | NOT RUN | HOLD |
| Y1/Y2 stop, gravity restraint, hydraulic isolation | UNKNOWN | UNKNOWN | UNKNOWN | NOT RUN | HOLD |

## Release logic

`EF-01..16 PAPER ONLY`; no scanner-specific numerical response, field dimension, PL/SIL or stop time may be transferred. No live personnel-in-zone test, unexpected-restart trial, guard defeat or hazardous energized experiment. **If minimum safe-to-operate protection cannot be demonstrated, do not operate with people exposed; any experimental work must be isolated/remote with everyone outside the danger zone and residual risk explicitly assessed.** External 4400-HY-01 and 2520–25F0 evaluation gates remain open, not self-scored.
