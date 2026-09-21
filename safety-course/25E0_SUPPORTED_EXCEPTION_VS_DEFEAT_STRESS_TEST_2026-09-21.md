# 25E0 — Supported Exception vs Unauthorized Defeat Stress Test

## Scenario

A guarded automated machine must occasionally be entered for setup/recovery. Two implementations both expose an ordinary controller diagnostic named `recovery_permit=1`.

**Implementation A** uses a deliberately selected setup mode, disables automatic operation, requires a three-position enabling device plus a separate held jog command, and uses an independently safety-monitored reduced-motion condition required by its machine-specific safety design. Releasing or overtraveling the enabling device removes exceptional motion eligibility. Return to production requires restoration of the normal safeguard and explicit production re-entry.

**Implementation B** uses a spare guard actuator fixed near the interlock, a taped ordinary jog button, and a LinuxCNC velocity override set low. The normal controller also reports `recovery_permit=1`.

After maintenance, both machines show zero speed, no ordinary alarms, `recovery_permit=1`, and the guard input is true. The automatic Cycle Start input has remained electrically asserted throughout the work.

## Learner tasks

1. Explain why equal `recovery_permit` values do not imply equal safety evidence.
2. Identify the independent propositions that Implementation A must still validate; do not call it `safe` merely from the architecture description.
3. For Implementation B, name the physical propositions destroyed or never established by the spare actuator, taped control and ordinary software speed limit.
4. Decide whether either implementation may infer a fresh automatic-production demand from the held Cycle Start signal. State the evidence class for your answer.
5. Describe production-return evidence without inventing numeric safe speed, stopping distance, pressure, force or PL/SIL values.
6. State what must happen if a required personnel-safety proposition remains `UNKNOWN` and people would otherwise be exposed.

## Expected reasoning boundary

A strong answer separates: mode authority; safeguard state; enabling state; actual process-motion witness; final-element/process safe-state evidence; ordinary motion demand; production demand freshness; configuration identity; exceptional-state clearance; and machine-specific energy hazards.

Implementation A is a recognizable professional **supported-exception pattern**, but that pattern alone is not proof that its machine-specific implementation is valid. Implementation B substitutes ordinary control and defeated physical sensing for safety evidence and therefore cannot inherit Implementation A's authority merely by producing the same normal-controller bit.

The held Cycle Start question must not be answered by guessing universal LinuxCNC or machine semantics. The safe curriculum rule is to require an intentional production re-entry policy that does not allow stale ordinary demand to acquire authority merely because safety eligibility returns; exact edge/state implementation is design-specific unless documented for the actual system.

If a required safety proposition cannot be established, normal operation with people exposed is not acceptable. Experimental operation, if necessary and separately justified, must isolate people outside the danger zone and state residual risk plainly.
