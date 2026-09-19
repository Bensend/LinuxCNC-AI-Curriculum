# Two-hand control, anti-tiedown, and multi-operator authority study

Date: 2026-09-19
Lane: independent safety curriculum Lane B
Status: durable architecture/source study; not an OpenPressBrake design prescription

## Why this branch

The primary safety lane is currently advancing reset/restart/cold-start/stale-command authority while the hydraulic post-service proof bridge remains open. This study deliberately uses different files and a different evidence package: two-hand control (THC), anti-tiedown, release-before-restart, and multi-operator concurrence for press-like hazards.

## Architecture freeze

**ONE BUTTON ACTIVE != TWO HANDS VALID != SIMULTANEITY VALID != ANTI-TIEDOWN SATISFIED != ALL REQUIRED OPERATORS VALID != SAFETY FUNCTION ENABLED != PHYSICAL HAZARD SAFE != PRODUCTION AUTHORITY.**

Also freeze:

**TWO-HAND OUTPUT TRUE != ORDINARY LINUXCNC START FRESH != FINAL ELEMENT RESPONDED != HAZARDOUS MOTION SAFE.**

**ONE OPERATOR VALID != EVERY EXPOSED OPERATOR PROTECTED.**

A two-hand control is a protective-control function, not evidence that hazardous energy is isolated. It is not a maintenance isolation method and does not replace guards, ESPE, retaining measures, or other protective functions required by the actual risk assessment.

## Evidence ledger

### SICK Safety Guide for the Americas

Classification: **DOC-CONFIRMED**.

SICK states that a two-hand control protects one person; if several operators are exposed, each person needs a separate two-hand control and all required actuating devices must be operated concurrently. It also states that releasing either control must stop the dangerous movement, restart requires synchronous operation within 0.5 s for the described type-III behavior, and placement/orientation/shrouding must make defeat difficult and keep the station outside the required safe mounting distance.

Source: https://www.sick.com/media/docs/6/06/606/Special_information_Safety_Guide_For_The_Americas_en_IM0032606.PDF

### SICK Flexi Soft / Safety Designer multi-operator logic

Classification: **DOC-CONFIRMED**.

SICK documents a Multi operator function block for up to three two-hand systems, explicitly including press applications. A Cycle request can force each operator to release their two-hand device at least once before restart, preventing a station from remaining permanently actuated. SICK also states that Reset and Restart are independent of this function block.

Source: https://www.sick.com/media/docs/3/83/083/operating_instructions_flexi_soft_in_the_safety_designer_configuration_software_en_im0081083.pdf

### Rockwell GuardLogix Two Hand Run Station

Classification: **DOC-CONFIRMED**.

Rockwell's THRS safety instruction combines two diverse-input buttons into a run-station result. It detects a button tie-down condition if the buttons are not pressed within the documented 500 ms window and prevents the run result. If one button is released and re-actuated while the other remains active, Cycle Buttons prevents a new run result until both controls have returned through their safe states.

Source: https://www.rockwellautomation.com/en-pr/docs/studio-5000-logix-designer/38-00/contents-ditamap/instruction-set/safety-instructions/two-hand-run-station--thrs-.html

### Rockwell Machinery Safebook 5

Classification: **DOC-CONFIRMED**.

Rockwell describes concurrent two-hand operation, continuous actuation during the hazardous condition, stopping when either control is released, and release of both controls before restart as anti-tiedown behavior.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/safebk-rm002_-en-p.pdf

### Pilz PNOZsigma two-hand monitoring

Classification: **DOC-CONFIRMED**.

Pilz publishes dedicated two-hand monitoring devices with dual-channel input arrangements and simultaneity monitoring. This independently confirms that two-hand concurrence is treated as a safety function rather than ordinary PLC/HMI button logic.

Source: https://www.pilz.com/es-MX/eshop/Dispositivos-de-conmutaci%C3%B3n/Dispositivos-de-conmutaci%C3%B3n-seguridad-funcional/PNOZsigma%3A-dispositivos-de-seguridad/Supervisi%C3%B3n-de-mandos-a-dos-manos/c/0010000200700380G8

## OpenPressBrake boundary

The following are **UNKNOWN** and must not be inferred from this study:

