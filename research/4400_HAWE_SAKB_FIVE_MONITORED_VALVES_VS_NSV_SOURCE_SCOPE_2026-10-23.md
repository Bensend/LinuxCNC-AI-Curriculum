# 4400 HAWE SAKB monitored-valve scope versus separate NSV hydraulic witness

**Status:** DOC-CONFIRMED manufacturer product-family evidence; installed-machine configuration and physical validation UNKNOWN. Studied 2026-10-23. No machine test or hydraulic circuit design is asserted.

## Authoritative manufacturer evidence

1. HAWE **D 6335**, August 2025 revision 1.1, printed p.9: https://productfinder.hawe.com/downloads/D6335-en.pdf . The **SAKB S** version is described as having valve position monitoring for **two proportional directional valves, two holding valves, and one 4/2-way directional valve**. This is a five-position *enumerated list* in the selected manifold variant, not a guarantee of complete hydraulic safety monitoring.
2. HAWE's SAKB product description identifies **one central control block and two separate suction/anti-cavitation valves**: https://www.hawe.com/en-us/products/product-finder/integrated%2Bsolutions/control%2Bfor%2Bpress%2Bbrakes/sakb%2B-%2Bcontrol%2Bfor%2Bpress%2Bbrakes/downloads/ . **DOC-CONFIRMED product-family architecture**, not a selected-machine hydraulic truth table.
3. HAWE **D 6368** anti-cavitation valve NSV product family/download listing, July 2026: https://www.hawe.com/products/product-finder/valves/check%2Bvalves-1/suction%2Band%2Bpre-fill%2Bvalves/nsv%2B-%2Bsuction%2Band%2Bpre-fill%2Bvalves/downloads/ . The manufacturer describes normally-open basic-position suction valves used to fill/empty press cylinders in rapid traverse, with control pressure needed to close them. Exact selected NSV suffix, monitoring option and port mapping must be read from its own revision. **DOC-CONFIRMED general family scope; selected variant UNKNOWN.**

## Evidence boundary

A builder sees `SAKB S: all valves OK` and concludes both separate NSVs are monitored and the elevated beam is held. **Invalid INFERENCE.** D 6335's specific list does not include those separate valves. That does not prove they are *not* monitored by some other circuit or device; it proves the five-position statement is insufficient to credit their feedback. The selected `NSV` variant and its own monitoring option require separate evidence.

Likewise, an NSV `L` suffix or an indicated pressure at one port cannot establish leakage rate, ram drift, all cylinder chambers, pilot pressure, accumulator energy, gravity load or mechanical restraint. No generic catalog pressure values are acceptance thresholds for the installed machine.

## Physical verification contract

| Package ID | What must be documented | Status |
|---|---|---|
| `ARC/DEP` | Exact SAKB model and S monitoring, both NSV model/suffix, manifold and cylinder port maps, wiring/feedback dependencies | UNKNOWN |
| `SRS/PHY` | Distinct protective stop, hydraulic holding, maintenance isolation, residual-pressure and elevated-load restraint propositions | UNKNOWN |
| `AUTH` | Independent safety-related logic/final elements versus ordinary LinuxCNC/FPGA command and diagnostic display | UNKNOWN |
| `VAL/PT` | Causal valve/guard demand plus actual physical ram/pressure-zone witness, separately from valve-position tag; safe isolation for any service | NOT RUN |
| `CHG/HF` | After NSV, sensor, gauge tap, bracket or hose change, mark dependent proof STALE; accessible approved test points and easy safe restoration | OPEN |

**Failure-path example (INFERENCE):** an elevated beam moves while five monitored SAKB valves report expected positions. The narrow statement `those five position signals are plausible` may remain true, but the broader `beam safely held` proposition is contradicted and must be blocked. Do not reset/rearm or enter the hazard zone until investigated and physically qualified. The safe experiment path is isolated/remote, people outside danger zones, with residual risk explicitly controlled.

**Related learner exercise:** `safety-course/4400_HYDRAULIC_COVERAGE_TECHNICIAN_CARD_2026-10-22.md`. This note is a documentation source trace, not a hydraulic schematic, PL/SIL calculation, or test result.
