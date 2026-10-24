# 4400 technician card — Contactor OFF command versus physical dropout

**PAPER ONLY; no energized fault injection, no machine acceptance.** Prerequisite [original Rockwell LVSAM-RM003A-EN-P 2012 audit](../research/4400_ROCKWELL_COIL_SUPPRESSION_LONG_CABLE_FALSE_HOLD_RETROFIT_AUDIT_2026-10-24.md), OEM [original 174-page guide](https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/lvsam-rm003_-en-p.pdf) printed §§5.3.3–5.3.5. This guide is not a selected-product manual.

## Eight cases

For each: state what is **DOC-CONFIRMED**, what is **INFERENCE**, what is **UNKNOWN**, which physical final element/witness is needed and whether old `VAL/PT` becomes STALE.

| ID | Hypothetical retrofit change | Reasoning discriminator |
|---|---|---|
| CC-01 | DC contactor coil suppressor changed from varistor to ordinary diode; old stop-time evidence reused. | OEM says diode extends dropout. No universal time or safe distance; re-evaluate actual final-element timing. |
| CC-02 | AC coil fed through a very long control cable; control contact opens but coil may stay held. | Rockwell §5.3.4.2 describes cable-capacitance current in **specific AC topology**. Do not claim this for all DC coils. |
| CC-03 | A small PLC output goes OFF and HMI says safe; contactor main contacts not witnessed. | OFF logic is not a physical contact witness, much less hydraulic ram hold. |
| CC-04 | Control harness rerouted farther from panel; coil sometimes fails to pull in. | OEM §5.3.4.1 identifies voltage drop and possible contact welding concerns. Need actual coil and harness data. |
| CC-05 | Replacement safety contactor has same ampere rating but different coil electronics/suppressor. | Matching load current does not establish matching release time, EDM compatibility or supply behavior. |
| CC-06 | Two contactors are installed but both use one suspect AC control harness. | Common cause; count of devices is not independent physical fault coverage. |
| CC-07 | Mirror feedback says OPEN while an unrestrained gravity-loaded hydraulic ram can still descend. | Contactor feedback cannot establish hydraulic holding; require separate mechanical/hydraulic physical proof. |
| CC-08 | Technician adds a shunt resistor to prevent false hold without an engineering review. | OEM discusses possible mitigations in context; generic student resistor retrofit is **not authorized**. Review actual circuit with qualified designer and revalidate. |

## Output

Sketch normal command, independent safety withdrawal, actual coil and suppression, mirror feedback, physical hazardous energy and service isolator **as separate objects**. Mark which change invalidates old `VAL/PT`. Write one human-factors improvement that prevents a wrong coil/suppressor replacement while keeping proper service easy.

`CC-01..08 PAPER ONLY`, selected machine details **UNKNOWN**, no numeric stop-time/coil values inferred, no physical test or external competency score. **No personnel-exposed hazardous operation is authorized.**
