# 3300-W1 — LinuxCNC waterjet implementation hunt and bounded process foundation

Date: 2026-09-14
LinuxCNC source search baseline: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: COMMUNITY-REPORTED real-machine evidence + SOURCE-SEARCHED upstream gap; no dedicated upstream process controller found in this bounded pass

## Purpose

Begin waterjet from actual LinuxCNC machines instead of copying QtPlasmaC assumptions. The initial objective is not to invent a complete waterjet state machine. It is to identify real authority surfaces, process channels and commissioning failures that are visible in public evidence, then name the missing evidence needed before freezing sequencing.

## Upstream source search boundary

A bounded code search of the pinned upstream LinuxCNC tree for `waterjet` finds branding/icon material but no dedicated realtime waterjet process component comparable to `plasmac.comp`.

Classification: SOURCE-SEARCHED GAP, **not proof that LinuxCNC community waterjet controllers do not exist**. Machine-specific HAL, remaps, custom components and private retrofit configs can exist outside upstream.

## Real implementation A — two-nozzle/two-abrasive retrofit

LinuxCNC forum thread, May 2014, by `jtc` documents an active waterjet retrofit where the operator needed independent control of:

- two nozzles;
- two abrasive senders;
- G-code program commands;
- physical panel overrides during AUTO execution.

The original implementation had panel toggle buttons launch M-code-style actions that used HAL `sets`, but AUTO mode would not accept those external command attempts while the program was running. This exposed a real authority problem rather than a simple output-wiring problem.

Community advice from `andypugh` was to avoid shell/MDI mediation for the live panel path and combine G-code-controlled HAL signals with physical inputs in HAL logic. Suggested command surfaces included coolant M-codes or M62/M63, with flip-flop/set/reset logic so program authority and manual override could be reconciled in one realtime-visible state.

### Durable lesson

For waterjet process outputs that must remain operator-controllable during AUTO, do not model manual override as “inject another MDI/M-code while AUTO runs.” Model it as explicit **program request + manual override + output arbitration**.

A bounded generic authority model is:

`program nozzle/abrasive request + manual override/inhibit + machine permissives -> arbitration/state -> physical nozzle/abrasive outputs`

The thread does not establish the correct final sequencing, but it does establish that the nozzles and abrasive senders are independently controlled process channels and that authority ownership matters during AUTO.

## Real implementation B — dual plasma/waterjet Mesa retrofit

A December 2016 LinuxCNC forum build by `emcPT`, performed with `jtc`, reports a machine retrofitted for dual WaterJet and plasma operation using Mesa 7i77 + 5i25 + 7i84. The team rebuilt full control and constructed a new Z axis with 750 mm travel.

The public thread is sparse and its attachments are not exposed through the current bounded retrieval. Therefore this is strong existence/hardware-topology evidence, but **not enough to import plasma process sequencing into waterjet**.

It does establish that a shared motion platform can host both processes while the process-control layer remains selectable/machine-specific.

## Real implementation C — manual Z correction during waterjet cutting

A March 2017 waterjet thread asked for normal G-code Z positioning/retract together with small operator up/down corrections during cutting. Community advice proposed reusing a manual THC-style HAL approach: normal LinuxCNC controls/home Z outside cutting; during the cut a separate control path can issue up/down correction commands.

Classification: COMMUNITY-REPORTED architecture suggestion, not source-confirmed final machine implementation.

### Durable lesson

Waterjet standoff correction is not automatically equivalent to plasma arc-voltage THC. The evidence supports the **need for a separate cutting-time Z correction authority**, but the feedback source here is manual operator input. No arc voltage exists, and no automatic physical standoff sensor contract is established by this thread.

Keep distinct:

- nominal programmed Z / retract;
- cutting-height correction authority;
- correction source (manual buttons here; possible sensor elsewhere);
- motion limits and recovery.

## Real implementation D — CMS 5-axis retrofit investigation

A 2023 thread documents a CMS waterjet owner attempting to retain Parker SLVD2 servo drives while replacing the proprietary controller with LinuxCNC. The early commissioning issue was identifying the actual drive interface: the owner initially described step/direction and resolver/RS-422 behavior, while Mesa developer PCW inferred from drawings that the drives were operating in analog torque/velocity mode with simulated encoder feedback.

PCW recommended Mesa hardware appropriate to ±10 V analog servo control only after verifying the drive mode, and explicitly warned that a 7i96S VFD analog output is unipolar/slow and not suitable as a ±10 V servo command.

