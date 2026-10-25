# 4400-DUST-01 — No-energy 14-gate LEV / collector fire / CNC stop review
**2026-10-25 | PAPER DESIGN REVIEW ONLY | ALL SELECTED TESTS NOT RUN**

This is a pre-commissioning document, not permission to energize, fault-inject or enter a hazard zone. Read [DUST-01 original OSHA/NFPA/CSB + LinuxCNC audit](../research/4400_OSHA_NFPA660_CSB_WOOD_DUST_LEV_FIRE_VS_CNC_COOLANT_PIN_SOURCE_AUDIT_2026-10-25.md), [Donaldson CPC Rev6 / HSE original source](../research/4400_DONALDSON_POWERCORE_FILTER_DELTA_P_VENT_AND_SPRINKLER_OEM_AUDIT_2026-10-25.md), and [DUST-02 2.9/development source comparison](../research/4400_LINUXCNC_2_9_VS_DEVELOPMENT_COOLANT_REQUEST_AND_ESTOP_VERSION_BOUNDARY_2026-10-25.md).

| Gate | Desk question | Evidence to request | Status |
|---|---|---|---|
| D01 | Exact process/material and combustible-dust/exposure hazard known? | Qualified DHA/exposure assessment and applicable edition/AHJ | UNKNOWN |
| D02 | Every CNC and other machine sharing collector identified? | As-built duct/branch map and owner | UNKNOWN |
| D03 | Hood, flexible duct and dust foot physically compatible with every cut/ATC position? | As-built clearance and capture plan | UNKNOWN |
| D04 | Hood-level capture commissioned, not just fan started? | Qualified baseline tests, operating conditions and measured witness | NOT RUN |
| D05 | Fan/duct/filter/collector faults distinguishable? | Actual diagnostic scheme and failure review | UNKNOWN |
| D06 | Filter Delta-P used only within validated scope? | OEM design baseline, leakage and blocked-hood review | UNKNOWN |
| D07 | Collector location and vent discharge exclude occupied areas? | Qualified site layout and OEM vent analysis | UNKNOWN |
| D08 | Fire/deflagration propagation through shared ducts mitigated? | Qualified protection/isolation design | UNKNOWN |
| D09 | Sprinkler/other suppression adds water/structural/drainage hazards? | Structural/drainage and fire-system integration review | UNKNOWN |
| D10 | Machine E-stop protects cutter/axes without unintended shared-collector harm? | Separate safety/normal/process authority map | NOT RUN |
| D11 | Collector fire event has an approved independent response? | Qualified fire/stop/isolation functional specification | NOT RUN |
| D12 | Power return cannot restart CNC or unsafe extraction automatically? | Reset/rearm and fresh-start sequence | NOT RUN |
| D13 | Maintenance isolation includes electrical, compressed air, gravity and smoldering? | Qualified LOTO/service plan | UNKNOWN |
| D14 | Cleaning, inspection and fault recovery easier than bypass? | Operator walkthrough and bypass-risk review | NOT RUN |

### Protected future physical validation (not a command to run)
After design gates and competent sign-off, a qualified team defines nonhazardous verification of actual capture and signal integrity, then isolated/remote protected verification of each *selected* process/stop/fire response. Never create combustible dust clouds, introduce ignition sources, block vents, disable suppression or expose people to a hazardous fault as a curriculum experiment. Record as-built revisions, measured conditions, independent witness and explicit pass/fail criteria from approved design; do not invent thresholds.

### Safety authority and release
Normal LinuxCNC M7/M8/M9, `iocontrol` and FPGA may request or diagnose extraction; neither owns personnel-safety stopping or collector deflagration mitigation. Physical final elements and engineered collector fire protection must be independently allocated. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 OPEN** until relevant selected proof and external competency. No OpenPressBrake collector installation claimed.
