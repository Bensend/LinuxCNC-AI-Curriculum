# 4400 — Safety configuration identity is not physical safety proof
**2026-10-24 | Original manufacturer-source investigation | SOURCE-READING, NOT GRADUATED | No selected-machine test**

## Engineering question
After a LinuxCNC/FPGA retrofit or maintenance replacement, which evidence proves that the **intended independent safety program** is loaded, which evidence only identifies some of its configuration, and which evidence is still required to establish that hazardous energy is actually removed or retained safely? In particular, can a matching safety checksum/signature, a yellow verified LED, or a networked output bit be treated as proof of physical final-element operation? **No**. These signals have different scopes and do not substitute for the as-built chain and physical validation.

## Directly inspected manufacturer evidence

**S1 — SICK Flexi Soft Gateways in Safety Designer**, original SICK operating instructions 8018172/1KOF/2023-09-08, pp. 109–115 (PDF pages 109–115 in print pagination), [manufacturer PDF](https://www.sick.com/media/docs/4/84/084/operating_instructions_flexi_soft_gateways_in_the_safety_designer_configuration_software_en_im0081084.pdf). **DOC-CONFIRMED**:
- Section 5.1.5 p.113: network input **data set 2** carries 4-byte total, Flexi Soft and verified Flexi Soft checksums. Its defined verification compares the Safety Designer configuration checksum against the configuration in the device; the CV indicator can illuminate yellow after this check. This is a **configuration verification statement**, not a stopping-performance test.
- Section 5.1.3 p.112: **networked output values show logic control information**, not guaranteed physical output terminal levels. A terminal may be disabled by cross-circuit or overload detection while the reported logic value retains its commanded status. A diagnostic viewer that displays an ON logic result therefore cannot certify energization of a contactor or state of an isolation valve.
- Section 5.1.6 p.113: module-status bytes contain error/diagnostic flags; absent module positions can be all logical 1, and reserved bits are static 1. Therefore a raw all-ones word is **not** universal healthy-device proof. Exact bit interpretation and physical module inventory matter.
- Section 5.1.1/5.1.2 pp.111–112: separate logic results, direct input and output values, and diagnostic status. They are not interchangeable.
- The **2023 Safety Designer gateway** document says its *total checksum equals Flexi Soft checksum*. It must not be generalized to older Designer/ACR configurations with different checksum scope.

**S2 — SICK Flexi Soft Designer basic online help**, original SICK 8014174/2015-02-02, p.25, [manufacturer PDF](https://www.sick.com/media/docs/0/20/120/online_help_software_flexi_soft_designer_en_im0040120.pdf). **DOC-CONFIRMED**: after transfer, the downloaded data are read back and compared with project data; the operator must inspect the generated report and explicitly confirm it. Verification is a deliberate human acceptance of *configuration*, not a physical safeguard proof.

**S3 — SICK Flexi Soft in Flexi Soft Designer**, SICK 8012480 (manufacturer-indexed text; the approximately 15 MB original PDF could not be opened fully with the available web reader), [manufacturer PDF](https://www.sick.com/media/docs/9/59/659/operating_instructions_flexi_soft_in_flexi_soft_designer_configuration_software_en_im0031659.pdf). **DOC-CONFIRMED from indexed manufacturer excerpts ONLY, not directly inspected full original**: section 16.5 states that the Flexi Soft checksum excludes the firmware/hardware version and the configurations of connected EFI-enabled devices; ACR, when enabled, has its own checksum, and total-checksum composition varies. This is a **specific older Flexi Soft Designer variant**, not a universal claim about Safety Designer or other manufacturers. Confirm exact edition and configuration before using it.

**R1 — Rockwell GuardLogix 5580/Compact GuardLogix 5580 Safety Applications: Generate the Safety Signature**, official online manufacturer documentation, retrieved 2026-10-24, [manufacturer page](https://www.rockwellautomation.com/en-ua/docs/technical/logix5000/_online/1756-rm012/guardlogix-5580-and-compact-guardlogix-5580-safety/safety-applications/commissioning-lifecycle/generate-the-safety-signature.html). **DOC-CONFIRMED**:
- The safety signature ID and timestamp identify the safety portion including logic, constants and configuration. For the documented controller family, a safety signature is required for rated SIL 2/SIL 3 operation; without it, use is development-only.
- The manufacturer requires recording the signature after validation and checking it **after every download**, including when only the standard application changes. A signed safety portion can remain unchanged while other machine behavior and interfaces change.
- Deleting the signature impacts safety functions and requires retest/revalidation to the extent necessary. Safety-lock status and signature are separate attributes; neither proves field wiring or physical stopping.
- The page describes firmware-revision-dependent modes for generating the signature (revision 38 versus 37 and earlier). Do not copy the mode rule to an unidentified controller.

**R2 — Rockwell GuardLogix Controllers User Manual**, publication 1756-UM020I-EN-P August 2012, p.112, [manufacturer PDF](https://literature.rockwellautomation.com/idc/groups/literature/documents/um/1756-um020_-en-p.pdf). **DOC-CONFIRMED** for that historical family: download behavior varies with safety lock and signature match; an unlocked controller with mismatching signatures may have its previous signature removed and full project downloaded. Firmware/project mismatch can require revalidation. Do not transplant 2012 rules into a 2026 controller without the applicable manual.

## Failure-path analysis and counterexamples
| Adversarial condition | What the green indication might still say | What is unproved | Appropriate independent evidence |
|---|---|---|---|
| Safety project checksum matches, but a downstream contactor is welded | Verified configuration | Contact opening, feedback discrepancy response, energy removal | As-built output/final-element path, monitored feedback and qualified fault validation |
| SICK logic output value is ON, output terminal inhibited by cross-circuit detection | Logic result ON | Physical terminal level or actuator energization | Per-module diagnostic + terminal/final-element measurement under qualified procedure |
| Older Flexi Soft Designer project checksum matches, connected EFI sensor settings changed | Flexi Soft checksum unchanged (product/edition-specific) | EFI protective-field configuration | Device-specific readback, ACR scope, optical field and stop/hold validation |
| GuardLogix safety signature matches after standard PLC download | Signed safety program unchanged | Standard-to-safety handshake, guard geometry, start/rearm, final-element wiring | Full dependency review and physical functional validation |
| Replacement safety CPU has newer firmware with same project | Some project identity may remain stable | Hardware/firmware compatibility and fault response | Manufacturer version matrix, recorded device identity and commissioning evidence |
| Network diagnostic bytes are all 1 | Apparently healthy raw status | Presence/health of every module; reserved/absent meanings | Decode by model and module position, verify inventory and fault reporting |
| LinuxCNC/HAL dashboard displays SAFE or STOPPED | Application status | Independent safety authorization or residual mechanical/hydraulic energy | Physical independent safety chain and safe-state witness |

## Architecture and practical technician workflow (INFERENCE; not a certified design)
1. **Inventory before opening a safety editor**: machine identity, safety controller and I/O model/serial/firmware, plug/memory module, connected scanner/EFI device identities, fieldbus safety endpoints, guarded zones, and final elements. If unknown, status is UNKNOWN, not PASS.
2. **Read and archive** the installed program with the exact manufacturer procedure, record a *scope-aware* signature/checksum and versioned project backup. Treat backups as confidential as-built material, not public course examples.
3. **Compare the correct scopes**: logic, constants, device configuration, connected EFI/ACR field settings, firmware/hardware, wiring and I/O mapping, network configuration, process-to-safety handshakes, and output terminal versus final-element feedback.
4. **After any download, replacement, edit, bypass, field reconfiguration or safety-network remapping**, require change-impact review and the manufacturer-prescribed re-verification/revalidation. Do not allow an operator to override a mismatch merely to regain production.
5. **Keep normal LinuxCNC/FPGA separate**: it may request motion and display diagnostics; the independent safety-related controller and physical energy-removal/holding elements retain personnel-safety authority. Do not let a standard EtherNet/IP, Modbus, HAL or GUI status bit become a safety permission.
6. **Physical proof is its own gate**: qualified independent stop, gravity load hold, energy isolation, protection coverage, fault detection, reset and fresh-start validation. A green checksum cannot close these gates.
7. **Human factors**: provide a labeled approved project/revision card inside the locked service documentation, one clear mismatch alarm, a simple guided readback/verification checklist and service-friendly guard hardware. Do not create a hidden technician workaround that bypasses the interlock.

## Limits and evidence ledger
- **SOURCE-CONFIRMED:** none from LinuxCNC or controller firmware in this investigation; LinuxCNC safety boundary remains an architecture rule, not a tested selected-machine property.
- **DOC-CONFIRMED:** S1, S2, R1, R2 from directly inspected manufacturer documents; S3 only manufacturer-indexed excerpt with full-PDF reader limit noted.
- **TEST-CONFIRMED:** none; no physical validation, no simulator, no runner.
- **INFERENCE:** proposed maintenance checklist and threat/failure paths beyond specific OEM statements.
- **UNKNOWN:** exact OpenPressBrake safety controller/firmware, installed checksum/signature and EFI/ACR scope, actual I/O/final elements, independent Y1/Y2 stop/hold, hydraulic isolation, guard/restart behavior.
- No particular checksum is cryptographic proof of physical configuration authenticity without manufacturer-specific threat model and verification; do not equate checksum match with a cybersecure signature or hardware safety performance level.
- Do not invent a controller firmware, checksum value, stopping distance, hydraulic valve truth table, PL/SIL or fault-detection coverage.

## Verification / transfer question
An engineer reports: “The replacement controller shows the same checksum and the LinuxCNC dashboard says safe, so Y1/Y2 can be operated with a person at the tooling.” Reject this release inference. Require exact product/revision scope, downstream physical safety path, independent stop/hold/guard/reset/restart evidence and residual-risk review. **G3/G4 remain NOT AUTHORIZED** without qualified machine proof.

## Next evidence gain
Obtain the exact selected controller and scanner configuration scope privately; compare with as-built electrical/hydraulic safety drawings; verify any original OEM full manual needed for that version; commission only through qualified, isolated/remote procedures with people outside hazards. An external fresh-AI evaluator must receive a novel challenge without the examples above or hidden answers being leaked.
