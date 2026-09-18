# Linked-machine E-stop span, signal forwarding, and reset authority trace

Date: 2026-09-18

## Question

For a linked machine/line with local safety zones, what professional evidence exists for the chain from an E-stop in one functional unit through its intended span of control, adjacent-machine hazard assumptions, output reaction, reset, and return of ordinary production authority?

This study is intentionally generic. It does **not** define an OpenPressBrake E-stop span, stop category, hydraulic reaction, stopping time/distance, PL/SIL/category/DC, or final-element design.

## Evidence classifications

### Pilz myPNOZ three-functional-unit signal-forwarding application

**DOC-CONFIRMED — manufacturer application documentation.** Pilz application description `myPNOZ: Signal forwarding to another myPNOZ`, document 1005677-EN-02, provides a concrete linked-unit topology rather than only a generic zone statement.

The example separates FU1, FU2 and FU3 into safety zones. Its documented propagation includes:

- FU2 E-STOP ES2, connected to FU2's global safety input, stops FU2 and forwards through FU2 zone 1 into FU1 zone 2 so the FU1 assembly line AL1 feeding FU2 is stopped.
- FU1 E-STOP ES1 also stops AL1.
- FU3 E-STOP ES3 propagates through FU3 zone 1 into FU2 zone 2 so FU2 assembly line AL2 is stopped.
- FU2 zone 3 stops functional unit 2 when either FU2 E-STOP ES2 is triggered or FU2 safety gate SG2 is triggered.
- Pilz describes the zone construction itself: upstream inputs directly affect downstream outputs; adding an output after an input creates a new zone; the head-module global input affects outputs of all zones.

Source: https://www.pilz.com/download/open/myPNOZ_Signalforwarding_1005677-EN-02.pdf

The same application states that when E-STOP ES2 is operated or an error occurs, outputs of all zones of the involved myPNOZ are reset. It explicitly cautions that this E-stop affects the relevant functional unit and feeding assembly line and that continued operation of upstream/downstream devices must not present a hazard.

The example also documents reset behavior: with its configured start type, cold start, warm start, or reactivation of the E-stop requires a reset with a rising and falling edge before the output is set again.

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
`-> safety-rated cross-unit forwarding where required`
`-> receiving zone evaluator`
`-> zone actuator network / final safety outputs`
`-> physical machine reaction`
`-> adjacent-zone hazard consequence checked`
`-> stop remains latched as required`
`-> E-stop device restored`
`-> deliberate safety reset/acknowledgement`
`-> safety outputs eligible to return`
`-> separate ordinary production START where required by the machine design`

The key teaching point is that **span selection is part of the safety function**. A local stop is not justified merely because the controls can be partitioned into zones. The Pilz FU1/FU2/FU3 example additionally demonstrates that span can propagate directionally across linked units according to material/machine interaction rather than matching a single controller enclosure.

## Freeze

`LOCAL E-STOP ACTUATED != ONLY LOCAL HAZARD EXISTS != ADJACENT EQUIPMENT MAY CONTINUE SAFELY != ALL RELEVANT FINAL ELEMENTS REACTED != PHYSICAL HAZARD ABSENT != RESET PERMITTED != PRODUCTION START AUTHORIZED.`

`SAFETY ZONE BOUNDARY != CONTROLLER/ENCLOSURE BOUNDARY != MATERIAL-TRANSFER HAZARD BOUNDARY.`

`GLOBAL SAFETY INPUT != EVERY ORDINARY CONTROL SIGNAL GLOBAL.`

`E-STOP DEVICE RESTORED != SAFETY RESET COMPLETE != ACTUATOR RELEASE COMPLETE != FRESH ORDINARY START.`

`HMI SHOWS RESET != SAFETY ACKNOWLEDGEMENT PATH VALID.`

## Failure/adversarial review

