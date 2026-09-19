# Safety operating-mode selection — power-up and transition authority study

Date: 2026-09-19

## Question

When a machine has automatic, setup/manual, and service modes with different safeguards, what must remain separate between selecting a mode, safely evaluating that selection, suspending a normal safeguard, enabling hazardous motion, and restoring production after a mode transition or power cycle?

This Lane-B study is intentionally independent of the primary lane's current HAWE ePrAX NSV replacement / hydraulic return-to-service evidence package.

## Evidence

### Pilz — operating-mode selector requirements

Source: https://www.pilz.com/en-GB/support/faq/standards/articles/167661

Evidence class: `DOC-CONFIRMED`.

Pilz states that where operating modes/control sequences require different safety levels, each selector position may exclusively enable one operating mode; operating the selector alone may not initiate machine operation; and the selected operating mode overrides other control functions except emergency stop/off. Pilz also explains why safety-related evaluation is needed when the mode selection itself determines which protective functions are active.

### Pilz PIT m4SEU — deliberate selection and power-up behavior

Source: https://www.pilz.com/download/open/PIT_m4SEU_Operat_Manual_1004648-EN-08.pdf

Evidence class: `DOC-CONFIRMED`.

The current PIT m4SEU operating manual documents safety-related mode selection for setup, manual, automatic and service modes. It detects multiple selection-button operation, only asserts one operating-mode output, and recognizes a new selection only after deliberate operator action for a defined period. It also treats power-on mode behavior as an explicit configured safety-related behavior rather than something to infer from an ordinary HMI state.

### SICK — enabling device is permissive, not START

Source: https://www.sick.com/media/docs/8/78/678/special_information_guide_for_safe_machinery_en_im0014678.pdf

Evidence class: `DOC-CONFIRMED`.

SICK's Guide for Safe Machinery says an enabling device can support setup/maintenance where normal protective devices are temporarily disabled, but only with other risk-reducing measures such as reduced force or speed. It explicitly states that actuating the enabling device alone must not initiate machine start. For a three-position device, motion is enabled only in the middle position; release or overtravel removes enabling authority. SICK further says the enabling function must not simply become valid while returning from position 3 to position 2.

### SICK E100 / Pilz PITenable — physical three-position behavior

Sources:
- https://www.sick.com/cn/en/catalog/products/safety/safety-switches/e100/c/g195532
- https://www.pilz.com/en-GB/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch

Evidence class: `DOC-CONFIRMED`.

Both manufacturers expose Off-On-Off three-position enabling behavior for work in a danger zone during setup/maintenance. This supports a physical human-factor boundary: panic squeeze and release both remove enabling authority rather than making a continuously held ordinary command the sole protective mechanism.

## Architecture freeze

`MODE REQUESTED != MODE SAFELY SELECTED != MODE TRANSITION COMPLETE != REQUIRED SUBSTITUTE SAFETY FUNCTIONS VALID != SAFEGUARD BYPASS AUTHORIZED != ENABLING DEVICE VALID != MOTION COMMAND PRESENT != HAZARDOUS MOTION AUTHORIZED != PHYSICAL MOTION SAFE`

Also freeze:

`POWER RESTORED != PREVIOUS MODE SAFE TO RESUME != SAFETY FUNCTIONS REVALIDATED != PRODUCTION AUTHORITY`

`MODE SELECTOR CHANGED != MACHINE START`

`ENABLING DEVICE MID-POSITION != MACHINE START`

`POSITION 3 -> POSITION 2 != AUTOMATIC RE-ENABLE`

## LinuxCNC / OpenPressBrake boundary

`INFERENCE`: LinuxCNC, HAL, an HMI, or ordinary FPGA logic may request a mode and display diagnostics, but where mode selection changes which personnel-protection functions are active, ordinary software state must not silently become the sole authority for the safety-relevant mode boundary. The independent safety architecture must own or safely evaluate the safety-relevant conditions required for that mode.

