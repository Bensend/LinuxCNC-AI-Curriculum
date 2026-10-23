# 4400 — SAKB monitored-valve coverage, NSV variants and the physical-witness gap

**Session:** 2026-10-22. **Status:** documentary research, not a machine design, validation, test result, or personnel-exposed operating authorization. **Course:** 2580 / 4400; feed cumulative 2520–25F0 safety design package.

## Precise engineering question

When a safety controller reports all monitored manifold valve positions as expected, which physical propositions are established, and which hydraulic/beam hazards remain unproved? This is a *coverage and evidence* question, not a request to infer an installed press-brake hydraulic truth table.

## Authoritative documents inspected

- HAWE D 6335, *Control system for CNC press brakes type SAKB*, **08-2025 rev 1.1**, printed pp. 4–5, 9, 13–14, 17: https://productfinder.hawe.com/downloads/D6335-en.pdf . Original PDF page images checked for the S-variant valve-monitoring note and measuring-point options.
- HAWE D 6368, *Anti-cavitation valve type NSV*, **06-2026 rev 1.3**, printed pp. 4, 6, 8, 24: https://productfinder.hawe.com/downloads/D6368-en.pdf . Original page images checked for L-suffix seal distinction, nominal pilot-pressure warning and disassembly hazard.
- OSHA 29 CFR 1910.147(d)(5)–(6): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 . Stored energy must be rendered safe and isolation verified before work; reaccumulation can require continuing verification.
- OSHA Directive STD 01-05-019: https://www.osha.gov/enforcement/directives/std-01-05-019 . Provides interpretation for continued verification when hazardous stored energy can reaccumulate.

## Source-bounded findings

**DOC-CONFIRMED — five monitored manifold valve positions, not universal pressure/ram proof.** D 6335 p. 9 explicitly identifies the S version as monitoring **two proportional directional valves, two holding valves and one 4/2-way directional valve**. That statement is not evidence of independent monitoring of every valve, anti-cavitation path, pressure zone, beam motion, or mechanical restraint. Do not conclude that an installed NSV has no feedback; its selected instrumentation is **UNKNOWN**.

**DOC-CONFIRMED — separate anti-cavitation devices and variant semantics.** D 6335 pp. 4–5 identifies NSV anti-cavitation valves separately mounted at cylinder bases, and illustrates compatible codes ending in **L**. D 6368 p. 6 distinguishes NSV without suffix (with seal; manufacturer describes zero leakage) and **L** (without seal; with leakage flow). The variant distinction is not a measured leakage rate, a prediction of beam descent, a holding-time guarantee or an assertion that NSV is the machine's safety-rated load-holding element. Actual part suffixes and hydraulic routing are **UNKNOWN** until checked on the selected installation.

**DOC-CONFIRMED — pilot values are guide values, not SRS limits.** D 6368 p. 8 says p1/p2 are nominal guide values, excluding tolerances, piston underside forces and seal friction. The manufacturer describes p1/p2 in relation to valve piston motion/seat. No value from that table can become a universal safe-pressure threshold, diagnostic limit, or machine stop acceptance criterion. Selected pilot topology and required pressure/motion witness remain **UNKNOWN**.

**DOC-CONFIRMED — measuring ports and optional circuits require configuration verification.** D 6335 p. 13 lists optional measuring connections or electronic transducers; p. 14 states some tool-clamping/crowning measuring points may instead be sealed with a plug. A schematic option is not proof a physical gauge/transducer is installed, connected to the relevant isolated volume, calibrated or able to observe reaccumulation. The S-variant five-valve monitoring description does not establish safety monitoring for every optional tool-clamping or crowning energy path. Exact coverage is **UNKNOWN**.

**DOC-CONFIRMED — manufacturer warns about unexpected movement during disassembly.** D 6368 p. 24 requires safe shutdown prior to disassembly, particularly with hydraulic accumulators, and warns of serious injury or death from sudden hydraulic drive movement if disassembled incorrectly. It instructs depressurization and maintenance safety measures. This is product documentation, not evidence that a selected press brake has been isolated or restrained.

