# 4400-HYD-01 — Sixteen paper technician scenarios (learner-visible, NOT blind)
**2026-10-24 | PAPER ONLY | No fault injection on an exposed machine**

For every scenario state (a) what is known from the provided signal, (b) what physical proposition remains UNKNOWN, (c) who owns the independent safety decision, (d) the least invasive qualified evidence needed, and (e) the safest operational restriction. Do **not** invent hydraulic valve tables, safety integrity or thresholds. Cite exact source revision when transferring OEM behavior.

## Normal drive versus independent safety
1. During fast descent, drive A reports inactive while normal CNC still requests descent. Explain why commanding zero speed alone cannot be credited as a safe stop.
2. Drive A reports active but Y1 accelerates unexpectedly. Distinguish status validity, actuator behavior and independent stopping evidence.
3. Y1 and Y2 have separate drive-active indicators but a common control supply. Analyze a possible common-cause failure without asserting one has occurred.
4. A new FPGA firmware version changes how a drive-active bit is sampled. Which previous safety and normal-control conclusions become stale?

## Valve position versus physical isolation
5. A monitored valve exposes PNP NO and NC outputs. Explain why two contacts on one sensor do not automatically constitute independent redundant valve monitoring.
6. A replacement seated valve has the same external size but a different RU/SU suffix. What must be checked before rearm?
7. A position switch changes while the OEM graph still shows mechanical overlap travel. Which statement about zero leakage would be unjustified?
8. A valve command goes OFF but feedback stays in its previous state. Describe fault handling without assuming whether the valve is stuck or the sensor is wrong.

## Fluid energy and load holding
9. A pressure sensor at one test point reads zero after the pump stops, while an accumulator and second cylinder compartment exist. What remains unknown?
10. A ram-support indicator says ENGAGED but no physical support/load-path evidence exists. What maintenance work remains prohibited?
11. A machine builder removes a flow-restricting orifice after adding safety-rated position monitoring. Explain what evidence and change-control review must precede acceptance.
12. A fast-down-to-press transition produces a sudden one-sided motion. Why is this not proof that a vendor's example overtravel is acceptable?

## Reset, service and human factors
13. Power returns while a foot pedal remains pressed and the safety PLC is green. What distinguishes safety rearm from a fresh cycle start?
14. A technician must remove a guard to read a pressure fitting. Propose a maintainable design improvement that does not weaken safeguarding.
15. A new valve assembly cannot accept the old field-replaceable solenoid. What configuration and maintenance evidence must be updated?
16. A product manual describes one exact hydraulic circuit. An engineer wants to copy its coil truth table into OpenPressBrake. Explain the evidence gate and a safe alternative.

**Review criterion:** a strong answer never treats an HMI status, position switch, drive-active signal or one pressure gauge as full physical stop/hold proof. This worksheet is not scored as an independent blind competency assessment.
