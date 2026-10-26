# 4400-HYD-LOX-01 — A lockable hydraulic bleed valve can conflict with gravity-load retention
**Original manufacturer-source investigation | 2026-10-26 | PAPER ONLY / NON-GRADUATED.**

## Primary manufacturer evidence
ROSS Controls, *Hydraulic Lockout Valve — Manual L-O-X*, https://www.rosscontrols.com/en/series/3133-hydraulic-lockout-valve (direct manufacturer page inspected 2026-10-26), especially Product Overview, FAQ and Installation & Maintenance Guidelines. Exact ROSS product only; **not** known installed on OpenPressBrake.

**DOC-CONFIRMED:** ROSS describes a four-way **manual** isolation valve: OFF blocks downstream supply, **T1** bleeds downstream fluid to tank, and **T2** separately bypasses running pump flow to tank. The handle is lockable only in OFF; optional **Port A** pressure indication provides a witness for that port/zone. Manufacturer explicitly says it is **not an automated safety shutoff**. ROSS warns that a downstream check that blocks the T1 drain can prevent full downstream depressurization. The OEM stresses accessible lockable controls and visible pressure verification.

## Two conflicting safety objectives
A gravity-loaded ram may need a **closed actuator-side holding path** to prevent descent when power disappears, yet maintenance needs **verified release of hazardous trapped pressure**. An upstream Port A zero reading does not prove pressure beyond a check valve is zero. Conversely, bleeding the load-supporting chamber without positive mechanical support could permit gravity descent. This is a conditional **INFERENCE**, not a measured behavior.

**Do not treat the OEM's T1 warning as permission to remove a load-holding valve from a press.** The qualified designer must preserve independent mechanical support, isolate every actual pressure zone and document a controlled no-person-exposure maintenance/rescue state. ROSS L-O-X is a manual LOTO device, not a substitute for risk-derived protective stopping, load holding or deliberate rearm.

## Adversarial documentary cases
| Question | Required proof, not assumption |
|---|---|
| Does OFF isolate every pressure zone? | Actual downstream topology, check/pilot/accumulator paths and gauges |
| Could Port A read zero while cylinder pressure remains? | Physical zone mapping and qualified independent measurement |
| Could T1 discharge cause ram descent? | Load-bearing chamber path and positive restraint |
| Is T2 pump bypass present/needed? | Actual pump shutdown/bypass design; no guessed circuit |
| Can each worker lock OFF safely? | Reachable handle, personal LOTO, visible status and verification |
| Does lock removal restart the machine? | Independent reset, clear-zone witness and deliberate local start |

## Evidence and limits
**DOC-CONFIRMED:** exact ROSS T1/T2/Port A/OFF-only/manual function. **INFERENCE:** conflict of hold and bleed, risk-reducing architecture. **SOURCE-CONFIRMED new LinuxCNC none; TEST-CONFIRMED none; COMMUNITY-REPORTED none. UNKNOWN:** actual OpenPressBrake valve/cylinder/pressure/PL/SIL and physical validation. No line opening, live bleed, hose break, ram-drop or personnel-exposed test authorized. **G0/G1 HOLD.**

Cross-reference [Parker holding/trapped pressure](4400_PARKER_HAS_LOAD_HOLD_CODE_N_MANUAL_RELEASE_PO_CHECK_AND_TRAPPED_PRESSURE_OEM_AUDIT_2026-10-26.md) and [Bosch hydraulic STO](4400_BOSCH_REXROTH_STOM_HYDRAULIC_STO_SDE_SLS_VS_RAM_HOLD_OEM_SCOPE_AUDIT_2026-10-26.md).