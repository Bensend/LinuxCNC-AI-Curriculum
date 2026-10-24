# 4400-RET-01 — Brownfield CNC safety cutover: independent final elements, terminal semantics and physical proof

## Identity and status

- **Level:** 4000 machine-specific safety architecture and integration; **SOURCE-READING / NOT GRADUATED**.
- **Prerequisites:** 2520–25F0 safety foundation; [2530 LinuxCNC software E-stop trace](2530_LINUXCNC_ESTOP_LATCH_BOUNDARY_TRACE_2026-09-22.md); [selected physical witness intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md).
- **LinuxCNC scope:** 2.9 `iocontrol` documentation and pinned `estop_latch.comp` commit `514be4f657b2f1c432ebaaebd117ef112e3e7565`.
- **Original OEM evidence:** Pilz PNOZ m B0 1002660-EN-13 product version 3.3+, Rockwell LVSAM-RM003A-EN-P November 2012; **not** claims of actual OpenPressBrake installation.
- **Verified:** 2026-10-24 documentary research. **No** fresh independent exam, source runtime, physical test or selected-machine safety release.

## Learning objective

A competent AI or technician can audit a proposed replacement of an old CNC with LinuxCNC and ordinary FPGA while **retaining an independent safety controller**. They must trace every protective function to an actual final element and physical witness, distinguish safety outputs from standard diagnostics and test-pulse wiring, detect invalidated stop/hold evidence after coil/cable/project changes, and prevent reset/restart and service-isolation shortcuts.

## Three engineering questions answered from authoritative evidence

1. **Does retaining the old safety PLC prove the safety functions remain?** No. A PLC can be healthy while its outputs are no longer wired to independently withdraw hazardous energy. This is a **source-informed engineering inference**; actual machine proof requires as-built final-element and physical witnesses.
2. **Can any 24 V output replace a safe output?** No. Pilz's original PNOZ m B0 manual distinguishes safety `O0..O3`, standard auxiliary `IM*`, and `T0..T3` test-pulse outputs, explicitly prohibiting standard I/O for safety-related use. Those terminal names and pulse figures apply **only** to that OEM model/version.
3. **Can an open control contact be taken as a physically open contactor?** Not universally. Rockwell's original guide documents DC coil suppression affecting drop-out and an **AC long-line capacitance** case where an opened control contact can leave the contactor energized. The latter is not a universal DC-coil claim or a selected-machine observation.

## Required source and engineering artifacts

| Read | Evidence to extract | Classification |
|---|---|---|
| [OSHA/Pilz/LinuxCNC retrofit source audit](../research/4400_BROWNFIELD_CNC_RETROFIT_SAFETY_PLC_CUTOVER_AND_LOCKABLE_ISOLATION_AUDIT_2026-10-24.md) | OSHA 1910.147(c)(2)(iii) conditional lockable-isolator trigger; LinuxCNC software latch versus independent physical safety; commercial retrofit scope | DOC/SOURCE-CONFIRMED, transfer INFERENCE |
| [Pilz exact output-role source audit](../research/4400_PILZ_PNOZ_MB0_SAFE_VS_AUX_OUTPUT_TEST_PULSE_CUTOVER_SOURCE_AUDIT_2026-10-24.md) | Manufacturer standard-I/O exclusion, safe/aux/test-pulse role, p.29 feedback prerequisites, p.30 revalidation, p.45 pulse distinctions | DOC-CONFIRMED only for exact OEM |
| [Rockwell coil/cable source audit](../research/4400_ROCKWELL_COIL_SUPPRESSION_LONG_CABLE_FALSE_HOLD_RETROFIT_AUDIT_2026-10-24.md) | DC suppression drop-out effect, AC long-line capacitance false hold, contactor feedback limitations | DOC-CONFIRMED OEM examples |
| [12-case cutover card](4400_RETAINED_SAFETY_PLC_RETROFIT_CUTOVER_TECHNICIAN_CARD_2026-10-24.md) | Trace missing physical authority and reset/start | PAPER ONLY |
| [10-case output substitution card](4400_SAFETY_OUTPUT_AUXILIARY_TEST_PULSE_SUBSTITUTION_FIELD_CARD_2026-10-24.md) | Reject standard status/test-pulse substitutions | PAPER ONLY |
| [8-case coil/cable card](4400_CONTACTOR_COIL_CABLE_CAPACITANCE_AND_DROPOUT_TECHNICIAN_CARD_2026-10-24.md) | Reject commanded-OFF = physically-open and unjustified timing transfer | PAPER ONLY |
| [Blank before/after cutover worksheet](4400_CNC_RETROFIT_SAFETY_FUNCTION_CONTINUITY_AND_ISOLATION_WORKSHEET_2026-10-24.md) | Actual per-function old/new `BND/ENE/AUTH/ARC/DEP/PHY/VAL/PT/CHG` and isolation gates | TEMPLATE, selected UNKNOWN |

