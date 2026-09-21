# Siemens / ABB setup-to-automatic return and fresh-start boundary

Date: 2026-09-21

## Question

When a machine returns from setup/manual operation to safeguarded automatic operation, does restoration of the automatic safety permission itself constitute a fresh production start? What should a curriculum learner infer about a start/jog request that remained true across the transition?

## Authoritative evidence

### Siemens SIRIUS Safety Integrated — safe speed / standstill example

**DOC-CONFIRMED.** Siemens' 2025 SIRIUS Safety Integrated application manual presents a machine with distinct setup and automatic speed windows selected by a mode switch. In automatic mode the protective door remains locked while motion conditions require it; in setup mode the door can be enabled under the setup speed-monitoring regime. Crucially, after the relevant actuators have switched off and the feedback circuit is closed, Siemens says the **Start button can be used to switch on again**. The return of valid monitored conditions and feedback therefore restores eligibility for a later start; it is not described as the start event itself.

Source: Siemens, *Safety Integrated Application Manual*, 02/2025, A5E03752040020A/RS-AM/012, section 3.5, `https://support.industry.siemens.com/cs/attachments/download/81366718/application_manual_sirius_safety_integrated_en-US.pdf`.

The associated 3TK2810-1 equipment manual independently documents separate Automatic and Setup monitoring modes and safety-related enabling circuits. This supports the mode/permission separation but does not by itself define ordinary-machine command freshness.

Source: Siemens, *3TK2810-1 safety-related speed monitor*, 08/2023, NEB926246402000/RS-AF/008.

### ABB robot implementation — manual/automatic command separation

**DOC-CONFIRMED.** ABB's 2026 FlexBuffer product manual states that hold-to-run belongs to Manual mode, not Automatic mode, and separately instructs that personnel be clear before pressing the start button. ABB's RAPID reference defines Automatic and Manual as operating modes while describing the main routine as normally beginning when the start button is pressed. Older IRC5 event documentation also distinguishes an **Automatic mode requested/confirmed** transition from program restart and states that after certain recoveries the operator resumes operation by restarting the program.

Sources:
- ABB, *Product manual - FlexBuffer*, 4GAA214009901-001 Rev A (2026).
- ABB, *Technical reference manual - RAPID overview*, 3HAC065040-001 Rev J.
- ABB, *Operating manual - Trouble shooting, IRC5*, 3HAC020738-001 Rev K.

## Evidence-qualified conclusion

The Siemens and ABB examples independently support this architecture:

1. operating-mode selection establishes which protective/safety regime is applicable;
2. safety-related conditions determine whether motion may be permitted in that regime;
3. restoration/confirmation of those conditions does not itself constitute an ordinary production start;
4. a distinct start/restart action remains part of returning to productive automatic motion.

This is strong enough to freeze the following curriculum rules:

- **AUTOMATIC MODE CONFIRMED != PRODUCTION START.**
- **SAFETY PERMISSION RESTORED != FRESH ORDINARY MOTION DEMAND.**
- **FEEDBACK CIRCUIT CLOSED != START COMMAND.**
- **SETUP/MANUAL AUTHORITY ENDED != AUTOMATIC DEMAND REGENERATED.**

## Held-demand boundary

The sources above do **not** explicitly prove a universal implementation rule for every ordinary start/jog input that remains electrically true across the mode transition. Therefore:

- **UNKNOWN / design-specific:** whether a particular PLC/CNC input is edge-triggered, level-sensitive, latched, queued, cancelled, tracked, or regenerated across a mode transition.
- **INFERENCE / curriculum design rule:** where automatic hazardous motion could otherwise begin merely because an old request remains asserted when permission returns, require an explicit freshness mechanism (for example release-and-reassert, rising-edge acceptance after eligibility, or cancellation of pre-transition demand) in the ordinary control state machine.
- Do not claim that Siemens SIRIUS or ABB IRC5 universally implements that exact ordinary-command algorithm unless the specific machine/controller documentation proves it.

This distinction matters: safety permission freshness and ordinary command freshness are separate properties. A safety controller may correctly restore permission while the ordinary controller still mishandles a stale request.

## OpenPressBrake teaching boundary

For a LinuxCNC/OpenPressBrake-style architecture, teach four separate questions:

1. **Mode authority:** which independently supervised operating mode is valid?
2. **Safety permission:** are the applicable protective conditions satisfied?
3. **Ordinary command freshness:** was the jog/start request newly established under the current authority, or did it survive from a previous state?
4. **Physical final element:** did the commanded stop/enable actually produce the required machine response?

LinuxCNC/FPGA logic may implement conservative ordinary-command cancellation/fresh-start behavior, diagnostics and production gating. It must not be described as acquiring personnel-safety authority merely because it refuses stale commands.

## Adversarial failure path

A machine is in setup. The operator holds an ordinary jog input. The safety enabling device is released, correctly removing safety permission. The mode selector is then changed to Automatic and all safeguards become valid. If the ordinary controller treats the still-high jog/start level as a new demand, motion can be requested without a fresh human command even though the independent safety subsystem behaved correctly.

The correct review asks both:

- did the safety subsystem correctly control permission across the transition? and
- did ordinary control invalidate pre-transition motion demand and require a fresh production command?

Passing the first does not prove the second.

## Evidence status

- Siemens setup/automatic monitoring and separate post-feedback Start action: **DOC-CONFIRMED**.
- ABB manual/automatic mode separation and separate Start action: **DOC-CONFIRMED**.
- Universal held-input behavior across arbitrary PLC/CNC mode transitions: **UNKNOWN**.
- Requiring explicit demand-freshness semantics in the design review: **INFERENCE**, justified as a conservative ordinary-control rule and not represented as a safety-standard mandate.

No simulation was required: the unresolved item is implementation-specific and cannot be honestly resolved by a synthetic generic lab.
