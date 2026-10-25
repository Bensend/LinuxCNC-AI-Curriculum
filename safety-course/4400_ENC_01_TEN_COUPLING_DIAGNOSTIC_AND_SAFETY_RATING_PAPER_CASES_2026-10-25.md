# 4400-ENC-01 — Ten open technician scenarios: encoder safety assumptions are mechanical
**2026-10-25 | PAPER ONLY | 10 scenarios UNSCORED / NOT BLIND**

Use [original 2013 OEM audit](../research/4400_KINETIX_SINGLE_ENCODER_SIL_CLAIM_COUPLING_EXCLUSION_AND_MOTION_DEPENDENT_DIAGNOSTICS_AUDIT_2026-10-25.md). For each scenario, distinguish OEM DOC-CONFIRMED prerequisites from a selected machine's UNKNOWNs; identify the hazard, a plausible failure and a qualified no-energy evidence request. Never invent an achieved PL/SIL or authorize a physical hazard test.

1. An integrator sees “up to PL e” in a Kinetix 2013 manual and applies it to a generic single incremental encoder on a hydraulic ram. Which prerequisites are absent?
2. The correct permanent-magnet motor and Sin/Cos encoder are installed, but a shaft coupling is a friction clamp with undocumented slip potential. Which OEM assumption is unproven?
3. A belt-driven machine uses one encoder on the motor and a large downstream inertial flywheel. The belt fails while the motor stops. What does motor standstill not prove?
4. Two encoders are bolted to the same removable pulley. Both agree after the pulley key shears. Why is channel count not mechanical independence?
5. A dual-encoder Kinetix installation passes discrepancy checks. Which encoder is the speed/standstill calculation based on in this exact OEM, and what does encoder 2 contribute?
6. A safety monitor is installed but has not moved for a year. What product-specific statement about motion-dependent diagnostics should prompt qualified maintenance review? Why must no hazardous motion be improvised?
7. A mechanic replaces an encoder coupling with a different design after an earlier integrity calculation. What change-control/validation must be reopened?
8. A vendor quotes 20 ms input-to-safe-stop-initiation as proof that a heavy spindle is fully stopped in 20 ms. Distinguish reaction initiation from physical stop time.
9. A safe-speed drive option defaults to single-encoder mode. Does default mode establish that a selected machine has met its coupling and encoder fault-exclusion conditions?
10. The press-brake Y1/Y2 encoders show standstill while hydraulic pressure remains trapped and the ram is gravity loaded. Which mechanical/hydraulic independent witnesses must precede access?

These cases are public practice, **not** independent blind scores. The evaluator must use new surfaces and withhold its oracle until learner precommitment. No test, physical proof or machine release is implied.
