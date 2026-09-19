# SafeZone Contactor / Stop-Validation / Rear-Access Gap Trace — 2026-09-19

## Purpose
Continue Lane B from `AREA_SCANNER_REAR_ACCESS_RESTART_INTERLOCK_AUTHORITY_STUDY_2026-09-18.md` using a complete professional safety-function implementation rather than another isolated component manual.

This study deliberately records both what the implementation proves and what it does **not** prove. It does not assign OpenPressBrake scanner geometry, stopping time/distance, PL/SIL/category/DC, hydraulic behavior, or a requirement to use this architecture.

## Evidence labels
- **SOURCE-CONFIRMED** — directly stated/shown by manufacturer application or device documentation.
- **DOC-CONFIRMED** — established by durable curriculum documentation.
- **TEST-CONFIRMED** — requires retained execution evidence; none newly claimed here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence.
- **UNKNOWN** — not established by the available implementation.

## Professional implementation traced
Rockwell Automation publication `SAFETY-AT137B-EN-P`, *Safety Function: Safety-Related Stop Initiated by a SafeZone Scanner*, January 2016, provides a complete scanner -> safety evaluator -> redundant final switching elements -> motor-power removal -> validation/fault-injection example.

Primary source:
https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at137_-en-p.pdf

Current scanner behavior cross-check:
https://literature.rockwellautomation.com/idc/groups/literature/documents/um/442l-um003_-en-p.pdf

## End-to-end chain

### 1. Protective-field intrusion
**SOURCE-CONFIRMED:** the SafeZone scanner supplies two PNP outputs to the Guardmaster 440C-CR30 safety relay. Interruption of the configured sensing zone de-energizes the scanner outputs.

### 2. Independent safety evaluator
**SOURCE-CONFIRMED:** the 440C-CR30 evaluates the scanner and E-stop safety inputs and drives two safety outputs. The application does not place this authority in an ordinary machine PLC, LinuxCNC, HAL, or a normal FPGA motion controller.

### 3. Physical final elements
**SOURCE-CONFIRMED:** the two safety outputs control two 100S-C safety contactor coils. De-energizing the contactors removes motor power. The motor then coasts to a stop in this particular example.

This supports the architecture chain:

`protective-field intrusion -> scanner safety outputs OFF -> safety relay outputs OFF -> K1/K2 drop -> motor power removed -> hazardous motion stops`

The motor/contactor topology is specific to this application and is **not** a hydraulic press-brake topology.

### 4. Final-element feedback / EDM-like proof
**SOURCE-CONFIRMED:** one normally-closed auxiliary contact from each safety contactor participates in the feedback/reset circuit. The safety outputs can only re-energize when both contactors are in the expected de-energized state. The validation checklist deliberately removes contactor feedback and verifies that Stop followed by Reset cannot restart/reset the safety relay.

This is stronger than checking only the commanded output bit: the safety evaluator receives state evidence from the external switching elements.

### 5. Physical stop witness is a separate commissioning proposition
**SOURCE-CONFIRMED:** the validation procedure does not stop at `K1/K2 de-energized`. During a feedback-fault test it separately requires hazardous motion to stop within the application-specific validated interval. The exact interval belongs to this example and is not transferable to another machine.

**INFERENCE:** the checklist structure itself is valuable: final-element state and physical stopping performance are distinct propositions and should be validated separately.

Freeze:

**SAFETY OUTPUT OFF != CONTACTORS DE-ENERGIZED/OPEN != MOTOR POWER REMOVED != HAZARDOUS MOTION PHYSICALLY STOPPED != STOP PERFORMANCE ACCEPTABLE.**

### 6. Fault retention and recovery
**SOURCE-CONFIRMED:** the application injects output/contactor faults. Certain injected faults trip the safety relay, leave the red fault indication on, and do not clear merely from a Reset action. The documented test removes the injected fault, power-cycles the safety relay where required by that implementation, then performs Reset and finally a separate external Start before hazardous motion resumes.

Freeze:

**FAULT SOURCE REMOVED != FAULT LATCH CLEARED != SAFETY RESET/REARM COMPLETE != FRESH ORDINARY START.**

The exact requirement to power-cycle is implementation-specific; do not turn it into a universal safety rule.

### 7. Reset is not Start
**SOURCE-CONFIRMED:** Rockwell states that releasing E-stop does not restart hazardous motion; after faults are cleared and Reset is performed, the system is enabled to accept a separate Start command. The validation tables likewise distinguish Reset from external Start.

Freeze:

**RESET ACCEPTED != HAZARDOUS MOTION STARTED.**

For LinuxCNC/OpenPressBrake teaching, stale `START/JOG/ENABLE` must not be treated as fresh intent merely because independent safety authority returns.

## Critical rear-access limitation exposed by the same evidence set

The Rockwell AT137 implementation closes the scanner -> safety evaluator -> contactors -> motor-power-removal -> physical-stop-validation -> feedback-fault -> recovery -> separate-start chain. It does **not** by itself demonstrate that a person who crosses the scanner field and then stands beyond that field remains continuously detected.

