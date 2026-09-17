# Professional Safety Release -> STO -> Separate START Trace

Session start UTC: 2026-09-17T23:35:18Z

## Question

Can an inspectable professional implementation close the evidence gap between a safety-system reset/release, the physical drive safety interface, and a separate ordinary START without treating `safety released` as `motion commanded`?

## Primary source

Festo application note 100245, *Safety Sub-Functions SS1-t, STO — Servo Drive CMMT-ST-...-S0, Cross Wiring of Servo Drives*, version 1.10 (2019-09-17), official Festo Support Portal document record:

- https://www.festo.com/fox/net/supportportal/Details/629723/Document.aspx

The Festo document describes cross-wiring several CMMT-ST servo drives and implementation of SS1/STO. The source-specific PL/category statements remain properties of the documented application and are not transferred to OpenPressBrake.

## Evidence classification

### DOC-CONFIRMED — demand and reset

Festo states that after the safety request is reset — examples given are mechanically releasing an E-stop or closing the safety gate — restart can be made possible by actuating acknowledgement button S1.

This establishes that restoration of the protective device is not itself the complete restart action.

### DOC-CONFIRMED — independent safety output to drive STO

The safety switching device T1 controls the servo drive T3 through safety outputs Q6/Q7. Festo states that this permits the drive power output stage to be controlled again and that STO is then no longer active.

On the stop side, Festo states that delayed switch-off of Q6/Q7 requests STO through the drive inputs #STO-A and #STO-B.

This closes a physical final-interface gap that the personnel-retention source did not expose: the safety switching device reaches the servo drive's dual-channel STO interface.

### DOC-CONFIRMED — ordinary control remains separate

Festo separately shows T1 output Q5 permitting the functional controller T2 to control the drive `CTRL-EN` / output-stage enable. Normal operation is then possible by pressing the separate ordinary START pushbutton S20.

Therefore the documented chain is:

`safety demand/restoration -> acknowledgement S1 -> safety switching device T1 -> Q6/Q7 -> drive STO interface -> Q5 permits functional-control enable -> separate START S20 -> normal operation`

The important boundary is that acknowledgement restores permission; it does not itself constitute the ordinary START command.

### DOC-CONFIRMED — feedback is bounded

Festo documents diagnostic output STA reporting STO safety-subfunction status back to T1. This is useful feedback about the drive safety function. It is not evidence that all machine hazards, stored energy, brakes, hydraulics, gravity loads, tooling or personnel state are safe.

## Reconciliation with personnel-retention work

Pilz Key-in-pocket documents a safe retained-person list and an `Enable (list empty)` output after all personnel have signed out, with a blind-spot check where required. Public Pilz material examined in the prior session did not identify the final machine actuator controlled by that enable.

Festo closes a different segment: it exposes the safety switching device through the drive STO interface and then preserves a separate ordinary START.

The two sources therefore support an architecture pattern without pretending they are one certified implementation:

`retained-person condition clear`  
`-> independent safety release`  
`-> machine-specific validated final safety interface`  
`-> final-element feedback as documented`  
`-> ordinary control permitted`  
`-> fresh separate START required`

The connection between a Pilz Key-in-pocket `Enable (list empty)` signal and any particular Festo, OpenPressBrake, contactor, STO or hydraulic final element remains **INFERENCE / DESIGN WORK**, not source-confirmed.

## Frozen curriculum rule

**SAFETY RELEASE != STO RELEASE != FUNCTIONAL ENABLE != FRESH START != MOTION.**

A design must name which transition each signal actually authorizes. A permissive returning TRUE must not be allowed to transform a stale maintained LinuxCNC/HAL/FPGA command into newly intended hazardous motion.

For bodily-entry hazards, add the already-frozen personnel rule ahead of this chain:

**ACCESS CLEAR != PERSONNEL CLEAR != RETAINED-PERSON LIST EMPTY != SAFETY RELEASE.**

## OpenPressBrake application boundary

For OpenPressBrake, the following remain UNKNOWN until selected hardware and installed-machine evidence exist:

- exact independent safety controller/output hardware;
- whether a servo/drive STO interface is part of the final architecture;
- hydraulic blocking/dump/load-holding final elements and feedback;
- contactor topology and EDM;
- personnel-retention method for any bodily-entry zone;
- reset/rearm/start wiring and required sequencing;
- pulse compatibility of the selected safety outputs and receiving final elements;
- PL/SIL/category, stopping time/distance, pressure thresholds and diagnostic coverage.

LinuxCNC and the ordinary FPGA may receive safety permissives/status for normal-control gating and diagnostics. They must not become the sole personnel-safety authority or the sole retained-person memory.

## Commissioning challenges derived from the trace

1. Restore a tripped protective device without acknowledgement: hazardous motion must not resume merely because the device became healthy.
2. Acknowledge/reset the safety system while ordinary START is absent: final safety permission may return as designed, but hazardous motion must not begin solely from acknowledgement.
3. Hold an ordinary START/JOG/ENABLE command before a safety trip, trip the safety function, then restore and acknowledge: verify the old command cannot silently become a fresh motion request.
4. Interrupt each STO channel/final safety interface according to manufacturer-supported validation methods and verify the documented diagnostic response; do not invent fault injection outside product guidance.
5. Verify that any displayed `STO released`, `safe`, `ready`, or `enable` indication is labeled to its bounded meaning and is freshness-qualified.
6. Where gravity/hydraulic hazards exist, separately prove load retention / pressure / restraint; STO status alone is insufficient.

## Information-gain result

This trace closes the generic electrical drive segment `safety reset -> safety output -> STO interface -> functional-control permission -> separate START`. It does **not** close the OpenPressBrake hydraulic final-element path or prove a complete personnel-retention-to-final-element implementation from one manufacturer.

Next useful branch: reconcile safety-output diagnostic test pulses with a real drive STO receiver and its documented filtering/tolerance/feedback behavior, or continue the hydraulic monitored-valve/fall-protection trace if that source exposes the complete physical path first.
