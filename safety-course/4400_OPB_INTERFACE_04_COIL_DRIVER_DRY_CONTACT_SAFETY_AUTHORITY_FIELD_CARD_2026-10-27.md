# 4400-OPB-INTERFACE-04 — Three look-alike outputs, three different jobs

**Field reviewer card | 2026-10-27 | NON-GRADUATED | public design reasoning, not machine authorization**

[Exact current cross-repository source audit](../research/4400_OPB_RELAY_COIL_VS_DRY_CONTACT_VS_PILZ_FINAL_ELEMENT_CROSS_REPO_AUTHORITY_AUDIT_2026-10-27.md). This card is a **new exact interface-selection delta** to OPB-CUTOVER-02 and OPB-ISO-03, not a replacement for those lessons.

## The quick discriminator

| If the machine needs… | The source-backed OpenPressBrake option | What it does **not** give you |
|---|---|---|
| A **24-V operational command** to the retained DNC/Pilz terminal | `digital_output_24v` in **11K2-switched L7/L07**, as allocated by the Rev 1 map | Not independent safety qualification or a contact. |
| A **voltage-free ordinary COM/NO/NC** signal | `dry_contact_relay_output` (Omron G5Q-1, currently **NOT READY**) after exact electrical-load review | Not a force-guided, safety-rated contact or a personnel-safety function. |
| To energize an **external ordinary 24-V relay/contactor coil** | `relay_contactor_driver` `COIL_24V/COIL_RETURN` (currently **SIMULATION-READY**, not released) | Not the external contact, contact feedback, safety stop or proof of load holding. |
| A protective stop, hydraulic load hold, safety reset or guarded access | **Retained independent Pilz/AKAS and actual safety final elements**, with wire-75 hardware and wire-63 drive paths preserved | Not assignable to ordinary FPGA output or watchdog. |

The latest `relay_contactor_driver/REV1_RESOURCE_CONTRACT.yaml` (OpenPressBrake commit `92cf5424be90f45f664ba2652dc725b38e1895f9`) uses **three FPGA GPIO per instance**, but the two field terminals carry **coil power**, not contact COM/NO/NC. Neither the new contract nor the inspected Rev 1 machine mapping assigns that reusable primitive to the press brake's eight ordinary DO.

## Five-minute documentary review (no live testing)

Start from the **actual machine function and electrical terminal**, not from a block name. Follow the load through the cabinet wiring and distinguish: who commands the switch; which supply and return feed it; which contacts or valves actually move; which independent safety element removes hazardous energy; what evidence confirms safe stopping and holding. For the first-machine map, **six** normal CNC-to-Pilz operational outputs plus **two** X-direction outputs make eight ordinary DO. Seven Pilz status inputs plus X index make eight ordinary DI. This is not a request for extra coil-driver instances.

An OFF command is not a physical open contact. The published coil-driver design basis itself notes that an output short to +24 V may defeat commanded OFF. Its `COIL_FAULT_OVERLOAD` and `COIL_FAULT_OVERTEMP` report semiconductor conditions, not external contact position. A general-purpose dry contact does not become a safety relay by being labeled “relay.” An ordinary FPGA reset LOW does not prove independent stop, gravity holding or deliberate rearm.

**Practical anti-bypass design:** keep existing safety wiring and service labels physically distinct from ordinary outputs; label terminals by **signal type, source, return and authority** rather than by ambiguous “RELAY” alone. Require a revision-matched wiring and load record before anyone swaps a coil driver, contact module or field-power source. Make access to documented, tested replacement parts easier than improvising a jumper.

**OEM rating trap:** Omron's original G5Q-1 datasheet distinguishes NO and NC resistive-load ratings; its 10-A family headline is not a universal NC/inductive rating. The published 5-ms initial relay release characteristic is not the completed board's contact release time or the machine's stop time. The ordinary dry-contact block uses a flyback diode; the separate external-coil driver uses active demagnetization. Do not transfer either timing path into safety calculations without a qualified actual assembly and load.\n\n**Fault-status validity:** The published external-coil driver uses an LM393LV open-drain comparator and a 3.3-V pull-up for each active-HIGH overload/overtemperature flag. TI documents comparator POR as high-impedance. An all-LOW fault display during a rail outage is not a positive healthy-contact witness. Keep rail validity, ordinary fault indication, contact feedback and independent physical stopping separate; no new FPGA status grants personnel-safety authority.\n\n## Exact evidence still missing

Existing restricted Stage A C/D/F/G and OPB-D01/D06/D08—not a new public questionnaire—must establish the installed safety-controller program, any actual coil-driver allocation, contactor identity/feedback, 11K2 poles/return, Y1/Y2 physical stop and gravity hold, hydraulic isolation, guarding, and deliberate restart. Qualified personnel must determine whether a contactor is a safety final element; the generic board primitive provides no safety rating or physical test.

**Evidence classes:** SOURCE-CONFIRMED public board contracts; DOC-CONFIRMED ST/Omron/Pilz general documentation; INFERENCE for proposed fault propagation; installed hardware and safety validation UNKNOWN; no TEST-CONFIRMED result. **G0/G1 HOLD; no personnel-exposed hazardous operation.** No lab, simulation or compute justified by this documentary discriminator.
