# 4400 technician exercise — the bracketed gate that looks healthy

Status: learner-facing exercise, not a hidden external-evaluator answer. Use only a generic example; no actual machine configuration is claimed.

## Scenario

A guarded machine uses a selected Pilz PSEN ml s 1.1 family switch. The electrical diagnostic says **locked**, and a prior build sheet recorded the direct-mount parallel FZh figure. Maintenance replaces the frame with a convenient bracket/handle kit, adds a short push/pull-cable escape release around a tight corner, and stores an old coded actuator nearby. A person can enter the enclosure. A colleague says: “The green lock LED and OSSD status prove the guard is safe; the bracket is just mechanical, and we can keep the old test report.”

## Required technician work

1. Identify at least four separate `PHY` propositions: guard retained until access safe; inside person can mechanically escape; independent machine hazard reaches/maintains safe state; no unprotected restart with person inside.
2. Determine the correct *source lookup sequence* for installed switch orientation, exact bracket number, cable length/route and escape-release mounting. Do not reuse the 7,500 N direct-mount figure on an unverified bracket.
3. Identify why the 80 N accessory release-force figure cannot prove escape from a physically jammed gate.
4. Trace the OSSD/fault/recommissioning chain after auxiliary/escape operation. What physical fact is **not** established by low OSSDs?
5. Explain how an old spare coded actuator can undermine the safeguard and specify a low-friction replacement/storage workflow.
6. Fill `BND`, `HAZ`, `SF`, `PHY`, `SRS`, `AUTH`, `DEP`, `ARC`, `HF`, `VAL`, `PT`, `CHG`, `UNK` links. Mark the old bracket/escape/force proof STALE until revalidated.
7. Write three physical checks that require a safely isolated machine and a qualified person; no hazardous live fault injection with people exposed.
8. Explain why the guard's actuator padlock does not by itself satisfy maintenance hazardous-energy isolation.
9. Compare one robot-cell whole-body-entry variant with a press-brake rear-service-door variant. Keep robot stored gravity loads and press-brake beam/pressure unknown until machine evidence exists.
10. Reject or defend the statement: “The component PL claim and green LED authorize operation.” Cite the precise physical witnesses that would still be missing.

## Review rubric (no model answer)

A defensible response distinguishes mechanical retention, actual egress, OSSD state, independent safe stopping/holding, reset/start and maintenance isolation; finds the orientation/bracket table; flags the ambiguous manual label rather than rationalizing it; preserves all selected-machine unknowns; makes the safe access path easy to use; and does not invent physical limits or achieved integrity. External 2520–25F0 evaluation remains separate and information-separated.
