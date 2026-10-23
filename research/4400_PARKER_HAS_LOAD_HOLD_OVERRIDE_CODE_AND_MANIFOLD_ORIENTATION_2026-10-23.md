# 4400 — Parker HAS load-hold manual override, order-code and manifold-orientation audit
Date: 2026-10-23 UTC | Original manufacturer-source investigation; not a selected-machine test or archived ZIP release

## Source and exact question

**Source (DOC-CONFIRMED):** Parker Hannifin, Hybrid Actuation System Cylinders Installation Manual, catalog HY08-4005-M11, “Load Holding Valves – PO Check Valves” and “Load Holding Valves – Locations on Lower Manifold,” printed pp. 35–37. Official PDF: https://www.parker.com/content/dam/Parker-com/Literature/Industrial-Cylinder/cylinder/Serv/HY08-4005-M11_HAS_Installation_Manual.pdf

**Question:** Can an apparently installed load-holding check valve actually be supplied/configured for *no holding*, and does the valve's visible location unambiguously identify the push/pull chamber?

**Answer at this product scope:** Yes to the first, no to the second. The manual states that circuit code “N” (no load holding) is supplied with an “R” coded PO check valve with its **manual override engaged**, permitting free flow both directions. It offers a tamper-resistant cover if the override poses an application issue. Separately, valve ports marked “a” and “b” map to push/pull circuits according to the unit's orientation; the manual provides an orientation-specific table. This is a manufacturer-described configuration, **not** proof that a particular installed cylinder has a functioning load-holding device.

## Evidence ledger

| Claim | Class | Exact manual scope | What remains UNKNOWN |
| --- | --- | --- | --- |
| HAS 500 / HAS-ST use product-specific PO check valve order codes P and R. | DOC-CONFIRMED | p. 36 product/valve table | Selected machine model, order code and as-built valve. |
| Circuit code N is described as no load holding with an R-coded PO check and manual override engaged. | DOC-CONFIRMED | p. 36 “Circuit Cide” [manual typo] note | Whether a particular override is engaged, damaged, locked, or altered. |
| Manual override permits free flow in either direction in that configuration. | DOC-CONFIRMED | p. 36 same note | Actual flow paths and consequences for the installed load. |
| Tamper-resistant cover is offered when override poses application issues. | DOC-CONFIRMED | p. 36 same note | Whether a cover is fitted and whether it prevents the foreseeable defeat in the actual installation. |
| Lower-manifold ports a/b are orientation-dependent for push versus pull circuit. | DOC-CONFIRMED | p. 37 orientation table A–D | Selected orientation, cylinder port labels and physical pressure zones. |
| Visual presence of two check-valve bodies or a gauge proves gravity restraint. | **REJECTED INFERENCE** | Manufacturer notes above | Requires exact configuration, as-built topology, and independent physical witness. |
| This manual establishes all press-brake hydraulic load-hold safety behavior. | **REJECTED INFERENCE** | HAS-specific product manual | Press-brake manifold, gravity force, hoses, pilot, leakage and other final elements. |

## Failure path — plausible component, absent function

1. Technician sees a PO check cartridge and assumes load holding.
2. Installed order/circuit code may instead designate **N/no load holding**; in the described Parker arrangement an R-coded valve is present but manually bypassed.
3. If a gravity load is being supported only by the assumed hydraulic lock, the physical restraint proposition is unproved.
4. A green HMI valve status, cylinder position bit, or a static gauge cannot establish the override's actual state or eliminate downstream leakage and common-cause faults.
5. Maintenance isolation and protection against falling loads remain separate; no person should enter the hazard zone based on the valve's visible presence.

**INFERENCE:** This is a realistic human-factor defeat/inspection trap for *any* system in which a bypassable hold device is mistaken for a passive default hold. The specific “N/R/manual override” behavior is confirmed **only** for the cited HAS manual.

## Failure path — orientation and false pressure witness

1. A service worksheet labels the “a” manifold cavity as the rod-side/pull chamber for every unit.
2. Parker's manual makes push/pull assignment depend on orientation A/B/C/D.
3. The worksheet can then associate a pressure reading, isolation valve, or test point with the wrong energy zone.
4. A zero reading on the wrong zone could be falsely promoted to evidence of load release or maintenance isolation.

**Required fix:** Obtain selected assembly order code, stamped orientation, as-built circuit and physical port-to-cylinder tracing before assigning SRS-ENERGY, PHY-HOLD or PT evidence. Do not infer orientation from photographs alone.

## Defeat-resistant architecture and practical technician workflow

- Keep manual overrides accessible for authorized service but conspicuously identified and protected from accidental or casual defeat; a tamper-resistant cover may help, but **does not substitute** for a qualified safety function or maintenance LOTO.
- Provide an unmistakable “override/service mode” record and a return-to-service check that verifies actual configuration, not just software reset. Avoid requiring tools or contortions for normal guard use that would encourage users to leave protection defeated.
- Label each load-holding and controlled-lowering function separately. The same HAS manual says its PO check is *not* a load-lowering valve and warns of ratcheting when lowering; this cannot be corrected by guessing a pilot pressure.
- Ensure independent physical support/restraint and exclusion before opening hydraulic circuits, inspecting a manual override or attempting a functional proof. This document **does not authorize** touching a loaded valve or performing a pressure test.

## Paper-only verification intake (not a procedure to manipulate a loaded machine)

| Intake | Required evidence | Status absent machine |
| --- | --- | --- |
| H-01 | Exact actuator nameplate and order code including circuit option | UNKNOWN |
| H-02 | Actual PO check cartridge P/R/N variant and override position | UNKNOWN |
| H-03 | Orientation A/B/C/D and physical port-to-chamber mapping | UNKNOWN |
| H-04 | Controlled-lowering device separate from static load hold | UNKNOWN |
| H-05 | Shared pilot supply, hose/line failure, relief/leak paths | UNKNOWN |
| H-06 | Physical independent ram support/restraint and witness | UNKNOWN |
| H-07 | Authorized service override access, tamper control and return-to-service signoff | UNKNOWN |
| H-08 | Personal energy isolation, residual-energy verification and deliberate restart | UNKNOWN |

No numeric pressures, times, valve leakage limits, safety ratings or machine truth tables are inferred for OpenPressBrake. A qualified designer must evaluate actual circuit and manufacturer instructions.

## Adversarial source check

**Misleading premise:** “The manual says a PO check holds loads, and I can see a PO check, so the ram is held.” **Reject:** order code N can deliberately use an R-coded manually bypassed valve.

**Misleading premise:** “A cover makes the valve safety-rated.” **Reject:** cover addresses one foreseeable defeat mode; it does not prove load restraint or fault tolerance.

**Misleading premise:** “Port a is always the push side.” **Reject:** manual's orientation table varies push/pull assignment.

**Misleading premise:** “This Parker example proves every pilot-operated check has an override.” **Reject:** product/edition scope only; selected devices must be inspected.

## Gate and continuation

All findings are **DOC-CONFIRMED** or clearly labeled INFERENCE/UNKNOWN; no TEST-CONFIRMED. Selected-machine IN-01..10 UNKNOWN; PHY-STOP/HOLD/ENERGY/RESTART unproven, VAL/PT NOT RUN, release HOLD. The six remaining historical archive candidates remain pending exact-byte recovery. No GitHub-hosted or self-hosted compute, simulation or physical test was required. Next: acquire actual machine schematic/order code and independently validate physical stop/hold, pilot/override fault paths and service isolation with an approved test plan.
