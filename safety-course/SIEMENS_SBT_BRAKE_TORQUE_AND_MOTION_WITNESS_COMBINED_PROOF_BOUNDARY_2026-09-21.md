# Siemens Safe Brake Test — combined brake-torque and motion-witness proof boundary

Date: 2026-09-21
Course branch: 4000 safety / 25E0 professional implementation tracing

## Question

Can an authoritative professional implementation be found that combines two different physical witness classes in one documented safety/return-to-service decision, rather than treating final-element status and process response as interchangeable?

## Sources

1. Siemens SINAMICS S120 Safety Integrated Function Manual, section 3.2.10 Safe Brake Test (SBT): https://support.industry.siemens.com/cs/attachments/109754301/s120_safety_fct_man_1117_eng_en-US.pdf
2. Siemens SINAMICS S210 operating instructions, Safety Integrated SBT parameter definitions: https://support.industry.siemens.com/cs/attachments/109827474/S210_S-1FK2_S-1FT2_op_instr_0424_en-US.pdf
3. Pilz Safety Compendium, safe brake functions / Safe Brake Test: https://www.pilz.com/download/open/TechBo_Pilz_safety_compendium_1004669-EN-02.pdf
4. Pilz PMCprotego Safe Motion overview: https://www.pilz.com/en-INT/products/drive-technology/servo-amplifiers/pmcprotego-safe-motion

## Evidence

### DOC-CONFIRMED — Siemens SBT deliberately challenges the brake and observes axis motion

The SINAMICS S120 manual states that Safe Brake Test checks the required holding torque of an operating or holding brake. The drive intentionally generates force/torque against the applied brake. If the brake is effective, axis motion remains within a parameterized tolerance; larger motion indicates that braking force/torque has deteriorated and maintenance is required.

This is materially stronger evidence than a brake coil command, brake-release contact, or auxiliary feedback alone. The test couples:

1. a commanded mechanical retaining state (brake applied),
2. a known active challenge from the drive (test force/torque), and
3. an independent process response (measured axis displacement/motion against a tolerance).

The S210 parameter documentation independently exposes the same structure: a configured brake holding torque, a test-torque factor, and an SBT position-tolerance parameter. This confirms that the diagnostic decision is based on challenged retaining capability plus observed motion, not merely on a brake-status bit.

### DOC-CONFIRMED — the combined test can expose mechanical degradation

Siemens explicitly describes excessive motion during the challenged test as evidence that braking force/torque has deteriorated and maintenance is required. Pilz independently describes SBT as an automatic test intended to detect faults in brake control and mechanics, and notes that a negative result can stop the plant and signal a fault.

### INFERENCE — this is a two-witness *test architecture*, not a universal continuous safe-state proof

The SBT evidence supports a bounded claim: under the configured test conditions, the applied brake resisted the configured challenge without exceeding the configured motion tolerance. It does not prove that every future stop will succeed, that brake torque remains adequate indefinitely, that all transmission elements are intact under every load, or that another hazardous-energy path is safe.

Likewise, the motion witness is meaningful only in relation to the configured test force/torque, tolerance, mechanics, sensor chain, and validated application assumptions.

### UNKNOWN / source limit — generic post-failure restart semantics

The public material inspected in this pass clearly exposes test torque, position tolerance, pass/fail intent, and maintenance consequence. It did not provide enough authoritative evidence in the inspected passages to freeze a universal post-failure restart algorithm such as "repair alone restores operation" or "a particular reset edge is always required." Do not import restart semantics from Rockwell SBC, Siemens 3SK1, or another product family into SBT.

## Curriculum freezes

- **BRAKE COMMAND/STATUS != BRAKE HOLDING CAPABILITY PROVED.**
- **BRAKE HOLDING CAPABILITY PROOF REQUIRES A DEFINED CHALLENGE AND A DEFINED RESPONSE ACCEPTANCE CRITERION when SBT-style proof is claimed.**
- **SBT PASS != ALL HAZARDOUS ENERGY SAFE.**
- **SBT PASS != FUTURE BRAKE PERFORMANCE GUARANTEED.**
- **MOTION WITHIN TEST TOLERANCE != ZERO MOTION.**
- **TEST TORQUE APPLIED != ACTUAL MACHINE WORST-CASE LOAD unless the design-specific validation establishes that relationship.**
- **BRAKE TEST PASS != ORDINARY START AUTHORITY.**
- **BRAKE TEST FAILURE CLEARED != FRESH ORDINARY DEMAND unless the actual implementation explicitly proves that restart semantic.**

## Reusable witness-chain model

For safety-course reviews, describe the chain with typed evidence rather than one `safe` bit:

`brake command -> brake applied state -> deliberate test torque/force -> measured axis response -> acceptance against position tolerance -> brake-test result -> safety rearm/return-to-service logic -> fresh ordinary motion demand`

Each arrow must name the actual device/function providing evidence. A later OpenPressBrake design must not copy Siemens torque, position, timing, PL/SIL, proof-test interval, or reset values. Those are design-specific.

## Human-factors implication

A proof test is useful only if failure disposition is difficult to bypass accidentally. A practical machine should present a failed proof as a clearly identified maintenance/commissioning state, prevent normal production handoff until the defined corrective/validation process is complete, and require a fresh ordinary production demand after safety eligibility is restored. Personnel-safety authority remains in the independent safety architecture; LinuxCNC may display diagnostics and enforce additional ordinary-control gates but must not be promoted to safety authority by convenience.

## Information-gain result

The narrow search target is satisfied: Siemens SBT is an authoritative professional implementation combining a final mechanical retaining element with an independent process-motion witness under a deliberate challenge. What remains unresolved is not the existence of such an architecture, but the exact return-to-service state machine after SBT failure for a specific SINAMICS configuration.

The next useful branch should therefore compare this *active proof-test* pattern with a machine implementation that uses two witness classes continuously or during every hazardous transition, or trace a documented SBT failure/restart sequence if authoritative source exposes it without ambiguity.
