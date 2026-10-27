# 4400-SAFE-PROGRAM-05 — Pilz program evidence without accidental modification

**Technician/qualified reviewer card | 2026-10-27 | NOT RUN | UNSCORED | not a commissioning authorization**

**First determine the exact installed controller.** “PNOZmulti” is not a sufficient model identifier. The original [Pilz Configurator FAQ](https://www.pilz.com/en-INT/products/small-controllers/software/pnozmulti-tools?etcc_cmp=PNOZmulti_Tools&etcc_ctv=215598&etcc_med=PR) documents **v10.14 LTS** for Classic/Mini project editing and migration, versus **v11** for PNOZmulti 2 projects. Do **not** migrate or rewrite an old application just to inspect it.

**Least-authority review:** Pilz documents **Level 2** as view-without-modification, Level 1 as modify/save, and Level 3 as able to change some commissioning blocks. Use an approved view-only workflow only when the *actual installed model and tool* support it. View-only privilege is **not** proof that online attachment, connection, transfer or device operation is harmless. Prefer existing offline records and qualified manufacturer instructions before any machine connection.

**Stop and escalate if:** the tool offers to download/transfer/write/migrate/reset; the displayed project differs from the approved baseline; the device model/firmware is unsupported; the only available role can edit; an unexpected controller fault/state change occurs; or the operator proposes a bypass to make evidence collection easier. Preserve a change/incident record; do not improvise recovery on a personnel-exposed machine.

**Evidence ladder:** (1) as-installed device/firmware identity, (2) compatible tool and authorized access mode, (3) actual active-project identity compared to approved baseline, (4) exact as-built safety I/O/final elements, (5) independent physical Y1/Y2 stopping/holding, isolation, guards, deliberate restart. Each rung is necessary for its claim; no earlier rung proves a later one.

**Scope:** read [manufacturer/version audit](../research/4400_PNOZMULTI_CLASSIC_V10_VS_PNOZMULTI2_V11_READ_ONLY_EVIDENCE_ACQUISITION_AUDIT_2026-10-27.md), [SAFE-PROGRAM-04 predecessor](../research/4400_SAFETY_PROGRAM_IDENTITY_FPSC_EXAMPLE_PILZ_CRC_VALVE_FEEDBACK_AND_BACKFEED_SOURCE_REVIEW_2026-10-27.md), and [existing restricted D01 intake](4400_OPB_CUTOVER_02_RESTRICTED_HANDSHAKE_AND_POWER_DELTA_CARD_2026-10-27.md). Keep sensitive project files and machine records private. **No machine evidence received; G0/G1 HOLD.**
