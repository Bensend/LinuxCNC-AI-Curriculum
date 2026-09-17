# Safety Output Diagnostic Pulse -> STO Receiver Contract

## Question

Lane B established that a safety output's diagnostic test pulses are part of the interface contract. Can that rule be closed against a real drive STO receiver with explicit manufacturer pulse limits and feedback?

## Authoritative receiver evidence

Festo CMMT-ST-C8-EC/EP/PN-S0 manual, 2024-04d, official manufacturer manual (document 8214108g1), plus Festo application note 100245 for the cross-wired SS1-t/STO implementation.

Official application-note record:
https://www.festo.com/fox/net/supportportal/Details/629723/Document.aspx

### DOC-CONFIRMED receiver limits

For CMMT-ST #STO-A/#STO-B, Festo documents:

- low test pulses tolerated up to 1 ms;
- minimum 50 ms between low test pulses;
- high test pulses tolerated up to 1 ms;
- minimum 50 ms between qualifying high test pulses;
- high test pulses must not occur simultaneously on #STO-A and #STO-B; they require a time offset.

These numbers are **Festo CMMT-ST-specific** and are not generic safety-output requirements.

### DOC-CONFIRMED safety-relay contract

Festo's safety-relay guidance requires suitable two-channel outputs, cross-contact/short detection, adequate output current including STO load, and evaluation of the servo drive diagnostic contact. It explicitly permits safety relay units with test pulses subject to the documented pulse restrictions.

This turns `test-pulse compatible` from a vague property into a measurable source/receiver contract.

### DOC-CONFIRMED feedback

The drive exposes diagnostic contact STA for STO status. Festo specifies it as a potential-free diagnostic contact and provides its electrical/reaction-time limits. The application note routes/evaluates STA at the safety switching device.

STA therefore closes a documented feedback loop for the **STO safety sub-function state**. It does not prove shaft standstill, brake holding, absence of gravity motion, hydraulic pressure removal, electrical isolation for maintenance, or personnel clearance.

## Interface proof chain

A valid integration review must preserve all of these separately:

`diagnostic pulse generated`
`-> pulse width/spacing/channel relationship within receiver limits`
`-> STO receiver remains in intended state`
`-> wiring/output diagnostics retain their intended fault-detection behavior`
`-> STO demand actually changes drive safety state when required`
`-> documented STA feedback changes as specified`
`-> machine-level hazardous-motion result validated separately`

## Failure-path analysis

### Pulse too long

If a safety output's OFF diagnostic pulse exceeds the receiving STO input's documented tolerance, the receiver may interpret diagnostic activity as a real safety demand. The likely machine-level symptom may be nuisance stopping, but the exact response is hardware-specific and must not be invented.

### Pulses overlap both STO channels

Festo explicitly disallows simultaneous high test pulses on the two STO channels in the documented condition. A source that independently satisfies per-channel pulse width but violates the cross-channel relationship is therefore still incompatible.

### Pulses disabled to stop nuisance trips

Disabling safety-output diagnostics is not a neutral wiring tweak. If those pulses support short/cross-fault detection, removing them can change diagnostic coverage and therefore invalidates any unchanged safety-function claim until the architecture is re-evaluated.

### STA healthy

`STA = expected` proves only the bounded drive STO diagnostic state described by Festo. It is not EDM for unrelated contactors and not proof of all hazardous energy removal.

### Ordinary controller sees stale STA

If LinuxCNC/HAL/HMI receives a mirrored STA state, the display must preserve source and freshness. The ordinary controller is not permitted to promote a stale `STO inactive/ready` value into safety authority.

## Frozen rule

**SOURCE PULSE SPEC + RECEIVER PULSE TOLERANCE + CHANNEL RELATIONSHIP + FEEDBACK CONTRACT are one interface.**

And:

**PULSE COMPATIBLE != STO FUNCTION VALIDATED != FINAL MACHINE HAZARD CONTROLLED.**

## OpenPressBrake boundary

The selected OpenPressBrake safety controller/output hardware and final STO/contactors/hydraulic interfaces remain UNKNOWN. Therefore no 1-ms/50-ms value is imported into OpenPressBrake. Once components are selected, compare their actual source-pulse waveform (including worst-case timing and both-channel relationship) against every receiver's manufacturer limits before freezing the interface.

No simulation is justified for this generic question because authoritative source and receiver specifications resolve it. Hardware validation becomes justified after actual parts and wiring are selected, particularly where cable capacitance, interposing devices, multiple parallel receivers or configuration alter the manufacturer-supported topology.

## Commissioning/validation prompts

1. Capture the configured safety-output diagnostic mode and manufacturer timing limits.
2. Record each receiver's permitted pulse width, spacing, polarity and simultaneous-channel restrictions.
3. Confirm load/current/cable constraints and supported topology.
4. Challenge each safety channel using manufacturer-supported procedures and verify the documented receiver feedback.
5. Confirm diagnostic pulses do not produce unintended final-element motion/dropout in the validated topology.
6. Confirm deliberate faults are detected where the safety design claims they are; do not infer diagnostic coverage from a green status LED.
7. Re-run the interface review after firmware/configuration, output-module, receiver, cable/topology or interposing-device changes.

## Information-gain result

This closes Lane B's requested real `diagnostic pulse -> STO receiver compatibility -> drive safety state -> feedback` example using a manufacturer that publishes both the application circuit and explicit receiver timing limits. It does not establish OpenPressBrake values and does not replace machine-level validation.
