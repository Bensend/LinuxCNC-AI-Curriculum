# 25E0 — Service/setup mode authorization and enabling boundary

Date: 2026-09-21

## Question

How should a professional machine separate permission to select a service/setup operating mode from the safety functions that actually make hazardous motion permissible in that mode?

## Siemens implementation evidence

**DOC-CONFIRMED** — Siemens Safety Integrated guidance states that a mode selector must not itself trigger machine operation; operation requires a separate operator action. If a safety function is revoked for setup or maintenance, another safety function must replace it. This is a direct architectural separation between **mode selection** and **hazardous-motion authority**.

**DOC-CONFIRMED** — Siemens TP1000F Mobile guidance for numerically controlled plant says setup mode requires an enabling mechanism; personnel may enter the danger zone while controlled movements are possible, movement is to be reduced according to the machine risk assessment, and movement should only be possible while the enabling mechanism is activated. It also warns that the enabling button alone should not trigger a hazardous operating state: a second specific HMI operation is required.

This supports the chain:

`setup selected -> setup safety functions active -> enabling device held in valid state -> separate deliberate motion command -> controlled/reduced motion`

not:

`setup selected -> motion enabled`.

## Pilz implementation evidence

**DOC-CONFIRMED** — PITmode/PITreader separates access permission from functionally safe operating-mode evaluation. The PITmode flex system requires an authorized transponder for selection; the safe evaluation selects only one mode at a time. Removal behavior is explicitly configurable (hold current mode or fall back to mode 1, with configurable fall-back behavior/acknowledgment options). The product family therefore demonstrates that authorization identity and safe mode selection are related but distinct state.

**DOC-CONFIRMED** — Pilz describes operating-mode selection as part of functional safety when different safety devices/functions are enabled or disabled between modes, and recommends restricting selection to appropriately qualified personnel while keeping use simple enough to discourage manipulation.

## Reusable architecture

The curriculum should teach four separate authorities:

1. **Identity/permission** — may this person request this mode?
2. **Safe mode selection** — which safety-function set is active?
3. **Enabling/protective condition** — what independent protective device or safe-motion condition must remain valid while exposure exists?
4. **Ordinary motion demand** — what deliberate jog/teach/setup command actually requests motion?

A fifth state is needed on exit:

5. **Production re-entry** — guards/protective functions restored, temporary states cleared, required validation/rearm complete, and ordinary production demand treated according to a documented freshness policy.

## Human-factors consequences

- An access key/transponder/password should make authorized service easier without being mistaken for safety proof.
- The enabling device should be ergonomically usable enough that operators are not incentivized to defeat it, but it must remain an independent condition rather than being synthesized by LinuxCNC from a UI mode.
- Mode indication must be conspicuous, particularly when the selected mode changes which safeguards are active.
- A service mode that permits work with an open guard must substitute appropriate protective functions; merely suppressing the guard is not a safety architecture.
- Returning to automatic should not silently transform a previously asserted setup/jog/cycle demand into production motion unless the actual validated design explicitly requires and safely supports that behavior.

## New freezes

- `AUTHORIZED USER != SAFE MODE SELECTED`.
- `SAFE MODE SELECTED != HAZARDOUS MOTION AUTHORIZED`.
- `ENABLING DEVICE VALID != MOTION COMMAND`.
- `MODE SELECTOR != START DEVICE`.
- `GUARD FUNCTION REVOKED != SAFETY FUNCTION ABSENT`; an appropriate substitute protective function is required by the application architecture.
- `SERVICE MODE EXIT != PRODUCTION START`.
- `ACCESS PERMISSION != PERSONNEL-SAFETY RELEASE`.

## Evidence boundary

The inspected Siemens/Pilz evidence strongly establishes authority separation and enabling-plus-separate-command structure. It does **not** establish one universal rule for what happens to a Start/Jog/Cycle signal that remains asserted across every possible service-to-automatic transition. Demand freshness must therefore remain an explicit machine/controller state-machine requirement and be validated rather than inferred from mode selection.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC may own the ordinary jog/cycle command and may receive a safe-mode status for UI and normal-control gating. It must not create the personnel-safety permission merely because `MODE=MANUAL`, `halui.mode.manual`, a GUI button, or an FPGA register says setup. A separate safety architecture must own the protective/enabling conditions appropriate to exposed-person operation.

## Sources

- Siemens, *Safety Integrated Application Manual*, operating-mode selection guidance, 10/2014.
- Siemens, *TP1000F Mobile RO Operating Instructions*, enabling mechanism/setup-mode safety instructions.
- Pilz, *PITmode flex System Description*, operating-mode permission, selection and transponder-removal behavior.
- Pilz, PITmode operating-mode selection/access-permission product and application documentation.

No executable compute was required. No GitHub-hosted runner was used.
