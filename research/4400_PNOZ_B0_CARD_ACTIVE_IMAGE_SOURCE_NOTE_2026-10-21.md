# 4400 Pilz PNOZ m B0 project-identity and chip-card ambiguity (2026-10-21)

Evidence class: **DOC-CONFIRMED** for the specified product manual; installed ERMAK controller **UNKNOWN**. No controller contact, simulation, physical testing, or commissioning.

Manufacturer: Pilz, *PNOZ m B0 Operating Manual 1002660-EN-13*, https://www.pilz.com/download/open/PNOZ_m_B0_Operating_Manual_1002660-EN-13.pdf .

- Section 7.3 (p.29): card-project loading presents name/CRC/date and calls for an explicit rotary-knob acceptance action.
- Section 7.4 (p.29): USB project **download** can also write an inserted chip card; do not call it a read-only backup.
- Sections 7.5–7.6 (p.30): function checks follow card exchange/project download/reset; the card is not required for operation.
- Section 8 (p.32): power-up is described as copying configuration from the card.
- Section 8.2.2.2 (pp.34–35): project menu can display information for device **or** card and contains a transfer action; a CRC without attribution is not proof of the active image.
- Section 4.2 (p.18): manufacturer requires protection against unauthorized physical/program changes and states Modbus/TCP lacks built-in security.

**Unresolved manufacturer wording:** power-up copying, explicit acceptance, and card-optional operation coexist in the same manual. Do not invent firmware-specific precedence or assume a power cycle/card swap is non-modifying. Identify exact installed base unit, firmware, expansion modules and approved project before choosing any manufacturer/OEM-approved read-only evidence method.

**Safety boundary:** matching project identity, RUN status, valve-position feedback and HMI diagnostics cannot prove the independent physical ram stopping/holding state. A physical contradiction invalidates a claimed safe-state witness. Maintain SRS/PHY/AUTH/DEP/ARC/VAL and CHG/STALE traceability; preserve external evaluation gates. All conceptual cases NOT RUN. No personnel-exposed hazardous operation authorized.
