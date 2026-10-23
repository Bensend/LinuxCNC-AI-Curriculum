# 4400 — AKAS-5M selected-setting overrun, automatic retest, and machine acceptance

**Session:** 2026-10-23 UTC. **Status:** manufacturer `DOC-CONFIRMED`, selected installation `UNKNOWN`, no physical `TEST-CONFIRMED` evidence. **Purpose:** clarify the 13 mm / 11 mm discrepancy from the preceding checkpoint by inspecting the *rest* of the same manual. Not a machine configuration, compliance certification, or permission to operate.

## Pinned authoritative document and exact page chain

Fiessler Elektronik, *AKAS-5M Operating Instructions*, document **1581**, dated **2024-02-15**, English translation, original manufacturer PDF: https://www.fiessler.de/default-wAssets/docs/download/AKAS/bdh-akas-5-original-engl-doc1581-v1.0.pdf . Rendered and visually inspected printed pp. **5, 14, 23, 25, 26** (zero-based PDF pages 4, 13, 22, 24, 25). This source applies to the AKAS-5M described in that document, not automatically to AKAS LC-5M, other Fiessler families, a replacement unit, or a different manual revision.

| Printed page | Specific manufacturer statement | Evidence classification | What it does **not** prove |
|---|---|---|---|
| 5, §2.1 item 4 | States a family maximum **13 mm**, with fast-speed reduction if **one** of ten measurements exceeds it. | `DOC-CONFIRMED` | Does not establish that 13 mm is acceptable for every switch position or installation. |
| 14, §5.2 | States **11 mm** in a ten-measurement instruction, but does not clearly identify the quantifier. Table 14/1 includes selectable distances **A=13 mm**, **B=11 mm** and smaller settings; text identifies **B** as the factory preset. | `DOC-CONFIRMED` | Does not explicitly explain why the prose uses 11 mm when the table permits A=13 mm. |
| 23, §5.10 | Describes automatic first-stroke/power-restoration overrun verification and a **30-hour** retest for the documented arrangement, referring to **prEN 12622**; identifies the alternative in which machine control performs the check. | `DOC-CONFIRMED` | Does not establish that the installed machine actually performs the check or that 30 hours is a universal current-standard interval. |
| 25, §6.2 checklist items 14–15 | Calls for a test after voltage reset and a measured overrun **below the Table 14/1 value**. | `DOC-CONFIRMED` | A ticked checklist without measured trace or valid provenance is not a physical witness. |
| 26, §6.3 | States the **machine control system** must perform an overrun test after voltage reset and repeat within the next 30 hours; measured overrun must not exceed the **maximum allowable overrun programmed by the receiver-support DIP switches**. Describes AKAS-5M operation **only with an additional safety PLC**; the safety PLC evaluates the dual OSSD and monitors relevant slow-speed inputs. | `DOC-CONFIRMED` | Does not prove ordinary LinuxCNC has safety authority, nor prove the installed safety PLC's actual configuration, fault response, or physical stop. |

## Revised adjudication of the 13/11 conflict

**Material information gain over the prior checkpoint:** printed pp. **25–26** explicitly connect the operative overrun check to the **selected Table 14/1 / DIP-switch value**. Therefore the source supports a **setting-dependent test obligation** more strongly than an unconditional universal 13 mm or 11 mm rule. A plausible interpretation is that p.5 advertises the family ceiling and p.14 discusses the factory-preset B condition. This is still `INFERENCE`: the prose on p.14 does not explicitly qualify its 11 mm instruction by B, and the wording about one versus all of ten measurements remains inconsistent/ambiguous. The apparent checklist phrasing *below* versus §6.3 *not exceed* also differs at the equality boundary; do not invent a machine pass rule at equality.

**Unresolved before selected-machine release:** installed catalog/serial and document revision; actual DIP positions; approved intended stop/overrun criterion and inequality; interpretation of the ten precommissioning measurements; independent machine stop/overrun traces; actual overrun-test ownership and timing; tool/laser geometry, blanking mode, and physical final-element path. Request manufacturer clarification where the ambiguity affects a real acceptance decision. The manual's 30-hour figure is **not** an inferred general interval for other models or current standards.

## Three non-substitutable evidence transactions

**Transaction 1 — initial measurement and setup.** Record exact selected variant, actual DIP configuration and mechanical setup, source applicability, raw precommissioning measurements, measurement method/instrument, independent witness, chosen acceptance basis, and reviewer disposition. Averages cannot conceal a bad individual measurement when the acceptance rule concerns individual results. If the acceptance rule is disputed, retain `UNKNOWN` and **block** crediting the test as accepted.

