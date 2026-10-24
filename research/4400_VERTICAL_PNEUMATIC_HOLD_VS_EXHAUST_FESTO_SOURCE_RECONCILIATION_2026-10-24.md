# 4400 — Vertical pneumatic load: safe exhaust versus pressure retention versus mechanical holding

**Date:** 2026-10-24 UTC. **Original source reconciliation / paper engineering lesson / NOT selected-machine validation.** Continues [pneumatic safe-exhaust audit](4400_PNEUMATIC_SAFE_EXHAUST_VARIANT_RESET_TRAPPED_VOLUME_SCOPE_AUDIT_2026-10-24.md) without changing the primary OpenPressBrake Y1/Y2 hydraulic evidence priority.

## Unresolved question resolved by manufacturer evidence

The first safe-exhaust audit identified that a vertical cylinder or suspended clamp can move when its supply is vented. Does an industrial safety architecture always dump compressed air on protective stop? **No.** Festo publishes distinct safety engineering examples that intentionally **retain compressed air** in a vertical drive during emergency-stop operation and combine mechanical braking/clamping with pneumatic control. This is an important source-backed alternative, **not** permission to leave arbitrary pneumatic circuits pressurised or call them safe for maintenance.

## Direct original manufacturer sources and scoped findings

**Festo, _Safety engineering guidelines — Pneumatic and electric solutions_, publicly readable page 52:** https://www.festo.com/PDF_Flip/safety/en/files/assets/basic-html/page52.html

- **DOC-CONFIRMED:** The manufacturer's example explicitly says the pressure supply is not deactivated, the air remains trapped in the drive on emergency stop, and the drive is **not free of compressed air**. It is described as recommended for vertical axes and includes a braking unit, servopneumatic controller, separate switching valves, pressure monitoring and non-return valves.
- **DOC-CONFIRMED:** In the described single-clamping-unit arrangement, the axis must first reach standstill before clamping. The example refers to a STOP request and delayed switching of the emergency-stop valves. That sequencing is **specific to the published architecture**; it does not authorize implementing a personnel safety delay inside ordinary LinuxCNC/FPGA logic.
- **DOC-CONFIRMED:** The page distinguishes two-channel stopping from one-channel blocking within the example and identifies the complete example as **not** itself a Machinery Directive safety component. Published category/PL values are conditional on correct implementation, not generic values to assign to a machine.

**Festo, same guidelines, page 56:** https://www.festo.com/PDF_Flip/safety/en/files/assets/basic-html/page56.html

- **DOC-CONFIRMED:** Festo explicitly states that clamping units and end-position locking are **not complete safety solutions**, although they can form part of one. It distinguishes use as a holding device (pressure/power failure) from use as a braking device (stopping motion), and lists distinct certified and noncertified variants. A generic rod lock, end-position latch or brake-shoe description is **not** a qualified safety function by itself.

**Festo, same guidelines, page 49:** https://www.festo.com/PDF_Flip/safety/en/files/assets/basic-html/page49.html

- **DOC-CONFIRMED:** A separate example for lifting/rotary cylinders deliberately keeps both cylinder chambers pressurised after electrical power-off. Its product and application are **not** interchangeable with page 52's servo-pneumatic stop/hold example or a safe-exhaust valve.
- **INFERENCE:** Different machine hazard propositions can demand different physical states: retaining air may be necessary to hold a load, while removing air may be necessary for safe access to a pneumatic pinch point. These may require a separate restraint or staged sequence to reconcile.

**Festo, _MS-SV_ 2023/05 manufacturer catalogue:** https://www.festo.com/media/pim/796/D15000100122796.pdf

- **DOC-CONFIRMED:** The MS6-SV-E safe-exhaust function is a different product-level proposition. The manufacturer limits downstream devices that impair exhaust and explicitly excludes the E/D from use as a press safety valve. A venting component is not a substitute for the load-holding architecture above.

No new LinuxCNC source, as-built machine schematic, hardware experiment or external competency test was performed. No numeric braking force, stopping distance, delay, pressure or PL/SIL has been transferred.

## Safety propositions must be separated

| Proposition | Potential architecture | What it does **not** prove |
|---|---|---|
| `PHY-MOTION`: hazardous motion stops before access | Independent safety-related stop control and qualified physical braking/stop witness | That residual compressed air is gone |
| `PHY-HOLD`: gravity/spring load remains restrained | Appropriately selected brake/rod lock/positive mechanical restraint with qualified load path | That a moving load can be caught safely, or that a clamp is safe for a worker to remove |
| `PHY-ENERGY`: maintenance zone has no dangerous pneumatic energy | Lockable physical isolation, appropriate zone bleed, verification and restraints | That a machine under normal guarded operation must always have zero air pressure |
| `PHY-RESTART`: reset does not restart hazardous motion | Independent reset and local deliberate new START after occupancy check, with stale commands invalidated | That a component's 'ready' status or released rod lock is a safe restart |
| `PHY-ACCESS`: person cannot be struck/crushed or trapped | Guards, occupancy/escape, load restraint, verified stop/hold and physical energy state for the actual task | That a 'stop category 1' label alone proves safe entry |