1. **Wrong span configured.** Pressing a local E-stop removes one unit's outputs while an upstream/downstream conveyor, robot, feeder, transfer mechanism, or gravity/hydraulic hazard can still injure a person in the affected space. Result: local output reaction may be correct while the safety function is wrong at the machine-system level.
2. **Forwarded safety signal lost or misassigned.** In the Pilz topology, a downstream unit's E-stop can deliberately stop the upstream assembly line feeding it. Misrouting that propagation can therefore leave a transfer hazard active even though the originating unit itself stopped. Treat forwarding faults according to the safety architecture; do not substitute an ordinary PLC/LinuxCNC network bit as the sole cross-unit safety authority.
3. **Adjacent machine continues by design.** Validation must demonstrate that its continued operation cannot create the hazard that the local E-stop is intended to control. The Pilz example states this condition explicitly.
4. **Reset performed from an HMI.** A normal HMI communication path is not automatically a safety reset path. Siemens specifically calls out safe-transfer measures for HMI acknowledgement.
5. **Cold/warm restart.** Do not assume power return or STOP->RUN transition restores outputs. The Pilz example deliberately requires reset under its configured start behavior.
6. **Stale ordinary command.** LinuxCNC/HAL/ordinary FPGA START, JOG, cycle request, conveyor request, DOWN, or ENABLE that remained asserted through the E-stop must not be reinterpreted as fresh operator intent merely because safety outputs become eligible again.
7. **Electrical safe output but residual energy remains.** STO or de-energized contactors do not by themselves prove gravity, hydraulic, pneumatic, thermal, stored mechanical, or process hazards absent.
8. **One forwarded path tested, another assumed.** The FU1/FU2/FU3 topology contains different propagation paths. Commissioning one E-stop does not prove the neighboring device's span, receiving zone, or outputs.

## Commissioning checks derived from the evidence

For each E-stop device, record its intended span and physically challenge every relevant hazardous actuator inside and adjacent to that span. Verify the actual final-element reaction, not only the safety-controller bit. For any adjacent equipment allowed to continue, document why that continuation cannot create a hazard in the stopped span and challenge foreseeable transfer/coupling paths.

For linked units, build an E-stop span matrix: rows are E-stop/protective devices and columns are hazardous functions/final elements across all adjacent units. Challenge every required intersection physically. A matrix is a commissioning aid, not a substitute for the risk assessment that determines which intersections are required.

Challenge power cycle, controller STOP/RUN, restored E-stop device, reset from every permitted station, wrong reset station, loss/misassignment of cross-unit safety forwarding, one failed final element, and stale ordinary production commands. Confirm that restoring the safety function does not itself create hazardous motion.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC may receive diagnostic state such as `E_STOP_ACTIVE`, `ZONE_INHIBITED`, `SAFETY_READY`, or an ordinary run permissive, but LinuxCNC/HAL and the normal FPGA controller must not become the sole authority that decides personnel-safety E-stop span, cross-zone safety forwarding, or reset validity.

For a press brake specifically, no inference is made here that STO, pump contactor removal, valve de-energization, or any generic zone output proves the beam/load safe. The physical final-element and retained-energy evidence remains machine-specific and must be validated separately.

## Evidence status

The three-functional-unit linked-zone topology, directional safety-signal propagation, explicit adjacent-hazard condition, configured reset behavior, Siemens zone actuator network, and separation of acknowledgement/start are **DOC-CONFIRMED** from manufacturer documentation.

A complete public same-machine trace that exposes every internal voting path, actual physical final-element feedback, injected cross-unit forwarding failure, and separate production START remains **UNKNOWN** from the evidence inspected in this session.

No executable lab is justified by this evidence gap: the unresolved questions are implementation- and machine-specific and are better answered by authoritative application/wiring/commissioning evidence than by synthetic simulation.

## Next evidence target

Use the Pilz FU1/FU2/FU3 topology as the professional linked-line baseline and seek its wiring/commissioning detail or a comparable implementation exposing:

`device/location -> span matrix -> cross-unit safety forwarding -> receiving evaluator -> final element -> physical witness -> adjacent-zone behavior -> forwarding fault -> latched state -> reset/rearm -> separate production START`.

Prefer documentation containing a failed cross-unit communication, wrong-span commissioning case, or actual output/contactor/drive feedback. Preserve `UNKNOWN` rather than inventing the physical machine response.
