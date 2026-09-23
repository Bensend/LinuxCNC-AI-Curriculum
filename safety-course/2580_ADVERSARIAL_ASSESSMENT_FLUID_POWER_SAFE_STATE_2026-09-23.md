# 2580 — Adversarial assessment: fluid-power safe state

## Assessment purpose

Test whether the learner can reason from a hazardous physical state backward through fluid-power final elements, diagnostics and independent safety control without substituting an electrical command, valve-position bit or catalog safety label for physical proof.

This assessment contains no machine-specific answer key. It is suitable for learner-facing use. Exact pressure thresholds, stopping times, PL/SIL, valve truth tables and load capacities are intentionally absent.

## Required answer discipline

For every scenario, the learner must produce this chain:

`hazard -> required physical safe-state proposition -> fluid/mechanical final element(s) -> diagnostic witness(es) -> independent safety-related control -> normal-control boundary -> residual UNKNOWNs -> validation evidence needed`

For every witness, state both **what it proves** and **what it does not prove**.

## Scenario 1 — Two electrical channels, one hydraulic throat

A vertical hydraulic axis has two independent safety-controller outputs. Both must agree before motion is permitted. The outputs drive separate coils/pilots, but the circuit ultimately relies on one common hydraulic element/path whose dangerous failure can preserve pressure/flow to the cylinder. LinuxCNC reports both safety-permit inputs false after an E-stop.

Tasks:

1. Decide whether “dual-channel electrical safety” establishes redundancy at the hazardous-motion final element.
2. Identify the common-dependency question that must be resolved before any Category/PL/SIL claim.
3. State what LinuxCNC's two false permit indications prove and do not prove.
4. Propose the minimum additional architecture/evidence questions needed to establish `hazardous descent prevented`.
5. State what remains UNKNOWN.

Critical trap: counting wires or safety outputs instead of physical dangerous-failure paths.

## Scenario 2 — The pressure gauge says zero

The pump contactor is open, the main supply shutoff is reported closed, and one pressure transducer near the manifold reads low. A check valve and blocked actuator port can isolate a cylinder chamber. An accumulator exists elsewhere in the circuit but its relationship to the hazardous chamber has not yet been traced.

Tasks:

1. Decide whether maintenance access to the crush zone is justified by the low reading.
2. Draw a volume/energy inventory showing every location that could remain pressurized or load-induced.
3. State the exact proposition supported by the transducer.
4. Identify what circuit evidence would show whether the accumulator can feed the hazardous volume.
5. Identify what physical isolation/decompression/restraint evidence would be required before exposed maintenance.

Critical trap: `pressure low here` -> `energy absent everywhere`.

## Scenario 3 — Stuck directional spool with a gravity load

On a safety demand, the controller commands the directional valve neutral and receives a position-disagreement fault. The pump is then disabled. The vertical load can descend under gravity if its load-holding path is ineffective.

Tasks:

1. Separate the directional-control, supply-isolation and load-holding propositions.
2. Explain why pump shutdown is not automatically the gravity-load safety function.
3. Identify which physical final element must address the load after active drive force disappears.
4. Explain how the position-disagreement diagnostic should influence rearm/restart without claiming it physically holds the load.
5. Specify validation questions without inventing load capacity, leakage or stopping distance.

## Scenario 4 — Hose failure downstream of the nice-looking valve block

A circuit uses a monitored upstream valve block and has excellent electrical diagnostics. A hose between that block and a vertical actuator ruptures. The load-holding strategy has never been analyzed for this failure location.

Tasks:

1. Trace how the rupture changes the intended hydraulic path.
2. Decide whether upstream monitored-valve state alone establishes safe load behavior.
3. Identify where hose-failure/load-holding protection would need to act in principle, while avoiding a machine-specific component prescription.
4. Identify the evidence needed for the actual load, installation and failure mode.
5. Explain when mechanical restraint becomes the appropriate maintenance/exposure measure.

Critical trap: treating a safety-oriented manifold as proof against every downstream physical failure.

## Scenario 5 — Pneumatic safe exhaust, trapped local volume

