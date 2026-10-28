# 4400-CROWN-01 — Crowning axis and lower-tool-clamp technician review
**2026-10-28 | Source-grounded one-pass field card | PUBLIC DOCUMENTARY ONLY / NOT RUN / NOT A RECOVERY PROCEDURE**

Read the [original Haas/WILA/eCFR source audit](../research/4400_CROWN_01_HAAS_WILA_CROWNING_LIMIT_RECOVERY_GUARD_DELIVERY_SOURCE_AUDIT_2026-10-28.md) and [predecessor Cincinnati hydraulic Auto Crown audit](../research/4400_PROFORM_OPTIONAL_MUTING_ADI_PLUG_FOOTSWITCH_AND_HYDRAULIC_ADDON_AUDIT_2026-10-23.md). This card is not a service manual, permission to operate contactors, bypass authorization or evidence that OpenPressBrake contains crowning.

## One-minute diagnostic rule
**“Crowning” is a function name, not an energy-isolation or safety-circuit description.** A machine may use a hydraulic bed cylinder, a motorized wedge V-axis, or no crowning. A motorized wedge assembly may *also* contain hydraulic lower-tool clamping. Neither normal controller V-position nor a limit-switch label proves physical position, guarded access, tool retention, independent stop/hold or service isolation.

## Technician decision table (no live work)
| Observation or requested task | What the evidence actually establishes | Safe review disposition |
|---|---|---|
| Controller shows plausible `Deflection`, but lead-screw sensor/position disagrees | Haas OEM explicitly lists wrong direction, stale/incorrect feedback as diagnostic possibilities. | **HOLD** ordinary crowning motion; qualified physical/feedback/phase review; do not repeatedly command end-of-travel. |
| Crowning sensor at secondary travel switch | Haas names additional hard-stop switches, but no safety integrity/physical stop time in cited page. | **SERVICE HOLD**; do not assume ordinary reset or generic jog safe. |
| Maintenance person proposes forcing cabinet contactors to recover | Haas's original 2026 §7.3 contains an exceptional manual contactor intervention; its §3.2 restricts cabinet access and forbids safety-device defeat. | **Do not perform from this card**. Refer to OEM/qualified electrical-safety team for controlled method with people outside danger zone and verified protection. |
| Press arrives with motorized crowning assembly but no guards | Exact WILA NSCR-I-HC-CNC/UPB listing says guards and mounting hardware are **not included**. | **HOLD** until correct installed guard/fasteners, accessibility, and safety requirements verified. Catalog delivery is not finished machine. |
| Another WILA variant lists hardened guards | Exact Premium NSCR-II-HC-CNC/UPB lists guards supplied, but no machine-level validation. | Inspect actual guards and tool-change access; no assumption of interchangeability or certified protection. |
| Main ram pump is off | A WILA motorized wedge may have separate motor supply and hydraulic clamp supply; Cincinnati predecessor hydraulic crown differs. | Map **all** installed energy paths and actual mechanical load retention; ordinary command OFF is not isolation. |
| Operator wants quick recovery without cabinet access | Repeated awkward exceptional recovery encourages safeguard defeat. | Engineering action: create qualified accessible recovery workflow, clearly marked unknown-position state and deliberate rearm; do not sacrifice guard/final-element independence. |

## Four-authority boundary
1. **Normal control:** LinuxCNC/FPGA or OEM HMI sets V/Y/tool-clamp commands, displays limits and feedback, and may inhibit routine movement. This is not personnel-safety authority.
2. **Monitoring:** displayed deflection, switch state, motor current, clamp pressure or “ready” are **proposition-specific diagnostics**, not physical safe-state certificates.
3. **Independent safety-related control:** selected guard/E-stop/stop/mode functions must be traced to the **actual installed** safety logic and final elements, with machine-specific independent validation. A switch named “safety” does not establish PL/SIL.
4. **Physical protection and energy removal:** correct guards and fasteners, independently supported gravity-loaded ram, secured tooling, actual electrical/hydraulic isolation and verified stored-energy control; all depend on the selected machine.

