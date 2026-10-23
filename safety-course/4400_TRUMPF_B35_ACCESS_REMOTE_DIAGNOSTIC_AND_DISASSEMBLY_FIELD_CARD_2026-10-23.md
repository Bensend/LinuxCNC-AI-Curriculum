# 4400 technician field card — different guards, muted optics, remote service and physical load support
**Paper-only, open-book, non-blind | 2026-10-23 | no machine operation, live fault injection, electrical/hydraulic intervention or personnel-exposed testing.**

Read [TRUMPF B35 2023 OEM audit](../research/4400_TRUMPF_B35_SIDE_DOOR_ASYMMETRY_MUTE_REMOTE_SUPPORT_AND_DISASSEMBLY_AUDIT_2026-10-23.md) and the original manufacturer manual. All questions require distinguishing **what the OEM actually says**, what is an **engineering inference**, and what is **unknown for the selected machine**.

| Case | Challenge | Evidence-grounded disposition |
|---|---|---|
| 1 | A trainee treats opening one side door, both side doors, and the rear door as the same safety event. | **Reject equivalence.** OEM text gives different reactions; selected safety circuit and actual stop/hold remain unproven. |
| 2 | BendGuard is below its mute point; the trainee assumes reduced speed makes die access safe. | **Reject.** OEM says optical protection inactive; independently qualified alternative protection and physical motion/access evidence required. |
| 3 | The backgauge drive DC bus is still energized after E-stop, so the trainee declares STO failed. | **Reject inference.** OEM describes drives supplied but torque disabled; selected drive STO diagnostic/physical proof still needed. |
| 4 | E-stop switches off the hydraulic unit; trainee removes a cylinder without supporting the beam. | **Reject.** OEM warns press beam may fall if hydraulic components removed first. |
| 5 | Remote service can view the HMI; trainee grants remote start because “OEMs allow remote access.” | **Reject.** The manual documents UI access and injury warning, not hazardous remote motion authority. Keep independent local safety and deliberate start. |
| 6 | Operator sees front optical protection and ignores moving backgauge/sheet-sweep exposure. | **Reject.** OEM identifies automatic step-change trapping hazard; map side/rear/helper/workpiece zones. |
| 7 | Trainee copies the manual's disassembly voltage/cooling wait as a universal electrical-safe or hydraulic-safe timer. | **Reject.** Model/task-specific guidance is not absence-of-energy verification or mechanical support. |
| 8 | A technician finds side guards difficult to reinstall and proposes leaving one open for setup. | **Reject.** Redesign accessible setup/guard mounting and verified safe modes, rather than bypassing protection. |

For each case record the **OEM page**, evidence class, affected `PHY-*` proposition, physical or independent safety-function witness required, human-factors mitigation, and a falsifier. This is not a hidden evaluator challenge and cannot graduate 2520–25F0.

**Minimum gate:** `IN-01..10 UNKNOWN`, `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART UNKNOWN`, `VAL/PT NOT RUN`. No selected numerical stop time, speed, PL/SIL or hydraulic truth table. No people exposed to an unproven hazard.
