# Schmersal reset / restart / feedback / controller-release separation

Date: 2026-09-21

## Why this branch

The setup-to-automatic source trace reached an honest evidence boundary. This branch rotates to 25E0 and asks a different question: after a safety-related field condition has interrupted operation, what evidence does a professional safety controller require before release, and how are reset/restart, actuator feedback and ordinary controller release kept distinct?

## Authoritative implementation

**DOC-CONFIRMED.** Schmersal's PROTECT SELECT multifunctional safety-controller operating instructions expose separate terminals/functions for:

- safety sensors and an Emergency-Stop command device;
- `START / RESET` inputs used as restart conditions;
- a dedicated **feedback circuit** input from external actuators such as guards, drive regulators, inverters or valve terminals;
- safe semiconductor/relay outputs; and
- a signalling/controller-release path that can be delayed separately for the ordinary drive/controller interface.

The current operating instructions describe the feedback circuit as an **additional condition** of the function macro. Reset is separately described as the restart condition for safety sensors/E-stop and, where applicable, as the request to relock a guard after the safety area has been exited and closed.

Source: Schmersal, *PROTECT SELECT / PROTECT SELECT OEM — Operating instructions*, current V10 document, application program examples and digital input definitions, `https://products.schmersal.com/upload/orig/10/00/20/07/DOC_MAN_MEC_mrl-protect-select_SEN_AIN_V10.pdf`.

Earlier/currently indexed Schmersal editions independently describe feedback from actuators including drive regulators, inverters and valve terminals as a distinct input condition, supporting that this is intentional architecture rather than a prose accident.

## Architecture extracted for teaching

The professional implementation supports four distinct state questions:

1. **Protective input state** — has the E-stop/sensor/guard condition returned to the state required by the safety function?
2. **External final-element feedback** — does the feedback circuit report the required state of the downstream actuator chain?
3. **Reset/restart condition** — has the required deliberate reset/restart action occurred?
4. **Ordinary controller release** — may the non-safety controller/drive interface now receive its operational release?

These are related but not interchangeable.

Freeze:

- **PROTECTIVE INPUT RESTORED != RESET/RESTART ACCEPTED.**
- **RESET/RESTART REQUESTED != EXTERNAL ACTUATOR FEEDBACK VALID.**
- **FEEDBACK CIRCUIT VALID != ORDINARY PRODUCTION START.**
- **CONTROLLER RELEASE ISSUED != PHYSICAL MACHINE RESPONSE VALIDATED.**

## Important limit on the feedback witness

The Schmersal feedback input is evidence about the configured external feedback circuit. It is not automatically proof of every physical hazard-energy state. A contactor auxiliary contact, drive status, valve-terminal feedback or guard contact has only the diagnostic authority established by the actual circuit and device design.

Therefore:

- **DOC-CONFIRMED:** the controller architecture can require external actuator feedback as a separate condition.
- **UNKNOWN / design-specific:** exactly what a given feedback contact proves about hydraulic pressure, ram motion, torque, stored energy, valve spool position or mechanical restraint.
- **INFERENCE:** curriculum validation must map each feedback signal to the physical claim it is allowed to support and require additional physical witness when the hazard analysis demands it.

## Human-factors consequence

A single green `READY` lamp encourages operators and maintainers to collapse the four questions above. A better HMI/diagnostic design may expose why release is blocked — protective device open, feedback circuit not returned, reset required, ordinary production start absent — while leaving safety authority in the safety subsystem.

The safer path is easier when the operator does not have to guess which reset to press repeatedly. Diagnostics should identify the unmet prerequisite without offering a bypass shortcut.

## OpenPressBrake curriculum boundary

For a press brake or other LinuxCNC machine, do not wire the conceptual architecture as `safety_ok -> LinuxCNC starts`. Teach instead:

`protective conditions + safety logic + final-element feedback -> safety release eligibility`

and separately:

`ordinary production state + fresh ordinary start request -> LinuxCNC motion request`

The actual hydraulic/mechanical safe state still requires machine-specific engineering and physical validation. Do not infer it from a generic safety-controller feedback loop.

## Failure-path review

Case A: E-stop is released but a downstream contactor feedback circuit has not returned. A reset button press must not be treated as proof that the final element is ready.

Case B: sensor and feedback conditions are valid and the safety subsystem releases the ordinary controller. An old cycle-start request remains asserted. Safety release still does not manufacture a fresh ordinary production start.

Case C: electrical valve-terminal feedback is valid but a hydraulic fault prevents the expected pressure/motion response. The feedback signal cannot be silently promoted into physical hydraulic proof.

## Evidence classification

- Separate reset/restart, actuator-feedback and controller-release functions: **DOC-CONFIRMED**.
- Exact physical meaning of any particular external feedback circuit: **UNKNOWN until circuit/device evidence is traced**.
- Requirement to bound diagnostic authority and preserve physical validation where needed: **INFERENCE grounded in the documented separation and existing course evidence**.

No simulation was justified; the useful gain came from an inspectable professional controller architecture, while the remaining physical questions are machine-specific.
