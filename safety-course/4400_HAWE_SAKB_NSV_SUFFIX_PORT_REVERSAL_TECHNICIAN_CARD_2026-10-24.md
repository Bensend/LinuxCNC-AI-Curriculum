# 4400 — HAWE SAKB / NSV seal suffix and reversed port technician card

**2026-10-24. Open-book paper-only; not a commissioning test.** Read the [original HAWE D 6335 / D 6368 source audit](../research/4400_HAWE_SAKB_NSV_SEAL_SUFFIX_PORT_REVERSAL_SOURCE_AUDIT_2026-10-24.md).

| Case | Technician's assertion | Required response |
|---|---|---|
| NS-F01 | "SAKB S has five monitored valves, so both cylinder NSVs are monitored too." | **REJECT.** The OEM's five-element list covers the central block, not automatically the separate NSVs. Obtain exact NSV/feedback wiring and physical beam witness. |
| NS-F02 | "The suffix `L` means leak-tight." | **REJECT.** D 6368 p. 6 defines `L` as **without seal, with leakage flow**. No physical hold is proven. |
| NS-F03 | "The NSV is a check valve, so power/pilot loss makes it closed." | **REJECT.** This NSV family is normally open and requires control pressure to close. |
| NS-F04 | "Port A always means the load-pressure port." | **REJECT.** `050` and `060` reverse the A/B pressure/suction assignments. Require exact suffix, as-built drawing and qualified verification. |
| NS-F05 | "The manufacturer's no-`L` zero-leakage catalog entry proves our elevated ram cannot drift." | **REJECT.** Product nominal leakage characteristic is not installed circuit holding, seal condition, cylinder integrity or mechanical restraint proof. |
| NS-F06 | "An ePRAX anti-cavitation valve and a SAKB NSV have the same safe state because both are HAWE." | **REJECT.** The compared product families have different integrated/separate arrangements and documented basic states. |
| NS-F07 | "Pilot pressure table says a certain number, so that's the minimum pressure on our machine." | **REJECT.** OEM values are guide values with omitted force/friction contributions; machine-specific pilot truth and safety acceptance remain UNKNOWN. |
| NS-F08 | "The gauge is zero, so disconnect the A line." | **REJECT.** A/B meaning depends on variant, and one port does not represent every trapped volume. No servicing exposure without full energy-zone verification and physical load restraint. |
| NS-F09 | "We replaced the NSV with a similar flange version; no revalidation needed." | **REJECT.** BA/BE, 050/060, L/sealed and size affect porting and leakage assumptions; invoke `CHG/ARC/DEP/VAL/PT`. |
| NS-F10 | "The HMI green status is enough; the mechanical ram block is inconvenient." | **REJECT.** Redesign access/support so correct safe action is easiest; ordinary status is not physical holding proof. |

For each case identify **exact OEM document/edition/page, product variant, actual feedback target, unproved physical proposition, safe documentary next step, and HOLD gate**. `NS-F01..10` paper-only, `VAL/PT NOT RUN`, selected hardware UNKNOWN. No actual valve actuation, gauge hookup, unrestrained load or exposed live experiment is authorized.
