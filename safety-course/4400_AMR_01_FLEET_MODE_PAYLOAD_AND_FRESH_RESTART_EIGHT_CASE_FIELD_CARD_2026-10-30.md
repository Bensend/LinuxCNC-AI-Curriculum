# 4400-AMR-01 — Fleet-green is not personnel-safe: eight technician cases
**2026-10-30 | PUBLIC PAPER PRACTICE / UNSCORED | NO PHYSICAL TESTS**

Read [fleet/traffic source audit](../research/4400_AMR_FLEET_01_OMRON_2019_2025_FLEET_WIFI_NOT_INTERLOCK_AND_EDGE_BARRIER_OEM_AUDIT_2026-10-30.md) and [mode/payload source audit](../research/4400_AMR_MODE_01_OMRON_JOYSTICK_LIDAR_BYPASS_STOP_ENVELOPE_AND_REARM_OEM_AUDIT_2026-10-30.md). Apply 2520 HZ→PROP→SF/SRS→AUTH→PHY/VAL and 2590 guard/presence-sensing reasoning. No hidden key, score or external graduation.

For **each case**, write: physical hazard; which signal is only normal control/diagnostics; independent safety function and final element; fault/restore/restart state; lowest-bypass layout; what evidence is UNKNOWN; why no exposed operation is authorized until qualified proof.

1. Two identical AMRs meet head-on. Fleet Wi-Fi is connected, but both scanners see the other's recessed scanner slot. Can route green prove the outer envelopes do not collide?
2. An AMR approaches a loading dock whose edge is drawn as a forbidden map polygon. A localization mismatch occurs. What independent physical edge measure remains necessary?
3. A worker drives a robot with a manual joystick to recover a stuck pallet. The dashboard says the scanner is healthy. The exact Omron 2019 SF4 manual mode bypasses LIDAR field detection. Which protection still needs independent review?
4. A shop changes a 250-kg-class platform to a tall, side-overhanging fixture. Navigation footprint is edited, but safety-zone export and stopping verification are unchanged. What invalidates the prior claim?
5. An E-stop is released, motors re-enabled and the older LD manual describes a possible two-second delayed resume. A person is still at the docking fixture. What is the missing deliberate system-level restart condition?
6. A robot turns in place beside a machine door; the forward protective field is clear but a sheet protrudes sideways. Why is a forward scanner-clear bit inadequate?
7. A fleet server loses connectivity while an ordinary LinuxCNC cell requests a part transfer. A route-reservation bit remains high. What must the independently selected transfer safety function do, and what is NOT proven by a PLC bit?
8. A maintenance technician wants to bypass a narrow transfer gate because it is hard to reinstall. What geometry/guard/recovery redesign would make the safe path easier, and what gate stays HOLD until validated?

**Non-negotiable:** do not test on people, drive toward a worker, alter safety-zone configuration, or energize a hazardous machine to complete these questions. No specific speed threshold, stopping distance, safety integrity or machine truth table is supplied as an acceptance value. Manufacturer editions are not interchangeable. For a selected installation, qualified risk assessment and physical witness are required.