**INFERENCE — monitoring coverage is not physical hazard coverage.** The target observed by a valve-position sensor is not automatically the ram, the trapped-pressure volume, the actual mechanical load path or the personnel exposure boundary. A plausible valve status can coexist with a different physical state. The *possibility* of that mismatch is supported by distinct observed quantities and known residual-energy mechanisms; whether any particular mismatch occurs in a selected circuit remains **UNKNOWN** until designed and measured.

## Adversarial contradiction case (hypothetical; NOT TEST-CONFIRMED)

The selected SAKB S-version valve-position signals report their expected positions. A pressure indication on one manifold port reads low. The selected NSV suffix, pressure-port topology, any accumulator and ram restraint are not documented. A second independent witness is unavailable or reports motion.

**Correct disposition:** retain only the narrow valve-position and known-port-pressure propositions for which the exact sensors are qualified. Mark the required `PHY-*` safe-beam/holding/depressurization proposition **NOT ESTABLISHED**. Block rearm/release and any personnel-exposed experimental operation; maintain a documented restricted state until the actual hydraulic and physical witness chain is reconciled. Do not assume the controller is wrong *or* that the physical witness is wrong without investigation; safety credit cannot be granted from an unresolved conflict.

## Cumulative package integration — stable ID families

| IDs | What the engineer must capture |
|---|---|
| `BND/ENE/HAZ` | Production, setup and maintenance exposure; gravity, pump, pilot, trapped pressure, optional clamp/crowning circuits. |
| `SF/PHY` | Specific stop/hold/restraint/depressurization propositions; what each valve/pressure/beam witness actually observes. |
| `SRS` | Machine-specific acceptance criteria and rearm constraints; no invented limits. |
| `AUTH` | Ordinary LinuxCNC/FPGA motion requests and diagnostics vs independent safety controller vs physical valves/restraints/isolators. |
| `DEP/ARC` | Shared pilot supply, electrical reference, manifold, sensor target, optional circuits, NSV variant and actual installed topology. |
| `VAL/PT` | Contradiction test, witness independence, measuring-port connectivity, gravity/stored-pressure and maintenance-isolation proof. |
| `HF` | Accessible, labeled, protected service test points and easy-to-restore guarding; reduce incentive to defeat safeguards for troubleshooting. |
| `CHG/UNK/RR` | NSV or manifold replacement/suffix changes, transducer relocation, stale validation, unknown trapped volumes and restrictions. |

### Eight-field final-element record (instance values intentionally UNKNOWN)

1. **Command:** selected independent safety-controller demand at output interface.
2. **Element:** exact monitored manifold valves, separate NSV, and other selected final elements.
3. **Feedback target:** each sensor's real valve/port/beam/restraint target, not a generic `safe` bit.
4. **Legitimate claim:** selected valve position or measured port pressure only, with explicit non-claims.
5. **Shared dependencies:** pilot, supply, reference, cable, manifold, mechanical and instrument paths.
6. **Residual energy:** gravity, pressure, accumulator, trapped volume, leakage/alternate paths, all conditional on installed topology.
7. **Physical witness:** selected independent beam/holding/restraint and pressure evidence required by SRS/PHY.
8. **Maintenance boundary:** lockable isolation, residual-energy control, mechanical support and continuing verification distinct from production safety enable.

## No-lab decision and next work

No simulation is justified: the unresolved questions concern the installed hydraulic schematic, exact part codes, sensor locations, pressure zones and physical restraint. A generic model would manufacture unverified facts. Next: obtain an authorized *public-safe* selected-component diagram, verify SAKB/NSV and optional-circuit part codes, map gauge taps to trapped volumes, and design an independent physical witness/contradiction validation plan. Generic safety schematics remain **NOT FROZEN**. No TEST-CONFIRMED machine evidence exists from this session.
