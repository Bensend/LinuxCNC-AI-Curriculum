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

Source: Rockford Systems, *Installation Manual for RHPS Control Systems on Hydraulic Press Brakes*, KSL278, p.26 public PDF/search extract.

**DOC-CONFIRMED.** The same manual says that when press stopping behavior changes because the machine is taking longer to stop, the safety distance must be recalculated and the safeguarding device moved farther away when the stopping time/distance has increased.

**DOC-CONFIRMED.** The manual also states that a failure affecting safety-related interface performance must not prevent a normal stop command; it must instead permit that stop or cause an immediate stop. Re-initiation is prevented until the failure is corrected or the system/device is manually reset. Repetitive manual reset in the presence of a fault is not an acceptable production operating method.

## Freeze

**TWO-HAND EVALUATOR RESPONSE != CONTROL-SYSTEM RESPONSE != FINAL CONTROL-ELEMENT RESPONSE != PHYSICAL RAM STOPPING RESPONSE != STOPPING-MONITOR ALLOWANCE.**

A station-distance validation that measures only one convenient layer is incomplete when the applicable architecture/formula requires the total chain.

**STOP-TIME MEASUREMENT PASS != STOPPING-PERFORMANCE MONITOR THRESHOLD VALID != STATION DISTANCE VALID FOREVER.**

**SAFETY FAULT RESETTABLE != FAULT CORRECTED != PRODUCTION AUTHORITY.** Repeated reset cannot be used to normalize a persistent safety-related fault.

**COMMAND TO STOP != FINAL CONTROL ELEMENT DE-ENERGIZED != RAM PHYSICALLY STOPPED.** These are distinct witnesses and should remain distinct in commissioning evidence.

## Relationship to prior IRSST trace

IRSST RF-651 already established that hydraulic press-brake two-hand protection depends on a safety distance principally driven by reliable/repeatable ram stopping time. Rockford adds implementation detail: the validated response chain can include control response, two-hand-interface response, final-element-to-stop behavior, and stopping-performance-monitor allowance. It also gives a practical worst-case measurement rule: challenge stopping on the downstroke where stopping time is longest rather than measuring at a convenient position.

Together these sources support a stronger curriculum chain:

`operator actuators -> two-hand/interface evaluation -> safety/control reaction -> final control element changes state -> physical ram decelerates/stops -> worst-case measured total response -> stopping-performance-monitor allowance -> validated station distance -> fresh cycle authority`.

## Commissioning / adversarial review

A professional commissioning plan should therefore challenge, without inventing machine-specific numeric criteria:

1. both-hand simultaneity, maintained actuation, release, and anti-tiedown behavior;
2. response from safety demand through the actual final control element rather than only an HMI/HAL bit;
3. physical ram stopping at the machine's documented worst-case test point/condition;
4. the complete response terms required by the applicable machine/safeguarding design;
5. stopping-performance-monitor behavior at its documented deterioration threshold;
6. the rule that increased stopping time invalidates the old distance until revalidated; and
7. persistent-fault behavior proving repeated reset cannot become a production workaround.

LinuxCNC, a normal FPGA, or an HMI may record diagnostics or request ordinary motion, but must not be treated as the independent personnel-safety authority merely because it can observe these states.

## Human factors

If maintaining a valid two-hand station distance makes normal work impractical, moving the station closer, tying down an actuator, or repeatedly resetting a fault is not an acceptable usability fix. The safeguarding architecture or material-handling method must be redesigned so the safe method is also the practical method.

## OpenPressBrake unknowns

`UNKNOWN`: whether OpenPressBrake will use two-hand safeguarding; applicable standard/version; actual final hydraulic control element(s); safety-controller/interface response; stop-time measurement method and worst-case test point; stopping-performance-monitor implementation/allowance; validated safety distance; deterioration threshold; test interval; and reset/restart sequence.

No Rockford numeric machine value or legacy-standard formula is adopted as an OpenPressBrake design requirement without the machine-specific risk assessment and current applicable requirements.

## Compute

No executable test is justified. The unresolved OpenPressBrake quantities require machine-specific architecture/measurement, not generic simulation. No GitHub-hosted or self-hosted compute was used.
