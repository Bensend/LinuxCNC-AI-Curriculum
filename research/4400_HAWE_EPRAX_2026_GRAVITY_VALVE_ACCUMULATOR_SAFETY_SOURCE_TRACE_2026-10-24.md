# 4400 — HAWE ePRAX modular 2026 press-brake hydraulic safety authority and stored-energy source trace

**Date:** 2026-10-24. **Status:** original manufacturer-source analysis, **not** an as-built OpenPressBrake design, safety-rated implementation or physical test.

## Exact primary source

HAWE Hydraulik SE, **B 6340 - 04-2026 - 1.5 en**, *Control system for CNC press brakes of type ePRAX modular*, 94-page manufacturer operating instructions (English translation), document generated **2026-06-11**. **Manufacturer-hosted PDF:** https://productfinder.hawe.com/downloads/B6340-en.pdf . Inspected printed pp. 8–10, 12–27, 39–47, 64 and 74. Product overview: https://www.hawe.com/products/product-finder/integrated+solutions/control+for+press+brakes/eprax-modular+-+control+for+press+brakes/ . The manual covers **variants** with/without optional **Slow Up Module**; its circuit drawings pp. 84–89 and type plates must be reconciled before interpreting an installed system.

This is a genuine **CNC press-brake beam** product family, unlike Bosch Rexroth's IH04E **die-cushion** example studied in `4400_BOSCH_IH04_VALVE_FEEDBACK_LEAKAGE_REPLACEMENT_SCOPE_AUDIT_2026-10-24.md`. It is still **not identified as OpenPressBrake's hardware**.

## Bounded question

When the normal servo pump/drive loses speed-control authority during a gravity-assisted downstroke, what **separate hydraulic safety authority** does this OEM architecture document? And which additional stored-energy/physical-load propositions remain after a nominal stop?

## Manufacturer-confirmed implementation map (do not transfer as a machine truth table)

| Evidence ID | Exact OEM behavior / part boundary | Manufacturer page | Classification | Important limit |
|---|---|---|---|---|
| HW-01 | Separate left/right cylinder modules, servo power modules and controllers are described; each axis uses its own controlled motor/pump. | pp. 12–18 | DOC-CONFIRMED | Two drives alone are **not** two independently proven safety functions. |
| HW-02 | Machine controls synchronize axes and command drive/valve functions; safety-related valve control and switch monitoring are assigned to the machine's **safety-related control**. | pp. 18–19, 27 | DOC-CONFIRMED | The supplied drive assembly is not a substitute for the machine-level safety controller, guarding and validation. |
| HW-03 | The described SRP/CS hydraulic valve group includes left/right `QM2/QM3/QM4/QM5` and corresponding `BG2/BG3/BG4/BG5` position-switch monitoring. | p. 19 | DOC-CONFIRMED | Exact electrical/valve variants and independent physical behavior must be checked on the installed design. |
| HW-04 | OEM IDLE state de-energizes valve coils; selected seated valves are described as holding the beam while others prevent unintended pressurization. | p. 20 | DOC-CONFIRMED | A stated intended OEM state is **not** a witnessed physical hold under faults or proof of isolation. |
| HW-05 | FAST DOWN is **gravity assisted** and motor/pump speed produces a variable rod-side output throttle. OEM warns that loss of active drive speed control can allow beam acceleration without braking; machine control must monitor drive-active signals and stop through hydraulic valves if necessary. | pp. 21–22 | DOC-CONFIRMED | Normal speed command/feedback and safety valve withdrawal must not be collapsed into a single software stop. |
| HW-06 | On a safety stop, the documented hydraulic safety-valve group is commanded to drop out; the exact set depends on the current mode/variant. | pp. 22–23 | DOC-CONFIRMED | A coil-drop request is not actual valve position, no leakage, or stopped beam. |
| HW-07 | During WORKING SPEED, safety-related beam speed monitoring uses **linear measurement systems**; excess speed leads to a safety stop and valve dropout. | pp. 23–24 | DOC-CONFIRMED | Linear-scale mounting, mechanical coupling, safety-controller ownership, test evidence and limits remain selected-machine questions. |
| HW-08 | Optional Slow Up module includes diaphragm accumulators `81-CM1/82-CM1`. During bending it stores hydraulic energy; decompression/Slow Up can drive **upward** beam movement from this stored energy. | pp. 15, 23–25 | DOC-CONFIRMED | Pump stopped != all motion energy absent. Option presence and trapped-pressure boundaries are machine-specific. |
| HW-09 | Factory counterbalance-valve orifices and rod-side measurement-coupling orifices are documented with **conditional** lowering-rate protection; the OEM explicitly requires rechecking against cylinder dimensions, beam weight and pressure and adapting sizes if needed. | p. 10 | DOC-CONFIRMED | Published `<10 mm/s` / `<5 mm/s` are **not** general safe-speed or acceptable-fall limits for another machine. |
| HW-10 | Machine manufacturer must provide safety equipment, safety functions and controller; integration must ensure power-supply loss does not create a hazard. | p. 27 | DOC-CONFIRMED | Component brochure's certification claim is not a machine-level PL/SIL or functional proof. |
| HW-11 | The drive cabinet has electrical stored energy; the manual gives an OEM-specific capacitor discharge waiting period before work. | p. 40 | DOC-CONFIRMED | Waiting alone is not electrical isolation or verified absence of voltage; never transfer a time to another drive. |
| HW-12 | Accumulator gas pre-charge check is a separate maintenance task involving the optional module; it explicitly involves pressure discharge and a manufacturer-specific precharge label. | p. 64 | DOC-CONFIRMED | No generic gas precharge, gauge-point mapping or maintenance method can be inferred for another installation. |
| HW-13 | The manual's troubleshooting includes an upward beam jump during a Slow Up-to-Preopening transition and describes mode-dependent pressure/valve behavior. | p. 74 | DOC-CONFIRMED | A **manufacturer-described transient** is not evidence of a measured fault on OpenPressBrake. |
| HW-14 | Distinct ordinary control, safety-related logic, physical final elements, independent beam motion/holding, pressure/accumulator and local restart authority are necessary for a credible machine proof. | Derived from HW-01..13 | INFERENCE | Needs as-built safety architecture, risk assessment and `VAL/PT` physical evidence. |

