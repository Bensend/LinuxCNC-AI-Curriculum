# 4400-HYD-TEMP-01 — Cold oil, hot trip, heater and physical ram-hold: technician review
**2026-10-28 | NO-ENERGY documentary/field-preparation card | UNSCORED | NOT AN ENERGIZED TEST PROCEDURE**

**The trap:** “The oil-temperature switch stopped the motor, so the ram is safe.” A **main-drive shutdown** is not independent hydraulic stopping, load holding, pressure removal or permission to access the die. A heater that can run independently of the motor drive creates a *separate isolation question*.

Read the [original OEM source audit](../research/4400_HYD_TEMP_01_CINCINNATI_PARKER_COLD_OIL_THERMAL_TRIP_HEATER_AND_STOP_PROOF_AUDIT_2026-10-28.md) alongside [FILT-01](4400_FILT_01_FILTER_BYPASS_INDICATOR_MEMORY_AND_COLD_START_TECHNICIAN_CARD_2026-10-25.md), [HYD-AIR-01](4400_HYD_AIR_01_CAVITATION_VS_AERATION_SAFE_SERVICE_FIELD_CARD_2026-10-26.md) and [2520 physical validation](2520_VERIFICATION_VALIDATION_AND_PHYSICAL_PROOF_2026-09-22.md). Cincinnati 60 PROFORM EM-507 (2003) and Parker VA130 are **different product families**, neither proven installed on OpenPressBrake.

| What someone sees | What it can mean | What it cannot prove | Safer, practical next action |
|---|---|---|---|
| Cold pump starts normally | Startup viscosity may be within the pump's starting envelope | Continuous-running viscosity, stop time or guard coverage | Check actual fluid/OEM running range; provide clear warm-up indication without bypassing protection |
| Oil-temperature alarm disappears | Temperature/switch state changed | Physical safety valves closed, load held, no trapped pressure | Keep independent stop/hold/access evidence separate |
| High-temperature alarm stops main drive | OEM's thermal control may remove pump/motor command | Gravity-loaded ram held, pressure zero or personnel-safe access | Treat as fault; use approved isolation and independent load support before service |
| HMI says normal temperature | Ordinary sensor at its location is within display logic | Actual local valve viscosity/temperature or safety response | Review exact sensor placement, actual fluid and component OEM limits |
| Motor OFF but heater option installed | Thermostatic heater may operate independently of motor drive | Heater electrically isolated by that command | Trace heater feed and isolation under qualified maintenance plan; verify at point of work |
| Warm proof test passed | One physical response was measured in its recorded condition | All allowed temperature, fluid, load and maintenance conditions validated | Define SRS-specific boundary conditions and revalidation after fluid/valve/heater changes |

**Minimal existing-record handoff (reuse Stage A A–G, not a new questionnaire):** as-built fluid and valve IDs; operating envelope; sensor and heater wiring/isolators; thermal fault/restart behavior; independent safety controller/final elements; actual physical stop/hold evidence and qualified reviewer. No live pressure checks, no reaching under a ram, no bypassed guards, no improvised temperature forcing.

**Usability design:** labeled fluid grade, readable warm-up status, serviceable filters, visible fault reason, accessible lockable heater isolation and a deliberate fresh restart reduce incentives to bypass. An optional heater can improve pump startup without itself proving safe motion.

**Evidence:** named OEM documents DOC-CONFIRMED; failure-path and review guidance INFERENCE; installed machine UNKNOWN; no physical test, simulation, score or compute. **G0/G1 HOLD.**
