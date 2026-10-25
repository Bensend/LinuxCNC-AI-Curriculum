# 4400-ACC-SAF-01 — 12-gate selected-machine no-energy documentary review

**Status:** BLANK / NOT RUN / NOT SCORED. Paper engineering gate, **not** a physical proof test or an instruction to operate hydraulics. Applicable **only if** the selected machine actually has an accumulator or credible trapped fluid/gas energy. Keep private machine drawings, serials and confidential as-built details out of this public repository.

| Gate | Qualified reviewer must produce | Current state |
|---|---|---|
| A — Machine identity | Selected machine, model/revision and exposed hazard boundaries; whether an accumulator is present | UNKNOWN |
| B — Exact pressure vessel | Manufacturer, complete order code, gas/fluid configuration, serial and correct OEM manual edition | UNKNOWN |
| C — Actual safety block | Complete M/E and Y/Z order code, installed manual, physical photograph and exact model diagram | UNKNOWN |
| D — Ports/valves | Verified S/P/T/M1 (if applicable), pilot/check/return/relief/bleed and isolation topology | UNKNOWN |
| E — Normal vs safety | Distinct LinuxCNC/HAL/FPGA command, independent safety logic, physical final element and LOTO authority | UNKNOWN |
| F — Power-loss/fault reaction | Exact deenergized valve state, stuck/blocked return, supply loss, replacement and monitoring failure paths | UNKNOWN |
| G — Pressure witness | Correct physical taps for every relevant trapped volume, gauge suitability, isolation cock and failure handling | UNKNOWN |
| H — Gas vessel | Separate precharge energy and qualified manufacturer-specific maintenance controls, not inferred from fluid zero | UNKNOWN |
| I — Gravity/support | Y1/Y2 or other load independently supported against unintended motion, including hydraulic holding failure | UNKNOWN |
| J — Stop/hold sequencing | If accumulator supplies protective-cycle energy, safe ordering of stop, holding, isolation and bleed justified | UNKNOWN |
| K — Human factors/LOTO | Accessible labeled isolators/bleeds, captive supports, individual worker control, service/escape, bypass pressure | UNKNOWN |
| L — Change and restart | Exact spare-part equivalence, CHG invalidation, revalidation, guard/occupancy, deliberate rearm and fresh motion | UNKNOWN |

**No-energy review protocol:** use current manufacturer documents and qualified engineering judgment to identify *which evidence* would be required; do not actuate, drain, open, charge, disassemble, bypass, or energize an actual accumulator/press during this documentary gate. A “PASS” here could only mean **documentation sufficient to plan a later separately authorized physical validation**. It cannot mean the physical safe state was reached.

**Negative discriminators:** M vs E; Y vs Z; gauge optional or relocated; fluid zero vs gas precharge; accumulator discharge vs independent gravity holding; bleed command vs actual flow; isolation vs stored-energy reaccumulation; reset vs fresh motion. Reject an answer that conflates any pair.

**Status:** A–L all UNKNOWN/NOT RUN; no independent evaluator, no measured stop/hold, no PL/SIL, no personnel-exposed operation. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD**. If minimum safe-to-operate threshold is not met, only qualified isolated/remote experimental operation with everyone outside danger zone and residual risk documented may be considered separately.
