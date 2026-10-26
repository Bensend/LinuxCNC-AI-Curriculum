# 4400 ENABLE-01 — Three-position enabling controls: panic squeeze, release/regrip, and mode authority
**2026-10-26 | Original manufacturer-document research | PUBLIC training artifact | NOT a machine design approval**

## Why this is a distinct safety question
A three-position enabling device is often described loosely as a "deadman" switch. That shorthand hides a failure path: the operator can **release** a grip in surprise or **squeeze harder** in panic. A two-position pushbutton, an ordinary LinuxCNC jog key, or a foot pedal that simply stays ON when pressed further does not provide the same contact sequence. An enabling switch also does **not** itself command movement, prove safely limited speed, make an unguarded press brake safe, or replace an emergency stop.

### Direct sources inspected (exact revision and limitations)
- **EUCHNER original operating instructions**, *Enabling Switch ZSA/ZSR*, doc. **2092781-09-07/26**, 4 pages, pp. 1–2 (direct PDF, published manufacturer version current on 2026-10-26): https://cdn.euchner.com/assets/Downloads/Betriebsanleitung/en/MAN_Operating-Instructions-Enabling-Switch-ZSA%E2%80%A6_EN_09_07-26_2092781.pdf . Relevant text: pp.1–2 "Correct use", "Function", "Connecting enabling switch", "Resetting after fault detection", "Functional check". Product-page identification: https://www.euchner.com/en-us/products/enabling-switch/enabling-switch-zsa-zsr/zsa2a2s05a/ . **DOC-CONFIRMED exact OEM**, not OpenPressBrake evidence.
- **IDEC original HE3B series product page**, https://www.idec.com/en-us/safety-explosion-protection/safety-components/enabling-switches/he3b-series (direct page, accessed 2026-10-26): two-contact three-position OFF–ON–OFF, tactile snap at 1→2, heavier actuation 2→3, lower holding force at 2, and **no ON during 3→1**. **DOC-CONFIRMED exact IDEC family**, not an integration certificate.
- **IEC 60947-5-8:2020** official scope was not purchased or inspected in full; a standards publisher's scope describes three-position enabling switches as **components** that permit operation to be initiated by a **separate start control** and, when deactivated, require stopping/prevention of initiation: https://webstore.ansi.org/standards/ds/dseniec609472021-2439334 . **DOC-CONFIRMED published scope only**; no machine-level compliance claim.

## Manufacturer-confirmed mechanism
| Operator/device event | EUCHNER three-stage ZSA2/ZSR2 contact intent | Safety proposition NOT thereby established |
|---|---|---|
| No grip (position 1) | Enable OFF; at least one enabling contact open | Ram stopped and independently held |
| Intentional mid-grip (position 2) | Enable condition ON, **only permits separate motion command** | Authorized mode, safe speed, clear hazard zone |
| Panic squeeze to end (position 3) | Enable OFF; at least one contact open | Measured stopping time, hydraulic load retention |
| Release from position 3 through position 2 to 1 | Enable **must not turn ON** while passing the middle | Full-system restart interlock or other guard validity |
| Release from position 2 to 1 | Enable OFF | Hydraulic isolation or maintenance LOTO |
| Regrip after full release | Can re-establish enabling **eligibility** with correctly evaluated contacts | Motion start permission without fresh, separate intentional command |

EUCHNER's **two-stage ZSA1** is a different variant: its manual explicitly warns **ZSA1 must not be used in safety circuits**. Do not replace a ZSA2 with ZSA1 based on identical housing, connector, cable or a generic "enabling" name. Its exact **ZSA2A2S05A** page lists **2 NO + 1 NC**, while the family manual permits either correctly selected **equivalent** or **antivalent** two-channel evaluation. The safety receiver must be configured for the actual **contact combination and polarity**, not a guessed all-NO wiring.

EUCHNER explicitly requires two independent switching contacts/contact combinations and a dual-channel safe evaluation input, with discrepancy monitoring. Its document states **3 s has proven appropriate** for some electromechanical-contact simultaneity, **not** that 3 s is a universally safe setting. Actual parameterization is an exact receiver, wiring, risk and fault-detection design decision; no OpenPressBrake discrepancy value is assigned.

