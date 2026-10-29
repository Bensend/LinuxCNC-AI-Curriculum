# 4400-MWF-01 — Two different reasons a CNC door may not be safe to open

**2026-10-29 | PAPER / UNSCORED / NO MACHINE TEST.** Read [HSE/NIOSH source audit](../research/4400_MWF_01_CNC_COOLANT_MIST_CLEARANCE_VS_MOTION_SAFE_ACCESS_OEM_REGULATOR_AUDIT_2026-10-29.md), existing 2590 guards and the 2520 hazard-to-physical-proposition method.

A finished machining cycle has **two separate questions**: (1) is hazardous motion physically controlled by the independent machine safety system? (2) has the residual metalworking-fluid mist been adequately removed by the actual enclosure/extraction system? Neither answer follows from the other.

## Eight paper challenges

1. LinuxCNC reports IDLE and spindle command zero. The operator opens the enclosure immediately and sees a visible mist cloud. Which physical proposition failed? What evidence was missing?
2. The enclosure fan output is ON but the filter is blocked. What measured or maintainable condition should the operator see instead of a green fan-command icon?
3. The operator proposes bypassing a spindle guard interlock to eliminate a mist-clearing delay. Why is this a category error? Propose a workflow redesign that reduces nuisance while preserving both protections.
4. A technician proposes a fixed 5-second clearance time for every machine. What actual enclosure, LEV, fluid and process data would justify a machine-specific delay?
5. HSE says the mist delay can be implemented by a machine program or timer. Does that make the ordinary CNC program a personnel-safety-rated motion guard? Explain the separate authorities.
6. A NIOSH 0.4 mg/m³ thoracic aerosol REL is offered as a real-time HAL interlock setpoint. Identify the measurement-time and regulatory-category mistakes.
7. The machine has stopped but a worker uses compressed air to clean the part with the door open. Identify aerosol, swarf and human-factor hazards; propose an easier enclosed alternative.
8. Power loss stops the extraction fan; the machine remains stationary. What must be re-established before operator access and fresh restart? Do not invent a universal clearance time.

**No-energy evidence card:** machine and fluid ID; LEV design and real airflow witness; filter/duct inspection; process-specific mist-clearance method; door access/guard safety path; operator-friendly cleaning; independent restart; reviewer role; source classification; unresolved UNKNOWNs. **No operation with people exposed to uncontrolled hazardous motion or inadequately controlled aerosol.** This paper card authorizes no smoke test, guard defeat, live aerosol measurement or physical machine operation.
