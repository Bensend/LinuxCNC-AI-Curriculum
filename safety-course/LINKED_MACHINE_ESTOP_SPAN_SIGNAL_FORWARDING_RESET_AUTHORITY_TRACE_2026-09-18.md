# Linked-machine E-stop span, signal forwarding, and reset authority trace

Date: 2026-09-18

## Question

For a linked machine/line with local safety zones, what professional evidence exists for the chain from an E-stop in one functional unit through its intended span of control, adjacent-machine hazard assumptions, output reaction, reset, and return of ordinary production authority?

This study is intentionally generic. It does **not** define an OpenPressBrake E-stop span, stop category, hydraulic reaction, stopping time/distance, PL/SIL/category/DC, or final-element design.

## Evidence classifications

### Pilz myPNOZ signal-forwarding application

**DOC-CONFIRMED — manufacturer application documentation.** Pilz application description `myPNOZ: Signal forwarding to another myPNOZ`, document 1005677-EN-02, states that when E-STOP ES2 is operated or an error occurs, outputs of all zones of the involved myPNOZ are reset. It also states explicitly that this E-stop affects the relevant functional unit and feeding assembly line, and that continued operation of upstream/downstream devices must be shown not to present a hazard.

Source: https://www.pilz.com/download/open/myPNOZ_Signalforwarding_1005677-EN-02.pdf

The same application documents reset behavior: with the configured start type, cold start, warm start, or reactivation of the E-stop requires a reset with a rising and falling edge before the output is set again.

**Important boundary:** this is evidence for the documented Pilz example, not a universal permission to leave adjacent equipment running. The adjacent-equipment continuation is conditional on the hazard assessment.

### Pilz myPNOZ global/local zone architecture

**DOC-CONFIRMED.** Pilz documents up to eight independently monitored safety zones and a global safety function in the head module that can act on all zones. This provides a professional example of both local-zone and whole-machine/global authority in one safety architecture.

Source: https://www.pilz.com/en-AU/company/news/articles/229267

### Siemens Automation Framework

**DOC-CONFIRMED — manufacturer framework documentation.** Siemens Automation Framework V1.2 defines a safety zone as a unit containing multiple safety functions and an actuator network. Its E-stop example safely shuts down drives using STO. Actuators are controlled in the zone actuator network because one actuator may be affected by several safety functions. The framework also summarizes zone release/acknowledgement state.

Source: https://support.industry.siemens.com/cs/attachments/109817223/109817223_Automation_Framework_DOC_V1_2_en.pdf

Siemens explicitly warns that the framework's global acknowledgement must be adapted to the real machine. It distinguishes HMI acknowledgement from safety-related transfer and provides mechanisms for fail-safe acknowledgement/reintegration rather than treating an ordinary HMI bit as inherently safe.

### Siemens LSafe E-stop drive function

**DOC-CONFIRMED.** `LSafe_EStopDrives` exposes distinct inputs for `acknowledge`, `start`, `stop`, and `eStop`, and distinct outputs for STO, drive enable, E-stop release, and acknowledgement requested. This is useful evidence that professional safety logic does not need to collapse E-stop reset and ordinary start into one authority.

Source: https://support.industry.siemens.com/cs/attachments/109793462/109793462_LSafe_DOC_V1_0_en.pdf

## Authority trace

A defensible linked-machine trace is:

`E-stop device/location`
`-> defined local/global span`
`-> safety evaluator`
`-> zone actuator network / final safety outputs`
`-> physical machine reaction`
`-> adjacent-zone hazard consequence checked`
`-> stop remains latched as required`
`-> E-stop device restored`
`-> deliberate safety reset/acknowledgement`
`-> safety outputs eligible to return`
`-> separate ordinary production START where required by the machine design`

The key teaching point is that **span selection is part of the safety function**. A local stop is not justified merely because the controls can be partitioned into zones.

## Freeze

`LOCAL E-STOP ACTUATED != ONLY LOCAL HAZARD EXISTS != ADJACENT EQUIPMENT MAY CONTINUE SAFELY != ALL RELEVANT FINAL ELEMENTS REACTED != PHYSICAL HAZARD ABSENT != RESET PERMITTED != PRODUCTION START AUTHORIZED.`

