# 4400 PNEU-COLD-01 — ice-blocked pneumatic exhaust and conflicting manufacturer temperature data

Date: 2026-10-26 UTC. **New source conflict and environment-dependent failure path; documentary only.** Not an OpenPressBrake installed-part finding, physical test or machine release.

## Engineering question

Does a low ambient-temperature rating prove a pneumatic quick-exhaust valve will reliably vent when wet compressed air expands through it? **No.** The ROSS manufacturer's own 18 Series product page distinguishes valve material/ambient capability from the moisture-free air condition needed to avoid icing at the exhaust/poppet. Its temperature statements also **contradict each other** and cannot be silently reconciled.

This is a distinct *cause* (freezing/ice) within the previously known generic blocked-exhaust family, not a newly discovered principle that blocked vents are dangerous. The existing [2026-10-24 pneumatic safe-exhaust audit](4400_PNEUMATIC_SAFE_EXHAUST_VARIANT_RESET_TRAPPED_VOLUME_SCOPE_AUDIT_2026-10-24.md) covers trapped air and obstructed silencers; the [2026-10-26 PNEU-MUFFLER audit](4400_PNEUMATIC_EXHAUST_SILENCER_CLOG_MAINTENANCE_DRIFT_OEM_RECONCILIATION_2026-10-26.md) addresses contamination/maintenance. This audit adds cold-environment moisture dependency and an explicit same-page OEM evidence conflict.

## Direct manufacturer-source inspection and contradiction

**ROSS Controls, Quick Exhaust Valves 18 Series**, official manufacturer product page: https://www.rosscontrols.com/en/series/264-quick-exhaust-valves , inspected 2026-10-26.

- **DOC-CONFIRMED page lines 43–46:** the 18 Series is a pressure-differential-operated, cylinder-local quick exhaust valve. A pressure drop at inlet Port 1 shifts a poppet to connect cylinder Port 2 to atmospheric Port 3. This is a pneumatic component function, **not** a certified personnel-safety final element.
- **DOC-CONFIRMED page lines 58–59, 103–109:** the overview and 'extended temperature' prose claim **-40 to 175 °F (-40 to 80 °C)**, but the adjacent technical table displays **40 to 175 °F (-40 to 80 °C)**. The Fahrenheit lower bound **40** does not correspond to Celsius **-40**. The same page therefore has a genuine internally inconsistent lower temperature value. The safe product rating is **UNKNOWN** pending exact selected part/revision and manufacturer clarification; neither lower bound may be used as design proof.
- **DOC-CONFIRMED page line 109 and installation text:** below 40 °F (4 °C), manufacturer warns that compressed air must be free of water vapor to prevent ice at poppet seating surfaces and exhaust port. The source's separate 'must be free of water vapor' language is more stringent than a casual ambient-temperature rating, but it does not supply a selected dew-point acceptance test.
- **DOC-CONFIRMED page lines 181, 204+ installation precautions:** exhaust Port 3 must not be restricted, and attached silencers must have adequate exhaust flow. The exact product family has different exhaust Cv by size; **do not** transfer catalog Cv to an unknown valve.

**ROSS Controls, SS110 18/19 Series Installation/Operating Instructions landing page**, https://www.rosscontrols.com/en/documents/55/18-19-series-valves, inspected 2026-10-26: directly accessible manufacturer page lines 59–76 warns restricted exhaust can cause erratic valve operation and recommends appropriate silencer capacity. The landing page does not resolve the specific 18 Series lower-temperature contradiction; linked PDF bytes not inspected.

**Festo, VTSA(-F) 2025-08j original operating instructions**, manufacturer PDF indexed at https://media.festo.com/assets/attachment-files/089179f92d0ab90c93d98e00c9c45a3e997b334f1dd4fb676a4ec5402906722183c778885067446112b58105b36d2d3eb7a9bdd7b3bf1a157426cceae13532be/VTSA%28-F%29_operating-instr_2025-08j_538923g1.pdf . The indexed original manufacturer text separately cautions that condensate/moisture can freeze at low temperatures and recommends a dryer. **Indexed excerpt only; PDF not directly inspected.** No Festo/ROSS part interchangeability or shared numeric rating inferred.

