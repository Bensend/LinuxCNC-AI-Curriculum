# 4400 / 2580 technician exercise — a zero gauge and a still-dangerous machine

**Learner-facing / no hidden evaluator answer.** Documentary design reasoning only; **no powered test, fluid manipulation, pressure setting, opening of hydraulic circuits or live-machine procedure**. Use the 2011 HYDAC accumulator instructions §3.2 and Fig. 1, the 2009 SAF/DSV port diagram and OSHA 1910.147(d)(3)–(6) (if applicable). All machine-specific values and wiring remain UNKNOWN.

## Case

A technician sees a pressure gauge on a SAF block fall abruptly to zero after a maintenance-related depressurization operation. A controller also reports 'valve closed'. A vertically loaded actuator remains elevated. The technician proposes removing a hydraulic line because 'both indicators agree'. The installed block is described verbally as 'SAF20, solenoid', but the only catalog screenshot available has both 'Manual Discharge' and a generic 'Valve Type: Solenoid' field. A colleague proposes adding an ordinary LinuxCNC pressure check to the reset permissive.

## Tasks

1. Reconstruct the *documented* `S/P/T/M1/M2` topology from the 2009 manufacturer diagram. Identify the gauge node and main isolation boundary. State which downstream and gas-side connections are not established by that diagram.
2. Explain what the abrupt zero can mean in the exact 2011 HYDAC gas-precharge-check procedure. Distinguish oil-side pressure from gas precharge, and state what a zero does **not** prove.
3. Resolve the catalog discrepancy only to the degree supported by the exact model code and specific fields. Mark unresolved manufacturer/as-built identity explicitly UNKNOWN. Compare `M`, `E/Y`, `E/Z` only within the dated manual's scope.
4. Write one each of `ENE`, `PHY`, `SRS`, `AUTH`, `DEP`, `ARC`, `VAL`, `UNK`, and `RR` records. The `PHY` proposition must cover actual elevated-load protection, not merely a status bit.
5. Design a *non-executed* contradiction validation case: expected valve feedback + gauge zero, yet an independent motion/holding witness contradicts safe state. Specify who owns the stop/rearm decision, what becomes STALE after replacing a gauge, and what physical evidence would close the question.
6. A colleague suggests 'leave the solenoid bleed de-energized all the time' to improve safety. Explain the potential conflict with energy needed for a controlled protective stop, and why no valve variant may be selected without the machine SRS.
7. Propose two low-friction human-factors improvements that reduce the incentive to bypass guarding or skip verification. Include safe accessible test points and a clearly visible isolation-state indicator, but explain why neither alone is safety proof.
8. State the minimum release decision for a machine with unverified holding and unknown trapped pressure, and how a bounded remote experiment differs from exposed maintenance.

## Review rubric (visible, no hidden solution)

Pass requires explicit separation of gas/fluid/actuator zones, correct revision-specific figure/port interpretation, preservation of model-code ambiguity, independent physical witness, maintenance isolation vs production stop, and refusal to credit an unmeasured machine as safe. **Critical fail:** 'zero gauge + closed valve bit = safe to disconnect'; inventing pressure thresholds or PL/SIL; treating LinuxCNC logic as independent personnel safety; using a 2009 `Y` model description to infer any installed `Z` or `M` behavior; or instructing personnel-exposed operation before basic safety proof.

**Fresh-AI transfer:** Apply the same reasoning to a pneumatic accumulator/reservoir with an isolated downstream actuator and a pressure switch upstream of a check valve. Do not carry over the SAF diagram as if it were the pneumatic circuit.
