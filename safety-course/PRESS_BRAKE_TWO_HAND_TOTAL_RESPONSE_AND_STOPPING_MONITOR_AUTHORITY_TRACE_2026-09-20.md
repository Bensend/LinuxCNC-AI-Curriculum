# Press-brake two-hand total-response and stopping-monitor authority trace

Date: 2026-09-20

## Question

For a hydraulic press brake using two-hand safeguarding, what professional implementation evidence defines the response chain that must be included in safety-distance validation, and what happens when stopping performance deteriorates?

## Evidence

### Rockford Systems RHPS hydraulic press-brake control installation manual

**DOC-CONFIRMED.** Rockford Systems' RHPS control-system installation manual for hydraulic press brakes states that a two-hand safeguarding station must be located at a safe distance. Citing ANSI B11.3-2002 for its implementation, it defines total safety-distance response as more than ram motion alone:

- `Ts`: press stop time measured from the final de-energized control element;
- `Tc`: control-system reaction time;
- `Tr`: two-hand control/interface reaction time; and
- `Tspm`: additional time allowed by the stopping-performance monitor before it detects stop-time deterioration.

The manual notes that `Ts + Tc` are commonly measured by a portable or built-in stop-time measuring device. It also instructs that, when the ANSI formula does not prescribe a stroke position, the stop demand should be applied on the downstroke at the point producing the longest stopping time.

Source: Rockford Systems, *Installation Manual for RHPS Control Systems on Hydraulic Press Brakes*, KSL278, pp.25-27 public PDF.

**DOC-CONFIRMED.** The same manual says that when press stopping behavior changes because the machine is taking longer to stop, the safety distance must be recalculated and the safeguarding device moved farther away when the stopping time/distance has increased.

**DOC-CONFIRMED.** The manual also states that a failure affecting safety-related interface performance must not prevent a normal stop command; it must instead permit that stop or cause an immediate stop. Re-initiation is prevented until the failure is corrected or the system/device is manually reset. Repetitive manual reset in the presence of a fault is not an acceptable production operating method.

### Inspectable RHPS control/final-element path

**DOC-CONFIRMED.** The RHPS manual exposes more of the real machine chain than a generic safety-distance formula. It describes redundant inputs feeding two processors, monitored ram-advance force-guided output relays, blocking-valve monitoring, and solenoid valve output(s) that route hydraulic fluid to the cylinders. In its normal sequence, when the actuating means are released before the bottom-of-stroke timing point, ram movement stops.

This is valuable implementation evidence because it identifies separate observable layers:

`palm buttons -> redundant safety/control processing -> monitored force-guided ram-advance relays -> hydraulic solenoid valve(s)/blocking-valve supervision -> cylinder flow -> physical ram motion`.

It does not prove that every RHPS retrofit uses the same hydraulic valve topology; machine wiring/hydraulic integration remains application-specific.

### Maintenance-triggered two-hand function test

**DOC-CONFIRMED.** Rockford requires the two-hand function tests before operating the press when the controls are used as point-of-operation safeguarding, and calls for them at every operator, die, or shift change **and every time maintenance is performed**. The checks include guarded/separated actuators, fixed position, safety distance based on stopping time during die closing, concurrent actuation within the configured anti-tie-down window, and antirepeat behavior. The manual then exercises release during die closing and expects the slide to stop.

This is a concrete post-maintenance re-test trigger for the safeguarding function. It is not evidence that every hydraulic valve replacement requires a separate static holding-valve load test; that primary-lane question remains open.

## Freeze

**TWO-HAND EVALUATOR RESPONSE != CONTROL-SYSTEM RESPONSE != FINAL CONTROL-ELEMENT RESPONSE != PHYSICAL RAM STOPPING RESPONSE != STOPPING-MONITOR ALLOWANCE.**

A station-distance validation that measures only one convenient layer is incomplete when the applicable architecture/formula requires the total chain.

