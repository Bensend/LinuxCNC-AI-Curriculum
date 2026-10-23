# 4400 — Guard lock that holds the door but is not a safety-rated locking witness

Status: **DOC-CONFIRMED manufacturer catalog comparison**; not a selected-machine compatibility or achieved-PL determination.

## Precise comparison

Official EUCHNER product records inspected 2026-10-22:

- **CTP-I1-AP-U-HA-AEC-SA-136595**, order 136595: https://www.euchner.com/en-us/products/transponder-coded-safety-switches-with-guard-locking/safety-switch-ctp-ap/ctp-i1-ap-u-ha-aec-sa-136595/ . Manufacturer explicitly says this version's guard locking is for **process protection only** and it **does not possess safe guard-lock monitoring**. It has FO1A/FO1B safety outputs, an `OL` guard-lock monitoring output, and a `PL e` characteristic specifically listed for **monitoring of guard position**. The presence of a locking solenoid, high-coded actuator, physical locking force and OL signal does not change that narrow allocation.
- **CTP-L1-AP-U-HA-AE-SH-123375**, order 123375: https://www.euchner.com/en-us/products/transponder-coded-safety-switch-with-guard-locking-2/ctp/safety-switch-ctp-ap-2/ctp-l1-ap-u-ha-ae-sh-123375/ . Manufacturer lists `PL e` specifically for **guard-lock monitoring** in the selected product and separately says **control of guard locking depends on external control**. FO1A/FO1B are safety outputs, whereas OD/OI/OL are labeled monitoring outputs. A safe locking-monitor function is not the same as a complete safe unlocking function, and neither establishes machine stopping, gravity restraint, actual egress or maintenance isolation.

The two compared product pages have **different connector families** (M12 8-pin versus M23 19-pin). Do not infer pin-level interchangeability. Their published mechanical FZh values happen to match at 3,000 N, which is *not* a reason to treat the safety functions as equivalent.

## Failure-path analysis

An installer replaces an L1 with a physically similar I1 because the latch, escape button, LED, or diagnostic OL still works. A supervisor sees FO1A/FO1B labeled “safety outputs” and concludes that the safety controller still has a validated guard-locking signal. This inference is unsound: the I1's stated PL e is for **guard position**, not safe guard-lock monitoring. The new component may be suitable for **process retention** and guard-position safety in its documented context, but it must not be silently credited for keeping the guard locked until dangerous motion stops.

`DOC-CONFIRMED`: product descriptions, output labels, product-specific characteristic-table allocation, external control dependency, connector and mechanical data. `INFERENCE`: a wrong-but-plausible substitution could defeat a design that requires safety-rated lock monitoring. `UNKNOWN`: exact original machine SRS/required function, controller wiring, pin compatibility, risk reduction, stop/access time, replacement acceptance and physical safe state.

## Eight-field final-element witness consequence

1. **Demand:** guard unlock request only after separately evidenced machine safe state.
2. **Physical final element:** selected latch/solenoid/actuator/guard structure.
3. **Feedback target:** guard position versus guard-lock position, **explicitly different**.
4. **Narrow supported proposition:** I1 product's published PL e for guard position; L1 product's published PL e for lock monitoring (in exact documented context).
5. **Shared dependencies:** controller selection, supply, cable, mounting, latch mechanics, external unlocking permission.
6. **Residual hazard:** motor run-down, hydraulic/gravity motion, person trapped, alternate process energy.
7. **Machine witness:** actual hazard stopped/held and actual access/escape path, independently validated.
8. **Maintenance:** lock status and escape release are not energy isolation or maintenance load restraint.

## Adversarial change-control test

`CHG-###`: substitution L1 -> I1. Mark `SRS` (safety-rated guard locking requirement), `AUTH` (who controls unlock), `ARC` (selected switch), `DEP` (connector/supply/feedback), `VAL` (lock monitoring and stop/access validation) and downstream evidence STALE. Refuse rearm/exposed-person operation if the physical and safety-control proposition is not re-established. A green LED, `OL` output or equal FZh does not resolve the mismatch. A genuine process-only retention function may be acceptable *only if* a separate validated safety architecture prevents hazardous access; that is a new SRS/architecture decision, not an assumed drop-in replacement.

## Cross-machine transfer

A robot-cell gate whose safety function requires locking until robot/axis motion ceases is **not equivalent** to a milling-machine guard that merely retains a door to avoid process interruption while a separate safety-rated interlock/stop path protects access. The actual machine's hazards, time-to-access, trapped-person risk and residual energy decide the required function. No PL/SIL or stopping distance invented.

## Source and publication gate

Both sources are official EUCHNER product pages; no hidden machine information. The linked CTP-I1 operating manual is identified by the manufacturer as doc 2126290 version 08-07/24; the L1 product page identifies its CTP-AP operating manual as doc 2124217 version 08-06/21. **Full operating manuals were not separately inspected in this branch.** A selected design must check those manuals and the exact catalog variant before schematic freeze. No simulation/lab: the difference is explicitly documented, while machine acceptance requires physical design evidence.
