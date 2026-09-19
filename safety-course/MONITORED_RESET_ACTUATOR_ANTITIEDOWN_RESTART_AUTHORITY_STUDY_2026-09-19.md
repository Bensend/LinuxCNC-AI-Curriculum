# Monitored Reset Actuator Anti-Tiedown and Restart Authority Study — 2026-09-19

## Lane / scope

Independent safety-curriculum Lane B. This study deliberately avoids the primary lane's current press-brake safety-related component replacement, hydraulic retaining-function, stopping-performance, and machine-level revalidation evidence package.

Question: what does a professional monitored/manual reset actually prove, what failures is it intended to reject, and where must its authority stop before ordinary machine motion is permitted?

## Architecture freeze

**PROTECTIVE CONDITION RESTORED != RESET ACTUATOR HEALTHY != VALID RESET TRANSITION OBSERVED != SAFETY OUTPUTS REARMED != FINAL ELEMENT PROVED != HAZARD AREA CLEAR != ORDINARY START AUTHORITY.**

Additional freezes:

- **RESET HELD/TIED DOWN != VALID MONITORED RESET.**
- **RESET ACCEPTED != START COMMAND.**
- **RESET DEVICE HEALTHY != EDM/FINAL ELEMENT HEALTHY.**
- **EDM/CONTACTOR FEEDBACK HEALTHY != PHYSICAL HAZARD ABSENT.**
- LinuxCNC/HAL/ordinary FPGA may display reset state or consume a safety permissive, but must not replace a required independent safety-side monitored-reset function.

## Evidence

### Rockwell Guardmaster reset behavior — DOC-CONFIRMED

Rockwell's current Guardmaster Safety Relays user manual distinguishes automatic/manual reset from monitored reset. For monitored reset, the safety inputs must close before reset, and the reset input must execute the device-defined signal cycle before safety outputs can energize. The same manual shows reset circuitry can include output-device monitoring contacts and a reset pushbutton, keeping external-device feedback and reset actuation as explicit parts of the safety circuit.

Source: Rockwell Automation, *Guardmaster Safety Relays User Manual*, Publication 440R-UM013I-EN-P, July 2024.

Evidence class: **DOC-CONFIRMED**.

### Rockwell reset anti-tie-down rationale — DOC-CONFIRMED

Rockwell's Machinery Safebook explains the purpose of requiring a reset change of state: the reset function checks the relevant interlock/contactors and, because a state transition is required, a reset actuator that is bypassed or blocked/tied down cannot silently serve as a permanent reset request. It separately warns that an unmonitored manual-reset arrangement can fail to detect a shorted or jammed reset switch.

Source: Rockwell Automation, *Machinery Safebook 5 — Safety related control systems for machinery*.

Evidence class: **DOC-CONFIRMED**.

### Pilz start/reset semantics — DOC-CONFIRMED

Pilz documents three distinct PNOZ X behaviors: automatic start energizes when the input circuit closes, manual start expects a rising edge, and monitored start expects a falling edge. This independently confirms that reset/start configuration is a deliberate safety-function semantic, not merely a generic Boolean `RESET=1` signal.

Source: Pilz, *PNOZ — Automatic, manual, monitored start* FAQ.

Evidence class: **DOC-CONFIRMED**.

### Schneider monitored falling-edge start — DOC-CONFIRMED

Schneider's Preventa XPSUAT instructions document monitored start with a falling edge: the start input must first be activated for the specified device-defined interval and the safety outputs activate on the falling edge after the safety-related inputs are valid. The numerical timing belongs to that product and is not transferred to OpenPressBrake.

Source: Schneider Electric, *Preventa XPSUAT Safety Module — Original Instructions*, 2019.

Evidence class: **DOC-CONFIRMED**.

## What the evidence does and does not prove

A monitored reset can reject important reset-circuit failures such as a continuously asserted/tied-down reset where the selected device requires an edge/change of state. It does **not** prove personnel absence, actual hazardous-energy removal, mechanical/hydraulic safe state, stopping performance, correct OpenPressBrake reset location, or that ordinary process intent is fresh.

The correct architecture is therefore layered:

