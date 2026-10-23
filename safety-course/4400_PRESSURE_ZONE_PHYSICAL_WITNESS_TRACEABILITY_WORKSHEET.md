# Conditional pressure-zone and physical-witness evidence card

**Status:** generic selected-block qualification supplement. Use only when an accumulator/trapped volume is credible. It supplements, not replaces, the canonical eight-field `SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md` contract.

| Record / ID family | Exact installed fact and evidence | UNKNOWN / acceptance disposition |
|---|---|---|
| `BND/ENE` energy boundary | Machine mode, people, fluid/gas/gravity/other stored energy, separate source(s) | |
| `ENE/ARC` accumulator identity | Manufacturer, complete model/serial, installed manual revision, gas/fluid construction | |
| `ARC/DEP` connection map | S, P, T, M1, M2 **only if** actual product uses those labels; check valves, pilot, consumer and return | |
| `SRS/PHY` physical proposition | Stopping, holding, isolation, discharge, maintenance restraint **as distinct requirements** | |
| `AUTH` owner | Normal LinuxCNC/FPGA; diagnostics; independent safety; final element; maintenance control | |
| `DEP` instrument topology | Gauge/pressure-transducer tap; isolating cock; blocked line; calibration; power/reference | |
| `DEP/UNK` reaccumulation | Gas precharge, other pumps, thermal, gravity, leaking seals, cross-port, trapped zones | |
| `ARC/UNK` variant | M vs E, Y vs Z, optional bleed/throttle/gauge/lock/position monitor; document conflict | |
| `VAL` independent witnesses | Physically relevant pressure-zone measurement, motion/hold/restraint, separate instrument | |
| `VAL` contradiction | Valve feedback expected while independent pressure/motion witness disagrees | |
| `PT/CHG` maintenance/replacement | Port relocation, gauge replacement, accumulator or valve variant substitution invalidation | |
| `RR/UNK` operation restriction | What cannot be proved; remote/isolated-only or do-not-operate boundary | |

**Eight-field final-element linkage:** commanded action (`SRS/AUTH`), actual final element (`AUTH/ARC`), feedback target (`PHY/VAL`), legitimate proposition (`PHY/SRS/VAL`), shared dependencies (`DEP`), residual energy (`PHY/SRS/ARC`), machine physical witness (`PHY/VAL`), maintenance isolation/blocking (`SRS/AUTH/ARC/VAL`). No field is waived because a pressure gauge exists.

**Pass/fail rule:** If `VAL` physical evidence contradicts feedback or instrument reading, mark the broad `PHY` **NOT ESTABLISHED**, record `UNK/RR`, block exposed operation and qualified rearm until independently resolved. A component PL/SIL claim or a pressure indication does not establish machine safety-function integrity.
