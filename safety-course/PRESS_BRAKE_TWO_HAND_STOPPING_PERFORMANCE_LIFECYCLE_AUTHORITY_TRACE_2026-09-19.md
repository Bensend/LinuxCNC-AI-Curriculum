# Press-brake two-hand stopping-performance lifecycle / authority trace

Date: 2026-09-19

## Question

When a two-hand control is relied upon as point-of-operation safeguarding on a hydraulic press brake, what must remain true beyond the two-hand logic itself?

## Evidence

### DOC-CONFIRMED — OSHA press-brake safeguarding and physical stopping witness

OSHA's powered-press-brake eTool recognizes a two-hand control device as one possible press-brake safeguarding method. Its two-hand-control explanation says the operator initiates the stroke with both controls and that removing a hand stops the slide. This is useful intended-behavior evidence, but it is not evidence that a particular hydraulic circuit or installation has adequate stopping performance.

Sources:
- OSHA, *Machine Guarding eTool — Powered Press Brakes*: https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes
- OSHA, *Machine Guarding eTool — Two-Hand Controls*: https://www.osha.gov/etools/machine-guarding/presses/two-hand-controls

OSHA's stop-time guidance is the stronger physical boundary. It says a portable or built-in stop-time measuring unit is used to determine machine stopping time for safeguarding placement, explicitly identifies hydraulic presses and press brakes as machines for which the method is used, and says the device can be used periodically to verify that the current safety distance still corresponds to the machine's current stopping ability.

Source:
- OSHA, *Machine Guarding eTool — Safety Distance*: https://www.osha.gov/etools/machine-guarding/presses/safety-distance

Important scope note: OSHA 29 CFR 1910.217's detailed two-hand formulas are written for mechanical power presses. Do not silently transfer its crankshaft-specific formula or mechanical-press requirements to a hydraulic press brake. The useful cross-machine evidence here is the explicit OSHA eTool statement that physical stop-time measurement is used on hydraulic presses/press brakes and can be repeated to verify continued correspondence between stopping ability and safeguard distance.

### DOC-CONFIRMED — hydraulic press-brake-specific guidance

IRSST guide RF-651, *Safeguarding hydraulic power press brakes*, states that protection offered by a two-hand control is based on safety distance, principally a function of ram stopping time, and says stopping time must be reliable and repeatable before this safeguarding method is considered. It also describes simultaneous maintained two-hand actuation and notes that a sheet support may be used because both hands are occupied.

Source:
- IRSST RF-651, *Safeguarding hydraulic power press brakes*: https://www.irsst.qc.ca/media/documents/pubirsst/rf-651.pdf

This is press-brake-specific evidence that the safeguard is not merely a button-logic problem: the ram's physical stopping behavior is part of whether the protective method is valid.

## Authority chain

A defensible two-hand safeguard therefore has at least these distinct claims:

1. both hand actuators are valid and demand logic is satisfied;
2. release of either hand creates the required safety demand;
3. independent safety-related control propagates that demand to the relevant final elements;
4. the final elements actually change the hazardous motion;
5. the ram physically stops with sufficiently reliable/repeatable performance for the selected protective arrangement;
6. the installed two-hand station/safety distance remains valid for the current measured stopping ability;
7. recovery/rearm rules do not convert a stale demand into a new hazardous cycle.

A pass at an earlier item cannot be substituted for a later item.

## Frozen curriculum boundaries

**TWO-HAND INPUT LOGIC PASS != SAFETY OUTPUT PASS != HYDRAULIC FINAL-ELEMENT RESPONSE != RAM PHYSICALLY STOPPED != STOPPING PERFORMANCE RELIABLE/REPEATABLE != SAFEGUARD DISTANCE VALID != PRODUCTION AUTHORITY.**

**COMMISSIONING STOP-TIME PASS != CURRENT STOP-TIME PROOF.** Where the safeguard's validity depends on stopping performance, a changed or degraded stopping system can invalidate the protective arrangement even though every two-hand input bit and relay diagnostic still looks healthy.

**BUTTON LOCATION UNCHANGED != SAFETY DISTANCE STILL VALID.** Physical stopping ability is a maintained property, not a permanent constant inherited from installation day.

## Change / maintenance consequence

INFERENCE from the combined evidence: maintenance or modification that can materially alter the stop path — for example work on a hydraulic final element relied upon to stop hazardous closing — creates a revalidation question for any safeguard whose safety distance depends on stopping performance. The curriculum must seek the applicable machine/OEM/standard procedure for the actual re-test trigger and acceptance criterion; it must not invent a universal interval, threshold, or numerical distance.

This inference is intentionally narrower than saying every hydraulic service operation automatically requires a particular named test. The existing CINCINNATI and Lazer Safe studies establish machine-level revalidation and system-specific stopping tests, but the public evidence still does not prove one universal post-valve-replacement sequence across press brakes.

## Human-factors application

A two-hand station that is moved closer because production is awkward, or a workpiece that forces the operator to defeat the two-hand method, destroys the assumptions behind the safeguard. The safer design response is to solve the ergonomics — work support, suitable safeguarding architecture, or process arrangement — rather than normalize bypassing the protective method.

## Open evidence gap

Still seek a professional hydraulic press-brake implementation that exposes the whole chain:

`two-hand release -> independent safety evaluator -> actual hydraulic final elements -> physical ram stop witness -> measured stop/reach proof -> final-element fault -> recovery/re-proof -> safety rearm -> press-brake production initiation`.

Also continue the higher-priority hydraulic service question already in PROGRESS.md: individual holding/safety-valve service/replacement -> unmasked retaining-function challenge -> physical ram/load witness -> pass/fail disposition -> stopping-performance re-proof where applicable. This study does not fill that UNKNOWN.

## Compute decision

No simulation or executable lab was justified. The unresolved questions are machine-specific physical safety questions requiring authoritative machine evidence or physical validation; synthetic compute would not establish them. No GitHub-hosted runner work was used.
