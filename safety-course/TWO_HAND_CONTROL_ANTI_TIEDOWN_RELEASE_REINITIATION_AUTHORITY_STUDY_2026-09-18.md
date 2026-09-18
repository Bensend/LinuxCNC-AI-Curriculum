# Lane B study — two-hand control, anti-tiedown, release and reinitiation authority

Date: 2026-09-18

## Why this branch

The active primary safety lane has just advanced hydraulic press-brake physical stop proof, periodic stop-performance validation, hydraulic final elements and rescue-motion boundaries. Lane B therefore stays out of those files and studies a separate initiating-device safety function: two-hand control (THC) anti-tiedown, synchronism, release, and fresh reinitiation authority.

This is architecture study, not a claim that OpenPressBrake requires or may rely on a particular two-hand-control implementation.

## Core authority freeze

`LEFT INPUT ACTIVE + RIGHT INPUT ACTIVE != VALID TWO-HAND ACTUATION`.

`BOTH HANDS PRESENT != SYNCHRONISM VALID != SAFETY OUTPUT AUTHORIZED != PHYSICAL HAZARD SAFE`.

`ONE BUTTON RELEASED != OTHER BUTTON MAY REMAIN TIED DOWN FOR NEXT INITIATION`.

`BOTH BUTTONS RELEASED != FRESH CYCLE AUTHORITY`.

`SAFETY RESET/REARM != FRESH TWO-HAND INITIATION != ORDINARY LINUXCNC START/JOG/CYCLE INTENT`.

The safety function must own the validity of the two-hand sequence. LinuxCNC/HAL or an ordinary FPGA may consume state/diagnostics, but ordinary control must not manufacture personnel-safety authority from two raw input bits.

## Evidence and provenance

### SOURCE-CONFIRMED — Rockwell Machinery Safebook 5

Rockwell's *Machinery Safebook 5* describes two-hand controls as requiring two controls to be operated concurrently to start a machine and continuously during the hazardous condition. It states that releasing either control must cease machine operation, and that after one control is released the other must also be released before restart. It explicitly identifies this as anti-tie-down behavior.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/safebk-rm002_-en-p.pdf

Transferable architecture result: simultaneous-looking raw inputs are insufficient. The safety evaluator must retain sequence state so a held/tied-down channel cannot combine with a later actuation of the other channel to create a new valid initiation.

### SOURCE-CONFIRMED — Rockwell GuardPLC THRS function block

Rockwell's GuardPLC certified Two-Hand Run Station function block monitors four input states (NO/NC information for the two controls). The documentation describes a Button Tie-Down condition when the buttons are not actuated within the documented synchronism interval and prevents the `Buttons Pressed` output from becoming active in that condition.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/1753-rm001_-en-p.pdf

Transferable architecture result: `two channels electrically ON` and `valid two-hand event` are separate states. Input complement/disagreement, timing/sequence validity, and anti-defeat state belong in the safety evaluation.

The source's numerical timing is evidence for that implementation, not an OpenPressBrake value.

### SOURCE-CONFIRMED — Rockwell validation checklist

Rockwell publishes a dedicated GuardLogix Two Hand Control Station Function Verification and Validation Checklist. The existence and structure of a safety-function-specific validation artifact is useful evidence that commissioning must verify the configured safety function rather than merely observe normal machine cycling.

Source: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at062_-en-e.pdf

### SOURCE-CONFIRMED — Pilz

Pilz lists two-hand controls as independently monitored safety functions across its PNOZ safety-relay/controller families, including dedicated two-hand monitoring products. Pilz's PITjog material also shows a manually operated device intended for two-handed operation in special operating situations, paired with approved safety evaluation units rather than treating ordinary machine-control inputs as the safety evaluator.

Sources:
- https://www.pilz.com/en-US/products/relay-modules/safety-relays-protection-relays/pnozsigma-safety-relays
- https://www.pilz.com/en-IE/products/operating-and-monitoring/control-and-signal-devices/pitjog-jog-switch

Transferable architecture result: the initiating device and safety evaluator are an explicit safety-function chain; ordinary machine logic remains downstream/separate.

## Evidence classification

