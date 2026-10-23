# 4400 — SAF-family pressure-witness usability and safeguard-defeat design review

**Purpose:** make the correct pressure-zone verification easier than the shortcut. This is a generic engineering design review, **not** a selected-machine hydraulic specification or a service procedure. Read alongside the existing course instrument-trust and test-point maintainability worksheets.

## Failure story to design against

A technician must verify a trapped hydraulic volume before maintenance. The only visible indicator is an HMI pressure reading. The actual gauge is behind a guard and the block has an accessible bleed handle but no obvious label identifying which side of the main shutoff the gauge measures. The technician has a strong incentive to accept a zero HMI value and skip physical verification. In the HYDAC SAF-family published schematic, the accumulator-side S node and system-side P node are separated by a main shutoff; a zero S gauge does not establish P or gas-side conditions. The design should not require a technician to choose between *doing the correct verification* and *exposing themselves to the hazard just to reach the test point*.

## Design review questions

| Foreseeable shortcut | Why the design invites it | Practical redesign candidate | What still needs independent proof |
|---|---|---|---|
| Trust one HMI zero for all hydraulic zones | Instrument location invisible; no zone labels | Durable physical zone map, HMI tag explicitly naming S/P/other volume, protected labeled test points at each required zone | Actual port connectivity and pressure-state witness |
| Enter under suspended member to see gauge | Gauge mounted in hazard zone | Relocate **readout/observation**, not casually the pressure tap; qualified remote instrument/inspection sight line outside hazard, protect signal and identity | Verified motion/holding/restraint and instrument chain |
| Remove guard for routine pressure verification | Guard obstructs normal service task | Designed protected access panel/hinged guard with captive hardware, suitable viewing and lockout provisions | No new reach/access hazard; applicable guard/interlock SRS |
| Ignore repeated nuisance pressure faults | Unclear diagnostic target, unstable or blocked tap | Diagnostic messages identify actual node, source/quality/freshness and fault; maintenance plan for sensor path | Not a new safety authority; fault state must not silently reset |
| Leave bleed/isolation handle in wrong state | Ambiguous handle positions, no restoration checklist | Clear valve-state label, keyed/captive restoration features where justified, explicit two-person/independent confirmation for high-consequence cases | Position/lock does not prove valve sealing or pressure state |
| Reuse a temporary gauge hose indefinitely | Permanent test point absent or inconvenient | Rated protected test-port architecture designed with appropriate service access and storage | Exact pressure rating, compatibility, leakage and safe service method UNKNOWN |
| Bypass interlock to inspect during powered testing | No remote diagnostic route | Camera/remote display, protected diagnostic interface, designed test mode with independent safeguarding and no personnel exposure | Complete machine SRS, safe test/positioning procedure |
| Treat padlock as proof of isolation | Padlock can be attached to incorrect state on some products | Positive mechanical state indication and lock-position verification integrated into task procedure | Actual isolating function and residual energy |

## Minimum proposed design inputs, not hardware instructions

1. **Map every hazardous volume:** `ENE-*` includes gas, fluid, gravity and credible trapped/reaccumulating zones; the physical tap/indicator must be identified by zone, not by generic `PRESSURE` text.
2. **Locate safe observations outside exposure:** visibility of relevant instruments and restraint engagement should not require stepping beneath an unproved load. Do not relocate pressure plumbing without an engineering change and revalidation.
3. **Retain independent final-element authority:** normal LinuxCNC/HMI diagnostics can explain faults and inhibit ordinary cycles; they do not replace independent safety-related control or maintenance isolation.
4. **Minimize defeat incentives:** easy-to-use guard, quick safe diagnostic access, obvious restart/reset states, captive fasteners and labeled test points. Do not create an override as a substitute for an inconvenient guard.
5. **Treat instrument and guard maintenance as safety-relevant changes:** a moved gauge, blocked port, replaced transmitter, modified access cover or alternate solenoid bleed variant may invalidate previously accepted `VAL/PT` evidence.
6. **Do not predeclare numeric acceptance:** pressure limit, hold force, stop time, safe distance, calibration interval, instrument rating and required PL/SIL remain UNKNOWN until justified by the selected equipment and hazard analysis.

## Adversarial design acceptance questions

- Can a worker complete the necessary verification from a safe location **without defeating** a protective device or placing any body part under an unproved load?
- If a gauge is disconnected, blocked, isolated or stale, does the UI reveal uncertainty instead of silently presenting an apparently valid zero?
- Can a reviewer trace the displayed pressure to the physical port, gauge revision, current as-built diagram and the exact volume it observes?
- Does a lockable isolation valve have an independently observable **actual** state, and is its effect on stored energy verified separately?
- Does a held reset or retained ordinary cycle command remain incapable of creating unapproved hazardous motion after protection is restored?
- If the proposed access design is awkward, will ordinary technicians predictably remove or bypass it? If yes, redesign rather than relying on instructions alone.

## Disposition

The public-source HYDAC topology supports the need for zone-specific witness labels, not a universal physical test-point design. These candidates require engineering review against the selected machine. If the machine cannot demonstrate its minimum stop/hold/isolation proposition, it must not be operated with people exposed. Any experimental operation must be isolated/remote with people outside the danger zone and residual risk stated.

**Evidence:** HYDAC PN#02068196 (09.11) Fig.1 and §3.2; HYDAC E 3.551.18/04.09 pp.107–108; OSHA 1910.147(d)(5)–(6) for covered servicing; course `SAFETY_TEST_POINT_AND_WITNESS_MAINTAINABILITY_AUDIT.md` and `SAFETY_VERIFICATION_INSTRUMENT_TRUST_CHAIN_WORKSHEET.md`. Practical redesign proposals are **INFERENCE**, not TEST-CONFIRMED or an achieved machine safety rating.

## Direct source navigation (publication-review addition)

- [HYDAC Accumulators Operating and Installation Instructions ACU1107-1367/09.11](https://betterfit-us.hydac.com/wp-content/uploads/Operating%20and%20Installation%20Instructions%20for%20HYDAC%20Accumulators.pdf)
- [OSHA 29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147)

These links identify source families/editions used by the companion investigation; they do **not** make this qualitative note an as-built machine design or a physical validation result. Verify exact selected product/manual and the proposition each source supports before publication.
