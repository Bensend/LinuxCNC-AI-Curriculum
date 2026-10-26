# 4400-RCD-02 — What powers the protective device when its supply fails?
**PUBLIC PAPER exercise / NON-GRADUATED. Four cases UNSCORED; six desk gates NOT RUN. No energized neutral-break lab.**

Read [RCD-02 original source audit](../research/4400_RCD_02_VOLTAGE_DEPENDENT_TRIP_NEUTRAL_LOSS_FUNCTIONAL_EARTH_OEM_AUDIT_2026-10-26.md) after [RCD-01](4400_RCD_01_DC_LEAKAGE_RCD_TYPE_AND_PE_NO_SHORTCUT_FIELD_MODULE_2026-10-26.md).

## Four questions for a fresh technician (UNSCORED)
1. **NL-P01:** Two RCDs are both Type B. One needs supply voltage for its trip electronics; the other is voltage-independent. Why is “both Type B” insufficient to approve either for a neutral-fault protection requirement? Identify missing product evidence.
2. **NL-P02:** A replacement RCD has an FE terminal. An installer proposes tying FE to a convenient control 0 V and removing a door's separate PE strap. Separate FE, PE, neutral and signal reference. What must be withheld pending qualified electrical review?
3. **NL-P03:** After a neutral-loss event, a category-1 voltage-dependent device can remain closed while a category-2 device opens. Does either observation prove that an OpenPressBrake ram is safely held or that a technician can enter? Explain the separate safety authority and physical witnesses.
4. **NL-P04:** An RCD front test button passes with normal supply. A technician claims this proves operation during a broken-neutral fault. What does the manufacturer test-button circuit actually exercise, and which proposition remains untested?

## Six documentary gates — all NOT RUN
| Gate | Evidence required | State |
|---|---|---|
| NL-G01 | Exact RCD make/model, revision and manufacturer operating instructions | NOT RUN |
| NL-G02 | Product's voltage-independent/dependent category and behavior on supply/neutral loss | NOT RUN |
| NL-G03 | Exact selected PE, FE, neutral and any auxiliary trip-power connections from as-built | NOT RUN |
| NL-G04 | Qualified applicable wiring standard/jurisdiction and selected protection coordination | NOT RUN |
| NL-G05 | Qualified no-energy inspection/verification plan; no dangerous intentional neutral fault | NOT RUN |
| NL-G06 | Separate machine physical stop/hold/guard/energy and deliberate restart witness | NOT RUN |

**Safer-by-default:** use the manufacturer's exact terminal diagram at the point of installation, identify FE and PE separately, make replacements traceable by catalog code and ensure a power-return event cannot by itself reauthorize hazardous motion. Where a basic safe-to-operate threshold is unproven, maintain G0/G1 HOLD; no personnel-exposed hazardous operation. Isolated/remote experimental work, if ever approved, requires qualified controls and residual-risk assessment.

**Evidence limits:** ABB/Schneider mechanisms are DOC-CONFIRMED for their described products; IET 2026 E classifications are UK residential guidance, not a U.S. machine rule. Selected machine UNKNOWN; no numeric fault-current, stopping distance, PL/SIL, live test or independent score.
