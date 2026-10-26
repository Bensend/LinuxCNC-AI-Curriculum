# 4400-PEDAL-02 — Pressure-point foot control is not necessarily a safety overtravel stop

Date: 2026-10-26. **Direct manufacturer document/product audit; NON-GRADUATED.** Distinct source deepening after [PEDAL-01](4400_PEDAL_01_LINEMASTER_ANTI_TRIP_SIGHTGUARD_OSHA_PRESS_BRAKE_SCOPE_AUDIT_2026-10-26.md). No selected-machine configuration or physical test.

## High-value false equivalence

**Three-phase / three-position actuation** and **safety foot switch with panic overtravel** sound similar but are not interchangeable. A manufacturer document describes one pressure-point design where **first NO remains asserted after deeper travel**; its separate safety-foot-switch design opens and mechanically latches a **positive-break NC** contact on overtravel. Without exact product identity, a deep pedal press cannot be credited as a protective stop.

## Source ledger — inspectable original OEM

1. **DOC-CONFIRMED, original Schmersal eight-page “Foot switches and Safety foot switches” brochure**, publication line **04.2006, issue 01, part 1186588**: https://products.schmersal.com/upload/orig/10/00/19/98/DOC_MAR_BRO_b-tfup_SEN_AIN_V2.pdf. Directly opened, eight pages. **Printed p.3 / PDF page 3 (zero-index p2)** “3-phase actuation with pressure point”: top position idle; initial pedal depression closes first NO; pushing past pressure point closes second NO while **first remains active**. The illustrated state sequence is `00 -> 10 -> 11`. This is **not** a safe-stop command without additional validated interpretation.
2. **DOC-CONFIRMED, same OEM PDF printed p.3 / PDF p2** “Safety foot switches”: depressing to pressure point closes NO; pressing beyond in danger opens a **positive-break NC**, which is **mechanically locked**; a blue button resets the switch. **Do not infer automatic reset, a universal NC/NO timing sequence or certified machine-level stop.**
3. **DOC-CONFIRMED, same PDF printed p.4 / PDF p3** ordering details: `hd` is pressure-point three-phase operation; `f` is a separate bi-stable start/stop feature; safety-foot-switch section at **printed p.6 / PDF p5** names `TFH 232-11-üdr`, specifies 1 NO/1 NC and positive-break NC. Manufacturer's **product-family labels do not collapse these variant distinctions**.
4. **DOC-CONFIRMED, current OEM catalog** [Schmersal TF 232-20HD, exact item 151182009](https://products.schmersal.com/en_GB/tf-232-20hd-151182009): 2 NO contacts, three-phase pressure point, “also available as safety foot switch,” not “this item is a safety foot switch.” The current page reports a slow-action NO switching element. The page was directly opened 2026-10-26.
5. **DOC-CONFIRMED OEM human factors:** the same 2006 brochure PDF p2 says .FH 232 protective shield has a wide opening intended for safety shoes and foot repositioning. This is a manufacturer usability design statement, not proof that any opening blocks every unintended actuation.

## Version / transfer boundaries

- The **2006 brochure** establishes its documented model-family operating principles. The **2026 catalog** establishes exact current 151182009 listed contacts. These are **not** a substitute for a selected part's current installation/operating manual or machine wiring.
- Do **not** map `TF 232-20HD` two-NO pressure-point operation onto `TFH 232-11-üdr` NC mechanical-latch behavior. `TF`, `TFH`, `HD`, `f`, `üdr` and full part number must be captured.
- A NO contact that remains asserted through a deeper press can produce the opposite result from an engineer's assumed “panic stop”; the machine controller must be separately assessed for how it interprets those inputs. Even a correctly wired positive-break NC does not independently prove final-element stopping, gravity holding or no unexpected restart.
- The brochure distinguishes **mechanical reset of a latched foot switch** from the **independent safety-controller reset/rearm** and **ordinary LinuxCNC new-cycle request**. These are separate state transitions. No physical test or timing value was inferred.

## Counterfactual hazard chain

`operator presses harder during danger` → `exact HD first NO remains closed` → `ordinary LinuxCNC start may remain asserted` → `if designer incorrectly assumes deep press removes command, motion may continue`.

For the **separate safety-foot-switch variant**, `overtravel opens positive-break NC and mechanically locks` is only a *device contact proposition*. The remainder is `qualified safety-related input/logic -> final elements -> physical stop/hold -> deliberate reset/restart`; all require selected-machine evidence.

## Practical no-energy discriminator

With authorized isolation and stored-energy controls, first record exact nameplate/order code and OEM contact diagram; then inspect design drawings and as-built contact mapping for each travel region, mechanical latch and blue reset. **Do not energize or actuate a hazardous machine to “try” the panic feature.** If the selected design is unknown or basic safe-to-operate evidence missing, hold operation with people exposed. Any bench/no-energy continuity examination must be qualified and must not be mistaken for physical stop proof.

## Evidence labels and gaps

- **DOC-CONFIRMED:** original Schmersal 2006 brochure and current exact-model catalog above.
- **SOURCE-CONFIRMED:** no new LinuxCNC trace; ordinary command boundary is prerequisite.
- **TEST-CONFIRMED:** none.
- **COMMUNITY-REPORTED:** none relied upon.
- **INFERENCE:** hazardous consequence if an engineer substitutes a three-phase HD NO contact for a safety overtravel NC.
- **UNKNOWN:** selected pedal, controller wiring, NC timing, safety function/PL/SIL, Y1/Y2 stop, gravity hold, pressure isolation, physical tests, evaluator.

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No hosted/local compute, workflow or physical test. Exact-product distinction is documentary, not installed-machine validation.