`protective devices/interlocks valid -> external-device feedback valid where required -> reset actuator executes required monitored transition -> independent safety logic rearms -> final-element/safe-state conditions remain valid -> ordinary machine control is separately permitted to accept an application-valid fresh start/motion request`.

Whether a particular function may automatically reset or automatically resume is application/risk-assessment specific. This study does not impose manual reset on every safety function.

## Failure-path / commissioning worksheet

| Challenge | Safety-side question | Required observation | Status for OpenPressBrake |
|---|---|---|---|
| Reset pushbutton held before protective condition restores | Does monitored reset reject a pre-existing asserted signal? | No unintended safety-output rearm | **UNKNOWN — machine implementation not selected** |
| Reset input shorted to supply | Is permanent assertion rejected by the selected reset semantics? | Fault/no rearm until valid transition | **UNKNOWN** |
| Reset actuator mechanically jammed | Can the system distinguish a valid operator action from stuck state? | No silent rearm from jammed reset | **UNKNOWN** |
| Protective input restores while reset remains held | Is ordering enforced? | Inputs valid before accepted reset transition | **UNKNOWN** |
| EDM/external-device feedback disagrees | Can reset override a welded/stuck final element? | Reset inhibited; disagreement retained | **UNKNOWN** |
| Reset accepted with person still in accessible hazard area | Is personnel-clear authority independent where bodily entry is possible? | Reset alone cannot prove area clear | **UNKNOWN** |
| LinuxCNC START/JOG/CYCLE remains asserted during safety trip | Does safety reset resurrect stale process intent? | No unintended hazardous motion | **UNKNOWN** |
| Safety-controller power cycle with reset held | Does startup treat held reset as a fresh valid reset? | No unintended rearm/start | **UNKNOWN** |
| Reset wiring bypass installed during maintenance | Is bypass detectable/controlled and removed before service return? | Production authority withheld until restored/validated | **UNKNOWN** |
| Reset works but physical final element remains hazardous | Is reset status falsely treated as safe-state proof? | Independent physical/final-element evidence governs access | **UNKNOWN** |

## LinuxCNC / FPGA boundary

LinuxCNC may request ordinary machine actions after the independent safety system grants the appropriate permissive. It may also display `RESET_REQUIRED`, `SAFETY_READY`, EDM diagnostics, or similar status. Those conveniences must not make LinuxCNC/HAL or the ordinary FPGA the sole authority for a monitored reset credited for personnel safety.

A stale ordinary command surviving a safety trip is a separate process-control problem. Safety reset is not a command-freshness generator.

## OpenPressBrake facts intentionally left UNKNOWN

- Whether every OpenPressBrake safety function requires manual/monitored reset.
- Exact reset device, wiring, safety controller/relay, edge semantics, timing, or location.
- Whether personnel-clear/rear-access proof is required for the eventual machine geometry.
- Exact EDM/final-element topology.
- PL/SIL/category/DC/CCF claims.
- Hydraulic safe-state truth table, pressure thresholds, stopping time/distance, or physical ram-safe criterion.
- Which functions, if any, are allowed automatic reset/restart after validated risk analysis.

## Curriculum takeaway

Teach reset as a safety-state transition with explicit preconditions and failure behavior, not as a generic HMI button. The student should be able to trace `protective condition -> final-element feedback -> reset actuator state history -> accepted monitored transition -> safety rearm -> separate ordinary motion authority`, then deliberately challenge a tied-down, shorted, jammed, pre-held, or bypassed reset path.

## Precise next-work checkpoint

Find a professional complete-machine or manufacturer application exposing:

`protective demand -> safety outputs off -> external switching/final-element feedback -> reset held/tied down or shorted -> monitored reset refuses rearm -> fault corrected -> deliberate valid reset transition -> safety outputs rearm -> physical final-element/safe-state witness -> application-specific fresh ordinary START`.

Prefer an implementation that visibly distinguishes reset-circuit anti-tie-down from EDM and from ordinary process start, and includes a commissioning/fault-injection step for a stuck or shorted reset actuator. Preserve numerical timing as device-specific evidence only.