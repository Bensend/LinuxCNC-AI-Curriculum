# 4400-WATERJET-TANK-02 — Catcher tank is not made safe by JET OFF

**NON-GRADUATED documentary review.** [Original manufacturer/incident source audit](../research/4400_WATERJET_TANK_02_ALUMINUM_HYDROGEN_SLUDGE_SPARK_IGNITION_SOURCE_AUDIT_2026-10-27.md).

**Scenario:** A waterjet has cut large amounts of aluminum; a later job uses material capable of producing sparks. The HMI shows STOPPED and pump pressure is zero. Does that clear the catcher tank? **No.** OEM ProtoMAX guidance identifies hydrogen generation from aluminum fines in water and possible accumulation in garnet/sludge. Cutting, stopping and tank-atmosphere safety are different propositions. The OMAX warning is **model-specific**, not proof of the condition of another machine.

**Four different witnesses:** (1) material/sludge inventory and cut sequence; (2) physical ventilation and possible gas-accumulation locations during operation **and idle**; (3) ignition sources and material-change authorization; (4) safe waste handling/maintenance access. None is supplied by ordinary LinuxCNC, FPGA, E-stop or pump-OFF status. OSHA's wet-collector incidents corroborate the broader water-reactive-fines mechanism but are **not waterjet incident reports**.

**Practical design:** accessible tank-cleaning and disposal without awkward guard defeat; easy material-change alerts; ventilation/ignition control appropriate to the actual tank; labeled work instructions and qualified acceptance. Do not improvise a numerical hydrogen threshold, purge time or universal cleaning interval. If the minimum safe-to-operate condition is unverified, withhold personnel-exposed operation.

**Evidence:** OEM/OSHA DOC-CONFIRMED; cross-machine composition INFERENCE; actual tank, concentration, ventilation, ignition and release UNKNOWN; TEST-CONFIRMED none, evaluator NOT RUN. Not evidence about installed OpenPressBrake; G0/G1 HOLD.