**STOP-TIME MEASUREMENT PASS != STOPPING-PERFORMANCE MONITOR THRESHOLD VALID != STATION DISTANCE VALID FOREVER.**

**SAFETY FAULT RESETTABLE != FAULT CORRECTED != PRODUCTION AUTHORITY.** Repeated reset cannot be used to normalize a persistent safety-related fault.

**COMMAND TO STOP != FINAL CONTROL ELEMENT DE-ENERGIZED != RAM PHYSICALLY STOPPED.** These are distinct witnesses and should remain distinct in commissioning evidence.

**POST-MAINTENANCE TWO-HAND FUNCTION TEST REQUIRED != SERVICED HYDRAULIC RETAINING ELEMENT STATICALLY LOAD-PROVED.**

## Relationship to prior IRSST trace

IRSST RF-651 already established that hydraulic press-brake two-hand protection depends on a safety distance principally driven by reliable/repeatable ram stopping time. Rockford adds implementation detail: the validated response chain can include control response, two-hand-interface response, final-element-to-stop behavior, and stopping-performance-monitor allowance. It also gives a practical worst-case measurement rule: challenge stopping on the downstroke where stopping time is longest rather than measuring at a convenient position.

Rockford further closes part of the requested complete implementation trace by identifying monitored force-guided ram-advance relays, blocking-valve monitoring, and hydraulic solenoid output(s), and by requiring the two-hand safeguard's function tests after maintenance.

Together these sources support a stronger curriculum chain:

`operator actuators -> two-hand/interface evaluation -> redundant processing -> monitored output relays -> hydraulic solenoid/blocking-valve path -> physical ram decelerates/stops -> worst-case measured total response -> stopping-performance-monitor allowance -> validated station distance -> fresh cycle authority`.

## Commissioning / adversarial review

A professional commissioning plan should therefore challenge, without inventing machine-specific numeric criteria:

1. both-hand simultaneity, maintained actuation, release, anti-tiedown and antirepeat behavior;
2. response from safety demand through the actual monitored output/final hydraulic control element rather than only an HMI/HAL bit;
3. physical ram stopping at the machine's documented worst-case test point/condition;
4. the complete response terms required by the applicable machine/safeguarding design;
5. stopping-performance-monitor behavior at its documented deterioration threshold;
6. the rule that increased stopping time invalidates the old distance until revalidated;
7. post-maintenance re-test of the safeguarding function where required by the machine/control documentation; and
8. persistent-fault behavior proving repeated reset cannot become a production workaround.

LinuxCNC, a normal FPGA, or an HMI may record diagnostics or request ordinary motion, but must not be treated as the independent personnel-safety authority merely because it can observe these states.

## Human factors

If maintaining a valid two-hand station distance makes normal work impractical, moving the station closer, tying down an actuator, or repeatedly resetting a fault is not an acceptable usability fix. The safeguarding architecture or material-handling method must be redesigned so the safe method is also the practical method.

## OpenPressBrake unknowns

`UNKNOWN`: whether OpenPressBrake will use two-hand safeguarding; applicable standard/version; actual final hydraulic control element(s); safety-controller/interface response; stop-time measurement method and worst-case test point; stopping-performance-monitor implementation/allowance; validated safety distance; deterioration threshold; test interval; and reset/restart sequence.

Also still `UNKNOWN`: whether service/replacement of the eventual OpenPressBrake holding/safety valve requires a separate static unmasked retaining-function proof, and how that proof is linked to post-maintenance stopping/start-up revalidation.

No Rockford numeric machine value, anti-tie-down setting, valve topology, or legacy-standard formula is adopted as an OpenPressBrake design requirement without the machine-specific risk assessment and current applicable requirements.

## Compute

No executable test is justified. The unresolved OpenPressBrake quantities require machine-specific architecture/measurement, not generic simulation. No GitHub-hosted or self-hosted compute was used.
