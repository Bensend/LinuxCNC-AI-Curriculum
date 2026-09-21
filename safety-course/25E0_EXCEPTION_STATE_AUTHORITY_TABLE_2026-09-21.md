# 25E0 — Exception-State Authority Table

Date: 2026-09-21
Purpose: prevent superficially similar permissive states from being treated as equivalent safety evidence.

| State | Activation authority | Protection suspended/altered | Replacement safety strategy | Motion authority | Persistence / limits | Exit / return evidence |
|---|---|---|---|---|---|---|
| Normal production protection | Independent safety architecture | None by exception | Normal validated safeguards and safety functions | Ordinary controller may request motion only inside safety permission | Production lifecycle | Normal validation/configuration baseline and field witnesses authoritative |
| Automatic safety-rated muting | Safety-related muting logic from qualified material/process signals | Defined ESPE protective action temporarily suppressed | Qualified material discrimination/sequence plus application-specific measures | Normal process motion may continue only under validated muting architecture | Temporary; sequence/time/state constrained | Muting sequence ends and normal protective function resumes; next cycle must qualify again |
| Manual muting-dependent override | Safety-related override state machine plus deliberate operator action | Defined ESPE action temporarily bypassed to recover a failed/jammed muting state | Restricted eligibility, visual/area controls, deliberate control, monitoring, bounded time/repetition; device-specific measures | **Separate motion command required in the Pilz implementation studied** | Temporary; exit/timeout/release/interlock/count constraints | Defined exit conditions restore normal protection; repeated failures may lock out |
| Setup/service with enabling + safely limited motion | Safety-related mode selection / enabling architecture | Some normal production safeguards may be replaced for the legitimate setup task | Validated alternate safeguards such as enabling device, safe speed/motion monitoring, restricted access/visibility as application requires | Enabling condition is not itself motion demand; separate deliberate jog/motion command | Limited to selected mode/conditions | Exit setup, restore normal safeguards, clear exceptional state, safety rearm and production-return checks |
| Commissioning force/simulation | Authorized engineering tool/user; may be safety-controller-specific but is an exceptional engineering state | Real field evidence may be overridden/substituted | Commissioning procedure, exclusion/remote operation and other explicit controls; **not automatically a production safety function** | Depends on commissioning procedure; never infer personnel-safety authority from a forced bit | May persist depending on platform; must be positively inventoried/cleared | Remove—not merely disable where distinct—forces/simulations; restore field authority; impact-based physical revalidation |
| Unauthorized defeat / ordinary PLC/LinuxCNC bypass | Ordinary control logic, jumper, spare actuator, HMI mask, forced permissive, etc. | Protection defeated without validated alternate safety strategy | None established | A permissive bit may permit ordinary motion but does not establish safety authority | Potentially indefinite/hidden | Remove defeat, repair motivating workflow, restore normal safety architecture, revalidate destroyed propositions before production |

## Key teaching rule

Two states can produce the same ordinary-control signal (`permit=1`) while carrying radically different evidence. Safety authority comes from the validated architecture, eligibility conditions, diagnostics, physical witnesses, failure behavior, lifecycle and revalidation—not from the Boolean value observed by LinuxCNC.

## Evidence anchors

- SICK deTec4 operating instructions 8021645 (2025-03-27): muting-dependent override eligibility, monitored override, total-time bound, consecutive-override limit/lockout. https://www.sick.com/media/docs/1/41/841/operating_instructions_detec4_safety_light_curtain_en_im0079841.pdf
- SICK Flexi Compact operating instructions 8026634/8026636: visual inspection/access restriction, explicit override transition, state-derived eligibility and limited override cycles. https://www.sick.com/media/docs/9/79/279/operating_instructions_8026634_en_im0096279.pdf
- Pilz PSEN opII4H operating manual 1003501-EN-12 §19.2.7: override must not initiate motion; separate control initiates motion; hold-to-run/secure control and defined automatic shutdown conditions. https://www.pilz.com/download/open/PSEN_opII4H_Operat_Man_1003501-EN-12.pdf
- Prior curriculum artifacts provide the setup/enabling and commissioning-force lifecycle evidence; retain their device/version boundaries.

## Non-transfer rule

The table compares **authority structure**, not numeric acceptance criteria. Do not transfer muting geometry, speed limits, timing, override counts, PL/SIL claims, hydraulic states, stopping distances, or reset semantics from one row/product/machine class to another.