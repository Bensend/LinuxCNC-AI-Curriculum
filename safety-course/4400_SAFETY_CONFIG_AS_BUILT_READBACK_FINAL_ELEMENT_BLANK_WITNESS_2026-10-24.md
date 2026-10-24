# 4400-CFG-01 — Blank as-built safety configuration and physical-authority witness
**NOT RUN / NOT AUTHORIZED TO ENERGIZE / 2026-10-24**. This is an evidence-intake template, not an executable test plan.

## Qualification and stop condition
Machine identity: **UNKNOWN**. Qualified responsible engineer: **UNASSIGNED**. Hazard-zone access and safe-state definition: **UNKNOWN**. Stop/hold/guard/rearm evidence: **UNKNOWN**. Until completed, **G0/G1 HOLD, G3/G4 NOT AUTHORIZED**. If experimental work is approved separately, use isolated/remote conditions with people outside the danger zone; stored energy and residual risk must be evaluated by qualified personnel.

| ID | Required selected-machine evidence | Actual record | Witness/status |
|---|---|---|---|
| CFG-W01 | Exact safety controller make/model/serial/hardware/firmware and manufacturer manual edition | UNKNOWN | NOT RUN |
| CFG-W02 | Safety I/O modules, expansion, fieldbus and EFI/ACR endpoints with firmware and configured field sets | UNKNOWN | NOT RUN |
| CFG-W03 | Approved safety project version, configuration readback, checksum/signature, scope and verified report | UNKNOWN | NOT RUN |
| CFG-W04 | Separate physical final-element wiring diagram: E-stop/guard/safety input to safety logic to output terminal to contactor/valve/holding element | UNKNOWN | NOT RUN |
| CFG-W05 | Distinguish logic-image output, measured terminal level, monitored auxiliary feedback and final mechanical/hydraulic state | UNKNOWN | NOT RUN |
| CFG-W06 | Program/replacement/download/change history and whether signature/checksum revalidated under exact OEM procedure | UNKNOWN | NOT RUN |
| CFG-W07 | Normal LinuxCNC/FPGA commands and interposing hardware shown unable to defeat independent personnel-safety function | UNKNOWN | NOT RUN |
| CFG-W08 | Independent Y1/Y2 safe stopping and gravity-load holding under each relevant energy/fault state | UNKNOWN | NOT RUN |
| CFG-W09 | Electrical/hydraulic stored-energy isolation and qualified point-of-work verification | UNKNOWN | NOT RUN |
| CFG-W10 | Guard/front/side/rear access, fault detection, reset, deliberate restart and occupied-zone prevention | UNKNOWN | NOT RUN |
| CFG-W11 | Qualified validation records, measurement uncertainty, limitations and revalidation triggers | UNKNOWN | NOT RUN |
| CFG-W12 | Residual-risk and operating restriction signoff; maintenance/guard reinstallation usability | UNKNOWN | NOT RUN |

No real project checksum, machine drawing, firmware or physical measurement has been supplied. Do not fill cells by copying vendor example values. Proprietary as-built data stay in restricted engineering records; the public curriculum may retain only non-identifying conclusions and evidence status.

**Gate decision:** HOLD / no personnel-exposed hazardous operation. Link to [CFG-01 module](4400_CFG_01_SAFETY_CONFIGURATION_IDENTITY_VS_PHYSICAL_PROOF_MODULE_2026-10-24.md) and [source investigation](../research/4400_SAFETY_CONFIGURATION_SIGNATURE_SCOPE_AND_PHYSICAL_OUTPUT_TRUTH_AUDIT_2026-10-24.md).
