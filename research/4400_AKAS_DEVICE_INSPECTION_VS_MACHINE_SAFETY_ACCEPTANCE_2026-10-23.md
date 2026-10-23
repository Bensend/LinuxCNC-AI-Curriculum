# 4400 — AKAS device inspection is not machine-level safety acceptance

**Evidence state:** DOC-CONFIRMED manufacturer text and explicitly marked engineering INFERENCE. **No TEST-CONFIRMED result.** Date: 2026-10-23 UTC. **Scope:** Fiessler AKAS-5M operating instructions, document 1581, dated 15 February 2024, especially printed page 43 (PDF page 42), and integration requirements printed pages 24–26. No selected machine, serial number, hydraulic circuit, controller revision or physical witness is available.

## Engineering question

A machine's laser-protection unit passes its device checklist. May a commissioning engineer therefore sign off the press brake's point-of-operation safety function, including box bending and muting?

**No.** The manufacturer states on the inspection sheet that the AKAS functional inspection does not replace the machine's safety inspection. It also states that modifications of the AKAS or machine can impair protection and require inspection again. This is a narrower, stronger finding than the generic warning that a green OSSD is not proof of a safe ram.

## Authoritative source trace

- Fiessler, *AKAS-5M Operating Instructions*, document 1581, 2024-02-15, inspection sheet printed p.43 (PDF p.42), https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf . **DOC-CONFIRMED:** the checklist separates device condition, integration with machine control, and checks of actual work speed, overrun, test-rod response, muting signals, and downstream safety-related control. It explicitly disclaims substituting the device inspection for machine safety checking.
- Same, printed pp.24–26: integration with machine control and separate safety-related speed/position/blanking signals. **DOC-CONFIRMED:** ordinary NC speed request alone is not a substitute for the documented safety-related speed/position conditions.
- Same, printed p.11: box-bending mode changes active receiver coverage; a finger adjacent to a large die can remain undetected. **DOC-CONFIRMED:** selected mode can deliberately remove a portion of protective coverage.
- OSHA, *Guidelines for Point of Operation Guarding of Power Press Brakes*, 1997, https://www.osha.gov/enforcement/directives/cpl-02-01-025 . **DOC-CONFIRMED:** power press-brake guarding is an application-level problem with conditional alternative measures. This document does not endorse an AKAS model, muting setting, universal speed or a specific machine.

## Four-layer acceptance chain

| Layer | What a successful inspection may establish | What remains unproved | Required linked package records |
|---|---|---|---|
| 1. Device | The selected AKAS receiver/transmitter responds under the manufacturer's stated checks. | Safety logic wiring, downstream safety response, actual stop, holding, residual energy. | Product revision and `BND`, `ARC`, `VAL`, `PT` |
| 2. Safety interface | Selected safety controller receives the correct mode/field/speed evidence and withdraws its qualified outputs on the intended demand. | That the physical final element obeyed or the beam stopped. | `SRS`, `AUTH`, `DEP`, `ARC`, `VAL` |
| 3. Final element | Selected contactor/drive/valve feedback supports its *narrow* mechanically/electrically observed proposition. | Complete absence of hazardous motion, trapped pressure or gravity risk. | `PHY`, `DEP`, `ARC`, `VAL`, `UNK` |
| 4. Machine | Independent selected-machine witness establishes the specific required stopping, holding, access and energy proposition for the actual tool/mode. | Blanket validity for other modes, tooling, people, or future modifications. | `BND`, `HAZ`, `SF`, `PHY`, `SRS`, `VAL`, `PT`, `CHG` |

**INFERENCE:** an acceptance form that merges these four layers into a single 'laser tested OK' checkbox can produce a false release. The manufacturer's explicit inspection disclaimer and its separate integration requirements support this failure concern, but the existence of such a defective form at any actual site is UNKNOWN.

## Muting transition proof obligation

For **normal flat**, **partial blanking**, **box mode**, **full muting**, **setup** and **return to normal**, separately document:

1. The exact selected device and manual, receiver elements actually active, tooling/guard reach geometry, operator and helper exposures.
2. The independent safety-related authority for mode selection and for actual speed/position qualification; ordinary LinuxCNC/FPGA is non-authoritative.
3. The output-to-final-element chain, the target of any feedback, common supply/pilot/mechanical dependencies, and residual energy.
4. The *independent* machine-level physical witness and a selected-machine acceptance criterion justified by design/measurement, or `UNKNOWN` if not available.
5. A return-to-normal and retained-command/restart review, and a `CHG`-triggered stale-evidence check after any tool, sensor, receiver, hydraulic, or controller change.

No manufacturer number is copied into a generic acceptance threshold. The manufacturer inspection sheet is a **source for what must be examined**, not an executed PASS record for this machine.

## Causal and adversarial checks — design only, NOT RUN

- **Another safeguard already stopped motion:** an AKAS demand observed while a separate gate is already open does not prove AKAS caused the safety response. Establish causality only in a qualified isolated validation procedure with people outside danger zones.
- **Normal NC speed says slow, independent motion evidence disagrees:** machine `PHY` is NOT ESTABLISHED even if mode, OSSD, and valve feedback appear healthy. Record `VAL=FAIL/BLOCKED`; do not release or rearm from green HMI.
- **Receiver changed to a similar model:** common signal names do not preserve beam/blanking geometry. Create `CHG`, mark relevant `VAL/PT` STALE, verify exact product/revision and full protective-function behavior.
- **Box-mode nuisance trip encourages a bypass:** improve tool alignment, supported mode selection, access and diagnostics. A convenience jumper or ordinary LinuxCNC override is not an alternate safety function.
- **Successful device test, gravity load still moves:** device response is narrow evidence; load holding and hydraulic paths require independent physical witness and design-specific safety control.
- **Muting lamp goes off after setup, but retained ordinary start exists:** lamp state does not prove reset/restart separation or protected space occupancy; verify independent rearm and separate start authorization.

## Disposition

No bench lab is frozen. Public manufacturer documents already settle the device-versus-machine acceptance question. The missing evidence is selected-machine geometry, control architecture, physical stopping/holding, and stored hydraulic energy. These cannot be fabricated by a generic test. Until minimum physical safety propositions are established, no hazardous operation with people exposed; any experimental operation must be isolated/remote with people outside the danger zone and residual risk explicitly assessed.

**Frozen claims:** `DEVICE CHECK PASS != MACHINE SAFETY ACCEPTANCE`; `MUTING ACCEPTED != ORIGINAL PROTECTIVE FIELD PRESENT`; `COMMAND SLOW != ACTUAL SPEED PROVED`; `VALVE FEEDBACK HEALTHY != BEAM SAFE STATE PROVED`; `SAFETY RESET != ORDINARY START`.

## Companion source conflict and non-laser hazards

The same manufacturer document has differing overrun-trigger wording on printed pp.5 and 14 (13 mm versus 11 mm). Both rendered pages were inspected and the intended relationship remains `UNKNOWN`; see `4400_AKAS_OVERTRAVEL_TEXT_CONFLICT_AND_SECONDARY_HAZARD_SCOPE_2026-10-23.md`. Neither number is a generic machine acceptance criterion. The manufacturer also disclaims protection against flying objects, while OSHA identifies moving-workpiece sweep/pinch and foot-control hazards. A device test cannot close those separate `HAZ/PHY/VAL` items.
