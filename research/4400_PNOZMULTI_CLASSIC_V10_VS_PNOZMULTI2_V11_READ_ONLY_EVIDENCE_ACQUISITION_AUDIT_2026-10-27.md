# 4400-SAFE-PROGRAM-05 — Pilz PNOZmulti Classic/Mini versus PNOZmulti 2 toolchain and evidence-acquisition boundary

**UTC session start:** 2026-10-27T11:31:46Z. **Status:** DOC/SOURCE study, NON-GRADUATED; G0/G1 HOLD. No connection to, program readback from, or operation of an installed machine was performed.

## Question, predecessor and incremental value

The prior [SAFE-PROGRAM-04](4400_SAFETY_PROGRAM_IDENTITY_FPSC_EXAMPLE_PILZ_CRC_VALVE_FEEDBACK_AND_BACKFEED_SOURCE_REVIEW_2026-10-27.md) established the distinction between a workstation project, an installed active project, matching CRC, valve feedback and physical stop/hold. The [existing restricted Stage B D01](../safety-course/4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md) already requests installed model and active application identity. This investigation does **not** claim a new generic safety function. Its **new exact manufacturer/version finding** is that the toolchain for recovering evidence differs materially between *PNOZmulti Classic/Mini* and *PNOZmulti 2*, and a view-only role can reduce accidental editing risk but cannot itself prove an online connection is non-disruptive or safe.

## Original manufacturer evidence (retrieved 2026-10-27)

