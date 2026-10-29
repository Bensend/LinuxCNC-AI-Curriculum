# 4400-ELEC-EXPOSE-01 — Technician field card: a dark cabinet is not proven de-energized

**2026-10-29 | documentary safety lesson, not an electrical test procedure.** [Original OSHA/NFPA audit](../research/4400_ELEC_EXPOSE_01_OSHA_1910_333_LED_ZERO_ENERGY_ARC_FLASH_CABINET_SERVICE_SOURCE_AUDIT_2026-10-29.md).

**Before opening an electrical enclosure for work:** distinguish a **normal machine stop**, **safety-related stop**, **electrical isolation**, **qualified verification of exposed parts**, and **physical gravity/hydraulic restraint**. These are not interchangeable. OSHA 1910.333 forbids using pushbuttons/interlocks as the only de-energization means and requires qualified test-equipment verification, including backfeed. Its 2012 interpretation says even a correctly installed voltage-indicator LED is only supplemental indication, **not** the required test.

The easiest safe design is a clearly labelled isolation map, convenient accessible external diagnostics, proper lockable disconnects, and a qualified electrical-work procedure that does not force opening energized cabinets for ordinary troubleshooting. Do not select an arc-flash boundary, PPE rating or energized-testing sequence by guesswork. NFPA currently lists **70E:2027**; verify the locally applicable edition.

| Technician observation | What remains unproved |
|---|---|
| E-stop pressed, HMI/24-V LED dark | Line-side voltage, alternate feeds, UPS, capacitors and actual isolation. |
| STO active / drive fault | Electrical disconnection, absence of voltage, gravity restraint. |
| Main disconnect open | Whether all supplies and unrelated backfeed are isolated. |
| Installed voltage indicator dark | Qualified test-equipment verification of the parts exposed. |
| Electrical isolation verified | Hydraulic stored energy, elevated beam hold, restored guards and deliberate restart. |

**No exposed-person operation or cabinet servicing on the basis of these indicators.** Qualified personnel must follow applicable electrical energy-control and risk-assessed work practices; experimental machine motion remains isolated/remote with people outside the hazard zone. OpenPressBrake as-built circuit, arc risk, stop/hold and validation **UNKNOWN / NOT RUN**. G0/G1 **HOLD**, independent evaluator **OPEN**.


### EOFF-01 paper addendum — red button, red power switch, lockable disconnect
[Direct Eaton/Pilz/OSHA source audit](../research/4400_EOFF_01_EATON_PILZ_OSHA_EMERGENCY_SWITCHING_OFF_VS_ESTOP_VS_LOTO_SOURCE_AUDIT_2026-10-29.md). **UNSCORED paper checks, not live procedures:** (1) E-stop stopped spindle but DC bus remains energized: stopping is not isolation. (2) Emergency switching-off interrupted one supply: check what it actually interrupts and whether gravity/controlled braking is lost; do not assume every feed isolated. (3) A padlocked disconnect with UPS/backfeed: identify other sources and require qualified verification. (4) Dark HMI and STO while ram suspended: neither electrical zero nor gravity hold is established. (5) Device reset with held Cycle Start: fresh separate start remains necessary. **No unqualified cabinet probing or energized demonstrations.**
