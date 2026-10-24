# 4400-RAD-03 — R15 v09 versus v11 original-manual edition and configuration scope
**Date:** 2026-10-24. **Evidence:** DOC-CONFIRMED direct original manufacturer PDFs; edition-specific, no selected machine. This is a comparison of documents, not a firmware qualification or laboratory test.

## Two independently inspected original sources
- Tele Radio R15 receiver **IM-PN-RX103-EN-v09**, 54 pages, [original manufacturer PDF](https://www.tele-radio.com/app/uploads/Panther-PN-R15-Manual-1.pdf). Cover: SW0014-14v24+; older firmware requires IM-PN-RX103-A04-EN.
- Tele Radio R15 receiver **IM-PN-RX103-EN-v11**, 57 pages, [original manufacturer PDF](https://www.tele-radio.com/app/uploads/IM-PN-RX103-ENv11.pdf). Cover: same SW0014-14v24+ gate. Both cover R15-01/-02/-07/-08/-13/-14.

## High-consequence version comparison
| Topic | v09 direct original | v11 direct original | Engineering implication |
|---|---|---|---|
| Qualified transmitter in safety-function chapter | **T19-02** (printed p.13) | **T19-02 and T29-12** (printed p.13) | Do not infer a T29-12 pairing from v09; select exact document/firmware and matching transmitter installation instructions/certification. |
| Stop subsystem | PLd Cat3, 500 ms max safety-related radio stop response (p.13) | Same described scope (p.13) | Neither is entire machine stopping distance/holding or end-to-end PL. |
| Configuration requirements | Continuous radio, all relays OFF link loss, <=500 ms timeout, login/logout ON, Custom ID OFF, Require start ON (p.14) | Same listed requirements (p.14) | Verify exact receiver readback and wiring, not only nameplate. |
| Receiver power return | Require start ON blocks stop-relay reactivation until start packet; OFF is NOT PLd compliant (p.15) | Same (p.15) | This radio permission is not deliberate new machine cycle start. |
| Discontinuous mode 5 | Explicitly cancels PLd classified stop (p.41) | Explicitly cancels PLd classified stop (p.43) | Convenience mode change can destroy certified safety scope. |
| Configuration-change handling | PLd LED meaning and mode menu described (pp.14, 35–36) | **Explicitly says power-cycle receiver after changing from PLd to non-PLd configuration** (p.37) | Edition-specific commissioning/change-control instruction; do not silently omit, and do not perform live changes with people exposed. |
| Special operating modes | Modes 0/255 reserved/customer-specific | Modes 0/255 reserved/customer-specific | Unknown custom behavior is not a safe default. |

## What was NOT established
- No complete clause-by-clause semantic diff; only relevant safety/identity/mode passages were compared.
- No selected receiver firmware, hardware, wiring, actual paired transmitter or version-appropriate certified configuration.
- No assertion that v11 is the latest manufacturer release solely because the version number is larger; search crawl/publication metadata do not establish release chronology.
- No test that power cycling changes physical machine behavior; the v11 instruction is product-specific and cannot be treated as permission to reenergize a loaded machine.
- No safety equivalence between T19-02 and T29-12; each needs its exact matching documentation and certification.

## Field-change gate (INFERENCE)
Any receiver manual/firmware/transmitter replacement or mode change should trigger CHG: lock machine against hazardous motion, confirm selected product/edition and configuration, assess stop-output wiring and end-to-end safety-function dependencies, revalidate actual physical stop/hold, inspect pairing and fresh-start logic, and only then consider commissioning. Treat a green receiver PLd LED as configuration indication, not a machine safety acceptance test.

**Selected machine:** radio presence UNKNOWN; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED; no compute or physical test.