**Important reset nuance:** EUCHNER describes recovery from a transient grip/fatigue discrepancy by observing an **unambiguous full release** and then a new mid-grip; it also discusses configurable automatic fault reset. That is an **enabling-channel fault-recovery mechanism**, NOT permission to restart motion, erase an E-stop latch, restore a defeated guard, or bypass an independent restart requirement. Treat a receiver that clears a fault while the grip is still held as an unresolved failure-path issue. Its exact document also states that every person in the danger area must carry their own enabling switch; this is manufacturer-use guidance, not evidence of a validated multi-person architecture on any selected machine.

EUCHNER distinguishes LED indications (not safety functions) and instructs qualified personnel to check both **enable only in position 2** and **no enabling on 3→1 return**, with **no persons in the danger area** for functional checks. Damaged/worn devices require replacement, not field repair. The product data sheet can override family manual differences; check the exact part, suffix, label and manual edition.

## Architecture boundary and failure-path reasoning
**INFERENCE (candidate pattern; not a validated circuit):** qualified keyed or equivalent protected setup mode → independent safety evaluator accepting a properly configured two-channel 3-position enabling device → separate intentional jog command in ordinary LinuxCNC → selected independent safety outputs/final elements → actual machine physical stop/hold witness. If a guard is intentionally unavailable in setup, a separately justified mode-specific risk reduction (e.g. validated limited speed, reduced force, additional exclusion/visibility) is required. A software speed setting is not automatically a safety-rated limited-speed function.

**Adversarial paths:** (a) operator squeeze to position 3 while a jog key remains held; (b) release 3→1 with held jog request; (c) single stuck/welded contact or shorted pair; (d) fatigue-induced one-channel transition and ambiguous auto-reset; (e) two people in hazard area with only one enabling device; (f) switch placed in a clamp/tape/fixture to defeat the hold; (g) replacement ZSA2→ZSA1; (h) pendant disconnection/reconnection with a held command; (i) unexpected power restoration; (j) machine gravity load continues to move despite removal of normal command.

**Failure-path conclusion:** a legitimate grip is **permission to request motion**, not motion initiation, not a validated safe operating mode, and not evidence of physical safe state. Regrip after panic must not turn a stale jog request into surprise motion. Independent safe outputs and physical load retention must remain authoritative even if LinuxCNC, its FPGA, HMI, or the pendant fails.

## Practical human factors
Prefer an ergonomic grip with tactile middle position, an obvious storage cradle that cannot hold the actuator pressed, captive/protected cable routing, clearly indicated selected mode and station, good visibility of motion and a reachable independent E-stop. Make guarded setup practical so operators do not wedge the enabling control ON. Observe actual operator fatigue, gloves, hand dominance, tool-change workflow, access and rescue; redesign friction before treating bypass as merely an instruction violation. **Do not** instruct users to defeat guards or test the device with people in a hazardous zone.

## Evidence classification and open gates
- **DOC-CONFIRMED:** exact EUCHNER 09-07/26 and IDEC product behavior, distinct two-/three-stage variants, contact-evaluation and release/regrip notes, standard scope only.
- **SOURCE-CONFIRMED:** no new LinuxCNC source inspected this session. Existing pinned Task/jog source elsewhere is ordinary-control context, not a safety path.
- **TEST-CONFIRMED:** none; no energized test, simulation or physical stop witness.
- **COMMUNITY-REPORTED:** none relied on.
- **INFERENCE:** safe mode separation, separate intentional motion edge, stale-command suppression, multi-person coverage, ergonomics and commissioning gate design.
- **UNKNOWN:** whether OpenPressBrake has an enabling switch/teach mode, exact part/receiver/firmware/wiring, mode selector, independent final elements, Y1/Y2 stop/hold, safe speed, guards, physical validation, PL/SIL, evaluator score.
- **Status:** 10 public scenarios **UNSCORED** and 12 documentary gates **NOT RUN** in [field module](../safety-course/4400_ENABLE_01_THREE_POSITION_GRIP_PANIC_RELEASE_REGRIP_AND_MODE_FIELD_MODULE_2026-10-26.md); G0/G1 **HOLD**, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No personnel-exposed hazardous operation.
