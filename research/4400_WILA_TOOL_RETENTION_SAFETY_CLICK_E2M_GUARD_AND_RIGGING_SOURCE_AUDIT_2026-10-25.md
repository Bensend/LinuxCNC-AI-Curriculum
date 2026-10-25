# 4400-TOOL-01 — Press-brake tooling retention and handling: primary-source audit
**2026-10-25 | source/document review | NON-GRADUATED | NO PHYSICAL TEST**

## Narrow engineering question
Can a quick-change punch be considered secured against falling, and can its clamp status establish safe die-change access? **No universal inference is justified.** Tool retention during handling, bending-load clamping, safe human access, and lifting/rigging are distinct propositions. This audit does not assert that WILA tooling is installed on OpenPressBrake.

## Direct manufacturer evidence
1. **WILA, “Fast and safe tool set-ups,”** https://www.wilatooling.com/en-us/knowledge-innovation/our-innovations/fast-and-safe-tool-set-ups/ (accessed 2026-10-25). WILA describes hydraulic and pneumatic holder variants, automatic seating/alignment, Safety-Click top-tool vertical insertion/removal, and **Safety-Click applicability only to tools at or below 12.5 kg**. Its Easy to Move (E2M) bearings support horizontal handling of heavier tools. **DOC-CONFIRMED for stated product family, not selected-machine qualification.**
2. **WILA, “Fast and safe changes without the physical wear and tear,”** https://www.wilatooling.com/en-us/knowledge-innovation/knowledge-articles/fast-and-safe-changes-without-the-physical-wear-and-tear/ (accessed 2026-10-25). Distinguishes vertical Safety-Click and horizontal E2M; describes injury-reduction motivation. **DOC-CONFIRMED manufacturer claim, not independently measured injury rate.**
3. **WILA USA 2024 catalog**, https://www.wilatooling.com/media/l04fzgkk/wila-catalog_2024_usa.pdf (manufacturer-hosted; indexed text consulted; entire 16 MB PDF was not opened by the web fetch). Catalog index distinguishes Safety-Click ≤12.5 kg, Safety-Pin/HD Safety-Pin and E2M-HD for other weight/tool families; holder guards and E2M roll-out prevention; mechanical, hydraulic, pneumatic clamp variants and differing pull-up ratings. **DOC-CONFIRMED at indexed-catalog-text level; exact page/part/edition and original PDF still need selected-hardware review.** Never transfer any catalog maximum to an unspecified holder or combine limits from different variants.
4. **OSHA 29 CFR 1910.184(c),(d)** https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.184 — slings must be identified, inspected, not overloaded, protected from sharp edges; keep employees clear of suspended loads, no fingers between sling and load. **DOC-CONFIRMED regulatory text.**
5. **OSHA 29 CFR 1910.179(n),(l)** https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.179 — for covered overhead/gantry cranes, balanced rigging, no carrying loads over people, and maintenance restoration of guards/safety devices. **DOC-CONFIRMED scope-limited.** Do not automatically apply crane-specific requirements to every hoist/tool-change device.

## Failure-path and authority decomposition
| Physical proposition | Potential false substitute | Discriminator and owner |
|---|---|---|
| TOOL-RETAIN: punch cannot drop during intended insert/remove | Clamp command = ON, or marketing term “Safety-Click” | Exact tool/holder family, compatible anti-drop feature, wear/damage and installation/retention inspection by competent person |
| TOOL-CLAMP: tool supports defined bending force without slip | TOOL-RETAIN true | Exact holder load rating, clamp mechanism, selected configuration, seating/engagement, tool suitability, independent verification |
| TOOL-TRANSFER: heavy tool cannot roll out/fall sideways | E2M bearings roll smoothly | Selected E2M guard/end stop/roll-out prevention and controlled transfer/support |
| TOOL-HOIST: load is securely supported and people excluded | Hoist up button released | Identified rated lifting points/rigging, condition, balanced load, exclusion; selected equipment rules |
| RAM-HOLD: machine beam remains safely supported during tooling change | CNC disabled or ram parked | Separate independent physical ram holding/restraint and isolated energy zones |
| FRESH-START: tooling change cannot leave retained start authority | Guard closed / tool seated | Independent safety reset and fresh ordinary motion demand after people clear |

### Adversarial sequences (INFERENCE; not a machine truth table)
A. Clamp pressure or pneumatic supply disappears after insertion. Safety-Click, **if compatible and intact**, might affect fall retention, but this **does not establish bending-force clamping** or a safe ram. Actual selected failure behavior UNKNOWN.
B. Heavy punch on E2M rollers is moved toward rail end while roll-out guard is missing. Low-friction handling improves ergonomics yet may increase fall opportunity; inspect selected end-stop design, do not infer automatic restraint.
C. Tool mass exceeds 12.5 kg; a worker treats any WILA “quick-change” holder as a Safety-Click. Manufacturer's published applicability boundary is violated. Select the exact approved heavy-tool retention/handling method instead.
D. Hoist supports tool while someone reaches beneath it to align a clamp. Suspended-load exclusion and pinch avoidance remain necessary; do not substitute LinuxCNC E-stop for physical lifting/ram control.
E. Clamp status lamp is green but a tool segment is not seated, or tool/holder variants differ. No independent seating/retention proof; do not bend or permit exposure.

## Claim ledger
- **DOC-CONFIRMED:** WILA vertical Safety-Click ≤12.5 kg, E2M horizontal handling, manufacturer catalog variant distinctions; OSHA sling/crane scope rules.
- **SOURCE-CONFIRMED:** no new LinuxCNC source traced. Existing course demonstrates normal CNC/HAL command ≠ safety final element; not reclassified as new source evidence.
- **TEST-CONFIRMED:** none.
- **COMMUNITY-REPORTED:** none used.
- **INFERENCE:** separate physical TOOL-RETAIN, TOOL-CLAMP, TOOL-TRANSFER, RAM-HOLD, TOOL-HOIST, and fresh restart contracts.
- **UNKNOWN:** OpenPressBrake installed tool/holder, actual retention/guard/rigging, ratings, wear, exact clamping fail state, operator access and physical tests.

## Evidence required before selected-machine design
Exact tool and holder part suffix/revision, tool segment weights and center of gravity, manufacturer's mating compatibility and limits, clamp and anti-drop parts, roll-out guard/end stops, rigging/lift points, task-specific access/guarding, as-built ram hold/isolation, competent inspection and independent selected-machine acceptance. Do not invent load capacity, safe lift height, test load, or PL/SIL. **No people-exposed tooling changes until the qualified machine team establishes the minimum safe-to-operate threshold.**

## Source limitations and next discriminator
The original 2024 WILA PDF is large and was not fully fetched; source text was corroborated against two directly opened manufacturer pages. An exact selected WILA manual or equivalent installed maker documentation would supersede generic catalog wording. No bench simulation can establish the installed mechanical retention or rigging facts; physical validation is gated behind G0/G1. No local or hosted compute justified.
