# 4400-ROUTER-SCOPE-01 — CNC router ejection/opening and robot-transfer one-pass safety review
**2026-10-30 | PUBLIC QUALIFIED-REVIEWER AID | UNSCORED / NOT RUN | no machine-release authority**

Use after [GUARD-REACH-01](4400_GUARD_REACH_01_REACH_VS_STOP_VS_EJECTION_FIELD_REVIEW_2026-10-28.md), [DUST-01](4400_DUST_01_WOOD_ROUTER_LEV_CAPTURE_FIRE_AND_CNC_COMMAND_BOUNDARY_MODULE_2026-10-25.md), and [AMR-TRANSFER-01](4400_AMR_TRANSFER_01_HANDSHAKE_IS_NOT_SAFE_TRANSFER_FOUR_CASE_FIELD_CARD_2026-10-30.md). [Original ISO/HSE/OSHA source audit](../research/4400_ROUTER_SCOPE_01_ISO19085_3_HSE_WIS22_EJECTION_OPENING_ROBOT_TRANSFER_SCOPE_AUDIT_2026-10-30.md). This is an **exact machine-class scope addendum**, not a new scored course or substitute for existing evaluations.

## Do not combine these four different questions
| Claim someone may make | What must actually be established | Safe paper disposition |
|---|---|---|
| 'The light curtain stops a person before the tool.' | Human approach, sensor field, stopping time and independent final-element response. | **ACCESS/STOP:** design-specific evidence; ISO 13855:2024 does not rate projectile containment. |
| 'The curtain strips stop a broken router bit.' | Actual tool family, opening geometry, tested curtain/enclosure assembly and ejection path. | **EJECTION:** ISO 19085-3:2021 explicitly excludes specified ejection hazards at curtain openings >700 mm and specified tool failures >=16 mm. Exclusion ≠ approval. |
| 'Our ISO 19085-3 CNC router is safe with a robot loader.' | Robot/transfer hazard map, independent stop/guard interface, payload retention, reset and fresh start. | **CELL INTERFACE:** integrated robotic loading/unloading is outside that standard's addressed scope. |
| 'The spindle is OFF, so we can enter to clean.' | Actual hazardous motion ended; interlocked access, task-specific isolation, residual energy and trapped-person escape. | **ACCESS/SERVICE:** normal CNC OFF indication does not prove a physical safe state. |

**Practical architecture:** Prefer an enclosure/transfer aperture that keeps fragments inside while permitting normal stock flow without routinely removing protection. Keep impact/containment protection distinct from personnel detection. Put clear diagnostics and accessible reset outside the zone with a verified sightline; avoid automatic restart after guard restoration. Provide convenient protected maintenance access and a way to inspect/replace worn curtains without improvised bypass.

**Edition guardrail:** HSE WIS22 was first published 2014, PDF footer revised 04/22 and cites older BS EN 848-3:2012; its example 100-g/70-m/s curtain test is **not** a universal current ISO 19085-3:2021 requirement or a substitute for an actual enclosure rating. ISO 19085-3:2021 remains published but a new draft is in development. Full licensed clauses were not inspected.

**Minimum evidence request, not an energized test:** existing manufacturer enclosure/curtain impact documentation, exact cutter/tool and opening configuration, robot-interface architecture if installed, dated guard drawings, safe-access/restart design and qualified review status. If any essential proposition is UNKNOWN, **do not operate with people exposed**. Experimental operation requires separately qualified isolation/remote authorization with people outside the danger zone and explicit residual risk.

**Status:** all selected-machine proofs UNKNOWN; paper-only UNSCORED, no independent evaluator, no simulation, no physical tests. OpenPressBrake G0/G1 HOLD; do not add another A–G owner questionnaire.