A dual monitored safe-exhaust valve removes supply and opens its exhaust path. A downstream machine module contains a check valve and local reservoir. One cylinder chamber can therefore retain pressure after the upstream system exhausts. The safe-exhaust valve reports both main elements in their expected positions.

Tasks:

1. State what the valve-position feedback proves.
2. State why it does not prove the cylinder chamber is de-energized.
3. Identify the trapped-volume architecture error.
4. Describe what pressure/force proposition must be validated at the hazard.
5. Explain whether the component's documented safety capability can be transferred unchanged to the complete machine.

## Scenario 6 — Repressurization becomes the hazard

After a guard event, the operator closes the guard and presses RESET. The pneumatic system immediately repressurizes. A cylinder that had drifted while exhausted moves as pressure returns. Normal LinuxCNC Cycle Start was never pressed.

Tasks:

1. Separate guard restoration, safety reset/rearm, safe energization/repressurization and normal cycle start.
2. Identify why immediate full repressurization can itself be a hazardous event.
3. Explain what a controlled/soft energization function can contribute and what still requires machine-level validation.
4. Propose a human-factors-friendly recovery sequence that does not reward bypassing the guard or exhaust function.
5. State why ordinary LinuxCNC should not become the sole personnel-safety authority merely because it can sequence recovery conveniently.

## Scenario 7 — Cylinder seal failure during maintenance

A hydraulic axis is stopped, electrically inhibited and nominally depressurized. A technician enters beneath a raised load. The maintenance procedure relies on valves and pressure indication but has no positive mechanical restraint. A cylinder/seal failure is considered credible for the maintenance task.

Tasks:

1. Decide whether a functional fluid-power stop is enough for this maintenance exposure.
2. Distinguish operational safeguarding from maintenance energy/load control.
3. Identify the physical proposition a mechanical restraint would need to establish.
4. State what a restraint-presence sensor could and could not prove.
5. Give the release decision if the load cannot be positively controlled while a person is exposed.

Critical safety rule: if the minimum safe-to-operate/maintain physical proposition cannot be established, people do not enter the danger zone; experimental work must be isolated/remote.

## Scenario 8 — Replacement drift

A failed monitored valve is replaced with a part that has the same port size, voltage and nominal flow rating. Its spool arrangement, leakage behavior, position-monitoring implementation and safety documentation differ.

Tasks:

1. Explain why apparent functional equivalence is insufficient.
2. Identify the affected safety-function assumptions and validation artifacts.
3. Decide what must be revalidated before return to service.
4. State which claims remain UNKNOWN until that evidence exists.
5. Explain how change control should prevent “it fits and cycles” from becoming the release criterion.

## Scoring dimensions for a fresh evaluator

Evaluate independently on:

- physical hazard/safe-state reasoning;
- separation of directional blocking, supply isolation, decompression and load holding;
- stored-energy and trapped-volume reasoning;
- gravity/external-load reasoning;
- diagnostic-witness precision;
- common-dependency/CCF recognition;
- maintenance restraint/isolation boundary;
- pneumatic safe-exhaust and repressurization reasoning;
- LinuxCNC/FPGA authority boundary;
- uncertainty discipline and refusal to invent machine-specific values;
- validation/release reasoning;
- practical human factors.

## Critical-fail conditions

Any of these is a critical miss requiring correction before 2580 can be treated as transferable:

- declaring a gravity/suspended load safe solely because the pump or electrical command is off;
- declaring all fluid energy absent from one low pressure reading;
- treating valve-position feedback as proof of downstream pressure or load state;
- treating two electrical channels as proof of independent hydraulic final elements;
- transferring a component PL/SIL/category claim directly to the complete machine;
- authorizing exposed maintenance where credible load motion remains uncontrolled;
- making ordinary LinuxCNC/HAL/FPGA logic the sole personnel-safety authority without evidence;
- inventing a pressure threshold, stopping time, diagnostic coverage, load capacity or achieved PL/SIL.

## Release-gate intent

This assessment should be followed by a syllabus coverage audit. Passing a self-review is not external competency evidence; the eventual fresh evaluator must remain information-separated from any hidden scoring key or expected scenario resolution.