- whether OpenPressBrake needs or will use two-hand control;
- whether it would be the primary protective device, a mode-specific device, or absent entirely;
- number/location/geometry of stations;
- required safety distance;
- stopping time/distance;
- control type/performance level/category/SIL;
- whether more than one operator can be exposed;
- whether foot control, light curtains, laser guarding, guards, enabling devices, or another protective architecture is appropriate;
- the hydraulic final-element response needed on release;
- any allowed motion after a hand is released.

These require machine-specific risk assessment, architecture, and physical validation.

## LinuxCNC / FPGA authority boundary

LinuxCNC may request a cycle, display station status, record diagnostics, or coordinate ordinary sequence logic. A normal FPGA may transport non-safety status or ordinary commands. Neither becomes personnel-safety authority merely because it can observe two buttons.

If a two-hand function is safety-related, the validated safety path must own the simultaneity, release, anti-tiedown, fault response, and safety output authority appropriate to the application. The ordinary cycle request remains a separate condition.

Useful conceptual gate:

`fresh ordinary cycle request AND validated two-hand protective authority AND all other required safety conditions -> machine-specific motion authority`

This is architecture notation only, not an OpenPressBrake implementation.

## Failure-path / commissioning worksheet

For an application that actually uses two-hand control, challenge at least these questions without inventing acceptance values:

1. Hold left control before actuating right. Does the safety function reject an invalid simultaneity sequence as designed?
2. Hold right before actuating left. Same question in the opposite order.
3. Establish a valid two-hand state, release one hand, then re-actuate it while the other remains held. Can motion authority return without both controls first cycling safe? It must not where anti-tiedown/release-before-restart is part of the validated design.
4. Release either hand during the hazardous portion. Trace the demand through the independent safety evaluator to the actual final element and physically validate the required machine response.
5. Power up with one or both controls already actuated. Does the system reject a stuck/high or pre-actuated control according to its validated architecture?
6. Simulate an approved input-channel fault. Does the safety evaluator inhibit the function and retain a useful diagnostic rather than treating the remaining plausible button state as sufficient?
7. If multiple operators are required, validate operator A while B is absent/released, then reverse. Does any single station incorrectly authorize the hazardous function?
8. Attempt to leave one operator station permanently actuated across cycles. Does cycle/release logic prevent it from becoming a standing permit?
9. Challenge any station-selection or bypass mechanism. Is removal of an operator station from the safety function itself controlled by the validated mode/risk architecture rather than ordinary HMI convenience?
10. Hold a LinuxCNC START/CYCLE request before restoring the safety condition. Does restoration of valid two-hand authority resurrect stale ordinary motion, or is a fresh ordinary initiation required by the machine's validated restart architecture?
11. Verify station placement and defeat resistance physically for the real machine. Logic validation alone cannot prove the operator cannot reach the hazard while maintaining the controls.
12. Verify actual stopping/protective performance with the real final element. A correct THRS/THC Boolean output is not physical stop proof.

## Evidence labels for future work

Use the curriculum provenance vocabulary strictly:

- **SOURCE-CONFIRMED** — source code/configuration directly inspected.
- **DOC-CONFIRMED** — manufacturer/standard-derived documentation directly supports the claim.
- **TEST-CONFIRMED** — a controlled test directly demonstrates the behavior.
- **COMMUNITY-REPORTED** — credible field report, not independently proven.
- **INFERENCE** — engineering conclusion derived from evidence but not explicitly stated by the source.
- **UNKNOWN** — not established; do not silently promote it.

This study currently contains DOC-CONFIRMED architecture evidence and INFERENCE only where explicitly framed as curriculum architecture. It contains no OpenPressBrake TEST-CONFIRMED physical result.

## Precise next Lane-B work

Find a complete professional press implementation that exposes:

`operator station(s) -> dual-channel two-hand inputs -> simultaneity/anti-tiedown evaluator -> multi-operator concurrence if applicable -> independent safety output -> actual press final element -> physical release/stop witness -> both-controls-released requalification -> separate fresh production initiation`.

Prefer a wiring/safety-controller example with a documented fault or commissioning procedure, not another generic product description. Preserve the distinction between control-logic correctness and physical stopping performance.

## Compute decision

No simulation, synthesis, benchmark, or executable verification is justified by the unresolved question in this pass. No GitHub-hosted runner should be used. If a later question genuinely requires executable verification, use only the repository's self-hosted `[self-hosted, openpressbrake]` path or record the blocker.