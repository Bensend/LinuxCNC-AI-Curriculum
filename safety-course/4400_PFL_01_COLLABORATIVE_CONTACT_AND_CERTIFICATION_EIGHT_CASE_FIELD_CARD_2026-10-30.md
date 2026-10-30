# 4400-PFL-01 — Collaborative robot contact and certification: eight unscored technician decisions
**2026-10-30 | PAPER ONLY / NOT RUN / NOT A BLIND EVALUATOR**

Read [PFL-01 original UR/ISO scope audit](../research/4400_PFL_01_UR_FORCE_LIMIT_KNEE_LEVER_CONTACT_VS_COLLABORATIVE_ACCESS_OEM_AUDIT_2026-10-30.md), [ROBOT-CERT-01 certificate/version audit](../research/4400_ROBOT_CERT_01_UR_2026_2011_CERT_VS_2025_PLAN_AND_FREEDRIVE_HGC_SCOPE_AUDIT_2026-10-30.md), and existing [robot plane geometry audit](../research/4400_ROBOT_PLANE_01_UR_SW10_15_DYNAMIC_SAFETY_PLANE_LATE_TRIGGER_AND_UNMONITORED_GEOMETRY_OEM_AUDIT_2026-10-29.md). This card is public, unscored training, not an evaluator hidden-answer packet or selected-machine approval.

For each case, record `BND | hazard/contact proposition | exact evidence/UNKNOWN | independent safety authority | physical witness | operator-friendly redesign | HOLD/eligible for qualified review`. Do not assume any actual robot or contact thresholds.

1. A UR10e SW5_23 safety table lists **25 N force-limit accuracy** and PL d/Cat 3. A sales flyer calls the entire palletizing cell safe for unguarded people. Distinguish accuracy, configured limit, actual contact force/pressure and complete cell integrity.
2. The tool center moves slowly near the base, but a person's fingers can be pinched between a robot link and a bracket. Apply the OEM short-lever-arm warning and propose a **physical geometry** improvement before adjusting a numeric limit.
3. A robot arm reaches outward at low speed while a helper can stand in its radial path. Explain why the OEM knee-joint exception defeats a speed-only safety argument.
4. A robot has a blunt compliant flange, but its attached sheet-metal blank has a sharp corner and a vacuum gripper may release it on stop. Separate robot PFL, tool/workpiece contact, drop-zone and final energy control.
5. A cell technician toggles Freedrive during Manual teaching. A supervisor declares Automatic Mode collaborative-safe. Identify the missing application-specific PFL/guard validation and the mode transition/restart checks.
6. A robot's published PL d/Cat 3 safety functions are valid for a specified model, but a firmware update, new tool mass and relocated fixture change the work envelope. Identify exact certificate scope, changed hazards and which validation must reopen.
7. A marketing page dated May 2026 advertises a January 2027 ISO 10218-1:2025 certification target. A procurement record calls an existing 2011-certified robot '2025-certified'. Identify the documentary contradiction without treating the future target as achieved.
8. A low-cost retrofit removes a physical guard because 'PFL handles it', but the robot also carries a powered deburring spindle. Propose the least inconvenient robust protection for exposed tool energy and deliberate restart, preserving independent safety authority.

**Expected reasoning boundaries (public guidance, not a scored key):** identify transient versus trapped contact, body/fixture/tool geometry, safety-rated functions versus ordinary LinuxCNC telemetry, actual certification/version, physical evidence needed, and practical ways to avoid bypass. Do **not** assign contact-force numbers, safe speed, stop distance, PL/PFH, hydraulic truth or test outcome without selected-machine evidence. Qualified human-contact tests are **not authorized** by this paper exercise.

**Current status:** all cases **NOT RUN**; no independent evaluator; no self-hosted or GitHub-hosted compute; OpenPressBrake G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.