## Hazard chain and boundaries

**INFERENCE:** moisture + cold exhaust expansion -> ice at poppet/exhaust -> impaired shifting or restricted venting -> delayed or incomplete pneumatic pressure removal -> hazardous load or personnel-access exposure **if** the selected machine relies on that vent path. This is not a measured stop-time, failure probability or accepted machine fault.

**Crucial counterexample:** A machine can be made *more* dangerous by rapidly venting a load-supporting pneumatic cylinder, vacuum gripper or spring-return actuator. Do not treat 'fastest possible exhaust' as the safety goal. First establish the physical safe state: what must be held, released, isolated or mechanically restrained? Only then select independent safety architecture and validate it.

**Source conflict rule:** record both contradictory OEM values with exact URL and date, classify selected rating UNKNOWN, ask manufacturer for exact part-number documentation and approved ambient/media/dew-point limits, and withhold environmental qualification until reconciled. Never choose the more convenient temperature claim.

## Practical human-factors and maintenance architecture

Prefer an accessible air-treatment/dryer/condensate-drain arrangement selected by qualified design, visible contamination/service indicators, an exhaust path that can be inspected without entering the hazard zone, documented cold-start restrictions, a clearly labelled qualified spare, and physical load restraint independent of a single pneumatic vent. Make correct maintenance simpler than warming a frozen fitting with an improvised unsafe method or bypassing a protective device. No energized ice-removal, pressure-fitting loosening, guard defeat or personnel-exposed fault test is authorized.

**Authority split:** LinuxCNC/ordinary FPGA may observe temperatures, report fault, and request normal stop; independent safety logic/final elements and actual physical energy-removal/load-retention determine personnel safety. A software alarm cannot establish that ice has cleared or that the machine is physically safe.

## Verification and next-work

Paper review: exact selected valve model/revision and temperature conflict resolution; lowest ambient and compressed-air/media temperature; moisture/dew-point source and dryer service; port 3/silencer geometry; all pressure zones and mechanical loads; safe state under icing and loss of power; physical pressure/stop/hold witness; safe cold-start and fresh deliberate restart. All **NOT RUN**. No synthetic lab justified: without selected circuit/environment, a simulated valve cannot establish physical safe-state or resolve the manufacturer's contradictory product rating.

Evidence labels: **DOC-CONFIRMED** for directly inspected ROSS pages and Festo indexed excerpt; **INFERENCE** for machine consequence; **UNKNOWN** for selected part rating, installed machine, pressure/dew point, PL/SIL, stop/hold response; **SOURCE-CONFIRMED LinuxCNC** none; **TEST-CONFIRMED** none; **COMMUNITY-REPORTED** none used.

**OpenPressBrake:** No evidence this 18 Series valve is installed. Hydraulic Y1/Y2 stopping and gravity holding cannot be derived from pneumatic evidence. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No hosted/local compute or physical test.

## Same-session manufacturer exact-variant follow-up — conflict narrowed, not silently erased

After freezing the original same-page contradiction, inspected ROSS's **exact 1868A3005** manufacturer product page https://www.rosscontrols.com/en/series_variants/51790-1868a3005 and its technical-data view https://www.rosscontrols.com/en/series_variants/51790-1868a3005/technical_data (retrieved 2026-10-26). Both explicitly list ambient **and** media **-40 to 175 °F (-40 to 80 °C)** for that named variant. Independent ROSS regional pages for other 18 Series variants also present -40 °F, but they are not selected-machine proof. This **DOC-CONFIRMED** part-specific evidence makes a **series landing-page typographical error plausible (INFERENCE)**; it does **not** justify deleting the original 40 °F table entry, ignoring historical manual editions, or claiming an actual installed machine's rating. A separate archived third-party mirror of a ROSS 18/19 manual shows 40–175 °F (4–80 °C); because it is not a directly inspected original manufacturer manual, treat it as an investigation lead only. **Reconciliation gate:** selected part label + applicable dated OEM installation manual or written manufacturer clarification, and moisture/dew-point conditions. A material -40 °F catalog claim still does not prove safe venting with wet air.
