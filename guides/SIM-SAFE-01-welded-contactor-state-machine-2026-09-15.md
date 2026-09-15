# SIM-SAFE-01 — Welded Contactor Human Lesson / State Machine

Status: FIRST IMPLEMENTABLE SPECIFICATION

## Human objective

Teach one idea so clearly that it transfers to other machines:

> **A command saying OFF is not proof that hazardous energy is actually gone.**

The learner should discover why downstream device feedback exists, why reset and restart are different, and why LinuxCNC can be a useful witness without being the final safety authority.

## Scenario

A mill spindle is powered through two independently commanded external contactors, K1 and K2. A monitoring safety device commands both contactor coils and receives normally-closed feedback contacts in its external-device-monitoring (EDM) loop. LinuxCNC receives a diagnostic/status witness and may request reset, but cannot override an unsafe EDM state.

This is a teaching abstraction. It is not a claim that every spindle or safety relay is wired this way.

## Visible learner diagram

```text
[E-STOP / GUARD]
       |
       v
[MONITORING SAFETY DEVICE] <----- [RESET REQUEST]
       |       ^
       |       +------ EDM: K1/K2 actual feedback
       v
   K1 coil + K2 coil
       |         |
       v         v
   [K1 power] [K2 power]
        \       /
         [SPINDLE ENERGY]

LinuxCNC ---- reset request / diagnostic witness ----^ 
```

The UI should visually separate **requests**, **safety authorization**, **physical switching**, and **diagnostics**.

## State variables

Boolean unless stated otherwise:

- `estop_ok`
- `guard_ok`
- `reset_request`
- `safety_authorized`
- `k1_coil_cmd`
- `k2_coil_cmd`
- `k1_power_closed_actual`
- `k2_power_closed_actual`
- `k1_feedback_closed` — feedback state representing K1 power contact returned to de-energized/open condition
- `k2_feedback_closed`
- `edm_ok`
- `spindle_energy_available`
- `linuxcnc_status_ok`
- `linuxcnc_frozen`
- `restart_request`

Fault flags:

- `FAULT_K1_WELDED`
- `FAULT_K2_WELDED`
- `FAULT_EDM_K1_STUCK_GOOD`
- `FAULT_EDM_K2_STUCK_GOOD`
- `FAULT_RESET_STUCK`
- `FAULT_LINUXCNC_FREEZE`

## Deterministic rules

### Physical contactors

When `k1_coil_cmd = true`, K1 power contact is closed.
When `k1_coil_cmd = false`, K1 power contact opens **unless `FAULT_K1_WELDED = true`**.
K2 behaves equivalently.

Feedback reflects the actual de-energized position unless its feedback fault is injected. A welded K1 therefore causes the K1 feedback to disagree with the expected reset-ready state, unless the feedback itself has also failed deceptively.

### EDM

`edm_ok` is true only when the modeled external-device feedback is in the expected reset-ready state before reauthorization.

A single welded contactor with healthy feedback must therefore prevent a new safety authorization after the stop cycle.

Do not teach that EDM magically removes energy. EDM is **detection/restart inhibition**. The second switching path is what can still remove spindle energy after one contactor welds in this simplified series-power scenario.

### Safety authorization

Safety authorization may become true only when:

- E-stop channel condition is healthy;
- guard condition is healthy;
- EDM is healthy;
- a valid deliberate reset event occurs.

Reset is an acknowledgement/rearm event, not a spindle restart command.

Loss of E-stop/guard condition removes authorization. Restoring the E-stop/guard alone does not restart the spindle.

### LinuxCNC

LinuxCNC may:
- display E-stop/safety status;
- display EDM/fault diagnostics if wired to receive them;
- issue a reset **request**.

LinuxCNC may not set `safety_authorized = true` directly.

If `FAULT_LINUXCNC_FREEZE = true`, the safety device/physical stop exercise must remain independently capable of removing authorization. The lesson must make this visible.

### Hazardous-energy witness

For this simplified two-series-contactor lesson, `spindle_energy_available` requires both K1 and K2 power paths closed. This is an exercise assumption, not a universal machine model.

A single welded K1 plus healthy K2 therefore still permits removal of spindle energy when K2 opens, while EDM prevents reset because K1 failed to return correctly.

## Exercise sequence

### Round A — normal behavior

