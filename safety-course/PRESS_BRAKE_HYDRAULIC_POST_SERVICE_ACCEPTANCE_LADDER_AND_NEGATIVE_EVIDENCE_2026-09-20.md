# Press-brake hydraulic post-service acceptance ladder and negative-evidence study — 2026-09-20

## Question

After a named counterbalance/holding/safety hydraulic element is diagnosed and replaced, what evidence is actually sufficient to return a hydraulic press brake to personnel-exposed production?

This pass deliberately distinguishes **diagnostic evidence**, **setting evidence**, **physical retaining evidence**, **dynamic stopping evidence**, **safeguarding evidence**, and **production-start authority**. It does not invent a missing OEM test.

## Evidence classification

### DOC-CONFIRMED — Cincinnati AUTOFORM diagnostic and setting evidence

Cincinnati AUTOFORM manual EM-494 provides a named counterbalance-pressure procedure. Counterbalance pressure is checked while the ram is moving down; after adjustment the ram is cycled a number of strokes and **both** counterbalance pressures are rechecked. The manual's RAM DRIFT troubleshooting procedure requires the ram to be blocked before valves are removed, then swaps counterbalance valves, bleeder valves, counterbalance check valves, and servo valves side-to-side. If the drift symptom follows a swapped component, the manual directs ordering/replacement of that component.

Source: Cincinnati Incorporated, AUTOFORM Press Brake Operation/Safety/Maintenance Manual EM-494, pp. 9-6/9-7 and troubleshooting pp. 9-38/9-39.
https://wwwassets.e-ci.com/PDF/Manuals/EM-494.pdf

### DOC-CONFIRMED — Cincinnati machine-level safety-maintenance witness

The same OEM manual contains a distinct SAFETY MAINTENANCE CHECK. It calls for point-of-operation safeguarding and pinch-point guarding to be correct, operator controls and operating modes to function properly, the ram to start and stop properly, auxiliary equipment to work properly, and scheduled normal maintenance to be completed.

This is machine-level evidence, not proof of a particular internal hydraulic element.

Source: EM-494, Safety Maintenance Check, p. 3-6.
https://wwwassets.e-ci.com/PDF/Manuals/EM-494.pdf

### DOC-CONFIRMED — Cincinnati diagnostic replacement instruction does not close acceptance

The accessible RAM DRIFT procedure ends the fault-localization branches with instructions such as ordering a new counterbalance valve/check valve/servo valve when the problem follows that component. It does **not** in that procedure specify:

- a post-installation static load/ram-retention challenge;
- a duration or allowable ram-drift acceptance criterion;
- a companion-path isolation state for the replacement acceptance test;
- a replacement-triggered stopping-time test;
- a replacement-triggered full safety-maintenance checklist;
- a reset/rearm/fresh-start sequence following the repair.

These omissions are recorded as **UNKNOWN**, not inferred requirements or permissions.

### DOC-CONFIRMED — existing press-brake evidence remains complementary, not interchangeable

Existing course evidence already establishes other rungs of the ladder:

- BAYKAL APH: periodic physical stop-time control is required and a measurement connection is provided.
- Lazer Safe/FoldSafe: physical stopping behavior can be tested while deliberately preventing the normal hydraulic stop path from masking the secondary stop path.
- Rockford RHPS: two-hand safeguarding depends on total response and physical stopping performance; maintenance triggers safeguarding function checks in the documented implementation.
- Cincinnati CB II: individual hydraulic/check paths can be diagnostically exercised rather than accepting aggregate machine motion as proof.

None of those sources, alone or in combination, authorizes transplanting an unstated static holding-valve acceptance criterion into AUTOFORM/OpenPressBrake.

## Acceptance-evidence ladder

The course shall keep the following witnesses separate:

1. **Service isolation** — hazardous stored/gravitational/electrical energy physically controlled so service can be performed.
2. **Diagnostic localization** — evidence identifies a suspect component/path (for example, a fault follows a side-to-side swap).
3. **Replacement/repair completed** — the component is installed correctly and the circuit restored.
4. **Setting/adjustment evidence** — required pressures/settings are established and remain correct after the OEM-specified cycling/recheck.
5. **Individual retaining-function witness** — if required by the actual machine architecture, the serviced retaining path is physically challenged without another path masking failure.
6. **Installed static machine witness** — the ram/load is physically retained under the defined machine acceptance conditions.
7. **Dynamic stop-performance witness** — actual hazardous motion stops within the validated envelope where stopping performance is part of safeguarding.
8. **Safeguarding/system revalidation** — guards, protective devices, modes, controls, diagnostics, reset/restart behavior and relevant final elements are revalidated.
9. **Safety rearm** — independent safety logic permits operation after its required reset/requalification.
10. **Fresh ordinary production start** — normal LinuxCNC/CNC/HMI/FPGA control receives a new intentional production command; retained/stale ordinary state is not promoted into motion authority.

A particular OEM may combine or omit rungs because its architecture differs. The curriculum must not assume equivalence merely because two tests move the same ram.

## Durable freezes

`FAULT FOLLOWS COMPONENT != COMPONENT REPLACED != REPLACEMENT INSTALLED CORRECTLY != REQUIRED SETTING RESTORED != SETTING STABLE AFTER CYCLING`

`SETTING/PRESSURE PASS != INDIVIDUAL RETAINING PATH PHYSICALLY PROVED != INSTALLED RAM/LOAD RETENTION PROVED`

`RAM STARTS/STOPS PROPERLY != STATIC RETENTION PROVED != WORST-CASE STOPPING PERFORMANCE MEASURED`

`STATIC RETENTION PASS != DYNAMIC STOP-PERFORMANCE PASS`

`MACHINE SAFETY-MAINTENANCE CHECK PASS != INTERNAL SERVICED ELEMENT INDIVIDUALLY UNMASKED`

`REPAIR COMPLETE != SAFETY REARM != FRESH ORDINARY PRODUCTION START`

## Adversarial cases

### New counterbalance valve, correct pressure

A technician replaces the valve implicated by side-to-side fault localization, sets pressure correctly, cycles the ram and rechecks both sides. This is meaningful OEM setting evidence. It is **not** evidence, from the located source, that the replacement has passed a defined static load-retention acceptance test.

### Ram appears to stop normally

A normal stop can be produced by a companion hydraulic path. Without a procedure that deliberately exposes the serviced path, normal stopping cannot be promoted into individual retaining-element proof.

### Safety-maintenance checklist passes

This supports machine-level return-to-service reasoning but does not identify which internal hydraulic path carried the load or stopped motion. It cannot retroactively turn aggregate behavior into an unmasked component test.

### Diagnostic symptom disappears after replacement

Disappearance of idle drift is useful installed-system evidence. Unless the OEM procedure defines the conditions and acceptance criterion, the course must not invent a quantitative drift limit or call the observation an individual component certification.

## OpenPressBrake boundary

OpenPressBrake's actual hydraulic retaining topology, number of independent load-holding paths, valve identities, safe service blocking method, static proof load/position/duration, allowable drift, oil temperature state, companion-path isolation method, dynamic stop-test conditions, acceptance thresholds and production-rearm sequence remain **UNKNOWN** until machine-specific engineering/measurement establishes them.

LinuxCNC and the ordinary FPGA/controller may request motion and report diagnostics, but they do not become personnel-safety authority by observing a successful repair test. Independent safety functions and physical final-element evidence remain separate.

## Information-gain result

The targeted search did **not** close the exact missing bridge `named replacement -> OEM-defined unmasked static retaining challenge -> quantitative pass/fail`. That is a branch-local evidence stop, not permission to invent a test.

What this pass adds is a durable acceptance-evidence ladder that prevents three recurrent category errors: using fault localization as acceptance, using correct pressure/settings as physical load-retention proof, and using aggregate machine start/stop behavior as proof of one internal retaining element.

## Next evidence target

Prefer a press-brake OEM or hydraulic-manifold service document that explicitly states what to do **after installation/replacement** of a named counterbalance, load-holding, check, blocking, or safety valve and includes a physical retaining witness with defined test conditions and disposition. If unavailable, rotate to another open safety module rather than repeatedly searching the same manuals.

## Compute

No executable question justified a lab. No GitHub-hosted runner and no self-hosted runner compute used.
