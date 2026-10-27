# 4400 HYD-CUSH-02 — Internal end-of-stroke cushion pressure invisible at the port
Status: ORIGINAL MANUFACTURER SOURCE AUDIT; NON-GRADUATED; 2026-10-27 UTC.

## Distinct question / novelty
Can a hydraulic cylinder's *internal* cushioning restriction produce a damaging local pressure that the ordinary cylinder-port gauge or external relief cannot directly reveal? Direct 963-line learner-index scan found `cushion` only in unrelated *die-cushion* valve-model text; no internal cushion/rod-side local-pressure module. This is a **distinct observation and component-qualification trap** from HYD-INT-01's generic blocked return.

## Direct original manufacturer source
**Aggressive Hydraulics**, Tony Casassa, *Hydraulic Cylinder Cushions Can Prevent Mechanical Shock*, manufacturer engineering article dated January 11, 2022 (page also shows November 18, 2025), directly read 2026-10-27: https://www.aggressivehydraulics.com/hydraulic-cylinder-cushions-can-prevent-mechanical-shock/ , lines 68–118.

**DOC-CONFIRMED for the described cushion designs:** a spear/needle cushion and a piston/ring/orifice cushion are alternative internal deceleration mechanisms. Their restrictions change as the piston approaches an end. A manufacturer example uses a 2:1 cylinder area ratio, cap-side 3,000 psi and local rod-side 6,000 psi at full extend. The article explicitly states this *local internal* pressure is not measured by a cylinder port gauge and cannot be limited by an **external** relief valve in that described configuration. It calls for seal, wall and head-retention design checks. Contamination can block small orifices, and adjustable cushions can be incorrectly readjusted.

**Important qualification:** The no-port-gauge/no-external-relief statement is for the described *internally isolated cushion pocket*, not a claim that every hydraulic rod chamber is always unobservable or that every external relief is useless. The manufacturer's example is not a universal design limit or proof of OpenPressBrake equipment.

## Safety architecture
- Ordinary deceleration cushioning protects equipment against end impact when selected/designed correctly; it is **not** automatically a validated safety-related stopping function, safe speed monitor, independent Y1/Y2 stop, or gravity-load hold.
- **INFERENCE:** a machine can show normal supply pressure and still have an excessive transient/local cushion-pocket pressure. A normal port transducer cannot be presumed to witness an internal volume separated by an orifice/check/ring.
- **INFERENCE:** changing cushion needle setting, rod/bore, end-stop position, load speed, fluid viscosity/contamination or replacement cylinder can invalidate previously accepted structural and stopping assumptions; create a CHG/stale-evidence event.
- **UNKNOWN:** whether the selected machine has an internal cushion, its geometry, relief bypasses, fluid paths, pressure sensors, energy/stop/hold design, manufacturer validation or qualified measurements.

## Verification without unsafe live trials
Document exact cylinder model and sectional drawing; trace every internal and external volume and bypass; obtain manufacturer maximum allowable transient/cushion pressures and acceptable operating envelope; check seal/head/retention and line ratings; evaluate credible inertia/gravity and contamination; identify whether the chosen sensor can actually observe the pocket; design independent protection and authorized test only after hazard isolation. Never create a blocked-line, overpressure or guard-bypass demonstration on a people-exposed machine.

## Evidence classification
DOC-CONFIRMED: original manufacturer cushion behavior, its example and explicit measurement limitation. INFERENCE: potential diagnostic blind spot and revalidation triggers for other machines. UNKNOWN: OpenPressBrake installed cylinder, pressure, transient, stop/hold and physical safety. TEST-CONFIRMED: none. SOURCE-CONFIRMED LinuxCNC: none. COMMUNITY-REPORTED: none used. G0/G1 HOLD.

Related: [HYD-CUSH field module](../safety-course/4400_HYD_CUSH_02_END_STROKE_LOCAL_PRESSURE_GAUGE_BLIND_SPOT_FIELD_MODULE_2026-10-27.md); [HYD-INT source audit](4400_HYD_INT_01_ROSS_AGGRESSIVE_HYDRAULICS_TRAPPED_ROD_SIDE_PRESSURE_INTENSIFICATION_AUDIT_2026-10-27.md).