The current SafeZone user manual explicitly says restart interlock is needed where a person cannot be detected at every point in the hazard area, and requires the reset/restart control to be outside the hazardous area with a clear view of the hazardous area and not operable by a person inside it.

Therefore the complete application example must not be over-read as personnel-clear proof.

Freeze:

**SCANNER FIELD CLEAR != PERSONNEL CLEAR.**

**CONTACTOR FEEDBACK VALID != RETAINED/BLIND AREA CLEAR.**

**PHYSICAL MOTION STOPPED != SAFE TO RESTART WHILE A PERSON MAY REMAIN INSIDE.**

This is a useful negative result: a complete, well-validated safety stop function can still require a separate restart-prevention/personnel-clear architecture when bodily entry or rear access exists.

## Commissioning/adversarial tests derived from the implementation

1. Interrupt protective field while running: verify safety outputs change, both final contactors drop, power-removal path acts, and actual hazardous motion reaches the required physical stop condition.
2. Hold protective field interrupted and issue ordinary Start: hazardous motion must remain inhibited.
3. Clear protective field without deliberate reset where restart interlock is required: no hazardous restart.
4. Remove one scanner channel or inject the documented channel faults: final elements must transition to the safe reaction and diagnostics must expose the fault.
5. Break one final-element feedback path: demand Stop then Reset; rearm must remain blocked.
6. Force one contactor output path incorrectly: verify the companion safety path produces the documented stop reaction and the safety fault remains latched as specified by the actual device.
7. Remove the injected fault: verify the implementation-specific fault-clear procedure; do not treat physical repair as automatic rearm.
8. Reset/rearm: verify Reset itself does not command motion.
9. Issue a new external Start only after safety authority is restored: verify hazardous motion resumes only from that separate action.
10. Rear-access challenge: allow a person to cross the protective field and then stand in a location not covered by the active field. If the architecture has no independent personnel-retention/rear-access proof, classify the design as insufficient for exposed operation rather than accepting `field clear` as personnel-clear.
11. Reset-location challenge: verify the reset operator can inspect the intended hazardous area and that reset cannot be actuated by a person remaining inside, when this method is relied upon.
12. Stale ordinary command challenge: hold an ordinary LinuxCNC/PLC Start-like request through the safety interruption. Returning safety authority must not convert that stale request into a fresh production initiation.

## Human-factors consequence
Where a person can disappear beyond the scanner field, relying on an operator to remember that somebody entered is a weak architecture. Prefer a safety-side design that makes restart prevention automatic or positively requires personnel-clear evidence. If the required clear-view reset position is impractical, that inconvenience is evidence to redesign the safeguarding/personnel-retention method rather than encouraging a bypass or poorly placed reset control.

If a machine cannot establish the required personnel-clear condition and physical hazard-safe condition, it should not be operated with people exposed to the hazard. Experimental operation must be isolated/remote with people outside the danger zone and residual risk explicit.

## LinuxCNC / FPGA boundary
LinuxCNC, HAL and the ordinary FPGA may display scanner state, final-element diagnostics, stop state and safety permissives. They may sequence normal production only after independent safety authority exists. They must not become the sole authority for:
- personnel-clear memory;
- scanner restart interlock relied upon for bodily-entry protection;
- final-element safety feedback evaluation;
- physical stop-performance acceptance;
- safety reset/rearm.

## Evidence status
- Complete scanner -> safety evaluator -> redundant contactor -> motor power-removal chain: **SOURCE-CONFIRMED**.
- Contact feedback preventing reset/restart on disagreement: **SOURCE-CONFIRMED**.
- Separate physical stop-performance validation in the application checklist: **SOURCE-CONFIRMED**.
- Fault removal followed by implementation-specific fault clearing, Reset, then separate Start: **SOURCE-CONFIRMED**.
- Need for restart interlock/visible reset where a person can remain beyond the protective field: **SOURCE-CONFIRMED** by current SafeZone manual.
- OpenPressBrake needs this exact scanner/contactor architecture: **UNKNOWN**.
- OpenPressBrake reset location, personnel-clear method, stop performance, hydraulic reaction, PL/SIL/category/DC: **UNKNOWN**.

## Information gained / information still missing
This session closes the requested complete **safety stop / final-element / physical-stop / fault-retention / reset / separate-start** chain for a professional stationary-machine example.

It also proves why that chain is not yet a complete **rear-access personnel-clear** implementation: the example does not provide continuous retained-area presence proof after a person leaves the scanner field.

The next highest-value Lane-B evidence target is therefore narrower:

`person crosses access field -> hazardous motion physically stopped -> person leaves field but remains inside -> safety-side retained-area/personnel-clear mechanism keeps restart inhibited -> deliberate exit/clear procedure -> reset from a valid observation position -> final-element proof -> safety rearm -> separate fresh Start`

Prefer an OEM/manufacturer implementation that shows both the entrance protective device and a second inside-area presence detector, trapped-key/personnel key, lockout/personnel-retention mechanism, or safety-controller presence memory. A mere statement that an operator should look inside is weaker evidence than a positive safety-side retained-area mechanism.

## Compute
No simulation, build, synthesis, benchmark or test suite was justified. No GitHub-hosted runner and no self-hosted runner compute was used.
