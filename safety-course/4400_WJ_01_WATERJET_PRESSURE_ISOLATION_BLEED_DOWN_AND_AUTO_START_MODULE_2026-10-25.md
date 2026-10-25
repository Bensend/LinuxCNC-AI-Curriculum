# 4400-WJ-01 — Waterjet high-pressure safety, bleed-down and startup authority
**2026-10-25 | 4400 safety implementation | NON-GRADUATED | no physical test**

## Learning outcome
A fresh engineer can identify every energy and access boundary on an abrasive waterjet, explain why normal CNC ready/stop and pump PLC indicators are insufficient for safe maintenance, reason about startup and pressure transitions, and request the minimum physical evidence without fabricating safety performance. This is a 4400 safety specialization, **not** reopening graduated 3300 machine-control content.

### Prerequisites and sources
2500 safety SRS/energy isolation, 2580 hydraulics, 2590 guarding, 25F0 machine transfer, 4400 selected-witness methodology. Read [original OEM evidence audit](../research/4400_HYPERTHERM_WATERJET_BLEED_DOWN_AUTO_START_AND_PRESSURE_ZONE_OEM_AUDIT_2026-10-25.md) before attempting [technician card](4400_WJ_01_TECHNICIAN_DECISION_CARD_AND_BLANK_WITNESS_2026-10-25.md). Primary sources: Hypertherm 808240 Rev1, 809790 Rev0, 810040 Rev0 and 80943C Rev0; Flow MotoJet product page; LinuxCNC official M66 documentation. See source audit for URLs and pages.

## Hazard boundaries: no collapsed 'safe' bit
| Hazard / exposure | Normal-control fact | Required separate safe-state proposition |
|---|---|---|
| Cutting head jet / injection | CNC requests jet off, M66 input READY, no G-code motion | Independent pressure/jet energy suppression plus physical containment and verified pressure condition at relevant head/line zones |
| Intensifier, attenuator and UHP tubing | Pump PLC reports OFF or bleed commanded | All hazardous pressure zones discharged/isolated and verified by an OEM-approved method; failed valve/blocked drain accounted for |
| Hydraulic pump / pneumatic pilot | PLC stage or pressure setpoint | All relevant supplies and residual energy isolated for maintenance; actual final-element response confirmed |
| Gantry, workpiece, abrasive/fragment ejecta | Axis idle or feed hold | Independently assessed access protection, no hazardous axis motion, catcher/guards/fixtures suitable for selected operation |
| Remote command and restart | CNC PUMP READY, pump LOCAL/REMOTE mode | Qualified safety-rearm authority separate from ordinary CNC/PLC; reset does not initiate jet or motion |
| Medical response | Small or apparently superficial wound | Treat possible high-pressure injection as urgent surgical emergency; immediate emergency care, OEM emergency card |

**Physical zero is zone-specific.** 808240 identifies the inlet filter gauges as low-pressure; do not substitute their zero indication for high-pressure line/cutting-head proof. A flow-pump product's claimed 1-second dump is not a transferable safe-entry delay. A cut-to-pierce bleed timer is not a safety response specification.

## Four distinct operational phases
**Production:** Guarding and jet catcher protect normal cutting. CNC commands motion/jet; pump PLC performs normal pressure regulation. Independent safety-related controls must own protective-device reaction and final energy withdrawal for selected hazards.

**Protective stop:** Stop request must cover gantry and fluid/jet hazards; a commanded valve position or HMI icon is only a diagnostic. Guard release remains prohibited until the selected safe-state criteria are physically met. A pump's E-stop must not be assumed to stop unrelated CNC axes, and vice versa.

**Maintenance:** Qualified personnel identify, isolate, lock, drain, and verify *each* relevant energy zone at appropriate points. Water supply, UHP line/attenuator, hydraulic drive, air pilot, stored pressure and axis gravity/electrical energy are different propositions. No pressure fitting or nozzle work based solely on timer, software status, or one inlet gauge.

**Restart/rearm:** After maintenance, restore guards and drains, reconcile exact firmware/settings, verify no bypasses, clear the zone and obtain a deliberate fresh start. Never treat a reset, restored power, pressure-ready bit or reconnecting a remote source as a cycle-start command.

## Manufacturer variant traps
- 808240 Rev1 describes normally-open air-actuated bleed on pump-off/E-stop; that is documented *intended behavior*, not independently verified actual pressure zero.
- 809790 Rev0 exposes a user-settable **cut-to-pierce** bleed duration. Changing it can leave head pressure higher than requested. It is **not** an E-stop safe time.
- 810040 Rev0 adds staged PLC startup, programmable stage delays and a warning state that can coexist with continuing startup. Its PUMP READY is a normal process output, not an independent access authorization.
- 810040 also warns that PLC reboot can erase settings. Configuration backups and restoration/revalidation are part of safety change control, not an optional convenience.
- Flow MotoJet advertised bleed performance is **not** proof for a Hypertherm pump or any selected installation.

## Failure-analysis contract
For each fault, document **demand → ordinary control observation → independent safety function → physical final element → separate physical witness → residual hazard → restart rule**. Minimum adversarial cases: blocked dump, failed pneumatic pilot, supply gauge zero with trapped UHP, stale READY, yellow warning while startup continues, remote/local ownership conflict, PLC setting loss after update, and a guard removed for a quick nozzle change. A single 'green' display cannot close any of these chains.

## Human-factors minimum
Provide convenient guarding with visibility into the cut zone, easy cleanup and nozzle service *after isolation*, labeled accessible lock points, unmistakable pressure-zone diagrams and a readily available injection-injury medical card. Fix recurring nuisance trips and service difficulty through guarded diagnostics, fixtures and better access rather than leaving the guard or bleed monitoring bypassed.

## No-energy verification and grading
Use the [12-gate desk review](4400_WJ_01_12_GATE_NO_ENERGY_CHANGE_REVIEW_2026-10-25.md) and [16 unscored technician cases](4400_WJ_01_TECHNICIAN_DECISION_CARD_AND_BLANK_WITNESS_2026-10-25.md). A competent independent evaluator must use novel scenarios and withhold scoring until a blind learner commitment; these paper cases are **not** blind results.

## Evidence / promotion
**DOC-CONFIRMED** edition-specific OEM and LinuxCNC documentation. **SOURCE-CONFIRMED** no new source trace. **TEST-CONFIRMED** none. **COMMUNITY-REPORTED** none. **INFERENCE** architecture and verification plan. **UNKNOWN** selected machine pressure zones, exact safe-state and response, hardware/firmware, standards adoption, risk assessment, PL/SIL and measured discharge. **Graduation:** not earned without external competency and, for selected-machine claims, qualified physical proof. If all unknowns differ, central teaching (ordinary control != physical pressure proof) remains valid; any *specific* hardware acceptance claim would not.

**Safety release:** no personnel-exposed hazardous operation on an unverified machine; if engineering experiments are essential, qualified isolated/remote planning with people outside danger zone, separately justified residual risk and authorization. This document is not such authorization.
