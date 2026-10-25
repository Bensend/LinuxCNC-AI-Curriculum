# 4400-SD-01 — Sixteen technician decision cases (PAPER / UNSCORED)
**Date 2026-10-25 | No machine actuation, no learner grading, no hidden answer key**

For each case write: (a) physical hazard, (b) exact OEM evidence versus inference, (c) who owns the safety decision, (d) the next discriminating documentary/physical witness, (e) whether operation with exposed people is allowed. Do not invent stopping times or hydraulic values.

1. SD status says LOCKED; a standard PLC can command UNLOCK. What is the missing personnel-retention claim?
2. A 2023 Schmersal brochure says some noncritical warnings do not switch outputs off immediately. Can a yellow warning be treated as an E-stop?
3. A technician assumes the brochure's 30-minute period is the machine's safe stopping time. Identify the invalid transfer.
4. An SD gateway loses network communication while a separate OSSD chain remains healthy. Which actual circuit must be traced before making a physical claim?
5. A safety controller receives two safe outputs but the non-safe gateway owns lock release. Distinguish interlock stop from personnel-rated guard retention.
6. A power-to-unlock spring lock stays closed after mains loss with a worker inside. Which escape path must be proven?
7. A power-to-lock option releases on power loss while spindle coasts. What independent design evidence is missing?
8. A bistable lock retains its last state on supply loss. Why does that not prove the machine is safe to enter?
9. A red release handle is fitted outside the fence, not inside. Is entrapment resolved?
10. A maintenance worker uses auxiliary release and forgets to restore it. Specify restoration and revalidation before restart.
11. A replacement switch fits the same holes and connector but has different suffix. What must be requalified?
12. An actuator can be held at the switch with the door open. What anti-defeat and physical geometry provisions are needed?
13. The guard closes while someone remains behind the fence. What independent occupancy/restart measures are required?
14. LinuxCNC retains a previous START command after the safety chain is restored. Why must fresh motion be distinct from guard reset?
15. The lock LED says healthy but a separate physical witness shows door ajar. How are contradictory observations handled?
16. A press brake's rear gate is locked but the ram can fall under gravity. What separate final element, mechanical hold and hydraulic evidence is needed?

**Evidence rules:** Schmersal 2023 SD brochure and Pilz guard-locking explainer = DOC-CONFIRMED for their stated scope; proposed failure chain = INFERENCE; installed hardware and physical state = UNKNOWN; no TEST-CONFIRMED outcome. A case is a teaching prompt, not a scored blind external challenge.

**No-energy handoff:** capture exact guard/interlock model, suffix, manual revision, safety OSSD wiring, SD gateway command path, selected safety controller, rated release logic, real access geometry, inside escape, ram holding, service isolation, reset visibility and fresh-start evidence. Record each missing item UNKNOWN; G0 HOLD.
