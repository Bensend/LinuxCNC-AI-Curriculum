# 4400-ELEC-01 — Point-of-work electrical verification and safe enclosure access
**Level:** 4000 safety-oriented hardware boundaries. **Status:** SOURCE-READING / NOT GRADUATED (2026-10-24).
**Prerequisites:** 2520/2530/2540/25E0 safety baseline; 4400-RET-01; 4400-DCB-01.
**Unlocks:** conditional qualified electrical-service evidence intake for CNC, press brakes, plasma, mills, lathes and robot cells.

## Learning objective
A fresh engineer must distinguish voltage **presence indication**, actively verified **absence-of-voltage testing**, a lockable **energy-isolating device**, a **safety-related stop**, and an independently **physically safe maintenance state**. Given multiple supplies, identify actual point of work and refuse to infer one green lamp proves all circuits safe.

## Evidence and reading order
Read [original OSHA/NFPA committee/Panduit/Grace audit](../research/4400_AVT_TESTPOINT_NFPA_COMMITTEE_OSHA_POINT_OF_WORK_CONFLICT_AUDIT_2026-10-24.md). Follow OSHA 1910.333/.147, Panduit B21110 Rev4 original pp.3,12–17, NFPA August 2025 committee minutes p.104, then earlier Grace/Rockwell vendor interpretation. **Committee proposed response is not verified final NFPA text.**

## Generic functional architecture, NOT selected wiring
Normal LinuxCNC/FPGA: diagnostics and ordinary control only.
Independent safety relay/PLC: hazard-specific protective stopping through verified final elements.
Lockable isolators: interrupt **each** source, including auxiliary/DC/backfeed.
Qualified absence verification: active, correctly rated method **at each exposed point of work**.
Mechanical/fluid controls: separately restrain gravity loads and pressure.

**Electrical zero does not prove hydraulic zero or ram holding.** An AVT green output must not be the sole permission for a person to enter a press hazard zone.

## Design-for-use
- Accessible labeled lockable isolators, segregated low-voltage diagnostic compartments and protected test access should make correct service faster than bypassing interlocks.
- Map all feeds, UPS, regeneration, DC buses and reaccumulation. A single test location does not certify another circuit.
- For an AVT require exact model, approved waveform/EMI location, independent paired lead terminations, as-built label, energized/deenergized OEM commissioning and requalification after changes.
- Qualified electrical workers determine test method, hazard assessment, shock/arc exposure and PPE; no energized student experiments.
- Do not assign personnel-safety authority to normal LinuxCNC/FPGA or a generic HMI bit.

## Claims ledger
| Proposition | Class | Boundary |
|---|---|---|
| Control switches not sole isolation; backfeed must be checked | DOC-CONFIRMED | OSHA 1910.333/.147 |
| Panduit VS2 AVT tests only sensor location and needs post-change commissioning | DOC-CONFIRMED | B21110 Rev4 only |
| 2025 NFPA committee proposed response restricts permanently mounted test points | DOC-CONFIRMED | Committee record, NOT adopted final text |
| Earlier vendor says certain high-impedance points can comply | DOC-CONFIRMED vendor statement | Chronological interpretation conflict |
| LinuxCNC E-stop proves cabinet service isolation | REJECTED | No such physical authority |
| Selected OpenPressBrake point-of-work electrical safety | UNKNOWN | No qualified as-built witness |

## Prediction before further verification
Dark red lamps with no active test do not prove absence; an auxiliary feed invalidates all-source proof; upstream green does not prove downstream shared DC bus safe. These are document-derived predictions, not physical TEST-CONFIRMED results.

Use [14 paper cases](4400_AVT_TESTPOINT_ENCLOSURE_ACCESS_TECHNICIAN_CARD_2026-10-24.md) and [blank witness](4400_ENCLOSURE_POINT_OF_WORK_ELECTRICAL_WITNESS_BLANK_2026-10-24.md).

## Graduation and promotion
**NOT GRADUATED**: actual qualified selected-machine evidence, authoritative final NFPA/AHJ resolution for test-point equivalence, independent fresh-AI transfer and physical safe-state verification missing. Counterfactual: if adopted standard differs, universal test-point compliance conclusion changes and must remain BLOCKED. Narrow claims about source mapping, point-only testing and control-stop vs isolation survive. No lab: standards chronology and physical placement cannot be resolved by synthetic compute. External evaluation NOT RUN/NOT SCORED.
