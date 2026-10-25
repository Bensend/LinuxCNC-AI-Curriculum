# 4400-BLOCK-01 — Twelve technician decisions and blank ram-support witness
**2026-10-25. PAPER EXERCISES ONLY; no machine tests; no external scores.** Companion: [BLOCK-01 module](4400_BLOCK_01_RAM_SUPPORT_STATIC_LOAD_POWERED_STROKE_AND_SERVICE_ACCESS_MODULE_2026-10-25.md), [OSHA/Cincinnati source audit](../research/4400_CINCINNATI_OSHA_RAM_BLOCK_STATIC_VS_POWERED_STROKE_AND_PRESS_BRAKE_SCOPE_AUDIT_2026-10-25.md).

For each case write: (a) people/exposure and lifecycle, (b) missing **physical** proposition, (c) independent authority and final energy-removal path, (d) source claim label and applicability, (e) what evidence would change HOLD to eligible for qualified review, (f) how to make correct safe behavior easier than bypass. **No answers are pre-scored.**

| # | PAPER scenario (deliberately no answer key) |
|---|---|
| 01 | A shop buys "universal press brake blocks" marketed as OSHA 1910.217-compliant. The supplier quotes §1910.217(d)(9)(iv), but the installed machine is a hydraulic press brake. |
| 02 | A manual for a different Cincinnati BASEFORM lists a minimum support strength of 10% machine capacity. A retrofit team uses that number for its new machine without weighing ram/tooling or assessing powered force. |
| 03 | A support post rated for ram deadweight is fitted while a hydraulic cylinder still has a possible powered-stroke path. A foot pedal is protected by a software inhibit. |
| 04 | Two support posts are placed close together under the center of a wide Y1/Y2 beam. The technician assumes two posts prove independent support of both ends. |
| 05 | A support rests on the top of a removable punch clamp rather than a machine-approved bearing point. The support's own rating is known. |
| 06 | An inductive switch reports the block engaged. The block is inserted sideways and does not make full contact with the ram. |
| 07 | Main disconnect locked, pump OFF and upstream pressure gauge at zero. Cylinder-side trapped pressure and a pilot check valve are not mapped. |
| 08 | Maintenance requires removing the block to reach a fastener. Operators have begun routinely leaving it out for quick tool changes. |
| 09 | A heavy new upper tool is installed after support validation; no change request is filed because the ram itself was not modified. |
| 10 | During rescue without mains power, one person wants to use an ordinary motor/jog command after restoring power to raise the ram; no approved load-transfer plan exists. |
| 11 | The guard is reclosed and safety relay reset is pressed while a prior LinuxCNC jog request is still logically active. A support is being removed. |
| 12 | An external technician arrives for shift handoff. The first technician removes a personal lock; the second assumes the safety PLC's green status proves the machine remains isolated. |

## Blank evidence worksheet — selected machine only, restricted engineering packet
| ID | Machine-specific document / independent physical witness required | Owner | Evidence revision/location | Classification | Gate state |
|---|---|---|---|---|---|
| BLOCK-01 | Machine serial, ram/tool mass, COG, Y1/Y2, support locations, tooling change history | machine/mechanical engineer | ___ | UNKNOWN | HOLD |
| BLOCK-02 | Support exact manufacturer/model, material, load case(s), approved bearing surfaces and signed analysis | mechanical engineer | ___ | UNKNOWN | HOLD |
| BLOCK-03 | Deadweight, eccentric/lateral/buckling/slip/load-path proof | qualified independent reviewer | ___ | UNKNOWN | HOLD |
| BLOCK-04 | Powered-stroke prevention, physical isolation and lock control independent of ordinary LinuxCNC/FPGA | safety/electrical engineer | ___ | UNKNOWN | HOLD |
| BLOCK-05 | Hydraulic chambers, pilot, relief, accumulator, residual pressure and reaccumulation | hydraulic engineer | ___ | UNKNOWN | HOLD |
| BLOCK-06 | Support installation/removal and rescue with no exposure; human-factor usability | operator + maintainer + reviewer | ___ | UNKNOWN | HOLD |
| BLOCK-07 | Fresh reset/rearm, no retained motion, support/guard restoration and fault response | independent safety engineer | ___ | UNKNOWN | HOLD |
| BLOCK-08 | Qualified physical validation method, instrumentation, exclusion, acceptance and witness | independent tester | ___ | UNKNOWN | NOT RUN |

**Status rules:** Never change UNKNOWN to PASS because a PDF, PLC status bit, supplier rating or desk worksheet exists. Record actual source edition, as-built revision and owner. N/A requires explicit documented reason. A failed gate stays HOLD; it is not repaired by repeating a lab.

**Human-factors design prompt:** Sketch a dedicated, easily handled, labeled support and storage location that makes the approved placement and personal lockout obvious, while maintaining real access to the service point. Do not specify an unverified thickness, material, support count, strength or position. Have an operator and maintainer critique the unpowered workflow before engineering release.

**Safety limit:** All twelve cases are paper; BLOCK-01..08 are blank. No people-exposed maintenance, live testing, intentional hydraulic fault, or unqualified support placement is authorized.

## Cross-source question for cases 02 and 06 (not an additional scored case)
The Cincinnati BASEFORM 90–175 manual states a **10% of machine capacity** support-block criterion; the OSHA 2007 slide-lock appendix states **2.0 times maximum anticipated load** for its defined slide-lock system and describes two independent visual engagement indications. Explain why these are different device/denominator/applicability questions rather than a license to choose the smaller number. Distinguish the indicator of engagement from the rated physical load path. The OSHA appendix also calls for qualified initial/retest after modifications or significant dynamic loading; no such test has been executed here. **Do not assign a universal numeric rating or self-score the answer.**