- **SOURCE-CONFIRMED:** manufacturer documentation establishes concurrent/two-hand actuation, continuous actuation during the hazardous condition, anti-tiedown/release behavior, safety-side monitoring, and dedicated validation practice.
- **DOC-CONFIRMED:** not separately asserted in this study beyond the source-confirmed manufacturer documents above.
- **TEST-CONFIRMED:** none. No OpenPressBrake hardware or configured safety controller was tested.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** a robust OpenPressBrake architecture, if it ever uses THC as a personnel-protective initiating function, should expose raw channel state separately from safety-side sequence validity and separately again from physical machine response.
- **UNKNOWN:** OpenPressBrake applicability; required THC type; button geometry/spacing/force; permitted operating modes; exact synchronism interval; required control reliability/PL/SIL/category/DC/CCF; stopping distance/time; hydraulic response; whether hold-to-run is required for a particular motion; and the physical final elements/witnesses needed for the actual machine.

## Failure-path analysis

A commissioning/validation plan should deliberately challenge at least these cases without assuming machine-specific timing or hydraulic truth:

1. Left control held before the right control is actuated.
2. Right control held before the left control is actuated.
3. One control mechanically tied down/stuck while the other is cycled.
4. Both controls become active but the safety evaluator judges the actuation sequence invalid.
5. Both controls are valid, then one is released during the hazardous portion of the motion.
6. One control is released and re-actuated while the other remains continuously held.
7. A raw NO/NC or dual-channel input disagreement exists on one station.
8. Safety-controller power is removed/restored with one or both controls held.
9. A safety reset/rearm occurs while one or both controls remain asserted.
10. LinuxCNC retains `START`, `JOG`, `CYCLE`, or a motion request while THC authority disappears and later returns.
11. Safety-side THC validity is TRUE but the commanded final element fails to change state.
12. Safety-side THC validity is removed but a hazardous physical response continues; this must be treated as a final-element/physical-witness problem, not hidden by a correct THC bit.
13. Mode changes while one or both THC controls are already held.
14. A maintenance bypass or temporary defeat causes a station to appear valid; bypass state must not silently become normal production authority.

## Required state separation for curriculum diagrams

A useful professional trace should expose at least:

`left physical actuator`
→ `left safety input/channel integrity`
→ `right physical actuator`
→ `right safety input/channel integrity`
→ `safety-side synchronism/sequence evaluator`
→ `anti-tiedown / both-released-before-reinitiation state`
→ `safety output/permissive`
→ `machine final element`
→ `physical motion/energy witness`
→ `release or invalid-sequence reaction`
→ `latched diagnostic where applicable`
→ `repair/clear`
→ `valid fresh two-hand actuation`

LinuxCNC/HAL/ordinary FPGA command state should be drawn alongside this chain, not substituted for it.

## Commissioning acceptance questions

- Can either single held control be combined with a later actuation of the other to obtain a new safety release?
- Does release of either required control remove the applicable safety authority during the hazardous condition?
- Must both controls return to the required released state before a new initiation can be recognized?
- Are contradictory/stuck channel states diagnosed rather than normalized into a valid actuation?
- Does power restoration with a held control fail to create fresh motion authority?
- Does reset/rearm remain distinct from initiation?
- Can stale ordinary LinuxCNC motion intent survive a safety interruption and become motion merely because THC validity returns? It must not be assumed acceptable.
- Is there a physical witness proving the intended hazardous response actually stopped/changed, rather than only proving the safety evaluator changed its output?

## Practical architecture lesson

Two-hand control is not `AND(left_button, right_button)`. The personnel-protective function is a stateful safety sequence involving channel integrity, concurrent actuation, anti-tiedown/release behavior, continued demand where required, fault handling, and deliberate reinitiation. The machine-control layer can request or sequence production, but it does not get to reinterpret an invalid safety-side input history as valid human intent.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted runner compute was consumed.

## Precise next Lane-B work

Find a complete professional hydraulic/servo press, press-brake, or comparable hazardous machine implementation exposing:

`two physical controls -> safety input diagnostics -> synchronism/anti-tiedown evaluator -> safety output -> final element -> physical motion witness -> one-control release -> hazardous-motion reaction -> both-controls release -> fresh reinitiation -> separate ordinary production sequencing`.

Prefer an OEM/manufacturer commissioning or validation document with an explicit tied-down/stuck-button, channel-disagreement, power-restoration, or failed-final-element test. Preserve the distinction between THC sequence validity and measured physical stopping performance.