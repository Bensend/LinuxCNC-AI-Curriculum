# Safety Replacement-Part Equivalence / Substitution Worksheet

## Purpose

Use this worksheet when replacing or substituting any component that participates in a personnel-safety function, protective device, hazardous-energy interruption path, feedback/EDM path, or physical safeguard.

**Frozen rule:** `same voltage/current/connector/shape` does **not** establish safety equivalence. Replacement acceptance follows the safety function and its dependencies, not superficial fit.

This is an architecture and evidence worksheet. It does not assign a PL/SIL/category, stopping distance, hydraulic pressure, response time, proof-test interval, or other machine-specific fact without authoritative documentation or measurement.

## Evidence labels

- `SOURCE-CONFIRMED` — directly supported by authoritative source material.
- `DOC-CONFIRMED` — confirmed by the actual machine/device drawings, manuals, BOM, approved change record, or retained configuration package.
- `TEST-CONFIRMED` — demonstrated on the actual relevant configuration by a bounded physical test.
- `COMMUNITY-REPORTED` — reported by community experience but not independently established.
- `INFERENCE` — engineering conclusion whose premises are stated.
- `UNKNOWN` — not yet established; never silently promote this to fact.

## Replacement classes

### A — Exact replacement

Same manufacturer and exact ordered part/revision where the manufacturer and machine documentation permit that revision.

This is the strongest starting case, but **not automatic proof of restored function**. Installation, wiring, configuration, alignment, calibration, feedback, mechanical coupling, and final-element behavior can still be wrong.

### B — Manufacturer-approved successor

A manufacturer explicitly identifies a successor/replacement and states the relevant compatibility or migration conditions.

Record every condition. A successor that requires changed firmware, parameters, wiring, reset behavior, response characteristics, mounting, diagnostics, or validation is a change-impact case rather than an invisible swap.

### C — Engineered equivalent

Not the exact device or an explicitly approved successor, but an engineering review establishes equivalence for **every safety-relevant dependency actually used by this machine** and a revalidation plan proves the affected physical safety function.

“Equivalent” is a conclusion, not a catalog adjective.

### D — Similar / fit-compatible substitute

Matches some convenient characteristics — voltage, current, coil resistance, connector, footprint, pole count, thread, pressure port, optical range, or package — but safety equivalence has not been established.

**Default disposition: `UNKNOWN / DO NOT TREAT AS SAFETY-EQUIVALENT`.**

## Claim-first replacement record

| Field | Record |
|---|---|
| Machine / configuration identity | |
| Safety function(s) affected | |
| Hazard boundary controlled | |
| Original manufacturer / exact MPN / revision | |
| Proposed replacement manufacturer / exact MPN / revision | |
| Replacement class A/B/C/D | |
| Why replacement is needed | |
| Authoritative replacement/successor statement | |
| Drawings/BOM/configuration affected | |
| Required physical revalidation | |
| Evidence retained | |
| Unresolved UNKNOWNs | |
| Return-to-service decision and authority | |

## Dependency comparison matrix

Mark each row `MATCH`, `CHANGED`, `NOT USED`, or `UNKNOWN`, and attach evidence.

| Dependency | Original | Replacement | Status | Evidence / consequence |
|---|---|---|---|---|
| Intended safety function / device role | | | | |
| Manufacturer-approved use/application constraints | | | | |
| Supply voltage and tolerances | | | | |
| Output/load electrical rating | | | | |
| Contact/output architecture | | | | |
| Positive-guided / force-guided contact requirement, if used | | | | |
| EDM / auxiliary feedback behavior | | | | |
| De-energized / fault state | | | | |
| Restart/reset behavior | | | | |
| Input test-pulse compatibility | | | | |
| OSSD / safety-output compatibility | | | | |
| Short/cross-fault diagnostics relied upon | | | | |
| Response / release behavior relevant to validated stop chain | | | | |
| Required safety-controller configuration | | | | |
| Firmware / device revision dependency | | | | |
| Network/device identity dependency | | | | |
| Connector pinout and keying | | | | |
| Cable/shield/ground requirements | | | | |
| Mechanical mounting / actuator geometry | | | | |
| Guard-switch defeat resistance / coded target pairing | | | | |
| Environmental rating relevant to installation | | | | |
| Temperature / contamination / vibration constraints | | | | |
| Hydraulic/pneumatic port/function compatibility, if applicable | | | | |
| Flow direction / center state / spring return, if applicable | | | | |
| Monitored valve/spool feedback, if applicable | | | | |
| Brake/contactor mechanical interface, if applicable | | | | |
| Calibration / teach / alignment metadata | | | | |
| Diagnostic indications available to maintenance | | | | |
| Required inspection/proof-test instructions | | | | |

A single `UNKNOWN` on a dependency that can defeat the safety function blocks an equivalence claim until resolved.

## Failure-path prompts

### “The coil is 24 V, so it is equivalent.”

Reject. Coil voltage alone says nothing about valve function, center state, spring return, flow direction, monitored position, switching behavior, connector pinout, environmental limits, or the machine's hydraulic safety architecture. For OpenPressBrake, do not infer a hydraulic truth table from coil ratings.

### “The contactor has the same current rating.”

Reject. Check pole/contact arrangement, coil/control behavior, auxiliary/EDM contacts actually relied upon, mechanically linked/force-guided properties where required, short-circuit coordination and the validated final-element architecture. A normal power contactor with convenient auxiliary contacts is not automatically interchangeable with a monitored safety final element.

### “The guard switch bolts into the same holes.”

Reject. Mounting fit does not establish actuation geometry, coding/pairing, defeat resistance, diagnostic behavior, output architecture, fault detection, response behavior, or compatibility with the safety controller.

