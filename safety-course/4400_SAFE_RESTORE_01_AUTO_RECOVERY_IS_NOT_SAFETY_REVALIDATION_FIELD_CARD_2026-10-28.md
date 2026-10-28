# 4400-SAFE-RESTORE-01 — “Configuration restored” does not mean “safe to run”

**2026-10-28 | technician / qualified reviewer | NON-GRADUATED, PAPER ONLY, NOT A LIVE MAINTENANCE PROCEDURE**

Read the [original SICK/Pilz source audit](../research/4400_SAFE_RESTORE_01_SICK_ACR_PILZ_FACTORY_RESET_FORENSIC_AND_POSITION_RETEACH_SOURCE_AUDIT_2026-10-28.md) after [SAFE-PROGRAM-04](4400_SAFE_PROGRAM_04_ACTIVE_PROJECT_AND_FINAL_ELEMENT_EVIDENCE_REVIEW_CARD_2026-10-27.md), [SAFE-PROGRAM-05](4400_SAFE_PROGRAM_05_PILZ_TOOLCHAIN_READ_ONLY_ACQUISITION_FIELD_CARD_2026-10-27.md) and [POS-TRUST-01](4400_POS_TRUST_01_HOMED_SOFTWARE_STATUS_VS_PHYSICAL_POSITION_TRUST_FIELD_CARD_2026-10-28.md). This is an exact-OEM maintenance addendum, not a new general reset course or scored test.

| A green or convenient observation | What original manufacturer evidence actually supports | What still needs separate proof |
|---|---|---|
| **SICK Flexi Soft ACR succeeded** | For compatible FX3-CPU2/CPU3 + system-plug configurations, selected same-type **EFI sensors** can be restored. ACR explicitly **does not restore Flexi Soft FX3-CPUx controllers**. | Correct sensor mounting/field geometry, physical guard coverage, final-element stop/hold, restart and selected configuration. |
| **SICK FX3-MOC1 module replaced** | OEM §10.2 requires function test; if specified reference-memory or SSI teach-in is used, reference/teach-in must be repeated. | Physical position trust; LinuxCNC HOMED is not a safety-monitor reference witness. |
| **SICK Flexi Compact SmartPlug present** | Stores configuration; unplugging its front connector stops program execution; exact manual says remove only with supply off. | Stopped program ≠ electrical isolation, hydraulic gravity hold or safe access. Do not assume Flexi Soft ACR rules apply. |
| **Pilz B0 display fault cleared after factory reset** | OEM §9 says reset deletes **project, inserted chip-card contents, error stack, program-change log and user settings**. | Original cause and approved project provenance may now be lost; revalidate independently, never “reset until green.” |

**Four-stage practical review:** (1) **Preserve** permitted existing diagnostic, active-project and change evidence without energized probing or destructive reset; (2) **Identify** exact installed base/expansion/sensor part numbers, firmware, approved configuration and replacement compatibility; (3) **Qualify** affected safety inputs, reference/geometry, wiring and independent physical final elements with the machine isolated and qualified review; (4) **Rearm separately** with verified area clearance, deliberate safety reset and a fresh ordinary cycle-start command. A maintenance recovery or new CRC alone cannot pass the physical release gate.

**Human factors:** keep an approved labeled spare and protected configuration/diagnostic archive with the machine's maintenance packet. Clearly mark **VIEW / EXPORT** separately from **DOWNLOAD / TEACH / RESET / FACTORY RESET**. Do not expand the existing [seven-packet G0 Stage A owner request](4400_OPENPRESSBRAKE_G0_EVIDENCE_REQUEST_ONE_PAGE_2026-10-25.md) with speculative hardware questions.

**Scope / status:** Original SICK/Pilz details **DOC-CONFIRMED only for named product/edition**; safe machine transfer **INFERENCE**; installed OpenPressBrake Pilz/AKAS, memory media, sensor, Y1/Y2 valves, guarding and restart **UNKNOWN**; physical test/evaluator **NOT RUN**. No operation with people exposed; G0/G1 **HOLD**, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. Independent 2520–25F0 evaluator OPEN. No compute.
