# 4400 — Same vendor, similar label, different protection logic: AKAS-5M vs AKAS LC-5M

**Status:** DOCUMENTARY COMPARISON / NO PHYSICAL VALIDATION. **Date:** 2026-10-23 UTC.

**Exact manufacturer sources:**

- **A:** Fiessler AKAS-5M, operating instructions **doc 1581**, revision **2024-02-15**, pp. 4–5, 9–11, 24–26. https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf
- **B:** Fiessler AKAS **LC-5M**, operating instructions **doc 1910**, revision **2021-07-30**, pp. 4–5, 9–11, 24–26. https://neu.fiessler.de/default-wAssets/docs/download/AKAS-LC/bdh-akas-lc5m-engl-doc1910.pdf

The two manuals were read and the box-bending/state diagrams compared. Both share high-level concepts (moving optical protection, blanking, box bending, monitored slow mode and OSSD permission), but the exact physical/temporal propositions differ.

| Design/evidence field | A: AKAS-5M doc 1581 | B: AKAS LC-5M doc 1910 | Safe transfer decision |
|---|---|---|---|
| Front receiver set | E3–E6 mentioned in box mode | E3–E5 mentioned in box mode | **Do not copy a receiver mask** between variants |
| Box-mode initial protection | E3–E6 muted; E1/E2 initially active (p.11) | E3–E5 muted; E1/E2 initially active (p.11) | Even when prose is similar, physical beam geometry differs |
| Flat-bend blanking progression | Manual describes E1/E5/E6 muting first; E4 briefly remains active, E3 later (p.9) | Manual describes E2/E3 muting first; E1/E4/E5 then changing, with E5 last (p.9) | **Signal timing and remaining protective zone are variant-specific** |
| Manufacturer-stated maximum overrun for referenced model | 13 mm (p.5) | 12 mm (p.5) | These are not transferable machine acceptance values; measured stopping behavior and exact selected manual still required |
| Box mode finger warning | Finger beside a large die may not be detected (p.11) | Same warning (p.11) | Shared hazard mechanism, not shared safety proof |
| Muting actual-speed requirement | Manufacturer's described <10 mm/s safety-related condition (pp.5,25) | Manufacturer's described <10 mm/s safety-related condition (pp.5,25) | Shared figure does not establish universal safety or equal hardware interfaces |
| Independent control/monitoring | p.25 describes safety-related slow-speed/position/OSSD processing | pp.24–26 explicitly require additional safety PLC and displacement encoder for LC-5M | Verify exact model, controller, wiring, sensor and firmware before engineering capture |
| Setup-mode return | Special OSSD muting must be cancelled (p.25) | Same restoration obligation (p.25) | Reversion still needs selected-machine proof |

**DOC-CONFIRMED:** different receiver sets and flat-bending muting sequences are described by the two manuals. **INFERENCE:** a replacement or software parameter copy that preserves only common signal names (`SSP`, `SP`, `SGO`, `SGS`, `HUSP`, `OSSD`) can silently change which physical area remains protected at a particular point in the stroke. The inference is about transfer risk, not a claim that an actual machine is incorrectly wired.

**Important caveat:** the 2021 LC-5M box-bending page refers to an `SSP/KAST` input in its heading and `KAST` in one numbered step while later wording mentions `SSP`; preserve this as an exact-manual labeling discrepancy, not a wiring recommendation. Both manuals also warn against using their described models for two parallel aligned tandem press brakes under their fast-speed synchronization assumptions (p. 5); this is not a universal verdict on all vendor variants. The 2021 LC-5M manual includes text referring to `E1 and E3–E6` in one flat-bending paragraph even though its stated LC-5M receiver set is E1–E5; this looks like a reused paragraph. The exact printed figures, wiring diagram, selected serial/revision and manufacturer clarification take precedence over an inferred correction. Preserve this as **DOC-CONFIRMED TEXT CONFLICT / UNKNOWN resolution**. The 2024 AKAS-5M document also contains a likely `SGS and SGS` repetition in one paragraph. Neither typo licenses a guessed safety truth table.

## Failure path: convenient 'compatible' replacement

1. Technician sees two Fiessler products with similar names and shared OSSD/slow/box signals.
2. Existing ordinary control maps the same symbolic signals, so the HMI and initial functional stroke look normal.
3. Selected variant's beam geometry and blanking progression differ; a region previously protected during a transition may now be suppressed or vice versa.
4. A nuisance trip motivates bypass, or a false pass occurs because another device already stopped motion.
5. No independent physical zone/stop/hold evidence exists, so the machine cannot be credited as safe for personnel-exposed use.

**Required change record:** `CHG` product identity and manufacturer revision; mark `BND/SF/PHY/SRS/DEP/ARC/VAL/PT` dependents STALE. Re-derive physical reach geometry, tool-change adjustment, timing/overrun, mode restoration, safety-controller compatibility, independent actual-speed witness, final elements and gravity/hydraulic energy disposition. Revalidate through a competent, selected-machine procedure before release.

## Human factors and architecture consequence

A component replacement should be easy to identify correctly: label the installed exact catalog/revision at the machine, retain the correct manual with the electrical drawing, and make setup/guard alignment accessible and repeatable. A generic 'AKAS compatible' dropdown or a single `laser_ok` flag in LinuxCNC should never be the authority for mode suppression. The safety controller and selected physical protective architecture own the decision.

## Verification and unknowns

No simulation is warranted: the key question (whether the manuals describe different masks/progression) is settled by authoritative documents. Actual installation behavior, safe distance, response, valve behavior, tool geometry, PL/SIL and whether either product is selected are UNKNOWN. No machine-level safety certification or permission to operate is claimed.

## Standards-edition guardrail

Both manufacturer manuals refer to older EN 12622 context. The repository's existing `research/ISO_6909_PUBLIC_SCOPE_NOTE_2026-10-11.md` records the published **ISO 6909:2026** scope. Do not claim that a particular clause in a newly published standard has been inspected here or that a newer edition automatically changes the selected product's operating instructions. Record machine manufacture date, jurisdiction, exact product manual and relevant standard edition as `BND/UNK` before a compliance or design-acceptance conclusion. This is a documentation applicability gate, not a legal opinion.
