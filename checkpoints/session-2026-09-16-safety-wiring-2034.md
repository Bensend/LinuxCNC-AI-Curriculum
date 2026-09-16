# Safety curriculum continuation — 2026-09-16 20:34Z

- Session start UTC: `2026-09-16T20:34:10Z`
- Session end UTC: `2026-09-16T20:39:40Z`
- Actual elapsed: `5.5 min`
- Overlap status: `NO EVIDENCE OF OVERLAP` — prior checkpoint ended `2026-09-16T19:38:54Z`.
- Compute: `NONE`; documentation/source research only. No GitHub-hosted Actions minutes consumed.
- Status: CHECKPOINTED — safety course remains active.

## Durable work completed

1. `safety-course/MODERN_PRESS_BRAKE_VALVE_MONITORING_TRACE_2026-09-16.md`
   - current PCSS-A E-stop contactor feedback pattern;
   - Y1/Y2 hydraulic final-element monitoring;
   - safety hydraulic outputs separated from ordinary proportional outputs;
   - pump-running state separated from ram safety permission;
   - failure paths and proof hierarchy.
2. `safety-course/SERVO_MACHINE_SS1_STO_ENERGY_BOUNDARY_2026-09-16.md`
   - E-stop/guard -> SS1 -> controlled stop -> STO trace;
   - STO explicitly separated from mains/DC-bus isolation;
   - gravity/overhauling loads separated from torque-off;
   - safe brake/guard-unlock implications;
   - direct comparison to press-brake hydraulic energy boundaries.

## Key evidence gained

- A modern press-brake safety controller can monitor the external E-stop contactor through NC auxiliary feedback rather than trusting output command alone.
- PCSS-A supports per-axis monitoring of hydraulic final elements including combinations of unload/prefill/high-speed/low-speed/safety valves.
- Supported PCSS configurations put important hydraulic functions on safety outputs while proportional enable/pressure remain standard outputs; ordinary proportional command is therefore not the sole safety authority.
- Professional servo safety similarly separates controlled stopping (SS1), torque prevention (STO), holding/gravity restraint, guard release and electrical isolation.
- Manufacturer safe-motion guidance explicitly warns that STO-based standstill does not solve gravitational/overhauling-load motion by itself.

## Exact next work

1. Continue searching for a modern OEM press-brake electrical drawing that exposes what the PCSS E-stop contactor actually disconnects, paired with that machine's hydraulic schematic.
2. Find a complete modern servo machine-tool electrical schematic and overlay guard/E-stop -> safety logic -> SS1/STO/contactors/brake -> motor with mains/DC-bus state.
3. Add an automated-cell final-element trace with safety PLC outputs, zone-dependent stopping and EDM/feedback.
4. Turn the accumulated professional patterns into an adversarial safety-architecture exercise without inventing PL/SIL, stopping distance or machine-specific hydraulic truth.

## LESSON_LOG safe-append status

`LESSON_LOG.md` is known from the preceding checkpoint to exceed the connector's safe complete-fetch window, while available writes replace the whole file. It was not overwritten from incomplete content. Append this row when an atomic/safe append path is available:

`| 2026-09-16 | Safety course — modern press-brake final-element monitoring + servo SS1/STO boundary | 2026-09-16T20:34:10Z | 2026-09-16T20:39:40Z | 5.5 | PCSS FINAL-ELEMENT + SERVO ENERGY-BOUNDARY TRACES ADDED | Modern OEM press-brake contactor load trace; complete servo machine schematic; automated-cell final elements | No overlap; no compute. |`
