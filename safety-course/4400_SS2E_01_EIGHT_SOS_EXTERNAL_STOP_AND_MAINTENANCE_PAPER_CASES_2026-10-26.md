# 4400-SS2E-01 — Eight external-stop/SOS authority paper cases

**Open-book, UNSCORED, no hidden answer or physical authorization.** Read [Siemens original SS2E audit](../research/4400_SIEMENS_S210_SS2E_EXTERNAL_DECELERATION_SOS_TORQUE_RETENTION_SOURCE_AUDIT_2026-10-26.md) and compare [SS1E-01](../research/4400_SIEMENS_S210_SS1_EXTERNAL_STOP_NO_RAMP_MONITORING_AND_TIMER_SOURCE_AUDIT_2026-10-26.md). For each case identify deceleration owner, timing/monitoring scope, physical hazard, independent safety function and missing selected-machine proof.

1. A mill Z axis receives SS2E while its LinuxCNC setpoint freezes. Is the drive autonomously decelerating during the p9553 delay?
2. A machine HMI displays “SS2E active” during p9553. Does this establish SBR/SAM monitoring or safe standstill during that delay?
3. The p9553 delay ends but a motor remains in motion. Distinguish subsequent SOS monitoring/fault reaction from a claim that the timer physically stopped the motor.
4. A technician mistakes SOS for STO and enters to replace a motor brake. What torque, mechanical gravity and maintenance isolation hazards remain?
5. An ordinary motion controller sees a drive-autonomous OFF3 ramp as following error and commands OFF2. Why does Siemens document SS2E as an integration alternative, and why is this not proof of safe stopping?
6. An integrator copies SS1E's STO-at-timeout expectation into SS2E. What fundamentally different energy/torque state follows the delay?
7. A press-brake retrofit proposes motor SOS as proof that independent Y1/Y2 hydraulic cylinders hold the beam. Which physical propositions remain UNKNOWN?
8. After a safety configuration download, a stale cycle-start remains high and a guard is reclosed. Distinguish SOS deselection, safety rearm, occupancy, qualified load hold and fresh motion permission.

**Pass boundary for teaching only:** reject “timer = standstill”, “SOS = torque removed”, “ordinary setpoint = safety final element” and “motor status = Y1/Y2 physical hold.” All **PAPER cases UNSCORED**; independent evaluator and PHY/VAL/PT NOT RUN. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; no personnel-exposed operation or compute.
