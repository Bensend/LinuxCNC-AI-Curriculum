# 4400 — SICK Flexi Soft EDM error reset can request an output switch-on
**2026-10-24 | Manufacturer-indexed excerpt audit, NOT original PDF inspection | NOT SELECTED-MACHINE PROOF**

## Critical question
Is a generic 'clear safety fault' button harmless if the external device monitoring (EDM) feedback indicates a contactor that has not dropped out?

## Exact manufacturer documents found
- SICK *Flexi Soft in Flexi Soft Designer*, operating instructions **8012480/1PUK/2024-11-18**, indexed original manufacturer PDF: https://cdn.sick.com/media/docs/9/59/659/Operating_instructions_Flexi_Soft_in_Flexi_Soft_Designer_Configuration_Software_en_IM0031659.PDF ; manufacturer-indexed extract printed **p. 132**, External Device Monitoring function block.
- SICK *Flexi Soft in the Safety Designer*, **8014519/1KOF/2023-09-08**, indexed manufacturer PDF: https://cdn.sick.com/media/docs/3/83/083/operating_instructions_flexi_soft_in_the_safety_designer_configuration_software_en_im0081083.pdf ; manufacturer-indexed extract printed **p. 109**.

**Provenance limitation:** The web PDF reader could not directly open the original CDN PDFs (DisabledError), although manufacturer-domain search-index text exposed the relevant passages in both documents. Treat the exact wording as **manufacturer-indexed DOC evidence, original-page verification OPEN**; do not claim the PDFs were inspected or that this behavior applies to another firmware/function-block family.

## Manufacturer-indexed behavior
The described EDM function expects feedback opposite to the Control input within configured `T_EDM`. It detects specified unexpected feedback transitions and delayed transitions. Its Error reset input can clear the EDM error on a rising edge when either (a) Control=0, feedback=1 or (b) Control=1, feedback=0. **In the latter case, Output 1 and Output 2 can also become 1.** The manufacturer explicitly warns that this can cause an **undesired switch-on with a defective contactor** and directs users to activate Error reset only when Control=0. The 2024 excerpt specifies Error reset availability for firmware >= V3.00.0; the 2023 Safety Designer excerpt does not support transplanting that qualifier to all products.

This is a more serious and precise statement than the generic slogan 'EDM blocks restart': **fault clearing itself can become an output-enabling event depending on control state and implementation**. A separate independent fresh-cycle start, fault reset preconditions, and actual final-element verification must be engineered for the selected machine.

## Design-review counterexample (INFERENCE; not a wiring prescription)
- A hazardous process has stopped or is supposed to stop.
- One contactor remains mechanically closed; the feedback indicates an abnormal state.
- A maintainer presses a shared HMI 'Reset All Faults' while the EDM block's Control remains 1.
- In the documented SICK function-block condition, the error-reset rising edge can reenable Output 1/2 despite the failed external element.

This is **not** evidence that OpenPressBrake uses Flexi Soft or that any particular valve/contactor energizes there. It demonstrates why safety fault reset and normal control start must not be casually merged.

## Required architecture discriminators
1. Exact installed safety controller, firmware, EDM block, parameter report and original OEM revision.
2. Whether a safety-rated physical reset path or approved safety-controller logic ensures the EDM Control is 0 before Error reset.
3. Whether a reset event can reenable safety outputs and whether a separate normal cycle-start demand is still required.
4. Whether EDM feedback is genuine, contact-type-appropriate, independent of normal PLC/FPGA/HMI simulation and physically linked to the intended final element.
5. Whether brownout, loss of common 0 V, stuck reset, bypassed feedback, welded final element and operator hold-to-run states have been covered by qualified review and physical validation.
6. Whether ram/spindle/robot/load hazards remain controlled even when electrical output states change.

## Claims ledger
| Statement | Evidence | Class |
|---|---|---|
| Documented SICK EDM error reset with Control=1/feedback=0 can enable Output 1/2 | Manufacturer-indexed 2024 p.132 and 2023 p.109 | DOC-CONFIRMED (indexed text only; original PDF not directly opened) |
| Error reset should only be activated when Control=0 | Manufacturer-indexed warnings | DOC-CONFIRMED (indexed only) |
| This exact behavior occurs on any selected OpenPressBrake controller | No as-built evidence | UNKNOWN |
| An ordinary LinuxCNC 'reset all' can safely clear safety faults | No independent safety authorization | UNSUPPORTED / UNKNOWN |

**Action:** do not enable personnel-exposed machine operation from this documentary finding. Physical machine proof, exact controller configuration and independent evaluation remain open. No hosted or local compute was used.
