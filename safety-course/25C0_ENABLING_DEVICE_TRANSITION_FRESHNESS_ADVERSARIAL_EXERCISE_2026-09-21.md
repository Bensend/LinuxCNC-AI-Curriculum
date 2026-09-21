# 25C0 adversarial exercise — enabling-device transition freshness

## Scenario

A machine has an independent safety controller, a three-position enabling device, a guarded hazard area, and LinuxCNC for ordinary motion control. Setup mode allows restricted manual motion while the normal production safeguard is intentionally suspended under the safety architecture.

An operator squeezes the enabling device from released through center to fully depressed. The safety system stops motion. While recovering from the event, the operator relaxes grip. The switch mechanically passes back through its center position. At the same time, the ordinary LinuxCNC jog button remains held from before the stop.

Later the operator exits setup mode and selects automatic mode while a normal cycle-start input is still physically held true from an earlier attempt.

## Required analysis

1. Identify why `enable_center && jog_request` is an unsafe/incomplete authority model.
2. State what must happen when returning from enabling-device overtravel toward center.
3. Separate enabling permission from the separate ordinary motion request.
4. Decide what should happen to the held jog request across the safety stop and setup-mode transition.
5. Decide whether selecting automatic mode may consume the already-held cycle-start level as a fresh start.
6. Identify which decisions belong to independent safety authority and which may remain ordinary LinuxCNC/FPGA control.
7. Name the machine-specific facts that cannot be invented from the generic evidence.

## Expected reasoning contract

A strong answer recognizes transition history as part of authority. The enabling function must not be inferred merely because the physical switch is currently in its center position after overtravel; the professional ABB pattern requires re-establishment from the released state. The enabling device is permission for a separate start/motion command, not the command itself.

The ordinary jog demand should not silently survive a safety stop/mode transition and become motion merely because safety permission returns. The production start held across a setup -> automatic transition likewise must not be treated as a fresh deliberate start without an explicit, validated design contract. A robust normal-control design cancels stale demand or requires a release/new edge/fresh command as appropriate.

Personnel-safety mode selection, enabling-device evaluation, safeguard suspension and required safety stop behavior belong to the independent safety-related architecture when the risk assessment requires them. LinuxCNC can provide the ordinary jog/cycle request and can enforce additional production freshness, but must not be credited as the safety-rated authority merely because it participates in the sequence.

Do not invent reduced speed, stop category, hydraulic valve sequence, stopping time/distance, PL/SIL, or diagnostic coverage for the target machine.

## Misleading premise

> "The switch is back in the center position and the jog input never went false, so resuming is more ergonomic and avoids requiring the operator to release everything."

Reject this premise. It turns stale physical/input state into renewed hazardous-motion authority and defeats the deliberate rearm semantics demonstrated by professional enabling-device implementations.

## Transfer variant

A plasma table uses a hold-to-run setup pendant instead of a three-position enabling switch. The exact state machine may differ, but the learner must still ask whether a held setup command can become fresh authority after a protective stop or mode transition rather than copying the ABB state machine mechanically.