# 4400-AMR-TRANSFER-01 — Conveyor handshake and safety relay drawing are not a validated transfer safeguard
**2026-10-30 | Original Omron I680-E-02 application example source trace | NON-GRADUATED**

## Concrete engineering question
A CNC machining cell receives an AMR 'ready at goal' signal. May the CNC conveyor/lift/robot or press-brake work transfer automatically on that ordinary signal, relying on a schematic that shows a safety relay and an optional safety PLC? **Not without an independently designed and verified transfer safety function.** This is a specific application-interface/source trace, not a selected OpenPressBrake installation or an extension of ordinary controller-board development.

## Original manufacturer source, exact pages
Omron LD-Series Integration Guide **I680-E-02** (original PDF https://www.omron.com.vn/data_pdf/mnu/i680-e-02_ld.pdf), Section 3-1, printed pp.3-2 through 3-6 (PDF pp.73–77), directly inspected including original printed pp.3-3 and 3-6 images.

**DOC-CONFIRMED**:
- Printed p.3-2: illustrative AMR lift/conveyor sequence uses a positioning goal, a **handshake** and material transfer, then lift lowers and vehicle travels to another goal. The manufacturer explicitly labels this an application example.
- Printed p.3-3: typical power distribution diagram shows an **optional safety PLC**, a safety relay, ordinary PLC/MAC, conveyor motors/controller, network switch and optional handshake sensors. It does **not** provide a complete safety-rated wiring/logic/PL calculation or prove that the pictured safety relay actually interrupts the correct energy paths in a selected machine.
- Printed pp.3-3–3-5: typical I/O list includes 'AMR ready', 'start of conveying', 'conveying complete', 'run roller motor', 'error reset', 'error communication', 'material position timeout', 'lift up complete' and 'run lift controller'. These are **illustrative ordinary process signals**; their names do not establish independent safe-state detection, safe stop, or occupancy clearance.
- Printed p.3-6, §3-1-3: the manufacturer calls for E-stop pushbuttons at conveyor height on the **same circuit** that halt AMR and payload-structure motion; the lift or conveyor **must not operate while AMR is in motion**; mechanical stops enabled while material loading/present; side sensing and vertical footprint adapted to payload. These are **Omron example-specific integration requirements**, not a universal approved schematic.
- Printed p.2-15, §2-10-1: payload transfer problems should trigger E-stop and interlock against harm; user-designed payload structure has independent hazards.
- I616-E-06 2019 original safety guide printed p.16 independently assigns **payload transfer fault detection, stopping and facility interlock** to the end user; Fleet Manager Wi-Fi is not interlocked collision prevention (p.17). [Predecessor fleet audit](4400_AMR_FLEET_01_OMRON_2019_2025_FLEET_WIFI_NOT_INTERLOCK_AND_EDGE_BARRIER_OEM_AUDIT_2026-10-30.md).

## Safety function allocation and adversarial fault paths
| Normal event | Credible failure | Unproven proposition | Minimum independent design question |
|---|---|---|---|
| 'Ready at goal' high | AMR rolls, localization stale, wrong height | Vehicle stationary and dock correctly supported | Which independent stop/hold and position/guard/energy witnesses are actually required? |
| 'Start conveying' / 'Run roller' | Stuck output, retained command after reset | Person cannot reach pinch/nip; roller stops | Which selected safety function removes conveyor torque and protects accessible pinch points? |
| 'Lift up complete' | Limit switch stuck, lift load unsupported | Payload held, gravity motion stopped | What physical support/holding and residual-energy witness exists? |
| 'Conveying complete' | Part jam, sensor falsely high | Material retained and transfer clear | How is fault detected, latched and recovered without personnel exposure? |
| 'Error reset' | Held reset, both systems restart | Fresh deliberate start and empty hazard zone | How are both systems' reset/rearm states coordinated without auto restart? |
| Communication lost | Last handshake bit remains high | Independent final elements reach safe state | What stale/timeout safety behavior is allocated and qualified? |

**INFERENCE:** Normal LinuxCNC HAL/PLC and AMR fleet/job coordination may execute logistics but must never be sole personnel-protective permission for moving the lift, conveyor, ram, gripper or vehicle. A safety relay symbol or optional safety PLC box is **architecture evidence only**. A qualified selected design must establish input/output wiring, diagnostic behavior, common-cause dependencies, final elements, power-loss/restart behavior and physical validation. The normal handshake can be a prerequisite to production motion **in addition to**, not instead of, safety permission.

## Human factors and validation
Use guarded transfer geometry, a visible accessible E-stop/recovery control, captive material support, and an easy jam-clear path that does not invite bypass. For the selected installation, freeze a validation matrix covering vehicle moving, lift moving, both stopped, person entering, part jam, power loss, communication loss, stale handshake, held reset, manual recovery and restart. **All cases NOT RUN**. No physical tests with personnel; if basic stop/hold/guard protection cannot be verified, **no personnel-exposed operation**. No stopping distance, PL/SIL, pressure, brake holding or wiring truth table inferred from the OEM example.

**Evidence:** DOC-CONFIRMED original OEM printed pages; SOURCE-CONFIRMED repository predecessor comparison; INFERENCE proposed independent system contract; TEST-CONFIRMED none; UNKNOWN exact AMR/cell/PLC/safety core/guard/actuator/physical witnesses. No selected OpenPressBrake AMR. No workflow, local/hosted compute or evaluator.
