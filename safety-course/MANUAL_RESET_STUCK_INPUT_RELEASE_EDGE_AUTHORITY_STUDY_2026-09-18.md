# Manual reset stuck-input / release-edge authority study

Date: 2026-09-18
Lane: independent safety curriculum Lane B

## Why this branch

The primary lane's newest durable work is press-cycle interruption/recovery/fresh reinitiation. This study deliberately does not extend that press-cycle evidence package. It addresses a different cross-machine safety weakness: whether a manual-reset input can be held, welded, shorted, synthesized by ordinary control, or already active when a reset becomes required.

## Evidence provenance

### ABB — manual reset architecture

**DOC-CONFIRMED** — ABB's safety guidance, *Using an HMI for reset and start*, describes manual reset as a separate deliberate action that does not initiate motion or a hazardous situation, enables acceptance of a separate start command, and is accepted by disengaging the reset actuator from its energized position. ABB recommends triggering on the falling edge and monitoring the positive-signal duration so a glitch or stuck reset is not accepted.

Source: https://new.abb.com/low-voltage/products/safety-products/using-an-hmi-for-reset-and-start

### ABB AC500-S SF_ResetButton

**DOC-CONFIRMED** — ABB's AC500-S `SF_ResetButton` safety function block explicitly implements trailing-edge reset behavior. `ResetIn` distinguishes released/actuated states; the block emits `ResetOut` after the falling edge. It also exposes minimum and maximum actuation-duration parameters; too-short and too-long actuation are ignored. ABB notes that the original safety manual, not the web quick reference, is authoritative for a functional-safety application.

Source: https://en.help.plc.abb.com/sf_resetbutton.html

### Schneider XPSMC diagnostics

**DOC-CONFIRMED** — Schneider's XPSMC safety-controller documentation exposes diagnostics including `reset button blocked` and `restart interlock active`. Schneider also documents that external errors keep affected safety outputs deactivated until the error is corrected and RESET is operated. This supports treating reset-input integrity and restart-interlock state as explicit diagnosable conditions rather than assuming a logical TRUE is a valid human acknowledgement.

Sources:
- https://www.se.com/us/en/download/document/33003275K01000/
- https://www.se.com/eg/en/faqs/FA177458/

## Architecture freeze

`RESET INPUT HIGH != DELIBERATE RESET ACTION`.

`RESET BUTTON PRESSED != RESET ACCEPTED`.

`RESET BUTTON RELEASED != RESET ACCEPTED` unless the safety evaluator has established that the complete reset conditions and reset-input behavior are valid.

`RESET ACCEPTED != SAFETY FUNCTION HEALTHY` unless all prerequisites required by that safety function have been established.

`RESET ACCEPTED != HAZARDOUS MOTION AUTHORITY`.

`RESET ACCEPTED != FRESH START / JOG / CYCLE INTENT`.

A reset signal that is already active before reset is requested must not silently become a fresh deliberate acknowledgement merely because the protected condition later becomes ready.

## Why release-edge behavior matters

A level-sensitive reset can accidentally turn a maintained electrical state into repeated or deferred acknowledgement. Examples include a welded pushbutton contact, short to 24 V, stuck HMI/PLC bit, wiring fault, or a button deliberately held while another person restores a guard or clears a fault. ABB's release-edge and duration-monitoring pattern gives the curriculum a concrete professional implementation for distinguishing a human reset gesture from a maintained level.

This does **not** establish universal reset timing values. ABB's block parameters are implementation evidence, not OpenPressBrake settings.

## Separation from ordinary LinuxCNC / FPGA control

**INFERENCE** — For OpenPressBrake architecture, LinuxCNC/HAL or the ordinary FPGA may display reset-required status and diagnostics, but an ordinary software bit must not be the sole authority that transforms a stuck/maintained reset input into personnel-safety rearm. Where reset is part of a required safety function, validity belongs in the independent safety path.

A LinuxCNC `START`, `JOG`, `CYCLE`, valve command, or enable that remains asserted while reset is pending is not made fresh merely because the safety system later accepts reset.

## Failure-path commissioning questions

1. Hold RESET before opening and reclosing a guard. Does the later reset request require a new valid deliberate action rather than accepting the already-high input?
2. Hold RESET while an E-stop or protective-device condition is restored. Does restoration alone leave restart authority absent?
3. Simulate a reset contact stuck high. Is the condition rejected/diagnosed rather than repeatedly acknowledged?
4. Apply a very short reset pulse. Is it rejected when the selected safety implementation requires deliberate-duration qualification?
5. Hold RESET abnormally long. Is a maintained/stuck input prevented from becoming indefinite reset authority?
6. Power-cycle the safety evaluator with RESET held. Does power restoration avoid manufacturing a valid reset event?
7. Restore a final element or EDM condition while RESET is held. Does feedback becoming healthy avoid retroactively converting the held level into acknowledgement?
8. Accept reset while ordinary LinuxCNC START/JOG/CYCLE remains asserted. Is a separate fresh ordinary motion request still required where the machine architecture requires one?
9. Fault or disconnect the reset input. Is the diagnostic distinct from a safeguard fault, final-element fault, and ordinary-control fault?
10. If an HMI displays a Reset button, identify whether it is only an ordinary request/diagnostic interface or actually part of the safety-related reset implementation; do not assume touchscreen location or ordinary PLC logic satisfies the safety function.

## Evidence labels / limits

- ABB manual-reset behavior: **DOC-CONFIRMED**.
- ABB `SF_ResetButton` trailing-edge and duration qualification: **DOC-CONFIRMED**.
- Schneider reset-blocked / restart-interlock diagnostics: **DOC-CONFIRMED**.
- OpenPressBrake use of an independent safety-side reset validator: **INFERENCE** pending actual safety architecture selection.
- OpenPressBrake reset device, wiring, diagnostic coverage, required PL/SIL/category/DC, timing windows, visibility/location, safety-controller function block, and restart semantics: **UNKNOWN**.
- No claim here is **TEST-CONFIRMED** or **SOURCE-CONFIRMED** from OpenPressBrake hardware/source.
- No **COMMUNITY-REPORTED** evidence is used.

## Practical design lesson

Treat reset as an event with provenance and prerequisites, not as a Boolean permission bit. A useful state trace is:

`RESET REQUIRED -> prerequisites physically/safely satisfied -> deliberate reset actuation -> valid release / input-integrity evaluation -> RESET ACCEPTED -> safety rearm eligible -> separate fresh ordinary START/JOG/CYCLE intent -> hazardous motion authority`.

Each arrow needs an identified owner and witness. LinuxCNC's ordinary machine-control state must not collapse these states into one `machine-on` bit.

## Compute

No simulation, synthesis, benchmark, or executable test was needed to answer this evidence question. No GitHub-hosted Actions minutes and no self-hosted runner compute were consumed.

## Precise next independent work

Find a professional implementation that exposes a reset input fault end-to-end: `reset required -> reset input stuck/shorted/held -> safety diagnostic -> outputs remain inhibited -> reset-input repair/release -> valid deliberate reset -> safety rearm -> separate fresh start`. Prefer a manufacturer safety-controller application with wiring/function-block detail and final-element feedback. Keep it independent of the primary lane's press-cycle interruption/recovery package.