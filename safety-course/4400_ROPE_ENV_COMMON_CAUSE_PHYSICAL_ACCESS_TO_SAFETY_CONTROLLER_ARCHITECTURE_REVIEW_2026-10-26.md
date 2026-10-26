# 4400 architecture review — a reachable safeguard is not the same as a healthy controller

**Status:** source-to-design integration, **NON-GRADUATED**. This review connects two *distinct* 2026-10-26 manufacturer investigations rather than claiming another discovery. No physical machine evidence or test.

**Sources:** [ROPE-PULL-01 original OEM audit](../research/4400_ROPE_PULL_01_ROCKWELL_SCHNEIDER_CABLE_TENSION_RESET_COVERAGE_OEM_AUDIT_2026-10-26.md) and [ENV-01 enclosure original OEM audit](../research/4400_ENV_01_NVENT_RITTAL_ROCKWELL_CONDENSATION_ENCLOSURE_SAFETY_BOUNDARY_AUDIT_2026-10-26.md).

## Minimal causal chain to prove, in order

`human can reach/actuate cable -> cable force reaches exact sensor -> sensor detects pull/cut and issues safety outputs -> safety receiver interprets exact OSSD/contact interface -> independent safety-related logic commands selected final elements -> physical machine stops/holds -> reset and fresh start do not reintroduce exposure`.

Each arrow is an independent evidence obligation. A successful LED test at one arrow cannot prove downstream physical safety. A normal LinuxCNC E-stop bit or HMI status is a **monitor**, not personnel-safety authority.

## Adversarial fault allocation

| Fault/shortcut | Layer | Likely false confidence | Appropriate discriminator | Evidence status |
|---|---|---|---|---|
| Red cable tied above reach to avoid forklift snag | Mechanical accessibility | Sensor green/OSSD ON | Whole-span reach/pull geometry and anti-defeat design | INFERENCE; selected installation UNKNOWN |
| New spring/pulley from unrelated device | Mechanical transmission | New part looks equivalent | Exact OEM part and qualified direction-by-direction proof | OEM installation DOC-CONFIRMED; selected machine UNKNOWN |
| Rockwell green + flashing amber | Sensor tension margin | “Green means fully healthy” | Exact OEM table: safety outputs can remain ON; maintenance warning | DOC-CONFIRMED for Lifeline 5 |
| GuardLink diagnostic tag says normal | Standard network/HMI | “Safety-rated because it came from a safety switch” | Rockwell manual p. 10: discovered tags are standard non-safety-rated | DOC-CONFIRMED for examined interface |
| Dry-contact device inserted in OSSD-only series | Safety-input architecture | Old integrity claim retained | Exact OEM series diagrams and fresh integrity allocation | DOC-CONFIRMED example PL ceilings, machine PL UNKNOWN |
| Cabinet cools, moisture at gaskets | Environmental/common cause | “High IP means no condensation” | nVent condensation/pressure mechanism; exact cabinet assembly | DOC-CONFIRMED mechanism, installed moisture UNKNOWN |
| Both normal I/O and safety I/O share wet cable gland | Electrical common cause | “Two channels means independent” | Actual cable routing, connectors, fault analysis, qualified tests | INFERENCE, no circuit-specific fault polarity |
| Heater running after cabinet repair | Monitoring | “Dry and safe now” | Insulation/environmental qualification plus separate stop/hold/restart proof | INFERENCE; no selected evidence |
| Operator resets rope switch while hidden person clears jam | Human factors/rearm | “Local reset restores safety” | Full-span visibility/inspection, personnel/LOTO controls and fresh start | OEM reset instructions DOC-CONFIRMED; actual behavior UNKNOWN |

## Architecture preference: low complexity and maintainability

1. **Avoid single-point shortcuts:** use an exact compatible rope/spring/safety input and a selected independent safety controller/relay, not HAL polling of an auxiliary or network tag.
2. **Make normal maintenance easy:** route cable where accessible yet protected, use visible tension diagnostics and labeled captive hardware; protect cabinet seals and provide qualified climate management and service access.
3. **Prefer clear fault state:** show *tension maintenance due*, *safety demand active*, *safety receiver fault*, *physical stop not proven* and *restart inhibited* as different conditions. Do not collapse into one green/red HMI lamp.
4. **Physical safe state independent of HMI:** selected final elements and mechanical/hydraulic load-holding proof, including press-brake gravity Y1/Y2, are separate from a cable sensor's OFF output.
5. **Treat any changed cable route, sensor interface, gland, heater, washdown, relay or controller configuration as a CHG candidate:** re-evaluate `DEP/ARC/SRS/PHY/VAL` and keep stale proofs stale.
6. **If qualified minimum safety cannot be demonstrated:** prohibit personnel-exposed hazardous operation. Remote/isolated experimental activity requires people outside the danger zone and a residual-risk statement.

## Concrete validation planning without unsafe testing

Prepare **documentary** evidence first: as-built route and cable variant; enclosure and cable gland selection; wiring/interface and diagnostic tag class; independent final-element/physical holding scheme; reset sightline/zone-clear procedure; maintenance accessibility. Freeze a physical test only after qualified risk assessment identifies an unresolved fact that documents cannot establish, and only with an isolation/remote plan. No numeric stop distance, PL/SIL, fault coverage or moisture threshold is assigned here.

**Claims:** DOC-CONFIRMED for the two exact OEM source families, INFERENCE for integrated failure paths and design pattern, UNKNOWN for actual OpenPressBrake configuration and physical response. SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none relied upon. No lab/Actions compute or independent evaluation. **G0/G1 HOLD**.
