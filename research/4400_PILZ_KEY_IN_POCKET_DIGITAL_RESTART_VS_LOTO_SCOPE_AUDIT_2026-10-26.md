# 4400 KEY-DIG-01 — Digital 'key in pocket' restart prevention versus hazardous-energy control

**Status:** manufacturer documentation/marketing scope audit 2026-10-26; no software source, controller configuration, or machine test.

## Original manufacturer sources
- Pilz 4 Oct 2022 press release https://www.pilz.com/en-US/company/press/messages/articles/235088
- Pilz 28 Aug 2023 system release note https://www.pilz.com/en-INT/company/news/articles/238605
- Pilz access management description https://www.pilz.com/en-GB/access-management

**DOC-CONFIRMED:** Pilz describes PITreader authentication and a safety controller (PNOZmulti 2 or PSS 4000), storing personalized security IDs in a safe list. Authorized workers carry RFID keys; restart remains inhibited until users sign out and their IDs are removed. The 2023 note specifically ties the PSS 4000 feature to release 1.25. These are **vendor descriptions of its implemented system**, not an inspected safety-controller source trace.

## Important scope conflict to preserve
The vendor describes the system as an alternative to conventional mechanical LOTO arrangements for some fenced maintenance applications. **This is a product-positioning claim, not proof that a particular task's legal personal-lockout obligations are met**, nor proof of isolation of electrical, hydraulic, pneumatic, thermal, gravity or accumulator energy. The relevant jurisdiction, task, risk assessment, physical isolation, residual-energy verification and applicable exceptions must be reviewed separately. Do not assert that RFID alone is equivalent to a personal lock and verified energy isolation.

## Failure-path reasoning (INFERENCE)
- Correct sign-out may permit a safety-controller restart while a person remains in a blind area due to identity/accountability or egress errors; independent physical area-clearance and deliberate start still matter.
- A network/HMI showing a signed-out identity is not evidence of physical ram holding or pressure-zero.
- Controller version/feature/configuration changes may alter the safe-list behavior; exact firmware and safety configuration are mandatory for a selected design.
- A lost RFID key, inaccessible reader or inconvenient sign-out may incentivize bypass; provide reliable recovery procedures that preserve independent barriers.

## Claims and gates
**DOC-CONFIRMED** Pilz-described functionality for its products and release; **INFERENCE** hazard analysis; **UNKNOWN** selected machine installation, certified function/configuration, independent safe-state, legal equivalence and actual PL/SIL. **SOURCE-CONFIRMED LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none.** No authorization for energized maintenance, personnel exposure or machine release; G0/G1 HOLD.
