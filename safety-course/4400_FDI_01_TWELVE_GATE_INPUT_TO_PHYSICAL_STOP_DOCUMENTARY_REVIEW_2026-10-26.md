# 4400-FDI-01 — Twelve-gate no-energy selected-system documentary review

**Blank worksheet / NOT RUN.** Use only with qualified restricted selected-machine evidence. This is a **desk review**, not a live fault-injection plan or a machine release. Do not publish private drawings, serial numbers or proprietary controller parameters.

| Gate | Qualified evidence to request | Result |
| --- | --- | --- |
| 01. Boundary | Hazardous elements, exposed people, machine modes, access and independent safety SRS | UNKNOWN |
| 02. Exact equipment | Actual drive/controller part, firmware, OEM manual revision; is Siemens S210 even present? | UNKNOWN |
| 03. Input wiring | Two F-DI sources, channel polarity, wiring/test pulse, shared 24 V/0 V and bypasses | UNKNOWN |
| 04. Parameter authority | Approved selected p9650/p9651/p9652/p9658 (or selected OEM equivalents), signatures and change rights | UNKNOWN |
| 05. Initial LOW case | Selected design's safe input-release discrepancy and transition behavior | NOT RUN |
| 06. Initial HIGH case | Selected design's protective demand, SS1/STO transition and fault behavior | NOT RUN |
| 07. Final element | Physical torque/valve/contactor energy path, independent safety response and diagnostic dependencies | UNKNOWN |
| 08. Load-side safe state | Independent Y1/Y2 stop/hold, brake/load coupling and trapped hydraulic energy witnesses | NOT RUN |
| 09. Brake proof | Exact brake type, static/dynamic role, wear diagnostics, safe brake-test authority and exclusion | UNKNOWN |
| 10. Access and rearm | Guard/personnel presence, visibility, deliberate reset, stale command suppression and fresh motion | NOT RUN |
| 11. Service and rescue | Independent personal LOTO, gravity supports, pressure isolation, safe recovery/escape | UNKNOWN |
| 12. Change/release | Reviewer, evidence freshness, new drive/parameter/guard triggers, physical validation plan and residual risk | NOT RUN |

**Stop rule:** any missing critical evidence leaves **G0/G1 HOLD**. A fault LED, drive STO bit, SBC command, passing SBT or ordinary LinuxCNC state does **not** substitute for load-side physical proof. No fault injection, drive energization or personnel-exposed testing is authorized by this document. G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.

**Source provenance:** [Siemens SINUMERIK MC/S210 07/2021 §§5.1, 5.2, 9.3.2](https://cache.industry.siemens.com/dl/files/295/109801295/att_1077953/v1/S210_MC_SI_commiss_man_0721_en-US.pdf), exact variant only. Selected-machine implementation and performance UNKNOWN. **0 lab compute.**
