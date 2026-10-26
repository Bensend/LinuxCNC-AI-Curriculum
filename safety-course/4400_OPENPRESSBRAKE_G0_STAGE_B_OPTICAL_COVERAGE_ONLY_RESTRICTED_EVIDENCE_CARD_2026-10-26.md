# OpenPressBrake G0 Stage B — optical safeguarding evidence card

**2026-10-26 | CONDITIONAL, RESTRICTED DOCUMENTARY HANDOFF | NO TEST / NO SAFETY RELEASE**

**When to use:** Only after the qualified Stage A [one-page A–G request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) identifies a safety light curtain, point-of-operation optical guard, scanner or another electro-sensitive protective device. **Do not assume an ESPE is installed.** If a particular optical type is absent, mark that *conditional type* N/A only with dated as-built evidence; essential guarding, stop, hold, access and restart requirements cannot be marked N/A by convenience.

## Restricted evidence to collect from existing records (no energized testing)

| Item | Qualified review question / existing evidence | Public state |
|---|---|---|
| O1 | Machine/retrofit and ESPE exact type plate, manufacturer, part number, firmware/edition, selected protective mode | UNKNOWN |
| O2 | Dated layout showing emitter, receiver, protected field, mounts, cable-end orientation, mirrors and hazard boundary | UNKNOWN |
| O3 | Which front, rear, side, under, over, around and behind access paths are physically blocked or separately protected? | UNKNOWN |
| O4 | Foreseeable polished dies/sheets, reflective workpieces, floor/paint, racks, bins and moving tooling envelopes | UNKNOWN |
| O5 | Exact OEM minimum reflective clearance for the selected model and measured/as-built D, with no cross-product formula reuse | UNKNOWN |
| O6 | Nearby emitters/receivers, optical crosstalk mitigation, beam coding, mirror legs and exact OEM restrictions | UNKNOWN |
| O7 | Each OSSD pair's separate safety input owner, qualified receiver, diagnostic pulse/filter behavior and total response-time assumptions | UNKNOWN |
| O8 | Existing OEM-specific test-piece/trip-check plan, near sender/midpoint/receiver and each mirror leg where applicable; actual qualified records separately | UNKNOWN |
| O9 | Independent final elements and physical Y1/Y2 stopping, gravity holding and stored-energy isolation witnesses; optical check alone does not prove them | UNKNOWN |
| O10 | Change/revalidation record for material, die, sensor, bracket, paint, optical neighbor, firmware or filter, plus local reset/escape/restart | UNKNOWN |

## Reviewer acceptance logic

1. **Documentary readiness is not optical validation.** A drawing, OEM formula or green HMI does not establish coverage. If geometry/identity is unknown or contradictory, HOLD the affected safeguard.
2. **Do not substitute device families.** SICK C4000 Select 2016 and senSe2 2022 have different published reflection-clearance formulas. Those published examples are not OpenPressBrake dimensions.
3. **No ad hoc OSSD splices or ordinary software safety authority.** Banner SLC4 prohibits paralleling OSSD outputs from different pairs; qualified safety input/controller integration is separate from LinuxCNC/FPGA diagnostics. OEM-supported safety-controller pulse filtering can alter the reaction-time budget.
4. **Physical machine proof remains independent.** Even an effective curtain cannot by itself establish Y1/Y2 stopping, gravity load holding, hydraulic isolation, maintenance LOTO, escape or fresh motion authorization.
5. **Human factors are part of the design.** Store shiny stock outside the optical corridor, retain easy-to-align brackets and the correct test piece, and make protective devices easier to use correctly than to bypass.

## Release / confidentiality

Collect actual photos, drawings, product labels, configuration, acceptance records and qualified reviewer decisions **privately**. Publish only redacted status IDs and whether each item is UNKNOWN, RECEIVED/UNREVIEWED, REVIEWED/IN-SCOPE, CONTRADICTORY, STALE or N/A WITH PROOF. No terminal wiring, site details, proprietary machine geometry or test instructions in this public card.

**G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** If the minimum protective design is unproven, no personnel-exposed hazardous operation. A qualified isolated/remote physical witness can be planned only after separate risk controls; this document authorizes none.

## Source basis and provenance

[Banner SLC4 / SICK C4000 Select / SICK senSe2 optical OEM audit](../research/4400_ESPE_OPTICAL_FALSE_CLEAR_REFLECTION_CROSSTALK_VARIANT_OEM_AUDIT_2026-10-26.md); [practical field module](4400_ESPE_OPT_01_REFLECTIVE_STOCK_OPTICAL_FALSE_CLEAR_AND_REARM_FIELD_MODULE_2026-10-26.md); [one-screen G0 evidence board](4400_G0_BOARD_01_ONE_SCREEN_RESTRICTED_EVIDENCE_STATUS_TEMPLATE_2026-10-26.md). **DOC-CONFIRMED** only for examined OEM manuals; **INFERENCE** this staged intake reduces burden; **TEST-CONFIRMED** no physical or adoption test; **UNKNOWN** selected OpenPressBrake optical equipment and physical proof. No hosted/local compute.