1. Learner enables the machine.
2. Learner starts the simulated spindle.
3. Learner presses E-stop.
4. Both contactors open; energy witness goes unavailable.
5. Learner releases E-stop.
6. Machine remains unauthorized until deliberate reset.
7. Reset authorizes the safety path; spindle still requires a separate restart command.

Checkpoint question: **Why didn't releasing E-stop restart the spindle?**

### Round B — cheap single ordinary relay

Learner may replace the monitored/two-contactor arrangement with one ordinary relay/contactor path.

Inject `power contact welded`.

Expected discovery: command and UI may say OFF while physical energy remains available. There is no independent downstream witness in the simple architecture.

Do not label the component bad merely because it is inexpensive. State exactly which fault is uncontrolled.

### Round C — K1 weld with K2 + EDM

1. Start from healthy authorized state.
2. Inject `FAULT_K1_WELDED` while energized.
3. Press E-stop.
4. K1 remains physically closed; K2 opens.
5. Spindle-energy witness becomes unavailable because K2 opened.
6. K1 feedback fails to return; EDM becomes unhealthy.
7. Release E-stop and press reset.
8. Authorization remains false.
9. LinuxCNC diagnostic may show `external switching device did not return` or equivalent plain-language lesson text.

Checkpoint question: **What actually stopped the energy, and what actually prevented the next reset?** Correct answer distinguishes K2 from EDM.

### Round D — LinuxCNC freezes

Repeat stop with `FAULT_LINUXCNC_FREEZE`.

Correct lesson outcome: the ordinary HMI/status display may freeze or become stale, but the modeled independent safety path still responds to the physical E-stop. The learner must not use the stale UI as proof of physical safe state.

### Round E — deceptive feedback fault

Advanced round: combine a welded K1 with a feedback path falsely reporting healthy. Mark this a **compound fault** and show why diagnostic architecture/validation matters. Do not infer a PL/SIL/category from the outcome.

## Progressive reveal

Default learner view shows:
- hazard-zone/spindle-energy indicator;
- E-stop/guard controls;
- reset control;
- K1/K2 physical contact animation;
- machine authorized/not-authorized.

Troubleshooting reveal 1:
- K1/K2 coil commands.

Reveal 2:
- K1/K2 actual power-contact state.

Reveal 3:
- K1/K2 EDM feedback.

Reveal 4:
- LinuxCNC diagnostic witness and whether it is fresh/stale.

This prevents the lesson from becoming a giant truth table while still allowing an engineer to inspect every state.

## Cheap-component swap behavior

Parts palette for first prototype:

- `ordinary relay/contactor — unmonitored`
- `two ordinary contactors — no feedback`
- `two contactors + monitoring relay/EDM`
- `drive STO pair` — shown only as a later comparison; explicitly note STO does not prove mechanical stopping/load holding.

Use relative cost bands (`$`, `$$`, `$$$`) initially, not current retail prices. Exact prices age quickly and can bias the lesson toward brands rather than architecture.

## Pass criteria

Learner passes SIM-SAFE-01 only if they can explain all of these without naming a standards category:

1. The OFF command is not the same thing as the physical contact state.
2. With K1 welded, K2 is the element that removes energy in the modeled series path.
3. EDM detects the failure and prevents reauthorization; it does not itself remove spindle power.
4. Reset is not restart.
5. LinuxCNC status is useful diagnostic information but is not proof that the physical contactors opened.
6. A cheaper architecture is acceptable only if its uncontrolled failure modes are acceptable for the actual hazard/use; price alone does not determine safety.

Critical fail: learner says `LinuxCNC says E-stop, therefore spindle energy must be gone`.

## Transfer prompt

Show a hydraulic cylinder or gravity axis with the electrical contactors removed from the diagram and ask:

> If the valve command says OFF, what physical fact would you need to establish before declaring the hazard controlled?

Expected transfer: the learner asks about actual energy/motion/load-holding state rather than assuming command OFF proves safety. No hydraulic truth table is supplied by this lesson.

## Implementation note

This state machine can be implemented entirely in browser-side deterministic JavaScript. No simulation runner is required. Unit tests, if later useful, must run on the local `[self-hosted, openpressbrake]` runner only; GitHub-hosted Actions compute is prohibited by current curriculum policy.
