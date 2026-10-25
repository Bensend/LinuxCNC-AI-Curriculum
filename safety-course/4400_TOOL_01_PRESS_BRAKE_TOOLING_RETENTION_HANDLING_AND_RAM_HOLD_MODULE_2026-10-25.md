# 4400-TOOL-01 — Press-brake die/punch retention, tool-change handling and machine holding
**4400 safety implementation | 2026-10-25 | NON-GRADUATED | PAPER ONLY**

## Competency
Given a selected press-brake tooling change, a fresh AI/technician must distinguish **anti-drop retention, bending-load clamping, horizontal roll-out protection, suspended-load support, independent ram holding, and fresh restart**. It must refuse to infer safe access from one clamp command, E-stop, or CNC “ready” bit.

Prerequisites: 2520 hazard/SRS derivation, 2580 hydraulic safety, 2590 guard access, 25E0 change/validation, 4400 OpenPressBrake G0 intake. This module adds no safety authority to ordinary LinuxCNC/FPGA.

## Evidence route
Read [WILA/OSHA original-source audit](../research/4400_WILA_TOOL_RETENTION_SAFETY_CLICK_E2M_GUARD_AND_RIGGING_SOURCE_AUDIT_2026-10-25.md). WILA's Safety-Click applies to **top tools ≤12.5 kg** on compatible products; E2M provides horizontal movement, and cataloged variants have distinct retention and roll-out mechanisms. OSHA's sling and covered-crane rules add separate load/rigging hazards. This is **DOC-CONFIRMED** product/regulatory context, **not** an installed-machine design.

## Physical hazard map
1. **Suspended punch/upper tool:** falls on hands/feet when an incompletely retained segment releases; moving punch can trap fingers between holder and tool.
2. **Heavy tool sliding sideways:** low-friction rollers ease handling but may permit unexpected roll-out if end guard/stop absent.
3. **Clamped but improperly seated punch:** bending loads can eject or shift a tool; anti-drop feature is not a bending-load rating.
4. **Tooling under an elevated ram:** ram/gravity/accumulator/valve energy remains separate from tool-clamp energy; E-stop or zero CNC motion request is not physical ram restraint.
5. **Hoist/rigging interface:** sling damage, sharp die edges, unbalanced tool and swing are independent hazards.
6. **Mode and rearm:** setup/tool-change must not inherit a retained cycle-start or bypassed safeguard.

## Safety-function derivation (example requirement language, NOT a selected SRS)
| ID | Required proposition | Primary physical mechanism | Evidence owner |
|---|---|---|---|
| SRS-TOOL-01 | Prevent unintended tool release/fall during defined insertion/removal | Exact compatible tool/holder anti-drop and secondary handling support | Tooling manufacturer + qualified integrator |
| SRS-TOOL-02 | Prevent unintended horizontal roll-out | Physical end/roll-out guard or equivalent selected retention | Qualified tooling engineer |
| SRS-TOOL-03 | Ensure tool correctly seated and clamped for bending loads | Selected clamp/seat/load mechanism and inspection | Tooling engineer; no invented capacity |
| SRS-TOOL-04 | Prevent ram motion/drift while hands exposed during setup | Independent selected ram stop/hold/energy management | Safety/hydraulic engineer |
| SRS-TOOL-05 | Prevent unexpected motion after setup/guard restoration | Independent reset/rearm and fresh deliberate normal start | Safety controls engineer |
| SRS-TOOL-06 | Prevent crushing by suspended tool and rigging | Rated lift and people-exclusion/physical support | Qualified lifting personnel |

**Separate states:** TOOL_CAPTURED, TOOL_CLAMPED_FOR_BEND, TOOL_TRANSFER_RESTRAINED, RAM_PHYSICALLY_HELD, ENERGY_ISOLATED_FOR_MAINTENANCE, PEOPLE_CLEAR, and START_FRESH. A single green lamp cannot prove the conjunction.

## Worked failure analysis
- **Loss of clamp energy:** exact clamp fail state UNKNOWN. A mechanical anti-drop feature may retain a compatible tool while bending clamping is lost. Response must inhibit bending and prevent human exposure until selected condition is established.
- **Wrong part/weight:** “Safety-Click” branding on another part is not evidence that a >12.5 kg tool is safely retained. Check exact compatible retention method and weight.
- **Missing roll-out guard:** a smooth-moving E2M tool can still leave its holder. Prefer captive, easy-to-reinstall guard/end stop; an awkward removable stop creates a predictable bypass incentive.
- **Machine E-stop during tool change:** normal command inhibited does not establish independent ram holding, pressure isolation or suspended-load safety.
- **Guard reinstalled after setup:** restoring a guard is not an automatic permission to restart; require cleared access, safety reset and new normal start in that order.
- **Tool supported by hoist:** a suspended load does not make it acceptable to work under it; use selected approved support/positioning arrangements that keep hands outside pinch zones.

## Practical human-factors design
Use tool carts at transfer height, labeled per-tool mass/compatibility, protected rails, captive end guards, fixtures that support tool weight before unclamping, and visible independent clamp/seat checks. Prefer quick secure capture and mechanical roll-out prevention over relying on a second person to catch a falling punch. Make safe setup faster than defeating guards; observe real tool-change steps with the operator before finalizing layout.

## Adversarial exam (unscored; evaluator must remain separate)
1. “Safety-Click is rated 12.5 kg, therefore the hydraulic holder can bend safely with any 12.5 kg punch.” Explain the conflation.
2. A 17 kg punch slides smoothly on E2M rollers; its end guard was removed for speed. What independent physical proposition fails?
3. The CNC reports E-stop and no commanded Y motion while a technician changes an upper die. Which safety facts remain unknown?
4. A clamp pressure switch reads healthy but the segment is tilted. Can bending proceed? Identify independent witness.
5. The hoist operator is ready to lift while another worker steadies a tool beneath it. Name the conflict and a safer transfer architecture.
6. After a tool change, the guard closes and an old foot-pedal command remains high. Explain fresh-reset versus fresh-start requirements without asserting exact LinuxCNC behavior.
7. A different vendor's holder is substituted with identical-looking geometry. Which exact records invalidate the previous qualification?
8. A workshop wants a low-cost safeguard. Compare a captive end stop/tool cart against a software warning with respect to fall prevention.

**No learner-facing answer key is supplied.** Independent scoring and physical validation remain open. For practice only, use the [technician worksheet](4400_TOOL_01_TECHNICIAN_CASES_AND_BLANK_WITNESS_2026-10-25.md).

## Counterfactual and release decision
If a selected holder's failure state differs from this audit, the module's central separation of retention/clamping/ram/hoist authority remains valid; selected implementation and acceptance **must not** be frozen until exact parts and physical evidence exist. **NON-GRADUATED**, independent evaluation NOT RUN, physical proof NOT RUN. OpenPressBrake G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. No personnel-exposed test authorized. No simulated lab justified for mechanical product facts.

## Exact-part correction / automatic changer transfer (same-session)
The generic ≤12.5 kg Safety-Click statement **does not resolve an exact 12.5 kg tool**: WILA's classic BIU-026 ATC page uses **<12.5 kg** for its vertical Safety-Click parts. Preserve the product-specific distinction rather than rounding away an OEM boundary. [TOOL-02 ATC source audit](../research/4400_WILA_NS_ATC_GSERIES_INCOMPATIBILITY_SAFETY_CLICK_SENSING_AUDIT_2026-10-25.md) also documents NS ATC versus classic G-Series incompatibility and why process-position feedback is not physical tool-transfer proof. Exact installed part manual remains the authority; no selected-machine qualification follows.
