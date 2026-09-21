# 25E0 — Production-Return / Exceptional-State Checklist and Adversarial Exercise

Date: 2026-09-21
Status: learner-facing safety-course artifact

## Purpose

Use this before declaring a machine ready for normal production after commissioning, maintenance, setup, troubleshooting, bypass, force, simulation, override, or safeguard defeat. It is deliberately proposition-based: a green bit, cleared alarm, removed jumper, or reset does not prove the physical proposition that was temporarily bypassed.

## Production-return checklist

For each item record **PASS / FAIL / UNKNOWN / N/A**, the evidence class (`SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, `UNKNOWN`), and the witness used. A safety-critical UNKNOWN blocks the acceptance claim that depends on it.

### A. Exceptional-state inventory

- [ ] Identify every physical defeat aid used: spare actuator, jumper, blocked/taped sensor, temporary wiring, disconnected feedback, bypass plug, service key, defeated enabling device, temporary guard removal.
- [ ] Identify every software exceptional state: PLC/safety force, LinuxCNC/HAL simulation or substitution, diagnostic override, test mode, service/setup mode, safety-function deactivation, alternate parameter set, temporary timeout/limit change.
- [ ] Identify any simulated or substituted physical witness and state exactly which physical proposition it stopped proving.
- [ ] Confirm exceptional-state inventory against the actual machine/configuration, not memory alone.

### B. Positive clearance

- [ ] Physical defeat aids are removed and normal field wiring/devices restored.
- [ ] Software forces/overrides are **removed**, not merely disabled where the platform distinguishes those states.
- [ ] Simulated witnesses/substitutions are removed and real field witnesses are again authoritative.
- [ ] Service/setup/commissioning state is positively exited; persistence across reboot, project download, recipe change, operator login, or mode transition has been considered.
- [ ] Temporary alternate parameters are restored to the accepted production values.
- [ ] Safety configuration/project identity is checked against the accepted baseline/signature/version where the platform provides one.
- [ ] Temporary commissioning indicators, warnings, and access controls are cleared only after the exceptional state itself is cleared.

### C. Physical proposition revalidation

For every bypassed/substituted witness, answer: **what physical fact did this witness normally prove, and what evidence now proves it again?**

- [ ] Guard/interlock: physical guard/protective-device behavior is exercised; a healthy input bit alone is insufficient after actuator defeat.
- [ ] Final element: contactor/valve/brake/drive safe-state behavior is checked using the validation evidence appropriate to the function.
- [ ] Process response: required motion/speed/pressure/position/energy endpoint is witnessed where the safety claim depends on it.
- [ ] Stored/gravity energy: retention, decompression, blocking, brake capability, or other design-specific physical evidence is re-established where applicable.
- [ ] Any safety-related component, plumbing, mechanics, sensor mounting, wiring, parameter, or logic changed during service is included in an impact-based revalidation scope.

### D. Fault and diagnostic restoration

- [ ] Faults are not merely acknowledged; the underlying condition and affected proposition have been checked.
- [ ] Required fault-injection/diagnostic tests are repeated when service could have invalidated them.
- [ ] Reset/rearm behavior is checked separately from physical safe-state proof.
- [ ] No diagnostic suppression, stale maintenance alarm mask, or test-only permissive remains active.

### E. Authority and demand freshness

- [ ] Personnel-safety release remains owned by the independent safety architecture, not ordinary LinuxCNC/FPGA logic.
- [ ] Ordinary machine-control readiness is separate from safety reset/rearm.
- [ ] A Start/Jog/Cycle/enable demand that existed before or during the exceptional state is treated according to the machine's validated transition semantics; do not assume a universal held-demand rule.
- [ ] Where fresh demand is required by the design, verify a deliberate post-return transition rather than relying on a signal that stayed asserted.
- [ ] Return to automatic/production mode does not itself initiate hazardous motion.

### F. Human factors and handoff

- [ ] The legitimate maintenance/setup task can now be done without recreating the defeated safeguard.
- [ ] Any friction that motivated the shortcut has an engineered correction or a documented safer workflow.
- [ ] Production operators can readily see normal versus exceptional mode/state.
- [ ] Shift/service handoff cannot silently inherit an exceptional state.
- [ ] If a safeguard cannot be restored and the minimum safe-to-operate threshold is not met, **do not operate with people exposed to the hazard**. Any necessary experimental operation is isolated/remote with people outside the danger zone and residual risk explicitly controlled.

## Acceptance rule

Production return requires more than `all alarms clear`. The acceptance record must show:

`exception inventory complete -> exceptional states positively cleared -> normal configuration identity established -> destroyed physical propositions revalidated -> safety reset/rearm valid -> ordinary control authority restored -> demand freshness handled -> production handoff complete`

Do not collapse these into a single `SAFE` Boolean in teaching or design documentation.

---

# Blind adversarial exercise — do not add an answer to this file

A machine has just completed troubleshooting after intermittent guard and motion faults. During service:

1. A spare coded guard actuator was taped beside the guard switch so technicians could repeatedly open the physical guard.
2. One safety input was forced TRUE in the safety controller. Before handoff the technician selected **Disable Forces**, but did not inspect whether the force assignment still exists.
3. LinuxCNC was temporarily configured to substitute a simulated `axis-stopped` indication for a field-derived diagnostic used by the HMI. The HMI now displays `STOPPED`.
4. A service-mode parameter set reduced commanded velocity and lengthened one diagnostic timeout.
5. A safety-related sensor bracket was moved and retightened.
6. The safety project reports its expected signature and no active safety fault.
7. The guard is now physically closed. The spare actuator is lying on top of the enclosure but has not been inventoried or controlled.
8. The operator's Cycle Start input was held TRUE before the first fault and remains electrically TRUE.
9. Safety reset is accepted and the normal controller reports ready.

## Learner task

Without inventing machine-specific safe speeds, stopping distances, PL/SIL targets, hydraulic states, or controller semantics:

1. Decide whether normal production may resume now.
2. Build an exceptional-state inventory from the facts above and identify what is still UNKNOWN.
3. For each force, simulation, defeat aid, parameter change, or moved component, name the physical proposition whose evidence may have been destroyed or weakened.
4. Distinguish configuration identity, safety reset, field-device validity, process-response evidence, and ordinary demand freshness.
5. State the minimum evidence needed before each affected acceptance claim can become PASS.
6. Explain how you would prevent the same maintenance workflow from encouraging future defeat.
7. State what must happen if the required safeguard cannot be restored but limited diagnostic motion is still necessary.

## Scoring focus

A strong answer preserves authority boundaries and evidence classes, blocks on safety-critical UNKNOWNs, refuses to treat a signature/reset/green HMI as physical proof, notices the difference between disabled and removed forces, scopes revalidation to changed physical/configuration elements, and does not invent a universal held-Cycle-Start behavior.