**Transaction 2 — automatic monitor freshness.** Record who owns the overrun test (selected safety controller/AKAS/other qualified arrangement), when the required trigger occurred (power restoration, first stroke, elapsed operating time), whether a new valid test actually executed, its measured result, timestamp/sequence, failure/inhibit behavior, and retained evidence. A power-on, `test_requested`, ordinary program start, HMI green light or stale last-PASS record does **not** prove a new accepted test. Do not claim that the manual's timing automatically makes a particular implementation safety-rated.

**Transaction 3 — machine-level hazard proposition.** Validate the installed final-element path and actual physical stop/holding across the relevant machine operating envelope, tooling, modes and changed conditions. Laser device health, OSSD transition, or monitored valve position alone cannot prove ram standstill, trapped hydraulic energy removal, gravity holding, workpiece sweep control, helper clearance, or maintenance isolation. Distinguish press-brake production protection from lockable energy isolation and blocking.

## Falsification cases (reasoning exercises; NOT RUN)

1. **Preset replaced:** a spare receiver is installed with DIP B, but the old worksheet records A. A previously valid test threshold cannot be reused without a `CHG` review; selected-setting provenance is broken.
2. **Stale monitor:** last recorded test PASS predates a power cycle. The controller UI reuses that result after reboot. The new test's occurrence remains unproved, regardless of whether the old physical stop test was valid.
3. **Quantifier trap:** nine hypothetical readings are 9 mm and one is 12 mm. Page 5's 13 mm one-of-ten condition is not triggered; p.14's 11 mm instruction cannot be reduced to a pass/fail algorithm without interpreting its quantifier and selected setting. These numbers are illustrative, **not** measured or acceptance recommendations.
4. **Equality trap:** an illustrative measurement equals the configured threshold. Page 25 says *smaller* while p.26 says *not exceed*. Do not silently choose `<=` or `<` in a real validation protocol without an authoritative acceptance basis.
5. **Contradictory physical witness:** a recorded overrun monitor PASS coexists with independently observed continuing hazardous ram motion. The discrepancy is a safety-relevant failure; do not accept the PASS as machine proof.
6. **Nuisance-test defeat:** frequent false monitor alarms cause operators to disable the test. Improve fault localization, inspection access and workflow; bypassing the monitor does not create safety authority.
7. **Mode transfer:** flat-bending validation is reused after box-mode muting or a new tool changes the detection geometry. The altered `BND/HAZ/SF/PHY/SRS/VAL` chain is stale until reviewed.

## Cumulative-package record and safety boundary

Carry `BND`, `ENE`, `HAZ`, `SF`, `PHY`, `SRS`, `AUTH`, `DEP`, `ARC`, `HF`, `VAL`, `PT`, `CHG`, `UNK`, `RR` identifiers. Separate (a) selected-setting documentary acceptance, (b) monitor execution/freshness, (c) machine-level physical safe state. A credible common-cause fault may corrupt both the monitor and the actuator it claims to observe. Ordinary LinuxCNC/HAL/FPGA software may request motion or display diagnostic state but must not become the sole personnel-safety decision owner.

**Operational restriction:** no hazardous operation with people exposed unless the selected-machine minimum safe-to-operate threshold is independently established. Isolated/remote experimental work still needs its own residual-risk assessment and people outside the danger zone. No numerical stopping/pressure/speed threshold or machine-specific hydraulic truth table is established here.

**Next evidence:** manufacturer clarification or the actual selected-machine technical file; an instrumented machine test only after its hazard boundary and qualified procedure are defined. No simulation can adjudicate inconsistent manual text. No lab compute justified in this session.

## Independent cross-check: mode-exception return is another transaction

Manufacturer printed **p.25 §6.2** says setup operation uses slow-speed conditions or a documented special OSSD-muting arrangement, fast-speed closing must be reliably excluded, and **the special muting must be cancelled after setup**. It also distinguishes an ordinary fast-speed-prevention function that need not itself be safety-oriented from the requirement that motion under a muting condition is constrained by the documented safety category. Printed **p.26 §6.3** assigns the OSSD evaluation and speed-position input monitoring to the **additional safety PLC**. These are `DOC-CONFIRMED` descriptions of this manufacturer application, not an approved design for an unspecified machine.

**New acceptance implication:** a current overrun-monitor PASS does not by itself prove that a temporary setup-mode muting exception has been exited, that the protective field is again active, or that a stale ordinary cycle command cannot restart motion. Conversely, exiting setup mode does not establish a new overrun test. Model these as *separate*, linked `VAL/PT/CHG` transitions. The selected machine's precise mode logic, safe-speed monitoring and reset/rearm ownership remain `UNKNOWN` until its actual safety application is inspected.

**Adversarial case:** after a tool change, the HMI shows the last overrun PASS and normal mode, but the safety-controller record of cancelling setup muting is missing. Do not infer active optical protection or restart eligibility from the HMI or the prior overrun record. The safe path is to withhold credit for the missing protection/transition evidence and resolve the installed safety function before exposed-person operation.
