# Cincinnati press-brake setup-mode, tooling-change, and motion-authority study

Date: 2026-09-21
Lane: independent safety curriculum Lane B

## Why this branch

The primary safety lane is currently advancing physical-change revalidation and adversarial return-to-service exercises. This study deliberately avoids that module/evidence package and instead examines an operator/setup authority boundary on a real hydraulic press brake: what SETUP mode changes, what motion controls remain available, and what additional physical precautions are still required during tooling work.

This is architecture evidence, not an OpenPressBrake design prescription.

## Evidence provenance

### Cincinnati BASEFORM / hydraulic press-brake manual

**DOC-CONFIRMED:** Cincinnati's BASEFORM operation/safety/maintenance manual instructs tooling installers to power the machine, start the main drive, log into the control, and verify that palmbuttons are enabled for SETUP mode before the tooling procedure. The same manual family states that with the machine control mode selector in SETUP, ram motion is limited to palmbuttons or the RAM UP control.

Source: Cincinnati Incorporated, BASEFORM Series Press Brake Operation, Safety and Maintenance Manual, EM-558. Public manufacturer PDF indexed at:
https://wwwassets.e-ci.com/PDF/Preinstallation/Press-Brakes/em-558-n-07-14-90-175-baseform-series-press-brake-operation-safety-and-maintenance-manual.pdf

**DOC-CONFIRMED:** The manual's safety instructions for installing/removing dies say to place the mode selector in SETUP so the ram can only be moved by palmbuttons or RAM UP, and warn not to reach into/through the die area while aligning dies or setting gaging.

**DOC-CONFIRMED:** For die removal, Cincinnati separately requires safety blocks between the dies and machine/control OFF for the cleaning portion, and states that ram die-clamp bolts are not to be loosened unless the dies are closed and the operator/control selector is OFF. Thus SETUP mode is not presented as a substitute for de-energization/blocking where the task requires those states.

**DOC-CONFIRMED:** Cincinnati identifies the rear space between the machine housings as hazardous and states that personnel are not to enter while the main drive motor is running or the control is energized.

### OSHA powered press-brake guidance

**SOURCE-CONFIRMED:** OSHA's powered-press-brake machine-guarding guidance identifies foot-pedal operation as an accidental-cycling hazard and lists presence sensing, two-hand control, pullback, and restraint approaches as point-of-operation safeguarding methods. This supports treating the cycle-command device and the safeguarding function as separate architectural concerns.

Source: OSHA Machine Guarding eTool, Powered Press Brakes:
https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes

## Authority decomposition

The Cincinnati evidence gives a useful setup-mode ladder:

`MODE = SETUP`

is not equivalent to:

`ram cannot move`.

Instead, SETUP changes which controls can authorize ram movement. In the documented machine, palmbutton/RAM-UP authority remains available. Therefore:

**SETUP MODE SELECTED != HAZARDOUS MOTION IMPOSSIBLE**

and:

**SETUP MODE SELECTED != DIE AREA SAFE TO ENTER**

The task then determines what additional state is required. Cincinnati's own tooling procedure uses different states for different substeps: controlled setup motion for positioning, explicit keep-out rules while motion authority exists, and blocked/OFF conditions for portions of die removal.

This is the key curriculum lesson: a mode selector is an authority router, not an energy-isolation device.

## OpenPressBrake architecture implication

**INFERENCE:** A future OpenPressBrake SETUP mode should be represented as a bounded authority state whose permitted command sources and motion classes are explicit. LinuxCNC/HAL/FPGA may request or display the mode, but an ordinary software mode bit must not silently become personnel-safety authority.

**INFERENCE:** The curriculum should force the learner to answer, for each setup task:

1. What hazardous energy/motion must remain available to perform this step?
2. Which command device may authorize that motion?
3. Which safeguards remain active?
4. Which areas must remain unoccupied even in SETUP?
5. Which later substep requires energy isolation, blocking/restraint, or another stronger state?
6. What transition is required before returning from setup to production?

