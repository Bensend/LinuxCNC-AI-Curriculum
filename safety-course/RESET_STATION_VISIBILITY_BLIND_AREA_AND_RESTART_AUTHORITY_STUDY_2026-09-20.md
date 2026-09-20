# Reset-Station Visibility, Blind-Area, and Restart-Authority Study

Date: 2026-09-20
Course: 4000 safety course — independent Lane B
Status: SOURCE/DOC study; no OpenPressBrake-specific safety performance inferred

## Question

When a protective device has stopped hazardous motion, what does authoritative manufacturer guidance require of the human reset/restart station, and what changes when the operator cannot see the complete hazardous area?

## Why this branch

The primary safety lane is currently advancing change-impact/partial revalidation and physical hydraulic/mechanical evidence. This study deliberately stays on a different evidence package: human reset-station placement, visibility, blind-area disposition, and the boundary between protective-device reset and ordinary machine restart.

## Authoritative evidence

### SICK S300 restart interlock

**DOC-CONFIRMED:** SICK's S300 safety laser scanner operating instructions warn that operating restart/reset while a person is in the hazardous area can cause dangerous machine restart. The reset/restart control must be outside the hazardous area, inaccessible from inside it, and positioned so the operator has a full view of the hazardous area.

**DOC-CONFIRMED:** Where both the scanner's internal restart interlock and an external machine restart interlock are used, SICK treats them as separate actions. Resetting the scanner with its field clear switches its OSSDs on, but the external restart interlock still prevents machine restart until the machine-controller restart control is operated.

Source: SICK, *S300 Safety Laser Scanner Operating Instructions*, 8010948/ZD09/2024-09-12, restart-interlock/reset section, accessed 2026-09-20.

Evidence provenance: **DOC-CONFIRMED**.

### Rockwell palletizer functional-safety example

**DOC-CONFIRMED:** Rockwell's palletizer functional-safety reference requires the reset button to be located where the operator can view the entire hazardous area. If the complete accessible hazardous area cannot be viewed from the reset location, Rockwell calls for supplemental safeguarding, giving a trapped-key system as an example.

Source: Rockwell Automation, *Palletizer Functional Safety with relay and configurable relay solution*, SAFETY-RM001, accessed 2026-09-20.

Evidence provenance: **DOC-CONFIRMED**.

### Rockwell safe-speed validation example

**DOC-CONFIRMED:** A Rockwell MSR57P validation example permits a PanelView reset only when the operator has a clear view of the hazard area from that terminal. The same procedure separately instructs the operator to visually verify that the machine is clear and safe and then press Start.

Source: Rockwell Automation, *Simple Safety with Guardmaster MSR57P Speed Monitoring Safety Relay Connected Components Building Block*, CC-QS022B-EN-P, system validation/test chapter, accessed 2026-09-20.

Evidence provenance: **DOC-CONFIRMED**.

### Pilz restart and blind-area evidence

**DOC-CONFIRMED:** Pilz safeguarding guidance states that after a protective field is triggered, clearing the field must not itself automatically restart the machine; reset should be from a control device outside the danger zone with visual contact.

Source: Pilz, *Safety Compendium*, Chapter 4 Safeguards, section 4.3.2.1 Restart, accessed 2026-09-20.

**DOC-CONFIRMED:** Pilz's PSS 4000 Key-in-pocket implementation addresses plants without an overall view by adding a blind-spot check. It describes forcing acknowledgement/visual inspection of difficult-to-see areas before restart and separately tracks whether the personnel safe list is empty.

Source: Pilz, *System release PSS 4000 1.25 — Key-in-pocket solution*, 2023-08-28, accessed 2026-09-20.

Evidence provenance: **DOC-CONFIRMED**.

## Reusable architecture conclusions

The reset station is not merely an HMI convenience. Its physical location is part of the safety argument when reset depends on a human determination that the danger zone is clear.

Freeze:

**PROTECTIVE FIELD CLEAR != HAZARDOUS AREA PERSONNEL-CLEAR.**

Freeze:

**RESET CONTROL ACCESSIBLE != RESET CONTROL SAFELY LOCATED.**

Freeze:

**RESET ACCEPTED / OSSD ON != MACHINE RESTART AUTHORIZED.**

Freeze:

**PARTIAL VIEW OF THE HAZARD AREA != ACCEPTABLE FULL-VIEW RESET BASIS.**

Freeze:

**CAMERA/HMI IMAGE AVAILABLE != AUTHORITATIVE PERSONNEL-CLEAR SAFETY FUNCTION** unless the actual safety architecture and validation explicitly establish that function. No cited source here establishes an ordinary camera or LinuxCNC display as such a safety function.

