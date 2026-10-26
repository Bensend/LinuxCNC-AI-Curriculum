# 4400 KEY-MECH-01 — Mechanical trapped-key sequence is not universal energy isolation

**Status:** manufacturer-source documentary audit 2026-10-26, no physical test. Sources: Fortress Safety mGard product page https://fortress-safety.com/fortress-range/mgard/ ; Fortress explanation https://fortress-safety.com/news/understanding-trapped-key-systems/ ; manufacturer mGard overview brochure indexed at https://fortress-safety.com/wp-content/uploads/2022/06/mGard-Overview-Brochure-June-2020-v1.5-EN-QR-Download-Digital-Version.pdf . **Access limitation:** the brochure was indexed with a relevant multi-person example but direct fetch returned DisabledError; do not treat uninspected pages as reviewed.

## DOC-CONFIRMED from accessible original manufacturer pages
- mGard mechanically sequences **power/control interlocking**, **intermediate key exchange**, and **access locks**; the manufacturer describes mechanical interlocks that may not need wiring at the access point.
- Key-exchange devices release one or more access keys only after prerequisite keys are inserted; a person can carry a **personnel key** into the safeguarded area, preventing return of the access key until that personnel key is returned.
- Different energy sources may have different prerequisite keys; manufacturer explicitly describes interlocking of circuit breakers and valves, and offers optional time-delay or voltage-sensing devices. These are **different devices/functions**, not proof that all stored energy has dissipated.

## Engineering distinction (INFERENCE)
A correct key sequence can strongly enforce **order of operations**, but the key alone cannot establish hydraulic residual pressure, gravity-load retention, a physically stopped Y1/Y2 axis, actual isolation contacts, or that an operator cannot be trapped by a changed escape route. For multiple people, a single shared personnel key cannot provide individual presence accountability equivalent to each person retaining their own designated protective key. The precise device design, number of keys, duplicated/master keys and emergency release must be checked; no universal behavior is inferred.

## Failure paths for qualified review
- Energy isolator key released based on a command but actual downstream hydraulic pressure remains trapped.
- An access lock is reclosed while a second worker is still in a blind cell because individual personnel-key count was not maintained.
- A duplicated/master key or replaced lock invalidates the assumed key uniqueness/sequence.
- A modified guard bracket or escape path makes a formerly safe access sequence physically hazardous.
- The correct sequence is cumbersome, so workers prop the door; improve layout and accessibility rather than defeat the interlock.

## Applicability / evidence
**DOC-CONFIRMED** Fortress product architecture as described; **INFERENCE** safety requirements; **UNKNOWN** selected machine installed key system, exact energy isolators, PL/SIL, stored-energy dissipation, personnel count, emergency escape and compliance with personal LOTO. OSHA 1910.147 applicability and exceptions must be reviewed separately; no manufacturer marketing is a substitute for the jurisdiction/task-specific legal and physical analysis. **TEST-CONFIRMED none; new LinuxCNC SOURCE-CONFIRMED none; COMMUNITY-REPORTED none. G0/G1 HOLD.**
