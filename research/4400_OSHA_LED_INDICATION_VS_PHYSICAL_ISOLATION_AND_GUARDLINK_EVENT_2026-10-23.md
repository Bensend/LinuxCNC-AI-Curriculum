# 4400 — Indication is not isolation verification: OSHA LED interpretation and GuardLink first-event boundary

**Study UTC:** 2026-10-23. **Status:** DOC-CONFIRMED official regulatory/manufacturer documents; INFERENCE for generic architecture and adversarial failure paths; UNKNOWN for any installed OpenPressBrake/other machine. No physical test, no machine qualification, no external blind evaluation. This is a public educational source trace, not a legal applicability determination.

## Source question

A maintainer sees a green HMI `SAFE` indicator, a panel disconnect's redundant LED indicators are dark, and a GuardLink first-trip field is clear. Can these observations replace task-specific verification of physical energy isolation, stored energy and hazardous motion?

**Answer:** No. Each indication has a bounded meaning; none of these three observations, alone or together without further evidence, establishes every relevant physical proposition.

## Primary documentary evidence

1. **DOC-CONFIRMED — OSHA, 29 CFR 1910.147(b), (d)(3–6), (f)(1):** energy-isolating devices physically prevent energy transmission/release; pushbuttons/selector switches are not energy-isolating devices; hazardous stored energy must be relieved, disconnected, restrained or otherwise rendered safe; the authorized worker verifies isolation/deenergization before servicing; temporary powered positioning is followed by deenergization and reapplication of energy controls. Official current regulation: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
2. **DOC-CONFIRMED — OSHA interpretation letter, 2012-12-12, “Whether an LED type device can be used for the isolation and deenergization verification requirements of 1910.147 and 1910.333”:** OSHA answers **No** to the described LED indicator replacing 1910.147(d)(6) verification. If properly installed/maintained, it might serve as a *redundant indicator* of disconnect-open position. The letter also distinguishes the separate electrical-exposure requirements of 1910.333. Do not extend this particular interpretation to all differently designed or qualified proving systems without evaluating their own scope. https://www.osha.gov/laws-regs/standardinterpretations/2012-12-12
3. **DOC-CONFIRMED — OSHA Appendix A typical minimal lockout procedure:** identify energy sources, secure isolation, address stored/residual energy (including elevated members and hydraulic systems), verify effectiveness and return controls to neutral. Appendix A is a typical procedure, not an automatically sufficient machine-specific method. https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147AppA
4. **DOC-CONFIRMED — Rockwell Automation, GuardLink EtherNet/IP Interface User Manual 432ES-UM001E-EN-P, June 2025, controller tag table p.64:** `Ch0.DeviceTripAddress` records the cause of the first operational-to-safe transition; subsequent device trips do not overwrite that first event. `Ch0.TripTimestamp` records the last operational-to-safe transition for documented causes. `Port1.Uncertain` denotes questionable data validity. These are **different evidence semantics**, not an all-current-guards-state bitmap. https://literature.rockwellautomation.com/idc/groups/literature/documents/um/432es-um001_-en-p.pdf

## Claim and authority matrix

| Proposition | Evidence class | What it can support | What it cannot support |
|---|---|---|---|
| Disconnect-position LEDs dark | DOC-CONFIRMED for the OSHA-described indicator | Supplementary indication of disconnect state under installation/maintenance conditions | Required isolation verification or absence of downstream/backfed/stored energy |
| `DeviceTripAddress` empty/unchanged | DOC-CONFIRMED for 432ES manual/edition | Narrow first-transition event diagnostic in the described channel | Every guard currently closed/locked; no later trip; physical stopping |
| `Uncertain=1` | DOC-CONFIRMED | Diagnostic-data validity is questionable | Reliable affirmative safety evidence |
| LinuxCNC machine-off/HMI reset | SOURCE/DOC boundary established elsewhere in curriculum | Ordinary control and operator diagnostics | Personnel-safety decision, maintenance isolation or physical final-element proof |
| Selected-machine zero-energy / ram held | UNKNOWN | Nothing until appropriate physical evidence exists | Cannot be inferred from one HMI bit, relay status, gauge, LED or manufacturer product sheet |

## Adversarial counterexample — press brake

**INFERENCE:** The disconnect LEDs indicate off; the ordinary HMI reads `Safe`; a 432ES event field shows the first tripped guard. Yet an accumulator chamber, trapped pilot line, gravity-loaded ram or unrelated electrical feed may remain hazardous. The observations are not logically inconsistent: they observe different boundaries. Conversely, an independent physical beam-motion witness that contradicts the purported stopped/held condition invalidates the broader safe-state proposition, even if the diagnostic display is green.

**UNKNOWN:** actual hydraulic/electrical topology, measured pressure zones, load-restraint method, exact selected safety device/firmware, stopping/access times and proof intervals. Do not invent them. A qualified site-specific verification method is required before personnel-exposed servicing or hazardous operation.

## Practical architecture / human-factors requirements (INFERENCE)

- Separate the HMI's **diagnostic status** (device/firmware, channel, source, event versus current, freshness, validity) from the independent safety-controller **protective decision** and from the **physical energy-isolation/holding** witness.
- Put lockable, labeled isolation points and suitable task-specific verification access where workers can reach them without removing or defeating guards. Label gauge/test-point **zone**, **upstream/downstream** location and known blind spots; design for reaccumulation checks.
- Treat loss of diagnostic freshness or power as **UNKNOWN**, not as a successful proof. Retain first-event history for troubleshooting but never use it as current-state authority.
- After a necessary energized positioning step, invalidate earlier isolation proof and repeat the selected energy-control and verification procedure before continuing maintenance.
- Make guard restoration, escape and verification simple, repeatable and physically inspectable. An inaccessible proof point or cumbersome guard that invites bypass is a design issue, not a training-only issue.

## Transfer and traceability

Map the real energy source and hazard to `BND/ENE/HAZ`; the physical proposition to `SF/PHY/SRS`; safety authority and final element to `AUTH/ARC/DEP`; worker convenience/defeat to `HF`; task-specific test/physical witness to `VAL/PT`; and every modification to `CHG` with dependent evidence marked STALE. Preserve `UNK/RR` until closure. The exercise is open-book and not a sealed 2520–25F0 answer.

**No exposed-person operation** until the minimum hazard-specific safe-to-operate evidence is established. Isolated/remote experimental operation must keep people outside the danger zone and state residual risk. No lab was justified: the narrow indicator-versus-verification question is answered by authoritative documentary evidence; physical machine validation remains a separate unresolved task.
