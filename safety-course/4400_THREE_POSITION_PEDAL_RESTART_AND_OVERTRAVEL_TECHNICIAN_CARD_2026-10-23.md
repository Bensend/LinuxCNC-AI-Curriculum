# 4400 technician card — press-brake foot pedal overtravel, release and restart

**Purpose:** a learner-facing *paper/isolated-bench* qualification exercise following 2530 reset/rearm, 2590 interlocks, 25C0 human factors and the cumulative Safety Design Package. No hazardous energized fault injection. Keep evaluator-only hidden answers separate.

## The machine case

A retrofit uses an ordinary LinuxCNC control panel, a three-position foot pedal, a separate safety-related controller and a hydraulically driven gravity-loaded ram. The operator reports that a held pedal sometimes allows another movement after a safety reset. A technician says that because the pedal has two safety contacts and the screen says READY, the machine must be safe. No validated machine stopping or holding data is available.

Manufacturer source: Fiessler `prd-fe-fs-engl-doc1908.pdf` printed pp. 10 and 18; selected switch part, wiring, controller and hydraulic circuit are **not** given. Treat all machine-specific claims as UNKNOWN.

## Task A — physical/contact identity

For the *specific* single-pedal model `FE-FS1-SU1ASDO2-U-XX`, draw three states: free, working pressure point, overtravel. For each, fill 13–14, 21–22, 11–12 and 31–32 as open/closed using the manufacturer diagram. Identify which are working contacts and which are safety NC contacts. Explain why a diagram of a double-pedal assembly cannot automatically prove a two-person safety function.

## Task B — trace authority, not LEDs

Fill the table for the selected machine or explicitly mark UNKNOWN:

| Event / proposition | Owner | Signal/physical witness | What it does NOT prove | Required `SRS/PHY/AUTH/VAL` IDs |
|---|---|---|---|---|
| ordinary press request | | | | |
| overtravel safety demand | | | | |
| safety-related output withdrawal | | | | |
| actual valve/drive final element | | | | |
| actual ram stop/holding | | | | |
| pedal release recognized | | | | |
| deliberate rearm and new start | | | | |
| servicing isolation/restraint | | | | |

**Adversarial variants:** selected FMSC-FP mode is `pedal 1 OR pedal 2` while HMI says two-person AND; selector fault; working contact stuck active; one safety NC shorted; pedal overtravel while another operator is exposed; swapped pedal terminals; selected AKAS mode delegates foot-pedal monitoring to an external safety PLC; safety reset while a start command remains held; replacement pedal has a different terminal arrangement. For each, say what is SOURCE/DOC-CONFIRMED, INFERENCE and UNKNOWN. No fabricated stopping limits or PL/SIL.

## Task B2 — multi-operator selector and restart indication

Fiessler FMSC-FP brochure doc1872 printed p. 5 has four modes (1 only, 2 only, OR, AND), a separate restart-button request indication, and a connection example. A typo in the brochure's list says "pedal 3" where its other descriptions refer to pedal 2. The learner must identify the exact *installed* selector position, controlled mode authority, per-pedal zone assignment, distinct restart request/acceptance, and independent output/physical witness. Do not use the brochure's example schematic as a verified retrofit wiring diagram. Explain what must become `CHG-*`/`STALE` when the selector logic, number of operators, wiring or replacement controller changes.

## Task B3 — transfer the selector logic without pretending to validate hardware

Fill an abstract 2-input OR/AND truth table for both inputs released, pedal 1 only, pedal 2 only, and both pressed. Identify the two states in which an OR authorization differs from AND. Then distinguish this paper result from the actual selected safety function, which must separately handle pedal overtravel, other protective devices, final elements, and physical machine stopping. Apply the same reasoning to a robot enabling-device selection or two-person automated-cell station, preserving their different hazard and restart requirements.

## Task C — make safe use easy

Identify three specific reasons a real operator might defeat the pedal (e.g. accidental nuisance overtravel, awkward placement, difficult cleaning). Propose changes to hood/mounting, fault indication and maintenance access that preserve the required safety function. Include a release/rearm/new-start workflow that does not encourage holding the pedal through reset.

## Pass conditions for a fresh evaluator

A credible response keeps normal command, safety stop, actual physical safe state, reset and fresh start distinct; notices the manufacturer catalogue's contradictory phrase about overtravel *initiating* hazardous motion; refuses to infer physical stopping from contact state; recognizes product- and mode-specific monitoring; and does not authorize exposed-person operation while minimum safety evidence is missing.

**Sources:** https://www.fiessler.de/default-wAssets/docs/download/FE-FS/prd-fe-fs-engl-doc1908.pdf ; current official product/mode descriptions https://www.fiessler.de/en/products/safety-products/safety-footpedals/safety-foot-pedals-fe-fs.php . Fiessler FMSC-FP brochure: https://www.fiessler.de/default-wAssets/docs/download/FMSC-Schaltgeraete/prd-fmsc-switching-device-engl-doc1872-comp.pdf . The separate Fiessler AKAS-3PF manual doc 1379 (2017-01-27) has only a search-excerpt witness this session; do not treat its specific monitoring-mode description as independently inspected. No physical test or machine release is implied.