## Failure-path analysis

### Failure 1 — treating SETUP as a safe-state synonym

A technician selects SETUP and enters the die area because the machine is "in setup." The manufacturer evidence contradicts that model: ram motion remains available from named controls.

Disposition: curriculum failure. Require explicit motion-authority and occupancy analysis.

### Failure 2 — LinuxCNC disables AUTO but leaves another motion path live

**INFERENCE:** Disabling automatic cycle execution does not prove that jog, manual valve command, hardware motion, RAM UP, maintenance controls, or another command path is absent. Validation must challenge every motion source that is supposed to be inhibited in the selected mode.

### Failure 3 — using control mode instead of physical blocking/isolation

The Cincinnati procedure itself moves between controlled energized setup and blocked/OFF states. A learner who uses SETUP as a substitute for required blocking or isolation has collapsed two distinct hazard-control methods.

### Failure 4 — stale production command across mode exit

**INFERENCE:** A held or queued production START/JOG/CYCLE request should not acquire fresh authority merely because SETUP is exited. Mode restoration, safety requalification/reset/rearm where required, and ordinary fresh production start should remain distinct transitions.

This inference is consistent with the curriculum's existing restart-freshness architecture but is not claimed as a Cincinnati-specific behavior.

## Question-driven commissioning plan

No executable compute is justified for this study. The unresolved questions are physical/architectural, not simulation questions.

For a future machine-specific acceptance plan, challenge at least:

- select SETUP and prove production automatic-cycle commands are inhibited as designed;
- deliberately actuate each command source that is supposed to remain permitted in SETUP and verify only the intended bounded motion occurs;
- challenge each command source that is supposed to be unavailable in SETUP;
- prove safeguard behavior for the areas that remain personnel-accessible during setup;
- prove that areas declared prohibited while energized remain procedurally/physically excluded;
- transition to a task requiring blocking/isolation and verify that SETUP alone is not accepted as the isolation proof;
- restore from the setup task and requalify affected safeguards/functions;
- hold or queue an ordinary START/JOG/CYCLE request during the transition back to production and verify it does not become fresh motion authority;
- require a separate fresh ordinary production start.

Machine-specific speeds, stopping distances, hydraulic states, safe positions, PL/SIL/category, and acceptance thresholds remain **UNKNOWN** until the actual OpenPressBrake architecture and physical machine are measured/validated.

## Evidence labels

- Cincinnati mode/tooling statements: **DOC-CONFIRMED**.
- OSHA general powered-press-brake hazard/safeguarding statements: **SOURCE-CONFIRMED**.
- No local physical machine tests were run: no **TEST-CONFIRMED** claims.
- No community report is used as design authority: no **COMMUNITY-REPORTED** claim.
- OpenPressBrake transfer statements above are explicitly **INFERENCE**.
- OpenPressBrake physical parameters and final setup-mode implementation remain **UNKNOWN**.

## Durable freezes

- **SETUP MODE SELECTED != HAZARDOUS MOTION IMPOSSIBLE**.
- **SETUP MODE SELECTED != DIE AREA SAFE TO ENTER**.
- **AUTOMATIC CYCLE DISABLED != ALL HAZARDOUS MOTION SOURCES DISABLED**.
- **BOUNDED ENERGIZED SETUP AUTHORITY != ENERGY ISOLATION/BLOCKING**.
- **MODE RETURNED TO PRODUCTION != SAFEGUARDS REQUALIFIED != FRESH PRODUCTION START**.

## Next Lane-B evidence target

Find an authoritative OEM/manufacturer commissioning or maintenance procedure that physically challenges multiple command sources across a setup/service-mode boundary, preferably showing a deliberate negative test such as AUTO/CYCLE inhibited while a bounded setup control remains functional, followed by restoration/requalification and a separate fresh production start. Prefer a different evidence family from the primary lane. If the primary lane moves into setup-mode command-authority work first, rotate Lane B rather than duplicate it.
