# 4400 MACH-LOW-02 — low-height fall into dangerous equipment, holes and dropped objects

**Status:** Original direct official regulation audit, NON-GRADUATED, examined 2026-10-27 UTC. A second distinct safety mechanism following MACH-ACCESS-01. Direct 971-line learner-index novelty check found no low-height fall, hole below four feet, falling-object or dangerous-equipment access module.

## Exact original source
US [eCFR 29 CFR 1910.28](https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-D/section-1910.28) was directly inspected (page displaying Title 29 current through 2026-10-23, last amended 2026-10-14). The following are **DOC-CONFIRMED for the regulatory text**, not universal machine-specific engineering dimensions:

- §1910.28(a)(1) broadly addresses exposed fall/falling-object hazards; §(a)(2) lists exceptions, but does not list machine-integral ladders as a blanket exemption. Compare the narrower **ladder-design** scope exception in [§1910.23(a)(2)](https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-D/section-1910.23). Exact applicability still needs jurisdiction/workplace/facts review.
- §1910.28(b)(3)(i) addresses holes at least 4 feet above a lower level; **§(b)(3)(ii) separately addresses stepping/tripping through holes below 4 feet**. Therefore “less than four feet means no hole protection” is false.
- **§1910.28(b)(6)(i) addresses a person less than four feet above dangerous equipment**: falling into machinery may require protection regardless of the ordinary unprotected-edge height rule. This is a different hazard from falling to the floor.
- §1910.28(c) addresses falling objects, including protection of people below by toeboards/screens, canopies or controlled exclusion of the falling-object zone as appropriate.
- §1910.28(b)(8) has a **special repair/service pit** exception with its own conditions. Do not transfer this exception to arbitrary machine openings or a removed walkway grate.
- §1910.28(b)(1)(i) uses a 4-foot general unprotected-edge threshold for covered workplaces, but that one number is **not** a universal no-risk/no-protection threshold for all holes, dangerous equipment or falling objects.

## Adversarial design transfer
A technician stands on a low service step above an unguarded ram or rotating shaft. Even if a fall to the floor would be short, the **destination** can be lethal. Separately, a short drop through a removed panel can break a leg or lead into machine energy. And a wrench dropped from an elevated service platform may injure a second person even if the maintainer has fall protection. These are **INFERENCE** transfers to generic machine design; no OpenPressBrake installed condition established.

## Engineering implications
Evaluate **where** a person could fall, not only how far. Prefer relocating service to ground level, physical guards/rails that do not encourage defeat, stable footing and controlled access; physically protect/cover temporary openings and people below. If maintenance requires opening the route, provide a temporary physical barrier and alternative path *before* removal; assess falling tools and use suitable tool handling/exclusion. Independent ram stop/hold/energy isolation remains a separate physical proposition.

**Evidence classes:** DOC-CONFIRMED exact §1910.28 text, INFERENCE machine transfer, UNKNOWN selected jurisdiction, access geometry, hole, exposed dangerous equipment, people below, physical Y1/Y2 stop/hold. No new LinuxCNC SOURCE-CONFIRMED, TEST-CONFIRMED or COMMUNITY-REPORTED evidence. No simulation or physical test justified. **G0/G1 HOLD.**
