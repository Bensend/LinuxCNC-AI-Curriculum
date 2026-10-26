# 4400-SUPPRESS-01 — Protect the output without hiding the release delay
**2026-10-26 | Practical 4000 safety lesson | NON-GRADUATED**

## Learning goal
Distinguish **command deassertion**, **electrical suppression**, **coil-current decay**, **mechanical relay/valve release**, **independent safety output state**, **machine physical stop/hold**, and **restart authorization**. A coil protector is not a personnel-safety function.

## Evidence
Read the [Omron safety-relay/Schneider exact-part source audit](../research/4400_OMRON_SAFETY_RELAY_DIODE_SUPPRESSION_RELEASE_DELAY_AND_SNEAK_CURRENT_OEM_AUDIT_2026-10-26.md) and the companion [LEAK-01 original IntelliVAC audit](../research/4400_ROCKWELL_INTELLIVAC_OFF_STATE_LEAKAGE_SNUBBER_POWER_UP_AND_DELAY_OEM_AUDIT_2026-10-26.md).

| Proposed change | What it may improve | What it may worsen or leave unproved |
|---|---|---|
| Plain diode across DC coil | suppress back-EMF at driver | longer release; no physical stop proof |
| Diode + Zener | different energy dissipation/release tradeoff | requires exact ratings, not a generic fix |
| RC across opening control contact | reduce switching transient/arcing | OFF leakage into high-impedance receiver |
| No suppressor | may remove one residual-current path | driver stress/contact wear; no safety proof |
| LED/contactor-status monitoring | useful diagnostics | LED may mean coil power, status may mean command, not physical power-pole state |

**DOC-CONFIRMED:** Omron safety-relay precautions describe release-time increase with suppression and sneak-current failures; Schneider's LC1D38BL has model-specific built-in suppressor and opening-time data. **INFERENCE:** stop-time budget must include exact final-element electrical and mechanical response. **UNKNOWN:** actual OpenPressBrake values.

## Documentary first, no energized experiment
A qualified engineer records exact coil, switching output, suppression part/location, supply, relay/valve model, feedback and final energy-removal path. Determine which OEM stop/release figures are relevant and what qualified physical witness would be needed. Preserve the independent safety-controller and load-holding boundary. Reopen validation after suppressor, driver, relay, valve, feedback or wiring change. Never prescribe a diode value, jumper, live probing, or a simulated stop time as a substitute for physical validation.

## Human factors
Supply a documented compatible replacement kit and easily inspected suppression/feedback labels; do not let operators 'solve' a slow stop or nuisance fault by removing parts or overriding guards. If a support/guard is awkward to use, redesign it to make the safe method easier.

## Cross-machine differences
A mill spindle may coast after contactor opening; a press brake has gravity/hydraulic holding; a lathe has chuck/workpiece inertia; a plasma table has high-voltage and arc sources; a robot cell requires access/occupancy management. The same electrical release mechanism does not imply the same stopping function or risk.

**PUBLIC adversarial prompt, UNSCORED:** After a coil diode replacement, the PLC output goes OFF immediately and the contactor feedback eventually changes. Can the old protective-distance calculation remain valid without further evidence? Identify the missing release-time and physical-stop witnesses. G0/G1 HOLD, evaluator NOT RUN.
