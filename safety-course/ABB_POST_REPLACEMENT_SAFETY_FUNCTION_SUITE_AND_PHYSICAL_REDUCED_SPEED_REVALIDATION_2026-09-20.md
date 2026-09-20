# ABB post-replacement safety-function suite and physical reduced-speed revalidation

Date: 2026-09-20

## Why this branch

The enabling-device search reached an information-gain stop. The next useful question was broader and directly relevant to return-to-service: does a professional machine manufacturer require a **suite** of safety function tests after controller-component replacement, and does that suite include physical machine behavior rather than only status bits?

## Current manufacturer evidence

### Replacement does not end at configuration restoration

**DOC-CONFIRMED.** ABB IRC5 Product Manual `3HAC047136-001`, Revision AC (2023), states under the maintenance schedule that function tests should be performed after replacing a component in the controller, in addition to the normal periodic intervals.

Official ABB source: https://library.e.abb.com/public/8d0c97742eed49b69255658f83639224/3HAC047136%20PM%20IRC5-en.pdf

ABB's 2024 OmniCore manuals preserve the same lifecycle principle. OmniCore V400XT lists function tests for operating modes, enabling device, stop functions and reduced-speed control, then states that after replacing a controller component the function tests should be performed. OmniCore C90XT likewise directs function testing after component replacement.

This independently reinforces the curriculum's existing replacement rule:

**COMPONENT REPLACED != CONFIGURATION RESTORED != SAFETY FUNCTIONS REVALIDATED != PRODUCTION AUTHORITY.**

### The test suite spans several different evidence layers

**DOC-CONFIRMED.** ABB's IRC5 maintenance function-test family includes, among other functions:

- mode-switch operation;
- three-position enabling-device operation;
- motor contactors;
- brake contactor;
- automatic/general stop functions;
- reduced-speed control.

The important engineering lesson is that ABB does not treat one successful controller status or one safety input as a proxy for the whole safety chain. Separate functions receive separate tests.

### Mode selection is challenged, not merely read from configuration

**DOC-CONFIRMED.** ABB's mode-switch function test starts the robot, transitions from manual to automatic and requires the robot to run in automatic for that part of the test; it then returns to manual and requires the corresponding manual-mode event to appear. Failure requires root-cause investigation.

Official ABB IRC5 source: https://library.e.abb.com/public/1f3af42176c54f899b51d6a14d0472f1/3HAC047136%20PM%20IRC5-en.pdf

This supports:

**MODE SELECTOR POSITION != MODE TRANSITION FUNCTIONALLY PROVED.**

### Enabling-device release is tied to external switching diagnostics

**DOC-CONFIRMED.** In the IRC5 motor-contactor function test, manual mode plus middle-position enabling produces the expected Motors ON state. Releasing the enabling device must produce the safety-guard-stop state; a motor-contactor conflict event is an explicit failure condition.

This is useful because it connects a personnel-operated safety input to a downstream final-element diagnostic rather than stopping at the enabling-device contact state.

It still does **not** prove instantaneous physical standstill or all hazardous-energy removal.

### Brake contactor test includes physical manipulator behavior

**DOC-CONFIRMED.** ABB's brake-contactor test instructs the tester, while maintaining eye contact with the manipulator, to move the joystick slightly to disengage the brakes and confirms that the manipulator can move. Releasing the enabling device is then expected to engage the brake/produce the documented safety state; brake-failure indication is a failed test.

This is stronger than an HMI-only check because actual manipulator response is part of the test. It is not, however, a quantitative brake holding-torque proof like the Siemens Safe Brake Test already studied elsewhere in the curriculum.

### Reduced speed is physically measured

**DOC-CONFIRMED.** ABB IRC5 §3.5.12 `Function test of reduced speed control` requires:

1. manual mode;
2. a test program commanding a known-distance move at a programmed speed above 250 mm/s;
3. execution of that move in manual mode;
4. measurement of travel time over the known distance, with sensors or I/O suggested for accuracy;
5. PASS only if actual speed does not exceed 250 mm/s; otherwise the test fails and root cause must be found.

Source: ABB IRC5 Product Manual `3HAC047136-001`, Revision AA (2023), §3.5.12, p.222: https://library.e.abb.com/public/1f3af42176c54f899b51d6a14d0472f1/3HAC047136%20PM%20IRC5-en.pdf

This provides a direct physical witness:

**REDUCED-SPEED MODE SELECTED != REDUCED SPEED PHYSICALLY PROVED.**

**SPEED LIMIT CONFIGURED != ACTUAL MACHINE SPEED MEASURED.**

## Cross-function return-to-service lesson

The ABB maintenance structure demonstrates a reusable professional pattern:

**repair/replacement -> restore system -> function-by-function challenge -> observe independent expected effects -> investigate any failed/conflicting result -> only then return the relevant functions to service.**

A single generic `safety_ok` status cannot substitute for this suite because the tests exercise different authorities and different witnesses: operating mode, enabling input, external contactor diagnostics, brake behavior, stop functions and physical speed.

## Evidence classification boundaries

- ABB procedures above: **DOC-CONFIRMED**.
- The generalized cross-machine return-to-service pattern: **INFERENCE**, derived from the manufacturer suite.
- A claim that every machine must use ABB's exact test list, 250 mm/s threshold, contactor topology, brake logic or event codes: **UNKNOWN / NOT TRANSFERABLE**.
- OpenPressBrake-specific test speed, mode set, final elements, stop category, brake/hydraulic test, PL/SIL, acceptance tolerance and test interval: **UNKNOWN** pending machine-specific engineering.

## Practical curriculum contract

For a safety-related replacement or modification, a fresh-AI engineer should build a **function-impact matrix**, not a generic reboot checklist. For each affected safety function record:

- initiating device/condition;
- selected operating mode;
- safety logic state expected;
- downstream final element expected to change;
- independent physical witness where practicable;
- quantitative acceptance criterion where the function is quantitative;
- diagnostic/conflict indication that constitutes failure;
- reset/rearm behavior;
- fresh ordinary start requirement;
- explicit disposition if the test fails.

This is **INFERENCE** as a reusable curriculum artifact, but it is grounded in ABB's manufacturer maintenance suite.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC and the normal FPGA can assist commissioning by displaying mode, event, speed, contactor, brake or other diagnostic data. They must not become the sole personnel-safety authority merely because they can aggregate those observations. Physical witnesses and independent safety functions retain their own provenance.

## Next evidence target

This branch materially improves post-replacement/return-to-service teaching. The next useful target is a manufacturer/OEM procedure that goes one step further by explicitly tying a **safety-related replacement to deliberate field input challenge, actual external final-element response, reset/rearm and a fresh production start** in one acceptance record. Lane B is independently researching networked safety-I/O identity/replacement; do not duplicate generic identity/configuration material.

If that all-in-one replacement chain remains unavailable, rotate to another safety branch rather than manufacturing a synthetic OEM procedure.

## Compute

No simulation/build/test compute was required; the question was resolved from authoritative manufacturer documentation.