## Four separate architectural paths

**Normal control:** `operator → LinuxCNC/HAL → FPGA → normal motion command`.

**Safety-related:** `guard/E-stop/protective sensor → qualified independent safety logic → suitable independent safety final element → actual physical stop/hold/energy response`.

**Diagnostics:** `safety controller status → ordinary HMI/record`; no reverse safety authority implied.

**Maintenance:** `physically lockable isolator(s) → stored-energy controls/ram restraint → independent verification → qualified service`.

A green HMI/PLC/FPGA status can be useful information, but is not a substitute for the second or fourth paths. Actual safety PLC model, hydraulic architecture, stopping and holding remain **UNKNOWN**.

## Learning sequence

**A — Source reading.** Locate the exact manufacturer version and show why PNOZ safe output, auxiliary output and test pulse are different; why the Rockwell AC cable example is not automatically a DC case; why LinuxCNC software reset is not physical safety reset; and why OSHA lockable-isolator trigger must be applied to actual modification facts.

**B — Before/after trace.** Use the blank worksheet for a fictional retrofit with an old CNC acknowledgement, a retained PLC, a new FPGA and a modified coil harness. Mark all affected safety functions and old validation as `STALE` until independent evidence.

**C — Human factors.** Redesign the cabinet so safe/aux/test-pulse terminals are physically and visually distinct, guard restoration is quick, correct suppressor parts are easy to identify, and deliberate local reset cannot be mistaken for production START.

**D — Adversarial review.** Work 30 cases from the three cards. The correct action is often **HOLD** and a precise missing-evidence request, not a guessed fix.

**E — Fresh handoff (NOT YET RUN).** Give an independent AI a *new* mixed-mill/press-cell scenario: a replacement CNC is connected to a retained safety PLC, a standard auxiliary output is labeled SAFE, a DC contactor suppressor changes, and the safety reset coincides with a retained cycle request. Require a function-by-function source-qualified hazard trace and a safe documentary verification plan without numerical invention. Do not supply a model answer in the handoff; have a separate evaluator score evidence classes, wrong-model transfer, final-element authority and physical/LOTO boundaries.

## Prediction check — OPEN, not post-hoc evidence

Predeclare for future **documentary** handoff: a fresh evaluator that treats the PNOZ `IM` auxiliary output as a safety output, Rockwell AC long-line false-hold as universal DC behavior, or LinuxCNC `user-request-enable` as independent safety reset must fail the source-scope gate. **No independent prediction test has been performed.** Do not count the authored paper scenarios as independent evaluation.

## Open uncertainty / no simulation justification

| Unresolved item | Consequence | Needed evidence | Status |
|---|---|---|---|
| Actual old/new selected safety PLC, FPGA, relay/valve wiring | Could invalidate all machine stop/hold claims | Restricted as-built drawings, model/revision/config and independent reviewer | UNKNOWN, release-blocking |
| Actual final-element response and gravity/hydraulic holding | Personnel hazard persists even with PLC STOP | Qualified machine-specific physical witness | UNKNOWN, G3/G4 NOT AUTHORIZED |
| Exact coil, cable, suppressor and receiver | Wrong model/pulse or stop-time transfer | Exact installed part manuals and harness/terminal maps | UNKNOWN |
| Fresh-AI evaluation | Module competency not established | Independent novel scenario and scored feedback | NOT RUN |
| OSHA major-modification applicability | Service isolator design obligations may change | Actual scope/jurisdiction and qualified review | OPEN |

No simulation can resolve an absent physical final element, unknown old/new wiring, or an uninspected hydraulic system. If a specific source/configuration question later cannot be resolved by documents, freeze a **bounded, question-driven** lab only on the authorized local self-hosted OpenPressBrake runner; do not use hosted minutes. No machine test is authorized here.

## Counterfactual and graduation decision

If the selected PLC is a completely different model, the **specific** PNOZ pulse numbers and terminals must not transfer, but the **general** requirement to identify the actual output role and final-element authority survives. If Rockwell's AC cable mechanism is irrelevant to the selected DC coil, the need to verify the actual coil/suppressor and physical dropout still survives. If the selected retrofit has no safety PLC, the retained-PLC premise becomes NOT APPLICABLE and the independent safety-function design must be established from scratch. None of these possibilities permits machine release by source reading alone.

**Graduation:** **NOT GRADUATED**. Source-reading evidence is substantial; independent fresh handoff, exact selected-machine validation and competent safety review remain open. Do not self-award a passing score. Minimum safe-to-operate threshold is not established; no personnel-exposed hazardous operation. Experimental operation, if justified later, must be isolated/remote with all people outside the danger zone and residual risk stated plainly.