This is motion-interface evidence, not process sequencing, but it is important commissioning evidence for industrial waterjet retrofits: preserve original servo/feedback topology from drawings and measurement rather than guessing from connector behavior.

The thread does not yet establish a successful 5-axis waterjet process retrofit, so W2 taper/5-axis process work remains deferred as instructed.

## Initial evidence-backed process surfaces

The public LinuxCNC evidence now supports the existence of these distinct waterjet surfaces:

1. geometric gantry/Z motion;
2. nozzle/water-jet enable channels;
3. abrasive-sender enable channels separate from nozzle channels;
4. program-command authority;
5. physical/operator override or inhibit authority during AUTO;
6. nominal Z positioning/retract;
7. cutting-time Z correction authority that may be manual or sensor-driven;
8. pump/high-pressure system — known to exist physically but **not yet publicly source-traced here**;
9. process readiness/pressure feedback — **UNKNOWN** in inspected implementations;
10. water/abrasive lead-lag and pierce recipe — **UNKNOWN**;
11. pause/abort recovery for pressure, nozzle and abrasive — **UNKNOWN**.

Do not collapse 8-11 into generic spindle enable merely because M-codes can drive outputs.

## What can and cannot be frozen yet

### Evidence-backed

- Water and abrasive can be independent command surfaces.
- Multi-head implementations exist and require independent output/authority handling.
- Manual override must be designed as arbitration/state, not assumed to work through MDI during AUTO.
- Waterjet cutting-height correction can require a distinct authority from nominal Z programming.
- Existing industrial servo hardware can be retained, but drive-mode/feedback provenance must be verified before selecting Mesa interfaces.

### Still UNKNOWN / insufficient public evidence

- high-pressure pump start/ready/fault handshake;
- high-pressure accumulator/intensifier readiness semantics;
- low-pressure water valve versus high-pressure on/off valve ownership;
- abrasive preflow/lag and postflow timing;
- water-only pierce versus abrasive pierce strategy;
- pressure-reduction or low-pressure pierce commands;
- pierce dwell / material recipe provenance;
- automatic standoff sensor type and update loop;
- nozzle clog/abrasive-flow feedback;
- pause, feed-hold, abort and restart reconciliation;
- what state can safely remain energized while motion pauses;
- final multi-head arbitration;
- safeguarding / pressure-system interlocks.

These unknowns block a production waterjet process state model. They do **not** block continuing W1 research.

## Provisional diagnostic layers

The evidence suggests debugging separate chains rather than one “waterjet on” state:

### Motion
`trajectory -> servo command -> drive interface -> motor/feedback -> gantry/head position`

### Process command
`CAM/G-code -> program nozzle/abrasive requests -> HAL/remap/custom arbitration -> physical outputs`

### Manual authority
`panel input -> debounce/state -> override/inhibit arbitration -> process output`

### Height
`nominal Z -> cutting episode -> correction source -> correction authority -> Z command -> physical standoff`

### Pressure / abrasive readiness
**Not yet evidence-backed enough to draw a call flow.** This is the highest-value next W1 source target.

## Adversarial review — 8/8

1. Does lack of upstream `waterjet.comp` prove LinuxCNC cannot control waterjets? **No; multiple real retrofits are publicly reported.**
2. Can plasma Arc OK/THC semantics simply be copied? **No; inspected waterjet evidence does not establish those physical signals.**
3. Are nozzle and abrasive necessarily one output? **No; a real retrofit had two nozzle and two abrasive-sender channels.**
4. Is a panel M-code/MDI command a dependable override while AUTO runs? **No; that exact architecture failed in the reported retrofit.**
5. Does manual cutting-height correction prove an automatic waterjet height sensor architecture? **No.**
6. Does the dual plasma/waterjet machine prove both processes used the same state machine? **No.**
7. Does the CMS drive thread prove a completed 5-axis retrofit? **No; preserve it as commissioning/interface evidence only.**
8. Can a slow unipolar VFD analog output be assumed suitable for ±10 V servo command? **No; Mesa guidance explicitly rejected that assumption.**

## Next evidence path

W1 should now target multiple public sources that expose **pump/high-pressure readiness plus water/abrasive timing**, ideally downloadable HAL/remap/custom components or a build diary showing commissioning and recovery. Search by specific machine/vendor terminology (intensifier, high-pressure valve, abrasive feeder/sender, low-pressure pierce, water-only pierce) rather than repeating generic `LinuxCNC waterjet` searches.

Do not begin W2 dual-head/5-axis taper compensation until the 3-axis process contract has evidence for command, readiness, lead/lag, pierce, height, pause/abort and fault handling.
