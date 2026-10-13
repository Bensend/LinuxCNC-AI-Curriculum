# 4400 — AKFR valve and pressure witness, manufacturer-document scope (2026-10-13)

**DOC-CONFIRMED** for historical manufacturer publications; selected-machine installation and physical behavior **UNKNOWN**. **TEST-CONFIRMED: none.** This is a safety-course research note, not a schematic, certification or release.

Fiessler's official four-page *AKAS Safety-Interface AKFR* document (no. 1264, July 16, 2010) describes an interface for AKAS-F and Rexroth hydraulics. Page 2 says the AKFR reads **valve-position indications and pressure sensors** and passes linked indications to AKAS-F. It describes five potential-free normally-open release contacts and fault conditions including protective-field interruption, guard opening, emergency stop and valve-switching faults. These are manufacturer descriptions of the named system, **not** a verified OpenPressBrake wiring/valve truth table.

The document gives an AKFR interface fall-delay specification, but this is **not** a measured machine stopping time. Its combined-system PL/category statements are manufacturer historical application claims; they cannot be transferred to a custom machine or treated as a current selected-product qualification.

**Cross-variant limit:** Fiessler's official AKFH document no. 1256 (August 9, 2021) describes a Hörbiger hydraulic interface reading valve-position indicators; that paragraph does **not** independently establish the AKFR pressure-sensor path for AKFH. The two device variants and document editions must not be conflated.

**Eight-field final-element witness contract:** Record (1) protective demand; (2) actual physical final element and energy path; (3) feedback sensor and exact observed target; (4) narrow proposition the feedback proves; (5) shared electrical/hydraulic/mechanical dependencies; (6) residual pressure, gravity and stored-energy paths; (7) independent machine-level physical stop/hold witness; and (8) separate maintenance energy isolation and mechanical support. An expected valve-position signal or a pressure reading at one point cannot prove all trapped volumes depressurized or the ram safely held.

**Adversarial contradiction:** If interface feedback is healthy but independent beam-position evidence shows movement after a protective demand, or an independent pressure observation reveals a hazardous retained volume, the broader physical safe-state proposition remains **NOT ESTABLISHED**. Block exposed-person operation, diagnose actual sensors, ports, hydraulic paths and mechanical restraint, and retain UNKNOWNs rather than disabling a contradictory witness. Ordinary LinuxCNC/FPGA outputs and HMI indications remain normal control/diagnostics, not personnel-safety authority.

**Human factors:** Make pressure test points, guard restoration and approved mechanical support installation accessible, keyed/labeled and faster than bypassing safeguards. Revalidate after changes to tooling, valve assembly, sensors, wiring or guards. No pressure thresholds, stopping distances, valve fail states, PL/SIL or diagnostic coverage are inferred.

Sources:
- https://www.fiessler.de/default-wAssets/docs/download/AKFH-R/bdh-akas-akfr-si-interface-engl-doc1268-v1.0.pdf
- https://www.fiessler.de/default-wAssets/docs/download/AKFH-R/bdh-akas-akfh-si-interface-dt-doc1256-v1.0.pdf
- https://www.fiessler.de/en/products/safety-products/press-brakes/press-brake-protection-akas.php

Continue via `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md` and the safety-course traceability IDs `BND/ENE/HAZ/SF/PHY/SRS/AUTH/DEP/ARC/VAL/HF/UNK/RR/CHG`. Do not release a machine with people exposed when its physical protection is unproven.
