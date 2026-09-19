# Hydraulic press-brake two-hand safety-distance and human-factors study

Date: 2026-09-19

## Why this branch matters

The prior two-hand work established simultaneity, anti-repeat and release/recovery authority, but did not yet have press-brake-specific evidence tying the protective principle to physical reach and measured stopping performance.

## Press-brake-specific evidence

### IRSST — Safeguarding hydraulic power press brakes

Evidence class: **DOC-CONFIRMED**.

The IRSST hydraulic press-brake safeguarding guide states that protection from a two-hand control depends on safety distance, which is mainly a function of ram stopping time, and says stopping time must be reliable and repeatable before this safeguarding method is considered. It describes simultaneous and maintained two-button action as initiating and maintaining ram movement, with the station installed at a distance that prevents the operator reaching the identified front-zone hazards.

It also documents two operating patterns rather than pretending one universal sequence exists: maintained two-hand operation through the cycle, and a two-hand-plus-pedal sequence where the ram automatically stops near the work before pedal-controlled bending so the operator can support the sheet.

This is directly useful to the curriculum because it joins the logic concept to a physical reach/stopping premise on hydraulic press brakes.

Source: IRSST, `RF-651`, *Safeguarding hydraulic power press brakes: choices and compromises*.

### OSHA press-brake guidance

Evidence class: **DOC-CONFIRMED**, with scope caution.

OSHA's machine-guarding eTool describes two-hand control as a point-of-operation safeguarding option for press brakes and illustrates a sequence in which releasing a hand stops the slide. It also emphasizes concurrent two-hand actuation, anti-repeat/release-before-resume concepts and safety distance for regulated press applications.

The detailed 1910.217 formula/rules on the page are mechanical-power-press provisions and must not be silently transplanted as the governing hydraulic press-brake design rule. The press-brake operational example is useful; regulatory scope must remain explicit.

Source: OSHA Machine Guarding eTool, Presses — Two-Hand Controls.

## Frozen boundaries

`TWO-HAND LOGIC VALID != TWO-HAND SAFEGUARD VALID`

`TWO-HAND SAFEGUARD VALID` additionally depends on the actual hazard geometry, control placement/reach relationship, machine stopping behavior, mode/sequence and other machine-specific protective measures.

`STOP COMMAND ISSUED != RAM STOPPING TIME RELIABLE/REPEATABLE != SAFETY DISTANCE VALID`

`CONTROL STATION WAS SAFE WHEN COMMISSIONED != CONTROL STATION REMAINS SAFE AFTER STOPPING PERFORMANCE DEGRADES OR MACHINE/TOOLING CHANGES`

`TWO-HAND MODE THROUGH ENTIRE CYCLE != TWO-HAND-THEN-PEDAL MODE`; mode-specific authority and safeguarding assumptions must be validated rather than merged.

## Practical human factors

The IRSST guide explicitly notes the need for sheet support because the operator's hands are occupied by the two-hand device. This is a valuable design lesson: if the safe operating method makes ordinary part support impossible, operators gain a strong incentive to defeat the safeguard. Provide work support, ergonomics and a production sequence that make correct use practical.

Therefore the course adopts: **safeguarding inconvenience that predictably drives bypass is an engineering problem to solve, not merely an instruction problem.**

## OpenPressBrake implications

Do not assign a two-hand station, location, timing constant or safety distance from these generic sources. For any real retrofit, actual stopping performance and hazard geometry must be established for that machine and the chosen safeguarding architecture.

LinuxCNC/HAL and the normal FPGA controller must not be the sole personnel-safety evaluator for the two-hand function. They may observe diagnostic/process state while independent safety authority controls the hazardous-motion permission/final elements.

If the minimum safe-to-operate conditions cannot be established, do not operate with people exposed to the hazard. Experimental motion must be isolated/remote with people outside the danger zone and residual risk stated.

## Next evidence target

Seek an inspectable hydraulic press-brake OEM or certified guarding implementation exposing the complete chain: two-hand device -> safety evaluator -> hydraulic final elements -> release response -> measured stopping performance -> placement/reach validation -> fault/recovery/re-proof. Until available, retain the exact hydraulic final-element chain as UNKNOWN.

No simulation is justified; software simulation cannot establish real stopping time, reach geometry or hydraulic final-element performance.