Where the operator cannot see the whole accessible hazardous area, the answer is not to assume the unseen area is clear. The architecture needs an additional measure appropriate to the application, such as presence sensing, personnel-retention/restart-inhibit, a documented blind-area check sequence, or another validated safeguard.

## Reset versus restart authority chain

A useful machine-level chain is:

`protective demand`
→ `hazardous motion/energy safety response`
→ `protective device becomes clear/healthy`
→ `personnel-clear evidence appropriate to accessible area`
→ `reset/restart-interlock acknowledgement from a valid location`
→ `safety outputs/permissive restored as designed`
→ `ordinary machine still not moving`
→ `separate fresh ordinary START/JOG/CYCLE command`
→ `machine motion`

The exact implementation is machine-specific, but the cited SICK evidence directly supports the important separation between scanner reset and external machine restart.

## LinuxCNC / FPGA boundary

LinuxCNC, HAL, a normal FPGA, or an HMI may display safety status and may implement ordinary command freshness. They must not silently turn a remote touchscreen reset, stale software bit, or ordinary network command into personnel-clear authority when the safety concept depends on a human viewing the hazard area.

A remote reset feature is therefore not acceptable merely because it is convenient or authenticated. Its physical/use context must satisfy the safety architecture. If the reset location cannot establish the required area-clear evidence, add the necessary safeguarding rather than weakening the reset rule.

## Commissioning / adversarial validation worksheet

1. Interrupt the protective device and verify the expected safety response at the actual machine/final elements.
2. Clear the protective device while deliberately leaving a test person/object in an accessible stand-behind or blind area. Clearing the device alone must not grant restart where personnel can remain undetected.
3. From the intended reset station, verify the operator can see every area whose clearance the reset action relies upon.
4. Verify the reset control cannot be operated from inside the hazardous area where the design relies on outside reset.
5. If complete visibility is impossible, challenge the supplemental safeguarding or blind-area-check sequence rather than accepting a visual assumption.
6. Operate reset with the protective device clear. Verify reset restores only the authority specified by the safety design; it must not itself cause hazardous motion where a separate start is required.
7. Hold ordinary START/JOG/CYCLE before or during reset. Verify stale ordinary commands do not become post-reset motion authority.
8. After reset/rearm, require the designed separate fresh ordinary start action and witness the actual machine response.
9. Challenge a failed/stuck reset input and verify the design's required monitored-reset/freshness behavior where applicable; do not infer a universal reset circuit from this study.
10. Revalidate station visibility and supplemental safeguarding after guard, scanner, machine, cell, fence, fixture, or operator-station changes that can create a new blind area.

## Maintenance and modification impact

A reset button can remain electrically unchanged while its safety assumption becomes invalid because the machine, guarding, fixture, fence, stock, tooling, or operator station changed the line of sight. Therefore:

**RESET CIRCUIT UNCHANGED != RESET-STATION VISIBILITY EVIDENCE UNCHANGED.**

This is an **INFERENCE** grounded in the manufacturer requirement that visibility be present at the reset location. A change that alters visibility should trigger review of the personnel-clear/restart-inhibit evidence even when no safety-controller code changed.

## OpenPressBrake boundary / UNKNOWN

This study does not establish:

- whether OpenPressBrake requires a particular reset station or number of stations;
- whether its actual danger zone is fully visible from any candidate location;
- what presence-sensing or personnel-retention technology is required;
- any PL/SIL/category/DC/CCF requirement;
- stopping time/distance, safe speed, hydraulic pressure, valve truth table, or safeguard distance;
- whether any camera or remote HMI can participate in a safety function.

All remain **UNKNOWN** until the real machine layout, hazards, risk assessment, and safety architecture establish them.

## Evidence labels used

- **DOC-CONFIRMED:** manufacturer documentation explicitly supports the claim.
- **INFERENCE:** engineering conclusion bounded by cited evidence.
- **SOURCE-CONFIRMED:** not separately used in this study.
- **TEST-CONFIRMED:** none; no machine test was run.
- **COMMUNITY-REPORTED:** none.
- **UNKNOWN:** machine-specific facts not established by sources.

## Information-gain result and precise next work

The generic reset-location/full-view requirement is now strongly manufacturer-supported. Do not spend another Lane-B pass collecting generic reset-button catalog statements.

Next high-value target: find a complete OEM/manufacturer commissioning procedure for an accessible high-energy machine or cell that deliberately demonstrates **person retained in a blind/stand-behind area → reset/restart inhibited → blind-area/personnel-clear mechanism completed → reset accepted → stale start rejected → separate fresh production start**, with actual final-element/machine response. If public evidence stops at generic visibility guidance, mark this sub-branch source-limited and rotate rather than inventing a machine-specific clear-zone procedure.

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.