`GLOBAL SAFETY INPUT != EVERY ORDINARY CONTROL SIGNAL GLOBAL.`

`E-STOP DEVICE RESTORED != SAFETY RESET COMPLETE != ACTUATOR RELEASE COMPLETE != FRESH ORDINARY START.`

`HMI SHOWS RESET != SAFETY ACKNOWLEDGEMENT PATH VALID.`

## Failure/adversarial review

1. **Wrong span configured.** Pressing a local E-stop removes one unit's outputs while an upstream/downstream conveyor, robot, feeder, transfer mechanism, or gravity/hydraulic hazard can still injure a person in the affected space. Result: local output reaction may be correct while the safety function is wrong at the machine-system level.
2. **Forwarded safety signal lost or misassigned.** Treat loss/fault according to the safety architecture; do not substitute an ordinary PLC/LinuxCNC network bit as the sole cross-unit safety authority.
3. **Adjacent machine continues by design.** Validation must demonstrate that its continued operation cannot create the hazard that the local E-stop is intended to control. The Pilz example states this condition explicitly.
4. **Reset performed from an HMI.** A normal HMI communication path is not automatically a safety reset path. Siemens specifically calls out safe-transfer measures for HMI acknowledgement.
5. **Cold/warm restart.** Do not assume power return or STOP->RUN transition restores outputs. The Pilz example deliberately requires reset under its configured start behavior.
6. **Stale ordinary command.** LinuxCNC/HAL/ordinary FPGA START, JOG, cycle request, conveyor request, DOWN, or ENABLE that remained asserted through the E-stop must not be reinterpreted as fresh operator intent merely because safety outputs become eligible again.
7. **Electrical safe output but residual energy remains.** STO or de-energized contactors do not by themselves prove gravity, hydraulic, pneumatic, thermal, stored mechanical, or process hazards absent.

## Commissioning checks derived from the evidence

For each E-stop device, record its intended span and physically challenge every relevant hazardous actuator inside and adjacent to that span. Verify the actual final-element reaction, not only the safety-controller bit. For any adjacent equipment allowed to continue, document why that continuation cannot create a hazard in the stopped span and challenge foreseeable transfer/coupling paths.

Challenge power cycle, controller STOP/RUN, restored E-stop device, reset from every permitted station, wrong reset station, communication loss between linked safety controllers, one failed final element, and stale ordinary production commands. Confirm that restoring the safety function does not itself create hazardous motion.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC may receive diagnostic state such as `E_STOP_ACTIVE`, `ZONE_INHIBITED`, `SAFETY_READY`, or an ordinary run permissive, but LinuxCNC/HAL and the normal FPGA controller must not become the sole authority that decides personnel-safety E-stop span, cross-zone safety forwarding, or reset validity.

For a press brake specifically, no inference is made here that STO, pump contactor removal, valve de-energization, or any generic zone output proves the beam/load safe. The physical final-element and retained-energy evidence remains machine-specific and must be validated separately.

## Evidence status

The linked-zone architecture, explicit adjacent-hazard condition, configured reset behavior, zone actuator network, and separation of acknowledgement/start are **DOC-CONFIRMED** from manufacturer documentation.

A complete public same-machine trace that exposes every internal voting path, actual physical final-element feedback, adjacent-unit failure injection, and separate production START remains **UNKNOWN** from the evidence inspected in this session.

No executable lab is justified by this evidence gap: the unresolved questions are implementation- and machine-specific and are better answered by authoritative application/wiring/commissioning evidence than by synthetic simulation.

## Next evidence target

Find a professional linked-cell or transfer-line implementation exposing two overlapping/different E-stop spans with actual final elements and commissioning behavior:

`device/location -> span mapping -> cross-unit safety communication -> evaluator -> final element -> physical witness -> adjacent-zone behavior -> latched state -> reset/rearm -> separate production START`.

Prefer documentation containing a failed cross-unit communication or wrong-span commissioning case. Preserve `UNKNOWN` rather than inventing the physical machine response.