**Core conflict:** A cylinder held by **trapped compressed air** is not pneumatically deenergized for service. A cylinder rendered pneumatically deenergized may be mechanically unsupported. These are distinct hazards; solve both rather than relabeling one as the other.

## Adversarial sequence and failure-path reasoning (paper only)

1. **Protective stop while vertical actuator is moving.** A simple dump valve removes air; gravity may accelerate the load. **UNKNOWN** actual load/stop response. Do not assume stopping or holding. A documented independent stop/hold arrangement and physical witness are required.
2. **Commanded controlled stop then clamp.** Festo page 52 uses a standstill-before-clamp condition in a specific design. A failed velocity sensor, timing error, broken coupling or loss of normal controller authority can invalidate an unqualified standstill inference. Safety-related sequencing must be independently allocated and validated, not copied into HAL.
3. **Clamping unit says engaged.** Mechanical engagement feedback observes its specified target, not automatically the full external load path, rated holding capacity or clamp wear. Obtain exact manufacturer variant and design evidence; no borrowed numerical rating.
4. **Maintenance after a successful protective stop.** Festo page 52 explicitly retains compressed air. A protective-stop indicator cannot substitute for upstream physical isolation, controlled relief of all hazardous zones, gravity restraint and verification under OSHA 1910.147 where applicable.
5. **Return after power failure.** A load may be held, but the cylinder can still move on re-pressurisation or lock release. Reject held START requests, ensure the local area is clear and require a deliberate new production START independent of safety reset.
6. **Maintenance bypass temptation.** If the rod lock is hard to inspect, a technician may wedge it or bypass its interlock. Redesign accessible restraints, guarded inspection points and easy reinstallable hardware; do not accept a procedure that predictably encourages defeat.

## Machine-class transfer without false equivalence

- **Press brake:** Y1/Y2 ram hydraulics remain a different system. This pneumatic evidence can inform an **actual** auxiliary clamp or backgauge actuator only after installed hardware is identified. It is not evidence for ram holding or a hydraulic valve truth table.
- **Robot cell:** Tool grippers may need retained part-holding while the robot itself requires independent motion stopping. Verify dropped-part and stored-air risks independently.
- **Saw/feeder:** A spring-return stock clamp can release when air is dumped, while a blade continues coasting. Separate blade standstill, clamp state and access control.
- **Mill/lathe:** Pneumatic toolchanger or chuck accessories may store energy and require a separate safe service zone; spindle STO does not establish chuck/tool retention.
- **Plasma table:** Torch lift/air assist can behave differently from high-voltage cutting energy and fumes; safe exhaust is not complete machine isolation.

## Evidence ledger and non-graduation

| Claim | Classification | Evidence | Open witness |
|---|---|---|---|
| Festo page 52 retains air on emergency stop in its vertical-axis example | DOC-CONFIRMED | Manufacturer page 52 | Exact selected design, stop/hold physical test UNKNOWN |
| Festo says a clamping/locking unit is not a complete safety solution | DOC-CONFIRMED | Manufacturer page 56 | Installed lock variant and qualified load path UNKNOWN |
| A different Festo example holds both chambers pressurised on power-off | DOC-CONFIRMED | Manufacturer page 49 | Actual applicability UNKNOWN |
| Exhausting air can remove support of an externally loaded actuator | INFERENCE | Physical reasoning plus manufacturer alternatives | Machine-specific behavior NOT TESTED |
| Ordinary LinuxCNC/FPGA must not own independent personnel-safety authority | Existing course safety boundary; no new source trace | Current 4400 architecture contracts | Selected independent wiring UNKNOWN |
| Selected OpenPressBrake uses this pneumatic scheme | UNKNOWN | No as-built evidence | `IN-04c` optional intake UNKNOWN |

**No new lab:** Source documentation already discriminates the competing design approaches. An experiment without the selected actuator/load is not justified and would not establish physical safety. `VAL/PT NOT RUN`; 4400-HY-01 fresh handoff PREPARED/NOT RUN, 2520–25F0 external gates OPEN. No personnel-exposed operation authorized. Any eventual hazardous verification requires an independently approved remote/isolated plan with all people outside the danger zone and residual risk stated.

**Next question:** If an actual pneumatic auxiliary is identified, which selected safety function is required for *each* mode—controlled stop, mechanical holding, pneumatic venting, maintenance isolation or combination—and which independent physical witness proves each? Do not invent acceptance values.