| Proposition | Classification | Original source / qualification |
|---|---|---|
| Pilz **PNOZmulti Configurator v11** is used for new PNOZmulti 2 projects and opening/editing existing PNOZmulti 2 projects; the v11 description lists B0, B1, B1 Burner, B0.1 and second-generation expansion hardware. | **DOC-CONFIRMED** for the manufacturer-described product/software versions, not an installed controller | Pilz original [PNOZmulti Configurator product/FAQ](https://www.pilz.com/en-INT/products/small-controllers/software/pnozmulti-tools?etcc_cmp=PNOZmulti_Tools&etcc_ctv=215598&etcc_med=PR), section “What's new in Version 11”. |
| Pilz **PNOZmulti Configurator v10.14 LTS** contains PNOZmulti **Classic/Mini** hardware and can open/edit those projects and migrate them to PNOZmulti 2. Classic/Mini ranges were discontinued at end of 2024. | **DOC-CONFIRMED** exact manufacturer version/compatibility statement; *migration is a change*, not evidence readback | Same original Pilz FAQ, “Can I continue to edit existing PNOZmulti Classic and Mini projects...?” |
| Pilz documents **three password privilege levels**: Level 1 modify/save; Level 2 view without modification; Level 3 changes to certain commissioning-adjustable blocks. | **DOC-CONFIRMED** tool capability; do not assume all installed controllers/versions offer identical interfaces | Same original Pilz FAQ, “Why do you need three passwords...?” |
| PNOZmulti Configurator can download a circuit diagram to the base unit; it also supports online diagnostics/error stack. | **DOC-CONFIRMED** software capability; **INFERENCE** that an incorrectly operated engineering session could alter the machine | Pilz [software overview](https://www.pilz.com/en-US/products/small-controllers/software) and original Configurator FAQ (online error stack). |
| Public Rev1 OpenPressBrake design says **retained Pilz PNOZmulti** but does not identify Classic/Mini/B0/B1 or installed program. | **SOURCE-CONFIRMED public proposed design only**, **UNKNOWN installed model** | [OpenPressBrake Rev1 YAML](https://github.com/Bensend/OpenPressBrake/blob/main/hardware/REV1_BOARD_INTEGRATION.yaml), Git blob `271e2d94a75e11858288efb3375a639fbf188dc8`, `board_contract.retains`. |
| Original PNOZ m B0 manual includes project name/CRC and requires safety-function checks after project/card changes. | **DOC-CONFIRMED for B0 only** | [Pilz PNOZ m B0 operating manual 1002660-EN-13](https://www.pilz.com/download/open/PNOZ_m_B0_Operating_Manual_1002660-EN-13.pdf), §§7.3–7.5, 8.2.2.2; [SAFE-PROGRAM-04](4400_SAFETY_PROGRAM_IDENTITY_FPSC_EXAMPLE_PILZ_CRC_VALVE_FEEDBACK_AND_BACKFEED_SOURCE_REVIEW_2026-10-27.md). |

**Correction to a tempting shortcut:** The presence of a recent v11 installer does **not** mean it can open an older Classic/Mini project. Conversely, using v10.14 to migrate a Classic/Mini project to PNOZmulti 2 is **not** a passive evidence-collection action; it creates a new configuration/change-control branch. Neither an offline simulation nor a valid-looking CRC is physical stop/hold validation.

## Non-invasive documentary acquisition hierarchy (conditional proposal, NOT RUN)

1. **Before any software or cable:** qualified reviewer obtains permitted existing cabinet label/model, archived OEM project export, dated commissioning report, installed controller/firmware inventory and revision history **without touching an energized safety controller**. A photo alone may identify a model but not its active project.
2. **Select the correct OEM manual and tool version from the exact installed device**, not from the words “PNOZmulti” or a workstation installer. Classic/Mini versus second generation is a blocking discriminator for software compatibility. Verify the selected tool's documented supported hardware/firmware and authorization model.
3. **Prefer authorized view-only access where supported.** Pilz's Level 2 is expressly view-without-modification; this mitigates editing privileges but does **not** prove that attaching a laptop, initiating online communication, downloading a project, or resetting the controller has no operational effect. Such effects are **UNKNOWN until model/version-specific instructions and qualified site procedure are checked**.
4. **Prohibit accidental transfer/migration as evidence collection.** Do not choose Download/Transfer/Write/Reset/Force/Commission/Start/Stop or a migration workflow merely to obtain a CRC. Treat any actual change or unexpected prompt as a **CHG event and HOLD**, with qualified revalidation required. This is an engineering conservative procedure, not a claim that every tool offers each command.
5. **Capture provenance without publishing sensitive files:** exact installed model and expansion list, firmware, tool version, role, method of obtaining readback, project ID/checksum/date if actually supported, readback timestamp and reviewer, approved baseline identifier, and a record that no change was made. Store any application export, network address, credentials, serials and site diagrams privately. The public curriculum records only evidence status and generic method.
6. **Reconcile identity to wiring and physics separately:** map approved program inputs/outputs to as-built wire 44/45/75, 11K2 L7/L07, AKAS, independently owned hydraulic valves, feedback and reset/restart logic. Then require independent Y1/Y2 stop and gravity holding, isolation, guard and restart validation. Identity is a necessary link, not a sufficient machine-safety witness.

## Adversarial documentary counterexamples (INFERENCE, not machine faults)

| Scenario | Invalid conclusion | Discriminating action |
|---|---|---|
| Engineer installs v11, cannot open a legacy Classic file, then recreates a plausible new project. | “The new file is equivalent to the active installed safety program.” | **HOLD**; identify Classic/Mini device and original v10.14-compatible archived application; never deploy a recreated project as a readback shortcut. |
| Engineer obtains a CRC from a workstation file while controller remains unidentified. | “CRC recorded = installed project proven.” | **HOLD** until qualified model-specific active-device identity/readback and approved baseline match. |
| Reviewer uses a role permitting block edits during “inspection.” | “Diagnostics session was necessarily read-only.” | Record actual privilege and session activity; prefer supported view-only role, stop if unexpected write/transfer/reset path appears. |
| Program identity matches but valve feedback and beam-hold proof are missing. | “G0/G1 may pass because the program is certified.” | **HOLD**; final-element wiring and independent physical stop/hold/guard/restart proof are separate. |

## Human-factors and release boundary

Provide the technician a one-page *model → compatible tool → view-only privilege → active identity → separate physical proof* path. Easy access to approved backups and clear “read only / do not download” labels reduces the incentive to bypass program protection. A safety program should never be modified simply to make a fault disappear or to recover an easy green indicator.

**Status:** installed Pilz model/tool compatibility/active project, readback permissions and as-built validation **UNKNOWN**; no remote connection, tool installation, simulation, physical test, evaluator or safety release. G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. No new questionnaire or public exercise bank. The existing Stage A and OPB-D01 evidence fields own any eventual private evidence.