### “The light curtain has the same protective height.”

Reject. Protective height alone does not establish resolution, range, blanking/muting behavior, OSSD interface, response characteristics, restart interlock behavior, mounting/alignment, safety-controller compatibility, or the existing validated separation-distance basis.

### “The drive supports STO too.”

Reject. The label `STO` does not establish identical terminals, channel architecture, test-pulse behavior, timing, diagnostics, reset behavior, firmware/configuration, external contactor/brake dependencies, or suitability for the machine's validated safety function.

### “The replacement safety relay has more features.”

Reject feature-count reasoning. More features can introduce different reset semantics, input test behavior, feedback monitoring, timing, configuration, or failure modes. Trace the exact used function end-to-end.

## Change-impact boundary

For each changed or unknown dependency, identify which previous evidence survives.

| Prior evidence | Survives unchanged? | Why / why not? | Required re-challenge |
|---|---|---|---|
| Hazard analysis / function requirement | | | |
| Wiring/document review | | | |
| Configuration/signature identity | | | |
| Input protective-device challenge | | | |
| Safety-logic response | | | |
| Final-element interruption/control | | | |
| Independent physical hazard observation | | | |
| EDM/feedback diagnostics | | | |
| Reset/restart/rearm test | | | |
| Fault-injection / discrepancy test | | | |
| Maintenance isolation verification | | | |

Do not automatically discard unrelated evidence, but do not preserve evidence whose dependency changed.

## Physical revalidation sequence

1. Control hazardous energy for the replacement work according to the actual task hazards.
2. Record original and replacement identities before installation.
3. Update affected drawings/BOM/configuration/change record.
4. Inspect wiring, mounting, coupling, alignment, plumbing and configuration against authoritative requirements.
5. Remove all temporary jumpers, forces, test plugs and bypasses used during service.
6. Challenge the **actual protective device or demand path** where practical; do not substitute a forced software bit for a physical-path test.
7. Observe the safety logic and the relevant final element independently enough to support the claim.
8. Verify feedback/EDM and diagnostic behavior relied upon by the architecture.
9. Verify reset/restart/rearm behavior; restoration of the protective device must not silently prove permission for hazardous restart.
10. Re-challenge changed fault-detection paths where the substitution changed diagnostics or channel behavior.
11. Preserve raw observations and configuration identity with the result.
12. Return to service only when unresolved `UNKNOWN`s cannot defeat the claimed safety function.

## Human-factors / maintenance rules

- Make the approved replacement obvious in the BOM and service documentation.
- Do not let an unlabeled “works electrically” spare become the de facto safety spare.
- Store safety-critical spares with exact identity and revision visible.
- If an emergency substitute is necessary to recover production, the machine remains out of personnel-exposed operation until the safety-equivalence case and required validation are complete.
- Prefer replacements that preserve simple, inspectable, maintainable architecture over substitutions that require technicians to remember undocumented exceptions.
- A bypass used to diagnose the failed component is not part of the replacement and must not survive return to service.

## Source notes

### OSHA machine-system / repair boundary — `SOURCE-CONFIRMED`

OSHA's mechanical-power-press safety material treats a press as an integrated system including mechanical, electrical/electronic, hydraulic, pneumatic, tooling and safeguarding elements; worn, damaged or incorrectly operating parts are to be repaired or replaced before use. This supports evaluating a replacement in the machine-system context rather than by one nameplate value.

Source: OSHA, *Mechanical Power Presses — Press Safety Considerations*, accessed 2026-09-16.

### OSHA maintenance / restoration boundary — `SOURCE-CONFIRMED`

OSHA machine-guarding guidance requires hazardous-energy control when safeguards must be removed for servicing and, before return to service, inspection that guards and other safety devices are in place and functional. OSHA's LOTO standard also requires the machine/equipment to be operationally intact before energy is restored.

Sources: OSHA, *Machine Guarding — Additional Safety Considerations*; 29 CFR 1910.147(e), accessed 2026-09-16.

### Interlock behavior — `SOURCE-CONFIRMED`

OSHA describes an interlocked guard as stopping/disengaging hazardous operation when opened and states that replacing the guard should not automatically restart the machine. This is a useful bounded behavioral check after guard/interlock replacement; it does not establish a machine-specific stopping distance or safety performance level.

Source: OSHA, *Machine Guarding — Guards*, accessed 2026-09-16.

## OpenPressBrake boundary

Ordinary LinuxCNC, HAL, UI logic, general-purpose FPGA logic, telemetry, and normal actuator commands may report or coordinate machine state but do not become personnel-safety authority because a replacement device can connect to them. Replacement work must preserve the independent safety-function boundary and independently validate the physical path actually relied upon for personnel protection.

## Completion gate

A replacement is not closed merely because the machine runs. Close only when:

- replacement identity and class are recorded;
- every safety-relevant changed/unknown dependency is resolved or explicitly blocks return to service;
- affected documentation/configuration is updated;
- the affected physical safety function is re-challenged to the justified extent;
- reset/restart/rearm and relied-upon diagnostics are checked;
- temporary service defeats are removed;
- retained evidence is claim-bounded and provenance-labeled; and
- machine-specific facts that were not measured/documented remain `UNKNOWN`.

## Precise next independent work

Build a **safety spare-parts / obsolescence lifecycle worksheet**: approved spare identity, revision control, storage aging/environment, periodic inventory, manufacturer discontinuance, successor qualification, firmware/configuration dependencies, cannibalized parts, counterfeit/unknown provenance, and what evidence must be repeated when an old spare is finally installed. Keep it independent of the primary lane's OEM wiring/hydraulic tracing.