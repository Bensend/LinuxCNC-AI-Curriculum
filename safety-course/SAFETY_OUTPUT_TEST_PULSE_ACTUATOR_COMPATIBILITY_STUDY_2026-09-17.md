# Safety Output Test-Pulse / Actuator Compatibility Study

Date: 2026-09-17
Lane: independent safety curriculum Lane B

## Question

When a safety controller, relay, or protective device deliberately inserts short OFF pulses into an otherwise ON safety output for diagnostics, what must be proven about the receiving final element or downstream safety input before that diagnostic scheme can be credited?

## Frozen architecture rule

`SAFETY OUTPUT HIGH != CONTINUOUS HIGH`.

`TEST PULSE GENERATED != RECEIVER COMPATIBLE != FINAL ELEMENT UNAFFECTED != DIAGNOSTIC COVERAGE PRESERVED`.

A safety output's diagnostic pulse scheme and the receiving device's input/actuator behavior form one interface contract. Pulse width, repetition, load capacitance/inductance, input filtering, dropout behavior, fault detection, and any permitted pulse-test disable mode must be taken from the actual selected devices. Do not infer compatibility from nominal 24-V levels alone.

## Evidence

### Rockwell MSR57P safety output pulse testing

**DOC-CONFIRMED:** Rockwell Automation publication 440R-UM004D-EN-P (Dec. 2022), section `Output Pulse Test Considerations`, states that output pulse testing supplies diagnostics required for the higher claimed safety rating. The manual permits pulse testing to be disabled when the connected device does not support OSSD inputs, but warns that disabling pulse testing reduces the maximum safety rating of a safety chain incorporating those I/O from the higher stated level to SIL CL 2 / PLd / Category 3.

Engineering meaning: a downstream device that cannot tolerate the diagnostic pulse is not fixed merely by turning the pulse off. Doing so changes diagnostic coverage and therefore changes the safety-function evidence package.

### Rockwell contactor application example

**DOC-CONFIRMED:** Rockwell safety application technique SAFETY-AT112 states that contactor coils typically do not react to safety-output pulse testing, but explicitly identifies the contrary case: if the selected contactor does react to the pulse test, pulse testing is disabled in that example. The document ties acceptability to the complete redundant/monitored architecture rather than asserting universal contactor immunity.

Engineering meaning: `it is only a short pulse` is not evidence. Actual coil/electronic-input response matters.

### SICK S3000 OSSD behavior

**DOC-CONFIRMED:** SICK S3000 operating instructions 8009942/ZD76/2025-08-19 document periodic OSSD tests in which both OSSDs are briefly switched OFF. The manual gives a 300-us maximum test-pulse width for the cited configuration and explicitly requires that the downstream controller not react to that test pulse by shutting down the machine.

The same manual specifies electrical load boundaries including output current, load inductance, load capacitance, and timing behavior. Those values are device-specific evidence, not generic OSSD constants.

Engineering meaning: a receiver needs a documented pulse-tolerance/filter contract. Excessive filtering is not automatically safe either, because it can delay or mask a genuine safety demand.

### Pilz test-pulse purpose

**SOURCE-CONFIRMED:** Pilz's current safety lexicon defines test-pulse outputs as deliberate pulses used, with appropriate wiring, to detect shorts across contacts. This confirms the general diagnostic purpose but does not provide an OpenPressBrake-specific timing or actuator contract.

## Failure-path matrix

| Failure / design error | Why apparently healthy operation is insufficient | Required evidence |
|---|---|---|
| Contactor/relay drops on an OFF test pulse | Repeated chatter, unintended stop, contact wear, or altered final-element state may occur | Actual output pulse envelope + coil/interface dropout behavior |
| Drive STO input interprets test pulse as a real STO demand | Nuisance STO/fault or restart inhibit can result | Selected drive safety-input pulse compatibility |
| Receiver filters pulses too aggressively | A real safety demand may be delayed/masked | Manufacturer-approved input filter / response specification |
| Large cable/input capacitance masks OFF pulse | Controller may fail to observe the expected diagnostic response | Output load/capacitance limits and installed wiring verification |
| Pulse testing disabled for compatibility | Diagnostic coverage has changed | Recalculate/revalidate complete safety function; do not retain old PL/SIL/DC claim |
| Two output channels share a downstream common cause | Dual outputs do not prove independent physical interruption | Complete final-element and common-cause analysis |
| HMI reports output ON during diagnostic pulses | Ordinary status collapses a time-varying safety signal into a misleading Boolean | Safety-device diagnostics plus physical final-element evidence |
| Ordinary FPGA/HAL filters or regenerates a safety signal | Personnel-safety authority has crossed into non-safety control | Independent safety-rated interface; ordinary control only observes permissive/diagnostic state |

## OpenPressBrake application boundary

**INFERENCE / design candidate:** If OpenPressBrake uses semiconductor safety outputs to command drive STO, safety contactors, monitored hydraulic-valve interfaces, or another safety-rated downstream input, the output/receiver pair should be reviewed as a single safety interface. At minimum record:

- output safe-state behavior;
- diagnostic OFF-pulse width/frequency and load limits;
- receiver's documented pulse tolerance and minimum recognized OFF duration;
- whether the receiver latches a fault/restart inhibit on pulses;
- cable capacitance and any interposing relay/interface behavior;
- whether disabling pulse testing is permitted and what diagnostic/safety claim changes;
- how final-element feedback proves the intended physical result independently of the output command.

**UNKNOWN:** OpenPressBrake's selected safety controller/output module, drive/STO input, contactor coils, hydraulic safety interface, exact pulse timing, wiring capacitance, PL/SIL/category, and acceptance thresholds. None are assigned here.

## Practical commissioning questions

1. With the actual output and receiver documentation side-by-side, is the diagnostic pulse explicitly tolerated?
2. Does the final element remain in the intended energized state during normal diagnostic pulses without chatter or nuisance fault?
3. Does a sustained genuine OFF demand still produce the required safe reaction through the complete final-element chain?
4. Does installed wiring remain within the output's load/capacitance limits?
5. If pulse testing is disabled, what diagnostic claim is lost and what compensating architecture/validation is actually documented?
6. Can the safety controller distinguish its diagnostic test from a wiring fault, and can maintenance personnel retrieve that diagnosis without treating an HMI Boolean as physical proof?

These are questions for selected hardware and commissioning evidence. This study supplies no machine-specific pass/fail timings.

## Evidence labels

- `SOURCE-CONFIRMED`: manufacturer material supports the stated general concept.
- `DOC-CONFIRMED`: cited manufacturer manual/application document supports the device-specific statement.
- `TEST-CONFIRMED`: none in this study.
- `COMMUNITY-REPORTED`: none relied upon.
- `INFERENCE`: OpenPressBrake design implications explicitly marked above.
- `UNKNOWN`: machine-specific hardware, timing, load, wiring, and safety-performance claims not yet evidenced.

## No-compute decision

No simulation, synthesis, benchmark, or executable test was justified. The unresolved question is selected-device documentation and installed-interface verification. No GitHub-hosted or self-hosted runner compute was consumed.

## Next independent work

Trace one complete professional safety output chain where the documentation exposes `safety output diagnostic pulse -> receiver/input compatibility -> physical final element -> feedback/EDM -> recovery after detected output fault`. Prefer a drive STO or safety-contactor implementation with explicit pulse-filter/tolerance data. If the primary lane reaches that package first, rotate to output short-circuit/backfeed fault detection or interposing-relay failure analysis rather than duplicate it.
