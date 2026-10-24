# 4400 — Leuze Smart Process Gating and multi-lane dynamic field selection: inspectable industrial implementations
**2026-10-24 | Original source study / OEM-reported implementations, NOT independently tested.**

## Engineering question
When material must pass a guarded opening, are more sensors and permissive muting always the most practical choice? What happens when five adjacent conveyor lanes make it possible to follow a pallet through an *unrelated* lane?

## Manufacturer source register and evidence classification
- **DOC-CONFIRMED OEM-published case account:** Leuze, [Südzucker five-track conveyor protection case](https://www.leuze.com/en-us/blog/detail/af674ca7f01f4c008f0a68a127ac04c5). Leuze reports that conventional shared muting would allow access beside an outgoing pallet on an adjacent conveyor, and that individual parallel muting/SPG paths could not fit. It describes two **vertical RSL 400** safety laser scanners, compact safety controls, pallet track/position selection and two-channel safety outputs. This is a manufacturer **reported implementation**, not independent TEST-CONFIRMED performance.
- **DOC-CONFIRMED OEM-published application:** Leuze, [WITRON Smart Process Gating](https://www.leuze.com/tr-tr/blog/detail/93353337efc24bf6933e51a61ed1668b). The described MLC 530 SPG method uses **one PLC process signal plus interruption of the light curtain** as the gating pair, eliminating extra muting sensors, but requires controlled flow and qualified system integration. The case report states a product/system capability for PL d with standard control; this is **not** a safety level assigned to any other machine.
- **DOC-CONFIRMED OEM-published integration warning:** Leuze, [rolling-gate SPG installation](https://www.leuze.com/en-au/blog/detail/86121ebda8b44b3c9a35a2e75fea64c). Manufacturer account states that the gating sequence must be programmed in PLC and that safety outcome is a **system solution** dependent on light curtain, process control and potentially mechanical elements.
- **DOC-CONFIRMED OEM-published field report:** Leuze, [SEW-EURODRIVE/SIVAplan intralogistics](https://www.leuze.com/en-int/industries/intralogistics/sew-eurodrive-and-sivaplan), describes independent scanner field adaptations around mobile robots and MLC 530 SPG material stations; this is a vendor case study, not access to its actual source code or validation dossier.
- **DOC-CONFIRMED original comparator:** SICK deTec4 HG [8023856/1SWC/2026-02-05](https://www.sick.com/media/docs/5/75/275/operating_instructions_detec4_hg_en_im0082275.pdf) p42 requires at least two independent muting signals and not exclusively PLC software; p61–71 documents alternative Smart Box Detection and its **non-monitoring Override**. Different certified products, different architectures.

## Important reconciliation — not a standards contradiction
Leuze SPG's *first* signal from ordinary process control does **not** establish that ordinary PLC/FPGA is personnel-safety authority: its second discriminator is a safety light curtain, and the overall system must be evaluated for its exact device, sequencing, geometry and final elements. Conversely, SICK deTec4 HG's 'not entirely software' muting requirement does not prohibit all process-derived supplementary signals in all qualified designs. **INFERENCE:** translating either OEM-specific pattern into an ad hoc LinuxCNC HAL bypass is unjustified. Require device-qualified implementation, independent stop/hold, monitored diagnostics and deliberate restart.

## Failure-path adversarial review
**Case A — five lanes with one global mute:** A pallet exits lane 2 while a person approaches lane 4; the whole opening is bypassed. A sensor count and valid lane-2 sequence do not prevent side entry. **Candidate control:** separate bounded protective field for only the active passage and physically guard gaps; verify transitions before exposure, not merely correct eventual field selection.

**Case B — PLC process bit sticks active in SPG:** The qualified safety curtain and its exact SPG sequence must reject unauthorized human entry and fault as designed; do not infer that it will from marketing text. Ask for the exact OEM installation/validation manual and inspect controller input source, safety controller final elements, reset/restart, occupancy and fault response.

**Case C — scanner field switches late:** The PLC reports lane change after material reaches the opening. A field configuration that becomes effective too late cannot protect the opening during the transition. The selected safety controller must qualify the timing and alternate approach paths; do not invent a reaction time.

**Case D — a pallet straddles two lanes or is wider than expected:** Field selection by nominal lane ID can leave an unprotected gap. Require actual pallet envelope, sensor coverage and physical side guarding.

**Case E — human factors:** Constant false trips on damaged pallets tempt operators to jumper sensors or keep overrides engaged. Rework lane geometry and recoverability rather than normalize bypass.

## Decision matrix — questions, not approvals
| Candidate | Potential practical advantage | Critical failure question |
|---|---|---|
| Fixed gates/interlocks and isolated transfer | Obvious physical boundary, often low defeat incentive | Can material transfer occur without a person-access gap? |
| Four-sensor muting per lane | Established product-specific sequencing | Can a person reproduce sequence, follow pallet or enter another lane? |
| Leuze SPG | Compact, fewer alignment-prone sensors | Are PLC+ESPE sequence, geometry and downstream safety actually qualified? |
| SICK SBD/OPR | Shape/sequence discrimination without general muting | Can person/body/box be classified as valid; what happens in Override? |
| Dynamic scanner field via qualified safety controller | Flexible lane-specific opening | Is the correct field effective before exposure, with no hidden adjacent access? |

## Provenance and limits
**DOC-CONFIRMED:** what OEM reports and what SICK manual says. **COMMUNITY-REPORTED:** none used. **SOURCE-CONFIRMED:** no installation source/config examined. **TEST-CONFIRMED:** none. **INFERENCE:** comparative failure paths and candidate design selection. **UNKNOWN:** independent acceptance tests, exact Leuze controller program, real stop/hold, actual safety performance, exact standard clauses, OpenPressBrake applicability. No selected OpenPressBrake multi-lane conveyor claimed. No physical/hosted/local tests or personnel-exposed operation.

## Next information gain
If selected system actually uses multi-lane material passage, obtain as-built lane/sensor geometry, approved safety controller configuration, scanner effective-field transition timing, physical final elements, qualified stop/hold, occupancy and fresh-start evidence. Otherwise retain as cross-machine transferable research and prioritize actual OpenPressBrake Y1/Y2 hazard evidence. No speculative simulation needed.
