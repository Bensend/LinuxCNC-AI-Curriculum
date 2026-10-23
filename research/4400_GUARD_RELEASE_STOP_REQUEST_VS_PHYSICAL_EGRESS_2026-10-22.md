# 4400 — Guard manual release: stop request versus physical egress

**Status:** manufacturer-scoped `DOC-CONFIRMED` and explicit `INFERENCE`; not machine validation. No tests run. 2026-10-22 UTC.

## Source and bounded finding

EUCHNER CTP-L.-AP operating instructions **2124217-08-06/21**, §§2 and 7.1–7.3: [official manufacturer PDF](https://www.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Transponder-Coded-Safety-Switch-With-Guard%E2%80%A6_EN_08_06-21_2124217.pdf).

The manual distinguishes **ordinary guard unlocking**, which should not occur until the dangerous function has ended, from **manual emergency/escape release**. When the documented manual release is actuated, the safety outputs switch OFF to generate a stop command; the OL monitoring output switches OFF and the OD door-position indication may be undefined. The optional inside escape release must be usable from inside without tools and not reachable from outside. The manufacturer warns against actuator tensile stress during manual release. These are `DOC-CONFIRMED` statements for the cited product/manual, not as-built evidence.

## Engineering consequence

**INFERENCE:** An escape release can generate a stop demand while permitting unlocking; its electrical output transition cannot prove that dangerous motion had already stopped **before** the release. The escape path, residual movement, physical opening under credible loading and independent stop/holding response are separate safety propositions. Do not make emergency egress depend on an ordinary-controller green status or make a no-tool inside escape inoperable in an attempt to enforce normal unlocking. The actual machine hazard geometry and protective architecture determine how the person avoids exposure during escape. Neither the safety output OFF nor a door-monitoring bit proves an exit route is physically passable.

This also explains why a production guard-lock output and a maintenance lockout mechanism cannot be conflated: one concerns access control during machine operation, while covered servicing requires separate physical isolation, residual-energy verification and worker-specific control.

## Curriculum traceability and validation gate

For a selected machine, link `BND/HAZ` exposure and inside/outside access; `SF/PHY` stop, holding and physical escape; `SRS` normal unlock versus emergency release; `AUTH` independent safety-related decision; `DEP` mechanical loading and output/receiver dependencies; `HF` bypass and trapping incentives; `VAL/PT` physical release/stop witnesses; `CHG/UNK` stale or unknown installed evidence. Preserve all `UNKNOWN`s until selected-machine physical validation.

A commissioning plan must establish independent stopping, holding and physical escape under justified preconditions, with no people exposed during unsafe experimental fault tests. No stopping distance, hydraulic truth table, force limit, achieved PL/SIL or acceptance threshold is invented here. Generic safety schematics remain **NOT FROZEN**; 2520–25F0 external/fresh evaluation gates remain **OPEN**.
