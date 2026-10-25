# 4400-RETURN-01 — Removing an absent employee's personal lock is not a supervisor convenience

**Status:** 2026-10-25, safety research / NON-GRADUATED. This is a distinct personnel-authority failure path from group lockout, shift change and minor servicing.

## Exact authority
- 29 CFR 1910.147(e)(3), *release from lockout/tagout*, https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
- OSHA original 1994 Federal Register preamble discussing personal lock control (context is 1910.269 and its comparison to 1910.147): https://www.osha.gov/laws-regs/federalregister/1994-01-31
- OSHA 2007 Federal Register discussion of 1910.147 lock-removal exception: https://www.osha.gov/laws-regs/federalregister/2007-12-20

**Access qualification:** official indexed OSHA text, 2026-10-25; direct OSHA open in this environment returned HTTP 403. **DOC-CONFIRMED from official indexed passages**; not direct full-page inspection.

## General rule and narrow exception
The employee who applies a personal lock/tag ordinarily removes it. Under 1910.147(e)(3), when that employee is unavailable, employer-directed removal requires an existing **documented, trained procedure providing equivalent safety**. It must include at least: (1) employer verification that the applying employee is not at the facility; (2) all reasonable efforts to contact and inform the employee of removal; and (3) assurance the employee knows of removal **before resuming work**. This is not permission for an untrained supervisor to cut a lock merely because the job is late.

The OSHA 1994 preamble emphasizes personal control, danger of assuming a worker has left, and that convenience is not a sufficient justification. The actual 1910.147(e)(3) text, not the 1910.269 rulemaking context, is the governing quoted source for the general-industry exception.

## Failure chain and countermeasures
**Hazard:** a personal lock is found after the night shift; supervisor assumes its owner left, removes it, and restores hydraulic power while that person or a different worker remains in the die area. **Independent failures:** inaccurate worker location; no exposure roster; unauthorized lock removal; unchecked stored energy; missing employee notification; stale normal CNC start request. **DOC-CONFIRMED** procedure requirements above. **INFERENCE** use a simple emergency escalation card requiring named employer authorization, positive absence check, reasonable contact record, physical personnel clearance, lockbox status, selected-machine isolation/ram hold verification, and recorded return-to-work notice. The card is not a substitute for the legally required procedure.

## Adversarial questions
1. Employee A forgot a lock; is the shift manager's master key alone sufficient?
2. Employee A cannot answer a phone; can the lock be cut immediately?
3. Employee A is confirmed off-site; which other required steps remain?
4. Employee A returns tomorrow; how must the removal be communicated before A resumes work?
5. If another employee remains exposed, does successful absent-worker contact authorize reenergization?
6. Can LinuxCNC 'safe/idle' or a safety relay green light prove everyone is clear?

## Limits
**DOC-CONFIRMED:** 1910.147(e)(3) and original OSHA contextual explanation. **SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **INFERENCE:** ergonomic escalation card and cross-check. **UNKNOWN:** actual OpenPressBrake isolation points, workers, safety state, legal context, physical Y1/Y2 hold/pressure/guarding. No physical tests, Actions dispatch or independent evaluation. **G0/G1 HOLD; no personnel-exposed operation.**