### Source-specific control-to-physics trace

**Ordinary command** (CNC/LinuxCNC equivalent): set speed/torque, synchronize Y axes, manage motion phase and diagnostics. **Normal drive/pump**: executes hydraulic flow and can provide controllable throttle during gravity-assisted downstroke. **Safety-related controller**: monitors selected protective-device, valve-switch and linear-scale inputs; makes an independent stop decision. **Safety-related final elements**: OEM-specified hydraulic valves change state when demanded. **Physical safe-state witness**: actual hazardous beam motion/holding, valve/pressure zone and accessible hazard boundaries must be independently validated. **Energy isolation**: separately addresses mains/DC bus, pump, trapped chambers and optional accumulator. **Restart**: deliberate local reset/rearm/start remains distinct.

The OEM explicitly assigns safety-related monitoring/valve authority to a machine-level safety-related controller. **Do not implement this authority in ordinary LinuxCNC/HAL or a normal FPGA board** simply because they already carry speed and valve telemetry. The exact OEM safety-controller implementation is **not supplied by this public manual**.

### Four failure paths that defeat a status-only argument

1. **Gravity-assisted FAST DOWN + inactive speed control.** The ordinary speed loop no longer provides intended hydraulic throttling. A safe design must independently demand the appropriate final-element state and **verify actual hazardous beam behavior**; `drive_active=0` alone is not physical stopping proof.
2. **Valve limit switch plausible + load drift.** The position switch can establish its own target state but does not necessarily observe cylinder leakage, counterbalance flow, manifold faults or mechanical coupling. Preserve physical `PHY-HOLD` witness.
3. **Pump off + optional Slow Up energy.** An accumulator can still drive motion. Include optional module identity, trapped-energy zone, accessible test points and isolation procedure; `PUMP_OFF` is not `ENE-ALL_ZERO`.
4. **Counterbalance orifice/measurement coupling changed.** Factory orifice sizing is conditional on geometry, weight and pressure; swapping a fitting or using a different cylinder can invalidate a credited flow-limiting proposition. Treat as `CHG` with revalidation, not a harmless maintenance action.

### Human factors / maintainability

The practical design should make it straightforward to **identify each Y-axis module and variant**, access labeled pressure measurement points without entering the ram zone, identify the optional accumulator, install a rated mechanical restraint, and obtain clear fault explanations without offering a convenient permanent valve/scale bypass. If a correct safe procedure is slower or more awkward than defeating a switch, that is a design issue to correct under `HF/CHG/VAL`.

### Falsifiable evidence requests for selected OpenPressBrake (paper-only)

- As-built **left/right Y1/Y2** hydraulic drawings with cylinder geometry, valve names/part numbers, actual safety outputs, monitor inputs and pressure-zone test points; evidence of independent safety controller, not a generic control I/O map.
- Confirmation whether any **accumulator/Slow Up/return-energy** feature exists, and what stored-energy release/verification method is specified.
- Actual linear-scale safety-monitor channel provenance, mounting/coupling, power/reset fault behavior and independent physical beam-motion witness.
- Credited stop/hold mechanism on drive-active loss, safety-controller power loss, hydraulic leak, spool/valve-switch mismatch, pressure loss, hose failure and asymmetric Y-axis behavior.
- Installed restraint/maintenance-isolation method and visible local deliberate restart/guard/occupancy policy.
- Validated machine-specific criteria derived from the actual standard applicability, load, geometry, stopping performance and independent risk assessment. **No numbers borrowed from HAWE or Bosch.**

## Explicit nonclaims

No assertion that OpenPressBrake uses HAWE ePRAX; no inferred selected-machine valve truth table, fail state, required PL/SIL, stop time/distance, leakage limit, pressure threshold, safe speed, or physical test result. HAWE's OEM certification statement and detailed valve states are **product/variant-specific**, not proof that an arbitrary retrofit is safe. `IN-01..10/OPT/PHY UNKNOWN`, `VAL/PT NOT RUN`, external 2520–25F0 gates OPEN. No exposed hazardous operation permitted absent independent basic safety proof; experimental motion requires remote isolation and people outside the danger zone.

## Information-gain conclusion

This source resolves an important **architecture-existence** question: an OEM press-brake servo-hydraulic system can explicitly separate normal drive speed/torque from safety-related monitored hydraulic valves and beam-speed monitoring, while retaining gravity and optional accumulator energy. A simulation is **not justified** merely to re-demonstrate these documented relationships. The open work is selected hardware evidence and physical validation, not software algebra.
