# 4400-RST-01 — Blank selected-machine power-return, reset and EDM witness
**2026-10-24 | BLANK / NOT RUN | Qualified restricted evidence intake only**

**Selected machine ID/revision:** UNKNOWN  
**Inspector, role, date, approved safe test plan:** NOT PROVIDED  
**As-built evidence access/classification:** NOT PROVIDED  
**Personnel-exposed operation authorized:** **NO**

| ID | Required independent proposition | Evidence ID / exact component, drawing or test | Status |
|---|---|---|---|
| RST-01 | Exact independent safety relay/PLC model, firmware, configuration signature and OEM manual revision | — | UNKNOWN |
| RST-02 | Exact E-stop/guard/ESPE wiring, reset circuit, manual/automatic mode, input fault detection | — | UNKNOWN |
| RST-03 | Safety output terminal map and downstream contactor/valve/drive final-element identity | — | UNKNOWN |
| RST-04 | Exact K1/K2 base **and auxiliary** SKU, approved front/side mounting/retention, OEM-declared main-pole mirror NC, terminal numbering, any auxiliary overlap/timing, feedback polarity/mapping, freshness and fault/recovery behavior | — | UNKNOWN |
| RST-05 | Power-loss/brownout return while pedal/normal motion request held: independent no-unexpected-start proof | — | NOT RUN |
| RST-06 | Stuck/shorted reset input and safety fault acknowledgment: no unintended motion authority | — | NOT RUN |
| RST-07 | Faulted/welded final-element detection and physical energy interruption (approved safe test method only) | — | NOT RUN |
| RST-08 | Separate safety reset, qualified area-clear verification and deliberate fresh normal cycle-start | — | NOT RUN |
| RST-09 | Independent Y1/Y2 stop, load hold, gravity restraint and hydraulic stored-energy boundaries | — | NOT RUN |
| RST-10 | Whole-body access, reset station sight line, escape and guard reinstallability | — | NOT RUN |
| RST-11 | Service LOTO/isolation and post-maintenance fresh-start/change-control process | — | NOT RUN |
| RST-12 | Physical outputs/contacts and actual machine behavior independently measured against SRS criteria | — | NOT RUN |

**Do not fill this from a generic OEM diagram or from a normal LinuxCNC/FPGA status screen.** A qualified tester must derive acceptance criteria from the actual hazard analysis and selected hardware, maintain safe remote/isolation boundaries, and preserve raw witness evidence. Never stage a dangerous live welded-contactor or stuck-valve condition with people exposed. Do not publish private drawings in the public curriculum.

**Release decision:** G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No numeric stopping distance, hydraulic pressure, diagnostic coverage or PL/SIL inferred. If minimum safe-to-operate threshold is unproven, do not operate with people exposed.