This does not imply that OpenPressBrake requires any particular commercial selector, safe PLC, safe-speed function, or enabling device. Those are machine/application decisions.

## Failure-path / commissioning questions

1. Select two mode inputs simultaneously. Does the safety evaluator reject or fault the selection rather than ambiguously choosing one?
2. Change from automatic to setup while ordinary CYCLE/START remains asserted. Can stale ordinary intent become motion in the new mode?
3. Change from setup back to automatic with a normal safeguard still bypassed or unproved. Is production authority withheld?
4. Power cycle in setup/service mode. Is the configured power-up mode behavior explicit and validated, and can hazardous motion occur without a deliberate motion command?
5. Hold an enabling device in its valid middle position before entering the mode. Does mode selection itself start motion? It must not be assumed to.
6. Squeeze the enabling device through position 3, then relax toward position 2 while a motion command remains present. Verify that this transition cannot silently recreate enabling authority contrary to the validated enabling-device behavior.
7. Release the enabling device during hazardous manual motion. Trace the independent safety reaction through the actual final element and physical motion witness.
8. Force a mode-selection disagreement or invalid combination. Verify the machine does not merely fall back to an ordinary HMI-selected mode.
9. Restore normal production mode. Require normal safeguards and any affected safety functions to be restored/proved before production authority; do not treat the mode label alone as proof.
10. Keep LinuxCNC START/JOG/CYCLE asserted across mode change or power restoration. Verify stale commands do not accidentally become fresh hazardous-motion intent where the validated application requires a fresh command.

## Evidence classification

### DOC-CONFIRMED

- A mode selector alone must not initiate machine operation (Pilz).
- Safety-relevant operating-mode selection can be implemented so only one mode output is active and a selection requires deliberate operator action (Pilz PIT m4SEU).
- Power-on mode behavior is an explicit configured behavior in the PIT m4SEU rather than an unstated assumption.
- Three-position enabling devices provide Off-On-Off behavior; release and overtravel remove enabling authority (SICK/Pilz).
- Enabling-device actuation alone must not initiate machine start (SICK).
- Return from enabling position 3 toward position 2 must not simply release/recreate enabling authority (SICK).

### INFERENCE

- Where operating mode determines which protective functions are active, LinuxCNC/HAL/HMI should not be the sole personnel-safety authority for that mode selection.
- A mode transition should be treated as an authority transition: stale ordinary commands and unresolved safeguard state deserve explicit challenge testing.

### UNKNOWN — preserve

- Which operating modes OpenPressBrake ultimately requires.
- Whether any OpenPressBrake mode permits safeguard suspension.
- Whether safe limited speed, safe direction, hold-to-run, three-position enabling, two-hand control, or another substitute measure is required in a specific mode.
- OpenPressBrake mode-selector hardware, safety architecture, speed/force limits, stopping performance, hydraulic truth table, pressure thresholds, PL/SIL/category/DC/CCF, or reset/restart timing.
- Whether production after a particular mode transition requires a separate reset, safety rearm, fresh ordinary START, or another machine-specific sequence beyond what authoritative machine evidence establishes.

## Curriculum consequence

Teach mode selection as a safety-authority boundary, not a GUI convenience. A robust trace asks separately: what mode was requested, what mode the independent safety system accepted, which normal safeguards are suspended, what substitute safety functions are valid, what deliberate motion command exists, what final element responded, and what the physical machine actually did.

## Precise next work

Find a complete professional machine implementation exposing:

`invalid/multiple mode request -> safety-side rejection -> deliberate valid mode selection -> normal safeguard suspension -> substitute reduced-risk safety function -> three-position enabling device -> separate sustained motion command -> release/overtravel stop through actual final element -> mode exit -> normal safeguard restoration/proof -> safety rearm as required -> application-specific production initiation`.

Prefer a machine tool, press/press brake, or robot cell with function diagrams and a documented power-up or invalid-mode commissioning test. Do not infer machine-specific speed, force, stopping, pressure, or restart values.