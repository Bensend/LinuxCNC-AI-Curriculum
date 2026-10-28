# 4400-BOND-01 — Protective earth versus functional EMC bonding (12 PAPER cases)
**2026-10-25 | learner exercise, NOT SCORED, NO PHYSICAL TEST**

Read [original OSHA/Schneider source audit](../research/4400_OSHA_SCHNEIDER_PROTECTIVE_BONDING_DOOR_HINGE_VARIANT_AND_EMC_BOUNDARY_AUDIT_2026-10-25.md). For each case state: fault-exposed metal, source-backed claim, unproved claim, evidence needed, change-control effect and safer low-friction maintenance option. No hidden answer key is present.

| Case | Situation |
|---|---|
| B01 | A metal cabinet door has a hinge but no visible jumper. |
| B02 | The manufacturer has documented and tested its exact switchgear hinge construction; a different CNC cabinet looks similar. |
| B03 | A door-mounted HMI adds a new power cable and strain relief. |
| B04 | A repaint covers the hinge and ground contact surfaces. |
| B05 | An electrician hears a continuity tester beep but has no acceptance method. |
| B06 | A VFD motor shield is connected to the enclosure; PE conductor is unverified. |
| B07 | A panel PC Ethernet shield touches chassis; the protective conductor is missing from the drawings. |
| B08 | An operator removes a removable panel that other cabinet bonding connections pass through. |
| B09 | A new flexible conduit and cable carrier are added; no independent bonding path has been reviewed. |
| B10 | A new door hinge/fastener product replaces the approved assembly. |
| B11 | LinuxCNC displays “all drives ready,” but protective-earth evidence is stale. |
| B12 | Main AC is isolated and protective bonding is verified; the press-brake ram is still elevated. |

## Blank selected-machine evidence
| ID | Artifact/revision | Reviewer | Disposition |
|---|---|---|---|
| BOND-01 exposed-metal and PE topology | UNKNOWN | — | HOLD |
| BOND-02 door/hinge/jumper manufacturer-approved variant | UNKNOWN | — | HOLD |
| BOND-03 fault-path adequacy and qualified verification method | UNKNOWN | — | HOLD |
| BOND-04 door motion, maintenance, repaint and replacement change control | UNKNOWN | — | HOLD |
| BOND-05 functional EMC/signal return separate from PE | UNKNOWN | — | HOLD |
| BOND-06 independent electrical isolation and mechanical Y1/Y2 holding | UNKNOWN | — | HOLD |

**STOP:** no deliberate earth-fault, PE disconnection, energized continuity test, or personnel-exposed operation. No numeric acceptance criterion is supplied. Evidence belongs in restricted as-built records; only status-only references enter the public course.


## 2026-10-28 original OEM lamp discriminator (existing B11, no new case)
[Cincinnati EM-519 2019 original manual, printed p. 6-5](https://wwwassets.e-ci.com/PDF/Manuals/em-519_n-08-19_proform__400-2000_hydraulic_press_brake_osmm.pdf) explicitly says its `GROUND CONNECTED` lamp shows **internal chassis ground** and **does not indicate the machine is grounded**. Extend existing B11's false-green-indicator reasoning: a lit lamp, Ethernet shield, continuity beep, hinge or LinuxCNC `ready` bit is not qualified proof of the protective fault-current path. Actual PE conductor, exposed-metal topology and verification remain BOND-01..06 UNKNOWN; do not perform an energized fault test. OEM-specific DOC-CONFIRMED source, not an OpenPressBrake installed indicator, no new score or release.