## Reuse existing restricted evidence, do not invent a new questionnaire
- **Stage A A:** exact press/option/crown/clamp variants, as-built revision, actual drive technology or dated N/A.
- **Stage A B/E:** crown and tool-change reach/pinch zones, guard/fastener installation, helpers and access.
- **Stage A C/D:** safety-program/final-element identity, crown motor and hydraulic clamp energy paths, load retention, isolators, stored energy.
- **Stage A F:** hazard-specific SRS for ordinary travel, hard-stop recovery, maintenance and deliberate restart.
- **Stage A G:** only a **qualified future** remote/isolated witness plan with exclusion, abort, protection and authorization. No live test authorized now.

## Adversarial reviewer questions — UNSCORED, not an exam bank
- If the motorized wedge has reached its “safety” limit, does that label prove a safety-rated stop? **No**; OEM label and wiring/function evidence are different.
- If one WILA variant is delivered with hardened guards, may all WILA crowning assemblies be treated as guarded? **No**; the exact Pro variant explicitly excludes guards.
- If the V motor is electrically isolated, is the lower die hydraulically retained and the ram supported? **UNKNOWN**; separate clamp and ram physical load paths.
- Does an OEM service passage authorize a LinuxCNC builder to actuate motor contactors from an open energized cabinet? **No**; qualified service context, circuit, protection and personnel exclusion remain unproven.
- Does “no crowning axis” close this hazard? **Only with dated as-built proof**, and it does not close ram, tooling or guarding hazards.

**Source status:** DOC-CONFIRMED exact OEM and eCFR text; INFERENCE safe-design implications; UNKNOWN selected machine; no physical validation, TEST-CONFIRMED result or independent evaluator. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** If minimum safe-to-operate protection cannot be demonstrated, do not operate with people exposed. Any experimental activity must be qualified, isolated/remote, with all personnel outside the danger zone and residual risk documented.


## Non-executable recovery-state contract (engineering proposal, not OEM logic)
| Review state | Entry evidence | Permitted *documentary* next step | What must NOT follow automatically |
|---|---|---|---|
| CROWN-NORMAL | Exact installed V/crown and tool-clamp type, guard/feedback/reference confirmed | Preserve normal-control/safety boundary and current change record | A normal V-position does not authorize personnel access |
| CROWN-DISAGREE | Actual sensor, display, or commanded direction inconsistent | Mark feedback/reference **STALE**, identify qualified service owner and affected dependencies | No repeated jog, no auto-retry or assumption that ordinary limit protects |
| CROWN-HARDSTOP-UNKNOWN | Secondary limit reached or position identity lost | **SERVICE HOLD**; obtain selected OEM safety circuit and approved isolation/recovery plan | No generic reset, cabinet contactor actuation, or bypass inferred from manual text |
| CROWN-SERVICE-ISOLATED | Qualified team has separately documented physical isolation, gravity/tool support and personnel protection | Only qualified approved servicing; if a later energized positioning task is unavoidable, apply the actual jurisdiction/site controlled procedure | No release of G0/G1 or re-energization by this paper card |
| CROWN-REQUALIFICATION-HOLD | Service has ended but sensors, guards, tools, drive phase or reference may have changed | Reconcile `CHG/DEP/PHY/VAL/PT`, independent protective function and deliberate fresh-start requirements | No automatic production rearm merely because the display changes or limit clears |

**Source-integrity nuance:** Haas's 2026 troubleshooting chapter also gives broad startup/reset advice before troubleshooting, while the same manual's safety chapter prohibits operation with malfunctioning components. Read the general instruction in its qualified diagnostic context, **not** as an instruction to clear E-stops and restart whenever a protective device or physical position is uncertain. The manual's §7.1 hydraulic symptom table also contains wording about a material pusher/collet whose applicability to the cited press-brake models is **UNKNOWN**; do not transpose that row into a press-brake fault or maintenance procedure without OEM confirmation. These are documentation-scope cautions, **not** findings of a proven manufacturer hardware defect.
